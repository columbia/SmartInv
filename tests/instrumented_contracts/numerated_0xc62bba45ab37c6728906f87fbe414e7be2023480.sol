1 /*
2  * @title Mixin contract which supports different payment channels and provides analytical per-channel data.
3  * @author Eenae
4  */
5 contract InvestmentAnalytics {
6 function iaInvestedBy(address investor) external payable;
7 }
8 
9 /*
10  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
11  * @author Eenae
12  */
13 contract AnalyticProxy {
14 
15     function AnalyticProxy() {
16         m_analytics = InvestmentAnalytics(msg.sender);
17     }
18 
19     /// @notice forward payment to analytics-capable contract
20     function() payable {
21         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
22     }
23 
24     InvestmentAnalytics public m_analytics;
25 }