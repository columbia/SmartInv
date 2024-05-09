1 pragma solidity ^0.4.19;
2 
3 
4 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 contract Ownable {
28     
29 	  // The addresses of the accounts (or contracts) that can execute actions within each roles.
30 	address public hostAddress;
31 	address public adminAddress;
32     
33     function Ownable() public {
34 		hostAddress = msg.sender;
35 		adminAddress = msg.sender;
36     }
37 
38     modifier onlyHost() {
39         require(msg.sender == hostAddress); 
40         _;
41     }
42 	
43     modifier onlyAdmin() {
44         require(msg.sender == adminAddress);
45         _;
46     }
47 	
48 	/// Access modifier for contract owner only functionality
49 	modifier onlyHostOrAdmin() {
50 		require(
51 		  msg.sender == hostAddress ||
52 		  msg.sender == adminAddress
53 		);
54 		_;
55 	}
56 
57 	function setHost(address _newHost) public onlyHost {
58 		require(_newHost != address(0));
59 
60 		hostAddress = _newHost;
61 	}
62     
63 	function setAdmin(address _newAdmin) public onlyHost {
64 		require(_newAdmin != address(0));
65 
66 		adminAddress = _newAdmin;
67 	}
68 }
69 
70 contract TokensWarContract is ERC721, Ownable {
71         
72     /*** EVENTS ***/
73         
74     /// @dev The NewHero event is fired whenever a new card comes into existence.
75     event NewToken(uint256 tokenId, string name, address owner);
76         
77     /// @dev The NewTokenOwner event is fired whenever a token is sold.
78     event NewTokenOwner(uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, uint256 tokenId);
79     
80     /// @dev The NewGoldenCard event is fired whenever a golden card is change.
81     event NewGoldenToken(uint256 goldenPayment);
82         
83     /// @dev Transfer event as defined in current draft of ERC721. ownership is assigned, including births.
84     event Transfer(address from, address to, uint256 tokenId);
85         
86     /*** CONSTANTS ***/
87         
88     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
89     string public constant NAME = "TokensWarContract"; // solhint-disable-line
90     string public constant SYMBOL = "TWC"; // solhint-disable-line
91       
92     uint256 private startingPrice = 0.001 ether; 
93     uint256 private firstStepLimit =  0.045 ether; //5 iteration
94     uint256 private secondStepLimit =  0.45 ether; //8 iteration
95     uint256 private thirdStepLimit = 1.00 ether; //10 iteration
96         
97     /*** STORAGE ***/
98         
99     /// @dev A mapping from card IDs to the address that owns them. All cards have
100     ///  some valid owner address.
101     mapping (uint256 => address) public cardTokenToOwner;
102         
103     // @dev A mapping from owner address to count of tokens that address owns.
104     //  Used internally inside balanceOf() to resolve ownership count.
105     mapping (address => uint256) private ownershipTokenCount;
106         
107     /// @dev A mapping from CardIDs to an address that has been approved to call
108     ///  transferFrom(). Each card can only have one approved address for transfer
109     ///  at any time. A zero value means no approval is outstanding.
110     mapping (uint256 => address) public cardTokenToApproved;
111         
112     // @dev A mapping from CardIDs to the price of the token.
113     mapping (uint256 => uint256) private cardTokenToPrice;
114         
115     // @dev A mapping from CardIDs to the position of the item in array.
116     mapping (uint256 => uint256) private cardTokenToPosition;
117     
118     // @dev tokenId of golden card.
119     uint256 public goldenTokenId;
120     
121     /*** STORAGE ***/
122     
123 	/*** ------------------------------- ***/
124     
125     /*** CARDS ***/
126     
127 	/*** DATATYPES ***/
128 	struct Card {
129 		uint256 token;
130 		string name;
131 	}
132 
133 	Card[] private cards;
134     
135 	
136 	/// @notice Returns all the relevant information about a specific card.
137 	/// @param _tokenId The tokenId of the card of interest.
138 	function getCard(uint256 _tokenId) public view returns (
139 		string name,
140 		uint256 token
141 	) {
142 	    
143 	    address owner = cardTokenToOwner[_tokenId];
144         require(owner != address(0));
145 	    
146 	    uint256 index = cardTokenToPosition[_tokenId];
147 	    Card storage card = cards[index];
148 		name = card.name;
149 		token = card.token;
150 	}
151     
152     /// @dev Creates a new token with the given name.
153 	function createToken(string _name, uint256 _id) public onlyAdmin {
154 		_createToken(_name, _id, address(this), startingPrice);
155 	}
156 	
157     /// @dev set golden card token.
158 	function setGoldenCardToken(uint256 tokenId) public onlyAdmin {
159 		goldenTokenId = tokenId;
160 		NewGoldenToken(goldenTokenId);
161 	}
162 	
163 	function _createToken(string _name, uint256 _id, address _owner, uint256 _price) private {
164 	    
165 		Card memory _card = Card({
166 		  name: _name,
167 		  token: _id
168 		});
169 			
170 		uint256 index = cards.push(_card) - 1;
171 		cardTokenToPosition[_id] = index;
172 		// It's probably never going to happen, 4 billion tokens are A LOT, but
173 		// let's just be 100% sure we never let this happen.
174 		require(_id == uint256(uint32(_id)));
175 
176 		NewToken(_id, _name, _owner);
177 		cardTokenToPrice[_id] = _price;
178 		// This will assign ownership, and also emit the Transfer event as
179 		// per ERC721 draft
180 		_transfer(address(0), _owner, _id);
181 	}
182 	/*** CARDS ***/
183 	
184 	/*** ------------------------------- ***/
185 	
186 	/*** ERC721 FUNCTIONS ***/
187     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
188     /// @param _to The address to be granted transfer approval. Pass address(0) to
189     ///  clear all approvals.
190     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
191     /// @dev Required for ERC-721 compliance.
192     function approve(
193         address _to,
194         uint256 _tokenId
195       ) public {
196         // Caller must own token.
197         require(_owns(msg.sender, _tokenId));
198     
199         cardTokenToApproved[_tokenId] = _to;
200     
201         Approval(msg.sender, _to, _tokenId);
202     }
203     
204     /// For querying balance of a particular account
205     /// @param _owner The address for balance query
206     /// @dev Required for ERC-721 compliance.
207     function balanceOf(address _owner) public view returns (uint256 balance) {
208         return ownershipTokenCount[_owner];
209     }
210     
211     function implementsERC721() public pure returns (bool) {
212         return true;
213     }
214     
215 
216     /// For querying owner of token
217     /// @param _tokenId The tokenID for owner inquiry
218     /// @dev Required for ERC-721 compliance.
219     function ownerOf(uint256 _tokenId) public view returns (address owner) {
220         owner = cardTokenToOwner[_tokenId];
221         require(owner != address(0));
222     }
223     
224     /// @notice Allow pre-approved user to take ownership of a token
225     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
226     /// @dev Required for ERC-721 compliance.
227     function takeOwnership(uint256 _tokenId) public {
228         address newOwner = msg.sender;
229         address oldOwner = cardTokenToOwner[_tokenId];
230     
231         // Safety check to prevent against an unexpected 0x0 default.
232         require(_addressNotNull(newOwner));
233 
234         // Making sure transfer is approved
235         require(_approved(newOwner, _tokenId));
236     
237         _transfer(oldOwner, newOwner, _tokenId);
238     }
239     
240     /// For querying totalSupply of token
241     /// @dev Required for ERC-721 compliance.
242     function totalSupply() public view returns (uint256 total) {
243         return cards.length;
244     }
245     
246     /// Third-party initiates transfer of token from address _from to address _to
247     /// @param _from The address for the token to be transferred from.
248     /// @param _to The address for the token to be transferred to.
249     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
250     /// @dev Required for ERC-721 compliance.
251     function transferFrom(address _from, address _to, uint256 _tokenId) public {
252         require(_owns(_from, _tokenId));
253         require(_approved(_to, _tokenId));
254         require(_addressNotNull(_to));
255     
256         _transfer(_from, _to, _tokenId);
257     }
258 
259     /// Owner initates the transfer of the token to another account
260     /// @param _to The address for the token to be transferred to.
261     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
262     /// @dev Required for ERC-721 compliance.
263     function transfer(address _to, uint256 _tokenId) public {
264         require(_owns(msg.sender, _tokenId));
265         require(_addressNotNull(_to));
266     
267         _transfer(msg.sender, _to, _tokenId);
268     }
269     
270     /// @dev Required for ERC-721 compliance.
271     function name() public pure returns (string) {
272         return NAME;
273     }
274     
275     /// @dev Required for ERC-721 compliance.
276     function symbol() public pure returns (string) {
277         return SYMBOL;
278     }
279 
280 	/*** ERC721 FUNCTIONS ***/
281 	
282 	/*** ------------------------------- ***/
283 	
284 	/*** ADMINISTRATOR FUNCTIONS ***/
285 	
286 	//send balance of contract on wallet
287 	function payout(address _to) public onlyHostOrAdmin {
288 		_payout(_to);
289 	}
290 	
291 	function _payout(address _to) private {
292 		if (_to == address(0)) {
293 			hostAddress.transfer(this.balance);
294 		} else {
295 			_to.transfer(this.balance);
296 		}
297 	}
298 	
299 	/*** ADMINISTRATOR FUNCTIONS ***/
300 	
301 
302     /*** PUBLIC FUNCTIONS ***/
303 
304     function contractBalance() public  view returns (uint256 balance) {
305         return address(this).balance;
306     }
307     
308 
309 
310   // Allows someone to send ether and obtain the token
311   function purchase(uint256 _tokenId) public payable {
312     address oldOwner = cardTokenToOwner[_tokenId];
313     address newOwner = msg.sender;
314     
315     require(oldOwner != address(0));
316 
317     uint256 sellingPrice = cardTokenToPrice[_tokenId];
318 
319     // Making sure token owner is not sending to self
320     require(oldOwner != newOwner);
321 
322     // Safety check to prevent against an unexpected 0x0 default.
323     require(_addressNotNull(newOwner));
324 
325     // Making sure sent amount is greater than or equal to the sellingPrice
326     require(msg.value >= sellingPrice);
327 
328     uint256 payment = uint256(Helper.div(Helper.mul(sellingPrice, 93), 100));
329     uint256 goldenPayment = uint256(Helper.div(Helper.mul(sellingPrice, 2), 100));
330     
331     uint256 purchaseExcess = Helper.sub(msg.value, sellingPrice);
332 
333     // Update prices
334     if (sellingPrice < firstStepLimit) {
335       // first stage
336       cardTokenToPrice[_tokenId] = Helper.div(Helper.mul(sellingPrice, 300), 93);
337     } else if (sellingPrice < secondStepLimit) {
338       // second stage
339       cardTokenToPrice[_tokenId] = Helper.div(Helper.mul(sellingPrice, 200), 93);
340     } else if (sellingPrice < thirdStepLimit) {
341       // second stage
342       cardTokenToPrice[_tokenId] = Helper.div(Helper.mul(sellingPrice, 120), 93);
343     } else {
344       // third stage
345       cardTokenToPrice[_tokenId] = Helper.div(Helper.mul(sellingPrice, 115), 93);
346     }
347 
348     _transfer(oldOwner, newOwner, _tokenId);
349 
350     // Pay previous tokenOwner if owner is not contract
351     if (oldOwner != address(this)) {
352       oldOwner.transfer(payment); //-0.05
353     }
354     
355     //Pay golden commission
356     address goldenOwner = cardTokenToOwner[goldenTokenId];
357     if (goldenOwner != address(0)) {
358       goldenOwner.transfer(goldenPayment); //-0.02
359     }
360 
361 	//CONTRACT EVENT 
362 	uint256 index = cardTokenToPosition[_tokenId];
363     NewTokenOwner(sellingPrice, cardTokenToPrice[_tokenId], oldOwner, newOwner, cards[index].name, _tokenId);
364 
365     msg.sender.transfer(purchaseExcess);
366     
367   }
368 
369   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
370     return cardTokenToPrice[_tokenId];
371   }
372 
373 
374 
375   /// @param _owner The owner whose celebrity tokens we are interested in.
376   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
377   ///  expensive (it walks the entire cards array looking for cards belonging to owner),
378   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
379   ///  not contract-to-contract calls.
380   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
381     uint256 tokenCount = balanceOf(_owner);
382     if (tokenCount == 0) {
383         // Return an empty array
384       return new uint256[](0);
385     } else {
386       uint256[] memory result = new uint256[](tokenCount);
387       uint256 totalCards = totalSupply();
388       uint256 resultIndex = 0;
389 
390       uint256 index;
391       for (index = 0; index <= totalCards-1; index++) {
392         if (cardTokenToOwner[cards[index].token] == _owner) {
393           result[resultIndex] = cards[index].token;
394           resultIndex++;
395         }
396       }
397       return result;
398     }
399   }
400 
401   /*** PRIVATE FUNCTIONS ***/
402   /// Safety check on _to address to prevent against an unexpected 0x0 default.
403   function _addressNotNull(address _to) private pure returns (bool) {
404     return _to != address(0);
405   }
406 
407   /// For checking approval of transfer for address _to
408   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
409     return cardTokenToApproved[_tokenId] == _to;
410   }
411 
412   /// Check for token ownership
413   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
414     return claimant == cardTokenToOwner[_tokenId];
415   }
416 
417 
418   /// @dev Assigns ownership of a specific card to an address.
419   function _transfer(address _from, address _to, uint256 _tokenId) private {
420     // Since the number of cards is capped to 2^32 we can't overflow this
421     ownershipTokenCount[_to]++;
422     //transfer ownership
423     cardTokenToOwner[_tokenId] = _to;
424 
425     // When creating new cards _from is 0x0, but we can't account that address.
426     if (_from != address(0)) {
427       ownershipTokenCount[_from]--;
428       // clear any previously approved ownership exchange
429       delete cardTokenToApproved[_tokenId];
430     }
431 
432     // Emit the transfer event.
433     Transfer(_from, _to, _tokenId);
434   }
435   
436 
437     function TokensWarContract() public {
438     }
439     
440 }
441 
442 library Helper {
443 
444   /**
445   * @dev Multiplies two numbers, throws on overflow.
446   */
447   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
448     if (a == 0) {
449       return 0;
450     }
451     uint256 c = a * b;
452     assert(c / a == b);
453     return c;
454   }
455 
456   /**
457   * @dev Integer division of two numbers, truncating the quotient.
458   */
459   function div(uint256 a, uint256 b) internal pure returns (uint256) {
460     // assert(b > 0); // Solidity automatically throws when dividing by 0
461     uint256 c = a / b;
462     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
463     return c;
464   }
465 
466   /**
467   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
468   */
469   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470     assert(b <= a);
471     return a - b;
472   }
473 
474   /**
475   * @dev Adds two numbers, throws on overflow.
476   */
477   function add(uint256 a, uint256 b) internal pure returns (uint256) {
478     uint256 c = a + b;
479     assert(c >= a);
480     return c;
481   }
482 }