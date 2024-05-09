1 pragma solidity ^0.4.21;
2 
3 /**
4  * this contract stands for the holds of WestIndia group
5  * all income will be split to holders according to their holds
6  * user can buy holds from shareholders at his will
7  */
8 contract Share {
9 
10     bool public pause;
11     /**
12      * owner can pause the contract so that no one can withdrawal
13      * he can't do anything else
14      */
15     address public owner;
16     
17     /**
18      * the holds of every holder
19      * the total holds stick to 10000
20      */
21     mapping (address => uint) public holds;
22 
23     /**
24      * since we don't record holders' address in a list
25      * and we don't want to loop holders list everytime when there is income
26      *
27      * we use a mechanism called 'watermark'
28      * 
29      * the watermark indicates the value that brought into each holds from the begining
30      * it only goes up when new income send to the contract
31 
32      * fullfilled indicate the amount that the holder has withdrawaled from his share
33      * it goes up when user withdrawal bonus
34      * and it goes up when user sell holds, goes down when user buy holds, since the total bonus of him stays the same.
35      */
36     mapping (address => uint256) public fullfilled;
37 
38     /**
39      * any one can setup a price to sell his holds
40      * if set to 0, means not on sell
41      */
42     mapping (address => uint256) public sellPrice;
43     mapping (address => uint) public toSell;
44 
45     uint256 public watermark;
46 
47     event PAUSED();
48     event STARTED();
49 
50     event SHARE_TRANSFER(address from, address to, uint amount);
51     event INCOME(uint256);
52     event PRICE_SET(address holder, uint shares, uint256 price, uint sell);
53     event WITHDRAWAL(address owner, uint256 amount);
54     event SELL_HOLDS(address from, address to, uint amount, uint256 price);
55     event SEND_HOLDS(address from, address to, uint amount);
56 
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61     
62     modifier notPaused() {
63         require(!pause);
64         _;
65     }
66     
67     function setState(bool _pause) onlyOwner public {
68         pause = _pause;
69         
70         if (_pause) {
71             emit PAUSED();
72         } else {
73             emit STARTED();
74         } 
75     }
76 
77     /**
78      * at start the owner has 100% share, which is 10,000 holds
79      */
80     function Share() public {        
81         owner = msg.sender;
82         holds[owner] = 10000;
83         pause = false;
84     }
85 
86     /**
87      * when there's income, the water mark goes up
88      */
89     function onIncome() public payable {
90         if (msg.value > 0) {
91             watermark += (msg.value / 10000);
92             assert(watermark * 10000 > watermark);
93 
94             emit INCOME(msg.value);
95         }
96     }
97 
98     /**
99      * automatically split income
100      */
101     function() public payable {
102         onIncome();
103     }
104 
105     function bonus() public view returns (uint256) {
106         return (watermark - fullfilled[msg.sender]) * holds[msg.sender];
107     }
108     
109     function setPrice(uint256 price, uint sell) public notPaused {
110         sellPrice[msg.sender] = price;
111         toSell[msg.sender] = sell;
112         emit PRICE_SET(msg.sender, holds[msg.sender], price, sell);
113     }
114 
115     /**
116      * withdrawal the bonus
117      */
118     function withdrawal() public notPaused {
119         if (holds[msg.sender] == 0) {
120             //you don't have any, don't bother
121             return;
122         }
123         uint256 value = bonus();
124         fullfilled[msg.sender] = watermark;
125 
126         msg.sender.transfer(value);
127 
128         emit WITHDRAWAL(msg.sender, value);
129     }
130 
131     /**
132      * transfer holds from => to (only holds, no bouns)
133      * this will withdrawal the holder bonus of these holds
134      * and the to's fullfilled will go up, since total bonus unchanged, but holds goes more
135      */
136     function transferHolds(address from, address to, uint amount) internal {
137         require(holds[from] >= amount);
138         require(amount > 0);
139 
140         uint256 fromBonus = (watermark - fullfilled[from]) * amount;
141         uint256 toBonus = (watermark - fullfilled[to]) * holds[to];
142         
143 
144         holds[from] -= amount;
145         holds[to] += amount;
146         fullfilled[to] = watermark - toBonus / holds[to];
147 
148         from.transfer(fromBonus);
149 
150         emit SHARE_TRANSFER(from, to, amount);
151         emit WITHDRAWAL(from, fromBonus);
152     }
153 
154     /**
155      * one can buy holds from anyone who set up an price,
156      * and u can buy @ price higher than he setup
157      */
158     function buyFrom(address from) public payable notPaused {
159         require(sellPrice[from] > 0);
160         uint256 amount = msg.value / sellPrice[from];
161 
162         if (amount >= holds[from]) {
163             amount = holds[from];
164         }
165 
166         if (amount >= toSell[from]) {
167             amount = toSell[from];
168         }
169 
170         require(amount > 0);
171 
172         toSell[from] -= amount;
173         transferHolds(from, msg.sender, amount);
174         from.transfer(msg.value);
175         
176         emit SELL_HOLDS(from, msg.sender, amount, sellPrice[from]);
177     }
178     
179     function transfer(address to, uint amount) public notPaused {
180         require(holds[msg.sender] >= amount);
181         transferHolds(msg.sender, to, amount);
182         
183         emit SEND_HOLDS(msg.sender, to, amount);
184     }
185 }