try {
    Add-Type -TypeDefinition @"
    using System;
    using System.Text.RegularExpressions;

    public class HtmlParser {
        public static string ReplaceMobileMenu(string html, string newMenu) {
            int startIndex = html.IndexOf("<div id=\"mobile-menu\"");
            if (startIndex == -1) return html;
            
            int depth = 0;
            int endIndex = -1;
            
            // This regex finds the START index of any opening or closing div tag
            Regex r = new Regex(@"<\s*\/?\s*div\b[^>]*>");
            MatchCollection matches = r.Matches(html, startIndex);
            
            foreach(Match m in matches) {
                if (m.Value.StartsWith("</")) {
                    depth--;
                } else {
                    depth++;
                }
                
                if (depth == 0) {
                    endIndex = m.Index + m.Length;
                    break;
                }
            }
            
            if (endIndex != -1) {
                return html.Substring(0, startIndex) + newMenu + html.Substring(endIndex);
            }
            return html;
        }
    }
"@
} catch {
    Write-Host "Type already added."
}

$files = Get-ChildItem -Filter *.html
foreach ($file in $files) {
    if (-not (Test-Path $file.FullName)) { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

    $newMenu = @"
    <!-- MOBILE OVERLAY MENU (CONVERSION OPTIMIZED) -->
    <div id="mobile-menu"
        class="fixed inset-0 bg-stone-50 z-[110] hidden flex-col animate-in slide-in-from-top duration-300 overflow-y-auto font-[Inter]">
        
        <!-- Sticky Header -->
        <div class="flex justify-between items-center p-5 bg-white shadow-sm sticky top-0 z-20">
            <div class="flex items-center space-x-3">
                <img src="./images/Candy_Town_Logo.png" alt="Logo" class="w-10 h-10 rounded-full shadow-md">
                <div class="flex flex-col border-l-2 border-brand-pink pl-3">
                    <span class="font-black text-[15px] text-brand-brown uppercase tracking-tighter leading-none">The Candy Town</span>
                    <span class="text-[8px] font-bold text-stone-400 uppercase tracking-widest mt-1">Make Events Sweeter</span>
                </div>
            </div>
            <button onclick="toggleMenu()"
                class="p-2 bg-stone-100 rounded-full text-brand-brown hover:bg-stone-200 transition">
                <i data-lucide="x" class="w-5 h-5"></i>
            </button>
        </div>

        <!-- Scrollable Body -->
        <div class="flex-1 p-5 space-y-6">
            
            <!-- Primary Navigation -->
            <div class="space-y-2">
                <p class="text-[10px] text-brand-blue font-black uppercase tracking-widest pl-2 mb-3">Menu</p>
                <a href="index.html#home" onclick="toggleMenu()" class="flex items-center p-3 rounded-2xl hover:bg-white transition relative overflow-hidden group">
                    <div class="absolute inset-0 bg-brand-pink/10 opacity-0 group-hover:opacity-100 transition"></div>
                    <div class="w-10 h-10 rounded-full bg-brand-brown/5 flex items-center justify-center text-brand-brown mr-4 group-hover:bg-brand-brown group-hover:text-white transition"><i data-lucide="home" class="w-5 h-5"></i></div>
                    <span class="text-lg font-black text-brand-brown">Home</span>
                    <i data-lucide="chevron-right" class="w-4 h-4 ml-auto text-stone-300"></i>
                </a>
                <a href="index.html#services" onclick="toggleMenu()" class="flex items-center p-3 rounded-2xl bg-white shadow-sm border border-brand-blue/10 hover:border-brand-blue/30 transition group">
                    <div class="w-10 h-10 rounded-full bg-brand-blue text-white flex items-center justify-center mr-4 group-hover:scale-110 transition cursor-pointer"><i data-lucide="store" class="w-5 h-5"></i></div>
                    <div class="flex flex-col">
                        <span class="text-lg font-black text-brand-brown leading-tight">All Stalls & Services</span>
                        <span class="text-[10px] text-stone-400 uppercase font-bold tracking-widest">Explore 12+ Options</span>
                    </div>
                    <i data-lucide="chevron-right" class="w-4 h-4 ml-auto text-brand-blue"></i>
                </a>
                <a href="gallery.html" onclick="toggleMenu()" class="flex items-center p-3 rounded-2xl hover:bg-white transition relative overflow-hidden group">
                    <div class="absolute inset-0 bg-brand-pink/10 opacity-0 group-hover:opacity-100 transition"></div>
                    <div class="w-10 h-10 rounded-full bg-brand-brown/5 flex items-center justify-center text-brand-brown mr-4 group-hover:bg-brand-brown group-hover:text-white transition"><i data-lucide="image" class="w-5 h-5"></i></div>
                    <span class="text-lg font-black text-brand-brown">Event Gallery</span>
                    <i data-lucide="chevron-right" class="w-4 h-4 ml-auto text-stone-300"></i>
                </a>
                <a href="index.html#about" onclick="toggleMenu()" class="flex items-center p-3 rounded-2xl hover:bg-white transition relative overflow-hidden group">
                    <div class="absolute inset-0 bg-brand-pink/10 opacity-0 group-hover:opacity-100 transition"></div>
                    <div class="w-10 h-10 rounded-full bg-brand-brown/5 flex items-center justify-center text-brand-brown mr-4 group-hover:bg-brand-brown group-hover:text-white transition"><i data-lucide="info" class="w-5 h-5"></i></div>
                    <span class="text-lg font-black text-brand-brown">About Us</span>
                    <i data-lucide="chevron-right" class="w-4 h-4 ml-auto text-stone-300"></i>
                </a>
            </div>

            <!-- Trending / High Conversion Mini-Grid -->
            <div class="space-y-3 pt-2">
                <div class="flex items-center justify-between pl-2 mb-3">
                    <p class="text-[10px] text-brand-blue font-black uppercase tracking-widest">Trending Stalls</p>
                    <span class="flex items-center gap-1 text-[9px] uppercase tracking-widest font-bold bg-red-100 text-red-600 px-2 py-1 rounded-full animate-pulse"><i data-lucide="flame" class="w-3 h-3"></i> Hot</span>
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <a href="candy-floss.html" class="bg-white p-4 rounded-2xl shadow-sm border border-brand-brown/5 flex flex-col items-center justify-center text-center gap-2 hover:-translate-y-1 transition group">
                        <div class="w-10 h-10 rounded-full bg-brand-pink/30 flex items-center justify-center group-hover:scale-110 transition">
                            <i data-lucide="cloud" class="w-5 h-5 text-pink-500"></i>
                        </div>
                        <span class="text-[11px] font-black text-brand-brown uppercase tracking-wide">Candy Floss</span>
                    </a>
                    <a href="popcorn.html" class="bg-white p-4 rounded-2xl shadow-sm border border-brand-brown/5 flex flex-col items-center justify-center text-center gap-2 hover:-translate-y-1 transition group">
                        <div class="w-10 h-10 rounded-full bg-yellow-50 flex items-center justify-center group-hover:scale-110 transition">
                            <i data-lucide="party-popper" class="w-5 h-5 text-yellow-500"></i>
                        </div>
                        <span class="text-[11px] font-black text-brand-brown uppercase tracking-wide">Popcorn</span>
                    </a>
                    <a href="chocolate-fountain.html" class="col-span-2 bg-gradient-to-r from-[#3e2723] to-[#5d4037] p-4 rounded-2xl shadow-md flex flex-row items-center justify-between hover:-translate-y-1 transition group">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center group-hover:scale-110 transition">
                                <i data-lucide="droplet" class="w-5 h-5 text-amber-200"></i>
                            </div>
                            <div class="flex flex-col text-left">
                                <span class="text-xs font-black text-white uppercase tracking-wide">Chocolate Fountain</span>
                                <span class="text-[9px] text-white/70 uppercase tracking-widest font-bold">Premium Bestseller</span>
                            </div>
                        </div>
                        <i data-lucide="chevron-right" class="w-5 h-5 text-white/50"></i>
                    </a>
                </div>
            </div>

            <!-- Social Proof / WhatsApp Block -->
            <div class="pt-2">
                <a href="https://wa.me/919867910957" target="_blank" class="bg-[#25D366]/5 rounded-2xl p-4 border border-[#25D366]/20 flex items-center justify-between group hover:bg-[#25D366]/10 transition">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-[#25D366] text-white flex items-center justify-center group-hover:scale-110 transition shadow-md">
                            <i data-lucide="message-circle" class="w-5 h-5"></i>
                        </div>
                        <div class="flex flex-col text-left">
                            <span class="font-black text-brand-brown text-sm">Chat on WhatsApp</span>
                            <span class="text-[10px] text-stone-500 font-bold">+91 9867910957</span>
                        </div>
                    </div>
                    <i data-lucide="external-link" class="w-5 h-5 text-stone-400 group-hover:text-[#25D366] transition"></i>
                </a>
            </div>
            
        </div>

        <!-- Sticky Bottom CTA -->
        <div class="p-5 bg-white border-t border-stone-200 shadow-[0_-10px_40px_rgba(0,0,0,0.05)] mt-auto sticky bottom-0 z-20">
            <a href="index.html#contact" onclick="toggleMenu()"
                class="flex items-center justify-center gap-3 w-full py-4 bg-brand-brown text-white text-center rounded-2xl font-black uppercase tracking-widest text-sm shadow-xl hover:-translate-y-1 hover:shadow-2xl transition-all relative overflow-hidden group">
                <div class="absolute inset-0 bg-white/10 w-full h-full transform -skew-x-12 -translate-x-full group-hover:animate-pulse"></div>
                <span>Get a Free Quote</span>
                <i data-lucide="arrow-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform"></i>
            </a>
            <p class="text-center text-[9px] text-stone-400 uppercase tracking-widest font-bold mt-3">We usually reply within 2 hours</p>
        </div>
    </div>
"@

    $newContent = [HtmlParser]::ReplaceMobileMenu($content, $newMenu)
    
    # We must ensure lucide re-renders icons for the new HTML string since it gets loaded at the bottom of the page usually.
    # Actually, toggleMenu() doesn't insert it, it only removes the 'hidden' class. Lucide runs on page load and parses EVERYTHING that is present in the DOM! 
    # Therefore, we do NOT need to call `lucide.createIcons()` inside toggleMenu().

    if ($newContent -ne $content) {
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated $($file.Name)"
    } else {
        Write-Host "Failed to find mobile-menu in $($file.Name)"
    }
}
