1 pragma solidity ^0.4.25;  
2 /*
3 * Web              - http://HOURS25.PRO
4 *
5 * Telegram         - https://t.me/hours25pro
6 *
7 * Email:             mailto:support(at sign)HOURS25.PRO
8 * 
9 * Marketing        - https://a-ads.com/campaigns/75140
10 *  - PROFIT 103,5% PER 25 HOURS 
11 *  - QUICK PAYMENTS
12 *  - Minimal contribution 0.02 eth
13 *  - Currency and payment - ETH
14 *  - Contribution allocation schemes:
15 *    -- 98% payments
16 *    -- 1% Marketing 
17 *    -- 1% PROJECT COMMISSION  (address)
18 *
19 *   ---About the Project--
20 *    Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
21 *    intermediaries. This technology opens incredible financial possibilities. Our automated investment 
22 *    distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
23 *    freely accessed online. In order to insure our investors' complete security, full control over the 
24 *    project has been transferred from the organizers to the smart contract: nobody can influence the 
25 *    system's permanent autonomous functioning.
26 * 
27 * ---How to use:--
28 *  1. Send from ETH wallet to the smart contract address 0x123456789......
29 *      any amount from 0.02 ETH.
30 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
31 *      of your wallet.
32 *  3. Claim your profit by sending 0.001 ether transaction.
33 *      We recommend output immediately after 6 hours.
34 *      Do not wait 25 hours!  
35 *   RECOMMENDED GAS LIMIT: 200000
36 *   RECOMMENDED GAS PRICE: https://ethgasstation.info/
37 *     You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
38 *
39 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
40 *     have private keys.
41 * 
42 *    Contracts reviewed and approved by pros!
43 * 
44 *    Scroll down to find it.
45 */
46 
47 contract Hours25 {
48     mapping (address => uint256) public balances;
49     mapping (address => uint256) public time_stamp;
50     mapping (address => uint256) public receive_funds;
51     uint256 internal total_funds;
52     
53     address commission;
54     address advertising;
55 
56     constructor() public {
57         commission = msg.sender;
58         advertising = 0xD93dFA3966dDac00C78D24286199CE318E1Aaac6;
59     }
60 
61     function showTotal() public view returns (uint256) {
62         return total_funds;
63     }
64 
65     function showProfit(address _investor) public view returns (uint256) {
66         return receive_funds[_investor];
67     }
68 
69     function showBalance(address _investor) public view returns (uint256) {
70         return balances[_investor];
71     }
72 
73     function isLastWithdraw(address _investor) public view returns(bool) {
74         address investor = _investor;
75         uint256 profit = calcProfit(investor);
76         bool result = !((balances[investor] == 0) || ((balances[investor]  * 1035) / 1000  > receive_funds[investor] + profit)); 
77         return result;
78     }
79 
80     function calcProfit(address _investor) internal view returns (uint256) {
81         uint256 profit = balances[_investor]*69/100000*(now-time_stamp[_investor])/60;
82         return profit;
83     }
84 
85 
86     function () external payable {
87         require(msg.value > 0,"Zero. Access denied.");
88         total_funds +=msg.value;
89         address investor = msg.sender;
90         commission.transfer(msg.value * 1 / 100);
91         advertising.transfer(msg.value * 1 / 100);
92 
93         uint256 profit = calcProfit(investor);
94         investor.transfer(profit);
95 
96         if (isLastWithdraw(investor)){
97           
98             balances[investor] = 0;
99             receive_funds[investor] = 0;
100            
101         }
102         else {
103         receive_funds[investor] += profit;
104         balances[investor] += msg.value;
105             
106         }
107         time_stamp[investor] = now;
108     }
109 
110 }