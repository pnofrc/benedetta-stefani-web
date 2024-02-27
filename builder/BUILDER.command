#!/usr/bin/env python3

import os
import json
import subprocess

subprocess.call(['sh', './compress.sh']) 

contents_json = '../contents.json'

with open(contents_json) as contents_data:
    data = json.load(contents_data)


html = '''
<!DOCTYPE html>

<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Benedetta Stefani</title>
        <meta name="description" content="Benedetta Stefani Portfolio">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="main.css">
        <link
            rel="stylesheet"
            href="swiper/swiper-bundle.min.css"
            />

        <script src="swiper/swiper-bundle.min.js"></script>

    </head>
    <body>

    <a onclick="toggleInfo()" id="burger">Benedetta Stefani</a>
        
    <div id="info">
        <p>for inquires</p>
        <p><a href="mailto:benedetta.stefanife@gmail.com">benedetta.stefanife@gmail.com</a></p>
        <p><a href="https://www.instagram.com/stefani.maledetta/" target="_blank">@stefani.maledetta</a></p>
    </div>
    
    <div id="description"></div>
'''


mainGallery = ''
subGalleries = ''

for content in data:

    slug = str(content)
    name = data[content]['name']
    description = data[content]['description']

    mainPics = data[content]['mainPics']

    folder = './data/' + data[content]['folder']

    if mainPics:
        for mainPic in mainPics:
            mainGallery += f'<div class="swiper-slide"><img data-slug="{slug}" data-name="{name}" data-description="{description}" onmouseover="changeDescription(`{str(slug)}`,`{str(name)}`,`{str(description)}`)" onclick="openSubGallery(`{str(slug)}`)" src="{folder}/{mainPic}"></div>\n'

    pics = os.listdir('../website/'+folder)

    if pics:
        subGalleries += f'<div class="subGallery" id="{slug}">\n'
                
        for pic in pics:
            subGalleries += f'  <img loading="lazy" src="{folder}/compressed/{pic}_compressed.jpg">\n'

        subGalleries += '</div>\n '


html += f'''<div id="mainGallery" class="swiper">
                <div class="swiper-wrapper">{mainGallery}</div>
                
                <div class="swiper-button-prev" onclick=getDataProject()></div>
                <div class="swiper-button-next" onclick=getDataProject()></div>\n
            </div>'''

html += subGalleries
html += '''


     <script src="script.js" async defer></script>

    </body>
</html>

'''
# print(html)

with open('../website/index.html', mode="w", encoding="utf-8") as results:
    results.write(html)


    