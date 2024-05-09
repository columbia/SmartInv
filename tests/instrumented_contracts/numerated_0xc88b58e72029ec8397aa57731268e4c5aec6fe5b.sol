1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/InbestToken.sol
223 
224 /**
225  * @title InbestToken
226  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
227  * Note they can later distribute these tokens as they wish using `transfer` and other
228  * `StandardToken` functions.
229  */
230 contract InbestToken is StandardToken {
231 
232   string public constant name = "Inbest Token";
233   string public constant symbol = "IBST";
234   uint8 public constant decimals = 18;
235 
236   // TBD
237   uint256 public constant INITIAL_SUPPLY = 17656263110 * (10 ** uint256(decimals));
238 
239   /**
240    * @dev Constructor that gives msg.sender all of existing tokens.
241    */
242   function InbestToken() public {
243     totalSupply_ = INITIAL_SUPPLY;
244     balances[msg.sender] = INITIAL_SUPPLY;
245     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
246   }
247 
248 }
249 
250 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
251 
252 /**
253  * @title Ownable
254  * @dev The Ownable contract has an owner address, and provides basic authorization control
255  * functions, this simplifies the implementation of "user permissions".
256  */
257 contract Ownable {
258   address public owner;
259 
260 
261   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263 
264   /**
265    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
266    * account.
267    */
268   function Ownable() public {
269     owner = msg.sender;
270   }
271 
272   /**
273    * @dev Throws if called by any account other than the owner.
274    */
275   modifier onlyOwner() {
276     require(msg.sender == owner);
277     _;
278   }
279 
280   /**
281    * @dev Allows the current owner to transfer control of the contract to a newOwner.
282    * @param newOwner The address to transfer ownership to.
283    */
284   function transferOwnership(address newOwner) public onlyOwner {
285     require(newOwner != address(0));
286     OwnershipTransferred(owner, newOwner);
287     owner = newOwner;
288   }
289 
290 }
291 
292 // File: contracts/InbestDistribution.sol
293 
294 /**
295  * @title Inbest Token initial distribution
296  *
297  * @dev Distribute Investors' and Company's tokens
298  */
299 contract InbestDistribution is Ownable {
300   using SafeMath for uint256;
301 
302   // Token
303   InbestToken public IBST;
304 
305   // Status of admins
306   mapping (address => bool) public admins;
307 
308   // Number of decimal places for tokens
309   uint256 private constant DECIMALFACTOR = 10**uint256(18);
310 
311   // Cliff period = 6 months
312   uint256 CLIFF = 180 days;  
313   // Vesting period = 12 months after cliff
314   uint256 VESTING = 365 days; 
315 
316   // Total of tokens
317   uint256 public constant INITIAL_SUPPLY   =    17656263110 * DECIMALFACTOR; // 14.000.000.000 IBST
318   // Total of available tokens
319   uint256 public AVAILABLE_TOTAL_SUPPLY    =    17656263110 * DECIMALFACTOR; // 14.000.000.000 IBST
320   // Total of available tokens for presale allocations
321   uint256 public AVAILABLE_PRESALE_SUPPLY  =    16656263110 * DECIMALFACTOR; // 500.000.000 IBST, 18 months vesting, 6 months cliff
322   // Total of available tokens for company allocation
323   uint256 public AVAILABLE_COMPANY_SUPPLY  =    1000000000 * DECIMALFACTOR; // 13.500.000.000 INST at token distribution event
324 
325   // Allocation types
326   enum AllocationType { PRESALE, COMPANY}
327 
328   // Amount of total tokens claimed
329   uint256 public grandTotalClaimed = 0;
330   // Time when InbestDistribution goes live
331   uint256 public startTime;
332 
333   // The only wallet allowed for Company supply
334   address public companyWallet;
335 
336   // Allocation with vesting and cliff information
337   struct Allocation {
338     uint8 allocationType;   // Type of allocation
339     uint256 endCliff;       // Tokens are locked until
340     uint256 endVesting;     // This is when the tokens are fully unvested
341     uint256 totalAllocated; // Total tokens allocated
342     uint256 amountClaimed;  // Total tokens claimed
343   }
344   mapping (address => Allocation) public allocations;
345 
346   // Modifier to control who executes functions
347   modifier onlyOwnerOrAdmin() {
348     require(msg.sender == owner || admins[msg.sender]);
349     _;
350   }
351 
352   // Event fired when a new allocation is made
353   event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
354   // Event fired when IBST tokens are claimed
355   event LogIBSTClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
356   // Event fired when admins are modified
357   event SetAdmin(address _caller, address _admin, bool _allowed);
358   // Event fired when refunding tokens mistakenly sent to contract
359   event RefundTokens(address _token, address _refund, uint256 _value);
360 
361   /**
362     * @dev Constructor function - Set the inbest token address
363     * @param _startTime The time when InbestDistribution goes live
364     * @param _companyWallet The wallet to allocate Company tokens
365     */
366   function InbestDistribution(uint256 _startTime, address _companyWallet) public {
367     require(_companyWallet != address(0));
368     require(_startTime >= now);
369     require(AVAILABLE_TOTAL_SUPPLY == AVAILABLE_PRESALE_SUPPLY.add(AVAILABLE_COMPANY_SUPPLY));
370     startTime = _startTime;
371     companyWallet = _companyWallet;
372     IBST = new InbestToken();
373     require(AVAILABLE_TOTAL_SUPPLY == IBST.totalSupply()); //To verify that totalSupply is correct
374 
375     // Allocate Company Supply
376     uint256 tokensToAllocate = AVAILABLE_COMPANY_SUPPLY;
377     AVAILABLE_COMPANY_SUPPLY = 0;
378     allocations[companyWallet] = Allocation(uint8(AllocationType.COMPANY), 0, 0, tokensToAllocate, 0);
379     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(tokensToAllocate);
380     LogNewAllocation(companyWallet, AllocationType.COMPANY, tokensToAllocate, grandTotalAllocated());
381   }
382 
383   /**
384     * @dev Allow the owner or admins of the contract to assign a new allocation
385     * @param _recipient The recipient of the allocation
386     * @param _totalAllocated The total amount of IBST tokens available to the receipient (after vesting and cliff)
387     */
388   function setAllocation (address _recipient, uint256 _totalAllocated) public onlyOwnerOrAdmin {
389     require(_recipient != address(0));
390     require(startTime > now); //Allocations are allowed only before starTime
391     require(AVAILABLE_PRESALE_SUPPLY >= _totalAllocated); //Current allocation must be less than remaining presale supply
392     require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0); // Must be the first and only allocation for this recipient
393     require(_recipient != companyWallet); // Receipient of presale allocation can't be company wallet
394 
395     // Allocate
396     AVAILABLE_PRESALE_SUPPLY = AVAILABLE_PRESALE_SUPPLY.sub(_totalAllocated);
397     allocations[_recipient] = Allocation(uint8(AllocationType.PRESALE), startTime.add(CLIFF), startTime.add(CLIFF).add(VESTING), _totalAllocated, 0);
398     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
399     LogNewAllocation(_recipient, AllocationType.PRESALE, _totalAllocated, grandTotalAllocated());
400   }
401 
402   /**
403    * @dev Transfer a recipients available allocation to their address
404    * @param _recipient The address to withdraw tokens for
405    */
406  function transferTokens (address _recipient) public {
407    require(_recipient != address(0));
408    require(now >= startTime); //Tokens can't be transfered until start date
409    require(_recipient != companyWallet); // Tokens allocated to COMPANY can't be withdrawn.
410    require(now >= allocations[_recipient].endCliff); // Cliff period must be ended
411    // Receipient can't claim more IBST tokens than allocated
412    require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
413 
414    uint256 newAmountClaimed;
415    if (allocations[_recipient].endVesting > now) {
416      // Transfer available amount based on vesting schedule and allocation
417      newAmountClaimed = allocations[_recipient].totalAllocated.mul(now.sub(allocations[_recipient].endCliff)).div(allocations[_recipient].endVesting.sub(allocations[_recipient].endCliff));
418    } else {
419      // Transfer total allocated (minus previously claimed tokens)
420      newAmountClaimed = allocations[_recipient].totalAllocated;
421    }
422 
423    //Transfer
424    uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
425    allocations[_recipient].amountClaimed = newAmountClaimed;
426    require(IBST.transfer(_recipient, tokensToTransfer));
427    grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
428    LogIBSTClaimed(_recipient, allocations[_recipient].allocationType, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
429  }
430 
431  /**
432   * @dev Transfer IBST tokens from Company allocation to reicipient address - Only owner and admins can execute
433   * @param _recipient The address to transfer tokens for
434   * @param _tokensToTransfer The amount of IBST tokens to transfer
435   */
436  function manualContribution(address _recipient, uint256 _tokensToTransfer) public onlyOwnerOrAdmin {
437    require(_recipient != address(0));
438    require(_recipient != companyWallet); // Company can't withdraw tokens for itself
439    require(_tokensToTransfer > 0); // The amount must be valid
440    require(now >= startTime); // Tokens cant't be transfered until start date
441    //Company can't trasnfer more tokens than allocated
442    require(allocations[companyWallet].amountClaimed.add(_tokensToTransfer) <= allocations[companyWallet].totalAllocated);
443 
444    //Transfer
445    allocations[companyWallet].amountClaimed = allocations[companyWallet].amountClaimed.add(_tokensToTransfer);
446    require(IBST.transfer(_recipient, _tokensToTransfer));
447    grandTotalClaimed = grandTotalClaimed.add(_tokensToTransfer);
448    LogIBSTClaimed(_recipient, uint8(AllocationType.COMPANY), _tokensToTransfer, allocations[companyWallet].amountClaimed, grandTotalClaimed);
449  }
450 
451  /**
452   * @dev Returns remaining Company allocation
453   * @return Returns remaining Company allocation
454   */
455  function companyRemainingAllocation() public view returns (uint256) {
456    return allocations[companyWallet].totalAllocated.sub(allocations[companyWallet].amountClaimed);
457  }
458 
459  /**
460   * @dev Returns the amount of IBST allocated
461   * @return Returns the amount of IBST allocated
462   */
463   function grandTotalAllocated() public view returns (uint256) {
464     return INITIAL_SUPPLY.sub(AVAILABLE_TOTAL_SUPPLY);
465   }
466 
467   /**
468    * @dev Admin management
469    * @param _admin Address of the admin to modify
470    * @param _allowed Status of the admin
471    */
472   function setAdmin(address _admin, bool _allowed) public onlyOwner {
473     require(_admin != address(0));
474     admins[_admin] = _allowed;
475      SetAdmin(msg.sender,_admin,_allowed);
476   }
477 
478   function refundTokens(address _token, address _refund, uint256 _value) public onlyOwner {
479     require(_refund != address(0));
480     require(_token != address(0));
481     require(_token != address(IBST));
482     ERC20 token = ERC20(_token);
483     require(token.transfer(_refund, _value));
484     RefundTokens(_token, _refund, _value);
485   }
486 }
487 
488 // File: contracts/InbestTokenDistributor.sol
489 
490 contract InbestTokenDistributor  is Ownable {
491   InbestDistribution public inbestDistribution;
492   address[] public walletsToDistribute;
493   mapping (address => address) public walletsToDistributeMapp;
494   mapping (address => bool) public admins;
495 
496   /**
497    * @dev Constructor recibe the inbestDistribution address contract.
498    */
499   function InbestTokenDistributor (InbestDistribution _inbestDistribution) public {
500     require(_inbestDistribution != address(0));
501     inbestDistribution = _inbestDistribution;
502   }
503   /**
504    * For each wallet on walletsToDistribute call to transferTokens over the inbestDistribution contract.
505    */
506   function distributeTokens() public{
507     require(walletsToDistribute.length > 0);
508     uint arrayLength = walletsToDistribute.length;
509     for (uint i=0; i < arrayLength; i++) {
510       inbestDistribution.transferTokens(walletsToDistribute[i]);
511     }
512   }
513 
514   /**
515    * For each wallet on walletsToDistribute call to transferTokens over the inbestDistribution contract.
516    */
517   function distributeTokensToWallets(address[] _addresses) public onlyOwner{
518     require(_addresses.length > 0);
519     uint arrayLength = _addresses.length;
520     for (uint i=0; i < arrayLength; i++) {
521       inbestDistribution.transferTokens(_addresses[i]);
522     }
523   }
524 
525   /**
526    * Add wallet to distribute
527    * @param _newAddress address [description]
528    */
529   function addWallet(address _newAddress) public onlyOwner{
530     require(_newAddress != address(0));
531     require(walletsToDistributeMapp[_newAddress] == address(0));
532     walletsToDistribute.push(_newAddress);
533     walletsToDistributeMapp[_newAddress] = _newAddress;
534   }
535 
536   // set the addresses in store
537   function addWallets(address[] _addresses) public onlyOwner{
538       for(uint i = 0; i < _addresses.length; i++){
539         addWallet(_addresses[i]);
540       }
541   }
542   /**
543    * Remove wallet to distribute
544    * @param  _removeAddress Address to be removed.
545    */
546   function removeWallet(address  _removeAddress) public onlyOwner {
547     for (uint i = 0; i < walletsToDistribute.length; i++){
548       if (_removeAddress == walletsToDistribute[i]) {
549         walletsToDistribute[i] = walletsToDistribute[walletsToDistribute.length-1];
550         walletsToDistribute.length--;
551         delete walletsToDistributeMapp[_removeAddress];
552       }
553     }
554   }
555 }