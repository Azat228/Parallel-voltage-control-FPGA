import numpy as np
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import socket
import json
import threading
import time
import traceback
import sys
num_rows = 1
nnn = 12
class MatrixManager:
    def __init__(self):
        self.matrices = []  # Store all 10x10 matrices
        self.current_matrix_index = -1  # Currently selected matrix index
    
    def add_matrix(self, matrix=None):
        if matrix is None:
            # If no matrix is provided, create a 2x10 zero matrix
            matrix = np.zeros((num_rows, 10), dtype=np.float32)
        elif matrix.shape != (num_rows, 10):
            raise ValueError("Matrix size must be 2×10.")
        
        self.matrices.append(matrix)
        self.current_matrix_index = len(self.matrices) - 1
        return self.current_matrix_index
    
    def update_matrix(self, index, matrix):
        if 0 <= index < len(self.matrices):
            self.matrices[index] = matrix
        else:
            raise IndexError("Index exceeds matrix dimensions.")
    
    def get_matrix(self, index):
        if 0 <= index < len(self.matrices):
            return self.matrices[index]
        else:
            raise IndexError("Matrix index out of bounds")
    
    def get_all_matrices(self):
        return self.matrices
    
    def get_matrix_count(self):
        return len(self.matrices)


class PynqCommunicator:
    def __init__(self, host='192.168.2.99', port=9090):
        self.host = host
        self.port = port
        self.socket = None
        self.connected = False
        self.log_callback = None
        self.connection_timeout = 5  # Connection timeout (seconds)
        self.response_timeout = 10     # Response timeout (seconds)
    
    def set_log_callback(self, callback):
        self.log_callback = callback
    
    def log(self, message):
        if self.log_callback:
            self.log_callback(message)
        else:
            print(message)
    
    def connect(self):
        try:
            self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.socket.settimeout(self.connection_timeout)  # Set connection timeout
            self.log(f"Attempting to connect to the server at {self.host}:{self.port}...")
            self.socket.connect((self.host, self.port))
            self.socket.settimeout(None)  # Restore blocking mode after connection
            self.connected = True
            self.log(f"Successfully connected to PYNQ-Z2 ({self.host}:{self.port})")
            return True
        except socket.timeout:
            self.log(f"Connection to PYNQ-Z2 timed out ({self.connection_timeout} seconds)")
            self.connected = False
            return False
        except socket.gaierror:
            self.log(f"Could not find the server address: {self.host}")
            self.connected = False
            return False
        except ConnectionRefusedError:
            self.log(f"Connection refused: {self.host}:{self.port} (Server may not be running or port is incorrect)")
            self.connected = False
            return False
        except Exception as e:
            error_type = e.__class__.__name__
            self.log(f"Failed to connect to PYNQ-Z2 [{error_type}]: {str(e)}")
            self.connected = False
            return False
    
    def disconnect(self):
        if self.socket:
            try:
                self.socket.close()
                self.log("Socket connection closed")
            except Exception as e:
                self.log(f"Error closing socket: {str(e)}")
        self.connected = False
        self.log("Disconnected from PYNQ-Z2")
    
    def send_matrix(self, matrix):
        if not self.connected:
            self.log("Error: Not connected to PYNQ-Z2")
            return False, "Not connected to PYNQ-Z2"
        
        try:
            # Convert NumPy matrix to list and serialize to JSON
            self.log("Preparing to send matrix data...")
            matrix_list = matrix.tolist()
            data = {
                'type': 'matrix',
                'data': matrix_list
            }
            json_data = json.dumps(data).encode('utf-8')
            
            # Send data length
            length = len(json_data)
            self.log(f"Total data length to send: {length} bytes")
            try:
                self.socket.sendall(length.to_bytes(4, byteorder='big'))
            except (ConnectionError, BrokenPipeError) as e:
                return False, f"Failed to send data length: Connection lost ({str(e)})"
            except Exception as e:
                return False, f"Failed to send data length: {str(e)}"
            
            # Send actual data
            try:
                self.socket.sendall(json_data)
                self.log("Matrix data sent, waiting for response...")
            except (ConnectionError, BrokenPipeError) as e:
                return False, f"Failed to send matrix data: Connection lost ({str(e)})"
            except Exception as e:
                return False, f"Failed to send matrix data: {str(e)}"
            
            # Improved response receiving logic
            self.socket.settimeout(self.response_timeout)  # Set receive timeout
            
            response_data = b''
            try:
                # Attempt to receive response
                start_time = time.time()
                while True:
                    try:
                        chunk = self.socket.recv(1024)
                        if not chunk:
                            if not response_data:
                                return False, "Server closed connection without response"
                            break
                        
                        response_data += chunk
                        self.log(f"Received {len(response_data)} bytes of response")
                        
                        # Check if more data is waiting to be received
                        try:
                            # Use non-blocking check for more data
                            self.socket.settimeout(0.1)
                            if not self.socket.recv(1, socket.MSG_PEEK):
                                break
                        except (socket.timeout, BlockingIOError):
                            # No more data
                            break
                        
                        # Prevent infinite loop
                        if time.time() - start_time > 10:  # 10 second total timeout
                            return False, "Response timeout (loop exceeded 10 seconds)"
                    
                    except ConnectionResetError:
                        return False, "Connection reset, server may have closed"
                    except ConnectionAbortedError:
                        return False, "Connection aborted, network may be unstable"
                
            except socket.timeout:
                # Timeout, but may have received partial data
                if not response_data:
                    return False, f"Response timeout ({self.response_timeout} seconds)"
                else:
                    self.log(f"Timeout occurred but received partial response: {len(response_data)} bytes")
            except Exception as e:
                return False, f"Error receiving response: {str(e)} ({e.__class__.__name__})"
            finally:
                # Reset to no timeout
                try:
                    self.socket.settimeout(None)
                except Exception:
                    pass  # Ignore timeout setting errors
            
            # Decode response
            try:
                response = response_data.decode('utf-8')
                self.log(f"PYNQ-Z2 response: {response}")
                if response.startswith("ERROR"):
                    return False, f"PYNQ-Z2 returned error: {response}"
                return True, response
            except UnicodeDecodeError:
                hex_data = response_data.hex()
                preview = hex_data[:50] + "..." if len(hex_data) > 50 else hex_data
                return False, f"Unable to decode response (not UTF-8 text): {preview}"
        
        except Exception as e:
            error_type = e.__class__.__name__
            error_details = str(e)
            self.log(f"Failed to send matrix [{error_type}]: {error_details}")
            # Get detailed stack trace
            exc_info = sys.exc_info()
            stack_trace = ''.join(traceback.format_exception(*exc_info))
            self.log(f"Exception stack trace:\n{stack_trace}")
            return False, f"Error sending matrix [{error_type}]: {error_details}"


class MatrixProcessorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("PYNQ-Z2 Matrix Processing GUI")
        self.root.geometry("1200x800")
        
        self.matrix_manager = MatrixManager()
        self.pynq_comm = PynqCommunicator()
        self.pynq_comm.set_log_callback(self.log)
        
        self.create_ui()
        
        # Add first empty matrix
        self.add_new_matrix()
        
        # Add window close handler
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
    
    def create_ui(self):
        # Create main frame
        main_frame = ttk.Frame(self.root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Top connection area
        conn_frame = ttk.LabelFrame(main_frame, text="PYNQ-Z2 Connection")
        conn_frame.pack(fill=tk.X, pady=(0, 10))
        
        ttk.Label(conn_frame, text="IP Address:").grid(row=0, column=0, padx=5, pady=5)
        self.ip_entry = ttk.Entry(conn_frame, width=15)
        self.ip_entry.insert(0, "192.168.2.99")
        self.ip_entry.grid(row=0, column=1, padx=5, pady=5)
        
        ttk.Label(conn_frame, text="Port:").grid(row=0, column=2, padx=5, pady=5)
        self.port_entry = ttk.Entry(conn_frame, width=6)
        self.port_entry.insert(0, "9090")
        self.port_entry.grid(row=0, column=3, padx=5, pady=5)
        
        self.connect_btn = ttk.Button(conn_frame, text="Connect", command=self.connect_to_pynq)
        self.connect_btn.grid(row=0, column=4, padx=5, pady=5)
        
        self.disconnect_btn = ttk.Button(conn_frame, text="Disconnect", command=self.disconnect_from_pynq, state=tk.DISABLED)
        self.disconnect_btn.grid(row=0, column=5, padx=5, pady=5)
        
        self.conn_status = ttk.Label(conn_frame, text="Disconnected", foreground="red")
        self.conn_status.grid(row=0, column=6, padx=5, pady=5)
        
        # Middle workspace
        work_frame = ttk.Frame(main_frame)
        work_frame.pack(fill=tk.BOTH, expand=True)
        
        # Left matrix list
        list_frame = ttk.LabelFrame(work_frame, text="Matrix List")
        list_frame.pack(side=tk.LEFT, fill=tk.Y, padx=(0, 10))
        
        self.matrix_list = tk.Listbox(list_frame, width=20, height=20)
        self.matrix_list.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.matrix_list.bind("<<ListboxSelect>>", self.on_matrix_selected)
        
        list_btn_frame = ttk.Frame(list_frame)
        list_btn_frame.pack(fill=tk.X, padx=5, pady=5)
        
        self.add_btn = ttk.Button(list_btn_frame, text="Add Matrix", command=self.add_new_matrix)
        self.add_btn.pack(side=tk.LEFT, padx=2)
        
        self.delete_btn = ttk.Button(list_btn_frame, text="Delete Matrix", command=self.delete_matrix)
        self.delete_btn.pack(side=tk.LEFT, padx=2)
        
        # Right matrix edit and log area
        right_frame = ttk.Frame(work_frame)
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)
        
        # Matrix edit area
        edit_frame = ttk.LabelFrame(right_frame, text="Matrix Editor")
        edit_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        matrix_frame = ttk.Frame(edit_frame)
        matrix_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Create 10x10 grid of entry widgets for matrix editing
        self.matrix_entries = []
        for i in range(num_rows):
            row_entries = []
            for j in range(10):
                entry = ttk.Entry(matrix_frame, width=5)
                entry.grid(row=i, column=j, padx=2, pady=2)
                row_entries.append(entry)
            self.matrix_entries.append(row_entries)
        
        button_frame = ttk.Frame(edit_frame)
        button_frame.pack(fill=tk.X, padx=10, pady=(0, 10))
        
        self.save_btn = ttk.Button(button_frame, text="Save Changes", command=self.save_matrix)
        self.save_btn.pack(side=tk.LEFT, padx=5)
        
        self.send_btn = ttk.Button(button_frame, text="Send to PYNQ-Z2", command=self.send_matrix_to_pynq)
        self.send_btn.pack(side=tk.LEFT, padx=5)
        
        self.random_btn = ttk.Button(button_frame, text="Random Fill", command=self.fill_random)
        self.random_btn.pack(side=tk.LEFT, padx=5)
        
        self.zero_btn = ttk.Button(button_frame, text="Clear", command=self.fill_zeros)
        self.zero_btn.pack(side=tk.LEFT, padx=5)
        
        # Log area
        log_frame = ttk.LabelFrame(right_frame, text="Communication Log")
        log_frame.pack(fill=tk.BOTH, expand=True)
        
        self.log_text = scrolledtext.ScrolledText(log_frame, height=8)
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        self.log_text.config(state=tk.DISABLED)
        
        # Log operation buttons
        log_btn_frame = ttk.Frame(log_frame)
        log_btn_frame.pack(fill=tk.X, padx=10, pady=(0, 10))
        
        self.clear_log_btn = ttk.Button(log_btn_frame, text="Clear Log", command=self.clear_log)
        self.clear_log_btn.pack(side=tk.LEFT, padx=5)
    
    def log(self, message):
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, f"[{time.strftime('%H:%M:%S')}] {message}\n")
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)
    
    def clear_log(self):
        self.log_text.config(state=tk.NORMAL)
        self.log_text.delete(1.0, tk.END)
        self.log_text.config(state=tk.DISABLED)
        self.log("Log cleared")
    
    def connect_to_pynq(self):
        host = self.ip_entry.get().strip()
        try:
            port = int(self.port_entry.get().strip())
            if port <= 0 or port > 65535:
                raise ValueError("Port must be between 1-65535")
        except ValueError as e:
            messagebox.showerror("Error", f"Invalid port setting: {str(e)}")
            return
        
        self.pynq_comm.host = host
        self.pynq_comm.port = port
        
        # Disable connect button to prevent multiple clicks
        self.connect_btn.config(state=tk.DISABLED)
        self.conn_status.config(text="Connecting...", foreground="blue")
        
        # Use thread for connection to avoid UI freeze
        def connect_thread():
            if self.pynq_comm.connect():
                self.root.after(0, lambda: self.connect_btn.config(state=tk.DISABLED))
                self.root.after(0, lambda: self.disconnect_btn.config(state=tk.NORMAL))
                self.root.after(0, lambda: self.conn_status.config(text="Connected", foreground="green"))
            else:
                self.root.after(0, lambda: self.connect_btn.config(state=tk.NORMAL))
                self.root.after(0, lambda: self.conn_status.config(text="Connection failed", foreground="red"))
                self.root.after(0, lambda: messagebox.showerror("Connection Failed", f"Could not connect to {host}:{port}, please check network and PYNQ-Z2 status"))
        
        threading.Thread(target=connect_thread, daemon=True).start()
    
    def disconnect_from_pynq(self):
        self.pynq_comm.disconnect()
        self.connect_btn.config(state=tk.NORMAL)
        self.disconnect_btn.config(state=tk.DISABLED)
        self.conn_status.config(text="Disconnected", foreground="red")
    
    def add_new_matrix(self):
        idx = self.matrix_manager.add_matrix()
        self.matrix_list.insert(tk.END, f"Matrix #{idx+1}")
        self.matrix_list.selection_clear(0, tk.END)
        self.matrix_list.selection_set(idx)
        self.display_matrix(idx)
        self.log(f"Added new matrix #{idx+1}")
    
    def delete_matrix(self):
        if self.matrix_manager.get_matrix_count() <= 1:
            messagebox.showinfo("Notice", "At least one matrix must remain")
            return
        
        selected = self.matrix_list.curselection()
        if not selected:
            return
        
        idx = selected[0]
        # Remove from list
        self.matrix_list.delete(idx)
        # Remove from manager
        matrices = self.matrix_manager.get_all_matrices()
        del matrices[idx]
        
        # Update list labels
        self.matrix_list.delete(0, tk.END)
        for i in range(len(matrices)):
            self.matrix_list.insert(tk.END, f"Matrix #{i+1}")
        
        # Select a new matrix
        new_idx = min(idx, len(matrices)-1)
        self.matrix_list.selection_set(new_idx)
        self.matrix_manager.current_matrix_index = new_idx
        self.display_matrix(new_idx)
        self.log(f"Deleted matrix #{idx+1}")
    
    def on_matrix_selected(self, event):
        selected = self.matrix_list.curselection()
        if not selected:
            return
        
        idx = selected[0]
        self.display_matrix(idx)
    
    def display_matrix(self, index):
        try:
            matrix = self.matrix_manager.get_matrix(index)
            self.matrix_manager.current_matrix_index = index
            
            # Update entry values
            for i in range(num_rows):
                for j in range(10):
                    self.matrix_entries[i][j].delete(0, tk.END)
                    self.matrix_entries[i][j].insert(0, str(matrix[i, j]))
        except IndexError:
            self.log(f"Error: Cannot display matrix with index {index}")
        except Exception as e:
            self.log(f"Error displaying matrix: {str(e)}")
    
    def save_matrix(self):
        idx = self.matrix_manager.current_matrix_index
        if idx < 0:
            return
        
        try:
            matrix = np.zeros((2, 10), dtype=np.float32)
            invalid_entries = []
            
            for i in range(num_rows):
                for j in range(10):
                    try:
                        value = float(self.matrix_entries[i][j].get())
                        matrix[i, j] = value
                    except ValueError:
                        invalid_entries.append((i+1, j+1))
            
            if invalid_entries:
                positions = ", ".join([f"[{i},{j}]" for i, j in invalid_entries])
                messagebox.showerror("Error", f"Invalid numeric values at positions: {positions}")
                return
            
            self.matrix_manager.update_matrix(idx, matrix)
            self.log(f"Successfully saved matrix #{idx+1}")
            return True
        except Exception as e:
            self.log(f"Error saving matrix: {str(e)}")
            messagebox.showerror("Save Failed", f"Error saving matrix: {str(e)}")
            return False
    
    def send_matrix_to_pynq(self):
        if not self.pynq_comm.connected:
            messagebox.showinfo("Notice", "Please connect to PYNQ-Z2 first")
            return
        
        idx = self.matrix_manager.current_matrix_index
        if idx < 0:
            return
        
        # Save current matrix first
        if not self.save_matrix():
            return
        
        # Disable send button to prevent multiple clicks
        self.send_btn.config(state=tk.DISABLED)
        
        # Use thread for sending to avoid UI freeze
        def send_thread():
            try:
                # Send to PYNQ-Z2
                matrix = self.matrix_manager.get_matrix(idx)
                self.log(f"Starting to send matrix #{idx+1} to PYNQ-Z2...")
                
                # Get matrix info for debugging
                matrix_info = f"Matrix size: {matrix.shape}, type: {matrix.dtype}"
                non_zero = np.count_nonzero(matrix)
                total = matrix.size
                self.log(f"Matrix info: {matrix_info}, non-zero elements: {non_zero}/{total}")
                
                # Show 3x3 preview for debugging
                preview = matrix[:3, :3]
                self.log(f"Matrix preview (top-left 3x3):\n{preview}")
                
                success, message = self.pynq_comm.send_matrix(matrix)
                
                if success:
                    self.root.after(0, lambda: self.log(f"Successfully sent matrix #{idx+1} to PYNQ-Z2"))
                    self.root.after(0, lambda: messagebox.showinfo("Send Successful", f"Matrix #{idx+1} successfully sent to PYNQ-Z2"))
                else:
                    self.root.after(0, lambda: self.log(f"Failed to send matrix #{idx+1} to PYNQ-Z2"))
                    self.root.after(0, lambda: self.log(f"Error details: {message}"))
                    self.root.after(0, lambda: messagebox.showerror("Send Failed", 
                                                                f"Could not send matrix to PYNQ-Z2:\n{message}"))
                    
                    # Try to reconnect
                    if "Connection lost" in message or "Connection reset" in message or "Connection aborted" in message:
                        self.root.after(0, lambda: self.log("Detected connection issue, attempting to reconnect..."))
                        self.root.after(500, self.try_reconnect)
            except Exception as e:
                error_msg = f"Unhandled exception during send: {str(e)}"
                self.root.after(0, lambda: self.log(error_msg))
                self.root.after(0, lambda: messagebox.showerror("Send Error", error_msg))
                
                # Get detailed stack trace
                exc_info = sys.exc_info()
                stack_trace = ''.join(traceback.format_exception(*exc_info))
                self.root.after(0, lambda: self.log(f"Exception stack trace:\n{stack_trace}"))
            finally:
                # Restore send button
                self.root.after(0, lambda: self.send_btn.config(state=tk.NORMAL))
        
        threading.Thread(target=send_thread, daemon=True).start()
    
    def try_reconnect(self):
        """Attempt to reconnect to PYNQ-Z2"""
        if self.pynq_comm.connected:
            self.pynq_comm.disconnect()
            self.connect_btn.config(state=tk.NORMAL)
            self.disconnect_btn.config(state=tk.DISABLED)
            self.conn_status.config(text="Disconnected", foreground="red")
        
        # Wait 1 second before reconnecting
        self.log("Waiting 1 second before attempting reconnect...")
        
        def delayed_reconnect():
            host = self.ip_entry.get().strip()
            try:
                port = int(self.port_entry.get().strip())
            except ValueError:
                return
            
            self.pynq_comm.host = host
            self.pynq_comm.port = port
            self.conn_status.config(text="Reconnecting...", foreground="blue")
            
            if self.pynq_comm.connect():
                self.connect_btn.config(state=tk.DISABLED)
                self.disconnect_btn.config(state=tk.NORMAL)
                self.conn_status.config(text="Connected", foreground="green")
                self.log("Reconnect successful")
            else:
                self.connect_btn.config(state=tk.NORMAL)
                self.conn_status.config(text="Reconnect failed", foreground="red")
                self.log("Reconnect failed")
        
        self.root.after(1000, delayed_reconnect)
    
    def fill_random(self):
        for i in range(num_rows):
            for j in range(10):
                random_value = np.random.randint(0, 100)
                self.matrix_entries[i][j].delete(0, tk.END)
                self.matrix_entries[i][j].insert(0, str(random_value))
        self.log("Matrix filled with random values")
    
    def fill_zeros(self):
        for i in range(num_rows):
            for j in range(10):
                self.matrix_entries[i][j].delete(0, tk.END)
                self.matrix_entries[i][j].insert(0, "0")
        self.log("Matrix cleared to zeros")
    
    def on_closing(self):
        """Cleanup when window closes"""
        if self.pynq_comm.connected:
            self.log("Disconnecting from PYNQ-Z2...")
            self.pynq_comm.disconnect()
        self.root.destroy()


def main():
    root = tk.Tk()
    app = MatrixProcessorApp(root)
    root.mainloop()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error running program: {str(e)}")
        # Show detailed stack trace
        traceback.print_exc()
    
    input("Program ended, press Enter to exit...")
