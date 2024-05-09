1 pragma solidity ^0.4.11;
2 
3 contract Interface {
4 
5 	// Ethart network interface
6     function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);		// Registers a new sha256 hash.
7 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered);			// Check if a sha256 hash is registared
8 	function isFactoryApproved (address _factory) returns (bool _approved);						// Check if an address is a registred factory contract
9 	function issuePatrons (address _to, uint256 _amount);										// Issues Patron tokens according to conditions specified in factory contracts
10 
11 	// ERC20 interface
12     function totalSupply() constant returns (uint256 totalSupply);
13 	function balanceOf(address _owner) constant returns (uint256 balance);
14  	function transfer(address _to, uint256 _value) returns (bool success);
15  	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16 	function approve(address _spender, uint256 _value) returns (bool success);
17 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18 
19 	function burn(uint256 _amount) returns (bool success);
20 	function burnFrom(address _from, uint256 _amount) returns (bool success);
21 }
22 
23 contract Artwork {
24 
25 /* 1. Introduction
26 
27 This text is a plain English translation of the smart contract's programming logic and represent its terms of use (terms). This plain English translation is a best effort only and while all reasonable precautions have been taken to ensure that the smart contract will behave in the exact way outlined in these terms, mistakes do happen (see The DAO) which may result in unexpected and unintended contract behaviour which may include the total loss of invested funds (Ether), other tokens sent to it as well as accessibility of the contract itself. Due to the nature of smart contracts, once it is deployed on the blockchain it becomes immutably imbedded in it which means that any bugs and/or exploits discovered after deployment are unfixable. Should the code behave differently than outlined in these terms, the code - by the very nature of smart contracts - takes precedent over the terms. By deploying, interacting or otherwise using the smart contract you acknowledge and accept all associated risks while at the same time waive all rights to hold the creator of the smart contract, the artists who deployed the smart contract, its current owner as well as any other parties responsible for potential damages suffered by or caused by you through your interaction with the smart contract to yourself or others. No backsies.
28 
29 2. Contract deployment
30 
31 This smart contract enables its owner to issue limited edition pieces of art (pieces) that are cryptographically embedded in the Ethereum blockchain. Every piece can be owned, offered for sale, sold, bought, transferred and burned. The contract accepts bid from interested buyers and allows for the cancelation of bids as well as the cancelation of pieces offered for sale and filling of bids. In addition the owner of the contract as well as Ethart will earn a commission for every future sales of pieces irrespective of who owns, buys or sells them using the contract.
32 
33 The contract creation costs approximately 1.7-1.8 Mgas - assuming a gas price of 20 Gwei, contract creation will cost ~0.03-0.034 ETH or about $12 (@$300/ETH) on the Ethereum main net. If contract creation is not urgent and Ethereum's pending transactions pool is not congested gas prices can be lowered to ~4 Gwei which would reduce the cost of deployment to ~$2-$3 per artwork.
34 
35 During creation the contract asks for the following parameters:
36 
37 	- The SHA256 hash of your piece (the cryptographic link of your artwork to the Ethereum blockchain)
38 	- Edition size (the maximum number of pieces you plan to issue)
39 	- Title (the title or name of your artwork, if any)
40 	- The link to your file (if any)
41 	- Custom text
42 	- The owner's commission in basis points (i.e. 1/100th of a percent)
43 
44 SHA256 hash: A SHA256 hash is a fixed length cryptographic digest of a file. On Mac and Linux it can be calculated by opening a terminal window and typing "openssl sha -sha256" followed by a space and the filename (i.e. "openssl sha -sha256 <FILENAME>") one wants to calculate the hash for. An online tool that serves the same purpose can be found at http://hash.online-convert.com/sha256-generator. By the nature of the cryptographic math the resulting hash is a) a unique fingerprint of the input file which can be independently verified by whomever has access to the original file, b) different for (almost) every file as long as at least one bit is different and c) almost impossible to reverse, meaning you can calculate a SHA256 hash from a file very easily but you can not generate the file from the SHA256 hash. Embedding the SHA256 hash in the contract at it's deployment therefore proofs that the limited edition pieces controlled by the smart contract's logic are linked to a particular file: the artwork.
45 
46 Edition size: The edition size is currently limited to a minimum of 1 and a maximum of 1,000 pieces.
47 
48 Title: the title is stored as a public string in the contract
49 
50 File link: So people can independently verify that a particular file is associated with a particular instance of a smart contract you can here specify the publicly accessible link to the file. Note that providing a link is not mandatory and some artists may decide to only provide the SHA256 hash and reveal the actual file associated with it at a later point in time or never.
51 
52 Custom text: This field can be whatever you want it to be. One use case could be a set of custom attributes for limited edition collectible playing cards. In this case you would format your game card attributes in a standard manner for later use e.g. Strength, Constitution, Dexterity, Intelligence, Wisdom as "12,8,6,9,3" which a later application can then read and interpreted according to your game's rules.
53 
54 Owner's commission: the account that deploys the smart contract can set a commission for future sales that will be paid out to the current owner of smart contract. The commission is specified in basis points where 1 basis point equals 0.01%. The commission must be greater than 0 and lower than 9750. If the owner wants to receive 5% for all future sales for example the commission will have to be set as 500.
55 
56 At deployment the owner of the smart contract will be set as the account that deployed it. Please make sure to carefully note down your account details including your address, private key, password, JSON file etc and keep it safe and secret. Remember: whoever has access to this information has access to the contract and all the funds and rights associated with it. If you loose this information it is almost certainly lost forever and your funds and artwork with it. Make at least one backup and keep it in a safe location. After contract deployment it is important for you to carefully note down the contract creation transaction receipt number, contract address and ABI for later reference. You and others will require this information to interact with the contract once it is live.
57 
58 The contract acts as it's own decentralised exchange with an on chain order book of the lowest ask and highest bid for a piece and allows for trustless trade of the pieces of art via the Ethereum blockchain.
59 
60 3. Providing a proof
61 
62 After deployment and before the first pieces can be bought or sold the owner has to provide a proof. This proof demonstrates that the artwork was in fact deployed by the artist. The proof can be in the form of a link to a blog post, a tweet or press release providing at the very least the artwork's contract address or contract creation transaction number.
63 
64 4. Ethart commission
65 
66 The fee for letting you deploy your artworks will be 2.5% of the edition size as well as 2.5% of future revenues. So you basically pay in art. After you have provided the proof, the contract issues 2.5% of the edition size to Ethart automatically as following:
67 
68 - 1 piece for every 40 pieces increase in edition size
69 - a (remainder / 40) chance of an additional piece
70 
71 Example: Say you create a 100 piece limited edition artwork. The contract will then issue at least 2 pieces to Ethart. In addition there will be a 20 in 40 chance (i.e. 50%) that one additional piece will be issued to Ethart. In other words, if you create a limited edition of 1 piece there is a chance of 2.5% that after you provide the proof this one piece will be transferred to Ethart. To avoid disappointment we therefore recommend a minimum edition size of 2 - then you are guaranteed to keep at least one piece with an additional 5% chance of loosing the other. The way the math works out Ethart will on average retain 2.5% of all pieces.
72 
73 The pieces transferred to Ethart can not be sold or transferred by Ethart for a minimum of one year (31,556,926 seconds) giving you plenty of time to monopolise the market.
74 
75 5. Changing the owner
76 
77 The current owner can transfer ownership of the contract to another account.
78 
79 6. Transferring pieces
80 
81 Your artworks is in fact an ERC20 token (https://theethereum.wiki/w/index.php/ERC20_Token_Standard) and supports all ERC20 features. Pieces can be transferred to other addresses (as long as they are not being offered for sale) by their respective owners. Make sure that pieces are only being transferred to accounts that have access to their private keys. Pieces send to exchanges or other accounts that do not have access to their private keys will be lost - most likely forever.
82 
83 7. Offering a piece for sale
84 
85 The owner of a piece can offer it for sale. The price for which it is offered (the ask) has to be lower than the current lowest ask. Once a piece is offered for sale by its owner for a lower price than the currently lowest ask it will become the lowest ask and replace the previous lowest ask. The sale price has to be specified in wei (1000000000000000000 wei = 1 ETH). Offering a piece for sale at an ask that is lower or equal to the highest bid will result in an instant sale for the highest bid.
86 
87 8. Canceling a sale
88 
89 The owner of a piece offered for sale can cancel the sale 24 hours after having offered the piece for sale. The 24 hour limited is intended to prevent owners to offer a piece at an artificially low price, displacing the currently lowest ask and then immediately canceling the sale.
90 
91 10. Buying a piece
92 
93 As long as a piece is being offered for sale, anyone can buy it as long as the buyer sends at least the current lowest ask price with the buy order. Any buy orders that do not send at least the current lowest ask price will be rejects. All the funds send with a buy order will be paid out to the seller of the piece, the contract owner as well as Ethart respectively and in proportion to the commission rules outlined above. There will be no refunds for funds sent in excess of the lowest ask price. Once a piece has been sold the lowest ask will be reset and the next piece offered for sale will become the lowest ask if any. Patrons that buy pieces via the artwork’s smart contract will be issued 2.5 Patron tokens for every Ether spend in the transaction.
94 
95 11. Placing a bid
96 
97 Buyers can place bids in wei (1000000000000000000 wei = 1 ETH). Bids have to be higher than the currently highest bid. Placing a bid that is higher than the current lowest ask price will result in the bidder instantly buying the piece offered by the lowest ask seller for the bid amount.
98 
99 12. Cancelling a bid
100 
101 Bids can be canceled by the buyer 24 hours after they have been placed. The 24 hour limited is intended to prevent buyers from placing an artificially high bid, displacing the currently highest bid and then immediately canceling the bid.
102 
103 13. Filling a bid
104 
105 Bids can be filled by anyone who owns a piece. The contract owner has a 24 hour exclusive first right of refusal to fill a bid.
106 
107 14. Burning a piece
108 
109 The owner of a piece can burn it, removing it permanently from the pool of available pieces and thereby reducing the edition size. Artists may choose to do so to increase the value of the remaining pieces or for any other reason.
110 
111 	(c) Stefan Pernar 2017 - all rights reserved
112 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
113 
114 */
115 
116 /* Public variables */
117 	address public owner;						// Contract owner.
118 	bytes32 public SHA256ofArtwork;				// sha256 hash of the artwork.
119 	uint256 editionSize;						// The edition size of the artwork.
120 	string title;								// The title of the artwork.
121 	string fileLink;							// The link to the file of the artwork.
122 	string public proofLink;					// Link to the creation proof by the artist -> this has to be done after contract creation
123 	string public customText;						// Custom text
124 	uint256 public ownerCommission;				// Percent given to the contract owner for every sale - must be >=0 && <=975 1000 = 100%.
125 	
126 	uint256 public lowestAskPrice;				// The lowest price an owner of a piece is willing to sell it for.
127 	address public lowestAskAddress;			// The address of the lowest ask.
128 	uint256 public lowestAskTime;				// The time by which the ask can be withdrawn.
129 	bool public pieceForSale;					// Is a piece for sale?
130 
131 	uint256 public highestBidPrice;				// The highest price a buyer is willing to pay for a piece.
132 	address public highestBidAddress;			// The address of the highest bidder
133 	uint256 public highestBidTime;				// The time by which the bid can be withdrawn
134 	uint public activationTime;					// Time this contract has been activated.
135 	bool public pieceWanted;					// Is a buyer interested in a piece?
136 
137 	/* Events */
138 	event newLowestAsk (uint256 price, address seller);							// Informs watchers of the contract when a new lowest ask price has been set. (price, seller)
139 	event newHighestBid (uint256 price, address bidder);							// Informs watchers of the contract when a new highest bid price has been placed. (price, bidder)
140 	event pieceTransfered (uint256 amount, address from, address to);				// Informs watchers of the contract when a piece has been transfered. (amount, from, to)
141 	event pieceSold (address from, address to, uint256 price);					// Informs watchers of the contract when a piece has been sold. (from, to, price)
142 
143 	event Transfer (address indexed _from, address indexed _to, uint256 _value);
144 	event Approval (address indexed _owner, address indexed _spender, uint256 _value);
145 	event Burn (address indexed _owner, uint256 _amount);
146 
147 	/* Other variables */
148 	bool proofSet;							// Has the proof been set yet?
149 	uint256 ethartAward;					// # of pieces awarded to Ethart.
150 
151 	mapping (address => uint256) public piecesOwned;				// Maps the number of pieces owned by an address
152  	mapping (address => mapping (address => uint256)) allowed;		// Used in burnFrom and transferFrom
153     address registrar = 0x562b85ACEEE81876D27252B7dc06f03F6A2565fc;						// set after deployment of Registrar contract
154 
155 	function Artwork (								// Constructor
156 		bytes32 _SHA256ofArtwork,
157 		uint256 _editionSize,
158 		string _title,
159 		string _fileLink,
160 		string _customText,
161 		uint256 _ownerCommission,
162 		address _owner
163 	) {
164 		if (_ownerCommission > 9750 || _ownerCommission <0) {throw;}
165 		owner = _owner;                            // Owner is set as the address spawning the contract
166 		SHA256ofArtwork = _SHA256ofArtwork;
167 		editionSize = _editionSize;
168 		title = _title;
169 		fileLink = _fileLink;
170 		customText = _customText;
171 		ownerCommission = _ownerCommission;
172 		activationTime = now;	
173 	}
174 
175     modifier onlyBy(address _account)
176     {
177         require(msg.sender == _account);
178         _;
179     }
180 
181 	modifier ethArtOnlyAfterOneYear()
182 	{
183 		require(msg.sender != registrar || now > activationTime + 31536000);
184 		_;
185 	}
186 
187 	modifier ownerFirst()
188 	{
189 		require(msg.sender == owner || now > highestBidTime + 86400 || piecesOwned[owner] == 0);
190 		_;
191 	}
192 
193 	modifier notLocked(address _owner, uint256 _amount)
194 	{
195 		require(_owner != lowestAskAddress || piecesOwned[_owner] > _amount);
196 		_;
197 	}
198 
199 	// allows the current owner to assign a new owner
200 	function changeOwner (address newOwner) onlyBy (owner) {
201 		owner = newOwner;
202 		}
203 
204 	function setProof (string _proofLink) onlyBy (owner) {
205 		if (!proofSet) {
206 			uint256 remainder;
207 			proofLink = _proofLink;
208 			proofSet = true;
209 			remainder = editionSize % 40;
210 			ethartAward = (editionSize - remainder) / 40;
211 			if (remainder > 0 && now % 39 <= remainder) {ethartAward++;}		// Yes - this is gameable - if it is that important to you: go ahead.
212 			piecesOwned[registrar] = ethartAward;
213 			piecesOwned[owner] = editionSize - ethartAward;
214 			}
215 		else {throw;}
216 		}
217 
218 	function transfer(address _to, uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
219 		if (piecesOwned[msg.sender] >= _amount 
220 			&& _amount > 0
221 			&& piecesOwned[_to] + _amount > piecesOwned[_to]
222 			&& _to != 0x0)																// use burn() instead
223 			{
224 			piecesOwned[msg.sender] -= _amount;
225 			piecesOwned[_to] += _amount;
226 			Transfer(msg.sender, _to, _amount);
227 			return true;
228 			}
229 			else { return false;}
230  		 }
231 
232     function totalSupply() constant returns (uint256 totalSupply) {
233 		totalSupply = editionSize;
234 		}
235 
236 	function balanceOf(address _owner) constant returns (uint256 balance) {
237  		return piecesOwned[_owner];
238 		}
239 
240  	function transferFrom(address _from, address _to, uint256 _amount) notLocked(_from, _amount) returns (bool success)
241 		{
242 			if (piecesOwned[_from] >= _amount
243 				&& allowed[_from][msg.sender] >= _amount
244 				&& _amount > 0
245 				&& piecesOwned[_to] + _amount > piecesOwned[_to]
246 				&& _to != 0x0															// use burn() instead
247 				&& (_from != lowestAskAddress || piecesOwned[_from] > _amount))
248 					{
249 					piecesOwned[_from] -= _amount;
250 					allowed[_from][msg.sender] -= _amount;
251 					piecesOwned[_to] += _amount;
252 					Transfer(_from, _to, _amount);
253 					return true;
254 					} else {return false;}
255 		}
256 
257 	function approve(address _spender, uint256 _amount) returns (bool success) {
258 		allowed[msg.sender][_spender] = _amount;
259 		Approval(msg.sender, _spender, _amount);
260 		return true;
261 		}
262 
263 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
264 		return allowed[_owner][_spender];
265 		}
266 
267 	function burn(uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
268 			if (piecesOwned[msg.sender] >= _amount) {
269 				piecesOwned[msg.sender] -= _amount;
270 				editionSize -= _amount;
271 				Burn(msg.sender, _amount);
272 				return true;
273 			}
274 			else {throw;}
275 		}
276 
277 	function burnFrom(address _from, uint256 _value) notLocked(_from, _value) returns (bool success) {
278 		if (piecesOwned[_from] >= _value && allowed[_from][msg.sender] >= _value) {
279 			piecesOwned[_from] -= _value;
280 			allowed[_from][msg.sender] -= _value;
281 			editionSize -= _value;
282 			Burn(_from, _value);
283 			return true;
284 		}
285 		else {throw;}
286 	}
287 
288 	function buyPiece() payable {
289 		if (pieceForSale && msg.value >= lowestAskPrice) {
290 			uint256 _amountOwner;
291 			uint256 _amountEthart;
292 			uint256 _amountSeller;
293 			_amountOwner = msg.value / 10000 * ownerCommission;
294 			_amountEthart = msg.value / 40;
295 			_amountSeller = msg.value - _amountOwner - _amountEthart;
296 			owner.transfer(_amountOwner);									// Transfer the contract owner's commission
297 			lowestAskAddress.transfer(_amountSeller);						// Transfer the buy price - commissions to seller
298 			registrar.transfer(_amountEthart);								// Transfer Ethart comission to Ethart
299 			piecesOwned[lowestAskAddress]--;
300 			piecesOwned[msg.sender]++;
301 			Interface a = Interface(registrar);
302 			a.issuePatrons(msg.sender, msg.value / 5 * 2);
303 			pieceSold (lowestAskAddress, msg.sender, msg.value);
304 			pieceForSale = false;
305 			lowestAskPrice = 0;
306 			lowestAskAddress = 0x0;
307 		}
308 		else {throw;}
309 	}
310 
311 	// Offer a piece for sale at a fixed price - the price has to be lower than the current lowest price
312 	function offerPieceForSale (uint256 _price) ethArtOnlyAfterOneYear {
313 		if (_price < lowestAskPrice || !pieceForSale) {
314 				if (_price <= highestBidPrice) {fillBid();}
315 				else {
316 				pieceForSale = true;
317 				lowestAskPrice = _price;
318 				lowestAskAddress = msg.sender;
319 				lowestAskTime = now;
320 				newLowestAsk (_price, lowestAskAddress);			// alerts contract watchers about new lowest ask price.
321 				}
322 		}
323 		else {throw;}
324 	}
325 
326 	// place a bid for any piece in the edition - bid has to be higher than current highest bid
327 	function placeBid () payable {
328 		if (msg.value > highestBidPrice || (pieceForSale && msg.value >= lowestAskPrice)) {
329 			if (pieceWanted) {highestBidAddress.transfer (highestBidPrice);}
330 			if (pieceForSale && msg.value >= lowestAskPrice) {buyPiece();}
331 			else {
332 				pieceWanted = true;
333 				highestBidPrice = msg.value;
334 				highestBidAddress = msg.sender;
335 				highestBidTime = now;
336 				newHighestBid (msg.value, highestBidAddress);
337 				}
338 		}
339 		else {throw;}
340 	}
341 
342 	function fillBid () ownerFirst ethArtOnlyAfterOneYear notLocked(msg.sender, 1) {	// Owner has 24h first right of refusual to fill the bid. Ethart can only fill bids after 1 year.
343 		if (pieceWanted && piecesOwned[msg.sender] >= 1) {								// If the current lowest ask address wants to fill a bid it has to cancel it's sale first and then
344 			uint256 _amountOwner;														// fill the bid.
345 			uint256 _amountEthart;
346 			uint256 _amountSeller;
347 			uint256 patronReward;
348 			_amountOwner = highestBidPrice / 10000 * ownerCommission;
349 			_amountEthart = highestBidPrice / 40;
350 			_amountSeller = highestBidPrice - _amountOwner - _amountEthart;
351 			owner.transfer(_amountOwner);									// Transfer the contract's owner's commission
352 			msg.sender.transfer(_amountSeller);								// Transfer the buy price - commissions to seller
353 			registrar.transfer(_amountEthart);								// Transfer Ethart comission to Ethart
354 			piecesOwned[highestBidAddress]++;
355 			Interface a = Interface(registrar);
356 			patronReward = highestBidPrice  / 5 * 2;
357 			a.issuePatrons(highestBidAddress, patronReward);				
358 			piecesOwned[msg.sender]--;
359 			pieceSold (msg.sender, highestBidAddress, highestBidPrice);
360 			pieceWanted = false;
361 			highestBidPrice = 0;
362 			highestBidAddress = 0x0;
363 		}
364 		else {throw;}
365 	}
366 
367 	// withdraw a bid - bids can only be withdrawn after 24 hours of being placed
368 	function cancelBid () onlyBy (highestBidAddress){
369 		if (pieceWanted && now > highestBidTime + 86400) {
370 			pieceWanted = false;
371 			msg.sender.transfer(highestBidPrice);
372 			highestBidPrice = 0;
373 			highestBidAddress = 0x0;
374 			newHighestBid (0, 0x0);
375 		}
376 		else {throw;}
377 	}
378 
379 	// cancels sales - sales can only be canceled 24 hours after it has been offered for sale
380 	function cancelSale () onlyBy (lowestAskAddress){
381 		if(pieceForSale && now > lowestAskTime + 86400) {
382 			pieceForSale = false;
383 			lowestAskPrice = 0;
384 			lowestAskAddress = 0x0;
385 			newLowestAsk (0, 0x0);
386 		}
387 		else {throw;}
388 	}
389 
390 }