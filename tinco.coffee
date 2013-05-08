# Cycle through colors
hue = 0
cycleColors = () ->
  setColors hsl2rgb(hue, .5, .5, 1).hex
  hue = hue + 0.005
  hue %= 1
  setTimeout cycleColors, 50

setColors = (hex) ->
  $("#header td.background").css('background-color', hex)

x = 0
y = 0
hue = 0
p = 0

# Build colors
buildColors = () ->
  buildColorsRun()
  setTimeout buildColors, 3000

buildColorsRun = () ->
  getBlock = (x,y) -> document.getElementById('header').getElementsByTagName('tr')[y].children[x]
  block = getBlock(x,y)

  if block?
    if not block.classList.contains('colored')
        block.style.backgroundColor = hsl2rgb(hue, .5,.5,1).hex
  if x - 2 >= 0
    previousBlock = getBlock(x - 2,y)
    if previousBlock? && not previousBlock.classList.contains('colored')
      previousBlock.style.backgroundColor = ''
  xx = x - 1
  yy = y + 1
  if xx >= 0 and yy < 7
    x = xx
    y = yy
  else
    x = (p += 1)
    y = 0
  hue += 0.05
  hue %= 1
  if p < 26
    setTimeout buildColorsRun, 10
  else
    p = x = y = hue = 0


# Makes the header table
makeHeader = () ->
  header =
    [
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0 ],
      [ 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0 ],
      [ 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    ]

  table = "<table>"
  for row in header
    table += "<tr>"
    for color in row
      table += "<td class=\"#{ if color is 1 then "colored" else "background"}\"></td>"
    table += "</tr>"
  table += "</table>"
  table

# Adapted from RaphaelJS
hsl2rgb = (h, s, l, o) ->
  if h > 1 or s > 1 or l > 1
    h /= 360
    s /= 100
    l /= 100

  rgb = {}
  channels = ["r", "g", "b"]
  if not s
    rgb = {
      r: l,
      g: l,
      b: l
    }
  else
    if l < .5
      t2 = l * (1 + s)
    else
      t2 = l + s - l * s

    t1 = 2 * l - t2

    for i in [0..2]
      t3 = h + 1 / 3 * -(i - 1)
      t3 += 1 if t3 < 0
      t3 -= 1 if t3 > 1
      if t3 * 6 < 1
        rgb[channels[i]] = t1 + (t2 - t1) * 6 * t3
      else if t3 * 2 < 1
        rgb[channels[i]] = t2
      else if (t3 * 3 < 2)
        rgb[channels[i]] = t1 + (t2 - t1) * (2 / 3 - t3) * 6
      else
        rgb[channels[i]] = t1

  rgb.r *= 255
  rgb.g *= 255
  rgb.b *= 255
  rgb.hex = "#" + (16777216 | rgb.b | (rgb.g << 8) | (rgb.r << 16)).toString(16).slice(1)
  rgb.opacity = o
  rgb

header = document.getElementById('header')
header.innerHTML = makeHeader()
buildColors()

