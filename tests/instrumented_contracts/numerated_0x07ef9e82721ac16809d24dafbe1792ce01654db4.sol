1 // File: contracts\interfaces\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     //function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts\SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: contracts\ChimpToken.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /*
102 Copyright (c) 2016 Smart Contract Solutions, Inc.
103 
104 Permission is hereby granted, free of charge, to any person obtaining
105 a copy of this software and associated documentation files (the
106 "Software"), to deal in the Software without restriction, including
107 without limitation the rights to use, copy, modify, merge, publish,
108 distribute, sublicense, and/or sell copies of the Software, and to
109 permit persons to whom the Software is furnished to do so, subject to
110 the following conditions:
111 
112 The above copyright notice and this permission notice shall be included
113 in all copies or substantial portions of the Software.
114 
115 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
116 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
117 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
118 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
119 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
120 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
121 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
122 */
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ChimpToken is IERC20 {
131   using SafeMath for uint256;
132 
133   // Poly Token parameters
134   string public name = 'Chimpion';
135   string public symbol = 'BNANA';
136   uint8 public constant decimals = 18;
137   uint256 public constant decimalFactor = 10 ** uint256(decimals);
138   uint256 public constant totalSupply = 100000000000 * decimalFactor;
139   mapping (address => uint256) balances;
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142   event Transfer(address indexed from, address indexed to, uint256 value);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145   /**
146   * @dev Constructor for Poly creation
147   * @dev Assigns the totalSupply to the PolyDistribution contract
148   */
149   constructor (address _ChimpDistributionContractAddress) public {
150     require(_ChimpDistributionContractAddress != address(0));
151     balances[_ChimpDistributionContractAddress] = totalSupply;
152     emit Transfer(address(0), address(_ChimpDistributionContractAddress), totalSupply);
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     // SafeMath.sub will throw if there is not enough balance.
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     emit Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts\Ownable.sol
264 
265 pragma solidity ^0.5.0;
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279      * account.
280      */
281     constructor () internal {
282         _owner = msg.sender;
283         emit OwnershipTransferred(address(0), _owner);
284     }
285 
286     /**
287      * @return the address of the owner.
288      */
289     function owner() public view returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(isOwner());
298         _;
299     }
300 
301     /**
302      * @return true if `msg.sender` is the owner of the contract.
303      */
304     function isOwner() public view returns (bool) {
305         return msg.sender == _owner;
306     }
307 
308     /**
309      * @dev Allows the current owner to relinquish control of the contract.
310      * @notice Renouncing to ownership will leave the contract without an owner.
311      * It will not be possible to call the functions with the `onlyOwner`
312      * modifier anymore.
313      */
314     function renounceOwnership() public onlyOwner {
315         emit OwnershipTransferred(_owner, address(0));
316         _owner = address(0);
317     }
318 
319     /**
320      * @dev Allows the current owner to transfer control of the contract to a newOwner.
321      * @param newOwner The address to transfer ownership to.
322      */
323     function transferOwnership(address newOwner) public onlyOwner {
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers control of the contract to a newOwner.
329      * @param newOwner The address to transfer ownership to.
330      */
331     function _transferOwnership(address newOwner) internal {
332         require(newOwner != address(0));
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335     }
336 }
337 
338 // File: contracts\ChimpDistribution.sol
339 
340 pragma solidity ^0.5.0;
341 
342 
343 
344 
345 
346 /**
347  * @title BNANA token initial distribution
348  *
349  * @dev Distribute purchasers, airdrop, reserve, and founder tokens
350  */
351 contract ChimpDistribution is Ownable {
352   using SafeMath for uint256;
353 
354   ChimpToken public BNANA;
355 
356   uint256 private constant decimalFactor = 10**uint256(18);
357   enum AllocationType { AIRDROP, MERCHANT, PAYROLL, MARKETING, PARTNERS, ADVISORS, RESERVE }
358   uint256 public constant INITIAL_SUPPLY   = 100000000000 * decimalFactor;
359   uint256 public AVAILABLE_TOTAL_SUPPLY    = 100000000000 * decimalFactor;
360 
361   uint256 public AVAILABLE_AIRDROP_SUPPLY  =      20000000 * decimalFactor; 
362   uint256 public AVAILABLE_MERCHANT_SUPPLY =   30000000000 * decimalFactor; 
363   uint256 public AVAILABLE_PAYROLL_SUPPLY =    12200000000 * decimalFactor; 
364   uint256 public AVAILABLE_MARKETING_SUPPLY =    210000000 * decimalFactor; 
365   uint256 public AVAILABLE_PARTNERS_SUPPLY =    5000000000 * decimalFactor; 
366   uint256 public AVAILABLE_ADVISORS_SUPPLY =     750000000 * decimalFactor; 
367   uint256 public AVAILABLE_RESERVE_SUPPLY  =   51820000000 * decimalFactor; 
368 
369 
370   uint256 public grandTotalClaimed = 0;
371   uint256 public startTime;
372 
373   // Allocation with vesting information
374   struct Allocation {
375     uint8 AllocationSupply; // Type of allocation
376     uint256 endCliff;       // Tokens are locked until
377     uint256 endVesting;     // This is when the tokens are fully unvested
378     uint256 totalAllocated; // Total tokens allocated
379     uint256 amountClaimed;  // Total tokens claimed
380   }
381   mapping (address => Allocation) public allocations;
382 
383   // List of admins
384   mapping (address => bool) public airdropAdmins;
385 
386   // Keeps track of whether or not a BNANA airdrop has been made to a particular address
387   mapping (address => bool) public airdrops;
388 
389   modifier onlyOwnerOrAdmin() {
390     require(isOwner() || airdropAdmins[msg.sender]);
391     _;
392   }
393 
394   event LogNewAllocation(address indexed _recipient, AllocationType indexed _fromSupply, uint256 _totalAllocated, uint256 _grandTotalAllocated);
395   event LogBNANAClaimed(address indexed _recipient, uint8 indexed _fromSupply, uint256 _amountClaimed, uint256 _totalAllocated, uint256 _grandTotalClaimed);
396 
397   /**
398     * @dev Constructor function - Set the poly token address
399     * @param _startTime The time when ChimpDistribution goes live
400     */
401   constructor (uint256 _startTime) public {
402     require(_startTime >= now);
403     require(AVAILABLE_TOTAL_SUPPLY == AVAILABLE_AIRDROP_SUPPLY.add(AVAILABLE_MERCHANT_SUPPLY).add(AVAILABLE_PAYROLL_SUPPLY).add(AVAILABLE_MARKETING_SUPPLY).add(AVAILABLE_PARTNERS_SUPPLY).add(AVAILABLE_ADVISORS_SUPPLY).add(AVAILABLE_RESERVE_SUPPLY));
404     startTime = _startTime;
405     BNANA = new ChimpToken(address(this));
406   }
407 
408   /**
409     * @dev Allow the owner of the contract to assign a new allocation
410     * @param _recipient The recipient of the allocation
411     * @param _totalAllocated The total amount of BNANA available to the receipient (after vesting)
412     * @param _supply The BNANA supply the allocation will be taken from
413     */
414 function setAllocation (address _recipient, uint256 _totalAllocated, AllocationType _supply) onlyOwner public {
415       require(allocations[_recipient].totalAllocated == 0 && _totalAllocated > 0);
416       require(_supply >= AllocationType.AIRDROP && _supply <= AllocationType.RESERVE);
417       require(_recipient != address(0));
418 
419       if (_supply == AllocationType.AIRDROP) {
420         AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(_totalAllocated);
421         allocations[_recipient] = Allocation(uint8(AllocationType.AIRDROP), 0, 0, _totalAllocated, 0);
422 
423       } else if (_supply == AllocationType.MERCHANT) {
424         AVAILABLE_MERCHANT_SUPPLY = AVAILABLE_MERCHANT_SUPPLY.sub(_totalAllocated);
425         allocations[_recipient] = Allocation(uint8(AllocationType.MERCHANT), 0, 0, _totalAllocated, 0);
426 
427       } else if (_supply == AllocationType.PAYROLL) {
428         AVAILABLE_PAYROLL_SUPPLY = AVAILABLE_PAYROLL_SUPPLY.sub(_totalAllocated);
429         allocations[_recipient] = Allocation(uint8(AllocationType.PAYROLL), 0, 0, _totalAllocated, 0);
430 
431       } else if (_supply == AllocationType.MARKETING) {
432         AVAILABLE_MARKETING_SUPPLY = AVAILABLE_MARKETING_SUPPLY.sub(_totalAllocated);
433         allocations[_recipient] = Allocation(uint8(AllocationType.MARKETING), 0, 0, _totalAllocated, 0);
434 
435       } else if (_supply == AllocationType.PARTNERS) {
436         AVAILABLE_PARTNERS_SUPPLY = AVAILABLE_PARTNERS_SUPPLY.sub(_totalAllocated);
437         allocations[_recipient] = Allocation(uint8(AllocationType.PARTNERS), 0, 0, _totalAllocated, 0);
438 
439       } else if (_supply == AllocationType.ADVISORS) {
440         AVAILABLE_ADVISORS_SUPPLY = AVAILABLE_ADVISORS_SUPPLY.sub(_totalAllocated);
441         allocations[_recipient] = Allocation(uint8(AllocationType.ADVISORS), 0, 0, _totalAllocated, 0);
442 
443       } else if (_supply == AllocationType.RESERVE) {
444         AVAILABLE_RESERVE_SUPPLY = AVAILABLE_RESERVE_SUPPLY.sub(_totalAllocated);
445         allocations[_recipient] = Allocation(uint8(AllocationType.RESERVE), 0, 0, _totalAllocated, 0);
446 
447       }
448       AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(_totalAllocated);
449       emit LogNewAllocation(_recipient, _supply, _totalAllocated, grandTotalAllocated());
450     }
451     
452   /**
453     * @dev Add an airdrop admin
454     */
455   function setAirdropAdmin(address _admin, bool _isAdmin) public onlyOwner {
456     airdropAdmins[_admin] = _isAdmin;
457   }
458 
459   /**
460     * @dev perform a transfer of allocations
461     * @param _recipient is a list of recipients
462     */
463   function airdropTokens(address[] memory _recipient, uint256[] memory _airdropAmount) public onlyOwnerOrAdmin {
464     require(now >= startTime);
465     uint airdropped;
466     for(uint256 i = 0; i< _recipient.length; i++)
467     {
468         if (!airdrops[_recipient[i]]) {
469           airdrops[_recipient[i]] = true;
470           require(BNANA.transfer(_recipient[i], _airdropAmount[i] * decimalFactor));
471           airdropped = airdropped.add(_airdropAmount[i] * decimalFactor);
472         }
473     }
474     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
475     AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);
476     grandTotalClaimed = grandTotalClaimed.add(airdropped);
477   }
478 
479   /**
480     * @dev Transfer a recipients available allocation to their address
481     * @param _recipient The address to withdraw tokens for
482     */
483   function transferTokens (address _recipient) public {
484     require(allocations[_recipient].amountClaimed < allocations[_recipient].totalAllocated);
485     require(now >= allocations[_recipient].endCliff);
486     //require(now >= startTime);
487     uint256 newAmountClaimed;
488     if (allocations[_recipient].endVesting > now) {
489       // Transfer available amount based on vesting schedule and allocation
490       newAmountClaimed = allocations[_recipient].totalAllocated.mul(now.sub(startTime)).div(allocations[_recipient].endVesting.sub(startTime));
491     } else {
492       // Transfer total allocated (minus previously claimed tokens)
493       newAmountClaimed = allocations[_recipient].totalAllocated;
494     }
495     uint256 tokensToTransfer = newAmountClaimed.sub(allocations[_recipient].amountClaimed);
496     allocations[_recipient].amountClaimed = newAmountClaimed;
497     require(BNANA.transfer(_recipient, tokensToTransfer));
498     grandTotalClaimed = grandTotalClaimed.add(tokensToTransfer);
499     emit LogBNANAClaimed(_recipient, allocations[_recipient].AllocationSupply, tokensToTransfer, newAmountClaimed, grandTotalClaimed);
500   }
501 
502   // Returns the amount of BNANA allocated
503   function grandTotalAllocated() public view returns (uint256) {
504     return INITIAL_SUPPLY - AVAILABLE_TOTAL_SUPPLY;
505   }
506 
507   // Allow transfer of accidentally sent ERC20 tokens
508   function refundTokens(address _recipient, address _token) public onlyOwner {
509     require(_token != address(BNANA));
510     IERC20 token = IERC20(_token);
511     uint256 balance = token.balanceOf(address(this));
512     require(token.transfer(_recipient, balance));
513   }
514 }