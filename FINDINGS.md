# Findings & Recommendations: Late Delivery Analysis

*Prepared by Saheed Yakubu, based on 65,752 orders (180,519 order lines), Jan 2015 – Jan 2018.*

## Executive summary

- **54.8% of all orders arrive late**, and this has not improved in three years: the monthly rate has stayed between 52% and 57% since January 2015.
- **Lateness is driven by shipping mode, not region.** Every First Class order is promised in 1 day and delivered in exactly 2, so **100% of delivered First Class orders are late**. This is a miscalibrated delivery promise, not a carrier failure. Correcting that one promise would cut the overall late rate from 57% to about 42%.
- **Lateness does not measurably reduce revenue or profit in this data.** Late orders show a slightly lower margin (11.8% vs 12.3%), but the gap is not statistically significant, and order value is fixed before shipping. The real cost of lateness is more likely lost repeat customers.
- **Profit is highly concentrated:** 8 of 50 product categories generate 85% of total profit. No category loses money overall, but about 1 in 5 order lines sells at a loss, wiping out roughly half of gross profit.

## 1. Is the late-delivery rate improving?

No. The monthly late rate has stayed between 52% and 57% in all 37 months of the data, and the 3-month rolling average stays close to 55%. There is no upward or downward trend. This is a structural, ongoing issue, not a dip tied to a specific period.

## 2. Where is lateness concentrated?

The strongest pattern in the data is **shipping mode**. The figures below exclude cancelled orders.

| Shipping mode | Promised delivery | Late orders | Avg. days over promise |
|---|---|---|---|
| First Class | 1 day | **100%** (9,602 of 9,602) | exactly 1.0 |
| Second Class | 2 days | 80% | 2.0 |
| Same Day | 0 days | 48% | 0.5 |
| Standard Class | 4 days | 40% | 0.0 |

The First Class result is the key finding. **Every single First Class order** is scheduled for 1 day and delivered in exactly 2 days, in every region, without exception. Real shipping failures are noisy: some orders are late by hours, others by days, and some regions are worse than others. A perfectly consistent one-day overrun means the **promised delivery window is set too tight**, not that the shipments are handled badly. The process reliably takes 2 days; the promise says 1.

Second Class shows a similar, weaker pattern: promised in 2 days, delivered on average 2 days later, and late 80% of the time.

**Impact:** if First Class were promised in 2 days instead of 1, all 9,602 of those orders would count as on time, and the overall late rate would fall from **57% to about 42%**, without changing anything in the warehouse or the carrier network.

## 3. Does lateness cost the business money?

Not measurably, in this data.

| | Avg. revenue/order | Avg. profit/order | Profit margin |
|---|---|---|---|
| On-time orders | $505.13 | $62.06 | 12.3% |
| Late orders | $501.62 | $59.37 | 11.8% |

Late orders bring in slightly less profit ($2.70 less per order), but this gap is **not statistically significant** (t ≈ −1.8, p ≈ 0.08). The revenue difference ($3.50 per order) is even smaller and also not significant. More importantly, **order value and profit are fixed when the order is placed, before anything ships**, so lateness cannot change them. A flat result here is expected, not evidence that lateness is harmless.

Where lateness does cost money is in **customer behaviour after delivery**: customers who receive a late order may not come back. Testing this needs customer-level follow-up analysis (comparing repeat purchase rates after late vs on-time first orders), which is the natural next step for this project.

## 4. Which product categories matter most?

No category loses money in total: all 50 are profitable overall. But profit is extremely concentrated. **Fishing** alone contributes 19% of total profit, and the **top 8 categories** (Fishing, Cleats, Camping & Hiking, Cardio Equipment, Women's Apparel, Water Sports, Indoor/Outdoor Games, Men's Footwear) account for **85%** of all profit. The remaining 42 categories contribute the last 15% combined.

A second, less obvious finding: **18.7% of all order lines sell at a loss.** Those lines lose $3.71M in total, against $7.51M earned on profitable lines, so they **wipe out roughly half of gross profit**.

What drives these losses is unclear, and the obvious explanation does not hold. **Discounts do not explain it:** the share of loss-making lines stays between 18% and 20% at every discount level, from 0% to 25%. It is also nearly identical across all large categories (16–20%). Real businesses rarely look this uniform, which suggests that this public dataset may be partly synthetic. The finding is reported as observed, but it should not be used to support pricing decisions without validating it on real data.

## Recommendations

1. **Change the First Class delivery promise from 1 day to 2.** The process reliably takes 2 days; the promise is the problem, not the carriers. This single change would cut the overall late rate from 57% to about 42%. Review the Second Class promise the same way.
2. **Measure the real cost of lateness through repeat purchases**, not order value. Compare how often customers order again after a late vs an on-time first order. This determines how much the business should invest in faster delivery.
3. **Focus inventory, marketing and pricing attention on the top 8 categories** that generate 85% of profit, and review whether the long tail of 42 low-contribution categories justifies its overhead.
4. **Investigate the loss-making order lines with real cost data.** Discounts do not explain them, so the next step is to check product costs, shipping costs and returns per line before acting.
5. **Look into cancelled orders separately** (4.3% of orders, lowest margin at 11.4%). The raw data also contains statuses like `SUSPECTED_FRAUD` and `PAYMENT_REVIEW`, which suggests a fraud or payment issue rather than a delivery one.

## Methodology note

The analysis was done in SQL (DuckDB) on the cleaned DataCo Smart Supply Chain dataset (`sql/01`–`05`), and presented in an interactive Power BI dashboard (`dashboard/late_delivery_dashboard.pbix`). Cancelled and suspected-fraud orders are excluded from delivery-rate and profit comparisons unless shown as their own group, since no completed sale took place. Statistical significance for the late vs on-time comparison was tested with a two-sample t-test on per-order values.

**Data limitations:** this is a public Kaggle dataset, and several patterns (identical loss rates across categories and discount levels, perfectly uniform delivery times per shipping mode) suggest it may be partly synthetic. The findings demonstrate the analytical approach; specific numbers should be validated on real operational data before business decisions are made.
