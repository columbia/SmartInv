1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4 	function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
5 		uint256 z = x + y;
6 		if (z < x || z < y) revert();
7 		return z;
8 	}
9 	function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
10 		if (x < y) revert();
11 		return x - y;
12 	}
13 	function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
14 		if (x == 0) return 0;
15 		uint256 z = x * y;
16 		if (z/x != y) revert();
17 		return z;
18 	}
19 }
20 
21 contract AccessMgr {
22 	address public mOwner;
23 	
24 	mapping(address => uint) public mModerators;
25 	address[] public mModeratorKeys;
26 	
27 	function AccessMgr() public {
28 		mOwner = msg.sender;
29 	}
30 	
31 	modifier Owner {
32 		if (msg.sender != mOwner)
33 			revert();
34 		_;
35 	}
36 	
37 	modifier Moderators {
38 		if (msg.sender != mOwner && mModerators[msg.sender] == 0)
39 			revert();
40 		_;
41 	}
42 	
43 	function changeOwner(address owner) Owner public {
44 		if (owner != address(0x0))
45 			mOwner = owner;
46 	}
47 	
48 	function addModerator(address moderator) Owner public {
49 		if (moderator != address(0x0)) {
50 			if (mModerators[moderator] > 0)
51 				return;
52 			mModerators[moderator] = mModeratorKeys.length;
53 			mModeratorKeys.push(moderator);
54 		}
55 	}
56 	
57 	function removeModerator(address moderator) Owner public {
58 		uint256 index = mModerators[moderator];
59 		if (index == 0) return;
60 		uint256 last = mModeratorKeys.length - 1;
61 		address lastMod = mModeratorKeys[last];
62 		
63 		index--;
64 		
65 		mModeratorKeys[index] = lastMod;
66 		delete mModeratorKeys[last];
67 		mModeratorKeys.length--;
68 		
69 		delete mModerators[moderator];
70 		
71 		mModerators[lastMod] = index;
72 	}
73 }
74 
75 contract UserMgr is SafeMath {
76 	struct User {
77 		uint256 balance;
78 		uint256[] hostedItems;
79 		uint256[] inventory;
80 	}
81 
82 	mapping(address => User) public mUsers;
83 	
84 	function UserMgr() public {}
85 	
86 	function getUser(address addr) public view returns (string name, uint256 balance, uint256[] hostedItems, uint256[] inventory) {
87 		User memory user = mUsers[addr];
88 		return (
89 			"Anonymous",
90 			user.balance,
91 			user.hostedItems,
92 			user.inventory);
93 	}
94 	
95 	function userDeposit() payable public {
96 		User storage user = mUsers[msg.sender];
97 		user.balance = safeAdd(user.balance, msg.value);
98 	}
99 	
100 	function userWithdraw() payable public {
101 		address sender = msg.sender;
102 		User storage user = mUsers[sender];
103 		uint256 amount = user.balance;
104 		if (amount == 0) revert();
105 		user.balance = msg.value;
106 		require(sender.send(amount));
107 	}
108 }
109 
110 contract ItemMgr {
111 	struct Item {
112 		string name;
113 		address hostAddress;
114 		uint256 price;
115 		uint256 numSold;
116 		uint256 basePrice;
117 		uint256 growthAmount;
118 		uint256 growthPeriod;
119 		address[] purchases;
120 	}
121 
122 	Item[] public mItems;
123 
124 	function ItemMgr() public {}
125 
126 	function getNumItems() public view returns (uint256 count) {
127 		return mItems.length;
128 	}
129 
130 	function getItem(uint256 index) public view
131 			returns (string name, address hostAddress, uint256 price, uint256 numSold,
132 					uint256 basePrice, uint256 growthAmount, uint256 growthPeriod) {
133 		uint256 length = mItems.length;
134 		if (index >= length) index = length-1;
135 		Item memory item = mItems[index];
136 		return (
137 			item.name, item.hostAddress, item.price, item.numSold,
138 			item.basePrice, item.growthAmount, item.growthPeriod
139 		);
140 	}
141 }
142 
143 contract PonziBaseProcessor is SafeMath, AccessMgr, UserMgr, ItemMgr {
144 	
145 	uint256 public mHostFee = 0;
146 	
147 	event ItemCreated(address host, uint256 itemId);
148 	event ItemBought(address buyer, uint256 itemId, uint256 number, uint256 price, uint256 refund);
149 	
150 	function PonziBaseProcessor() public {
151 		mOwner = msg.sender;
152 	}
153 	
154 	function setHostFee(uint256 hostFee) Owner public {
155 		mHostFee = hostFee;
156 	}
157 	
158 	function createItem(string name, uint256 basePrice, uint256 growthAmount, uint256 growthPeriod) payable public returns (uint256 itemId) {
159 		address sender = msg.sender;
160 		User storage user = mUsers[sender];
161 		uint256 balance = user.balance;
162 		
163 		if (msg.value > 0)
164 			balance = safeAdd(balance, msg.value);
165 		
166 		if (basePrice <= 0)
167 			revert(); // Base price must be non-zero.
168 		
169 		//if (growthAmount <= 0) Allow non-growing items.
170 		//	revert(); // Growth amount must be non-zero.
171 		
172 		if (growthPeriod <= 0)
173 			revert(); // Growth period must be non-zero.
174 		
175 		if (bytes(name).length > 32)
176 			revert(); // Name must be 32 characters max.
177 		
178 		uint256 fee = basePrice;
179 		uint256 minFee = mHostFee;
180 		if (fee < minFee)
181 			fee = minFee;
182 		
183 		if (balance < fee)
184 			revert(); // Insufficient balance.
185 		
186 		uint256 id = mItems.length;
187 		mItems.length++;
188 		
189 		Item storage item = mItems[id];
190 		item.name = name;
191 		item.hostAddress = sender;
192 		item.price = basePrice;
193 		item.numSold = 0;
194 		item.basePrice = basePrice;
195 		item.growthAmount = growthAmount;
196 		item.growthPeriod = growthPeriod;
197 		
198 		item.purchases.push(mOwner);
199 		item.purchases.push(sender);
200 		
201 		balance = safeSubtract(balance, fee);
202 		user.balance = balance;
203 		user.hostedItems.push(id);
204 		user.inventory.push(id);
205 		
206 		User storage owner = mUsers[mOwner];
207 		owner.balance = safeAdd(owner.balance, fee);
208 		
209 		if (mOwner != sender) {
210 			owner.inventory.push(id);
211 		}
212 		
213 		ItemCreated(sender, id);
214 		
215 		return id;
216 	}
217 	
218 	function buyItem(uint256 id) payable public {
219 		address sender = msg.sender;
220 		User storage user = mUsers[sender];
221 		uint256 balance = user.balance;
222 		
223 		if (msg.value > 0)
224 			balance = safeAdd(balance, msg.value);
225 		
226 		Item storage item = mItems[id];
227 		uint256 price = item.price;
228 		
229 		if (price == 0)
230 			revert(); // Item not found.
231 		
232 		if (balance < price)
233 			revert(); // Insufficient balance.
234 		
235 		balance = safeSubtract(balance, price);
236 		user.balance = balance;
237 		user.inventory.push(id);
238 		
239 		uint256 length = item.purchases.length;
240 		
241 		uint256 refund = price;
242 		uint256 dividend = price / length;
243 		for (uint256 i=0; i<length; i++) {
244 			User storage holder = mUsers[item.purchases[i]];
245 			holder.balance = safeAdd(holder.balance, dividend);
246 			refund -= dividend;
247 		}
248 		// Consume the lost fraction when dividing as insurance for the contract,
249 		// but still report the refund value in the event.
250 		// user.balance += refund;
251 		
252 		item.purchases.push(sender);
253 		uint256 numSold = item.numSold++;
254 		
255 		if (item.numSold % item.growthPeriod == 0)
256 			item.price = safeAdd(item.price, item.growthAmount);
257 		
258 		ItemBought(sender, id, numSold, price, refund);
259 	}
260 }