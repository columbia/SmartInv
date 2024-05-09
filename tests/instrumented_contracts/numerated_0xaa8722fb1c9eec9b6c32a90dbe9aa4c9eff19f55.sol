1 pragma solidity ^0.4.21;
2 
3 
4 contract OrganicumOrders {
5     struct order {
6     uint256 balance;
7     uint256 tokens;
8     }
9 
10     mapping (address => order) public orders;
11     address[] public holders;
12 
13     uint256 public supplyTokens;
14     uint256 public supplyTokensSaved;
15     uint256 public tokenDecimal = 18;
16 
17     uint256 minAmount = 1000; // minAmount / 100 = 10 $
18     uint256 softCap = 5000000; // softCap / 100 = 50 000 $
19     uint256 supplyInvestmen = 0;
20 
21     uint16 fee = 500; // fee / 10000 = 0.05 = 5%
22 
23     uint256 public etherCost = 60000; // etherCost / 100 = 600 $
24 
25     address public owner;
26 
27     uint256 public startDate = 1521849600; // 24.03.2018
28     uint256 public firstPeriod = 1522540800; // 01.04.2018
29     uint256 public secondPeriod = 1525132800; // 01.05.2018
30     uint256 public thirdPeriod = 1527811200; // 01.06.2018
31     uint256 public endDate = 1530403200; // 01.07.2018
32 
33     function OrganicumOrders()
34     {
35         owner = msg.sender;
36     }
37 
38     modifier isOwner()
39     {
40         assert(msg.sender == owner);
41         _;
42     }
43 
44     function changeOwner(address new_owner) isOwner
45     {
46         assert(new_owner != address(0x0));
47         assert(new_owner != address(this));
48         owner = new_owner;
49     }
50 
51     function changeEtherCost(uint256 new_cost) isOwner external
52     {
53         assert(new_cost > 0);
54         etherCost = new_cost*100;
55     }
56 
57     function getPrice() constant returns(uint256)
58     {
59         if(now < firstPeriod)
60         {
61             return 95; // 0.95 $
62         }
63         else if(now < secondPeriod)
64         {
65             return 100; // 1.00 $
66         }
67         else if(now < thirdPeriod)
68         {
69             return 110; // 1.10 $
70         }
71         else
72         {
73             return 120; // 1.20 $
74         }
75     }
76 
77     function () payable
78     {
79         assert(now >= startDate && now < endDate);
80         assert((msg.value * etherCost)/10**18 >= minAmount);
81 
82         if(orders[msg.sender].balance == 0 && orders[msg.sender].tokens == 0)
83         {
84             holders.push(msg.sender);
85         }
86 
87         uint256 countTokens = (msg.value * etherCost) / getPrice();
88         orders[msg.sender].balance += msg.value;
89         orders[msg.sender].tokens += countTokens;
90 
91         supplyTokens += countTokens;
92         supplyTokensSaved += countTokens;
93         supplyInvestmen += msg.value;
94     }
95 
96     function orderFor(address to) payable
97     {
98         assert(now >= startDate && now < endDate);
99         assert((msg.value * etherCost)/10**18 >= minAmount);
100 
101         if(orders[to].balance == 0 && orders[to].tokens == 0)
102         {
103             holders.push(to);
104             if (to.balance == 0)
105             {
106                 to.transfer(0.001 ether);
107             }
108         }
109 
110         uint256 countTokens = ((msg.value - 0.001 ether) * etherCost) / getPrice();
111         orders[to].balance += msg.value;
112         orders[to].tokens += countTokens;
113 
114         supplyTokens += countTokens;
115         supplyTokensSaved += countTokens;
116         supplyInvestmen += msg.value;
117     }
118 
119     mapping (address => bool) public voter;
120     uint256 public sumVote = 0;
121     uint256 public durationVoting = 24 hours;
122 
123     function vote()
124     {
125         assert(!voter[msg.sender]);
126         assert(now >= endDate && now < endDate + durationVoting);
127         assert((supplyInvestmen * etherCost)/10**18 >= softCap);
128         assert(orders[msg.sender].tokens > 0);
129 
130         voter[msg.sender] = true;
131         sumVote += orders[msg.sender].tokens;
132     }
133 
134     function refund(address holder)
135     {
136         assert(orders[holder].balance > 0);
137 
138         uint256 etherToSend = 0;
139         if ((supplyInvestmen * etherCost)/10**18 >= softCap)
140         {
141             assert(sumVote > supplyTokensSaved / 2); // > 50%
142             etherToSend = orders[holder].balance * 95 / 100;
143         }
144         else
145         {
146             etherToSend = orders[holder].balance;
147         }
148         assert(etherToSend > 0);
149 
150         if (etherToSend > this.balance) etherToSend = this.balance;
151 
152         holder.transfer(etherToSend);
153 
154         supplyTokens -= orders[holder].tokens;
155         orders[holder].balance = 0;
156         orders[holder].tokens = 0;
157     }
158 
159     function takeInvest() isOwner
160     {
161         assert(now >= endDate + durationVoting);
162         assert(this.balance > 0);
163 
164         if(sumVote > supplyTokensSaved / 2)
165         {
166             assert(supplyTokens == 0);
167         }
168 
169         owner.transfer(this.balance);
170     }
171 }