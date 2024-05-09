1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two numbers, throws on overflow.
6      **/
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     
16     /**
17      * @dev Integer division of two numbers, truncating the quotient.
18      **/
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  **/
53  
54 contract Ownable {
55     address payable public owner;
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
60      **/
61    constructor() public {
62       owner = msg.sender;
63     }
64     
65     /**
66      * @dev Throws if called by any account other than the owner.
67      **/
68     modifier onlyOwner() {
69       require(msg.sender == owner);
70       _;
71     }
72     
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      **/
77     function transferOwnership(address payable newOwner) public onlyOwner {
78       require(newOwner != address(0));
79       emit OwnershipTransferred(owner, newOwner);
80       owner = newOwner;
81     }
82 }
83 
84 /* @title ControlledAccess
85  * @dev The ControlledAccess contract allows function to be restricted to users
86  * that possess a signed authorization from the owner of the contract. This signed
87  * message includes the user to give permission to and the contract address to prevent
88  * reusing the same authorization message on different contract with same owner. 
89  */
90 
91 /**
92  * @title ERC20Basic interface
93  * @dev Basic ERC20 interface
94  **/
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  **/
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) public view returns (uint256);
108     function transferFrom(address from, address to, uint256 value) public returns (bool);
109     function approve(address spender, uint256 value) public returns (bool);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title TokenVesting
115  * @dev A token holder contract that can release its token balance gradually like a
116  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
117  * owner.
118  */
119 contract TokenVesting is Ownable {
120   using SafeMath for uint256;
121 
122   event Vested(address beneficiary, uint256 amount);
123   event Released(address beneficiary, uint256 amount);
124 
125   struct Balance {
126       uint256 value;
127       uint256 start;
128       uint256 currentPeriod;
129   }
130 
131   mapping(address => Balance) private balances;
132   mapping (address => uint256) private released;
133   uint256 private period;
134   uint256 private duration;
135   mapping (uint256 => uint256) private percentagePerPeriod;
136 
137   constructor() public {
138     owner = msg.sender;
139     period = 4;
140     duration = 7884000;
141     percentagePerPeriod[0] = 15;
142     percentagePerPeriod[1] = 20;
143     percentagePerPeriod[2] = 30;
144     percentagePerPeriod[3] = 35;
145   }
146   
147   function balanceOf(address _owner) public view returns(uint256) {
148       return balances[_owner].value.sub(released[_owner]);
149   }
150     /**
151    * @notice Vesting token to beneficiary but not released yet.
152    * ERC20 token which is being vested
153    */
154   function vesting(address _beneficiary, uint256 _amount) public onlyOwner {
155       if(balances[_beneficiary].start == 0){
156           balances[_beneficiary].start = now;
157       }
158 
159       balances[_beneficiary].value = balances[_beneficiary].value.add(_amount);
160       emit Vested(_beneficiary, _amount);
161   }
162   
163   /**
164    * @notice Transfers vested tokens to beneficiary.
165    * ERC20 token which is being vested
166    */
167   function release(address _beneficiary) public onlyOwner {
168     require(balances[_beneficiary].currentPeriod.add(1) <= period);
169     require(balances[_beneficiary].value > released[_beneficiary]);
170     require(balances[_beneficiary].start != 0);
171     require(now >= balances[_beneficiary].start.add((balances[_beneficiary].currentPeriod.add(1) * duration)));
172 
173     uint256 amountReleasedThisPeriod = balances[_beneficiary].value.mul(percentagePerPeriod[balances[_beneficiary].currentPeriod]);
174     amountReleasedThisPeriod = amountReleasedThisPeriod.div(100);
175     released[_beneficiary] = released[_beneficiary].add(amountReleasedThisPeriod);
176     balances[_beneficiary].currentPeriod = balances[_beneficiary].currentPeriod.add(1);
177 
178     BasicToken(owner).transfer(_beneficiary, amountReleasedThisPeriod);
179 
180     emit Released(_beneficiary, amountReleasedThisPeriod);
181   }
182 }
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances.
187  **/
188 contract BasicToken is ERC20Basic {
189     using SafeMath for uint256;
190     mapping(address => uint256) balances;
191     uint256 totalSupply_;
192     
193     /**
194      * @dev total number of tokens in existence
195      **/
196     function totalSupply() public view returns (uint256) {
197         return totalSupply_;
198     }
199     
200     /**
201      * @dev transfer token for a specified address
202      * @param _to The address to transfer to.
203      * @param _value The amount to be transferred.
204      **/
205     function transfer(address _to, uint256 _value) public returns (bool) {
206         require(_to != address(0));
207         require(_value <= balances[msg.sender]);
208 
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         emit Transfer(msg.sender, _to, _value);
212         return true;
213     }
214     
215     /**
216      * @dev Gets the balance of the specified address.
217      * @param _owner The address to query the the balance of.
218      * @return An uint256 representing the amount owned by the passed address.
219      **/
220     function balanceOf(address _owner) public view returns (uint256) {
221         return balances[_owner];
222     }
223 }
224 
225 contract StandardToken is ERC20, BasicToken {
226     mapping (address => mapping (address => uint256)) allowed;
227     /**
228      * @dev Transfer tokens from one address to another
229      * @param _from address The address which you want to send tokens from
230      * @param _to address The address which you want to transfer to
231      * @param _value uint256 the amount of tokens to be transferred
232      **/
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234         require(_to != address(0));
235         require(_value <= balances[_from]);
236         require(_value <= allowed[_from][msg.sender]);
237     
238         balances[_from] = balances[_from].sub(_value);
239         balances[_to] = balances[_to].add(_value);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241         
242         emit Transfer(_from, _to, _value);
243         return true;
244     }
245     
246     /**
247      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248      *
249      * Beware that changing an allowance with this method brings the risk that someone may use both the old
250      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      * @param _spender The address which will spend the funds.
254      * @param _value The amount of tokens to be spent.
255      **/
256     function approve(address _spender, uint256 _value) public returns (bool) {
257         allowed[msg.sender][_spender] = _value;
258         emit Approval(msg.sender, _spender, _value);
259         return true;
260     }
261     
262     /**
263      * @dev Function to check the amount of tokens that an owner allowed to a spender.
264      * @param _owner address The address which owns the funds.
265      * @param _spender address The address which will spend the funds.
266      * @return A uint256 specifying the amount of tokens still available for the spender.
267      **/
268     function allowance(address _owner, address _spender) public view returns (uint256) {
269         return allowed[_owner][_spender];
270     }
271     
272     /**
273      * @dev Increase the amount of tokens that an owner allowed to a spender.
274      *
275      * approve should be called when allowed[_spender] == 0. To increment
276      * allowed value is better to use this function to avoid 2 calls (and wait until
277      * the first transaction is mined)
278      * From MonolithDAO Token.sol
279      * @param _spender The address which will spend the funds.
280      * @param _addedValue The amount of tokens to increase the allowance by.
281      **/
282     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
283         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285         return true;
286     }
287     
288     /**
289      * @dev Decrease the amount of tokens that an owner allowed to a spender.
290      *
291      * approve should be called when allowed[_spender] == 0. To decrement
292      * allowed value is better to use this function to avoid 2 calls (and wait until
293      * the first transaction is mined)
294      * From MonolithDAO Token.sol
295      * @param _spender The address which will spend the funds.
296      * @param _subtractedValue The amount of tokens to decrease the allowance by.
297      **/
298     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
299         uint oldValue = allowed[msg.sender][_spender];
300         if (_subtractedValue > oldValue) {
301             allowed[msg.sender][_spender] = 0;
302         } else {
303             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304         }
305         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306         return true;
307     }
308 }
309 
310 
311 /**
312  * @title Configurable
313  * @dev Configurable varriables of the contract
314  **/
315 contract Configurable {
316     uint256 public constant cap = 2000000000*10**18;
317     uint256 public basePrice = 314815*10**16; // tokens per 1 ether
318     uint256 public tokensSold = 0;
319     uint256 public tokensSoldInICO = 0;
320     uint256 public tokensSoldInPrivateSales = 0;
321     
322     uint256 public constant tokenReserve = 2000000000*10**18;
323     uint256 public constant tokenReserveForICO = 70000000*10**18;
324     uint256 public constant tokenReserveForPrivateSales = 630000000*10**18;
325     uint256 public remainingTokens = 0;
326     uint256 public remainingTokensForICO = 0;
327     uint256 public remainingTokensForPrivateSales = 0;
328 
329     uint256 public minTransaction = 1.76 ether;
330     uint256 public maxTransaction = 29.41 ether;
331 
332     uint256 public discountUntilSales = 1176.47 ether;
333     uint256 public totalSalesInEther = 0;
334     mapping(address => bool) public buyerGetDiscount;
335 }
336 
337 contract BurnableToken is BasicToken, Ownable {
338     event Burn(address indexed burner, uint256 value);
339     
340     function burn(uint256 _value) public onlyOwner {
341         _burn(msg.sender, _value);
342       }
343       
344     function _burn(address _who, uint256 _value) internal {
345         require(_value <= balances[_who]);
346         balances[_who] = balances[_who].sub(_value);
347         totalSupply_ = totalSupply_.sub(_value);
348         emit Burn(_who, _value);
349         emit Transfer(_who, address(0), _value);
350     }
351 }
352 
353 /**
354  * @title CrowdsaleToken 
355  * @dev Contract to preform crowd sale with token
356  **/
357 contract CrowdsaleToken is StandardToken, Configurable, BurnableToken  {
358     /**
359      * @dev enum of current crowd sale state
360      **/
361      enum Stages {
362         none,
363         icoStart,
364         icoEnd
365     }
366     
367     bool  public haltedICO = false;
368     Stages currentStage;
369     TokenVesting public tokenVestingContract;
370   
371     /**
372      * @dev constructor of CrowdsaleToken
373      **/
374     constructor() public {
375         currentStage = Stages.none;
376         balances[owner] = balances[owner].add(tokenReserve);
377         totalSupply_ = totalSupply_.add(tokenReserve);
378 
379         remainingTokens = cap;
380         remainingTokensForICO = tokenReserveForICO;
381         remainingTokensForPrivateSales = tokenReserveForPrivateSales;
382         tokenVestingContract = new TokenVesting();
383         emit Transfer(address(this), owner, tokenReserve);
384     }
385     
386     /**
387      * @dev fallback function to send ether to for Crowd sale
388      **/
389     function () external payable {
390         
391         require(!haltedICO);
392         require(currentStage == Stages.icoStart);
393         require(msg.value > 0);
394         require(remainingTokensForICO > 0);
395         require(minTransaction <= msg.value);
396         require(maxTransaction >= msg.value);
397         
398         uint256 weiAmount = msg.value; // Calculate tokens to sell
399         uint256 bonusTokens;
400         uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
401         uint256 returnWei = 0;
402 
403         //Check is discount is valid or not
404         if (totalSalesInEther.add(weiAmount) <= discountUntilSales && !buyerGetDiscount[msg.sender]) {
405             bonusTokens = tokens.div(10);
406 
407             totalSalesInEther = totalSalesInEther.add(weiAmount);
408             buyerGetDiscount[msg.sender] = true;
409         }
410         
411         if (tokensSoldInICO.add(tokens.add(bonusTokens)) > tokenReserveForICO) {
412             uint256 newTokens = tokenReserveForICO.sub(tokensSoldInICO);
413             bonusTokens = newTokens.sub(tokens);
414 
415             if (bonusTokens <= 0) {
416                 bonusTokens = 0;
417             }
418 
419             tokens = newTokens.sub(bonusTokens);
420             returnWei = tokens.div(basePrice).div(1 ether);
421         }
422         
423         //Calculate token sold in ICO and remaining token
424         tokensSoldInICO = tokensSoldInICO.add(tokens.add(bonusTokens));
425         remainingTokensForICO = tokenReserveForICO.sub(tokensSoldInICO);
426 
427         tokensSold = tokensSold.add(tokens.add(bonusTokens)); // Increment raised amount
428         remainingTokens = cap.sub(tokensSold);
429 
430         if(returnWei > 0){
431             msg.sender.transfer(returnWei);
432             emit Transfer(address(this), msg.sender, returnWei);
433         }
434         
435         balances[msg.sender] = balances[msg.sender].add(tokens);
436         balances[owner] = balances[owner].sub(tokens);
437         emit Transfer(address(this), msg.sender, tokens);
438         owner.transfer(weiAmount);// Send money to owner
439     }
440     
441     function sendPrivate(address _to, uint256 _tokens) external payable onlyOwner {
442         require(_to != address(0));
443         require(address(tokenVestingContract) != address(0));
444         require(remainingTokensForPrivateSales > 0);
445         require(tokenReserveForPrivateSales >= tokensSoldInPrivateSales.add(_tokens));
446 
447         //Calculate token sold in private sales and remaining token
448         tokensSoldInPrivateSales = tokensSoldInPrivateSales.add(_tokens);
449         remainingTokensForPrivateSales = tokenReserveForPrivateSales.sub(tokensSoldInPrivateSales);
450 
451         tokensSold = tokensSold.add(_tokens); // Increment raised amount
452         remainingTokens = cap.sub(tokensSold);
453 
454         balances[address(tokenVestingContract)] = balances[address(tokenVestingContract)].add(_tokens);
455         tokenVestingContract.vesting(_to, _tokens);
456 
457         balances[owner] = balances[owner].sub(_tokens);
458         emit Transfer(address(this), address(tokenVestingContract), _tokens);
459     }
460 
461     function release(address _to) external onlyOwner {
462         tokenVestingContract.release(_to);
463     }
464 
465     /**
466      * @dev startIco starts the public ICO
467      **/
468     function startIco() public onlyOwner {
469         require(currentStage != Stages.icoEnd);
470         currentStage = Stages.icoStart;
471     }
472     
473     event icoHalted(address sender);
474     function haltICO() public onlyOwner {
475         haltedICO = true;
476         emit icoHalted(msg.sender);
477     }
478 
479     event icoResumed(address sender);
480     function resumeICO() public onlyOwner {
481         haltedICO = false;
482         emit icoResumed(msg.sender);
483     }
484 
485     /**
486      * @dev endIco closes down the ICO 
487      **/
488     function endIco() internal {
489         currentStage = Stages.icoEnd;
490         // Transfer any remaining tokens
491         if(remainingTokens > 0)
492             balances[owner] = balances[owner].add(remainingTokens);
493         // transfer any remaining ETH balance in the contract to the owner
494         owner.transfer(address(this).balance); 
495     }
496 
497 
498     /**
499      * @dev finalizeIco closes down the ICO and sets needed varriables
500      **/
501     function finalizeIco() public onlyOwner {
502         require(currentStage != Stages.icoEnd);
503         endIco();
504     }
505 
506     function setDiscountUntilSales(uint256 _discountUntilSales) public onlyOwner {
507         discountUntilSales = _discountUntilSales;
508     }
509     
510     function setBasePrice(uint256 _basePrice) public onlyOwner {
511         basePrice = _basePrice;
512     }
513 
514     function setMinTransaction(uint256 _minTransaction) public onlyOwner {
515         minTransaction = _minTransaction;
516     }
517 
518     function setMaxTransaction(uint256 _maxTransaction) public onlyOwner {
519         maxTransaction = _maxTransaction;
520     }
521 
522     function addTokenSoldInICO(uint256 _amount) public onlyOwner {
523         tokensSoldInICO = tokensSoldInICO.add(_amount);
524         remainingTokensForICO = tokenReserveForICO.sub(tokensSoldInICO);
525 
526         tokensSold = tokensSold.add(_amount);
527         remainingTokens = cap.sub(_amount);
528     }
529 
530     function addTokenSoldInPrivateSales(uint256 _amount) public onlyOwner {
531         tokensSoldInPrivateSales = tokensSoldInPrivateSales.add(_amount);
532         remainingTokensForPrivateSales = tokenReserveForPrivateSales.sub(tokensSoldInPrivateSales);
533 
534         tokensSold = tokensSold.add(_amount);
535         remainingTokens = cap.sub(_amount);
536     }
537 }
538 
539 /**
540  * @title TokoinToken 
541  * @dev Contract to create the Tokoin Token
542  **/
543 contract TokoinToken is CrowdsaleToken {
544     string public constant name = "Tokoin";
545     string public constant symbol = "TOKO";
546     uint32 public constant decimals = 18;
547 }