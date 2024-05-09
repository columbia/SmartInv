1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of user permissions.
7  */
8 
9 contract Ownable {
10     address public owner;
11     address public newOwner;
12     address public adminer;
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30     
31   /**
32    * @dev Throws if called by any account other than the adminer.
33    */
34     modifier onlyAdminer {
35         require(msg.sender == owner || msg.sender == adminer);
36         _;
37     }
38     
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a new owner.
41    * @param _owner The address to transfer ownership to.
42    */
43     function transferOwnership(address _owner) public onlyOwner {
44         newOwner = _owner;
45     }
46     
47   /**
48    * @dev New owner accept control of the contract.
49    */
50     function acceptOwnership() public {
51         require(msg.sender == newOwner);
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54         newOwner = address(0x0);
55     }
56     
57   /**
58    * @dev change the control of the contract to a new adminer.
59    * @param _adminer The address to transfer adminer to.
60    */
61     function changeAdminer(address _adminer) public onlyOwner {
62         adminer = _adminer;
63     }
64     
65 }
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72  
73 library SafeMath {
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         assert(c / a == b);
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // assert(b > 0); // Solidity automatically throws when dividing by 0
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         assert(b <= a);
92         return a - b;
93     }
94 
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 }
101 
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  */
107  
108 contract ERC20Basic {
109     uint256 public totalSupply;
110     function balanceOf(address who) public view returns (uint256);
111     function transfer(address to, uint256 value) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120  
121 contract BasicToken is ERC20Basic {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) balances;
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         require(_to != address(0));
133         require(_value <= balances[msg.sender]);
134 
135     // SafeMath.sub will throw if there is not enough balance.
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147     function balanceOf(address _owner) public view returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151 }
152 
153 
154 /**
155  * @title ERC20 interface
156  */
157  
158 contract ERC20 is ERC20Basic {
159     function allowance(address owner, address spender) public view returns (uint256);
160     function transferFrom(address from, address to, uint256 value) public returns (bool);
161     function approve(address spender, uint256 value) public returns (bool);
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  */
171  
172 contract StandardToken is ERC20, BasicToken {
173 
174     mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to tran sfer to.
180   * @param _value The amount to be transferred.
181   */
182     function transfer(address _to, uint256 _value) public returns (bool) {
183         return BasicToken.transfer(_to, _value);
184     }
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193         require(_to != address(0));
194         require(_value <= balances[_from]);
195         require(_value <= allowed[_from][msg.sender]);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201         return true;
202     }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214     function approve(address _spender, uint256 _value) public returns (bool) {
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true;
218     }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226     function allowance(address _owner, address _spender) public view returns (uint256) {
227         return allowed[_owner][_spender];
228     }
229 
230   /**
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    */
236     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
243         uint oldValue = allowed[msg.sender][_spender];
244         if (_subtractedValue > oldValue) {
245             allowed[msg.sender][_spender] = 0;
246         } else {
247             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248         }
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253 }
254 
255 
256 /**
257  * @title Mintable token
258  */
259 
260 contract MintableToken is StandardToken, Ownable {
261     event Mint(address indexed to, uint256 amount);
262 
263 
264   /**
265    * @dev Function to mint tokens
266    * @param _to The address that will receive the minted tokens.
267    * @param _amount The amount of tokens to mint.
268    * @return A boolean that indicates if the operation was successful.
269    */
270     function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {
271         totalSupply = totalSupply.add(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         emit Mint(_to, _amount);
274         emit Transfer(address(0), _to, _amount);
275         return true;
276     }
277 }
278 
279 /**
280  * @title Additioal token
281  * @dev Mintable token with a token can be increased with proportion.
282  */
283  
284 contract AdditionalToken is MintableToken {
285 
286     uint256 public maxProportion;
287     uint256 public lockedYears;
288     uint256 public initTime;
289 
290     mapping(uint256 => uint256) public records;
291     mapping(uint256 => uint256) public maxAmountPer;
292     
293     event MintRequest(uint256 _curTimes, uint256 _maxAmountPer, uint256 _curAmount);
294 
295 
296     constructor(uint256 _maxProportion, uint256 _lockedYears) public {
297         require(_maxProportion >= 0);
298         require(_lockedYears >= 0);
299         
300         maxProportion = _maxProportion;
301         lockedYears = _lockedYears;
302         initTime = block.timestamp;
303     }
304 
305   /**
306    * @dev Function to Increase tokens
307    * @param _to The address that will receive the minted tokens.
308    * @param _amount The amount of the minted tokens.
309    * @return A boolean that indicates if the operation was successful.
310    */
311     function mint(address _to, uint256 _amount) onlyAdminer public returns (bool) {
312         uint256 curTime = block.timestamp;
313         uint256 curTimes = curTime.sub(initTime)/(31536000);
314         
315         require(curTimes >= lockedYears);
316         
317         uint256 _maxAmountPer;
318         if(maxAmountPer[curTimes] == 0) {
319             maxAmountPer[curTimes] = totalSupply.mul(maxProportion).div(100);
320         }
321         _maxAmountPer = maxAmountPer[curTimes];
322         require(records[curTimes].add(_amount) <= _maxAmountPer);
323         records[curTimes] = records[curTimes].add(_amount);
324         emit MintRequest(curTimes, _maxAmountPer, records[curTimes]);        
325         return(super.mint(_to, _amount));
326     }
327 
328 }
329 
330 /**
331  * @title Pausable
332  * @dev Base contract which allows children to implement an emergency stop mechanism.
333  */
334  
335 contract Pausable is Ownable {
336     event Pause();
337     event Unpause();
338 
339     bool public paused = false;
340 
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is not paused.
344    */
345     modifier whenNotPaused() {
346         require(!paused);
347         _;
348     }
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is paused.
352    */
353     modifier whenPaused() {
354         require(paused);
355         _;
356     }
357 
358   /**
359    * @dev called by the owner to pause, triggers stopped state
360    */
361     function pause() onlyAdminer whenNotPaused public {
362         paused = true;
363         emit Pause();
364     }
365 
366   /**
367    * @dev called by the owner to unpause, returns to normal state
368    */
369     function unpause() onlyAdminer whenPaused public {
370         paused = false;
371         emit Unpause();
372     }
373 }
374 
375 
376 /**
377  * @title Pausable token
378  * @dev StandardToken modified with pausable transfers.
379  **/
380 
381 contract PausableToken is StandardToken, Pausable {
382 
383     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
384         return super.transfer(_to, _value);
385     }
386 
387     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
388         return super.transferFrom(_from, _to, _value);
389     }
390 
391     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
392         return super.approve(_spender, _value);
393     }
394 
395     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
396         return super.increaseApproval(_spender, _addedValue);
397     }
398 
399     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
400         return super.decreaseApproval(_spender, _subtractedValue);
401     }
402 }
403 
404 /**
405  * @title Token contract
406  */
407  
408 contract Token is AdditionalToken, PausableToken {
409 
410     using SafeMath for uint256;
411     
412     string public  name;
413     string public symbol;
414     uint256 public decimals;
415 
416     mapping(address => bool) public singleLockFinished;
417     
418     struct lockToken {
419         uint256 amount;
420         uint256 validity;
421     }
422 
423     mapping(address => lockToken[]) public locked;
424     
425     
426     event Lock(
427         address indexed _of,
428         uint256 _amount,
429         uint256 _validity
430     );
431     
432     function () payable public  {
433         revert();
434     }
435     
436     constructor (string _symbol, string _name, uint256 _decimals, uint256 _initSupply, 
437                     uint256 _maxProportion, uint256 _lockedYears) AdditionalToken(_maxProportion, _lockedYears) public {
438         name = _name;
439         symbol = _symbol;
440         decimals = _decimals;
441         totalSupply = totalSupply.add(_initSupply * (10 ** decimals));
442         balances[msg.sender] = totalSupply.div(2);
443         balances[address(this)] = totalSupply - balances[msg.sender];
444     }
445 
446     /**
447      * @dev Lock the special address 
448      *
449      * @param _time The array of released timestamp 
450      * @param _amountWithoutDecimal The array of amount of released tokens
451      * NOTICE: the amount in this function not include decimals. 
452      */
453     
454     function lock(address _address, uint256[] _time, uint256[] _amountWithoutDecimal) onlyAdminer public returns(bool) {
455         require(!singleLockFinished[_address]);
456         require(_time.length == _amountWithoutDecimal.length);
457         if(locked[_address].length != 0) {
458             locked[_address].length = 0;
459         }
460         uint256 len = _time.length;
461         uint256 totalAmount = 0;
462         uint256 i = 0;
463         for(i = 0; i<len; i++) {
464             totalAmount = totalAmount.add(_amountWithoutDecimal[i]*(10 ** decimals));
465         }
466         require(balances[_address] >= totalAmount);
467         for(i = 0; i < len; i++) {
468             locked[_address].push(lockToken(_amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i])));
469             emit Lock(_address, _amountWithoutDecimal[i]*(10 ** decimals), block.timestamp.add(_time[i]));
470         }
471         return true;
472     }
473     
474     function finishSingleLock(address _address) onlyAdminer public {
475         singleLockFinished[_address] = true;
476     }
477     
478     /**
479      * @dev Returns tokens locked for a specified address for a
480      *      specified purpose at a specified time
481      *
482      * @param _of The address whose tokens are locked
483      * @param _time The timestamp to query the lock tokens for
484      */
485     function tokensLocked(address _of, uint256 _time)
486         public
487         view
488         returns (uint256 amount)
489     {
490         for(uint256 i = 0;i < locked[_of].length;i++)
491         {
492             if(locked[_of][i].validity>_time)
493                 amount += locked[_of][i].amount;
494         }
495     }
496 
497     /**
498      * @dev Returns tokens available for transfer for a specified address
499      * @param _of The address to query the the lock tokens of
500      */
501     function transferableBalanceOf(address _of)
502         public
503         view
504         returns (uint256 amount)
505     {
506         uint256 lockedAmount = 0;
507         lockedAmount += tokensLocked(_of, block.timestamp);
508         amount = balances[_of].sub(lockedAmount);
509     }
510     
511     function transfer(address _to, uint256 _value) public  returns (bool) {
512         require(_value <= transferableBalanceOf(msg.sender));
513         return super.transfer(_to, _value);
514     }
515 
516     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
517         require(_value <= transferableBalanceOf(_from));
518         return super.transferFrom(_from, _to, _value);
519     }
520     
521     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdminer returns (bool success) {
522         return ERC20(tokenAddress).transfer(owner, tokens);
523     }
524 }