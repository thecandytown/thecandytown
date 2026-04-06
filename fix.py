import os
import re

files = [
    "bachpan-ki-yaadein.html",
    "candy-floss.html",
    "chana-jor-garam.html",
    "chocolate-fountain.html",
    "cupcakes.html",
    "french-fries.html",
    "ice-gola.html",
    "masala-sweet-corn.html",
    "popcorn.html",
    "potato-twister.html",
    "tangy-maggie.html",
    "waffle-stall.html"
]

for f in files:
    if not os.path.exists(f): continue
    with open(f, "r", encoding="utf-8") as file:
        content = file.read()
        
    # 1. Remove Mobile Back Button Below Nav
    content = re.sub(r'\s*<!-- Mobile Back Button Below Nav -->\s*<a href="index\.html"[^>]*>.*?</a>\s*', '\n\n', content, flags=re.DOTALL)

    # 2. Update layout
    gridOld = "md:grid-cols-[1.2fr_1fr] gap-16 items-start"
    gridNew = "md:grid-cols-2 gap-10 md:gap-16 items-start"
    content = content.replace(gridOld, gridNew)

    imgContainerOld = "w-full h-[280px] md:h-[420px] rounded-3xl overflow-hidden shadow-2xl -mt-3"
    imgContainerNew = "w-full aspect-square rounded-[2rem] overflow-hidden shadow-xl"
    content = content.replace(imgContainerOld, imgContainerNew)

    headingOld = "text-4xl md:text-5xl font-black text-brand-brown pt-1"
    headingNew = "text-3xl md:text-4xl lg:text-5xl font-black text-brand-brown leading-tight pt-1"
    content = content.replace(headingOld, headingNew)

    pricingCardOld = "bg-brand-pink/30 p-5 md:p-6 rounded-2xl shadow-lg space-y-5 max-w-sm border border-brand-blue/20 relative overflow-hidden"
    pricingCardNew = "bg-white p-6 md:p-8 rounded-[2rem] shadow-xl space-y-5 w-full md:max-w-md border border-brand-pink relative overflow-hidden"
    content = content.replace(pricingCardOld, pricingCardNew)

    descOld = "text-stone-600 text-lg leading-relaxed max-w-xl"
    descNew = "text-stone-600 text-base md:text-lg leading-relaxed max-w-2xl"
    content = content.replace(descOld, descNew)

    with open(f, "w", encoding="utf-8") as file:
        file.write(content)
