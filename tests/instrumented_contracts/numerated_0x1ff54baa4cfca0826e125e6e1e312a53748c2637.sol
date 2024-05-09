1 pragma solidity ^0.4.18;
2 
3 //
4 // LimeEyes
5 // Decentralized art on the Ethereum blockchain!
6 // (https://limeeyes.com/)
7 /*
8              ___                  ___        
9          .-''   ''-.          .-''   ''-.    
10        .'           '.      .'           '.  
11       /   . -  ;  - . \    /   . -  ;  - . \ 
12      (  ' `-._|_,'_,.- )  (  ' `-._|_,'_,.- )
13       ',,.--_,4"-;_  ,'    ',,.--_,4"-;_  ,' 
14         '-.;   \ _.-'        '-.;   \ _.-'   
15             '''''                '''''       
16 */
17 // Welcome to LimeEyes!
18 //
19 // This smart contract allows users to purchase shares of any artwork that's
20 // been added to the system and it will pay dividends to all shareholders
21 // upon the purchasing of new shares! It's special in the way it works because
22 // the shares can only be bought in certain amounts and the price of those 
23 // shares is dependant on how many other shares there are already. Each
24 // artwork starts with 1 share available for purchase and upon each sale,
25 // the number of shares for purchase will increase by one (1 -> 2 -> 3...),
26 // each artwork also has an owner and they will always get the dividends from 
27 // the number of shares up for purchase, for example;
28 /*
29     If the artwork has had shares purchased 4 times, the next purchase will
30     be for 5 shares of the artwork. Upon the purchasing of these shares, the
31     owner will receive the dividends equivelent to 5 shares worth of the sale
32     value. It's also important to note that the artwork owner cannot purchase
33     shares of their own art, instead they just inherit the shares for purchase
34     and pass it onto the next buyer at each sale.
35 */ 
36 // The price of the shares also follows a special formula in order to maintain
37 // stability over time, it uses the base price of an artwork (set by the dev 
38 // upon the creation of the artwork) and the total number of shares purchased
39 // of the artwork. From here you simply treat the number of shares as a percentage
40 // and add that much on top of your base price, for example;
41 /*
42     If the artwork has a base price of 0.01 ETH and there have been 250 shares 
43     purchased so far, it would mean that the base price will gain 250% of it's
44     value which comes to 0.035 ETH (100% + 250% of the base price).
45 */
46 // The special thing about this is because the shares are intrinsicly linked with
47 // the price, the dividends from your shares will trend to a constant value instead
48 // of continually decreasing over time. Because our sequence of shares is a triangular
49 // number (1 + 2 + 3...) the steady state of any purchased shares will equal the number
50 // of shares owned (as a percentage) * the artworks base price, for example;
51 /*
52     If the artwork has a base price of 0.01 ETH and you own 5 shares, in the long run
53     you should expect to see 5% * 0.01 ETH = 0.0005 ETH each time the artwork has any
54     shares purchased. In contrast, if you own 250 shares of the artwork, you should 
55     expect to see 250% * 0.01 ETH = 0.025 ETH each time the artwork has shares bought.
56   
57     It's good to point out that if you were the first buyer and owned 1 share, the next
58     buyer is going to be purchasing 2 shares which means you have 1 out of the 3 shares
59     total and hence you will receive 33% of that sale, at the next step there will be
60     6 shares total and your 1 share is now worth 16% of the sale price, as mentioned
61     above though, your earnings upon the purchasing of new shares from your original
62     1 share will trend towards 1% of the base price over a long period of time.
63 */
64 //
65 // If you're an artist and are interested in listing some of your works on the site
66 // and in this contract, please visit the website (https://limeeyes.com/) and contact
67 // the main developer via the links on the site!
68 //
69 
70 contract LimeEyes {
71 
72 	//////////////////////////////////////////////////////////////////////
73 	//  Variables, Storage and Events
74 
75 
76 	address private _dev;
77 
78 	struct Artwork {
79 		string _title;
80 		address _owner;
81 		bool _visible;
82 		uint256 _basePrice;
83 		uint256 _purchases;
84 		address[] _shareholders;
85 		mapping (address => bool) _hasShares;
86 		mapping (address => uint256) _shares;
87 	}
88 	Artwork[] private _artworks;
89 
90 	event ArtworkCreated(
91 		uint256 artworkId,
92 		string title,
93 		address owner,
94 		uint256 basePrice);
95 	event ArtworkSharesPurchased(
96 		uint256 artworkId,
97 		string title,
98 		address buyer,
99 		uint256 sharesBought);
100 
101 
102 	//////////////////////////////////////////////////////////////////////
103 	//  Constructor and Admin Functions
104 
105 
106 	function LimeEyes() public {
107 		_dev = msg.sender;
108 	}
109 
110 	modifier onlyDev() {
111 		require(msg.sender == _dev);
112 		_;
113 	}
114 
115 	// This function will create a new artwork within the contract,
116 	// the title is changeable later by the dev but the owner and
117 	// basePrice cannot be changed once it's been created.
118 	// The owner of the artwork will start off with 1 share and any
119 	// other addresses may now purchase shares for it.
120 	function createArtwork(string title, address owner, uint256 basePrice) public onlyDev {
121 
122 		require(basePrice != 0);
123 		_artworks.push(Artwork({
124 			_title: title,
125 			_owner: owner,
126 			_visible: true,
127 			_basePrice: basePrice,
128 			_purchases: 0,
129 			_shareholders: new address[](0)
130 		}));
131 		uint256 artworkId = _artworks.length - 1;
132 		Artwork storage newArtwork = _artworks[artworkId];
133 		newArtwork._hasShares[owner] = true;
134 		newArtwork._shareholders.push(owner);
135 		newArtwork._shares[owner] = 1;
136 
137 		ArtworkCreated(artworkId, title, owner, basePrice);
138 
139 	}
140 
141 	// Simple renaming function for the artworks, it is good to
142 	// keep in mind that when the website syncs with the blockchain,
143 	// any titles over 32 characters will be clipped.
144 	function renameArtwork(uint256 artworkId, string newTitle) public onlyDev {
145 		
146 		require(_exists(artworkId));
147 		Artwork storage artwork = _artworks[artworkId];
148 		artwork._title = newTitle;
149 
150 	}
151 
152 	// This function is only for the website and whether or not
153 	// it displays a certain artwork, any user may still buy shares
154 	// for an invisible artwork although it's not really art unless
155 	// you can view it.
156 	// This is exclusively reserved for copyright cases should any
157 	// artworks be flagged as such.
158 	function toggleArtworkVisibility(uint256 artworkId) public onlyDev {
159 		
160 		require(_exists(artworkId));
161 		Artwork storage artwork = _artworks[artworkId];
162 		artwork._visible = !artwork._visible;
163 
164 	}
165 
166 	// The two withdrawal functions below are here so that the dev
167 	// can access the dividends of the contract if it owns any
168 	// artworks. As all ETH is transferred straight away upon the
169 	// purchasing of shares, the only ETH left in the contract will
170 	// be from dividends or the rounding errors (although the error
171 	// will only be a few wei each transaction) due to the nature
172 	// of dividing and working with integers.
173 	function withdrawAmount(uint256 amount, address toAddress) public onlyDev {
174 
175 		require(amount != 0);
176 		require(amount <= this.balance);
177 		toAddress.transfer(amount);
178 
179 	}
180 
181 	// Used to empty the contracts balance to an address.
182 	function withdrawAll(address toAddress) public onlyDev {
183 		toAddress.transfer(this.balance);
184 	}
185 
186 
187 	//////////////////////////////////////////////////////////////////////
188 	//  Main Artwork Share Purchasing Function
189 
190 
191 	// This is the main point of interaction in this contract,
192 	// it will allow a user to purchase shares in an artwork
193 	// and hence with their investment, they pay dividends to
194 	// all the current shareholders and then the user themselves
195 	// will become a shareholder and earn dividends on any future
196 	// purchases of shares.
197 	// See the getArtwork() function for more information on pricing
198 	// and how shares work.
199 	function purchaseSharesOfArtwork(uint256 artworkId) public payable {
200 
201 		// This makes sure only people, and not contracts, can buy shares.
202 		require(msg.sender == tx.origin);
203 
204 		require(_exists(artworkId));
205 		Artwork storage artwork = _artworks[artworkId];
206 
207 		// The artwork owner is not allowed to purchase shares of their
208 		// own art, instead they will earn dividends automatically.
209 		require(msg.sender != artwork._owner);
210 
211 		uint256 totalShares;
212 		uint256[3] memory prices;
213 		( , , , prices, totalShares, , ) = getArtwork(artworkId);
214 		uint256 currentPrice = prices[1];
215 
216 		// Make sure the buyer sent enough ETH
217 		require(msg.value >= currentPrice);
218 
219 		// Send back the excess if there's any.
220 		uint256 purchaseExcess = msg.value - currentPrice;
221 		if (purchaseExcess > 0)
222 			msg.sender.transfer(purchaseExcess);
223 
224 		// Now pay all the shareholders accordingly.
225 		// (this will potentially cost a lot of gas)
226 		for (uint256 i = 0; i < artwork._shareholders.length; i++) {
227 			address shareholder = artwork._shareholders[i];
228 			if (shareholder != address(this)) { // transfer ETH if the shareholder isn't this contract
229 				shareholder.transfer((currentPrice * artwork._shares[shareholder]) / totalShares);
230 			}
231 		}
232 
233 		// Add the buyer to the registry.
234 		if (!artwork._hasShares[msg.sender]) {
235 			artwork._hasShares[msg.sender] = true;
236 			artwork._shareholders.push(msg.sender);
237 		}
238 
239 		artwork._purchases++; // track our purchase
240 		artwork._shares[msg.sender] += artwork._purchases; // add the shares to the sender
241 		artwork._shares[artwork._owner] = artwork._purchases + 1; // set the owners next shares
242 
243 		ArtworkSharesPurchased(artworkId, artwork._title, msg.sender, artwork._purchases);
244 		
245 	}
246 
247 
248 	//////////////////////////////////////////////////////////////////////
249 	//  Getters
250 
251 
252 	function _exists(uint256 artworkId) private view returns (bool) {
253 		return artworkId < _artworks.length;
254 	}
255 
256 	function getArtwork(uint256 artworkId) public view returns (string artworkTitle, address ownerAddress, bool isVisible, uint256[3] artworkPrices, uint256 artworkShares, uint256 artworkPurchases, uint256 artworkShareholders) {
257 		
258 		require(_exists(artworkId));
259 
260 		Artwork memory artwork = _artworks[artworkId];
261 
262 		// As at each step we are simply increasing the number of shares given by 1, the resulting
263 		// total from adding up consecutive numbers from 1 is the same as the triangular number
264 		// series (1 + 2 + 3 + ...). the formula for finding the nth triangular number is as follows;
265 		// Tn = (n * (n + 1)) / 2
266 		// For example the 10th triangular number is (10 * 11) / 2 = 55
267 		// In our case however, the owner of the artwork always inherits the shares being bought
268 		// before transferring them to the buyer but the owner cannot buy shares of their own artwork.
269 		// This means that when calculating how many shares, we need to add 1 to the total purchases
270 		// in order to accommodate for the owner. from here we just need to adjust the triangular
271 		// number formula slightly to get;
272 		// Shares After n Purchases = ((n + 1) * (n + 2)) / 2
273 		// Let's say the art is being purchased for a second time which means the purchaser is
274 		// buying 3 shares and therefore the owner will get 3 shares worth of dividends from the
275 		// overall purchase value. As it's the 2nd purchase, there are (3 * 4) / 2 = 6 shares total
276 		// according to our formula which is as expected.
277 		uint256 totalShares = ((artwork._purchases + 1) * (artwork._purchases + 2)) / 2;
278 
279 		// Set up our prices array;
280 		// 0: base price
281 		// 1: current price
282 		// 2: next price
283 		uint256[3] memory prices;
284 		prices[0] = artwork._basePrice;
285 		// The current price is also directly related the total number of shares, it simply treats
286 		// the total number of shares as a percentage and adds that much on top of the base price.
287 		// For example if the base price was 0.01 ETH and there were 250 shares total it would mean
288 		// that the price would gain 250% of it's value = 0.035 ETH (100% + 250%);
289 		// Current Price = (Base Price * (100 + Total Shares)) / 100
290 		prices[1] = (prices[0] * (100 + totalShares)) / 100;
291 		// The next price would just be the same as the current price but we have a few extra shares.
292 		// If there are 0 purchases then you are buying 1 share (purchases + 1) so the next buyer would
293 		// be purchasing 2 shares (purchases + 2) so therefore;
294 		prices[2] = (prices[0] * (100 + totalShares + (artwork._purchases + 2))) / 100;
295 
296 		return (
297 				artwork._title,
298 				artwork._owner,
299 				artwork._visible,
300 				prices,
301 				totalShares,
302 				artwork._purchases,
303 				artwork._shareholders.length
304 			);
305 
306 	}
307 
308 	function getAllShareholdersOfArtwork(uint256 artworkId) public view returns (address[] shareholders, uint256[] shares) {
309 
310 		require(_exists(artworkId));
311 
312 		Artwork storage artwork = _artworks[artworkId];
313 
314 		uint256[] memory shareholderShares = new uint256[](artwork._shareholders.length);
315 		for (uint256 i = 0; i < artwork._shareholders.length; i++) {
316 			address shareholder = artwork._shareholders[i];
317 			shareholderShares[i] = artwork._shares[shareholder];
318 		}
319 
320 		return (
321 				artwork._shareholders,
322 				shareholderShares
323 			);
324 
325 	}
326 
327 	function getAllArtworks() public view returns (bytes32[] titles, address[] owners, bool[] isVisible, uint256[3][] artworkPrices, uint256[] artworkShares, uint256[] artworkPurchases, uint256[] artworkShareholders) {
328 
329 		bytes32[] memory allTitles = new bytes32[](_artworks.length);
330 		address[] memory allOwners = new address[](_artworks.length);
331 		bool[] memory allIsVisible = new bool[](_artworks.length);
332 		uint256[3][] memory allPrices = new uint256[3][](_artworks.length);
333 		uint256[] memory allShares = new uint256[](_artworks.length);
334 		uint256[] memory allPurchases = new uint256[](_artworks.length);
335 		uint256[] memory allShareholders = new uint256[](_artworks.length);
336 
337 		for (uint256 i = 0; i < _artworks.length; i++) {
338 			string memory tmpTitle;
339 			(tmpTitle, allOwners[i], allIsVisible[i], allPrices[i], allShares[i], allPurchases[i], allShareholders[i]) = getArtwork(i);
340 			allTitles[i] = stringToBytes32(tmpTitle);
341 		}
342 
343 		return (
344 				allTitles,
345 				allOwners,
346 				allIsVisible,
347 				allPrices,
348 				allShares,
349 				allPurchases,
350 				allShareholders
351 			);
352 
353 	}
354 
355 	function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
356 		bytes memory tmpEmptyStringTest = bytes(source);
357 		if (tmpEmptyStringTest.length == 0) {
358 			return 0x0;
359 		}
360 
361 		assembly {
362 			result := mload(add(source, 32))
363 		}
364 	}
365 
366 	
367 	//////////////////////////////////////////////////////////////////////
368 
369 }