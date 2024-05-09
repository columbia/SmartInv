1 pragma solidity ^0.4.13;
2 
3 contract NumberBoard {
4 
5 	struct ANumberCard {
6 		address			owner;
7 		uint			lookupIdx;
8 		string  		theMessage;
9 		bool			buyNowActive;
10 		uint 			buyNowPrice;
11 		address			currentBidder;
12 		uint			currentBid;
13 	}
14 
15 	mapping(uint => ANumberCard) 	public ownership;
16 	mapping(address => uint[]) 		public ownershipLookup;
17 
18 	uint constant					public minPrice = 1 finney;
19 	uint							public houseEarnings;
20 	mapping(address => uint)		public earnings;
21 	mapping(address => uint)		public deadbids;
22 
23 	address houseOwner;
24 
25 	event NumberTaken(uint indexed number);
26 	event PriceSet(uint indexed number, uint price);
27 	event BidPlaced(uint indexed number, uint price);
28 	event BidCanceled(uint indexed number, uint price);
29 	event BidAccepted(uint indexed number, uint price);
30 	event PriceAccepted(uint indexed number, uint price);
31 
32 	function NumberBoard() {
33 		houseOwner = msg.sender;
34 	}
35 
36 	function isOwner(address addr, uint theNum) constant returns (bool) {
37 		return ownership[theNum].owner == addr;
38 	}
39 
40 	function hasOwner(uint theNum) constant returns (bool) {
41 		return ownership[theNum].owner > 0;
42 	}
43 
44 	function ownedNumbers(address addr) constant returns (uint[]) {
45 		uint l = ownershipLookup[addr].length;
46 		uint[] memory ret = new uint[](l);
47 		for (uint i = 0; i < l; i++) {
48 			ret[i] = ownershipLookup[addr][i];
49 		}
50 		return ret;
51 	}
52 
53 	function takeNumber(uint theNum) {
54 		require(!hasOwner(theNum));
55 		require(!isOwner(msg.sender, theNum));
56 
57 		ownership[theNum] = ANumberCard(msg.sender, 0, "", false, 0, 0, 0);
58 		ownershipLookup[msg.sender].push(theNum);
59 		ownership[theNum].lookupIdx = ownershipLookup[msg.sender].length - 1;
60 
61 		NumberTaken(theNum);
62 	}
63 
64 	function transferNumberOwnership(uint theNum, address from, address to) private {
65 		require(isOwner(from, theNum));
66 
67 		ANumberCard storage card = ownership[theNum];
68 
69 		card.owner = to;
70 		uint len = ownershipLookup[from].length;
71 		ownershipLookup[from][card.lookupIdx] = ownershipLookup[from][len - 1];
72 		ownershipLookup[from].length--;
73 
74 		ownershipLookup[to].push(theNum);
75 		ownership[theNum].lookupIdx = ownershipLookup[to].length - 1;
76 	}
77 
78 	function updateMessage(uint theNum, string aMessage) {
79 		require(isOwner(msg.sender, theNum));
80 
81 		ownership[theNum].theMessage = aMessage;
82 	}
83 
84 //---------------------
85 // Buy now
86 //---------------------
87 
88 	function hasBuyNowOffer(uint theNum) constant returns (bool) {
89 		return ownership[theNum].buyNowActive;
90 	}
91 
92 	function canAcceptBuyNow(uint theNum, address buyer) constant returns (bool) {
93 		return ownership[theNum].owner != buyer && hasBuyNowOffer(theNum);
94 	}
95 
96 	function placeBuyNowOffer(uint theNum, uint price) {
97 		require(isOwner(msg.sender, theNum));
98 		require(price >= minPrice);
99 
100 		ANumberCard storage numCard = ownership[theNum];
101 		numCard.buyNowPrice = price;
102 		numCard.buyNowActive = true;
103 
104 		PriceSet(theNum, price);
105 	}
106 
107 	function cancelBuyNowOffer(uint theNum) {
108 		require(isOwner(msg.sender, theNum));
109 		cancelBuyNowOfferInternal(ownership[theNum]);
110 	}
111 
112 	function acceptBuyNowOffer(uint theNum) payable {
113 		require (canAcceptBuyNow(theNum, msg.sender));
114 		ANumberCard storage numCard = ownership[theNum];
115 		require (msg.value == numCard.buyNowPrice);
116 
117 		addEarnings(msg.value, numCard.owner);
118 		cancelBidInternal(theNum);
119 
120 		transferNumberOwnership(theNum, numCard.owner, msg.sender);
121 		cancelBuyNowOfferInternal(numCard);
122 
123 		PriceAccepted(theNum, msg.value);
124 	}
125 
126 	function cancelBuyNowOfferInternal(ANumberCard storage numCard) private {
127 		numCard.buyNowPrice = 0;
128 		numCard.buyNowActive = false;		
129 	}
130 
131 //---------------------
132 // Bidding
133 //---------------------
134 
135 	function placeNewBid(uint theNum) payable {
136 		require(hasOwner(theNum));
137 		require(!isOwner(msg.sender, theNum));
138 		require(msg.value >= minPrice);
139 
140 		ANumberCard storage numCard = ownership[theNum];
141 		require(msg.value > numCard.currentBid + minPrice);
142 
143 		deadbids[numCard.currentBidder] += numCard.currentBid;
144 
145 		numCard.currentBid = msg.value;
146 		numCard.currentBidder = msg.sender;
147 
148 		BidPlaced(theNum, msg.value);
149 	}
150 
151 	function cancelBid(uint theNum) {
152 		ANumberCard storage numCard = ownership[theNum];
153 		require(msg.sender == numCard.currentBidder);
154 
155 		uint amount = numCard.currentBid;
156 		cancelBidInternal(theNum);
157 		BidCanceled(theNum, amount);
158 	}
159 
160 	function cancelBidInternal(uint theNum) private {
161 		ANumberCard storage numCard = ownership[theNum];
162 		deadbids[numCard.currentBidder] += numCard.currentBid;
163 		numCard.currentBid = 0;
164 		numCard.currentBidder = 0;
165 	}
166 
167 	function acceptBid(uint theNum) {
168 		require(isOwner(msg.sender, theNum));
169 
170 		ANumberCard storage numCard = ownership[theNum];
171 		require(numCard.currentBid > 0);
172 		require(numCard.currentBidder != 0);
173 
174 		uint amount = numCard.currentBid;
175 		addEarnings(amount, numCard.owner);
176 		transferNumberOwnership(theNum, numCard.owner, numCard.currentBidder);
177 
178 		numCard.currentBidder = 0;
179 		numCard.currentBid = 0;
180 
181 		BidAccepted(theNum, amount);
182 	}
183 
184 	function addEarnings(uint amount, address to) private {
185 		uint interest = amount / 100;
186 		earnings[to] += amount - interest;
187 		houseEarnings += interest;
188 	}
189 
190 	function withdrawDeadBids() {
191  		uint amount = deadbids[msg.sender];
192         deadbids[msg.sender] = 0;
193         msg.sender.transfer(amount);
194 	}
195 
196 	function withdrawEarnings() {
197  		uint amount = earnings[msg.sender];
198         earnings[msg.sender] = 0;
199         msg.sender.transfer(amount);
200 	}
201 
202 	function withdrawHouseEarnings() {
203 		require(msg.sender == houseOwner);
204 
205 		uint amount = houseEarnings;
206 		houseEarnings = 0;
207         msg.sender.transfer(amount);
208 	}
209 }