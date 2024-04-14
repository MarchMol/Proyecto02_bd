import tkinter as tk
from tkinter import ttk, messagebox
from src import db

class RestaurantManagementApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('Sistema de Gestión del Restaurante')
        self.geometry('800x400')  # Ajusta según la resolución deseada

        self.style = ttk.Style(self)
        self.style.theme_use('clam')  # Tema visual para los widgets ttk

        self.tab_control = ttk.Notebook(self)
        self.create_order_tab()
        self.create_kitchen_tab()
        self.create_bar_tab()
        self.create_reports_tab()
        self.tab_control.pack(expand=1, fill='both')

    def create_order_tab(self):
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Pedidos')

        ttk.Label(tab, text='Gestión de Pedidos', font=('Helvetica', 18, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Número de Mesa:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        table_number_entry = ttk.Entry(form_frame)
        table_number_entry.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Plato/Bebida:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        dish_combobox = ttk.Combobox(form_frame)
        dish_combobox.grid(row=1, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Cantidad:").grid(row=2, column=0, padx=10, pady=10, sticky='e')
        quantity_entry = ttk.Entry(form_frame)
        quantity_entry.grid(row=2, column=1, padx=10, pady=10, sticky='w')

        ttk.Button(form_frame, text="Agregar al Pedido", command=lambda: self.add_to_order(table_number_entry, dish_combobox, quantity_entry)).grid(row=3, column=1, padx=10, pady=20, sticky='e')

    def create_kitchen_tab(self):
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Cocina')
        ttk.Label(tab, text='Pedidos en Cocina', font=('Helvetica', 18, 'bold')).pack(pady=20)
        
        # Crear el Treeview widget
        self.treeview_kitchen = ttk.Treeview(tab, columns=( 'nombre', 'tiempo'), show='headings')
        self.treeview_kitchen.heading('nombre', text='Nombre')
        self.treeview_kitchen.heading('tiempo', text='Tiempo')
        self.treeview_kitchen.pack(fill='x', expand=True)
        
        ttk.Button(tab, text="Actualizar Lista", command=self.update_kitchen_orders).pack(pady=10)
        self.update_kitchen_orders()  # Cargar inicialmente los pedidos

    def create_bar_tab(self):
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Bar')
        ttk.Label(tab, text='Pedidos en Bar', font=('Helvetica', 18, 'bold')).pack(pady=20)
        
        # Crear el Treeview widget
        self.treeview_bar = ttk.Treeview(tab, columns=('nombre', 'tiempo'), show='headings')
        self.treeview_bar.heading('nombre', text='Nombre')
        self.treeview_bar.heading('tiempo', text='Tiempo')
        self.treeview_bar.pack(fill='x', expand=True)
        
        ttk.Button(tab, text="Actualizar Lista", command=self.update_bar_orders).pack(pady=10)
        self.update_bar_orders()  # Cargar inicialmente los pedidos

    def update_kitchen_orders(self):
        # Primero limpiamos la tabla
        for i in self.treeview_kitchen.get_children():
            self.treeview_kitchen.delete(i)
        
        # Suponemos que fetch_kitchen_orders devuelve una lista de tuplas
        orders = db.fetch_kitchen_orders() 
        for order in orders:
            self.treeview_kitchen.insert('', 'end', values=order)

    def update_bar_orders(self):
        # Primero limpiamos la tabla
        for i in self.treeview_bar.get_children():
            self.treeview_bar.delete(i)
        
        # Suponemos que fetch_bar_orders devuelve una lista de tuplas
        orders = db.fetch_bar_orders()  
        for order in orders:
            self.treeview_bar.insert('', 'end', values=order)


    def create_reports_tab(self):
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Reportes')

        ttk.Label(tab, text='Generar y Visualizar Reportes', font=('Helvetica', 18, 'bold')).pack(pady=20)
        ttk.Button(tab, text="Reporte de Platos Más Pedidos", command=self.report_most_ordered).pack(pady=10)
        ttk.Button(tab, text="Reporte de Horarios de Pedidos", command=self.report_order_times).pack(pady=10)
        ttk.Button(tab, text="Reporte de Tiempos de Comida", command=self.report_meal_times).pack(pady=10)
        ttk.Button(tab, text="Reporte de Quejas", command=self.report_complaints).pack(pady=10)

    def add_to_order(self, table_entry, dish_combobox, quantity_entry):
        # Placeholder para lógica de adición al pedido
        print(f"Pedido agregado: Mesa {table_entry.get()}, Plato {dish_combobox.get()}, Cantidad {quantity_entry.get()}")

    def report_most_ordered(self):
        messagebox.showinfo("Reporte", "Los platos más ordenados son...")

    def report_order_times(self):
        messagebox.showinfo("Reporte", "Horarios de mayor pedido...")

    def report_meal_times(self):
        messagebox.showinfo("Reporte", "Promedio de tiempos de comida...")

    def report_complaints(self):
        messagebox.showinfo("Reporte", "Detalles de las quejas recibidas...")

if __name__ == "__main__":
    app = RestaurantManagementApp()
    app.mainloop()
