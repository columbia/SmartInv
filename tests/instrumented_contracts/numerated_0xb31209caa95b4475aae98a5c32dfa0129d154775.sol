1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public;
5 }
6 
7 contract RetailSale {
8     address public beneficiary;
9     uint public actualPrice;
10     uint public nextPrice;
11     uint public nextPriceDate = 0;
12     uint public periodStart;
13     uint public periodEnd;
14     uint public bonus = 0;
15     uint public bonusStart = 0;
16     uint public bonusEnd = 0;
17     uint public milestone = 0;
18     uint public milestoneBonus = 0;
19     bool public milestoneReached = true;
20     uint public minPurchase;
21     token public tokenReward;
22 
23     event FundTransfer(address backer, uint amount, uint bonus, uint tokens);
24 
25     /**
26      * Constrctor function
27      *
28      * Setup the owner
29      */
30     function RetailSale(
31         address _beneficiary,
32         address addressOfTokenUsedAsReward,
33         uint ethPriceInWei,
34         uint _minPurchase,
35         uint start,
36         uint end
37     ) public {
38         beneficiary = _beneficiary;
39         tokenReward = token(addressOfTokenUsedAsReward);
40         actualPrice = ethPriceInWei;
41         nextPrice = ethPriceInWei;
42         minPurchase = _minPurchase;
43         periodStart = start;
44         periodEnd = end;
45     }
46 
47     /**
48      * Fallback function
49      *
50      * The function without name is the default function that is called whenever anyone sends funds to a contract
51      */
52     function()
53     payable
54     isOpen
55     aboveMinValue
56     public {
57         uint price = actualPrice;
58         if (now >= nextPriceDate) {
59             price = nextPrice;
60         }
61         uint vp = (msg.value * 1 ether) / price;
62         uint b = 0;
63         uint tokens = 0;
64         if (now >= bonusStart && now <= bonusEnd) {
65             b = bonus;
66         }
67         if (this.balance >= milestone && !milestoneReached) {
68             b = milestoneBonus;
69             milestoneReached = true;
70         }
71         if (b == 0) {
72             tokens = vp;
73         } else {
74             tokens = (vp + ((vp * b) / 100));
75         }
76         tokenReward.transferFrom(beneficiary, msg.sender, tokens);
77         FundTransfer(msg.sender, msg.value, b, tokens);
78     }
79 
80     modifier aboveMinValue() {
81         require(msg.value >= minPurchase);
82         _;
83     }
84 
85     modifier isOwner() {
86         require(msg.sender == beneficiary);
87         _;
88     }
89 
90     modifier isClosed() {
91         require(!(now >= periodStart && now <= periodEnd));
92         _;
93     }
94 
95     modifier isOpen() {
96         require(now >= periodStart && now <= periodEnd);
97         _;
98     }
99 
100     modifier validPeriod(uint start, uint end){
101         require(start < end);
102         _;
103     }
104 
105     /**
106      * Set next start date
107      * @param _start the next start date in seconds.
108      * @param _start the next end date in seconds.
109      */
110     function setNextPeriod(uint _start, uint _end)
111     isOwner
112     validPeriod(_start, _end)
113     public {
114         periodStart = _start;
115         periodEnd = _end;
116     }
117 
118     /**
119      * Set the new min purchase value
120      * @param _minPurchase the new minpurchase value in wei.
121      */
122     function setMinPurchase(uint _minPurchase)
123     isOwner
124     public {
125         minPurchase = _minPurchase;
126     }
127 
128     /**
129      * Change the bonus percentage
130      * @param _bonus the new bonus percentage.
131      * @param _bonusStart When the bonus starts in seconds.
132      * @param _bonusEnd When the bonus ends in seconds.
133      */
134     function changeBonus(uint _bonus, uint _bonusStart, uint _bonusEnd)
135     isOwner
136     public {
137         bonus = _bonus;
138         bonusStart = _bonusStart;
139         bonusEnd = _bonusEnd;
140     }
141 
142     /**
143      * Change the next milestone
144      * @param _milestone The next milestone amount in wei
145      * @param _milestoneBonus The bonus of the next milestone
146      */
147     function setNextMilestone(uint _milestone, uint _milestoneBonus)
148     isOwner
149     public {
150         milestone = _milestone;
151         milestoneBonus = _milestoneBonus;
152         milestoneReached = false;
153     }
154 
155     /**
156      * Set the next price
157      * @param _price The next eth price in wei
158      * @param _priceDate The date in second when the next price start
159      */
160     function setNextPrice(uint _price, uint _priceDate)
161     isOwner
162     public {
163         actualPrice = nextPrice;
164         nextPrice = _price;
165         nextPriceDate = _priceDate;
166     }
167 
168 
169     /**
170      * Withdraw the funds
171      *
172      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
173      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
174      * the amount they contributed.
175      */
176     function safeWithdrawal()
177     isClosed
178     isOwner
179     public {
180 
181         beneficiary.transfer(this.balance);
182 
183     }
184 
185     function open() view public returns (bool) {
186         return (now >= periodStart && now <= periodEnd);
187     }
188 
189 }