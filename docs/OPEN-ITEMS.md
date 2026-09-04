# OPEN-ITEMS.md

Everything not done: bugs, unfinished work, decisions waiting on the
owner, and landmines. Each item says whether it was **verified** or is
**carried forward unchecked**, because the difference matters when you
are deciding what to trust.

Read `AGENTS.md` first. Last reviewed **2026-09-04**.

---

## 1. The nightly iOS reinstall cannot install to a locked device

**Verified**, from `/tmp/yahwehs-world-ios-reinstall.log` for the
2026-09-04 04:40 run.

Both iOS devices failed. The build itself succeeded and the macOS leg
succeeded; only the two `devicectl install` steps failed:

```
kAMDMobileImageMounterDeviceLocked: The device is locked.
Failed to mount /Library/Developer/DeveloperDiskImages/iOS_DDI/...
```

The developer disk image cannot be mounted on a locked iPhone or iPad.
The job fires at 04:40, when both devices are locked and will stay
locked, so **the iOS half of this job is expected to fail every night**
— it is not a transient WiFi problem. The macOS leg is unaffected,
which is why `/Applications` is current at 1.2.6 while the phones are
not.

The script reports this as `(asleep, off WiFi, or unpaired)`, which is
wrong and sent an earlier investigation down the wrong path. That
message has been corrected to name the locked-device case.

**Not decided:** what to do about it. The options, none free:

- run `tools/yahwehs-world-ios-reinstall.sh` by hand while holding an
  unlocked device — reliable, but manual every 7 days;
- move the job to a time the owner is normally awake and the device
  unlocked, accepting it will still miss some nights;
- accept macOS-only automation and treat iOS as manual.

This needs the owner's call. Until then the phones drift.

## 2. Verse quality has never been fairly assessed

**Carried forward unchecked.**

The owner's original complaint — verses "not really related" — was
answered with a real fix (the model now reads a 700-char body excerpt
and must justify the pick in a `whyRelated` field, and the corpus grew
to 159 verses). But every subsequent look at output was taken while the
majority of stories were on **keyword fallback**, meaning the deep-match
prompt was not what produced them. Judging the prompt from those
editions was meaningless.

As of 2026-09-04 coverage is 111/111. This is the first honest
opportunity to evaluate. If verses still miss, the lever is the prompt
in `aiDeepMatch` and the corpus, **not** quota or cadence.

## 3. The GitHub release is two versions behind

**Verified** — `gh release list` shows `v1.2.4` as latest against
`pubspec.yaml` 1.2.6.

The portal's download buttons all point at `releases/latest`. Anyone
downloading the Android APK, macOS or iOS build today gets 1.2.4:
pre-blue-theme, and without the Dart-side section ordering for the
Creation and Documentary desks. They would still see those desks, since
the filter chips come from the feed.

Closing it means building four artifacts and `gh release create v1.2.6`.

## 4. `yswords-data/README.md` overstates the API-key advice

**Verified** by reading the file against `gh secret list`.

The README says adding a key is "the highest-value lever on deep-match
coverage" and cites the ~58-calls/day measurement. That was written
mid-debugging and the evidence since contradicts its emphasis: a second
key was never added, and coverage reached 100% on one key once the model
chain and cadence were fixed. The measurement is accurate; the
recommendation built on it is stale.

## 5. Two source feeds contribute little

**Verified** at 2026-08-25, **not re-checked since**.

- `BBC Entertainment & Arts` matched **0** items against the
  `documentary`/`docuseries` keyword filter in the run it was tested in.
  It was kept because arts coverage does carry documentaries
  periodically, but it has never been observed contributing.
- `Nature` is a weekly journal in a pipeline that sizes desks by
  same-day supply. It was the original reason `science` carries a
  `maxItems: 26` override. Whether it still surfaces is unverified.

Neither is a bug. Both are worth a look if the desks feel thin.

## 6. Unused UI strings

**Verified** by grep.

`ui_strings.dart` defines `sectionWorld` … `sectionDocumentary`, but
only `sectionAll` is referenced anywhere in `lib/`. Chip labels come
from the feed's `categoryLabel`. The entries were kept for symmetry when
the two new desks were added.

Harmless, but do not assume editing them changes anything on screen.

## 7. `yswords-data/README.md` step 4 still cites the old corpus size

**Verified.** It says "149 curated verses across 24 topical categories";
the file holds **159**. Cosmetic, but this project treats a stale
document as worse than no document.
