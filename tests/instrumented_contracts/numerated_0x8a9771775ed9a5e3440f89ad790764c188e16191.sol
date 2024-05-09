1 pragma solidity ^0.4.24;
2 
3 interface ERC721 /* is ERC165 */ {
4   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
5   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
6   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
7   function balanceOf(address _owner) external view returns (uint256);
8   function ownerOf(uint256 _tokenId) external view returns (address);
9   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
10   function approve(address _approved, uint256 _tokenId) external payable;
11   function setApprovalForAll(address _operator, bool _approved) external;
12   function getApproved(uint256 _tokenId) external view returns (address);
13   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 /**
63  * @title SafeMath32
64  * @dev SafeMath library implemented for uint32
65  */
66 library SafeMath32 {
67 
68   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
69     if (a == 0) {
70       return 0;
71     }
72     uint32 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   function div(uint32 a, uint32 b) internal pure returns (uint32) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint32 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function add(uint32 a, uint32 b) internal pure returns (uint32) {
90     uint32 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 /**
97  * @title SafeMath16
98  * @dev SafeMath library implemented for uint16
99  */
100 library SafeMath16 {
101 
102   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
103     if (a == 0) {
104       return 0;
105     }
106     uint16 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   function div(uint16 a, uint16 b) internal pure returns (uint16) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint16 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   function add(uint16 a, uint16 b) internal pure returns (uint16) {
124     uint16 c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }
129 
130 contract Owner {
131 
132   address public owner;
133 
134   /**
135    * @dev set the owner of contract
136    */
137   constructor() public {
138       owner = msg.sender;
139   }
140 
141   /**
142    * @dev only the owner
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 }
149 
150 /**
151  * @title GreedyCoin
152  */
153 contract GreedyCoin is Owner,ERC721 {
154 
155   using SafeMath for uint256;
156 
157   // total supply
158   uint16  constant ISSUE_MAX = 2100;
159 
160   // init price
161   uint256 constant START_PRICE = 0.1 ether;
162 
163   // min price
164   uint256 constant PRICE_MIN = 0.000000000000000001 ether;
165 
166   // max price
167   uint256 constant PRICE_LIMIT = 100000000 ether;
168 
169   // percent of fee
170   uint256 constant PROCEDURE_FEE_PERCENT = 10;
171 
172   // GreedyCoin token
173   struct TokenGDC{
174     bytes32 token_hash;
175     uint256 last_deal_time;
176     uint256 buying_price;
177     uint256 price;
178   }
179 
180   /**
181    * @dev token structure
182   */
183   TokenGDC[] stTokens;
184 
185   /**
186    * @dev owner of tokens ( index => address )
187   */
188   mapping (uint256 => address) stTokenIndexToOwner;
189 
190   /**
191    * @dev GreedyCoin count of one address
192   */
193   mapping (address => uint256) stOwnerTokenCount;
194 
195   /**
196    * @dev set transfer token permission
197   */
198   mapping (uint256 => address) stTokenApprovals;
199 
200   /**
201   * @dev set approved address
202   */
203   mapping (address => mapping (address => bool) ) stApprovalForAll;
204 
205 
206   /*
207    * @dev (ERC721)
208    */
209   function balanceOf(address owner) external view returns (uint256 balance){
210     balance = stOwnerTokenCount[owner];
211   }
212   
213   /**
214    * @dev query the owner of one GreedyCoin
215    */
216   function ownerOf(uint256 token_id) external view returns (address owner){
217     owner = stTokenIndexToOwner[token_id];
218   }
219 
220   /**
221    * @dev transfer from
222    */
223   function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
224     require(msg.sender == _from);
225     require(_to != address(0));
226     require(_tokenId >= 0 && _tokenId < ISSUE_MAX - 1);
227     _transfer(_from, _to, _tokenId);
228   }
229 
230   /**
231    * @dev approve before transfer
232    */
233   function approve(address to, uint256 token_id) external payable {
234     require(msg.sender == stTokenIndexToOwner[token_id]);
235     stTokenApprovals[token_id] = to;
236     emit Approval(msg.sender, to, token_id);
237   }
238 
239   /**
240    * @dev get approve
241    */
242   function getApproved(uint256 _tokenId) external view returns (address){
243     return stTokenApprovals[_tokenId];
244   }
245 
246   /**
247    * @dev setApprovalForAll
248    */
249   function setApprovalForAll(address _operator, bool _approved) external {
250     stApprovalForAll[msg.sender][_operator] = _approved;
251     emit ApprovalForAll(msg.sender, _operator, _approved);
252   }
253 
254   /**
255    * @dev isApprovedForAll
256    */
257   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
258     return stApprovalForAll[_owner][_operator] == true;
259   }
260 
261   /**
262    * @dev _transfer
263    */
264   function _transfer(address from, address to, uint256 token_id) private {
265     require(stTokenApprovals[token_id] == to || stApprovalForAll[from][to]);
266     stOwnerTokenCount[to] = stOwnerTokenCount[to].add(1);
267     stOwnerTokenCount[msg.sender] = stOwnerTokenCount[msg.sender].sub(1);
268     stTokenIndexToOwner[token_id] = to;
269     emit Transfer(from, to, token_id);
270   }
271 
272   /**
273    * @dev query detail of one GreedyCoin
274    */
275   function queryToken(uint256 _tokenId) external view returns ( uint256 price, uint256 last_deal_time ) {
276     TokenGDC memory token = stTokens[_tokenId];
277     price = token.price;
278     last_deal_time = token.last_deal_time;
279   }
280 
281 
282   /**
283    * @dev get all GreedyCoins of msg.sender
284    */
285   function getMyTokens() external view returns ( uint256[] arr_token_id, uint256[] arr_last_deal_time, uint256[] buying_price_arr, uint256[] price_arr ){
286 
287     TokenGDC memory token;
288 
289     uint256 count = stOwnerTokenCount[msg.sender];
290     arr_last_deal_time = new uint256[](count);
291     buying_price_arr = new uint256[](count);
292     price_arr = new uint256[](count);
293     arr_token_id = new uint256[](count);
294 
295     uint256 index = 0;
296     for ( uint i = 0; i < stTokens.length; i++ ){
297       if ( stTokenIndexToOwner[i] == msg.sender ) {
298         token = stTokens[i];
299         arr_last_deal_time[index] = token.last_deal_time;
300         buying_price_arr[index] = token.buying_price;
301         price_arr[index] = token.price;
302         arr_token_id[index] = i;
303         index = index + 1;
304       }
305     }
306   }
307 }
308 
309 contract Market is GreedyCoin {
310 
311   using SafeMath for uint256;
312 
313   event Bought (address indexed purchaser,uint256 indexed token_price, uint256 indexed next_price);
314   event HitFunds (address indexed purchaser,uint256 indexed funds, uint256 indexed hit_time);
315   event Recommended (address indexed recommender, uint256 indexed agency_fee);
316 
317   // buy (only accept normal address)
318   function buy(uint256 next_price, bool is_recommend, uint256 recommend_token_id) external payable mustCommonAddress {
319 
320     require (next_price >= PRICE_MIN && next_price <= PRICE_LIMIT);
321 
322     _checkRecommend(is_recommend,recommend_token_id);
323     if (stTokens.length < ISSUE_MAX ){
324       _buyAndCreateToken(next_price,is_recommend,recommend_token_id);
325     } else {
326       _buyFromMarket(next_price,is_recommend,recommend_token_id);
327     }
328   }
329 
330   // query current blance of fees
331   function queryCurrentContractFunds() external view returns (uint256) {
332     return (address)(this).balance;
333   }
334 
335   // query the lowest price
336   function queryCurrentTradablePrice() external view returns (uint256 token_id,uint256 price) {
337     if (stTokens.length < ISSUE_MAX){
338       token_id = stTokens.length;
339       price = START_PRICE;
340     } else {
341       token_id = _getCurrentTradableToken();
342       price = stTokens[token_id].price;
343     }
344   }
345 
346   // get the cheapest GreedyCoin
347   function _getCurrentTradableToken() private view returns(uint256 token_id) {
348     uint256 token_count = stTokens.length;
349     uint256 min_price = stTokens[0].price;
350     token_id = 0;
351     for ( uint i = 0; i < token_count; i++ ){
352       // token = stTokens[i];
353       uint256 price = stTokens[i].price;
354       if (price < min_price) {
355         // token = stTokens[i];
356         min_price = price;
357         token_id = i;
358       }
359     }
360   }
361 
362   // create GreedyCoin
363   function _buyAndCreateToken(uint256 next_price, bool is_recommend, uint256 recommend_token_id ) private {
364 
365     require( msg.value >= START_PRICE );
366 
367     // create
368     uint256 now_time = now;
369     uint256 token_id = stTokens.length;
370     TokenGDC memory token;
371     token = TokenGDC({
372       token_hash: keccak256(abi.encodePacked((address)(this), token_id)),
373       last_deal_time: now_time,
374       buying_price: START_PRICE,
375       price: next_price
376     });
377     stTokens.push(token);
378 
379     stTokenIndexToOwner[token_id] = msg.sender;
380     stOwnerTokenCount[msg.sender] = stOwnerTokenCount[msg.sender].add(1);
381 
382     // 10% fee
383     uint256 current_fund = START_PRICE.div(100 / PROCEDURE_FEE_PERCENT);
384 
385     // hash of GreedyCoin
386     bytes32 current_token_hash = token.token_hash;
387 
388     owner.transfer( START_PRICE - current_fund );
389 
390     // if get all fees
391     _gambling(current_fund, current_token_hash, now_time);
392 
393     // recommendation
394     _awardForRecommender(is_recommend, recommend_token_id, current_fund);
395 
396     _refund(msg.value - START_PRICE);
397 
398     // emit event
399     emit Bought(msg.sender, START_PRICE, next_price);
400 
401   }
402 
403 // buy GreedyCoin from each other,after all GreedyCoins has been created
404   function _buyFromMarket(uint256 next_price, bool is_recommend, uint256 recommend_token_id ) private {
405 
406     uint256 current_tradable_token_id = _getCurrentTradableToken();
407     TokenGDC storage token = stTokens[current_tradable_token_id];
408 
409     uint256 current_token_price = token.price;
410 
411     bytes32 current_token_hash = token.token_hash;
412 
413     uint256 last_deal_time = token.last_deal_time;
414 
415     require( msg.value >= current_token_price );
416 
417     uint256 refund_amount = msg.value - current_token_price;
418 
419     token.price = next_price;
420 
421     token.buying_price = current_token_price;
422 
423     token.last_deal_time = now;
424 
425     address origin_owner = stTokenIndexToOwner[current_tradable_token_id];
426 
427     stOwnerTokenCount[origin_owner] =  stOwnerTokenCount[origin_owner].sub(1);
428 
429     stOwnerTokenCount[msg.sender] = stOwnerTokenCount[msg.sender].add(1);
430 
431     stTokenIndexToOwner[current_tradable_token_id] = msg.sender;
432 
433     uint256 current_fund = current_token_price.div(100 / PROCEDURE_FEE_PERCENT);
434 
435     origin_owner.transfer( current_token_price - current_fund );
436 
437     _gambling(current_fund, current_token_hash, last_deal_time);
438 
439     _awardForRecommender(is_recommend, recommend_token_id, current_fund);
440 
441     _refund(refund_amount);
442 
443     emit Bought(msg.sender, current_token_price, next_price);
444   }
445 
446   function _awardForRecommender(bool is_recommend, uint256 recommend_token_id, uint256 current_fund) private {
447 
448     if ( is_recommend && stTokens.length >= recommend_token_id) {
449 
450       address recommender = stTokenIndexToOwner[recommend_token_id];
451 
452       // 50% of fee
453       uint256 agency_fee = current_fund.div(2);
454 
455       recommender.transfer(agency_fee);
456 
457       emit Recommended(recommender,agency_fee);
458     }
459   }
460 
461   function _refund(uint256 refund_amount) private {
462     if ( refund_amount > 0 ) {
463       msg.sender.transfer(refund_amount);
464     }
465   }
466 
467   // 10% change of getting all blance of fees
468   function _gambling(uint256 current_fund, bytes32 current_token_hash, uint256 last_deal_time) private {
469 
470     // random 0 - 99
471     uint256 random_number = _createRandomNumber(current_token_hash,last_deal_time);
472 
473     if ( random_number < 10 ) {
474 
475       // contract address
476       address contract_address = (address)(this);
477 
478       uint256 hit_funds = contract_address.balance.sub(current_fund);
479 
480       msg.sender.transfer(hit_funds);
481 
482       emit HitFunds(msg.sender, hit_funds, now);
483     }
484   }
485 
486   function _createRandomNumber(bytes32 current_token_hash, uint256 last_deal_time) private pure returns (uint256) {
487     return (uint256)(keccak256(abi.encodePacked(current_token_hash, last_deal_time))) % 100;
488   }
489 
490   function _checkRecommend(bool is_recommend, uint256 recommend_token_id) private view {
491     if ( is_recommend ) {
492       if ( stTokens.length > 0 ) {
493         require(recommend_token_id >= 0 && recommend_token_id < stTokens.length);
494       } 
495     }
496   }
497 
498   modifier aboveMinNextPrice(uint next_price) { 
499     require (next_price >= PRICE_MIN && next_price <= PRICE_LIMIT);
500     _;
501   }
502 
503   // must be a normal address
504   modifier mustCommonAddress() { 
505     require (_isContract(msg.sender) == false);
506     _; 
507   }
508 
509   // check if it is the address of contract
510   function _isContract(address addr) private view returns (bool) {
511     uint size;
512     assembly { size := extcodesize(addr) }
513     return size > 0;
514   }
515 
516 }