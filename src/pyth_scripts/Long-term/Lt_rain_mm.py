import matplotlib
# Force matplotlib to not use any Xwindows backend.
matplotlib.use('Agg')
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import csv
from matplotlib.dates import strpdate2num

# Set fontsize for plot

font = {'family' : 'monospace',
    'weight' : 'normal',
        'size'   : '10'}

matplotlib.rc('font', **font)  # pass in the font dict as kwargs

#def skip_first(seq,n):
#    for i, item in enumerate(seq):
#        if i >= n:
#            yield item
#g = open('soundTransit1_remote_rawMeasurements_15m.txt', 'w')
#with open('soundTransit1_remote_rawMeasurements_15m.dat', 'rb') as f:
#    csvreader = csv.reader(f)
#    for row in skip_first(csvreader,4):
#        for row in csv.reader(f,delimiter=',',skipinitialspace=True):
#            print >>g, "\t".join(row)
#g.close()

def readfiles(file_list,c1):
    """ read <TAB> delemited files as strings
        ignoring '# Comment' lines """
    data = []
    for fname in file_list:
        data.append(
                    np.loadtxt(fname,
                               usecols=(0,c1),
                               comments='#',    # skip comment lines
                               delimiter='\t',
                               converters = { 0 : strpdate2num('%Y-%m-%d %H:%M:%S') },
                               dtype=None))
    return data

def init_plot(title, yMin=0, yMax=13):
    plt.figure(figsize=(12, 6))  # figsize=(24, 12)
    plt.title(title + disclamers, fontsize=11)
    plt.xlabel(xtext)
    plt.ylabel(ytext)
    #plt.xlim(xMin,xMax)
    plt.ylim(yMin,yMax)
    plt.grid()
    #plt.xticks(np.arange(xMin,xMax+1))

def end_plot(name=None, cols=5):
    plt.legend(bbox_to_anchor=(0, -.15, 1, -0.5), loc=8, ncol=cols, fontsize=10,
               mode="expand", borderaxespad=-1.,  scatterpoints=1)
    if name:
        plt.savefig(name, bbox_inches='tight')

disclamers = ('\nUSGS PROVISIONAL DATA'
              '\nSUBJECT TO REVISION'
              )
xtext = ('Date & Time')
ytext = ('15-minute rainfall, mm')

data = readfiles(['waMVD116_Lt.txt'],5)

column_0 = np.array(data)[0][:,0]
rain_tipCount = np.array(data)[0][:,1]

#Compute Rainfall
rain_mm = rain_tipCount * 0.254

init_plot('Rainfall at Marine View Dr. & 116 St. SW')

plt.plot(column_0, rain_mm, linestyle='-', color='b', label='Rainfall')

plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d\n%H:%M'))
plt.gca().xaxis.set_major_locator(mdates.HourLocator())
plt.gca().xaxis.set_minor_locator(mdates.HourLocator(interval=6))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=1))

end_plot(name='MVD116_rain.png')

# ------------------------

data = readfiles(['waMLP_Lt.txt'],3)

column_0 = np.array(data)[0][:,0]
rain_tipCount = np.array(data)[0][:,1]

#Compute Rainfall
rain_mm = rain_tipCount * 0.254

init_plot('Rainfall at Mukilteo Lighthouse Park')

plt.plot(column_0, rain_mm, linestyle='-', color='b', label='Rainfall')

plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d\n%H:%M'))
plt.gca().xaxis.set_major_locator(mdates.HourLocator())
plt.gca().xaxis.set_minor_locator(mdates.HourLocator(interval=6))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=1))

end_plot(name='MLP_rain.png')

# ------------------------

data = readfiles(['waMWWD_Lt.txt'],3)

column_0 = np.array(data)[0][:,0]
rain_tipCount = np.array(data)[0][:,1]

#Compute Rainfall
rain_mm = rain_tipCount * 0.254

init_plot('Rainfall at Mukilteo Wastewater Plant')

plt.plot(column_0, rain_mm, linestyle='-', color='b', label='Rainfall')

plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d\n%H:%M'))
plt.gca().xaxis.set_major_locator(mdates.HourLocator())
plt.gca().xaxis.set_minor_locator(mdates.HourLocator(interval=6))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=1))

end_plot(name='MWWD_rain.png')

# ------------------------

data = readfiles(['waWatertonA_Lt.txt'],6)

column_0 = np.array(data)[0][:,0]
rain_tipCount = np.array(data)[0][:,1]

#Compute Rainfall
rain_mm = rain_tipCount * 0.254

init_plot('Rainfall at Waterton Circle Station A')

plt.plot(column_0, rain_mm, linestyle='-', color='b', label='Rainfall')

plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d\n%H:%M'))
plt.gca().xaxis.set_major_locator(mdates.HourLocator())
plt.gca().xaxis.set_minor_locator(mdates.HourLocator(interval=6))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=1))

end_plot(name='MWatA_rain.png')

