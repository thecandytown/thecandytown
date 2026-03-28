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
    "tangy-maggie.html",
    "waffle-stall.html"
]

def capitalize_title(filename):
    base = filename.replace('.html', '').replace('-stall', '')
    return ' '.join(word.capitalize() for word in base.split('-'))

for filename in files:
    if not os.path.exists(filename):
        print(f"File {filename} not found.")
        continue
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Update title block
    title_regex = re.compile(
        r'(<h1 class="text-4xl md:text-5xl font-black text-brand-brown">\s*(.+?)\s*</h1>)',
        re.DOTALL
    )
    def title_replace(match):
        title_text = match.group(2).strip()
        return f"""<!-- Urgency & Social Proof -->
            <div class="space-y-2">
              <span class="inline-flex items-center gap-1.5 px-3 py-1 pb-1.5 rounded-full bg-red-100 text-red-600 font-bold text-xs uppercase tracking-widest border border-red-200 shadow-sm animate-pulse">
                <span>🔥</span> Trending - High Demand
              </span>
              
              <h1 class="text-4xl md:text-5xl font-black text-brand-brown pt-1">
                {title_text}
              </h1>
              
              <div class="flex items-center gap-1 text-yellow-500 pt-1">
                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                <span class="text-stone-500 text-xs font-bold tracking-wide uppercase ml-2 mt-0.5">
                  (4.9/5 Average Rating)
                </span>
              </div>
            </div>"""

    if '🔥' not in content:
        content = title_regex.sub(title_replace, content, count=1)

    # 2. Update Pricing Card
    pricing_regex = re.compile(
        r'(<div\s+class="bg-brand-pink/30 p-5 md:p-6 rounded-2xl shadow-lg space-y-4 max-w-sm border border-brand-blue/20"\s*>)\s*(<p.*?<span class="text-brand-blue">(.*?)</span>.*?</p>)\s*<a\s+href="index\.html#contact"\s+class="inline-block px-8 py-3 bg-brand-brown text-white rounded-full font-bold uppercase tracking-widest text-xs hover:-translate-y-0.5 hover:shadow-xl transition"\s*>\s*Get a Quote\s*</a>\s*(<p class="text-xs text-stone-500">.*?</p>)\s*</div>',
        re.DOTALL
    )

    def pricing_replace(match):
        price = match.group(3).strip()
        return f"""<div
              class="bg-brand-pink/30 p-5 md:p-6 rounded-2xl shadow-lg space-y-5 max-w-sm border border-brand-blue/20 relative overflow-hidden"
            >
              <!-- Decorative background element -->
              <div class="absolute -top-12 -right-12 w-32 h-32 bg-brand-blue/10 rounded-full blur-2xl"></div>

              <p class="text-xl md:text-2xl font-black text-brand-brown relative z-10">
                Stalls starting from
                <span class="text-brand-blue block mt-1 text-3xl">{price}</span>
              </p>

              <a
                href="index.html#contact"
                class="group inline-flex items-center justify-center gap-2 w-full px-8 py-3.5 bg-brand-brown text-white rounded-full font-black uppercase tracking-widest text-sm hover:-translate-y-1 hover:shadow-2xl transition-all duration-300 relative z-10 animate-pulse"
              >
                Get a Quote
                <i data-lucide="arrow-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform"></i>
              </a>

              <p class="text-[10px] uppercase font-bold tracking-widest text-stone-400 relative z-10 pt-1">
                *Pricing varies based on guest count and city.
              </p>

              <!-- Trust Badges -->
              <div class="grid grid-cols-3 gap-2 pt-4 border-t border-brand-blue/10 relative z-10">
                <div class="flex flex-col items-center text-center space-y-1">
                  <div class="w-8 h-8 rounded-full bg-white shadow-sm border border-brand-blue/30 flex items-center justify-center text-brand-blue">
                    <i data-lucide="award" class="w-4 h-4"></i>
                  </div>
                  <span class="text-[9px] font-bold text-brand-brown uppercase tracking-tight leading-tight">Premium Quality</span>
                </div>
                <div class="flex flex-col items-center text-center space-y-1">
                  <div class="w-8 h-8 rounded-full bg-white shadow-sm border border-brand-blue/30 flex items-center justify-center text-brand-blue">
                    <i data-lucide="sparkles" class="w-4 h-4"></i>
                  </div>
                  <span class="text-[9px] font-bold text-brand-brown uppercase tracking-tight leading-tight">100% Hygienic</span>
                </div>
                <div class="flex flex-col items-center text-center space-y-1">
                  <div class="w-8 h-8 rounded-full bg-white shadow-sm border border-brand-blue/30 flex items-center justify-center text-brand-blue">
                    <i data-lucide="chef-hat" class="w-4 h-4"></i>
                  </div>
                  <span class="text-[9px] font-bold text-brand-brown uppercase tracking-tight leading-tight">Trained Staff</span>
                </div>
              </div>
            </div>"""

    if 'Premium Quality' not in content:
        content = pricing_regex.sub(pricing_replace, content, count=1)

    # 3. Add Mobile Sticky CTA Bar
    footer_regex = re.compile(r'(</footer>)(.*?)(</body>)', re.DOTALL)
    
    price_match = re.search(r'<span class="text-brand-blue block mt-1 text-3xl">(₹[0-9,]+/-)</span>', content)
    if not price_match:
        price_match = re.search(r'<span class="text-brand-blue">(₹[0-9,]+/-)</span>', content)
    price_str = price_match.group(1) if price_match else "₹4,999/-"
    
    display_title = capitalize_title(filename)

    def footer_replace(match):
        return f"""</footer>

    <!-- Mobile Sticky CTA Bar -->
    <div class="md:hidden fixed bottom-0 inset-x-0 z-40 bg-white border-t border-brand-blue/20 shadow-[0_-10px_40px_rgba(0,0,0,0.1)] p-4 flex items-center justify-between pb-6">
      <div class="flex flex-col">
        <span class="text-[10px] font-black uppercase text-stone-400 tracking-widest">{display_title}</span>
        <span class="text-brand-blue font-black text-xl">{price_str}</span>
      </div>
      <a href="index.html#contact" class="px-6 py-3 bg-brand-brown text-white rounded-full font-black uppercase tracking-widest text-xs shadow-xl animate-pulse whitespace-nowrap">
        Book Now
      </a>
    </div>

{match.group(2)}</body>"""

    if 'Mobile Sticky CTA Bar' not in content:
        content = footer_regex.sub(footer_replace, content)

    # 4. Modify body page-fade
    content = content.replace('<body class="bg-brand-pink font-[Inter] page-fade">', '<body class="bg-brand-pink font-[Inter]">')
    content = content.replace(
        '<main class="pt-24 md:pt-32 max-w-7xl mx-auto px-6">', 
        '<main class="pt-24 md:pt-32 max-w-7xl mx-auto px-6 page-fade">'
    )

    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Updated {filename}")
