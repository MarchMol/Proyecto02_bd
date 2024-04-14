import sys
sys.path.append('\\src')

from src import db

import tkinter as tk
from tkinter import messagebox
from tkinter import ttk

def event_login(user_entry,password_entry, root):
    username = user_entry.get()
    password = password_entry.get()

    if(len(username)!= 0 and len(password)!= 0):
        try:
            if db.LogIn(username,password):
                messagebox.showinfo("Login Successful", "Main page goes here")
                root.destroy()
            else:
                messagebox.showerror("Login Failed", "Invalid username or password")
                user_entry.delete(0,tk.END)
                password_entry.delete(0,tk.END)
        except:
            print("Hubo un error iniciando sesión")


def create_login_screen():
    root_login = tk.Tk()
    root_login.title("Login Screen")
    
    label_username = tk.Label(root_login, text="Id:")
    label_username.grid(row=0, column=0, padx=10, pady=5, sticky=tk.E)
    entry_username = tk.Entry(root_login)
    entry_username.grid(row=0, column=1, padx=10, pady=5)

    label_password = tk.Label(root_login, text="Contraseña:")
    label_password.grid(row=1, column=0, padx=10, pady=5, sticky=tk.E)
    entry_password = tk.Entry(root_login, show="*")  
    entry_password.grid(row=1, column=1, padx=10, pady=5)

    button_login = tk.Button(root_login, text="Log In", command=lambda: event_login(entry_username, entry_password, root_login))
    button_login.grid(row=2, column=0, padx=10, pady=10)

    button_login = tk.Button(root_login, text="Sign In", command=lambda: create_signin_screen(root_login))
    button_login.grid(row=2, column=1, padx=10, pady=10)
    
    root_login.mainloop()
    
    
def event_signin(entry_username, entry_password, entry_name, entry_role, root_sigin):
    username = entry_username
    password = entry_password.get()
    name = entry_name.get()
    role = entry_role.get()
    print(username, password, name, role)
    if(len(password)!= 0 and len(name)!=0):
        try:
            if(db.SignIn(username, password, name, role)):
                messagebox.showinfo("Sign In Successful", "Main page goes here")
                root_sigin.destroy()
                create_login_screen()
            else:
                messagebox.showinfo("Sign In UNuccessful", "An error ocured when signing in :(")
        except:
            messagebox.showerror("Sign in Failed", "An error ocured when signing in")
            entry_password.delete(0,tk.END)
            entry_name.delete(0,tk.END)

def generateId():
    id = db.getNextId()+1
    if(id <10):
        rslt = "00"+str(id)
    elif(id<100):
        rslt = "0"+str(id)
    else:
        rslt = str(id)
    return rslt
    
def create_signin_screen(root_login):
    root_login.destroy()
    root_signin = tk.Tk()
    root_signin.title("Sign In Screen")
    
    label_username = tk.Label(root_signin, text="Id autogenerada: E"+generateId())
    label_username.grid(row=0, column=0, padx=10, pady=5, sticky=tk.E)


    label_password = tk.Label(root_signin, text="Contraseña:")
    label_password.grid(row=1, column=0, padx=10, pady=5, sticky=tk.E)
    entry_password = tk.Entry(root_signin)  
    entry_password.grid(row=1, column=1, padx=10, pady=5)
    
    label_name = tk.Label(root_signin, text="Nombre:")
    label_name.grid(row=2, column=0, padx=10, pady=5, sticky=tk.E)
    entry_name = tk.Entry(root_signin)  
    entry_name.grid(row=2, column=1, padx=10, pady=5)
    
    roles = ["MESERO", "GERENTE", "CHEF"]
    
    lable_role = tk.Label(root_signin, text="Rol:")
    lable_role.grid(row=3, column=0, padx=10, pady=5, sticky=tk.E)
    entry_role = ttk.Combobox(root_signin, values=roles)
    entry_role.grid(row=3, column=1,padx=10, pady=10)
    entry_role.set("MESERO")

    button_login = tk.Button(root_signin, text="Sign In", command=lambda: event_signin("E"+generateId(), entry_password, entry_name, entry_role, root_signin))
    button_login.grid(row=4, column=1, padx=10, pady=10)
    
    root_signin.mainloop()

    
create_login_screen()
    

    
