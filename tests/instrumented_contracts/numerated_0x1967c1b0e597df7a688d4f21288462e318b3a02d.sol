1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface 
6  * 
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title OwnableWithAdmin 
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract OwnableWithAdmin {
26   address public owner;
27   address public adminOwner;
28 
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor() public {
35     owner = msg.sender;
36     adminOwner = msg.sender;
37   }
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the admin.
48    */
49   modifier onlyAdmin() {
50     require(msg.sender == adminOwner);
51     _;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner or admin.
56    */
57   modifier onlyOwnerOrAdmin() {
58     require(msg.sender == adminOwner || msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72   /**
73    * @dev Allows the current adminOwner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferAdminOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(adminOwner, newOwner);
79     adminOwner = newOwner;
80   }
81 
82 }
83 
84 
85 /**
86  * @title SafeMath
87  * @dev Math operations with safety checks that throw on error
88  */
89 library SafeMath {
90 
91   /**
92   * @dev Multiplies two numbers, throws on overflow.
93   */
94   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95     if (a == 0) {
96       return 0;
97     }
98     uint256 c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   /**
114   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 
130   function uint2str(uint i) internal pure returns (string){
131       if (i == 0) return "0";
132       uint j = i;
133       uint length;
134       while (j != 0){
135           length++;
136           j /= 10;
137       }
138       bytes memory bstr = new bytes(length);
139       uint k = length - 1;
140       while (i != 0){
141           bstr[k--] = byte(48 + i % 10);
142           i /= 10;
143       }
144       return string(bstr);
145   }
146  
147   
148 }
149 
150 
151 /**
152  * @title LockedPrivatesale
153  * @notice Contract is not payable.
154  * Owner or admin can allocate tokens.
155  * Tokens will be released in 3 steps / dates. 
156  *
157  *
158  */
159 contract LockedPrivatesale is OwnableWithAdmin {
160   using SafeMath for uint256;
161 
162   uint256 private constant DECIMALFACTOR = 10**uint256(18);
163 
164 
165   event FundsBooked(address backer, uint256 amount, bool isContribution);
166   event LogTokenClaimed(address indexed _recipient, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
167   event LogNewAllocation(address indexed _recipient, uint256 _totalAllocated);
168   event LogRemoveAllocation(address indexed _recipient, uint256 _tokenAmountRemoved);
169   event LogOwnerAllocation(address indexed _recipient, uint256 _totalAllocated);
170    
171 
172   // Amount of tokens claimed
173   uint256 public grandTotalClaimed = 0;
174 
175   // The token being sold
176   ERC20 public token;
177 
178   // Amount of tokens Raised
179   uint256 public tokensTotal = 0;
180 
181   // Max token amount
182   uint256 public hardCap = 0;
183   
184 
185   //Tokens will be released in 3 steps/dates
186   uint256 public step1;
187   uint256 public step2;
188   uint256 public step3;
189 
190   // Buyers total allocation
191   mapping (address => uint256) public allocationsTotal;
192 
193   // User total Claimed
194   mapping (address => uint256) public totalClaimed;
195 
196   // List of allocation step 1
197   mapping (address => uint256) public allocations1;
198 
199   // List of allocation step 2
200   mapping (address => uint256) public allocations2;
201 
202   // List of allocation step 3
203   mapping (address => uint256) public allocations3;
204 
205   //Buyers
206   mapping(address => bool) public buyers;
207 
208   //Buyers who received all there tokens
209   mapping(address => bool) public buyersReceived;
210 
211   //List of all addresses
212   address[] public addresses;
213   
214  
215   constructor(uint256 _step1, uint256 _step2, uint256 _step3, ERC20 _token) public {
216      
217     require(_token != address(0));
218 
219     require(_step1 >= now);
220     require(_step2 >= _step1);
221     require(_step3 >= _step2);
222 
223     step1       = _step1;
224     step2       = _step2;
225     step3       = _step3;
226 
227     token = _token;
228   }
229 
230   
231   /**
232    * @dev fallback function ***DO NOT OVERRIDE***
233    */
234   function () public {
235     //Not payable
236   }
237 
238 
239 
240   /**
241     * @dev Set allocation buy admin
242     * @param _recipient Users wallet
243     * @param _tokenAmount Amount Allocated tokens + 18 decimals
244     */
245   function setAllocation (address _recipient, uint256 _tokenAmount) onlyOwnerOrAdmin  public{
246       require(_tokenAmount > 0);      
247       require(_recipient != address(0)); 
248 
249       //Check hardCap 
250       require(_validateHardCap(_tokenAmount));
251 
252       //Allocate tokens
253       _setAllocation(_recipient, _tokenAmount);    
254 
255       //Increese token amount
256       tokensTotal = tokensTotal.add(_tokenAmount);  
257 
258       //Logg Allocation
259       emit LogOwnerAllocation(_recipient, _tokenAmount);
260   }
261 
262   /**
263     * @dev Remove allocation 
264     * @param _recipient Users wallet
265     *  
266     */
267   function removeAllocation (address _recipient) onlyOwner  public{         
268       require(_recipient != address(0)); 
269       require(totalClaimed[_recipient] == 0); //Check if user claimed tokens
270 
271 
272       //_recipient total amount
273       uint256 _tokenAmountRemoved = allocationsTotal[_recipient];
274 
275       //Decreese token amount
276       tokensTotal = tokensTotal.sub(_tokenAmountRemoved);
277 
278       //Reset allocations
279       allocations1[_recipient]      = 0; 
280       allocations2[_recipient]      = 0; 
281       allocations3[_recipient]      = 0;
282       allocationsTotal[_recipient]  = 0; // Remove  
283       
284       //Set buyer to false
285       buyers[_recipient] = false;
286 
287       emit LogRemoveAllocation(_recipient, _tokenAmountRemoved);
288   }
289 
290 
291  /**
292    * @dev Set internal allocation 
293    *  _buyer The adress of the buyer
294    *  _tokenAmount Amount Allocated tokens + 18 decimals
295    */
296   function _setAllocation (address _buyer, uint256 _tokenAmount) internal{
297 
298       if(!buyers[_buyer]){
299         //Add buyer to buyers list 
300         buyers[_buyer] = true;
301 
302         //Add _buyer to addresses list
303         addresses.push(_buyer);
304 
305         //Reset buyer allocation
306         allocationsTotal[_buyer] = 0;
307 
308       }  
309 
310       //Add tokens to buyers allocation
311       allocationsTotal[_buyer]  = allocationsTotal[_buyer].add(_tokenAmount); 
312 
313       //Spilt amount in 3
314       uint256 splitAmount = allocationsTotal[_buyer].div(3);
315       uint256 diff        = allocationsTotal[_buyer].sub(splitAmount+splitAmount+splitAmount);
316 
317 
318       //Sale steps
319       allocations1[_buyer]   = splitAmount;            // step 1 
320       allocations2[_buyer]   = splitAmount;            // step 2
321       allocations3[_buyer]   = splitAmount.add(diff);  // step 3 + diff
322 
323 
324       //Logg Allocation
325       emit LogNewAllocation(_buyer, _tokenAmount);
326 
327   }
328 
329 
330   /**
331     * @dev Return address available allocation
332     * @param _recipient which address is applicable
333     */
334   function checkAvailableTokens (address _recipient) public view returns (uint256) {
335     //Check if user have bought tokens
336     require(buyers[_recipient]);
337 
338     uint256 _availableTokens = 0;
339 
340     if(now >= step1){
341       _availableTokens = _availableTokens.add(allocations1[_recipient]);
342     }
343     if(now >= step2){
344       _availableTokens = _availableTokens.add(allocations2[_recipient]);
345     }
346     if(now >= step3){
347       _availableTokens = _availableTokens.add(allocations3[_recipient]);
348     }
349 
350     return _availableTokens;
351   }
352 
353   /**
354     * @dev Transfer a recipients available allocation to their address
355     * @param _recipients Array of addresses to withdraw tokens for
356     */
357   function distributeManyTokens(address[] _recipients) onlyOwnerOrAdmin public {
358     for (uint256 i = 0; i < _recipients.length; i++) {
359 
360       //Check if address is buyer 
361       //And if the buyer is not already received all the tokens
362       if(buyers[_recipients[i]] && !buyersReceived[_recipients[i]]){
363         distributeTokens( _recipients[i]);
364       }
365     }
366   }
367 
368 
369   /**
370     * @dev Loop address and distribute tokens
371     *
372     */
373   function distributeAllTokens() onlyOwner public {
374     for (uint256 i = 0; i < addresses.length; i++) {
375 
376       //Check if address is buyer 
377       //And if the buyer is not already received all the tokens
378       if(buyers[addresses[i]] && !buyersReceived[addresses[i]]){
379         distributeTokens( addresses[i]);
380       }
381             
382     }
383   }
384 
385   /**
386     * @notice Withdraw available tokens
387     * 
388     */
389   function withdrawTokens() public {
390     distributeTokens(msg.sender);
391   }
392 
393   /**
394     * @dev Transfer a recipients available allocation to _recipient
395     *
396     */
397   function distributeTokens(address _recipient) public {
398     //Check date
399     require(now >= step1);
400     //Check have bought tokens
401     require(buyers[_recipient]);
402 
403     //
404     bool _lastWithdraw = false;
405 
406     uint256 _availableTokens = 0;
407     
408     if(now >= step1  && now >= step2  && now >= step3 ){      
409 
410       _availableTokens = _availableTokens.add(allocations3[_recipient]); 
411       _availableTokens = _availableTokens.add(allocations2[_recipient]);
412       _availableTokens = _availableTokens.add(allocations1[_recipient]);
413 
414       //Reset all allocations
415       allocations3[_recipient] = 0;
416       allocations2[_recipient] = 0;
417       allocations1[_recipient] = 0;
418 
419       //Step 3, all tokens should be received
420       _lastWithdraw = true;
421 
422 
423     } else if(now >= step1  && now >= step2 ){
424       
425       _availableTokens = _availableTokens.add(allocations2[_recipient]);
426       _availableTokens = _availableTokens.add(allocations1[_recipient]); 
427 
428       //Reset step 1 & step 2 allocation
429       allocations2[_recipient] = 0;
430       allocations1[_recipient] = 0;
431 
432 
433     }else if(now >= step1){
434 
435       _availableTokens = allocations1[_recipient];
436 
437       //Reset step 1 allocation
438       allocations1[_recipient] = 0; 
439 
440 
441     }
442 
443     require(_availableTokens>0);    
444 
445     //Check if contract has tokens
446     require(token.balanceOf(this)>=_availableTokens);
447 
448     //Transfer tokens
449     require(token.transfer(_recipient, _availableTokens));
450 
451     //Add claimed tokens to totalClaimed
452     totalClaimed[_recipient] = totalClaimed[_recipient].add(_availableTokens);
453 
454     //Add claimed tokens to grandTotalClaimed
455     grandTotalClaimed = grandTotalClaimed.add(_availableTokens);
456 
457     emit LogTokenClaimed(_recipient, _availableTokens, allocationsTotal[_recipient], grandTotalClaimed);
458 
459     //If all tokens are received, add _recipient to buyersReceived
460     //To prevent the loop to fail if user allready used the withdrawTokens
461     if(_lastWithdraw){
462       buyersReceived[_recipient] = true;
463     }
464 
465   }
466 
467 
468 
469   function _validateHardCap(uint256 _tokenAmount) internal view returns (bool) {
470       return tokensTotal.add(_tokenAmount) <= hardCap;
471   }
472 
473 
474   function getListOfAddresses() public view returns (address[]) {    
475     return addresses;
476   }
477 
478 
479   // Allow transfer of tokens back to owner or reserve wallet
480   function returnTokens() public onlyOwner {
481     uint256 balance = token.balanceOf(this);
482     require(token.transfer(owner, balance));
483   }
484 
485   // Owner can transfer tokens that are sent here by mistake
486   function refundTokens(address _recipient, ERC20 _token) public onlyOwner {
487     uint256 balance = _token.balanceOf(this);
488     require(_token.transfer(_recipient, balance));
489   }
490 
491 
492 }
493 
494 
495 /**
496  * @title EDPrivateSale
497  * @dev Only owner or admin can allocate tokens. Tokens can be booked in advanced without the token contract.
498  * Tokens will be released in 3 steps / dates. 
499  * A token needs to be attached to this contract and this contract needs to have balance to be able to send tokens to collector
500  * No whitelist in contract is requierd
501  *
502 */
503 contract EDPrivateSale is LockedPrivatesale {
504   constructor(
505     uint256 _step1, 
506     uint256 _step2, 
507     uint256 _step3,    
508     ERC20 _token
509   ) public LockedPrivatesale(_step1, _step2, _step3, _token) {
510 
511     // 50,000,000 tokens
512     hardCap = 50000000 * (10**uint256(18)); 
513 
514   }
515 }