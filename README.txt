CHILLRX-2 — DEPLOYMENT PACKAGE
================================

WHAT THIS IS
------------
A correctly-structured, upload-ready version of the ChillRx Delray site for
Vercel (project: chill-rx, root directory already set to "chillrx-2").

Upload the CONTENTS of this folder so the repo looks like:

  chillrx-2/
  ├── index.html
  ├── hyperbaric-oxygen-therapy.html
  ├── whole-body-cryotherapy.html
  └── images/
      ├── (9 .jpg images)
      └── hero-video.mp4

STATUS
------
HOMEPAGE (index.html):  ✅ FULLY WORKING.
  - All CSS is inline. All 9 images + hero video load from images/.
  - Image extensions corrected to .jpg (they were JPEGs mislabeled .png).
  - Nothing else required. Upload and it renders perfectly.

SUBPAGES (hyperbaric-oxygen-therapy.html, whole-body-cryotherapy.html):
  ⚠️ INCLUDED but NOT yet self-contained.
  - Their relative paths were corrected for this flat structure
    (../assets/ -> assets/, ../index.html -> index.html).
  - They have NO inline styles — they need a stylesheet and logos that
    were NOT part of the original upload:
        assets/site.css
        assets/logo_light.png
        assets/logo_slate.png
  - They also link to pages from the larger chillrx.net build that are
    not in this deployment (locations/, resources/, services/,
    privacy-policy, terms-of-use). Those links will 404 here.

TO FINISH THE SUBPAGES, EITHER:
  (A) Drop in assets/site.css + the two logos from your full chillrx.net
      build (create an assets/ folder inside chillrx-2/), and add the
      missing scaffold pages; OR
  (B) Have them rebuilt as self-contained, on-brand single pages (same
      inline-CSS system as index.html) so they deploy with no extra files.

NOTE
----
The orphan file 1781464552499_image (a stray screenshot, unreferenced by
any page) was intentionally excluded.
