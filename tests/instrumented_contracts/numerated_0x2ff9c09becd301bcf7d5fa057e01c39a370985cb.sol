1 pragma solidity ^0.4.18;
2 
3 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // KpopItem is a ERC-721 token (https://github.com/ethereum/eips/issues/721)
52 // Each KpopItem has its connected KpopToken celebrity card
53 // Kpop.io is the official website
54 
55 contract ERC721 {
56   function approve(address _to, uint _tokenId) public;
57   function balanceOf(address _owner) public view returns (uint balance);
58   function implementsERC721() public pure returns (bool);
59   function ownerOf(uint _tokenId) public view returns (address addr);
60   function takeOwnership(uint _tokenId) public;
61   function totalSupply() public view returns (uint total);
62   function transferFrom(address _from, address _to, uint _tokenId) public;
63   function transfer(address _to, uint _tokenId) public;
64 
65   event Transfer(address indexed from, address indexed to, uint tokenId);
66   event Approval(address indexed owner, address indexed approved, uint tokenId);
67 }
68 
69 contract KpopToken is ERC721 {
70   address public author;
71   address public coauthor;
72 
73   string public constant NAME = "Kpopio";
74   string public constant SYMBOL = "KpopToken";
75 
76   uint public GROWTH_BUMP = 0.1 ether;
77   uint public MIN_STARTING_PRICE = 0.002 ether;
78   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
79 
80   struct Celeb {
81     string name;
82   }
83 
84   Celeb[] public celebs;
85 
86   mapping(uint => address) public tokenIdToOwner;
87   mapping(uint => uint) public tokenIdToPrice; // in wei
88   mapping(address => uint) public userToNumCelebs;
89   mapping(uint => address) public tokenIdToApprovedRecipient;
90 
91   event Transfer(address indexed from, address indexed to, uint tokenId);
92   event Approval(address indexed owner, address indexed approved, uint tokenId);
93   event CelebSold(uint tokenId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);
94 
95   function KpopToken() public {
96     author = msg.sender;
97     coauthor = msg.sender;
98   }
99 
100   function _transfer(address _from, address _to, uint _tokenId) private {
101     require(ownerOf(_tokenId) == _from);
102     require(!isNullAddress(_to));
103     require(balanceOf(_from) > 0);
104 
105     uint prevBalances = balanceOf(_from) + balanceOf(_to);
106     tokenIdToOwner[_tokenId] = _to;
107     userToNumCelebs[_from]--;
108     userToNumCelebs[_to]++;
109 
110     // Clear outstanding approvals
111     delete tokenIdToApprovedRecipient[_tokenId];
112 
113     Transfer(_from, _to, _tokenId);
114 
115     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
116   }
117 
118   function buy(uint _tokenId) payable public {
119     address prevOwner = ownerOf(_tokenId);
120     uint currentPrice = tokenIdToPrice[_tokenId];
121 
122     require(prevOwner != msg.sender);
123     require(!isNullAddress(msg.sender));
124     require(msg.value >= currentPrice);
125 
126     // Take a cut off the payment
127     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));
128     uint leftover = SafeMath.sub(msg.value, currentPrice);
129     uint newPrice;
130 
131     _transfer(prevOwner, msg.sender, _tokenId);
132 
133     if (currentPrice < GROWTH_BUMP) {
134       newPrice = SafeMath.mul(currentPrice, 2);
135     } else {
136       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
137     }
138 
139     tokenIdToPrice[_tokenId] = newPrice;
140 
141     if (prevOwner != address(this)) {
142       prevOwner.transfer(payment);
143     }
144 
145     CelebSold(_tokenId, currentPrice, newPrice,
146       celebs[_tokenId].name, prevOwner, msg.sender);
147 
148     msg.sender.transfer(leftover);
149   }
150 
151   function balanceOf(address _owner) public view returns (uint balance) {
152     return userToNumCelebs[_owner];
153   }
154 
155   function ownerOf(uint _tokenId) public view returns (address addr) {
156     return tokenIdToOwner[_tokenId];
157   }
158 
159   function totalSupply() public view returns (uint total) {
160     return celebs.length;
161   }
162 
163   function transfer(address _to, uint _tokenId) public {
164     _transfer(msg.sender, _to, _tokenId);
165   }
166 
167   /** START FUNCTIONS FOR AUTHORS **/
168 
169   function createCeleb(string _name, uint _price) public onlyAuthors {
170     require(_price >= MIN_STARTING_PRICE);
171 
172     uint tokenId = celebs.push(Celeb(_name)) - 1;
173     tokenIdToOwner[tokenId] = author;
174     tokenIdToPrice[tokenId] = _price;
175     userToNumCelebs[author]++;
176   }
177 
178   function withdraw(uint _amount, address _to) public onlyAuthors {
179     require(!isNullAddress(_to));
180     require(_amount <= this.balance);
181 
182     _to.transfer(_amount);
183   }
184 
185   function withdrawAll() public onlyAuthors {
186     require(author != 0x0);
187     require(coauthor != 0x0);
188 
189     uint halfBalance = uint(SafeMath.div(this.balance, 2));
190 
191     author.transfer(halfBalance);
192     coauthor.transfer(halfBalance);
193   }
194 
195   function setCoAuthor(address _coauthor) public onlyAuthor {
196     require(!isNullAddress(_coauthor));
197 
198     coauthor = _coauthor;
199   }
200 
201   /** END FUNCTIONS FOR AUTHORS **/
202 
203   function getCeleb(uint _tokenId) public view returns (
204     string name,
205     uint price,
206     address owner
207   ) {
208     name = celebs[_tokenId].name;
209     price = tokenIdToPrice[_tokenId];
210     owner = tokenIdToOwner[_tokenId];
211   }
212 
213   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
214 
215   function approve(address _to, uint _tokenId) public {
216     require(msg.sender == ownerOf(_tokenId));
217 
218     tokenIdToApprovedRecipient[_tokenId] = _to;
219 
220     Approval(msg.sender, _to, _tokenId);
221   }
222 
223   function transferFrom(address _from, address _to, uint _tokenId) public {
224     require(ownerOf(_tokenId) == _from);
225     require(isApproved(_to, _tokenId));
226     require(!isNullAddress(_to));
227 
228     _transfer(_from, _to, _tokenId);
229   }
230 
231   function takeOwnership(uint _tokenId) public {
232     require(!isNullAddress(msg.sender));
233     require(isApproved(msg.sender, _tokenId));
234 
235     address currentOwner = tokenIdToOwner[_tokenId];
236 
237     _transfer(currentOwner, msg.sender, _tokenId);
238   }
239 
240   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
241 
242   function implementsERC721() public pure returns (bool) {
243     return true;
244   }
245 
246   /** MODIFIERS **/
247 
248   modifier onlyAuthor() {
249     require(msg.sender == author);
250     _;
251   }
252 
253   modifier onlyAuthors() {
254     require(msg.sender == author || msg.sender == coauthor);
255     _;
256   }
257 
258   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
259 
260   function setMinStartingPrice(uint _price) public onlyAuthors {
261     MIN_STARTING_PRICE = _price;
262   }
263 
264   function setGrowthBump(uint _bump) public onlyAuthors {
265     GROWTH_BUMP = _bump;
266   }
267 
268   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
269     PRICE_INCREASE_SCALE = _scale;
270   }
271 
272   /** PRIVATE FUNCTIONS **/
273 
274   function isApproved(address _to, uint _tokenId) private view returns (bool) {
275     return tokenIdToApprovedRecipient[_tokenId] == _to;
276   }
277 
278   function isNullAddress(address _addr) private pure returns (bool) {
279     return _addr == 0x0;
280   }
281 }
282 
283 contract KpopItem is ERC721 {
284   address public author;
285   address public coauthor;
286   address public manufacturer;
287 
288   string public constant NAME = "KpopItem";
289   string public constant SYMBOL = "KpopItem";
290 
291   uint public GROWTH_BUMP = 0.1 ether;
292   uint public MIN_STARTING_PRICE = 0.002 ether;
293   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
294   uint public DIVIDEND = 3;
295   address public KPOPIO_CONTRACT_ADDRESS = 0xB2eE4ACf44b12f85885F23494A739357575a1760;
296 
297   struct Item {
298     string name;
299     uint[6] traits;
300   }
301 
302   Item[] public items;
303 
304   mapping(uint => address) public tokenIdToOwner;
305   mapping(uint => uint) public tokenIdToCelebId; // celeb from KpopIO
306   mapping(uint => uint) public tokenIdToPrice; // in wei
307   mapping(address => uint) public userToNumItems;
308   mapping(uint => address) public tokenIdToApprovedRecipient;
309 
310   event Transfer(address indexed from, address indexed to, uint tokenId);
311   event Approval(address indexed owner, address indexed approved, uint tokenId);
312   event ItemSold(uint tokenId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);
313 
314   function KpopItem() public {
315     author = msg.sender;
316     coauthor = msg.sender;
317   }
318 
319   function _transfer(address _from, address _to, uint _tokenId) private {
320     require(ownerOf(_tokenId) == _from);
321     require(!isNullAddress(_to));
322     require(balanceOf(_from) > 0);
323 
324     uint prevBalances = balanceOf(_from) + balanceOf(_to);
325     tokenIdToOwner[_tokenId] = _to;
326     userToNumItems[_from]--;
327     userToNumItems[_to]++;
328 
329     delete tokenIdToApprovedRecipient[_tokenId];
330 
331     Transfer(_from, _to, _tokenId);
332     
333     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
334   }
335 
336   function buy(uint _tokenId) payable public {
337     address prevOwner = ownerOf(_tokenId);
338     uint currentPrice = tokenIdToPrice[_tokenId];
339 
340     require(prevOwner != msg.sender);
341     require(!isNullAddress(msg.sender));
342     require(msg.value >= currentPrice);
343 
344     // Set dividend
345     uint dividend = uint(SafeMath.div(SafeMath.mul(currentPrice, DIVIDEND), 100));
346 
347     // Take a cut
348     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 90), 100));
349 
350     uint leftover = SafeMath.sub(msg.value, currentPrice);
351     uint newPrice;
352 
353     _transfer(prevOwner, msg.sender, _tokenId);
354 
355     if (currentPrice < GROWTH_BUMP) {
356       newPrice = SafeMath.mul(currentPrice, 2);
357     } else {
358       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
359     }
360 
361     tokenIdToPrice[_tokenId] = newPrice;
362 
363     // Pay the prev owner of the item
364     if (prevOwner != address(this)) {
365       prevOwner.transfer(payment);
366     }
367 
368     // Pay dividend to the current owner of the celeb that's connected to the item
369     uint celebId = celebOf(_tokenId);
370     KpopToken KPOPIO = KpopToken(KPOPIO_CONTRACT_ADDRESS);
371     address celebOwner = KPOPIO.ownerOf(celebId);
372     if (celebOwner != address(this) && !isNullAddress(celebOwner)) {
373       celebOwner.transfer(dividend);
374     }
375 
376     ItemSold(_tokenId, currentPrice, newPrice,
377       items[_tokenId].name, prevOwner, msg.sender);
378 
379     msg.sender.transfer(leftover);
380   }
381 
382   function balanceOf(address _owner) public view returns (uint balance) {
383     return userToNumItems[_owner];
384   }
385 
386   function ownerOf(uint _tokenId) public view returns (address addr) {
387     return tokenIdToOwner[_tokenId];
388   }
389 
390   function celebOf(uint _tokenId) public view returns (uint celebId) {
391     return tokenIdToCelebId[_tokenId];
392   }
393 
394   function totalSupply() public view returns (uint total) {
395     return items.length;
396   }
397 
398   function transfer(address _to, uint _tokenId) public {
399     _transfer(msg.sender, _to, _tokenId);
400   }
401 
402   /** START FUNCTIONS FOR AUTHORS **/
403 
404   function createItem(string _name, uint _price, uint _celebId, uint[6] _traits) public onlyManufacturer {
405     require(_price >= MIN_STARTING_PRICE);
406 
407     uint tokenId = items.push(Item({name: _name, traits:_traits})) - 1;
408     tokenIdToOwner[tokenId] = author;
409     tokenIdToPrice[tokenId] = _price;
410     tokenIdToCelebId[tokenId] = _celebId;
411     userToNumItems[author]++;
412   }
413 
414   function withdraw(uint _amount, address _to) public onlyAuthors {
415     require(!isNullAddress(_to));
416     require(_amount <= this.balance);
417 
418     _to.transfer(_amount);
419   }
420 
421   function withdrawAll() public onlyAuthors {
422     require(author != 0x0);
423     require(coauthor != 0x0);
424 
425     uint halfBalance = uint(SafeMath.div(this.balance, 2));
426 
427     author.transfer(halfBalance);
428     coauthor.transfer(halfBalance);
429   }
430 
431   function setCoAuthor(address _coauthor) public onlyAuthor {
432     require(!isNullAddress(_coauthor));
433 
434     coauthor = _coauthor;
435   }
436 
437   function setManufacturer(address _manufacturer) public onlyAuthors {
438     require(!isNullAddress(_manufacturer));
439 
440     coauthor = _manufacturer;
441   }
442 
443   /** END FUNCTIONS FOR AUTHORS **/
444 
445   function getItem(uint _tokenId) public view returns (
446     string name,
447     uint price,
448     uint[6] traits,
449     address owner,
450     uint celebId
451   ) {
452     name = items[_tokenId].name;
453     price = tokenIdToPrice[_tokenId];
454     traits = items[_tokenId].traits;
455     owner = tokenIdToOwner[_tokenId];
456     celebId = celebOf(_tokenId);
457   }
458 
459   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
460 
461   function approve(address _to, uint _tokenId) public {
462     require(msg.sender == ownerOf(_tokenId));
463 
464     tokenIdToApprovedRecipient[_tokenId] = _to;
465 
466     Approval(msg.sender, _to, _tokenId);
467   }
468 
469   function transferFrom(address _from, address _to, uint _tokenId) public {
470     require(ownerOf(_tokenId) == _from);
471     require(isApproved(_to, _tokenId));
472     require(!isNullAddress(_to));
473 
474     _transfer(_from, _to, _tokenId);
475   }
476 
477   function takeOwnership(uint _tokenId) public {
478     require(!isNullAddress(msg.sender));
479     require(isApproved(msg.sender, _tokenId));
480 
481     address currentOwner = tokenIdToOwner[_tokenId];
482 
483     _transfer(currentOwner, msg.sender, _tokenId);
484   }
485 
486   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
487 
488   function implementsERC721() public pure returns (bool) {
489     return true;
490   }
491 
492   /** MODIFIERS **/
493 
494   modifier onlyAuthor() {
495     require(msg.sender == author);
496     _;
497   }
498 
499   modifier onlyAuthors() {
500     require(msg.sender == author || msg.sender == coauthor);
501     _;
502   }
503 
504   modifier onlyManufacturer() {
505     require(msg.sender == author || msg.sender == coauthor || msg.sender == manufacturer);
506     _;
507   }
508 
509   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
510 
511   function setMinStartingPrice(uint _price) public onlyAuthors {
512     MIN_STARTING_PRICE = _price;
513   }
514 
515   function setGrowthBump(uint _bump) public onlyAuthors {
516     GROWTH_BUMP = _bump;
517   }
518 
519   function setDividend(uint _dividend) public onlyAuthors {
520     DIVIDEND = _dividend;
521   }
522 
523   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
524     PRICE_INCREASE_SCALE = _scale;
525   }
526 
527   function setKpopioContractAddress(address _address) public onlyAuthors {
528     KPOPIO_CONTRACT_ADDRESS = _address;
529   }
530 
531   /** PRIVATE FUNCTIONS **/
532 
533   function isApproved(address _to, uint _tokenId) private view returns (bool) {
534     return tokenIdToApprovedRecipient[_tokenId] == _to;
535   }
536 
537   function isNullAddress(address _addr) private pure returns (bool) {
538     return _addr == 0x0;
539   }
540 }