import matplotlib.pyplot as plt
from matplotlib.dates import AutoDateLocator

class Graph:
    def __init__(self, dates, values, location):
        self.dates = dates
        self.values = values
        self.location = location
        
    def create_graph(self,name,title,x,y):
        # Create a plot using matplotlib
        fig, ax = plt.subplots(figsize=(10, 6))
        ax.plot(self.dates, self.values, linestyle='-', color='b')

        # Use AutoDateLocator to automatically choose tick positions
        ax.xaxis.set_major_locator(AutoDateLocator())

        # Set the tick interval to increase spacing between date labels
        ax.yaxis.set_major_locator(AutoDateLocator(minticks=30))  # Adjust minticks as needed

        # Labeling and formatting
        plt.title(title)
        plt.xlabel(x)
        plt.ylabel(y)

        # Save the plot to a file (optional)
        plt.savefig('Others/'+name+'.png')

        # Show the plot
        plt.show()
