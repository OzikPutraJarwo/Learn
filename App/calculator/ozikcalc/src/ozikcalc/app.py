import toga
from toga.style import Pack
from toga.style.pack import COLUMN, ROW

class Calculator(toga.App):

    def startup(self):
        self.main_window = toga.MainWindow(title=self.formal_name)
        
        # Container for layout
        box = toga.Box(style=Pack(direction=COLUMN, padding=10))

        # Display widget
        self.result = toga.TextInput(readonly=True, style=Pack(flex=1))

        # Create a grid of buttons
        grid = [
            ['7', '8', '9', '/'],
            ['4', '5', '6', '*'],
            ['1', '2', '3', '-'],
            ['0', '.', '=', '+']
        ]

        # Create a box for each row of buttons
        for row in grid:
            row_box = toga.Box(style=Pack(direction=ROW))
            for label in row:
                button = toga.Button(label, on_press=self.on_button_press, style=Pack(flex=1, padding=5))
                row_box.add(button)
            box.add(row_box)

        box.add(self.result)
        self.main_window.content = box
        self.main_window.show()

    def on_button_press(self, widget):
        if widget.label == '=':
            try:
                self.result.value = str(eval(self.result.value))
            except:
                self.result.value = 'Error'
        else:
            if self.result.value == 'Error':
                self.result.value = ''
            self.result.value += widget.label

def main():
    return Calculator()

if __name__ == '__main__':
    main().main_loop()