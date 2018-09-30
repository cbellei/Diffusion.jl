import matplotlib.pyplot as plt
import pandas as pd
from matplotlib import rc

rc('font',**{'family':'arial','sans-serif':['Helvetica'],'size':18})

# fname = "src/reference_8x4_output.dat"
fname = "src/output.dat"
dataJulia = pd.read_csv(fname, sep='\t', header=None).values[0]
print(len(dataJulia))

nx = 256
ny = 256

dataJulia = dataJulia.reshape(nx + 2, ny + 2)
plt.imshow(dataJulia, interpolation='none', vmin=-10.0, vmax=10.0)
cbar = plt.colorbar()
plt.tight_layout()
plt.savefig("initial_state.png", format='png')
plt.show()