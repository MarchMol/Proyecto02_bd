import tkinter as tk
from tkinter import ttk, messagebox
from src import db

class RestaurantManagementApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('Sistema de Gestión del Restaurante')
        self.geometry('1000x400')  

        self.style = ttk.Style(self)
        self.style.theme_use('clam')  # Tema visual para los widgets ttk

        self.tab_control = ttk.Notebook(self)
        self.create_order_tab()
        self.create_kitchen_tab()
        self.create_bar_tab()
        self.create_facturas_tab()
        self.create_reports_tab()
        self.tab_control.pack(expand=1, fill='both')

    def create_order_tab(self):   
        # Fución muestra la ventana adicional para agregar nuevo elemento de comida
        def foodSelection(bill_info):  
            # Funció valida si los valores ingresados son correctos para e ingresa los elementos de comida    
            def validateFoodSelection():
                try:
                    if(food_combox.get()!= '' and int(entry_quantity.get())>0):
                        print("SE AGREGA EL ELEMENTO")
                        print(item_dic[food_combox.get()])
                        print(bill_info[0][0])
                        for i in range(int(entry_quantity.get())):
                            db.insertOrder(bill_info[0][0],item_dic[food_combox.get()])
                        foodSelectionWindow.destroy()
                        table_selection(bill_info[0][1])
                        
                    else:
                        error_label.grid(row=2, column=0, padx=10, pady=5)
                except:
                    error_label.grid(row=2, column=0, padx=10, pady=5)
                        
            # Ventana para agregar comida
            foodSelectionWindow = tk.Tk()
            foodSelectionWindow.title("Elección de Alimentos")
            
            # Titulo y Combobox para los elementos de comida
            tk.Label(foodSelectionWindow, text="Lista de Alimentos").grid(row=0, column=0, padx=10, pady=5, sticky=tk.E)
    
            items = db.fetchMenu()
            item_names = []
            item_dic = {}
            for item in items:
                item_names.append(item[0]) # Lista con los nombres de los alimentos
                item_dic[item[0]] = item[1] # Diccionario con nombres e ids
            
            food_combox = ttk.Combobox(foodSelectionWindow, values=item_names)
            food_combox.grid(row=0, column=1,padx=10, pady=10)
            
            # Titulo y Entry para la cantidad de elementos
            tk.Label(foodSelectionWindow, text="Cantidad").grid(row=1, column=0, padx=10, pady=5, sticky=tk.E)
            entry_quantity = tk.Entry(foodSelectionWindow)  
            entry_quantity.grid(row=1, column=1, padx=10, pady=5)
            
            # Label de error, solo se muestra si se ingresaron datos invalidos
            error_label = tk.Label(foodSelectionWindow, text="Datos Inválidos",foreground="red")
            
            #Boton para agregar comida
            tk.Button(foodSelectionWindow, text="Agregar", command=lambda: validateFoodSelection()).grid(row=3, column=1, padx=10, pady=5)
            
            # Loop
            foodSelectionWindow.mainloop()
        
        # Función principal, se ejecuta al escoger una mesa
        def table_selection(selected_option):
            print(selected_option)
            if(selected_option!='' and len(db.fetch_bills(selected_option))>0):
                a = db.fetch_bills(selected_option)
                print(a)
                state.config(text="Mesa Ocupada")
                details.config(text="Cuenta Abierta: "+str((a[0][0])))
                details.grid(row=1, column=1, padx=10, pady=10, sticky="w")
                btn_open_bill.grid_forget()
                btn_add_item.grid(row=2, column=0, padx=10, pady=5, sticky="e")
                btn_close_bill.grid(row=2, column=1, padx=10, pady=5, sticky="e")
                orderIterator(db.fetchOrders(a[0][0]))   
            else:
                treeviewDeleter()      
                state.config(text="Mesa Libre")
                btn_open_bill.grid(row=1, column=1, padx=10, pady=10,sticky="w")
                details.grid_forget()
                btn_add_item.grid_forget()
                btn_close_bill.grid_forget()
        
        # Función borra todos los elementos del treeview para cuando se necesita mostrar diferentes datos
        def treeviewDeleter():
            for i in treeview_orders.get_children():
                treeview_orders.delete(i)
        
        # Función itera para enseñar todos los elementos asociados a la cuenta
        def orderIterator(order):   
            treeviewDeleter()         
            for item in order:
                treeview_orders.insert('', 'end', values=item)
            
        # Obtiene el numero de registros y lo convierte en el formato de las id de Cuentas
        def formatCuentaId(num):
            num+=1
            if(num<10):
                rslt = 'C00'+str(num)
            elif(num<100):
                rslt = 'C0'+str(num)
            else:
                rslt = 'C'+str(num)
            return rslt
        
        # Función para abrir cuenta nueva
        def open_bill(selected_table):
            bill = formatCuentaId(db.nextBill()[0])
            result = messagebox.askquestion("Confirmación", "¿Desea abrir una cuenta nueva? \n\nLa cuenta "+bill +" se asociara con\nla mesa "+selected_table)
            if result == "yes":
                print("User clicked Yes")
                db.create_new_bill(bill, selected_table)
                table_selection(selected_table)
            else:
                print("No pasa nada si dice que no :)")
                
        # Frame
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Pedidos')
        ttk.Label(tab, text='Gestión de Pedidos', font=('Helvetica', 18, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        # Se obtienen las mesas
        tables = db.fetch_tables()
        
        # Combobox para escoger la mesa
        ttk.Label(form_frame, text="Número de Mesa:").grid(row=0, column=0, padx=10, pady=5, sticky='e')
        table_number_combox = ttk.Combobox(form_frame, values=tables)
        table_number_combox.grid(row=0, column=1, padx=10, pady=5, sticky='w')
        table_number_combox.bind("<<ComboboxSelected>>", lambda _ : table_selection(table_number_combox.get()))

        # Estado de la mesa (ocupada o libre)
        state = ttk.Label(form_frame, text="")
        state.grid(row=1, column=0, padx=10, pady=5, sticky="e")
        
        # Dice por que cuenta esta ocupada la mesa
        details = ttk.Label(form_frame, text="")
        details.grid(row=1, column=1, padx=10, pady=5, sticky="w")
        
        # Boton para abrir cuenta nueva
        btn_open_bill = tk.Button(form_frame, text="Abrir Cuenta", command=lambda: open_bill(table_number_combox.get()))
        btn_open_bill.grid_forget()
        
        # Boton para agregar item de comida
        btn_add_item = tk.Button(form_frame, text="Agregar Alimento", command=lambda: foodSelection(db.fetch_bills(table_number_combox.get())))
        
        # Boton para cerrar cuenta
        btn_close_bill = tk.Button(form_frame, text="Cerrar Cuenta", command=lambda: print("TODO Aabrir cuenta"))
        
        # Treeview para visualizar elementos agregados a la cuenta
        treeview_orders= ttk.Treeview(tab, columns=('Nombre', 'Precio', 'Hora'), show='headings')
        treeview_orders.heading('Nombre', text='Nombre')
        treeview_orders.heading('Precio', text='Precio')
        treeview_orders.heading('Hora', text='Hora')
        treeview_orders.pack(pady=5, expand=True)


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
    # Create the main "Reportes" tab
        reports_tab = ttk.Frame(self.tab_control)
        self.tab_control.add(reports_tab, text='Reportes')

    # Create a Notebook widget to contain individual report tabs
        reports_notebook = ttk.Notebook(reports_tab)
        reports_notebook.pack(expand=1, fill='both')

        # Define the reports and their corresponding functions
        reports = {
            "Platos Más Pedidos": self.create_platos_mas_pedidos_tab,
            "Horarios de Pedidos": self.create_horarios_pedidos_tab,
            "Tiempos de Comida": self.create_tiempos_comida_tab,
            "Quejas por Persona": self.create_quejas_persona_tab,
            "Quejas por Plato": self.create_quejas_plato_tab,
            "Eficiencia de Meseros": self.create_eficiencia_meseros_tab
        }
    
    # Iterate over each report and create a tab for it
        for report_name, create_tab_function in reports.items():
            report_tab = ttk.Frame(reports_notebook)
            reports_notebook.add(report_tab, text=report_name)
        
            # Call the corresponding function to create the report tab
            create_tab_function(report_tab)
    
            
    def add_to_order(self, table_entry, dish_combobox, quantity_entry):
        # Placeholder para lógica de adición al pedido
        print(f"Pedido agregado: Mesa {table_entry.get()}, Plato {dish_combobox.get()}, Cantidad {quantity_entry.get()}")

    def create_platos_mas_pedidos_tab(self, tab):
        ttk.Label(tab, text='Reporte de los platos más pedidos por los clientes', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Fecha inicial:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        fecha_inicial = ttk.Entry(form_frame)
        fecha_inicial.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Fecha final:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        fecha_final = ttk.Entry(form_frame)
        fecha_final.grid(row=1, column=1, padx=10, pady=10, sticky='w')
    
        # Function to generate the report
        def generate_report():
            # Get the start and end dates from the entry fields
            start_date = fecha_inicial.get()
            end_date = fecha_final.get()
        
            # Call the function from the database and populate the treeview
            report_data = db.PlatosMasPedidos(start_date, end_date)
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R1.get_children():
                    self.treeview_R1.delete(item)
            
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R1.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.grid(row=2, columnspan=2, pady=20)

        # Create the treeview widget to display report data
        self.treeview_R1 = ttk.Treeview(tab, columns=('alimentos', 'pedidos'), show='headings')
        self.treeview_R1.heading('alimentos', text='Alimentos')
        self.treeview_R1.heading('pedidos', text='Cantidad de Pedidos')
        self.treeview_R1.pack(fill='x', expand=True)
        
        
    
    def create_horarios_pedidos_tab(self, tab):
        ttk.Label(tab, text='Horario en el que se ingresan más pedidos', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Fecha inicial:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        fecha_inicial = ttk.Entry(form_frame)
        fecha_inicial.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Fecha final:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        fecha_final = ttk.Entry(form_frame)
        fecha_final.grid(row=1, column=1, padx=10, pady=10, sticky='w')
    
        # Function to generate the report
        def generate_report():
            # Get the start and end dates from the entry fields
            start_date = fecha_inicial.get()
            end_date = fecha_final.get()
        
            # Call the function from the database and populate the treeview
            report_data = db.HorariosMasPedidos(start_date, end_date)
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R2.get_children():
                    self.treeview_R2.delete(item)
            
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R2.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.grid(row=2, columnspan=2, pady=20)

        # Create the treeview widget to display report data
        self.treeview_R2 = ttk.Treeview(tab, columns=('horario', 'pedidos'), show='headings')
        self.treeview_R2.heading('horario', text='Horario')
        self.treeview_R2.heading('pedidos', text='Cantidad de Pedidos')
        self.treeview_R2.pack(fill='x', expand=True)
    
    def create_tiempos_comida_tab(self, tab):
        ttk.Label(tab, text='Promedio de tiempo en que se tardan los clientes en comer', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Fecha inicial:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        fecha_inicial = ttk.Entry(form_frame)
        fecha_inicial.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Fecha final:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        fecha_final = ttk.Entry(form_frame)
        fecha_final.grid(row=1, column=1, padx=10, pady=10, sticky='w')
    
        # Function to generate the report
        def generate_report():
            # Get the start and end dates from the entry fields
            start_date = fecha_inicial.get()
            end_date = fecha_final.get()
        
            # Call the function from the database and populate the treeview
            report_data = db.TiempoPromedio(start_date, end_date)
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R3.get_children():
                    self.treeview_R3.delete(item)
            
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R3.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.grid(row=2, columnspan=2, pady=20)

        # Create the treeview widget to display report data
        self.treeview_R3 = ttk.Treeview(tab, columns=('personas', 'tiempo'), show='headings')
        self.treeview_R3.heading('personas', text='Cantidad de Personas')
        self.treeview_R3.heading('tiempo', text='Tiempo Promedio')
        self.treeview_R3.pack(fill='x', expand=True)
    
    def create_quejas_persona_tab(self, tab):
        ttk.Label(tab, text='Reporte de las quejas agrupadas por persona', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Fecha inicial:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        fecha_inicial = ttk.Entry(form_frame)
        fecha_inicial.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Fecha final:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        fecha_final = ttk.Entry(form_frame)
        fecha_final.grid(row=1, column=1, padx=10, pady=10, sticky='w')
    
        # Function to generate the report
        def generate_report():
            # Get the start and end dates from the entry fields
            start_date = fecha_inicial.get()
            end_date = fecha_final.get()
        
            # Call the function from the database and populate the treeview
            report_data = db.QuejasPersonas(start_date, end_date)
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R4.get_children():
                    self.treeview_R4.delete(item)
            
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R4.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.grid(row=2, columnspan=2, pady=20)

        # Create the treeview widget to display report data
        self.treeview_R4 = ttk.Treeview(tab, columns=('Persona', 'queja'), show='headings')
        self.treeview_R4.heading('Persona', text='Personas')
        self.treeview_R4.heading('queja', text='Cantidad de Quejas')
        self.treeview_R4.pack(fill='x', expand=True)
    
    def create_quejas_plato_tab(self, tab):
        ttk.Label(tab, text='Reporte de las quejas agrupadas por plato', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        ttk.Label(form_frame, text="Fecha inicial:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        fecha_inicial = ttk.Entry(form_frame)
        fecha_inicial.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Fecha final:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        fecha_final = ttk.Entry(form_frame)
        fecha_final.grid(row=1, column=1, padx=10, pady=10, sticky='w')
    
        # Function to generate the report
        def generate_report():
            # Get the start and end dates from the entry fields
            start_date = fecha_inicial.get()
            end_date = fecha_final.get()
        
            # Call the function from the database and populate the treeview
            report_data = db.QuejasporPlato(start_date, end_date)
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R5.get_children():
                    self.treeview_R5.delete(item)
            
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R5.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.grid(row=2, columnspan=2, pady=20)

        # Create the treeview widget to display report data
        self.treeview_R5 = ttk.Treeview(tab, columns=('plato', 'quejas'), show='headings')
        self.treeview_R5.heading('plato', text='Platos')
        self.treeview_R5.heading('quejas', text='Cantidad de Quejas')
        self.treeview_R5.pack(fill='x', expand=True)
    
    def create_eficiencia_meseros_tab(self, tab):
        ttk.Label(tab, text='Reporte de eficiencia de meseros (6 últimos meses)', font=('Helvetica', 16, 'bold')).pack(pady=20)
        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        # Function to generate the report
        def generate_report():
            # Call the function from the database and populate the treeview
            report_data = db.Eficiencia()
            if report_data:
                # Clear the existing data in the treeview
                for item in self.treeview_R6.get_children():
                    self.treeview_R6.delete(item)
        
                # Insert the new data into the treeview
                for row in report_data:
                    self.treeview_R6.insert('', 'end', values=row)

        # Button to generate the report
        generate_button = ttk.Button(form_frame, text="Generar Reporte", command=generate_report)
        generate_button.pack(pady=20)

        # Create the treeview widget to display report data
        self.treeview_R6 = ttk.Treeview(tab, columns=('año', 'mes', 'mesero', 'amabilidad_promedio', 'exactitud_promedio'), show='headings')
        self.treeview_R6.heading('año', text='Año')
        self.treeview_R6.heading('mes', text='Mes')
        self.treeview_R6.heading('mesero', text='Mesero')
        self.treeview_R6.heading('amabilidad_promedio', text='Amabilidad Promedio')
        self.treeview_R6.heading('exactitud_promedio', text='Exactitud Promedio')
        self.treeview_R6.pack(fill='x', expand=True)
    def create_facturas_tab(self):
        tab = ttk.Frame(self.tab_control)
        self.tab_control.add(tab, text='Facturas')
        ttk.Label(tab, text='Buscar Facturas', font=('Helvetica', 18, 'bold')).pack(pady=20)

        form_frame = ttk.Frame(tab, padding=(20, 10))
        form_frame.pack(pady=10, fill='x')

        # Inputs para nombre, nit y método de pago
        ttk.Label(form_frame, text="Nombre:").grid(row=0, column=0, padx=10, pady=10, sticky='e')
        nombre_entry = ttk.Entry(form_frame)
        nombre_entry.grid(row=0, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="NIT:").grid(row=1, column=0, padx=10, pady=10, sticky='e')
        nit_entry = ttk.Entry(form_frame)
        nit_entry.grid(row=1, column=1, padx=10, pady=10, sticky='w')

        ttk.Label(form_frame, text="Método de Pago:").grid(row=2, column=0, padx=10, pady=10, sticky='e')
        metodo_pago_combobox = ttk.Combobox(form_frame, values=['Efectivo', 'Tarjeta', 'Ambas'])
        metodo_pago_combobox.grid(row=2, column=1, padx=10, pady=10, sticky='w')
        metodo_pago_combobox.set('Efectivo') # Default value

        # Botón de búsqueda
        buscar_button = ttk.Button(form_frame, text="Buscar Factura", command=lambda: self.buscar_factura(nombre_entry, nit_entry, metodo_pago_combobox))
        buscar_button.grid(row=3, column=1, padx=10, pady=20, sticky='e')

        # Treeview para mostrar las facturas encontradas
        self.treeview_facturas = ttk.Treeview(tab, columns=('id_factura', 'nit', 'nombre', 'direccion', 'monto_efectivo', 'monto_tarjeta', 'monto_total', 'fecha', 'cuenta'), show='headings')
        self.treeview_facturas.heading('id_factura', text='ID Factura')
        self.treeview_facturas.heading('nit', text='NIT')
        self.treeview_facturas.heading('nombre', text='Nombre')
        self.treeview_facturas.heading('direccion', text='Dirección')
        self.treeview_facturas.heading('monto_efectivo', text='Monto Efectivo')
        self.treeview_facturas.heading('monto_tarjeta', text='Monto Tarjeta')
        self.treeview_facturas.heading('monto_total', text='Monto Total')
        self.treeview_facturas.heading('fecha', text='Fecha')
        self.treeview_facturas.heading('cuenta', text='Cuenta')

        # Configuración de las columnas para ajustar el ancho
        self.treeview_facturas.column('id_factura', width=70)
        self.treeview_facturas.column('nit', width=90)
        self.treeview_facturas.column('nombre', width=150)
        self.treeview_facturas.column('direccion', width=150)
        self.treeview_facturas.column('monto_efectivo', width=100)
        self.treeview_facturas.column('monto_tarjeta', width=100)
        self.treeview_facturas.column('monto_total', width=100)
        self.treeview_facturas.column('fecha', width=100)
        self.treeview_facturas.column('cuenta', width=80)
        # ... (configuración de las columnas del treeview)
        self.treeview_facturas.pack(fill='x', expand=True)

    def buscar_factura(self, nombre_entry, nit_entry, metodo_pago_combobox):
        nombre = nombre_entry.get()
        nit = nit_entry.get()
        metodo_pago = metodo_pago_combobox.get()

        # Limpieza previa de la tabla
        for i in self.treeview_facturas.get_children():
            self.treeview_facturas.delete(i)
        
        # Buscar las facturas con el endpoint de bd.py
        facturas = db.buscar_facturas(nombre, nit, metodo_pago)
        if facturas:
            for factura in facturas:
                factura_formateada = factura[:4] + tuple(f'Q.{m:.2f}' if isinstance(m, float) else m for m in factura[4:7]) + factura[7:]
                self.treeview_facturas.insert('', 'end', values=factura_formateada)
        else:
            messagebox.showinfo("Buscar Facturas", "No se encontraron facturas de cuentas cerradas con esos datos.")
if __name__ == "__main__":
    app = RestaurantManagementApp()
    app.mainloop()
