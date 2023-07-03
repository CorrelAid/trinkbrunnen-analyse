#!/usr/bin/env python
# coding: utf-8

# # Karte Trinkbrunnen Deutschland
# 
# * * *

# # Imports

# In[1]:


import overpy
import folium
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# # Config

# In[2]:


amenity = 'drinking_water'


# In[3]:


api = overpy.Overpass()


# # Data Germany

# In[4]:


area = 'Deutschland'


# In[5]:


get_ipython().run_cell_magic('time', '', 'r_ger = api.query(f"""\n                  area[name="{area}"];\n                  node["amenity"="{amenity}"](area);\n                  out meta;\n                  """)\n')


# # Map

# In[7]:


X = np.array([(float(node.lon), float(node.lat)) for node in r_ger.nodes])
coord_df = pd.DataFrame({'lat': [lat[0] for lat in X],
                         'lon': [lon[1] for lon in X],
                         'label': [f"""{d.tags.get('description')}, 
                                   access: {d.tags.get('access')}, 
                                   bottle: {d.tags.get('bottle')}, 
                                   wheelchair: {d.tags.get('wheelchair')}""" 
                                   for d in r_ger.nodes],
                        'access': [d.tags.get('access') for d in r_ger.nodes],
                        'bottle': [d.tags.get('bottle') for d in r_ger.nodes],
                        'wheelchair': [d.tags.get('wheelchair') for d in r_ger.nodes]})


# Determine quality of nodes

# In[8]:


coord_df.access = np.where(coord_df.access.isna(), 0, 1)
coord_df.bottle = np.where(coord_df.bottle.isna(), 0, 1)
coord_df.wheelchair = np.where(coord_df.wheelchair.isna(), 0, 1)
coord_df['quality'] = (coord_df.access + coord_df.bottle + coord_df.wheelchair) / 3

conds = [coord_df.quality == 1, coord_df.quality.between(0.3, 0.7), coord_df.quality < 0.3]
choose = ['green', 'yellow', 'red']

coord_df['quality_c'] = np.select(conds, choose)


# In[ ]:


m = folium.Map(location=[52, 13], tiles='cartodbpositron', zoom_start=6)
for i in range(0,len(coord_df)):
    folium.Circle(
    location=[coord_df.iloc[i]['lon'], coord_df.iloc[i]['lat']],
    popup=coord_df.iloc[i]['label'],
    color=coord_df.iloc[i]['quality_c'],
    fill=True,
    opacity= 0.89,
    stroke= True,
    weight= 1
    ).add_to(m)
m.save(f'../docs/{area.lower()}-{amenity.replace("_", "-")}.html')

m

