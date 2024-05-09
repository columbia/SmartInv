1 contract InvestmentAnalytics {
2 function iaInvestedBy(address investor) external payable;
3 }
4 
5 /*
6  * @title This is proxy for analytics. Target contract can be found at field m_analytics (see "read contract").
7  * @author Eenae
8 
9  * FIXME after fix of truffle issue #560: refactor to a separate contract file which uses InvestmentAnalytics interface
10  */
11 contract AnalyticProxy {
12 
13     function AnalyticProxy() {
14         m_analytics = InvestmentAnalytics(msg.sender);
15     }
16 
17     /// @notice forward payment to analytics-capable contract
18     function() payable {
19         m_analytics.iaInvestedBy.value(msg.value)(msg.sender);
20     }
21 
22     InvestmentAnalytics public m_analytics;
23 }