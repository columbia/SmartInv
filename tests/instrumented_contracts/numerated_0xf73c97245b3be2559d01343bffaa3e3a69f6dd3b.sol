1 pragma solidity ^0.4.21;
2 
3 contract ItemMarket{
4 	address public owner;
5 
6 	// 500 / 10000 = 5%
7 	uint16 public devFee = 500;
8 	uint256 public ItemCreatePrice = 0.02 ether;
9 
10 	event ItemCreated(uint256 id);
11 	event ItemBought(uint256 id);
12 	event ItemWon(uint256 id);
13 
14 	struct Item{
15 		uint32 timer;
16 		uint256 timestamp;
17 		uint16 priceIncrease;
18 		uint256 price;
19 		uint256 amount;
20 		uint256 minPrice;
21 		uint16 creatorFee;
22 		uint16 previousFee;
23 		uint16 potFee;
24 
25 		address creator;
26 		address owner;
27 		string quote;
28 		string name;
29 	} 
30 
31 	mapping (uint256 => Item) public Items;
32 
33 	uint256 public next_item_index = 0;
34 
35     modifier onlyOwner(){
36         if (msg.sender == owner){
37             _;
38         }
39         else{
40             revert();
41         }
42     }
43 
44     function ItemMarket() public{
45     	owner = msg.sender;
46     	// Add items 
47 
48     	AddItem(600, 1500, 1 finney, 0, 3000, "Battery");
49 
50 
51     	AddItem(600, 150, 4 finney, 0, 5000, "Twig");
52 
53     	AddItem(3600, 2000, 10 finney, 0, 4000, "Solar Panel");
54     	AddItem(3600*24, 5000, 10 finney, 0, 5000, "Moon");
55     	AddItem(3600*24*7, 7500, 50 finney, 0, 7000, "Ethereum");
56 
57     }
58 
59     function ChangeFee(uint16 _fee) public onlyOwner{
60     	require(_fee <= 500);
61     	devFee = _fee;
62     }
63 
64     function ChangeItemPrice(uint256 _newPrice) public onlyOwner{
65     	ItemCreatePrice = _newPrice;
66     }
67 
68     function AddItem(uint32 timer, uint16 priceIncrease, uint256 minPrice, uint16 creatorFee, uint16 potFee, string name) public payable {
69     	require (timer >= 300);
70     	require (timer < 31622400);
71 
72     	require(priceIncrease <= 10000);
73     	require(minPrice >= (1 finney) && minPrice <= (1 ether));
74     	require(creatorFee <= 2500);
75     	require(potFee <= 10000);
76     	require(add(add(creatorFee, potFee), devFee) <= 10000);
77 
78 
79 
80     	if (msg.sender == owner){
81     		require(creatorFee == 0);
82     		if (msg.value > 0){
83     			owner.transfer(msg.value);
84     		}
85     	}
86     	else{
87     		uint256 left = 0;
88     		if (msg.value > ItemCreatePrice){
89     			left = sub(msg.value, ItemCreatePrice);
90     			msg.sender.transfer(left);
91     		}
92     		else{
93     			if (msg.value < ItemCreatePrice){
94 
95     				revert();
96     			}
97     		}
98 
99     		owner.transfer(sub(msg.value, left));
100     	}
101 
102 
103         require (devFee + potFee + creatorFee <= 10000);
104         
105     	uint16 previousFee = 10000 - devFee - potFee - creatorFee;
106     	var NewItem = Item(timer, 0, priceIncrease, minPrice, 0, minPrice, creatorFee, previousFee, potFee, msg.sender, address(0), "", name);
107 
108     	Items[next_item_index] = NewItem;
109 
110     	emit ItemCreated(next_item_index);
111 
112     	next_item_index = add(next_item_index,1);
113     }
114 
115     function Payout(uint256 id) internal {
116     	var UsedItem = Items[id];
117     	uint256 Paid = UsedItem.amount;
118     	UsedItem.amount = 0;
119 
120     	UsedItem.owner.transfer(Paid);
121 
122     	// reset game 
123     	UsedItem.owner = address(0);
124     	UsedItem.price = UsedItem.minPrice;
125     	UsedItem.timestamp = 0;
126 
127     	emit ItemWon(id);
128 
129     }
130 
131 
132     function TakePrize(uint256 id) public {
133     	require(id < next_item_index);
134     	var UsedItem = Items[id];
135     	require(UsedItem.owner != address(0));
136     	uint256 TimingTarget = add(UsedItem.timer, UsedItem.timestamp);
137 
138     	if (block.timestamp > TimingTarget){
139     		Payout(id);
140     		return;
141     	}
142     	else{
143     		revert();
144     	}
145     }
146 
147 
148 
149 
150     function BuyItem(uint256 id, string quote) public payable{
151     	require(id < next_item_index);
152     	var UsedItem = Items[id];
153 
154 
155     	if (UsedItem.owner != address(0) && block.timestamp > (add(UsedItem.timestamp, UsedItem.timer))){
156     		Payout(id);
157     		if (msg.value > 0){
158     			msg.sender.transfer(msg.value);
159     		}
160     		return;
161     	}
162 
163     	require(msg.value >= UsedItem.price);
164     	require(msg.sender != owner);
165     	//require(msg.sender != UsedItem.creator); 
166     	require(msg.sender != UsedItem.owner);
167 
168     	uint256 devFee_used = mul(UsedItem.price, devFee) / 10000;
169     	uint256 creatorFee_used = mul(UsedItem.price, UsedItem.creatorFee) / 10000;
170     	uint256 prevFee_used;
171 
172    		if (UsedItem.owner == address(0)){
173    			// game not started. 
174    			prevFee_used = 0;
175    		}
176    		else{
177    			prevFee_used = (mul(UsedItem.price, UsedItem.previousFee)) / 10000;
178    			UsedItem.owner.transfer(prevFee_used);
179    		}
180 
181    		if (creatorFee_used != 0){
182    			UsedItem.creator.transfer(creatorFee_used);
183    		}
184 
185    		if (devFee_used != 0){
186    			owner.transfer(devFee_used);
187    		}
188    		
189    		if (msg.value > UsedItem.price){
190    		    msg.sender.transfer(sub(msg.value, UsedItem.price));
191    		}
192 
193    		uint256 potFee_used = sub(sub(sub(UsedItem.price, devFee_used), creatorFee_used), prevFee_used);
194 
195    		UsedItem.amount = add(UsedItem.amount, potFee_used);
196    		UsedItem.timestamp = block.timestamp;
197    		UsedItem.owner = msg.sender;
198    		UsedItem.quote = quote;
199    		UsedItem.price = (UsedItem.price * (add(10000, UsedItem.priceIncrease)))/10000;
200 
201    		emit ItemBought(id);
202     }
203     
204 	function () payable public {
205 		// msg.value is the amount of Ether sent by the transaction.
206 		if (msg.value > 0) {
207 			msg.sender.transfer(msg.value);
208 		}
209 	}
210 	
211 	
212 	
213 	    
214     // Not interesting, safe math functions
215     
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217       if (a == 0) {
218          return 0;
219       }
220       uint256 c = a * b;
221       assert(c / a == b);
222       return c;
223    }
224 
225    function div(uint256 a, uint256 b) internal pure returns (uint256) {
226       // assert(b > 0); // Solidity automatically throws when dividing by 0
227       uint256 c = a / b;
228       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229       return c;
230    }
231 
232    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233       assert(b <= a);
234       return a - b;
235    }
236 
237    function add(uint256 a, uint256 b) internal pure returns (uint256) {
238       uint256 c = a + b;
239       assert(c >= a);
240       return c;
241    }
242 
243 
244 }