1 pragma solidity ^0.4.21;
2 
3 // Updates since last contract 
4 // Price increase is now max 200% from 100% 
5 // min Price is now 1 szabo from 1 finney. This price is not recommended due to gas. 
6 // If you start a new game (amount in pot is 0, and timer hasn't started) then you will pay NO fees
7 // This means that you can always start a game without any risk. 
8 // If no one decides to buy, then you can pay out back, and you will get the pot, which is 100% of your payment back!!
9 
10 // WARNING
11 // IF SITE GOES DOWN, THEN YOU CAN STILL KEEP PLAYING THE GAME 
12 // INSTRUCTIONS:
13 // GO TO REMIX.ETHEREUM.ORG, UPLOAD THIS CONTRACT, AND THEN LOAD THIS CONTRACT FROM ADDRESS 
14 // MAKE SURE YOU ARE CONNECTED WITH METAMASK TO MAINNET 
15 // NOW YOU CAN CALL FUNCTIONS 
16 // EX; CALL PAYOUT(ID) SO YOU CAN PAY OUT IF YOU WON A CARD. 
17 // NOTE: SITES WHICH HOST UI ARE NOT SUPPOSED TO GO DOWN
18 
19 contract ItemMarket{
20 	address public owner;
21 
22 	// 500 / 10000 = 5%
23 	uint16 public devFee = 500;
24 	uint256 public ItemCreatePrice = 0.02 ether;
25 
26     // note, on etherscan you can see these item calls
27     // if you buy an item, the TX will call ItemCreated with the id it gets - which you can see on etherscan!
28 	event ItemCreated(uint256 id);
29 	event ItemBought(uint256 id);
30 	event ItemWon(uint256 id);
31 	//event ItemCreationError(string err);
32 
33 	struct Item{
34 		uint32 timer;
35 		uint256 timestamp;
36 		uint16 priceIncrease;
37 		uint256 price;
38 		uint256 amount;
39 		uint256 minPrice;
40 		uint16 creatorFee;
41 		uint16 previousFee;
42 		uint16 potFee;
43 
44 		address creator;
45 		address owner;
46 		string quote;
47 		string name;
48 	} 
49 
50 	mapping (uint256 => Item) public Items;
51 
52 	uint256 public next_item_index = 0;
53 
54     modifier onlyOwner(){
55         if (msg.sender == owner){
56             _;
57         }
58         else{
59             revert();
60         }
61     }
62 
63     function ItemMarket() public{
64     	owner = msg.sender;
65     	// Add items 
66        
67     
68         
69     }
70     
71     uint8 IS_STARTED=0;
72     
73     function callOnce() public {
74         require(msg.sender == owner);
75         require(IS_STARTED==0);
76         IS_STARTED = 1;
77         AddItemExtra(600, 1500, 1 finney, 0, 3000, "Battery", msg.sender);
78     	AddItemExtra(600, 150, 4 finney, 0, 5000, "Twig", msg.sender);
79     	AddItemExtra(3600, 2000, 10 finney, 0, 4000, "Solar Panel", msg.sender);
80     	AddItemExtra(3600*24, 5000, 10 finney, 0, 5000, "Moon", msg.sender);
81     	AddItemExtra(3600*24*7, 7500, 50 finney, 0, 7000, "Ethereum", msg.sender);
82     	
83     	// Previous contract had items. Recreate those
84     	
85         AddItemExtra(2000, 10000, 1000000000000000, 500, 2000, "segfault's ego", 0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB);
86         AddItemExtra(300, 10000, 10000000000000000, 500, 2500, "Hellina", 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285);
87         AddItemExtra(600, 10000, 100000000000000000, 500, 2000, "nightman's gambit", 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956);
88         AddItemExtra(360000, 10000, 5000000000000000, 200, 1800, "BOHLISH", 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d);
89         AddItemExtra(900, 2000, 20000000000000000, 1000, 2000, "Phil's labyrinth", 0x457dEA5F9c185419EA47ff80f896d98aadf1c727);
90         AddItemExtra(420, 6899, 4200000000000000, 500, 4000, "69,420 (Nice)", 0x477cCD47d62a4929DD11651ab835E132c8eab3B8);
91         next_item_index = next_item_index + 2; // this was an item I created. We skip this item. Item after this too, to check if != devs could create 
92         // apparently people created wrong settings which got reverted by the add item function. it looked like system was wrong
93         
94         // tfw next item 
95         // i didnt create this name lol 
96         
97         AddItemExtra(600, 10000, 5000000000000000, 2500, 7000, "HELLINA IS A RETARDED DEGENERATE GAMBLER AND A FUCKING FUD QUEEN", 0x26581d1983ced8955C170eB4d3222DCd3845a092);
98         
99         // created this, nice hot potato 
100         
101         AddItemExtra(1800, 9700, 2000000000000000, 0, 2500, "Hot Potato", msg.sender);
102     }
103 
104     function ChangeFee(uint16 _fee) public onlyOwner{
105     	require(_fee <= 500);
106     	devFee = _fee;
107     }
108 
109     function ChangeItemPrice(uint256 _newPrice) public onlyOwner{
110     	ItemCreatePrice = _newPrice;
111     }
112     
113     // INTERNAL EXTRA FUNCTION TO MOVE OVER OLD ITEMS 
114     
115     function AddItemExtra(uint32 timer, uint16 priceIncrease, uint256 minPrice, uint16 creatorFee, uint16 potFee, string name, address own) internal {
116     	uint16 previousFee = 10000 - devFee - potFee - creatorFee;
117     	var NewItem = Item(timer, 0, priceIncrease, minPrice, 0, minPrice, creatorFee, previousFee, potFee, own, address(0), "", name);
118 
119     	Items[next_item_index] = NewItem;
120 
121     	//emit ItemCreated(next_item_index);
122 
123     	next_item_index = add(next_item_index,1);
124     }
125 
126     function AddItem(uint32 timer, uint16 priceIncrease, uint256 minPrice, uint16 creatorFee, uint16 potFee, string name) public payable {
127     	require (timer >= 300);
128     	require (timer < 31622400);
129 
130     	require(priceIncrease <= 20000);
131     	require(minPrice >= (1 szabo) && minPrice <= (1 ether));
132     	require(creatorFee <= 2500);
133     	require(potFee <= 10000);
134     	require(add(add(creatorFee, potFee), devFee) <= 10000);
135 
136 
137 
138     	if (msg.sender == owner){
139     		require(creatorFee == 0);
140     		if (msg.value > 0){
141     			owner.transfer(msg.value);
142     		}
143     	}
144     	else{
145     		uint256 left = 0;
146     		if (msg.value > ItemCreatePrice){
147     			left = sub(msg.value, ItemCreatePrice);
148     			msg.sender.transfer(left);
149     		}
150     		else{
151     			if (msg.value < ItemCreatePrice){
152 
153     				revert();
154     			}
155     		}
156 
157     		owner.transfer(sub(msg.value, left));
158     	}
159 
160 
161         require (devFee + potFee + creatorFee <= 10000);
162         
163     	uint16 previousFee = 10000 - devFee - potFee - creatorFee;
164     	var NewItem = Item(timer, 0, priceIncrease, minPrice, 0, minPrice, creatorFee, previousFee, potFee, msg.sender, address(0), "", name);
165 
166     	Items[next_item_index] = NewItem;
167 
168     	emit ItemCreated(next_item_index);
169 
170     	next_item_index = add(next_item_index,1);
171     }
172 
173     function Payout(uint256 id) internal {
174     	var UsedItem = Items[id];
175     	uint256 Paid = UsedItem.amount;
176     	UsedItem.amount = 0;
177 
178     	UsedItem.owner.transfer(Paid);
179 
180     	// reset game 
181     	UsedItem.owner = address(0);
182     	UsedItem.price = UsedItem.minPrice;
183     	UsedItem.timestamp = 0;
184 
185     	emit ItemWon(id);
186 
187     }
188 
189 
190     function TakePrize(uint256 id) public {
191     	require(id < next_item_index);
192     	var UsedItem = Items[id];
193     	require(UsedItem.owner != address(0));
194     	uint256 TimingTarget = add(UsedItem.timer, UsedItem.timestamp);
195 
196     	if (block.timestamp > TimingTarget){
197     		Payout(id);
198     		return;
199     	}
200     	else{
201     		revert();
202     	}
203     }
204 
205 
206 
207 
208     function BuyItem(uint256 id, string quote) public payable{
209     	require(id < next_item_index);
210     	var UsedItem = Items[id];
211 
212 
213     	if (UsedItem.owner != address(0) && block.timestamp > (add(UsedItem.timestamp, UsedItem.timer))){
214     		Payout(id);
215     		if (msg.value > 0){
216     			msg.sender.transfer(msg.value);
217     		}
218     		return;
219     	}
220 
221     	require(msg.value >= UsedItem.price);
222     	require(msg.sender != owner);
223     	//require(msg.sender != UsedItem.creator); 
224     	require(msg.sender != UsedItem.owner);
225 
226     	uint256 devFee_used = mul(UsedItem.price, devFee) / 10000;
227     	uint256 creatorFee_used = mul(UsedItem.price, UsedItem.creatorFee) / 10000;
228     	uint256 prevFee_used;
229 
230    		if (UsedItem.owner == address(0)){
231    			// game not started. 
232    			// NO FEES ARE PAID WHEN THE TIMER IS STARTS
233    			// IF NO ONE START PLAYING GAME, then the person who bought first can get 100% of his ETH back!
234    			prevFee_used = 0;
235    			devFee_used = 0;
236    			creatorFee_used = 0;
237    		}
238    		else{
239    			prevFee_used = (mul(UsedItem.price, UsedItem.previousFee)) / 10000;
240    			UsedItem.owner.transfer(prevFee_used);
241    		}
242 
243    		if (creatorFee_used != 0){
244    			UsedItem.creator.transfer(creatorFee_used);
245    		}
246 
247    		if (devFee_used != 0){
248    			owner.transfer(devFee_used);
249    		}
250    		
251    		if (msg.value > UsedItem.price){
252    		    msg.sender.transfer(sub(msg.value, UsedItem.price));
253    		}
254 
255    		uint256 potFee_used = sub(sub(sub(UsedItem.price, devFee_used), creatorFee_used), prevFee_used);
256 
257    		UsedItem.amount = add(UsedItem.amount, potFee_used);
258    		UsedItem.timestamp = block.timestamp;
259    		UsedItem.owner = msg.sender;
260    		UsedItem.quote = quote;
261    		UsedItem.price = (UsedItem.price * (add(10000, UsedItem.priceIncrease)))/10000;
262 
263    		emit ItemBought(id);
264     }
265     
266 	function () payable public {
267 		// msg.value is the amount of Ether sent by the transaction.
268 		if (msg.value > 0) {
269 			msg.sender.transfer(msg.value);
270 		}
271 	}
272 	
273 	
274 	
275 	    
276     // Not interesting, safe math functions
277     
278     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
279       if (a == 0) {
280          return 0;
281       }
282       uint256 c = a * b;
283       assert(c / a == b);
284       return c;
285    }
286 
287    function div(uint256 a, uint256 b) internal pure returns (uint256) {
288       // assert(b > 0); // Solidity automatically throws when dividing by 0
289       uint256 c = a / b;
290       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291       return c;
292    }
293 
294    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295       assert(b <= a);
296       return a - b;
297    }
298 
299    function add(uint256 a, uint256 b) internal pure returns (uint256) {
300       uint256 c = a + b;
301       assert(c >= a);
302       return c;
303    }
304 
305 
306 }