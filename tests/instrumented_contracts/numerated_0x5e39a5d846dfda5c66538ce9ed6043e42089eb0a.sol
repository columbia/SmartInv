1 pragma solidity ^0.4.11;
2 
3 /* Ethart unindexed Factory Contract 'COSIMA' v1.0 2017-07-08
4 
5 	https://ethart.com - The Ethereum Art Network
6 
7 	Ethart ARCHITECTURE
8 	-------------------
9 						_________________________________________
10 						V										V
11 	Controller --> Registrar <--> Factory Contract1 --> Artwork Contract1
12 								  Factory Contract2		Artwork Contract2
13 										...					...
14 								  Factory ContractN		Artwork ContractN
15 
16 	Controller: The controller contract is the owner of the Registrar contract and can
17 		- Set a new owner
18 		- Control the assets of the Registrar (withdraw ETH, transfer, sell, burn pieces owned by the Registrar)
19 		- The plan is to have the controller contract be a DAO in preparation for a possible ICO
20 	
21 	Registrar:
22 		- The Registrar contract acts as the central registry for all sha256 hashes in the Ethart factory contract network.
23 		- Approved Factory Contracts can register sha256 hashes using the Registrar interface.
24 		- ethartArtReward of the art produced and ethartRevenueReward of turnover of the contract network will be awarded to the Registrar.
25 	
26 	Factory Contracts:
27 		- Factory Contracts can spawn Artwork Contracts in line with artists specifications
28 		- Factory Contracts will only spawn Artwork Contracts who's sha256 hashes are unique per the Registrar's sha256 registry
29 		- Factory Contracts will register every new Artwork Contract with it's details with the Registrar contract
30 	
31 	Artwork Contracts:
32 		- Artwork Contracts act as minimalist decentralised exchanges for their pieces in line with specified conditions
33 		- Artwork Contracts will interact with the Registrar to issue buyers of pieces a predetermined amount of Patron tokens based on the transaction value 
34 		- Artwork Contracts can be interacted with by the Controller via the Registrar using their interfaces to transfer, sell, burn etc pieces
35 	
36 	(c) Stefan Pernar 2017 - all rights reserved
37 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
38 
39 Artworks created with this factory have the following ABI:
40 
41 [{"constant":true,"inputs":[],"name":"pieceForSale","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"referrerReward","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"proofSet","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ownerCommission","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_proofLink","type":"string"}],"name":"setProof","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"proofLink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"customText","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"fillBid","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint256"}],"name":"burn","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"title","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ethartArtAwarded","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidAddress","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"highestBidTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ethartArtReward","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"referrer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancelBid","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"changeOwner","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"pieceWanted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"SHA256ofArtwork","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_price","type":"uint256"}],"name":"offerPieceForSale","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"buyPiece","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"activationTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"piecesOwned","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"cancelSale","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ethartRevenueReward","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"fileLink","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"placeBid","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"editionSize","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lowestAskTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"_SHA256ofArtwork","type":"bytes32"},{"name":"_editionSize","type":"uint256"},{"name":"_title","type":"string"},{"name":"_fileLink","type":"string"},{"name":"_customText","type":"string"},{"name":"_ownerCommission","type":"uint256"},{"name":"_owner","type":"address"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"seller","type":"address"}],"name":"NewLowestAsk","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"price","type":"uint256"},{"indexed":false,"name":"bidder","type":"address"}],"name":"NewHighestBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"}],"name":"PieceTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"price","type":"uint256"}],"name":"PieceSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Burn","type":"event"}]
42 
43 */
44 
45 contract Interface {
46 
47 	// Ethart network interface
48 
49 	// Get Ethart reward variables
50 	function getEthartRevenueReward () returns (uint256 _ethartRevenueReward);
51 	function getEthartArtReward () returns (uint256 _ethartArtReward);
52 
53 	// Registers a new artwork.
54 	function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);
55 	
56 	// Check if a sha256 hash is registered
57 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered);
58 	
59 	// Check if an address is a registered factory contract
60 	function isFactoryApproved (address _factory) returns (bool _approved);
61 	
62 	// Issues Patron tokens according to conditions specified in factory contracts
63 	function issuePatrons (address _to, uint256 _amount);
64 
65 	// Safe transfer alternative from Open Zeppelin
66 	function asyncSend(address _owner, uint256 _amount);
67 
68 	// Retrieve referrer and referrer reward information from the registrar
69 	function getReferrer (address _artist) returns (address _referrer);
70 	function getReferrerReward () returns (uint256 _referrerReward);
71 
72 	// ERC20 interface
73     function totalSupply() constant returns (uint256 totalSupply);
74 	function balanceOf(address _owner) constant returns (uint256 balance);
75  	function transfer(address _to, uint256 _value) returns (bool success);
76  	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
77 	function approve(address _spender, uint256 _value) returns (bool success);
78 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
79 
80 	function burn(uint256 _amount) returns (bool success);
81 	function burnFrom(address _from, uint256 _amount) returns (bool success);
82 }
83 
84 contract Factory {
85 
86   // index of created artworks
87 
88   address[] public artworks;
89 
90   // Registrar contract address
91   address registrar = 0x5f68698245e8c8949450E68B8BD8acef37faaE7D;   // set after deployment of Registrar contract
92 
93   // useful to know the row count in artworks index
94 
95   function getContractCount() 
96     public
97     constant
98     returns(uint contractCount)
99   {
100     return artworks.length;
101   }
102 
103   // deploy a new artwork
104 
105   function newArtwork (bytes32 _SHA256ofArtwork, uint256 _editionSize, string _title, string _fileLink, string _customText, uint256 _ownerCommission) public returns (address newArt)
106   {
107 	Interface a = Interface(registrar);
108 	if (!a.isSHA256HashRegistered(_SHA256ofArtwork)) {
109 		Artwork c = new Artwork(_SHA256ofArtwork, _editionSize, _title, _fileLink, _customText, _ownerCommission, msg.sender);
110 		a.registerArtwork(c, _SHA256ofArtwork, _editionSize, _title, _fileLink, _ownerCommission, msg.sender, false, false);
111 		artworks.push(c);
112 		return c;
113 	}
114 	else {throw;}
115 	}
116 }
117 
118 contract Artwork {
119 
120 /* Ethart unindexed Artwork Contract 'COSIMA' v1.0 2017-07-08
121 
122 1. Introduction
123 
124 This text is a plain English translation of the artwork smart contract's 'COSIMA' programming logic and represent its terms of use (terms). This plain English translation is a best effort only and while all reasonable precautions - including significant bug bounties - have been taken to ensure that the smart contract will behave in the exact way outlined in these terms, mistakes do happen (see The DAO) which may result in unexpected and unintended contract behaviour which may include the total loss of invested funds (Ether), other tokens sent to it as well as accessibility of the contract itself. Due to the nature of smart contracts, once it is deployed on the blockchain it becomes immutably imbedded in it which means that any bugs and/or exploits discovered after deployment are unfixable. Should the code behave differently than outlined in these terms, the code - by the very nature of smart contracts - takes precedent over the terms. By deploying, interacting or otherwise using the smart contract you acknowledge and accept all associated risks while at the same time waive all rights to hold the creator of the smart contract, the artists who deployed the smart contract, its current owner as well as any other parties responsible for potential damages suffered by or caused by you through your interaction with the smart contract to yourself or others. No backsies.
125 
126 2. Contract deployment
127 
128 This smart contract enables its owner to issue limited edition pieces of art (pieces) that are cryptographically embedded in the Ethereum blockchain. Every piece can be owned, offered for sale, sold, bought, transferred and burned. The contract accepts bids from interested buyers and allows for the cancelation of bids as well as the cancelation of pieces offered for sale and filling of bids. In addition the owner of the contract as well as Ethart will earn a commission for every future sales of pieces irrespective of who owns, buys or sells them using the contract.
129 
130 The contract creation costs approximately 2.4 Mgas - assuming a gas price of 20 Gwei, contract creation will cost ~0.05 ETH or about $15 (@$300/ETH) on the Ethereum main net. If contract creation is not urgent and Ethereum's pending transactions pool is not congested gas prices can be lowered to ~4 Gwei which would reduce the cost of deployment to ~$3 per artwork at current prices. Please make sure you understand the implications of gas cost, gas price and Ether price before you engage with this contract as the price of Ether and gas prices accepted by miners can and do change on a daily basis.
131 
132 During creation the contract asks for the following parameters:
133 
134 	- The SHA256 hash of your piece (the cryptographic link of your artwork to the Ethereum blockchain)
135 	- Edition size (the maximum number of pieces you plan to issue)
136 	- Title (the title or name of your artwork, if any)
137 	- The link to your file (if any)
138 	- Custom text (if any)
139 	- The owner's commission in basis points (i.e. 1/100th of a percent)
140 
141 SHA256 hash: A SHA256 hash is a fixed length cryptographic digest of a file. On Mac and Linux it can be calculated by opening a terminal window and typing "openssl sha -sha256" followed by a space and the filename (i.e. "openssl sha -sha256 <FILENAME>") one wants to calculate the hash for. An online tool that serves the same purpose can be found at http://hash.online-convert.com/sha256-generator. By the nature of the cryptographic math the resulting hash is a) a unique fingerprint of the input file which can be independently verified by whomever has access to the original file, b) different for (almost) every file as long as at least one bit is different and c) almost impossible to reverse, meaning you can calculate a SHA256 hash from a file very easily but you can not generate the file from the SHA256 hash. Embedding the SHA256 hash in the contract at it's deployment therefore proofs that the limited edition pieces controlled by the smart contract's logic are linked to a particular file: the artwork.
142 
143 Edition size: The maximum number of pieces you wish your artwork to have.
144 
145 Title: the title is stored as a public string in the contract
146 
147 File link: So people can independently verify that a particular file is associated with a particular instance of a smart contract you can here specify the publicly accessible link to the file. Note that providing a link is not mandatory and some artists may decide to only provide the SHA256 hash and reveal the actual file associated with it at a later point in time or never.
148 
149 Custom text: This field can be whatever you want it to be. One use case could be a set of custom attributes for limited edition collectible playing cards. In this case you would format your game card attributes in a standard manner for later use e.g. Strength, Constitution, Dexterity, Intelligence, Wisdom as "12,8,6,9,3" which a later application can then read and interpreted according to your game's rules.
150 
151 Owner's commission: the account that deploys/ed the smart contract can set a commission for future sales that will be paid out to the current owner of smart contract. The commission is specified in basis points where 1 basis point equals 0.01%. The commission must be greater than 0 and lower than 10000 - Ethart's reward. If the owner wants to receive 5% for all future sales for example the commission will have to be set as 500.
152 
153 At deployment the owner of the smart contract will be set as the account that deployed it. Please make sure to carefully note down your account details including your address, private key, password, JSON file etc and keep it safe and secret. Remember: whoever has access to this information has access to the contract and all the funds and rights associated with it. If you loose this information it is almost certainly going to be lost forever and your funds and artwork with it. Make at least one backup and keep it in a safe location. After contract deployment it is important for you to carefully note down the contract creation transaction receipt number, contract address and ABI for later reference. You and others will require this information to interact with the contract once it is live. If you created an artwork and lost your artwork's contract address you can look up the sha256 hash of your artwork in the registrar's artwok registry which will return your artwork's contract address to you.
154 
155 The artwork contract acts as it's own decentralised exchange with an on chain order book of the lowest ask and highest bid for a piece and allows for trustless trade of the pieces of art via the Ethereum blockchain.
156 
157 3. Providing a proof
158 
159 After deployment and before the first pieces can be bought or sold the owner has to provide a proof. This proof demonstrates that the artwork was in fact deployed by the artist. The proof can be in the form of a link to a blog post, a tweet or press release, providing at the very least the artwork's contract address or contract creation transaction number.
160 
161 4. Ethart commission
162 
163 The fee for letting you deploy your artworks is set by the registrar contract and will be between 0 and 10% of the edition size as well as between 0 and 10% of future revenues. Please make sure to check these numbers before you deploy your artwork's contarct as these values will be fixed after contract deployment. After you have provided the proof, the contract issues a percent of the edition size to Ethart automatically as following:
164 
165 - 1 piece for every (10000 / ethartArtReward) pieces increase in edition size
166 - a (remainder / (10000 / ethartArtReward)) chance of an additional piece
167 
168 Example: Say you create a 100 piece limited edition artwork and the ethartArtReward is set as 250 (2.5%). The contract will then issue at least 2 pieces to Ethart. In addition there will be a 20 in 40 (i.e. 50%) chance that one additional piece will be issued to Ethart. In other words, if you create a limited edition of 1 piece there is always a chance that after you provide the proof this one piece will be transferred to Ethart. To avoid disappointment we therefore recommend a minimum edition size of 2 - then you are guaranteed to keep at least one piece with an additional small chance of loosing the other. The way the math works out Ethart will on average retain ethartArtReward in basis points of all pieces.
169 
170 The pieces transferred to Ethart can not be sold or transferred by Ethart for a minimum of one year (31,556,926 seconds) giving you plenty of time to monopolise the market.
171 
172 5. Changing the owner
173 
174 The current owner of the artwork contract can transfer ownership of the contract to another account.
175 
176 6. Transferring pieces
177 
178 Your artworks is in fact an ERC20 token (https://theethereum.wiki/w/index.php/ERC20_Token_Standard) and supports all ERC20 features. Pieces can be transferred to other addresses (as long as they are not being offered for sale) by their respective owners. Make sure that pieces are only being transferred to accounts that have access to their private keys. Pieces send to exchanges or other accounts that do not have access to their private keys will be lost - most likely forever.
179 
180 7. Offering a piece for sale
181 
182 The owner of a piece can offer it for sale. The price for which it is offered (the ask) has to be lower than the current lowest ask. Once a piece is offered for sale by its owner for a lower price than the currently lowest ask it will become the lowest ask and replace the previous lowest ask. The sale price has to be specified in wei (1000000000000000000 wei = 1 ETH).
183 
184 8. Canceling a sale
185 
186 The owner of a piece offered for sale can cancel the sale 24 hours after having offered the piece for sale. The 24 hour limited is intended to prevent owners to offer a piece at an artificially low price, displacing the currently lowest ask and then immediately canceling the sale.
187 
188 10. Buying a piece
189 
190 As long as a piece is being offered for sale, anyone can buy it as long as the buyer sends at least the current lowest ask price with the buy order. Any buy orders that do not send at least the current lowest ask price will be rejects. All the funds send with a buy order will be paid out to the seller of the piece, the contract owner as well as Ethart respectively and in proportion to the commission rules outlined above. There will be no refunds for funds sent in excess of the lowest ask price. Once a piece has been sold the lowest ask will be reset and the next piece offered for sale will become the lowest ask if any. Patrons that buy pieces via the artwork’s smart contract will be issuedpatronRewardMultiplier Patron tokens for every Ether spend in the transaction.
191 
192 11. Placing a bid
193 
194 Buyers can place bids in ether. Bids have to be higher than the currently highest bid. Placing a bid that is higher than the current lowest ask price will result in the bidder instantly buying the piece offered by the lowest ask seller for the bid amount.
195 
196 12. Cancelling a bid
197 
198 Bids can be canceled by the buyer 24 hours after they have been placed. The 24 hour limited is intended to prevent buyers from placing an artificially high bid, displacing the currently highest bid and then immediately canceling the bid.
199 
200 13. Filling a bid
201 
202 Bids can be filled by anyone who owns a piece.
203 
204 14. Burning a piece
205 
206 The owner of a piece can burn it, removing it permanently from the pool of available pieces and thereby reducing the edition size. Artists may choose to do so to increase the value of the remaining pieces or for any other reason.
207 
208 15. Referral reward
209 
210 The referrer of an artist receives referrerReward basis points of ethartRevenueReward as their referral reward for every piece sold using this contract. The referrer has to be set by the artist prior to creating their first artwork.
211 
212 16. Withdrawing funds
213 
214 For security reasons Ethart contracts' handling of ether transfers have been implemented following the best practise pull payment method from Open Zeppelin (https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/payment/PullPayment.sol). This means that all funds used in placing bids and buying pieces are being transfered to the registrar contract. Sellers, artists, owners, referrer and buyers canceling their bids or those who are being outbid can claim their funds by executing the withdrawPayments method of the registrar contract. Not only does this mitigate several security concerns but at the same time provides a single location for everyone to claim their funds in one transaction.
215 
216 17. Standing bug bounty
217 
218 The factory contract this contract has been spawned from has a standing bug bounty of 1,000 Patrons for all practical and demonstrable exploits that cause the unintentional loss of ether and/or tokens. If you feel you have discovered an exploit path or vulnerability please contact us at http://ethart.com and claim your reward.
219 
220 	(c) Stefan Pernar 2017 - all rights reserved
221 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
222 
223 */
224 
225 /* Public variables */
226 	address public owner;						// Contract owner.
227 	bytes32 public SHA256ofArtwork;				// sha256 hash of the artwork.
228 	uint256 public editionSize;					// The edition size of the artwork.
229 	string public title;						// The title of the artwork.
230 	string public fileLink;						// The link to the file of the artwork.
231 	string public proofLink;					// Link to the creation proof by the artist -> this has to be done after contract creation
232 	string public customText;					// Custom text
233 	uint256 public ownerCommission;				// Percent given to the contract owner for every sale - must be >=0 && <=975 1000 = 100%.
234 	
235 	uint256 public lowestAskPrice;				// The lowest price an owner of a piece is willing to sell it for.
236 	address public lowestAskAddress;			// The address of the lowest ask.
237 	uint256 public lowestAskTime;				// The time by which the ask can be withdrawn.
238 	bool public pieceForSale;					// Is a piece for sale?
239 
240 	uint256 public highestBidPrice;				// The highest price a buyer is willing to pay for a piece.
241 	address public highestBidAddress;			// The address of the highest bidder
242 	uint256 public highestBidTime;				// The time by which the bid can be withdrawn
243 	uint public activationTime;					// Time this contract has been activated.
244 	bool public pieceWanted;					// Is a buyer interested in a piece?
245 
246 	/* Events */
247 	
248 	// Informs watchers of the contract when a new lowest ask price has been set. (price, seller)
249 	event NewLowestAsk (uint256 price, address seller);
250 	
251 	// Informs watchers of the contract when a new highest bid price has been placed. (price, bidder)
252 	event NewHighestBid (uint256 price, address bidder);
253 	
254 	// Informs watchers of the contract when a piece has been transferred. (amount, from, to)
255 	event PieceTransferred (uint256 amount, address from, address to);
256 	
257 	// Informs watchers of the contract when a piece has been sold. (from, to, price)
258 	event PieceSold (address from, address to, uint256 price);
259 
260 	event Transfer (address indexed _from, address indexed _to, uint256 _value);
261 	event Approval (address indexed _owner, address indexed _spender, uint256 _value);
262 	event Burn (address indexed _owner, uint256 _amount);
263 
264 	/* Other variables */
265 	
266 	// Has the proof been set yet?
267 	bool public proofSet;
268 	
269 	// # of pieces awarded to Ethart.
270 	uint256 public ethartArtAwarded;
271 
272 	// Maps the number of pieces owned by an address
273 	mapping (address => uint256) public piecesOwned;
274 	
275 	// Used in burnFrom and transferFrom
276  	mapping (address => mapping (address => uint256)) allowed;
277 	
278 	// set after deployment of Registrar contract
279     address registrar = 0x5f68698245e8c8949450E68B8BD8acef37faaE7D;
280 	
281 	// Ethart reward variables - fixed after contract creation
282 	uint256 public ethartRevenueReward;
283 	uint256 public ethartArtReward;
284 	address public referrer;
285 	
286 	// Referrer receives referrerReward basis points of ethartRevenueReward
287 	uint256 public referrerReward;
288 
289 	// Constructor
290 	function Artwork (
291 		bytes32 _SHA256ofArtwork,
292 		uint256 _editionSize,
293 		string _title,
294 		string _fileLink,
295 		string _customText,
296 		uint256 _ownerCommission,
297 		address _owner
298 	) {
299 		if (_ownerCommission > (10000 - ethartRevenueReward)) {throw;}
300 		Interface a = Interface(registrar);
301 		ethartRevenueReward = a.getEthartRevenueReward();
302 		ethartArtReward = a.getEthartArtReward();
303 		referrer = a.getReferrer (_owner);
304 		referrerReward = a.getReferrerReward ();
305 		// Owner is set as the address spawning the contract
306 		owner = _owner;
307 		SHA256ofArtwork = _SHA256ofArtwork;
308 		editionSize = _editionSize;
309 		title = _title;
310 		fileLink = _fileLink;
311 		customText = _customText;
312 		ownerCommission = _ownerCommission;
313 		activationTime = now;	
314 	}
315 
316 	modifier onlyBy(address _account)
317 	{
318 		require(msg.sender == _account);
319 		_;
320 	}
321 
322 	// The registrar can execute certain functions only after one year
323 	modifier ethArtOnlyAfterOneYear()
324 	{
325 		require(msg.sender != registrar || now > activationTime + 31536000);
326 		_;
327 	}
328 
329 	// Sales / approvals have to be cancelled first for certain functions
330 	modifier notLocked(address _owner, uint256 _amount)
331 	{
332 		require(_owner != lowestAskAddress || piecesOwned[_owner] > _amount);
333 		_;
334 	}
335 
336 	// Mitigating ERC20 short address attacks (http://vessenes.com/the-erc20-short-address-attack-explained/)
337 	modifier onlyPayloadSize(uint size)
338 	{
339 		require(msg.data.length >= size + 4);
340 		_;
341 	}
342 
343 	// allows the current owner to assign a new owner
344 	function changeOwner (address newOwner) onlyBy (owner) {
345 		owner = newOwner;
346 		}
347 
348 	function setProof (string _proofLink) onlyBy (owner) {
349 		if (!proofSet) {
350 			uint256 remainder;
351 			proofLink = _proofLink;
352 			proofSet = true;
353 			remainder = editionSize % (10000 / ethartArtReward);
354 			ethartArtAwarded = (editionSize - remainder) / (10000 / ethartArtReward);
355 			// Yes - this is gameable - if it is that important to you: go ahead.
356 			if (remainder > 0 && now % ((10000 / ethartArtReward) - 1) <= remainder) {ethartArtAwarded++;}
357 			piecesOwned[registrar] = ethartArtAwarded;
358 			piecesOwned[owner] = editionSize - ethartArtAwarded;
359 			}
360 		else {throw;}
361 		}
362 
363 	function transfer(address _to, uint256 _amount) notLocked(msg.sender, _amount) onlyPayloadSize(2 * 32) returns (bool success) {
364 		if (piecesOwned[msg.sender] >= _amount 
365 			&& _amount > 0
366 			&& piecesOwned[_to] + _amount > piecesOwned[_to]
367 			// use burn() instead
368 			&& _to != 0x0)
369 			{
370 			piecesOwned[msg.sender] -= _amount;
371 			piecesOwned[_to] += _amount;
372 			Transfer(msg.sender, _to, _amount);
373 			return true;
374 			}
375 			else { return false;}
376  		 }
377 
378 	function totalSupply() constant returns (uint256 totalSupply) {
379 		totalSupply = editionSize;
380 		}
381 
382 	function balanceOf(address _owner) constant returns (uint256 balance) {
383  		return piecesOwned[_owner];
384 		}
385 
386 	function transferFrom(address _from, address _to, uint256 _amount) notLocked(_from, _amount) onlyPayloadSize(3 * 32)returns (bool success)
387 		{
388 			if (piecesOwned[_from] >= _amount
389 				&& allowed[_from][msg.sender] >= _amount
390 				&& _amount > 0
391 				&& piecesOwned[_to] + _amount > piecesOwned[_to]
392 				// use burn() instead
393 				&& _to != 0x0
394 				&& (_from != lowestAskAddress || piecesOwned[_from] > _amount))
395 					{
396 					piecesOwned[_from] -= _amount;
397 					allowed[_from][msg.sender] -= _amount;
398 					piecesOwned[_to] += _amount;
399 					Transfer(_from, _to, _amount);
400 					return true;
401 					} else {return false;}
402 		}
403 
404 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
405 	// If this function is called again it overwrites the current allowance with _value.
406 	// To be extra secure set allowance to 0 and check that none of our allowance was spend between you sending the tx and it getting mined. Only then decrease/increase the allowance.
407 	// See https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.m9fhqynw2xvt
408 	function approve(address _spender, uint256 _amount) returns (bool success) {
409 		allowed[msg.sender][_spender] = _amount;
410 		Approval(msg.sender, _spender, _amount);
411 		return true;
412 		}
413 
414 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
415 		return allowed[_owner][_spender];
416 		}
417 
418 	function burn(uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
419 			if (piecesOwned[msg.sender] >= _amount) {
420 				piecesOwned[msg.sender] -= _amount;
421 				editionSize -= _amount;
422 				Burn(msg.sender, _amount);
423 				return true;
424 			}
425 			else {throw;}
426 		}
427 
428 	function burnFrom(address _from, uint256 _value) notLocked(_from, _value) onlyPayloadSize(2 * 32) returns (bool success) {
429 		if (piecesOwned[_from] >= _value && allowed[_from][msg.sender] >= _value) {
430 			piecesOwned[_from] -= _value;
431 			allowed[_from][msg.sender] -= _value;
432 			editionSize -= _value;
433 			Burn(_from, _value);
434 			return true;
435 		}
436 		else {throw;}
437 	}
438 
439 	function buyPiece() payable {
440 		if (pieceForSale && msg.value >= lowestAskPrice) {
441 			uint256 _amountOwner;
442 			uint256 _amountEthart;
443 			uint256 _amountSeller;
444 			uint256 _amountReferrer;
445 			_amountOwner = (msg.value / 10000) * ownerCommission;
446 			_amountEthart = (msg.value / 10000) * ethartRevenueReward;
447 			_amountSeller = msg.value - _amountOwner - _amountEthart;
448 			Interface a = Interface(registrar);
449 			if (referrer != 0x0) {
450 				_amountReferrer = _amountEthart / 10000 * referrerReward;
451 				_amountEthart -= _amountReferrer;
452 				// Async send the referrer reward to the referrer
453 				a.asyncSend(referrer, _amountReferrer);
454 				}
455 			piecesOwned[lowestAskAddress]--;
456 			piecesOwned[msg.sender]++;
457 			PieceSold (lowestAskAddress, msg.sender, msg.value);
458 			pieceForSale = false;
459 			lowestAskPrice = 0;
460 			// Reward the buyer with Patron tokens
461 			a.issuePatrons(msg.sender, msg.value);
462 			// Async send the contract owner's commission
463 			a.asyncSend(owner, _amountOwner);
464 			// Async send the buy price - commissions to seller
465 			a.asyncSend(lowestAskAddress, _amountSeller);
466 			lowestAskAddress = 0x0;
467 			// Async send Ethart commission to Ethart
468 			a.asyncSend(registrar, _amountEthart);
469 			// Transfer the sale price to the registrar contract
470 			registrar.transfer(msg.value);
471 		}
472 		else {throw;}
473 	}
474 
475 	// Offer a piece for sale at a fixed price - the price has to be lower than the current lowest price
476 	function offerPieceForSale (uint256 _price) ethArtOnlyAfterOneYear {
477 		if ((_price < lowestAskPrice || !pieceForSale) && piecesOwned[msg.sender] >= 1) {
478 				if (_price <= highestBidPrice) {fillBid();}
479 				else
480 				{
481 					pieceForSale = true;
482 					lowestAskPrice = _price;
483 					lowestAskAddress = msg.sender;
484 					lowestAskTime = now;
485 					NewLowestAsk (_price, lowestAskAddress);			// alerts contract watchers about new lowest ask price.
486 				}
487 		}
488 		else {throw;}
489 	}
490 
491 	// place a bid for a piece - bid has to be higher than current highest bid
492 	function placeBid () payable {
493 		if (msg.value > highestBidPrice || (pieceForSale && msg.value >= lowestAskPrice)) {
494 			if (pieceWanted) 
495 				{
496 					Interface a = Interface(registrar);
497 					a.asyncSend(highestBidAddress, highestBidPrice);
498 				}
499 			if (pieceForSale && msg.value >= lowestAskPrice) {buyPiece();}
500 			else
501 				{
502 					pieceWanted = true;
503 					highestBidPrice = msg.value;
504 					highestBidAddress = msg.sender;
505 					highestBidTime = now;
506 					NewHighestBid (msg.value, highestBidAddress);
507 					registrar.transfer(msg.value);
508 				}
509 		}
510 		else {throw;}
511 	}
512 
513 	// If the current lowest ask address wants to fill a bid it has to either cancel it's sale first and then
514 	// fill the bid or lower the lowest ask price to be equal or lower than the highest bid.
515 	function fillBid () ethArtOnlyAfterOneYear notLocked(msg.sender, 1) {
516 		if (pieceWanted && piecesOwned[msg.sender] >= 1) {
517 			uint256 _amountOwner;														
518 			uint256 _amountEthart;
519 			uint256 _amountSeller;
520 			uint256 _amountReferrer;
521 			_amountOwner = (highestBidPrice / 10000) * ownerCommission;
522 			_amountEthart = (highestBidPrice / 10000) * ethartRevenueReward;
523 			_amountSeller = highestBidPrice - _amountOwner - _amountEthart;
524 			Interface a = Interface(registrar);
525 			if (referrer != 0x0) {
526 				_amountReferrer = _amountEthart / 10000 * referrerReward;
527 				_amountEthart -= _amountReferrer;
528 				// Async send the referrer reward to the referrer
529 				a.asyncSend(referrer, _amountReferrer);
530 				}
531 			piecesOwned[highestBidAddress]++;
532 			// Reward the buyer with Patron tokens
533 			a.issuePatrons(highestBidAddress, highestBidPrice);				
534 			piecesOwned[msg.sender]--;
535 			PieceSold (msg.sender, highestBidAddress, highestBidPrice);
536 			pieceWanted = false;
537 			highestBidPrice = 0;
538 			highestBidAddress = 0x0;
539 			// Async send the contract owner's commission
540 			a.asyncSend(owner, _amountOwner);
541 			// Async send the buy price - commissions to seller
542 			a.asyncSend(msg.sender, _amountSeller);
543 			// Async send Ethart commission to Ethart
544 			a.asyncSend(registrar, _amountEthart);
545 		}
546 		else {throw;}
547 	}
548 
549 	// withdraw a bid - bids can only be withdrawn after 24 hours of being placed
550 	function cancelBid () onlyBy (highestBidAddress){
551 		if (pieceWanted && now > highestBidTime + 86400) {
552 			pieceWanted = false;
553 			highestBidPrice = 0;
554 			highestBidAddress = 0x0;
555 			NewHighestBid (0, 0x0);
556 			Interface a = Interface(registrar);
557 			a.asyncSend(msg.sender, highestBidPrice);			
558 		}
559 		else {throw;}
560 	}
561 
562 	// cancels sales - sales can only be canceled 24 hours after it has been offered for sale
563 	function cancelSale () onlyBy (lowestAskAddress){
564 		if(pieceForSale && now > lowestAskTime + 86400) {
565 			pieceForSale = false;
566 			lowestAskPrice = 0;
567 			lowestAskAddress = 0x0;
568 			NewLowestAsk (0, 0x0);
569 		}
570 		else {throw;}
571 	}
572 
573 }