1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC721 interface
5  * @dev see https://github.com/ethereum/eips/issues/721
6  */
7 contract ERC721 {
8   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
9   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
10 
11   function balanceOf(address _owner) public view returns (uint256 _balance);
12   function ownerOf(uint256 _tokenId) public view returns (address _owner);
13   function transfer(address _to, uint256 _tokenId) public;
14   function approve(address _to, uint256 _tokenId) public;
15   function takeOwnership(uint256 _tokenId) public;
16 }
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26   mapping (address => bool) public admins;
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37     admins[owner] = true;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48   
49   modifier onlyAdmin() {
50     require(admins[msg.sender]);
51     _;
52   }
53 
54   function changeAdmin(address _newAdmin, bool _approved) onlyOwner public {
55     admins[_newAdmin] = _approved;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a * b;
77     assert(a == 0 || c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92   
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title ERC721Token
102  * Generic implementation for the required functionality of the ERC721 standard
103  */
104 contract Economeme is ERC721, Ownable {
105   using SafeMath for uint256;
106 
107   // Total amount of tokens
108   uint256 private totalTokens;
109   uint256 public developerCut;
110   uint256 public submissionPool; // The fund amount gained from submissions.
111   uint256 public submissionPrice; // How much it costs to submit a meme.
112   uint256 public endingBalance; // Balance at the end of the last purchase.
113 
114   // Meme Data
115   mapping (uint256 => Meme) public memeData;
116 
117   // Mapping from token ID to owner
118   mapping (uint256 => address) private tokenOwner;
119 
120   // Mapping from token ID to approved address
121   mapping (uint256 => address) private tokenApprovals;
122 
123   // Mapping from owner to list of owned token IDs
124   mapping (address => uint256[]) private ownedTokens;
125 
126   // Mapping from token ID to index of the owner tokens list
127   mapping(uint256 => uint256) private ownedTokensIndex;
128 
129   // Balances from % payouts.
130   mapping (address => uint256) public creatorBalances;
131 
132   // Events
133   event Purchase(uint256 indexed _tokenId, address indexed _buyer, address indexed _seller, uint256 _purchasePrice);
134   event Creation(address indexed _creator, uint256 _tokenId, uint256 _timestamp);
135 
136   // Purchasing caps for determining next price
137   uint256 private firstCap  = 0.02 ether;
138   uint256 private secondCap = 0.5 ether;
139   uint256 private thirdCap  = 2.0 ether;
140   uint256 private finalCap  = 5.0 ether;
141 
142   // Struct to store Meme data
143   struct Meme {
144     uint256 price;         // Current price of the item.
145     address owner;         // Current owner of the item.
146     address creator;       // Address that created dat boi.
147   }
148   
149   function Economeme() public {
150     submissionPrice = 1 ether / 100;
151   }
152 
153 /** ******************************* Buying ********************************* **/
154 
155   /**
156   * @dev Purchase meme from previous owner
157   * @param _tokenId uint256 of token
158   */
159   function buyToken(uint256 _tokenId) public 
160     payable
161   {
162     // get data from storage
163     Meme storage meme = memeData[_tokenId];
164     uint256 price = meme.price;
165     address oldOwner = meme.owner;
166     address newOwner = msg.sender;
167     uint256 excess = msg.value.sub(price);
168 
169     // revert checks
170     require(price > 0);
171     require(msg.value >= price);
172     require(oldOwner != msg.sender);
173     
174     uint256 devCut = price.mul(2).div(100);
175     developerCut = developerCut.add(devCut);
176 
177     uint256 creatorCut = price.mul(2).div(100);
178     creatorBalances[meme.creator] = creatorBalances[meme.creator].add(creatorCut);
179 
180     uint256 transferAmount = price.sub(creatorCut + devCut);
181 
182     transferToken(oldOwner, newOwner, _tokenId);
183 
184     // raise event
185     emit Purchase(_tokenId, newOwner, oldOwner, price);
186 
187     // set new price
188     meme.price = getNextPrice(price);
189 
190     // Safe transfer to owner that will bypass throws on bad contracts.
191     safeTransfer(oldOwner, transferAmount);
192     
193     // Send refund to buyer if needed
194     if (excess > 0) {
195       newOwner.transfer(excess);
196     }
197     
198     // If safeTransfer did not succeed, we take lost funds into our cut and will return manually if it wasn't malicious.
199     // Otherwise we're going out for some beers.
200     if (address(this).balance > endingBalance + creatorCut + devCut) submissionPool += transferAmount;
201     
202     endingBalance = address(this).balance;
203   }
204 
205   /**
206    * @dev safeTransfer allows a push to an address that will not revert if the address throws.
207    * @param _oldOwner The owner that funds will be transferred to.
208    * @param _amount The amount of funds that will be transferred.
209   */
210   function safeTransfer(address _oldOwner, uint256 _amount) internal { 
211     assembly { 
212         let x := mload(0x40) 
213         let success := call(
214             5000, 
215             _oldOwner, 
216             _amount, 
217             x, 
218             0x0, 
219             x, 
220             0x20) 
221         mstore(0x40,add(x,0x20)) 
222     } 
223   }
224 
225   /**
226   * @dev Transfer Token from Previous Owner to New Owner
227   * @param _from previous owner address
228   * @param _to new owner address
229   * @param _tokenId uint256 ID of token
230   */
231   function transferToken(address _from, address _to, uint256 _tokenId) internal {
232     // check token exists
233     require(tokenExists(_tokenId));
234 
235     // make sure previous owner is correct
236     require(memeData[_tokenId].owner == _from);
237 
238     require(_to != address(0));
239     require(_to != address(this));
240 
241     // clear approvals linked to this token
242     clearApproval(_from, _tokenId);
243 
244     // remove token from previous owner
245     removeToken(_from, _tokenId);
246 
247     // update owner and add token to new owner
248     addToken(_to, _tokenId);
249 
250     // raise event
251     emit Transfer(_from, _to, _tokenId);
252   }
253   
254   /**
255   * @dev Determines next price of token
256   * @param _price uint256 ID of current price
257   */
258   function getNextPrice (uint256 _price) internal view returns (uint256 _nextPrice) {
259     if (_price < firstCap) {
260       return _price.mul(200).div(95);
261     } else if (_price < secondCap) {
262       return _price.mul(135).div(96);
263     } else if (_price < thirdCap) {
264       return _price.mul(125).div(97);
265     } else if (_price < finalCap) {
266       return _price.mul(117).div(97);
267     } else {
268       return _price.mul(115).div(98);
269     }
270   }
271 
272 /** *********************** Player Administrative ************************** **/
273 
274   /**
275   * @dev Used by posters to submit and create a new meme.
276   */
277   function createToken() external payable {
278     // make sure token hasn't been used yet
279     uint256 tokenId = totalTokens + 1;
280     require(memeData[tokenId].price == 0);
281     require(msg.value == submissionPrice);
282     submissionPool += submissionPrice;
283     endingBalance = address(this).balance;
284     
285     // create new token
286     memeData[tokenId] = Meme(1 ether / 100, msg.sender, msg.sender);
287 
288     // mint new token
289     _mint(msg.sender, tokenId);
290     
291     emit Creation(msg.sender, tokenId, block.timestamp);
292   }
293 
294   /**
295   * @dev Withdraw anyone's creator balance.
296   * @param _beneficiary The person whose balance shall be sent to them.
297   */
298   function withdrawBalance(address _beneficiary) external {
299     uint256 payout = creatorBalances[_beneficiary];
300     creatorBalances[_beneficiary] = 0;
301     _beneficiary.transfer(payout);
302     endingBalance = address(this).balance;
303   }
304 
305 /** **************************** Frontend ********************************** **/
306 
307   /**
308   * @dev Return all relevant data for a meme.
309   * @param _tokenId Unique meme ID.
310   */
311   function getMemeData (uint256 _tokenId) external view 
312   returns (address _owner, uint256 _price, uint256 _nextPrice, address _creator) 
313   {
314     Meme memory meme = memeData[_tokenId];
315     return (meme.owner, meme.price, getNextPrice(meme.price), meme.creator);
316   }
317 
318   /**
319   * @dev Check the creator balance of a certain address.
320   * @param _owner The address to check the balance of.
321   */
322   function checkBalance(address _owner) external view returns (uint256) {
323     return creatorBalances[_owner];
324   }
325 
326   /**
327   * @dev Determines if token exists by checking it's price
328   * @param _tokenId uint256 ID of token
329   */
330   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
331     return memeData[_tokenId].price > 0;
332   }
333   
334 /** ***************************** Only Admin ******************************* **/
335   
336   /**
337    * @dev Withdraw dev's cut
338    * @param _devAmount The amount to withdraw from developer cut.
339    * @param _submissionAmount The amount to withdraw from submission pool.
340   */
341   function withdraw(uint256 _devAmount, uint256 _submissionAmount) public onlyAdmin() {
342     if (_devAmount == 0) { 
343       _devAmount = developerCut; 
344     }
345     if (_submissionAmount == 0) {
346       _submissionAmount = submissionPool;
347     }
348     developerCut = developerCut.sub(_devAmount);
349     submissionPool = submissionPool.sub(_submissionAmount);
350     owner.transfer(_devAmount + _submissionAmount);
351     endingBalance = address(this).balance;
352   }
353 
354   /**
355    * @dev Admin may refund a submission to a user.
356    * @param _refundee The address to refund.
357    * @param _amount The amount of wei to refund.
358   */
359   function refundSubmission(address _refundee, uint256 _amount) external onlyAdmin() {
360     submissionPool = submissionPool.sub(_amount);
361     _refundee.transfer(_amount);
362     endingBalance = address(this).balance;
363   }
364   
365   /**
366    * @dev Refund a submission by a specific tokenId.
367    * @param _tokenId The unique Id of the token to be refunded at current submission price.
368   */
369   function refundByToken(uint256 _tokenId) external onlyAdmin() {
370     submissionPool = submissionPool.sub(submissionPrice);
371     memeData[_tokenId].creator.transfer(submissionPrice);
372     endingBalance = address(this).balance;
373   }
374 
375   /**
376    * @dev Change how much it costs to submit a meme.
377    * @param _newPrice The new price of submission.
378   */
379   function changeSubmissionPrice(uint256 _newPrice) external onlyAdmin() {
380     submissionPrice = _newPrice;
381   }
382 
383 
384 /** ***************************** Modifiers ******************************** **/
385 
386   /**
387   * @dev Guarantees msg.sender is owner of the given token
388   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
389   */
390   modifier onlyOwnerOf(uint256 _tokenId) {
391     require(ownerOf(_tokenId) == msg.sender);
392     _;
393   }
394 
395 /** ******************************* ERC721 ********************************* **/
396 
397   /**
398   * @dev Gets the total amount of tokens stored by the contract
399   * @return uint256 representing the total amount of tokens
400   */
401   function totalSupply() public view returns (uint256) {
402     return totalTokens;
403   }
404 
405   /**
406   * @dev Gets the balance of the specified address
407   * @param _owner address to query the balance of
408   * @return uint256 representing the amount owned by the passed address
409   */
410   function balanceOf(address _owner) public view returns (uint256) {
411     return ownedTokens[_owner].length;
412   }
413 
414   /**
415   * @dev Gets the list of tokens owned by a given address
416   * @param _owner address to query the tokens of
417   * @return uint256[] representing the list of tokens owned by the passed address
418   */
419   function tokensOf(address _owner) public view returns (uint256[]) {
420     return ownedTokens[_owner];
421   }
422 
423   /**
424   * @dev Gets the owner of the specified token ID
425   * @param _tokenId uint256 ID of the token to query the owner of
426   * @return owner address currently marked as the owner of the given token ID
427   */
428   function ownerOf(uint256 _tokenId) public view returns (address) {
429     address owner = tokenOwner[_tokenId];
430     return owner;
431   }
432 
433   /**
434    * @dev Gets the approved address to take ownership of a given token ID
435    * @param _tokenId uint256 ID of the token to query the approval of
436    * @return address currently approved to take ownership of the given token ID
437    */
438   function approvedFor(uint256 _tokenId) public view returns (address) {
439     return tokenApprovals[_tokenId];
440   }
441 
442   /**
443   * @dev Transfers the ownership of a given token ID to another address
444   * @param _to address to receive the ownership of the given token ID
445   * @param _tokenId uint256 ID of the token to be transferred
446   */
447   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
448     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
449   }
450 
451   /**
452   * @dev Approves another address to claim for the ownership of the given token ID
453   * @param _to address to be approved for the given token ID
454   * @param _tokenId uint256 ID of the token to be approved
455   */
456   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
457     address owner = ownerOf(_tokenId);
458     require(_to != owner);
459     if (approvedFor(_tokenId) != 0 || _to != 0) {
460       tokenApprovals[_tokenId] = _to;
461       emit Approval(owner, _to, _tokenId);
462     }
463   }
464 
465   /**
466   * @dev Claims the ownership of a given token ID
467   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
468   */
469   function takeOwnership(uint256 _tokenId) public {
470     require(isApprovedFor(msg.sender, _tokenId));
471     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
472   }
473 
474   /**
475    * @dev Tells whether the msg.sender is approved for the given token ID or not
476    * This function is not private so it can be extended in further implementations like the operatable ERC721
477    * @param _owner address of the owner to query the approval of
478    * @param _tokenId uint256 ID of the token to query the approval of
479    * @return bool whether the msg.sender is approved for the given token ID or not
480    */
481   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
482     return approvedFor(_tokenId) == _owner;
483   }
484   
485   /**
486   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
487   * @param _from address which you want to send tokens from
488   * @param _to address which you want to transfer the token to
489   * @param _tokenId uint256 ID of the token to be transferred
490   */
491   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
492     require(_to != address(0));
493     require(_to != ownerOf(_tokenId));
494     require(ownerOf(_tokenId) == _from);
495 
496     clearApproval(_from, _tokenId);
497     removeToken(_from, _tokenId);
498     addToken(_to, _tokenId);
499     emit Transfer(_from, _to, _tokenId);
500   }
501 
502   /**
503   * @dev Internal function to clear current approval of a given token ID
504   * @param _tokenId uint256 ID of the token to be transferred
505   */
506   function clearApproval(address _owner, uint256 _tokenId) private {
507     require(ownerOf(_tokenId) == _owner);
508     tokenApprovals[_tokenId] = 0;
509     emit Approval(_owner, 0, _tokenId);
510   }
511 
512 
513     /**
514   * @dev Mint token function
515   * @param _to The address that will own the minted token
516   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
517   */
518   function _mint(address _to, uint256 _tokenId) internal {
519     addToken(_to, _tokenId);
520     emit Transfer(0x0, _to, _tokenId);
521   }
522 
523   /**
524   * @dev Internal function to add a token ID to the list of a given address
525   * @param _to address representing the new owner of the given token ID
526   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
527   */
528   function addToken(address _to, uint256 _tokenId) private {
529     require(tokenOwner[_tokenId] == address(0));
530     tokenOwner[_tokenId] = _to;
531     memeData[_tokenId].owner = _to;
532     
533     uint256 length = balanceOf(_to);
534     ownedTokens[_to].push(_tokenId);
535     ownedTokensIndex[_tokenId] = length;
536     totalTokens = totalTokens.add(1);
537   }
538 
539   /**
540   * @dev Internal function to remove a token ID from the list of a given address
541   * @param _from address representing the previous owner of the given token ID
542   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
543   */
544   function removeToken(address _from, uint256 _tokenId) private {
545     require(ownerOf(_tokenId) == _from);
546 
547     uint256 tokenIndex = ownedTokensIndex[_tokenId];
548     uint256 lastTokenIndex = balanceOf(_from).sub(1);
549     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
550 
551     tokenOwner[_tokenId] = 0;
552     ownedTokens[_from][tokenIndex] = lastToken;
553     ownedTokens[_from][lastTokenIndex] = 0;
554     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
555     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
556     // the lastToken to the first position, and then dropping the element placed in the last position of the list
557 
558     ownedTokens[_from].length--;
559     ownedTokensIndex[_tokenId] = 0;
560     ownedTokensIndex[lastToken] = tokenIndex;
561     totalTokens = totalTokens.sub(1);
562   }
563 
564   function name() public pure returns (string _name) {
565     return "Economeme Meme";
566   }
567 
568   function symbol() public pure returns (string _symbol) {
569     return "ECME";
570   }
571 
572 }