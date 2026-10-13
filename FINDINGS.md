# Findings & Recommendations: Late Delivery Analysis

*Prepared by Saheed Yakubu — based on 65,752 orders (180,519 order lines), Jan 2015 – Jan 2018.*

## Executive summary

- **54.8% of all orders arrive late**, and this has not improved over three years — it has held steady between 52% and 57% every month since January 2015.
- Lateness is **not spread evenly**: it is heavily concentrated in **First Class** and **Second Class** shipping, in every region, and looks like a *scheduling* problem rather than a *carrier performance* problem.
- Late deliveries cost **profit margin, not revenue** — customers still buy, but the company earns ~4% less profit per late order.
- Profit is **highly concentrated**: 8 of 50 product categories generate ~85% of total profit. No category loses money overall, but every category has a hidden layer (15–24% of its order lines) that sells at a loss.

## 1. Is the late-delivery rate improving?

No. The monthly late % has stayed in a narrow 52–57% band for all 37 months in the dataset, and the 3-month rolling average never strays from ~54–55%. There is no improving or worsening trend — this is a structural, ongoing issue, not a one-off dip tied to a specific period.

## 2. Where is lateness concentrated?

By far the strongest pattern in the data: **shipping mode**, not region, drives lateness.

| Shipping mode | Late % (typical, across regions) | Avg. days over schedule |
|---|---|---|
| First Class | 90–100% | ~1.00 days, almost every time |
| Second Class | 70–85% | ~2.0 days |
| Same Day | 40–50% | ~0.5 days |
| Standard Class | 30–40% | ~0.0 days |

This pattern repeats *identically* in every single region (Canada, Western Europe, Southeast Asia, etc.) — First Class is always worst, Standard Class is always best. The fact that First Class overruns its schedule by almost exactly 1.00 day, consistently, everywhere, is the key clue: this looks like the **promised delivery window is set too tight** (e.g. promising 1 day when the process reliably takes 2), rather than First Class shipments being badly handled. A real logistics failure would be noisier and more region-specific; this is too uniform.

## 3. Does lateness cost the business money?

Yes, but through margin, not sales volume:

| | Avg. revenue/order | Avg. profit/order | Profit margin |
|---|---|---|---|
| On-time orders | $505.13 | $62.06 | 12.3% |
| Late orders | $501.62 | $59.37 | 11.8% |

Revenue per order is essentially unchanged (−0.7%) — late delivery doesn't appear to shrink basket size. Profit per order drops ~4.3%, and margin drops half a point. Looking at the full delivery-status breakdown, there's a clean gradient: **Advance shipping (12.2%) ≈ On time (12.4%) > Late delivery (11.8%) > Cancelled (11.4%)**. Cancelled orders — a small 4.3% of volume — are the worst performers of all, worth a closer look on their own (the data separately flags order statuses like `SUSPECTED_FRAUD` and `PAYMENT_REVIEW`, which may be related).

## 4. Which product categories matter most?

No category loses money in total — all 50 are profitable overall. But profit is extremely concentrated: **Fishing** alone contributes 19% of total profit, and the **top 8 categories** (Fishing, Cleats, Camping & Hiking, Cardio Equipment, Women's Apparel, Water Sports, Indoor/Outdoor Games, Men's Footwear) account for **~85%** of all profit — out of 50 categories. The remaining 42 contribute the last 15% combined.

A second, less obvious finding: in *every* category, regardless of how profitable it is overall, **15–24% of individual order lines sell at a loss**. The category totals look healthy because profitable lines outweigh the losing ones, but this loss-making layer is consistent and sizeable enough to be worth investigating — discounting is the most likely driver, though this dataset doesn't let us prove that directly.

## Recommendations

1. **Audit the First Class / Second Class delivery promise, not the carriers.** The near-universal, near-identical overage (≈1 day for First Class, everywhere) points to the *scheduled* delivery window being miscalibrated rather than execution failing. Correcting the promised timeframe would likely fix the majority of the "54.8% late" headline number, since these two modes carry most of the late volume.
2. **Treat late delivery as a margin problem, not a revenue problem**, when prioritizing fixes — e.g. if the SLA fix in (1) isn't feasible quickly, consider margin-protection levers (refund caps, renegotiated carrier rates for First/Second Class) rather than demand-side fixes, since the data shows customers aren't buying less because of lateness.
3. **Double down on the top 8 categories** that drive 85% of profit for inventory, marketing, and pricing attention; evaluate whether the long tail of 42 low-contribution categories justifies its overhead, or is a candidate for rationalization.
4. **Investigate the 15–24% loss-making lines inside every category** — start by checking whether discount depth correlates with the loss, and consider a minimum-margin discount cap if so.
5. **Look into cancelled orders** (4.3% of volume, worst margin) — the presence of fraud/payment-review statuses in the raw order data suggests this may be a fraud or payment-friction issue rather than a delivery one, and would need separate data (payment detail) to confirm.

## Methodology note

Analysis was done in SQL (DuckDB) on the cleaned DataCo Smart Supply Chain dataset (`sql/01`–`05`), then rebuilt as an interactive Power BI dashboard (`dashboard/late_delivery_dashboard.pbix`) for exploration. Cancelled and suspected-fraud order lines are excluded from profit/margin comparisons unless explicitly shown as their own category, since no sale occurred on those lines.
