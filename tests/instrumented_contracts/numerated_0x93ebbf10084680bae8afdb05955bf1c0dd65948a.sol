1 pragma solidity ^0.4.11;
2 
3 /* Ethart unindexed Artwork Contract 'COSIMA' v1.0 2017-07-08
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
84 contract Artwork {
85 
86 /* Ethart unindexed Artwork Contract 'COSIMA' v1.0 2017-07-08
87 
88 1. Introduction
89 
90 This text is a plain English translation of the artwork smart contract's 'COSIMA' programming logic and represent its terms of use (terms). This plain English translation is a best effort only and while all reasonable precautions - including significant bug bounties - have been taken to ensure that the smart contract will behave in the exact way outlined in these terms, mistakes do happen (see The DAO) which may result in unexpected and unintended contract behaviour which may include the total loss of invested funds (Ether), other tokens sent to it as well as accessibility of the contract itself. Due to the nature of smart contracts, once it is deployed on the blockchain it becomes immutably imbedded in it which means that any bugs and/or exploits discovered after deployment are unfixable. Should the code behave differently than outlined in these terms, the code - by the very nature of smart contracts - takes precedent over the terms. By deploying, interacting or otherwise using the smart contract you acknowledge and accept all associated risks while at the same time waive all rights to hold the creator of the smart contract, the artists who deployed the smart contract, its current owner as well as any other parties responsible for potential damages suffered by or caused by you through your interaction with the smart contract to yourself or others. No backsies.
91 
92 2. Contract deployment
93 
94 This smart contract enables its owner to issue limited edition pieces of art (pieces) that are cryptographically embedded in the Ethereum blockchain. Every piece can be owned, offered for sale, sold, bought, transferred and burned. The contract accepts bids from interested buyers and allows for the cancelation of bids as well as the cancelation of pieces offered for sale and filling of bids. In addition the owner of the contract as well as Ethart will earn a commission for every future sales of pieces irrespective of who owns, buys or sells them using the contract.
95 
96 The contract creation costs approximately 2.4 Mgas - assuming a gas price of 20 Gwei, contract creation will cost ~0.05 ETH or about $15 (@$300/ETH) on the Ethereum main net. If contract creation is not urgent and Ethereum's pending transactions pool is not congested gas prices can be lowered to ~4 Gwei which would reduce the cost of deployment to ~$3 per artwork at current prices. Please make sure you understand the implications of gas cost, gas price and Ether price before you engage with this contract as the price of Ether and gas prices accepted by miners can and do change on a daily basis.
97 
98 During creation the contract asks for the following parameters:
99 
100 	- The SHA256 hash of your piece (the cryptographic link of your artwork to the Ethereum blockchain)
101 	- Edition size (the maximum number of pieces you plan to issue)
102 	- Title (the title or name of your artwork, if any)
103 	- The link to your file (if any)
104 	- Custom text (if any)
105 	- The owner's commission in basis points (i.e. 1/100th of a percent)
106 
107 SHA256 hash: A SHA256 hash is a fixed length cryptographic digest of a file. On Mac and Linux it can be calculated by opening a terminal window and typing "openssl sha -sha256" followed by a space and the filename (i.e. "openssl sha -sha256 <FILENAME>") one wants to calculate the hash for. An online tool that serves the same purpose can be found at http://hash.online-convert.com/sha256-generator. By the nature of the cryptographic math the resulting hash is a) a unique fingerprint of the input file which can be independently verified by whomever has access to the original file, b) different for (almost) every file as long as at least one bit is different and c) almost impossible to reverse, meaning you can calculate a SHA256 hash from a file very easily but you can not generate the file from the SHA256 hash. Embedding the SHA256 hash in the contract at it's deployment therefore proofs that the limited edition pieces controlled by the smart contract's logic are linked to a particular file: the artwork.
108 
109 Edition size: The maximum number of pieces you wish your artwork to have.
110 
111 Title: the title is stored as a public string in the contract
112 
113 File link: So people can independently verify that a particular file is associated with a particular instance of a smart contract you can here specify the publicly accessible link to the file. Note that providing a link is not mandatory and some artists may decide to only provide the SHA256 hash and reveal the actual file associated with it at a later point in time or never.
114 
115 Custom text: This field can be whatever you want it to be. One use case could be a set of custom attributes for limited edition collectible playing cards. In this case you would format your game card attributes in a standard manner for later use e.g. Strength, Constitution, Dexterity, Intelligence, Wisdom as "12,8,6,9,3" which a later application can then read and interpreted according to your game's rules.
116 
117 Owner's commission: the account that deploys/ed the smart contract can set a commission for future sales that will be paid out to the current owner of smart contract. The commission is specified in basis points where 1 basis point equals 0.01%. The commission must be greater than 0 and lower than 10000 - Ethart's reward. If the owner wants to receive 5% for all future sales for example the commission will have to be set as 500.
118 
119 At deployment the owner of the smart contract will be set as the account that deployed it. Please make sure to carefully note down your account details including your address, private key, password, JSON file etc and keep it safe and secret. Remember: whoever has access to this information has access to the contract and all the funds and rights associated with it. If you loose this information it is almost certainly going to be lost forever and your funds and artwork with it. Make at least one backup and keep it in a safe location. After contract deployment it is important for you to carefully note down the contract creation transaction receipt number, contract address and ABI for later reference. You and others will require this information to interact with the contract once it is live. If you created an artwork and lost your artwork's contract address you can look up the sha256 hash of your artwork in the registrar's artwok registry which will return your artwork's contract address to you.
120 
121 The artwork contract acts as it's own decentralised exchange with an on chain order book of the lowest ask and highest bid for a piece and allows for trustless trade of the pieces of art via the Ethereum blockchain.
122 
123 3. Providing a proof
124 
125 After deployment and before the first pieces can be bought or sold the owner has to provide a proof. This proof demonstrates that the artwork was in fact deployed by the artist. The proof can be in the form of a link to a blog post, a tweet or press release, providing at the very least the artwork's contract address or contract creation transaction number.
126 
127 4. Ethart commission
128 
129 The fee for letting you deploy your artworks is set by the registrar contract and will be between 0 and 10% of the edition size as well as between 0 and 10% of future revenues. Please make sure to check these numbers before you deploy your artwork's contarct as these values will be fixed after contract deployment. After you have provided the proof, the contract issues a percent of the edition size to Ethart automatically as following:
130 
131 - 1 piece for every (10000 / ethartArtReward) pieces increase in edition size
132 - a (remainder / (10000 / ethartArtReward)) chance of an additional piece
133 
134 Example: Say you create a 100 piece limited edition artwork and the ethartArtReward is set as 250 (2.5%). The contract will then issue at least 2 pieces to Ethart. In addition there will be a 20 in 40 (i.e. 50%) chance that one additional piece will be issued to Ethart. In other words, if you create a limited edition of 1 piece there is always a chance that after you provide the proof this one piece will be transferred to Ethart. To avoid disappointment we therefore recommend a minimum edition size of 2 - then you are guaranteed to keep at least one piece with an additional small chance of loosing the other. The way the math works out Ethart will on average retain ethartArtReward in basis points of all pieces.
135 
136 The pieces transferred to Ethart can not be sold or transferred by Ethart for a minimum of one year (31,556,926 seconds) giving you plenty of time to monopolise the market.
137 
138 5. Changing the owner
139 
140 The current owner of the artwork contract can transfer ownership of the contract to another account.
141 
142 6. Transferring pieces
143 
144 Your artworks is in fact an ERC20 token (https://theethereum.wiki/w/index.php/ERC20_Token_Standard) and supports all ERC20 features. Pieces can be transferred to other addresses (as long as they are not being offered for sale) by their respective owners. Make sure that pieces are only being transferred to accounts that have access to their private keys. Pieces send to exchanges or other accounts that do not have access to their private keys will be lost - most likely forever.
145 
146 7. Offering a piece for sale
147 
148 The owner of a piece can offer it for sale. The price for which it is offered (the ask) has to be lower than the current lowest ask. Once a piece is offered for sale by its owner for a lower price than the currently lowest ask it will become the lowest ask and replace the previous lowest ask. The sale price has to be specified in wei (1000000000000000000 wei = 1 ETH).
149 
150 8. Canceling a sale
151 
152 The owner of a piece offered for sale can cancel the sale 24 hours after having offered the piece for sale. The 24 hour limited is intended to prevent owners to offer a piece at an artificially low price, displacing the currently lowest ask and then immediately canceling the sale.
153 
154 10. Buying a piece
155 
156 As long as a piece is being offered for sale, anyone can buy it as long as the buyer sends at least the current lowest ask price with the buy order. Any buy orders that do not send at least the current lowest ask price will be rejects. All the funds send with a buy order will be paid out to the seller of the piece, the contract owner as well as Ethart respectively and in proportion to the commission rules outlined above. There will be no refunds for funds sent in excess of the lowest ask price. Once a piece has been sold the lowest ask will be reset and the next piece offered for sale will become the lowest ask if any. Patrons that buy pieces via the artwork’s smart contract will be issuedpatronRewardMultiplier Patron tokens for every Ether spend in the transaction.
157 
158 11. Placing a bid
159 
160 Buyers can place bids in ether. Bids have to be higher than the currently highest bid. Placing a bid that is higher than the current lowest ask price will result in the bidder instantly buying the piece offered by the lowest ask seller for the bid amount.
161 
162 12. Cancelling a bid
163 
164 Bids can be canceled by the buyer 24 hours after they have been placed. The 24 hour limited is intended to prevent buyers from placing an artificially high bid, displacing the currently highest bid and then immediately canceling the bid.
165 
166 13. Filling a bid
167 
168 Bids can be filled by anyone who owns a piece.
169 
170 14. Burning a piece
171 
172 The owner of a piece can burn it, removing it permanently from the pool of available pieces and thereby reducing the edition size. Artists may choose to do so to increase the value of the remaining pieces or for any other reason.
173 
174 15. Referral reward
175 
176 The referrer of an artist receives referrerReward basis points of ethartRevenueReward as their referral reward for every piece sold using this contract. The referrer has to be set by the artist prior to creating their first artwork.
177 
178 16. Withdrawing funds
179 
180 For security reasons Ethart contracts' handling of ether transfers have been implemented following the best practise pull payment method from Open Zeppelin (https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/payment/PullPayment.sol). This means that all funds used in placing bids and buying pieces are being transfered to the registrar contract. Sellers, artists, owners, referrer and buyers canceling their bids or those who are being outbid can claim their funds by executing the withdrawPayments method of the registrar contract. Not only does this mitigate several security concerns but at the same time provides a single location for everyone to claim their funds in one transaction.
181 
182 17. Standing bug bounty
183 
184 The factory contract this contract has been spawned from has a standing bug bounty of 1,000 Patrons for all practical and demonstrable exploits that cause the unintentional loss of ether and/or tokens. If you feel you have discovered an exploit path or vulnerability please contact us at http://ethart.com and claim your reward.
185 
186 	(c) Stefan Pernar 2017 - all rights reserved
187 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
188 
189 */
190 
191 /* Public variables */
192 	address public owner;						// Contract owner.
193 	bytes32 public SHA256ofArtwork;				// sha256 hash of the artwork.
194 	uint256 public editionSize;					// The edition size of the artwork.
195 	string public title;						// The title of the artwork.
196 	string public fileLink;						// The link to the file of the artwork.
197 	string public proofLink;					// Link to the creation proof by the artist -> this has to be done after contract creation
198 	string public customText;					// Custom text
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
213 	
214 	// Informs watchers of the contract when a new lowest ask price has been set. (price, seller)
215 	event NewLowestAsk (uint256 price, address seller);
216 	
217 	// Informs watchers of the contract when a new highest bid price has been placed. (price, bidder)
218 	event NewHighestBid (uint256 price, address bidder);
219 	
220 	// Informs watchers of the contract when a piece has been transferred. (amount, from, to)
221 	event PieceTransferred (uint256 amount, address from, address to);
222 	
223 	// Informs watchers of the contract when a piece has been sold. (from, to, price)
224 	event PieceSold (address from, address to, uint256 price);
225 
226 	event Transfer (address indexed _from, address indexed _to, uint256 _value);
227 	event Approval (address indexed _owner, address indexed _spender, uint256 _value);
228 	event Burn (address indexed _owner, uint256 _amount);
229 
230 	/* Other variables */
231 	
232 	// Has the proof been set yet?
233 	bool public proofSet;
234 	
235 	// # of pieces awarded to Ethart.
236 	uint256 public ethartArtAwarded;
237 
238 	// Maps the number of pieces owned by an address
239 	mapping (address => uint256) public piecesOwned;
240 	
241 	// Used in burnFrom and transferFrom
242  	mapping (address => mapping (address => uint256)) allowed;
243 	
244 	// set after deployment of Registrar contract
245     address registrar = 0x5f68698245e8c8949450E68B8BD8acef37faaE7D;
246 	
247 	// Ethart reward variables - fixed after contract creation
248 	uint256 public ethartRevenueReward;
249 	uint256 public ethartArtReward;
250 	address public referrer;
251 	
252 	// Referrer receives referrerReward basis points of ethartRevenueReward
253 	uint256 public referrerReward;
254 
255 	// Constructor
256 	function Artwork (
257 		bytes32 _SHA256ofArtwork,
258 		uint256 _editionSize,
259 		string _title,
260 		string _fileLink,
261 		string _customText,
262 		uint256 _ownerCommission,
263 		address _owner
264 	) {
265 		if (_ownerCommission > (10000 - ethartRevenueReward)) {throw;}
266 		Interface a = Interface(registrar);
267 		ethartRevenueReward = a.getEthartRevenueReward();
268 		ethartArtReward = a.getEthartArtReward();
269 		referrer = a.getReferrer (_owner);
270 		referrerReward = a.getReferrerReward ();
271 		// Owner is set as the address spawning the contract
272 		owner = _owner;
273 		SHA256ofArtwork = _SHA256ofArtwork;
274 		editionSize = _editionSize;
275 		title = _title;
276 		fileLink = _fileLink;
277 		customText = _customText;
278 		ownerCommission = _ownerCommission;
279 		activationTime = now;	
280 	}
281 
282 	modifier onlyBy(address _account)
283 	{
284 		require(msg.sender == _account);
285 		_;
286 	}
287 
288 	// The registrar can execute certain functions only after one year
289 	modifier ethArtOnlyAfterOneYear()
290 	{
291 		require(msg.sender != registrar || now > activationTime + 31536000);
292 		_;
293 	}
294 
295 	// Sales / approvals have to be cancelled first for certain functions
296 	modifier notLocked(address _owner, uint256 _amount)
297 	{
298 		require(_owner != lowestAskAddress || piecesOwned[_owner] > _amount);
299 		_;
300 	}
301 
302 	// Mitigating ERC20 short address attacks (http://vessenes.com/the-erc20-short-address-attack-explained/)
303 	modifier onlyPayloadSize(uint size)
304 	{
305 		require(msg.data.length >= size + 4);
306 		_;
307 	}
308 
309 	// allows the current owner to assign a new owner
310 	function changeOwner (address newOwner) onlyBy (owner) {
311 		owner = newOwner;
312 		}
313 
314 	function setProof (string _proofLink) onlyBy (owner) {
315 		if (!proofSet) {
316 			uint256 remainder;
317 			proofLink = _proofLink;
318 			proofSet = true;
319 			remainder = editionSize % (10000 / ethartArtReward);
320 			ethartArtAwarded = (editionSize - remainder) / (10000 / ethartArtReward);
321 			// Yes - this is gameable - if it is that important to you: go ahead.
322 			if (remainder > 0 && now % ((10000 / ethartArtReward) - 1) <= remainder) {ethartArtAwarded++;}
323 			piecesOwned[registrar] = ethartArtAwarded;
324 			piecesOwned[owner] = editionSize - ethartArtAwarded;
325 			}
326 		else {throw;}
327 		}
328 
329 	function transfer(address _to, uint256 _amount) notLocked(msg.sender, _amount) onlyPayloadSize(2 * 32) returns (bool success) {
330 		if (piecesOwned[msg.sender] >= _amount 
331 			&& _amount > 0
332 			&& piecesOwned[_to] + _amount > piecesOwned[_to]
333 			// use burn() instead
334 			&& _to != 0x0)
335 			{
336 			piecesOwned[msg.sender] -= _amount;
337 			piecesOwned[_to] += _amount;
338 			Transfer(msg.sender, _to, _amount);
339 			return true;
340 			}
341 			else { return false;}
342  		 }
343 
344 	function totalSupply() constant returns (uint256 totalSupply) {
345 		totalSupply = editionSize;
346 		}
347 
348 	function balanceOf(address _owner) constant returns (uint256 balance) {
349  		return piecesOwned[_owner];
350 		}
351 
352 	function transferFrom(address _from, address _to, uint256 _amount) notLocked(_from, _amount) onlyPayloadSize(3 * 32)returns (bool success)
353 		{
354 			if (piecesOwned[_from] >= _amount
355 				&& allowed[_from][msg.sender] >= _amount
356 				&& _amount > 0
357 				&& piecesOwned[_to] + _amount > piecesOwned[_to]
358 				// use burn() instead
359 				&& _to != 0x0
360 				&& (_from != lowestAskAddress || piecesOwned[_from] > _amount))
361 					{
362 					piecesOwned[_from] -= _amount;
363 					allowed[_from][msg.sender] -= _amount;
364 					piecesOwned[_to] += _amount;
365 					Transfer(_from, _to, _amount);
366 					return true;
367 					} else {return false;}
368 		}
369 
370 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
371 	// If this function is called again it overwrites the current allowance with _value.
372 	// To be extra secure set allowance to 0 and check that none of our allowance was spend between you sending the tx and it getting mined. Only then decrease/increase the allowance.
373 	// See https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.m9fhqynw2xvt
374 	function approve(address _spender, uint256 _amount) returns (bool success) {
375 		allowed[msg.sender][_spender] = _amount;
376 		Approval(msg.sender, _spender, _amount);
377 		return true;
378 		}
379 
380 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
381 		return allowed[_owner][_spender];
382 		}
383 
384 	function burn(uint256 _amount) notLocked(msg.sender, _amount) returns (bool success) {
385 			if (piecesOwned[msg.sender] >= _amount) {
386 				piecesOwned[msg.sender] -= _amount;
387 				editionSize -= _amount;
388 				Burn(msg.sender, _amount);
389 				return true;
390 			}
391 			else {throw;}
392 		}
393 
394 	function burnFrom(address _from, uint256 _value) notLocked(_from, _value) onlyPayloadSize(2 * 32) returns (bool success) {
395 		if (piecesOwned[_from] >= _value && allowed[_from][msg.sender] >= _value) {
396 			piecesOwned[_from] -= _value;
397 			allowed[_from][msg.sender] -= _value;
398 			editionSize -= _value;
399 			Burn(_from, _value);
400 			return true;
401 		}
402 		else {throw;}
403 	}
404 
405 	function buyPiece() payable {
406 		if (pieceForSale && msg.value >= lowestAskPrice) {
407 			uint256 _amountOwner;
408 			uint256 _amountEthart;
409 			uint256 _amountSeller;
410 			uint256 _amountReferrer;
411 			_amountOwner = (msg.value / 10000) * ownerCommission;
412 			_amountEthart = (msg.value / 10000) * ethartRevenueReward;
413 			_amountSeller = msg.value - _amountOwner - _amountEthart;
414 			Interface a = Interface(registrar);
415 			if (referrer != 0x0) {
416 				_amountReferrer = _amountEthart / 10000 * referrerReward;
417 				_amountEthart -= _amountReferrer;
418 				// Async send the referrer reward to the referrer
419 				a.asyncSend(referrer, _amountReferrer);
420 				}
421 			piecesOwned[lowestAskAddress]--;
422 			piecesOwned[msg.sender]++;
423 			PieceSold (lowestAskAddress, msg.sender, msg.value);
424 			pieceForSale = false;
425 			lowestAskPrice = 0;
426 			// Reward the buyer with Patron tokens
427 			a.issuePatrons(msg.sender, msg.value);
428 			// Async send the contract owner's commission
429 			a.asyncSend(owner, _amountOwner);
430 			// Async send the buy price - commissions to seller
431 			a.asyncSend(lowestAskAddress, _amountSeller);
432 			lowestAskAddress = 0x0;
433 			// Async send Ethart commission to Ethart
434 			a.asyncSend(registrar, _amountEthart);
435 			// Transfer the sale price to the registrar contract
436 			registrar.transfer(msg.value);
437 		}
438 		else {throw;}
439 	}
440 
441 	// Offer a piece for sale at a fixed price - the price has to be lower than the current lowest price
442 	function offerPieceForSale (uint256 _price) ethArtOnlyAfterOneYear {
443 		if ((_price < lowestAskPrice || !pieceForSale) && piecesOwned[msg.sender] >= 1) {
444 				if (_price <= highestBidPrice) {fillBid();}
445 				else
446 				{
447 					pieceForSale = true;
448 					lowestAskPrice = _price;
449 					lowestAskAddress = msg.sender;
450 					lowestAskTime = now;
451 					NewLowestAsk (_price, lowestAskAddress);			// alerts contract watchers about new lowest ask price.
452 				}
453 		}
454 		else {throw;}
455 	}
456 
457 	// place a bid for a piece - bid has to be higher than current highest bid
458 	function placeBid () payable {
459 		if (msg.value > highestBidPrice || (pieceForSale && msg.value >= lowestAskPrice)) {
460 			if (pieceWanted) 
461 				{
462 					Interface a = Interface(registrar);
463 					a.asyncSend(highestBidAddress, highestBidPrice);
464 				}
465 			if (pieceForSale && msg.value >= lowestAskPrice) {buyPiece();}
466 			else
467 				{
468 					pieceWanted = true;
469 					highestBidPrice = msg.value;
470 					highestBidAddress = msg.sender;
471 					highestBidTime = now;
472 					NewHighestBid (msg.value, highestBidAddress);
473 					registrar.transfer(msg.value);
474 				}
475 		}
476 		else {throw;}
477 	}
478 
479 	// If the current lowest ask address wants to fill a bid it has to either cancel it's sale first and then
480 	// fill the bid or lower the lowest ask price to be equal or lower than the highest bid.
481 	function fillBid () ethArtOnlyAfterOneYear notLocked(msg.sender, 1) {
482 		if (pieceWanted && piecesOwned[msg.sender] >= 1) {
483 			uint256 _amountOwner;														
484 			uint256 _amountEthart;
485 			uint256 _amountSeller;
486 			uint256 _amountReferrer;
487 			_amountOwner = (highestBidPrice / 10000) * ownerCommission;
488 			_amountEthart = (highestBidPrice / 10000) * ethartRevenueReward;
489 			_amountSeller = highestBidPrice - _amountOwner - _amountEthart;
490 			Interface a = Interface(registrar);
491 			if (referrer != 0x0) {
492 				_amountReferrer = _amountEthart / 10000 * referrerReward;
493 				_amountEthart -= _amountReferrer;
494 				// Async send the referrer reward to the referrer
495 				a.asyncSend(referrer, _amountReferrer);
496 				}
497 			piecesOwned[highestBidAddress]++;
498 			// Reward the buyer with Patron tokens
499 			a.issuePatrons(highestBidAddress, highestBidPrice);				
500 			piecesOwned[msg.sender]--;
501 			PieceSold (msg.sender, highestBidAddress, highestBidPrice);
502 			pieceWanted = false;
503 			highestBidPrice = 0;
504 			highestBidAddress = 0x0;
505 			// Async send the contract owner's commission
506 			a.asyncSend(owner, _amountOwner);
507 			// Async send the buy price - commissions to seller
508 			a.asyncSend(msg.sender, _amountSeller);
509 			// Async send Ethart commission to Ethart
510 			a.asyncSend(registrar, _amountEthart);
511 		}
512 		else {throw;}
513 	}
514 
515 	// withdraw a bid - bids can only be withdrawn after 24 hours of being placed
516 	function cancelBid () onlyBy (highestBidAddress){
517 		if (pieceWanted && now > highestBidTime + 86400) {
518 			pieceWanted = false;
519 			highestBidPrice = 0;
520 			highestBidAddress = 0x0;
521 			NewHighestBid (0, 0x0);
522 			Interface a = Interface(registrar);
523 			a.asyncSend(msg.sender, highestBidPrice);			
524 		}
525 		else {throw;}
526 	}
527 
528 	// cancels sales - sales can only be canceled 24 hours after it has been offered for sale
529 	function cancelSale () onlyBy (lowestAskAddress){
530 		if(pieceForSale && now > lowestAskTime + 86400) {
531 			pieceForSale = false;
532 			lowestAskPrice = 0;
533 			lowestAskAddress = 0x0;
534 			NewLowestAsk (0, 0x0);
535 		}
536 		else {throw;}
537 	}
538 
539 }