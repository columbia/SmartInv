1 /**
2  * @title Contractus contract
3  * Funds distribution:
4  * 90% - deposit funds
5  * 3%  - support
6  * 7% -  marketing
7  * Allows you to receive income up to 2 deposit amounts and above if you continue to keep the deposit. 
8  * You can receive income 200% or more only once. In this case the deposit is closed. 
9  * Thus, the longer you keep the deposit open and do not withdraw your income, the more your potential gain becomes.
10  *Payments are terminated after the completion of 200%. To re-enter the game, you must replenish your deposit.
11  * You can receive your income at any time, based on a 2.5% per day calculation to 200%
12  * 
13  * This contract is a game - a lottery, in which prizes - payments on the deposit. 
14  * The contract is not a pyramid, since all deposits have a finite period of validity of payments. 
15  * You should not use this contract for investment purposes. Only for the game - lottery.
16  * By sending funds to this contract, you should understand that it is possible that the balance 
17  * of the contract will not be enough to pay all players. 
18  * Contract developers have not left themselves any functions for the withdrawal of players' funds, 
19  * but this is just a game - remember this.
20  */
21 
22 
23 
24 pragma solidity ^0.4.24;
25 contract Contractus {
26     mapping (address => uint256) public balances;
27     mapping (address => uint256) public timestamp;
28     mapping (address => uint256) public receiveFunds;
29     uint256 internal totalFunds;
30     
31     address support;
32     address marketing;
33 
34     constructor() public {
35         support = msg.sender;
36         marketing = 0x53B83d7be0D19b9935363Af1911b7702Cc73805e;
37     }
38 
39     function showTotal() public view returns (uint256) {
40         return totalFunds;
41     }
42 
43     function showProfit(address _investor) public view returns (uint256) {
44         return receiveFunds[_investor];
45     }
46 
47     function showBalance(address _investor) public view returns (uint256) {
48         return balances[_investor];
49     }
50 
51     /**
52      * The function will show you whether your deposit will remain in the game after the withdrawal of revenue or close after reaching 200%
53      * A value of "true" means that your deposit will be closed after withdrawal of funds
54      */
55     function isLastWithdraw(address _investor) public view returns(bool) {
56         address investor = _investor;
57         uint256 profit = calcProfit(investor);
58         bool result = !((balances[investor] == 0) || (balances[investor] * 2 > receiveFunds[investor] + profit));
59         return result;
60     }
61 
62     function calcProfit(address _investor) internal view returns (uint256) {
63         uint256 profit = balances[_investor]*25/1000*(now-timestamp[_investor])/86400; // a seconds in one day
64         return profit;
65     }
66 
67 
68     function () external payable {
69         require(msg.value > 0,"Zero. Access denied.");
70         totalFunds +=msg.value;
71         address investor = msg.sender;
72         support.transfer(msg.value * 3 / 100);
73         marketing.transfer(msg.value * 7 / 100);
74 
75         uint256 profit = calcProfit(investor);
76         investor.transfer(profit);
77 
78         if (isLastWithdraw(investor)){
79             /**
80              * @title Closing of the deposit
81              * 
82              *  You have received 200% (or more) of your contribution.
83              *  Under the terms of the game, your contribution is closed, the statistics are reset.
84              *  You can start playing again. We wish you good luck!
85              */
86             balances[investor] = 0;
87             receiveFunds[investor] = 0;
88            
89         }
90         else {
91         receiveFunds[investor] += profit;
92         balances[investor] += msg.value;
93             
94         }
95         timestamp[investor] = now;
96     }
97 
98 }