1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title InbestToken
214  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
215  * Note they can later distribute these tokens as they wish using `transfer` and other
216  * `StandardToken` functions.
217  */
218 contract InbestToken is StandardToken {
219 
220   string public constant name = "Inbest Token";
221   string public constant symbol = "IBST";
222   uint8 public constant decimals = 18;
223 
224   // TBD
225   uint256 public constant INITIAL_SUPPLY = 17656263110 * (10 ** uint256(decimals));
226 
227   /**
228    * @dev Constructor that gives msg.sender all of existing tokens.
229    */
230   function InbestToken() public {
231     totalSupply_ = INITIAL_SUPPLY;
232     balances[msg.sender] = INITIAL_SUPPLY;
233     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
234   }
235 
236 }
237 
238 /**
239  * @title Ownable
240  * @dev The Ownable contract has an owner address, and provides basic authorization control
241  * functions, this simplifies the implementation of "user permissions".
242  */
243 contract Ownable {
244   address public owner;
245 
246 
247   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249 
250   /**
251    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252    * account.
253    */
254   function Ownable() public {
255     owner = msg.sender;
256   }
257 
258   /**
259    * @dev Throws if called by any account other than the owner.
260    */
261   modifier onlyOwner() {
262     require(msg.sender == owner);
263     _;
264   }
265 
266   /**
267    * @dev Allows the current owner to transfer control of the contract to a newOwner.
268    * @param newOwner The address to transfer ownership to.
269    */
270   function transferOwnership(address newOwner) public onlyOwner {
271     require(newOwner != address(0));
272     OwnershipTransferred(owner, newOwner);
273     owner = newOwner;
274   }
275 
276 }
277 
278 /**
279  * @title Inbest Token initial distribution
280  *
281  * @dev Distribute Investors' and Company's tokens
282  */
283 contract InbestDistribution is Ownable {
284   using SafeMath for uint256;
285 
286   // Token
287   InbestToken public IBST;
288 
289   // Status of admins
290   mapping (address => bool) public admins;
291 
292   // Number of decimal places for tokens
293   uint256 private constant DECIMALFACTOR = 10**uint256(18);
294 
295   // Cliff period = 6 months
296   uint256 CLIFF = 180 days;  
297   // Vesting period = 12 months after cliff
298   uint256 VESTING = 365 days; 
299 
300   // Total of tokens
301   uint256 public constant INITIAL_SUPPLY   =    17656263110 * DECIMALFACTOR; // 14.000.000.000 IBST
302   // Total of available tokens
303   uint256 public AVAILABLE_TOTAL_SUPPLY    =    17656263110 * DECIMALFACTOR; // 14.000.000.000 IBST
304   // Total of available tokens for presale allocations
305   uint256 public AVAILABLE_PRESALE_SUPPLY  =    16656263110 * DECIMALFACTOR; // 500.000.000 IBST, 18 months vesting, 6 months cliff
306   // Total of available tokens for company allocation
307   uint256 public AVAILABLE_COMPANY_SUPPLY  =    1000000000 * DECIMALFACTOR; // 13.500.000.000 INST at token distribution event
308 
309   // Allocation types
310   enum AllocationType { PRESALE, COMPANY}
311 
312   // Amount of total tokens claimed
313   uint256 public grandTotalClaimed = 0;
314   // Time when InbestDistribution goes live
315   uint256 public startTime;
316 
317   // The only wallet allowed for Company supply
318   address public companyWallet;
319 
320   // Allocation with vesting and cliff information
321   struct Allocation {
322     uint8 allocationType;   // Type of allocation
323     uint256 endCliff;       // Tokens are locked until
324     uint256 endVesting;     // This is when the tokens are fully unvested
325     uint256 totalAllocated; // Total tokens allocated
326     uint256 amountClaimed;  // Total tokens claimed
327   }
328   mapping (address => Allocation) public allocations;
329 
330   // Modifier to control who executes functions
331   modifier onlyOwnerOrAdmin() {
332     require(msg.sender == owner || admins[msg.sender]);
333     _;
334   }
335 
336   // Event fired when a new allocation is made
337   event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
338   // Event fired when IBST tokens are claimed
339   event LogIBSTClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
340   // Event fired when admins are modified
341   event SetAdmin(address _caller, address _admin, bool _allowed);
342   // Event fired when refunding tokens mistakenly sent to contract
343   event RefundTokens(address _token, address _refund, uint256 _value);
344 
345   /**
346     * @dev Constructor function - Set the inbest token address
347     * @param _startTime The time when InbestDistribution goes live
348     * @param _companyWallet The wallet to allocate Company tokens
349     */
350   function InbestDistribution(uint256 _startTime, address _companyWallet) public {
351     require(_companyWallet != address(0));
352     require(_startTime >= now);
353     require(AVAILABLE_TOTAL_SUPPLY == AVAILABLE_PRESALE_SUPPLY.add(AVAILABLE_COMPANY_SUPPLY));
354     startTime = _startTime;
355     companyWallet = _companyWallet;
356     IBST = new InbestToken();
357     require(AVAILABLE_TOTAL_SUPPLY == IBST.totalSupply()); //To verify that totalSupply is correct
358 
359     // Allocate Company Supply
360     uint256 tokensToAllocate = AVAILABLE_COMPANY_SUPPLY;
361     AVAILABLE_COMPANY_SUPPLY = 0;
362     allocations[companyWallet] = Allocation(uint8(AllocationType.COMPANY), 0, 0, tokensToAllocate, 0);
363     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(tokensToAllocate);
364     LogNewAllocation(companyWallet, AllocationType.COMPANY, tokensToAllocate, grandTotalAllocated());
365   }
366 
367   /**
368     * @dev Allow the owner or admins of the contract to assign a new allocation
369     * @param _recipient The recipient of the allocation
370     * @param _totalAllocated The total amount of IBST tokens available to the receipient (after vesting and cliff)
371     */
372   function setAllocation (address _recipient, uint256 _totalAllocated) public onlyOwnerOrAdmin {
373     require(_recipient != address(0));
374     require(startTime > now); //Allocations are allowed only before starTime
375     require(AVAILABLE_PRESALE_SUPPLY >= _totalAllocated); //Current allocation must be less than remaining presale supply
376     require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0); // Must be the first and only allocation for this recipient
377     require(_recipient != companyWallet); // Receipient of presale allocation can't be company wallet
378 
379     // Allocate
380     AVAILABLE_PRESALE_SUPPLY = AVAILABLE_PRESALE_SUPPLY.sub(_totalAllocated);
381     allocations[_recipient] = Allocation(uint8(AllocationType.PRESALE), startTime.add(CLIFF), startTime.add(CLIFF).add(VESTING), _totalAllocated, 0);
382     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
383     LogNewAllocation(_recipient, AllocationType.PRESALE, _totalAllocated, grandTotalAllocated());
384   }
385 
386   /**
387    * @dev Transfer a recipients available allocation to their address
388    * @param _recipient The address to withdraw tokens for
389    */
390  function transferTokens (address _recipient) public {
391    require(_recipient != address(0));
392    require(now >= startTime); //Tokens can't be transfered until start date
393    require(_recipient != companyWallet); // Tokens allocated to COMPANY can't be withdrawn.
394    require(now >= allocations[_recipient].endCliff); // Cliff period must be ended
395    // Receipient can't claim more IBST tokens than allocated
396    require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
397 
398    uint256 newAmountClaimed;
399    if (allocations[_recipient].endVesting > now) {
400      // Transfer available amount based on vesting schedule and allocation
401      newAmountClaimed = allocations[_recipient].totalAllocated.mul(now.sub(allocations[_recipient].endCliff)).div(allocations[_recipient].endVesting.sub(allocations[_recipient].endCliff));
402    } else {
403      // Transfer total allocated (minus previously claimed tokens)
404      newAmountClaimed = allocations[_recipient].totalAllocated;
405    }
406 
407    //Transfer
408    uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
409    allocations[_recipient].amountClaimed = newAmountClaimed;
410    require(IBST.transfer(_recipient, tokensToTransfer));
411    grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
412    LogIBSTClaimed(_recipient, allocations[_recipient].allocationType, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
413  }
414 
415  /**
416   * @dev Transfer IBST tokens from Company allocation to reicipient address - Only owner and admins can execute
417   * @param _recipient The address to transfer tokens for
418   * @param _tokensToTransfer The amount of IBST tokens to transfer
419   */
420  function manualContribution(address _recipient, uint256 _tokensToTransfer) public onlyOwnerOrAdmin {
421    require(_recipient != address(0));
422    require(_recipient != companyWallet); // Company can't withdraw tokens for itself
423    require(_tokensToTransfer > 0); // The amount must be valid
424    require(now >= startTime); // Tokens cant't be transfered until start date
425    //Company can't trasnfer more tokens than allocated
426    require(allocations[companyWallet].amountClaimed.add(_tokensToTransfer) <= allocations[companyWallet].totalAllocated);
427 
428    //Transfer
429    allocations[companyWallet].amountClaimed = allocations[companyWallet].amountClaimed.add(_tokensToTransfer);
430    require(IBST.transfer(_recipient, _tokensToTransfer));
431    grandTotalClaimed = grandTotalClaimed.add(_tokensToTransfer);
432    LogIBSTClaimed(_recipient, uint8(AllocationType.COMPANY), _tokensToTransfer, allocations[companyWallet].amountClaimed, grandTotalClaimed);
433  }
434 
435  /**
436   * @dev Returns remaining Company allocation
437   * @return Returns remaining Company allocation
438   */
439  function companyRemainingAllocation() public view returns (uint256) {
440    return allocations[companyWallet].totalAllocated.sub(allocations[companyWallet].amountClaimed);
441  }
442 
443  /**
444   * @dev Returns the amount of IBST allocated
445   * @return Returns the amount of IBST allocated
446   */
447   function grandTotalAllocated() public view returns (uint256) {
448     return INITIAL_SUPPLY.sub(AVAILABLE_TOTAL_SUPPLY);
449   }
450 
451   /**
452    * @dev Admin management
453    * @param _admin Address of the admin to modify
454    * @param _allowed Status of the admin
455    */
456   function setAdmin(address _admin, bool _allowed) public onlyOwner {
457     require(_admin != address(0));
458     admins[_admin] = _allowed;
459      SetAdmin(msg.sender,_admin,_allowed);
460   }
461 
462   function refundTokens(address _token, address _refund, uint256 _value) public onlyOwner {
463     require(_refund != address(0));
464     require(_token != address(0));
465     require(_token != address(IBST));
466     ERC20 token = ERC20(_token);
467     require(token.transfer(_refund, _value));
468     RefundTokens(_token, _refund, _value);
469   }
470 }