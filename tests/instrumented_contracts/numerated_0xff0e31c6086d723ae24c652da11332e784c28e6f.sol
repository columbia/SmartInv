1 pragma solidity ^0.4.25;
2 
3 /**
4 UnrealInvest Contract
5 - GAIN UP TO 120-130% PER 5 MINUTES (every 20 blocks)
6 - 3% of the contributions go to project advertising
7 
8 How to use:
9     1. Send at least 0.01 Ether to make an investment.
10     2a. Claim your profit by sending 0 Ether transaction in 20 blocks.
11         OR
12     2b. Send at least 0.01 Ether in 20 blocks to reinvest AND get your
13         profit at the same time.
14     2c. The amount for the payment is calculated as the
15         AMOUNT_IN_THE_FUND/NUMBER_OF_ACTIVE_INVESTORS.
16         If you didn't receive the entire due payment, you can try sending
17         a new request after another 20 blocks.
18     3. Participants with referrers receive 130% instead of 120%.
19     4. To become someone's referral, enter the address of the referrer
20         in the field DATA when sending the first deposit.
21     5. Only a participant who deposited at least 0.01 Ether can become
22         a referrer.
23     6. Referrers receive 5% of each deposit of referrals immediately to
24         their wallet.
25     7. To receive the prize fund, you need to be the last investor for
26         at least 42 blocks (~10 minutes), after which you need to send
27         0 Ether or reinvest.
28 
29 RECOMMENDED GAS LIMIT: 300000
30 RECOMMENDED GAS PRICE: https://ethgasstation.info/
31 
32 Contract reviewed and approved by pros!
33 */
34 
35 contract UnrealInvest {
36     uint public prizePercent = 2;
37     uint public supportPercent = 3;
38     uint public refPercent = 5;
39     uint public holdInterval = 20;
40     uint public prizeInterval = 42;
41     uint public percentWithoutRef = 120;
42     uint public percentWithRef = 130;
43     uint public minDeposit = 0.01 ether;
44     
45     address support = msg.sender;
46     uint public prizeFund;
47     address public lastInvestor;
48     uint public lastInvestedAt;
49     
50     uint public activeInvestors;
51     uint public totalInvested;
52     
53     // records investors
54     mapping (address => bool) public registered;
55     // records amounts invested
56     mapping (address => uint) public invested;
57     // records amounts paid
58     mapping (address => uint) public paid;
59     // records blocks at which investments/payments were made
60     mapping (address => uint) public atBlock;
61     // records referrers
62     mapping (address => address) public referrers;
63     
64     function bytesToAddress(bytes source) internal pure returns (address parsedAddress) {
65         assembly {
66             parsedAddress := mload(add(source,0x14))
67         }
68         return parsedAddress;
69     }
70     
71     function () external payable {
72         require(registered[msg.sender] && msg.value == 0 || msg.value >= minDeposit);
73         
74         bool fullyPaid;
75         uint transferAmount;
76         
77         if (!registered[msg.sender] && msg.data.length == 20) {
78             address referrerAddress = bytesToAddress(bytes(msg.data));
79             require(referrerAddress != msg.sender);     
80             if (registered[referrerAddress]) {
81                 referrers[msg.sender] = referrerAddress;
82             }
83         }
84         registered[msg.sender] = true;
85         
86         if (invested[msg.sender] > 0 && block.number >= atBlock[msg.sender] + holdInterval) {
87             uint availAmount = (address(this).balance - msg.value - prizeFund) / activeInvestors;
88             uint payAmount = invested[msg.sender] * (referrers[msg.sender] == 0x0 ? percentWithoutRef : percentWithRef) / 100 - paid[msg.sender];
89             if (payAmount > availAmount) {
90                 payAmount = availAmount;
91             } else {
92                 fullyPaid = true;
93             }
94             if (payAmount > 0) {
95                 paid[msg.sender] += payAmount;
96                 transferAmount += payAmount;
97                 atBlock[msg.sender] = block.number;
98             }
99         }
100         
101         if (msg.value > 0) {
102             if (invested[msg.sender] == 0) {
103                 activeInvestors++;
104             }
105             invested[msg.sender] += msg.value;
106             atBlock[msg.sender] = block.number;
107             totalInvested += msg.value;
108             
109             lastInvestor = msg.sender;
110             lastInvestedAt = block.number;
111             
112             prizeFund += msg.value * prizePercent / 100;
113             support.transfer(msg.value * supportPercent / 100);
114             if (referrers[msg.sender] != 0x0) {
115                 referrers[msg.sender].transfer(msg.value * refPercent / 100);
116             }
117         }
118         
119         if (lastInvestor == msg.sender && block.number >= lastInvestedAt + prizeInterval) {
120             transferAmount += prizeFund;
121             delete prizeFund;
122             delete lastInvestor;
123         }
124         
125         if (transferAmount > 0) {
126             msg.sender.transfer(transferAmount);
127         }
128         
129         if (fullyPaid) {
130             delete invested[msg.sender];
131             delete paid[msg.sender];
132             activeInvestors--;
133         }
134     }
135 }