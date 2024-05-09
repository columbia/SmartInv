1 pragma solidity ^0.4.11;
2 
3 /* Ethart unindexed Factory Contract:
4 
5 	Ethart ARCHITECTURE
6 	-------------------
7 						_________________________________________
8 						V										V
9 	Controller --> Registrar <--> Factory Contract1 --> Artwork Contract1
10 								  Factory Contract2	    Artwork Contract2
11 								  		...					...
12 								  Factory ContractN	    Artwork ContractN
13 
14 	Controller: The controler contract is the owner of the Registrar contract and can
15 		- Set a new owner
16 		- Controll the assets of the Registrar (withdraw ETH, transfer, sell, burn pieces owned by the Registrar)
17 		- The plan is to replace the controller contract with a DAO in preperation for a possible ICO
18 	
19 	Registrar:
20 		- The Registrar contract atcs as the central registry for all sha256 hashes in the Ethart factory contract network.
21 		- Approved Factory Contracts can register sha256 hashes using the Registrar interface.
22 		- 2.5% of the art produced and 2.5% of turnover of the contract network will be transfered to the Registrar.
23 	
24 	Factory Contracts:
25 		- Factory Contracts can spawn Artwork Contracts in line with artists specifications
26 		- Factory Contracts will only spawn Artwork Contracts who's sha256 hashes are unique per the Registrar's sha256 registry
27 		- Factory Contracts will register every new Artwork Contract with it's details with the Registrar contract
28 	
29 	Artwork Contracts:
30 		- Artwork Contracts act as minimalist decentralized exchanges for their pieces in line with specified conditions
31 		- Artwork Contracts will interact with the Registrar to issue buyers of pieces a predetermined amount of Patron tokens based on the transaction value 
32 		- Artwork Contracts can be interacted with by the Controller via the Registrar using their interfaces to transfer, sell, burn etc pieces
33 	
34 	(c) Stefan Pernar 2017 - all rights reserved
35 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
36 
37 Artworks created with this factory have the following ABI:
38 
39 [{"constant":true,"inputs":[],"name":"pieceForSale","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ownerCommission","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_proofLink","type":"string"}],"name":"setProof","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"proofLink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"fillBid","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint256"}],"name":"burn","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancelBid","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"changeOwner","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"pieceWanted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"SHA256ofArtwork","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_price","type":"uint256"}],"name":"offerPieceForSale","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"buyPiece","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"activationTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"piecesOwned","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancelSale","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"placeBid","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"_SHA256ofArtwork","type":"bytes32"},{"name":"_editionSize","type":"uint256"},{"name":"_title","type":"string"},{"name":"_fileLink","type":"string"},{"name":"_ownerCommission","type":"uint256"},{"name":"_owner","type":"address"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"seller","type":"address"}],"name":"newLowestAsk","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"bidder","type":"address"}],"name":"newHighestBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"}],"name":"pieceTransfered","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"price","type":"uint256"}],"name":"pieceSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Burn","type":"event"}]
40 
41 */
42 
43 contract Interface {
44 
45 	// Ethart network interface
46     function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);		// Registers a new sha256 hash.
47 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered);			// Check if a sha256 hash is registared
48 	function isFactoryApproved (address _factory) returns (bool _approved);						// Check if an address is a registred factory contract
49 	function issuePatrons (address _to, uint256 _amount);										// Issues Patron tokens according to conditions specified in factory contracts
50 
51 	// ERC20 interface
52     function totalSupply() constant returns (uint256 totalSupply);
53 	function balanceOf(address _owner) constant returns (uint256 balance);
54  	function transfer(address _to, uint256 _value) returns (bool success);
55  	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
56 	function approve(address _spender, uint256 _value) returns (bool success);
57 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
58 
59 	function burn(uint256 _amount) returns (bool success);
60 	function burnFrom(address _from, uint256 _amount) returns (bool success);
61 }
62 
63 contract Factory {
64 
65   // index of created artworks
66 
67   address[] public artworks;
68 
69   // Registrar contract address
70 
71   address registrar = 0x562b85ACEEE81876D27252B7dc06f03F6A2565fc;   // set after deployment of Registrar contract
72 
73   // useful to know the row count in artworks index
74 
75   function getContractCount() 
76     public
77     constant
78     returns(uint contractCount)
79   {
80     return artworks.length;
81   }
82 
83   // deploy a new contract
84 
85   function newArtwork (bytes32 _SHA256ofArtwork, uint256 _editionSize, string _title, string _fileLink, string _customText, uint256 _ownerCommission) public returns (address newArt)
86   {
87 	Interface a = Interface(registrar);
88 	if (!a.isSHA256HashRegistered(_SHA256ofArtwork) && a.isFactoryApproved(this)) {
89 		Artwork c = new Artwork(_SHA256ofArtwork, _editionSize, _title, _fileLink, _customText, _ownerCommission, msg.sender);
90 		artworks.push(c);
91 		a.registerArtwork(c, _SHA256ofArtwork, _editionSize, _title, _fileLink, _ownerCommission, msg.sender, false, false);
92 		return c;
93 	}
94 	else {throw;}
95 	}
96 }
97 
98 contract Artwork {
99 
100 /* 1. Introduction
101 
102 This text is a plain English translation of the smart contract's programming logic and represent its terms of use (terms). This plain English translation is a best effort only and while all reasonable precautions have been taken to ensure that the smart contract will behave in the exact way outlined in these terms, mistakes do happen (see The DAO) which may result in unexpected and unintended contract behaviour which may include the total loss of invested funds (Ether), other tokens sent to it as well as accessibility of the contract itself. Due to the nature of smart contracts, once it is deployed on the blockchain it becomes immutably imbedded in it which means that any bugs and/or exploits discovered after deployment are unfixable. Should the code behave differently than outlined in these terms, the code - by the very nature of smart contracts - takes precedent over the terms. By deploying, interacting or otherwise using the smart contract you acknowledge and accept all associated risks while at the same time waive all rights to hold the creator of the smart contract, the artists who deployed the smart contract, its current owner as well as any other parties responsible for potential damages suffered by or caused by you through your interaction with the smart contract to yourself or others. No backsies.
103 
104 2. Contract deployment
105 
106 This smart contract enables its owner to issue limited edition pieces of art (pieces) that are cryptographically embedded in the Ethereum blockchain. Every piece can be owned, offered for sale, sold, bought, transferred and burned. The contract accepts bid from interested buyers and allows for the cancelation of bids as well as the cancelation of pieces offered for sale and filling of bids. In addition the owner of the contract as well as Ethart will earn a commission for every future sales of pieces irrespective of who owns, buys or sells them using the contract.
107 
108 The contract creation costs approximately 1.7-1.8 Mgas - assuming a gas price of 20 Gwei, contract creation will cost ~0.03-0.034 ETH or about $12 (@$300/ETH) on the Ethereum main net. If contract creation is not urgent and Ethereum's pending transactions pool is not congested gas prices can be lowered to ~4 Gwei which would reduce the cost of deployment to ~$2-$3 per artwork.
109 
110 During creation the contract asks for the following parameters:
111 
112 	- The SHA256 hash of your piece (the cryptographic link of your artwork to the Ethereum blockchain)
113 	- Edition size (the maximum number of pieces you plan to issue)
114 	- Title (the title or name of your artwork, if any)
115 	- The link to your file (if any)
116 	- Custom text
117 	- The owner's commission in basis points (i.e. 1/100th of a percent)
118 
119 SHA256 hash: A SHA256 hash is a fixed length cryptographic digest of a file. On Mac and Linux it can be calculated by opening a terminal window and typing "openssl sha -sha256" followed by a space and the filename (i.e. "openssl sha -sha256 <FILENAME>") one wants to calculate the hash for. An online tool that serves the same purpose can be found at http://hash.online-convert.com/sha256-generator. By the nature of the cryptographic math the resulting hash is a) a unique fingerprint of the input file which can be independently verified by whomever has access to the original file, b) different for (almost) every file as long as at least one bit is different and c) almost impossible to reverse, meaning you can calculate a SHA256 hash from a file very easily but you can not generate the file from the SHA256 hash. Embedding the SHA256 hash in the contract at it's deployment therefore proofs that the limited edition pieces controlled by the smart contract's logic are linked to a particular file: the artwork.
120 
121 Edition size: The edition size is currently limited to a minimum of 1 and a maximum of 1,000 pieces.
122 
123 Title: the title is stored as a public string in the contract
124 
125 File link: So people can independently verify that a particular file is associated with a particular instance of a smart contract you can here specify the publicly accessible link to the file. Note that providing a link is not mandatory and some artists may decide to only provide the SHA256 hash and reveal the actual file associated with it at a later point in time or never.
126 
127 Custom text: This field can be whatever you want it to be. One use case could be a set of custom attributes for limited edition collectible playing cards. In this case you would format your game card attributes in a standard manner for later use e.g. Strength, Constitution, Dexterity, Intelligence, Wisdom as "12,8,6,9,3" which a later application can then read and interpreted according to your game's rules.
128 
129 Owner's commission: the account that deploys the smart contract can set a commission for future sales that will be paid out to the current owner of smart contract. The commission is specified in basis points where 1 basis point equals 0.01%. The commission must be greater than 0 and lower than 9750. If the owner wants to receive 5% for all future sales for example the commission will have to be set as 500.
130 
131 At deployment the owner of the smart contract will be set as the account that deployed it. Please make sure to carefully note down your account details including your address, private key, password, JSON file etc and keep it safe and secret. Remember: whoever has access to this information has access to the contract and all the funds and rights associated with it. If you loose this information it is almost certainly lost forever and your funds and artwork with it. Make at least one backup and keep it in a safe location. After contract deployment it is important for you to carefully note down the contract creation transaction receipt number, contract address and ABI for later reference. You and others will require this information to interact with the contract once it is live.
132 
133 The contract acts as it's own decentralised exchange with an on chain order book of the lowest ask and highest bid for a piece and allows for trustless trade of the pieces of art via the Ethereum blockchain.
134 
135 3. Providing a proof
136 
137 After deployment and before the first pieces can be bought or sold the owner has to provide a proof. This proof demonstrates that the artwork was in fact deployed by the artist. The proof can be in the form of a link to a blog post, a tweet or press release providing at the very least the artwork's contract address or contract creation transaction number.
138 
139 4. Ethart commission
140 
141 The fee for letting you deploy your artworks will be 2.5% of the edition size as well as 2.5% of future revenues. So you basically pay in art. After you have provided the proof, the contract issues 2.5% of the edition size to Ethart automatically as following:
142 
143 - 1 piece for every 40 pieces increase in edition size
144 - a (remainder / 40) chance of an additional piece
145 
146 Example: Say you create a 100 piece limited edition artwork. The contract will then issue at least 2 pieces to Ethart. In addition there will be a 20 in 40 chance (i.e. 50%) that one additional piece will be issued to Ethart. In other words, if you create a limited edition of 1 piece there is a chance of 2.5% that after you provide the proof this one piece will be transferred to Ethart. To avoid disappointment we therefore recommend a minimum edition size of 2 - then you are guaranteed to keep at least one piece with an additional 5% chance of loosing the other. The way the math works out Ethart will on average retain 2.5% of all pieces.
147 
148 The pieces transferred to Ethart can not be sold or transferred by Ethart for a minimum of one year (31,556,926 seconds) giving you plenty of time to monopolise the market.
149 
150 5. Changing the owner
151 
152 The current owner can transfer ownership of the contract to another account.
153 
154 6. Transferring pieces
155 
156 Your artworks is in fact an ERC20 token (https://theethereum.wiki/w/index.php/ERC20_Token_Standard) and supports all ERC20 features. Pieces can be transferred to other addresses (as long as they are not being offered for sale) by their respective owners. Make sure that pieces are only being transferred to accounts that have access to their private keys. Pieces send to exchanges or other accounts that do not have access to their private keys will be lost - most likely forever.
157 
158 7. Offering a piece for sale
159 
160 The owner of a piece can offer it for sale. The price for which it is offered (the ask) has to be lower than the current lowest ask. Once a piece is offered for sale by its owner for a lower price than the currently lowest ask it will become the lowest ask and replace the previous lowest ask. The sale price has to be specified in wei (1000000000000000000 wei = 1 ETH). Offering a piece for sale at an ask that is lower or equal to the highest bid will result in an instant sale for the highest bid.
161 
162 8. Canceling a sale
163 
164 The owner of a piece offered for sale can cancel the sale 24 hours after having offered the piece for sale. The 24 hour limited is intended to prevent owners to offer a piece at an artificially low price, displacing the currently lowest ask and then immediately canceling the sale.
165 
166 10. Buying a piece
167 
168 As long as a piece is being offered for sale, anyone can buy it as long as the buyer sends at least the current lowest ask price with the buy order. Any buy orders that do not send at least the current lowest ask price will be rejects. All the funds send with a buy order will be paid out to the seller of the piece, the contract owner as well as Ethart respectively and in proportion to the commission rules outlined above. There will be no refunds for funds sent in excess of the lowest ask price. Once a piece has been sold the lowest ask will be reset and the next piece offered for sale will become the lowest ask if any. Patrons that buy pieces via the artwork’s smart contract will be issued 2.5 Patron tokens for every Ether spend in the transaction.
169 
170 11. Placing a bid
171 
172 Buyers can place bids in wei (1000000000000000000 wei = 1 ETH). Bids have to be higher than the currently highest bid. Placing a bid that is higher than the current lowest ask price will result in the bidder instantly buying the piece offered by the lowest ask seller for the bid amount.
173 
174 12. Cancelling a bid
175 
176 Bids can be canceled by the buyer 24 hours after they have been placed. The 24 hour limited is intended to prevent buyers from placing an artificially high bid, displacing the currently highest bid and then immediately canceling the bid.
177 
178 13. Filling a bid
179 
180 Bids can be filled by anyone who owns a piece. The contract owner has a 24 hour exclusive first right of refusal to fill a bid.
181 
182 14. Burning a piece
183 
184 The owner of a piece can burn it, removing it permanently from the pool of available pieces and thereby reducing the edition size. Artists may choose to do so to increase the value of the remaining pieces or for any other reason.
185 
186 	(c) Stefan Pernar 2017 - all rights reserved
187 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
188 
189 */
190 
191 /* Public variables */
192 	address public owner;						// Contract owner.
193 	bytes32 public SHA256ofArtwork;				// sha256 hash of the artwork.
194 	uint256 editionSize;						// The edition size of the artwork.
195 	string title;								// The title of the artwork.
196 	string fileLink;							// The link to the file of the artwork.
197 	string public proofLink;					// Link to the creation proof by the artist -> this has to be done after contract creation
198 	string public customText;						// Custom text
199 	uint256 public ownerCommission;				// Percent given to the contract owner for every sale - must be >=0 && <=975 1000 = 100%.
200 	
201 	uint256 public lowestAskPrice;				// The lowest price an owner of a piece is willing to sell it for.
202 	address public lowestAskAddress;			// The address of the lowest ask.
203 	uint256 public lowestAskTime;				// The time by which the ask can be withdrawn.
204 	bool public pieceForSale;					// Is a piece for sale?
205 
206 	uint256 public highestBidPrice;				// The highest price a buyer is willing to pay for a piece.
207 	address public highestBidAddress;			// The address of the highest bidder
208 	uint256 public highestBidTime;				// The time by which the bid can be withdrawn
209 	uint public activationTime;					// Time this contract has been activated.
210 	bool public pieceWanted;					// Is a buyer interested in a piece?
211 
212 	/* Events */
213 	event newLowestAsk (uint256 price, address seller);							// Informs watchers of the contract when a new lowest ask price has been set. (price, seller)
214 	event newHighestBid (uint256 price, address bidder);							// Informs watchers of the contract when a new highest bid price has been placed. (price, bidder)
215 	event pieceTransfered (uint256 amount, address from, address to);				// Informs watchers of the contract when a piece has been transfered. (amount, from, to)
216 	event pieceSold (address from, address to, uint256 price);					// Informs watchers of the contract when a piece has been sold. (from, to, price)
217 
218 	event Transfer (address indexed _from, address indexed _to, uint256 _value);
219 	event Approval (address indexed _owner, address indexed _spender, uint256 _value);
220 	event Burn (address indexed _owner, uint256 _amount);
221 
222 	/* Other variables */
223 	bool proofSet;							// Has the proof been set yet?
224 	uint256 ethartAward;					// # of pieces awarded to Ethart.
225 
226 	mapping (address => uint256) public piecesOwned;				// Maps the number of pieces owned by an address
227  	mapping (address => mapping (address => uint256)) allowed;		// Used in burnFrom and transferFrom
228     address registrar = 0x562b85ACEEE81876D27252B7dc06f03F6A2565fc;						// set after deployment of Registrar contract
229 
230 	function Artwork (								// Constructor
231 		bytes32 _SHA256ofArtwork,
232 		uint256 _editionSize,
233 		string _title,
234 		string _fileLink,
235 		string _customText,
236 		uint256 _ownerCommission,
237 		address _owner
238 	) {
239 		if (_ownerCommission > 9750 || _ownerCommission <0) {throw;}
240 		owner = _owner;                            // Owner is set as the address spawning the contract
241 		SHA256ofArtwork = _SHA256ofArtwork;
242 		editionSize = _editionSize;
243 		title = _title;
244 		fileLink = _fileLink;
245 		customText = _customText;
246 		ownerCommission = _ownerCommission;
247 		activationTime = now;	
248 	}
249 
250     modifier onlyBy(address _account)
251     {
252         require(msg.sender == _account);
253         _;
254     }
255 
256 	modifier ethArtOnlyAfterOneYear()
257 	{
258 		require(msg.sender != registrar || now > activationTime + 31536000);
259 		_;
260 	}
261 
262 	modifier ownerFirst()
263 	{
264 		require(msg.sender == owner || now > highestBidTime + 86400 || piecesOwned[owner] == 0);
265 		_;
266 	}
267 
268 	modifier notLocked(address _owner, uint256 _amount)
269 	{
270 		require(_owner != lowestAskAddress || piecesOwned[_owner] > _amount);
271 		_;
272 	}
273 
274 	// allows the current owner to assign a new owner
275 	function changeOwner (address newOwner) onlyBy (owner) {
276 		owner = newOwner;
277 		}
278 
279 	function setProof (string _proofLink) onlyBy (owner) {
280 		if (!proofSet) {
281 			uint256 remainder;
282 			proofLink = _proofLink;
283 			proofSet = true;
284 			remainder = editionSize % 40;
285 			ethartAward = (editionSize - remainder) / 40;
286 			if (remainder > 0 && now % 39 <= remainder) {ethartAward++;}		// Yes - this is gameable - if it is that important to you: go ahead.
287 			piecesOwned[registrar] = ethartAward;
288 			piecesOwned[owner] = editionSize - ethartAward;
289 			}
290 		else {throw;}
291 		}
292 
293 	function transfer(address _to, uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
294 		if (piecesOwned[msg.sender] >= _amount 
295 			&& _amount > 0
296 			&& piecesOwned[_to] + _amount > piecesOwned[_to]
297 			&& _to != 0x0)																// use burn() instead
298 			{
299 			piecesOwned[msg.sender] -= _amount;
300 			piecesOwned[_to] += _amount;
301 			Transfer(msg.sender, _to, _amount);
302 			return true;
303 			}
304 			else { return false;}
305  		 }
306 
307     function totalSupply() constant returns (uint256 totalSupply) {
308 		totalSupply = editionSize;
309 		}
310 
311 	function balanceOf(address _owner) constant returns (uint256 balance) {
312  		return piecesOwned[_owner];
313 		}
314 
315  	function transferFrom(address _from, address _to, uint256 _amount) notLocked(_from, _amount) returns (bool success)
316 		{
317 			if (piecesOwned[_from] >= _amount
318 				&& allowed[_from][msg.sender] >= _amount
319 				&& _amount > 0
320 				&& piecesOwned[_to] + _amount > piecesOwned[_to]
321 				&& _to != 0x0															// use burn() instead
322 				&& (_from != lowestAskAddress || piecesOwned[_from] > _amount))
323 					{
324 					piecesOwned[_from] -= _amount;
325 					allowed[_from][msg.sender] -= _amount;
326 					piecesOwned[_to] += _amount;
327 					Transfer(_from, _to, _amount);
328 					return true;
329 					} else {return false;}
330 		}
331 
332 	function approve(address _spender, uint256 _amount) returns (bool success) {
333 		allowed[msg.sender][_spender] = _amount;
334 		Approval(msg.sender, _spender, _amount);
335 		return true;
336 		}
337 
338 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
339 		return allowed[_owner][_spender];
340 		}
341 
342 	function burn(uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
343 			if (piecesOwned[msg.sender] >= _amount) {
344 				piecesOwned[msg.sender] -= _amount;
345 				editionSize -= _amount;
346 				Burn(msg.sender, _amount);
347 				return true;
348 			}
349 			else {throw;}
350 		}
351 
352 	function burnFrom(address _from, uint256 _value) notLocked(_from, _value) returns (bool success) {
353 		if (piecesOwned[_from] >= _value && allowed[_from][msg.sender] >= _value) {
354 			piecesOwned[_from] -= _value;
355 			allowed[_from][msg.sender] -= _value;
356 			editionSize -= _value;
357 			Burn(_from, _value);
358 			return true;
359 		}
360 		else {throw;}
361 	}
362 
363 	function buyPiece() payable {
364 		if (pieceForSale && msg.value >= lowestAskPrice) {
365 			uint256 _amountOwner;
366 			uint256 _amountEthart;
367 			uint256 _amountSeller;
368 			_amountOwner = msg.value / 10000 * ownerCommission;
369 			_amountEthart = msg.value / 40;
370 			_amountSeller = msg.value - _amountOwner - _amountEthart;
371 			owner.transfer(_amountOwner);									// Transfer the contract owner's commission
372 			lowestAskAddress.transfer(_amountSeller);						// Transfer the buy price - commissions to seller
373 			registrar.transfer(_amountEthart);								// Transfer Ethart comission to Ethart
374 			piecesOwned[lowestAskAddress]--;
375 			piecesOwned[msg.sender]++;
376 			Interface a = Interface(registrar);
377 			a.issuePatrons(msg.sender, msg.value / 5 * 2);
378 			pieceSold (lowestAskAddress, msg.sender, msg.value);
379 			pieceForSale = false;
380 			lowestAskPrice = 0;
381 			lowestAskAddress = 0x0;
382 		}
383 		else {throw;}
384 	}
385 
386 	// Offer a piece for sale at a fixed price - the price has to be lower than the current lowest price
387 	function offerPieceForSale (uint256 _price) ethArtOnlyAfterOneYear {
388 		if (_price < lowestAskPrice || !pieceForSale) {
389 				if (_price <= highestBidPrice) {fillBid();}
390 				else {
391 				pieceForSale = true;
392 				lowestAskPrice = _price;
393 				lowestAskAddress = msg.sender;
394 				lowestAskTime = now;
395 				newLowestAsk (_price, lowestAskAddress);			// alerts contract watchers about new lowest ask price.
396 				}
397 		}
398 		else {throw;}
399 	}
400 
401 	// place a bid for any piece in the edition - bid has to be higher than current highest bid
402 	function placeBid () payable {
403 		if (msg.value > highestBidPrice || (pieceForSale && msg.value >= lowestAskPrice)) {
404 			if (pieceWanted) {highestBidAddress.transfer (highestBidPrice);}
405 			if (pieceForSale && msg.value >= lowestAskPrice) {buyPiece();}
406 			else {
407 				pieceWanted = true;
408 				highestBidPrice = msg.value;
409 				highestBidAddress = msg.sender;
410 				highestBidTime = now;
411 				newHighestBid (msg.value, highestBidAddress);
412 				}
413 		}
414 		else {throw;}
415 	}
416 
417 	function fillBid () ownerFirst ethArtOnlyAfterOneYear notLocked(msg.sender, 1) {	// Owner has 24h first right of refusual to fill the bid. Ethart can only fill bids after 1 year.
418 		if (pieceWanted && piecesOwned[msg.sender] >= 1) {								// If the current lowest ask address wants to fill a bid it has to cancel it's sale first and then
419 			uint256 _amountOwner;														// fill the bid.
420 			uint256 _amountEthart;
421 			uint256 _amountSeller;
422 			uint256 patronReward;
423 			_amountOwner = highestBidPrice / 10000 * ownerCommission;
424 			_amountEthart = highestBidPrice / 40;
425 			_amountSeller = highestBidPrice - _amountOwner - _amountEthart;
426 			owner.transfer(_amountOwner);									// Transfer the contract's owner's commission
427 			msg.sender.transfer(_amountSeller);								// Transfer the buy price - commissions to seller
428 			registrar.transfer(_amountEthart);								// Transfer Ethart comission to Ethart
429 			piecesOwned[highestBidAddress]++;
430 			Interface a = Interface(registrar);
431 			patronReward = highestBidPrice  / 5 * 2;
432 			a.issuePatrons(highestBidAddress, patronReward);				
433 			piecesOwned[msg.sender]--;
434 			pieceSold (msg.sender, highestBidAddress, highestBidPrice);
435 			pieceWanted = false;
436 			highestBidPrice = 0;
437 			highestBidAddress = 0x0;
438 		}
439 		else {throw;}
440 	}
441 
442 	// withdraw a bid - bids can only be withdrawn after 24 hours of being placed
443 	function cancelBid () onlyBy (highestBidAddress){
444 		if (pieceWanted && now > highestBidTime + 86400) {
445 			pieceWanted = false;
446 			msg.sender.transfer(highestBidPrice);
447 			highestBidPrice = 0;
448 			highestBidAddress = 0x0;
449 			newHighestBid (0, 0x0);
450 		}
451 		else {throw;}
452 	}
453 
454 	// cancels sales - sales can only be canceled 24 hours after it has been offered for sale
455 	function cancelSale () onlyBy (lowestAskAddress){
456 		if(pieceForSale && now > lowestAskTime + 86400) {
457 			pieceForSale = false;
458 			lowestAskPrice = 0;
459 			lowestAskAddress = 0x0;
460 			newLowestAsk (0, 0x0);
461 		}
462 		else {throw;}
463 	}
464 
465 }