---
layout: default
---

<p class="header">
    <img src="/images/icon_128x128.png"
        srcset="/images/icon_128x128.png, /images/icon_128x128@2x.png 2x"
        width="128"
        height="128" />
    <div class="appname">{{ site.title }}</div>
    <div class="tagline">{{ site.description }}</div>
    <div class="actions">
        <a href="https://apps.apple.com/us/app/symbolic-by-jason-morley/id6477066265">
            <img src="/images/appstore-badge.svg" alt="Download on the App Store" style="width: 180px; vertical-align: middle; object-fit: contain;" />
        </a>
    </div>
</p>

<div class="showcase">
    <div class="content">
        {% include picture.html light="/images/screenshot-default@2x.png" dark="/images/screenshot-default-dark@2x.png" %}
    </div>
</div>
