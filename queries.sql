# PORTFOLIO VALUE AND PROFIT/LOSS ANALYSIS
SELECT 
    u.name,
    p.portfolio_name,
    s.symbol,

    SUM(
        CASE 
            WHEN t.transaction_type='BUY' 
            THEN t.quantity 
            ELSE -t.quantity 
        END
    ) AS total_quantity,

    SUM(
        CASE 
            WHEN t.transaction_type='BUY'
            THEN t.quantity*t.price
            ELSE -t.quantity*t.price
        END
    ) AS invested_amount,

    sp.close_price,

    (
      SUM(
        CASE 
          WHEN t.transaction_type='BUY'
          THEN t.quantity
          ELSE -t.quantity
        END
      ) * sp.close_price
    ) AS current_value

FROM users u
JOIN portfolios p
ON u.user_id=p.user_id

JOIN transactions t
ON p.portfolio_id=t.portfolio_id

JOIN stocks s
ON t.stock_id=s.stock_id

JOIN stock_prices sp
ON s.stock_id=sp.stock_id

GROUP BY 
u.name,p.portfolio_name,s.symbol,sp.close_price;


# FOR TOP PERFORMING STOCKS
SELECT 
    s.symbol,
    s.company_name,

    MIN(sp.close_price) AS lowest_price,
    MAX(sp.close_price) AS highest_price,

    ROUND(
    ((MAX(sp.close_price)-MIN(sp.close_price))
    /MIN(sp.close_price))*100,2
    ) AS growth_percentage

FROM stocks s

JOIN stock_prices sp
ON s.stock_id=sp.stock_id

GROUP BY s.symbol,s.company_name

ORDER BY growth_percentage DESC;

# USER INVESTMENT SUMMARY DASHBOARD
SELECT

u.name,

COUNT(DISTINCT p.portfolio_id)
AS total_portfolios,

COUNT(t.transaction_id)
AS total_transactions,

SUM(
CASE 
WHEN t.transaction_type='BUY'
THEN t.quantity*t.price
END
)
AS total_investment

FROM users u

JOIN portfolios p
ON u.user_id=p.user_id

JOIN transactions t
ON p.portfolio_id=t.portfolio_id

GROUP BY u.name;

# TO FIND OUT MOST TRADED STOCKS
SELECT

s.symbol,

SUM(t.quantity) AS total_volume,

COUNT(*) AS trade_count

FROM transactions t

JOIN stocks s
ON t.stock_id=s.stock_id

GROUP BY s.symbol

ORDER BY total_volume DESC;

# PORTFOLIO DIVERSIFICATION ANALYSIS
SELECT

p.portfolio_name,

s.sector,

COUNT(*) AS holdings

FROM portfolios p

JOIN transactions t
ON p.portfolio_id=t.portfolio_id

JOIN stocks s
ON t.stock_id=s.stock_id

GROUP BY 
p.portfolio_name,
s.sector;

# STOCK TREND ANALYSIS USING MOVING AVERAGES
SELECT

s.symbol,
sp.price_date,
sp.close_price,

AVG(sp.close_price)
OVER(
PARTITION BY s.symbol
ORDER BY sp.price_date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)
AS moving_average_7_days

FROM stock_prices sp

JOIN stocks s
ON sp.stock_id=s.stock_id;