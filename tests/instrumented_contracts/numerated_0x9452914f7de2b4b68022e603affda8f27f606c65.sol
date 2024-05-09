1 /*
2  * @title Mixin contract which supports different payment channels and provides analytical per-channel data.
3  * @author Eenae
4  */
5 contract InvestmentAnalytics {
6     function iaInvestedBy(address investor) external payable;
7 }
8 
9 
10 /*
11  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
12  * @author Eenae
13 
14  * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface
15  */
16 contract AnalyticProxy {
17 
18     function AnalyticProxy() {
19         m_analytics = InvestmentAnalytics(msg.sender);
20     }
21 
22     /// @notice forward payment to analytics-capable contract
23     function() payable {
24         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
25     }
26 
27     InvestmentAnalytics public m_analytics;
28 }