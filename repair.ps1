$file = "potato-twister.html"
$content = [System.IO.File]::ReadAllText("$pwd\$file", [System.Text.Encoding]::UTF8)

$pattern = '(?s)<!-- Urgency & Social Proof -->.*?<!-- Pricing Card -->'
$replacement = @"
<!-- Urgency & Social Proof -->
            <div class="space-y-2">
              <h1 class="text-4xl md:text-5xl font-black text-brand-brown pt-1">
                Potato Twister Stall
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
            </div>

            <p class="text-stone-600 text-lg leading-relaxed max-w-xl">
              Our crispy potato twister stall adds a sizzling, savory twist to parties and events with freshly spiral-cut potatoes 
              fried to golden perfection. Seasoned with a variety of flavorful spices and sauces, it's a hot favorite
               for snack lovers across all age groups. Prepared live with strict hygienic practices and handled by trained staff 
               for a delicious, street-style experience.
            </p>

            <div>
              <h3 class="text-brand-blue font-bold tracking-widest uppercase text-sm mb-3">
                Best For
              </h3>
              <ul class="list-disc pl-5 space-y-2 text-stone-700">
                <li>Mall Activations & Brand Promotions</li>
                <li>Night Markets & Flea Events</li>
                <li>Concerts & Youth Festivals</li>
                <li>Open-Air Parties & Rooftop Events</li>
              </ul>
            </div>

            <!-- Pricing Card -->
"@

$content = [regex]::Replace($content, $pattern, $replacement)
[System.IO.File]::WriteAllText("$pwd\$file", $content, [System.Text.Encoding]::UTF8)
Write-Host "Repaired!"
