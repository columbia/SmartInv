1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (a == 0) {
32       return 0;
33     }
34 
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender)
121     public view returns (uint256);
122 
123   function transferFrom(address from, address to, uint256 value)
124     public returns (bool);
125 
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address _owner,
196     address _spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    */
294   function renounceOwnership() public onlyOwner {
295     emit OwnershipRenounced(owner);
296     owner = address(0);
297   }
298 
299   /**
300    * @dev Allows the current owner to transfer control of the contract to a newOwner.
301    * @param _newOwner The address to transfer ownership to.
302    */
303   function transferOwnership(address _newOwner) public onlyOwner {
304     _transferOwnership(_newOwner);
305   }
306 
307   /**
308    * @dev Transfers control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function _transferOwnership(address _newOwner) internal {
312     require(_newOwner != address(0));
313     emit OwnershipTransferred(owner, _newOwner);
314     owner = _newOwner;
315   }
316 }
317 
318 
319 contract FreezableToken is StandardToken {
320     // freezing chains
321     mapping (bytes32 => uint64) internal chains;
322     // freezing amounts for each chain
323     mapping (bytes32 => uint) internal freezings;
324     // total freezing balance per address
325     mapping (address => uint) internal freezingBalance;
326 
327     event Freezed(address indexed to, uint64 release, uint amount);
328     event Released(address indexed owner, uint amount);
329 
330     /**
331      * @dev Gets the balance of the specified address include freezing tokens.
332      * @param _owner The address to query the the balance of.
333      * @return An uint256 representing the amount owned by the passed address.
334      */
335     function balanceOf(address _owner) public view returns (uint256 balance) {
336         return super.balanceOf(_owner) + freezingBalance[_owner];
337     }
338 
339     /**
340      * @dev Gets the balance of the specified address without freezing tokens.
341      * @param _owner The address to query the the balance of.
342      * @return An uint256 representing the amount owned by the passed address.
343      */
344     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
345         return super.balanceOf(_owner);
346     }
347 
348     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
349         return freezingBalance[_owner];
350     }
351 
352     /**
353      * @dev gets freezing count
354      * @param _addr Address of freeze tokens owner.
355      */
356     function freezingCount(address _addr) public view returns (uint count) {
357         uint64 release = chains[toKey(_addr, 0)];
358         while (release != 0) {
359             count++;
360             release = chains[toKey(_addr, release)];
361         }
362     }
363 
364     /**
365      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
366      * @param _addr Address of freeze tokens owner.
367      * @param _index Freezing portion index. It ordered by release date descending.
368      */
369     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
370         for (uint i = 0; i < _index + 1; i++) {
371             _release = chains[toKey(_addr, _release)];
372             if (_release == 0) {
373                 return;
374             }
375         }
376         _balance = freezings[toKey(_addr, _release)];
377     }
378 
379     /**
380      * @dev freeze your tokens to the specified address.
381      *      Be careful, gas usage is not deterministic,
382      *      and depends on how many freezes _to address already has.
383      * @param _to Address to which token will be freeze.
384      * @param _amount Amount of token to freeze.
385      * @param _until Release date, must be in future.
386      */
387     function freezeTo(address _to, uint _amount, uint64 _until) public {
388         require(_to != address(0));
389         require(_amount <= balances[msg.sender]);
390 
391         balances[msg.sender] = balances[msg.sender].sub(_amount);
392 
393         bytes32 currentKey = toKey(_to, _until);
394         freezings[currentKey] = freezings[currentKey].add(_amount);
395         freezingBalance[_to] = freezingBalance[_to].add(_amount);
396 
397         freeze(_to, _until);
398         emit Transfer(msg.sender, _to, _amount);
399         emit Freezed(_to, _until, _amount);
400     }
401 
402     /**
403      * @dev release first available freezing tokens.
404      */
405     function releaseOnce() public {
406         bytes32 headKey = toKey(msg.sender, 0);
407         uint64 head = chains[headKey];
408         require(head != 0);
409         require(uint64(block.timestamp) > head);
410         bytes32 currentKey = toKey(msg.sender, head);
411 
412         uint64 next = chains[currentKey];
413 
414         uint amount = freezings[currentKey];
415         delete freezings[currentKey];
416 
417         balances[msg.sender] = balances[msg.sender].add(amount);
418         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
419 
420         if (next == 0) {
421             delete chains[headKey];
422         } else {
423             chains[headKey] = next;
424             delete chains[currentKey];
425         }
426         emit Released(msg.sender, amount);
427     }
428 
429     /**
430      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
431      * @return how many tokens was released
432      */
433     function releaseAll() public returns (uint tokens) {
434         uint release;
435         uint balance;
436         (release, balance) = getFreezing(msg.sender, 0);
437         while (release != 0 && block.timestamp > release) {
438             releaseOnce();
439             tokens += balance;
440             (release, balance) = getFreezing(msg.sender, 0);
441         }
442     }
443 
444     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
445         // WISH masc to increase entropy
446         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
447         assembly {
448             result := or(result, mul(_addr, 0x10000000000000000))
449             result := or(result, _release)
450         }
451     }
452 
453     function freeze(address _to, uint64 _until) internal {
454         require(_until > block.timestamp);
455         bytes32 key = toKey(_to, _until);
456         bytes32 parentKey = toKey(_to, uint64(0));
457         uint64 next = chains[parentKey];
458 
459         if (next == 0) {
460             chains[parentKey] = _until;
461             return;
462         }
463 
464         bytes32 nextKey = toKey(_to, next);
465         uint parent;
466 
467         while (next != 0 && _until > next) {
468             parent = next;
469             parentKey = nextKey;
470 
471             next = chains[nextKey];
472             nextKey = toKey(_to, next);
473         }
474 
475         if (_until == next) {
476             return;
477         }
478 
479         if (next != 0) {
480             chains[key] = next;
481         }
482 
483         chains[parentKey] = _until;
484     }
485 }
486 
487 
488 /**
489  * @title Burnable Token
490  * @dev Token that can be irreversibly burned (destroyed).
491  */
492 contract BurnableToken is BasicToken {
493 
494   event Burn(address indexed burner, uint256 value);
495 
496   /**
497    * @dev Burns a specific amount of tokens.
498    * @param _value The amount of token to be burned.
499    */
500   function burn(uint256 _value) public {
501     _burn(msg.sender, _value);
502   }
503 
504   function _burn(address _who, uint256 _value) internal {
505     require(_value <= balances[_who]);
506     // no need to require value <= totalSupply, since that would imply the
507     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
508 
509     balances[_who] = balances[_who].sub(_value);
510     totalSupply_ = totalSupply_.sub(_value);
511     emit Burn(_who, _value);
512     emit Transfer(_who, address(0), _value);
513   }
514 }
515 
516 
517 
518 /**
519  * @title Pausable
520  * @dev Base contract which allows children to implement an emergency stop mechanism.
521  */
522 contract Pausable is Ownable {
523   event Pause();
524   event Unpause();
525 
526   bool public paused = false;
527 
528 
529   /**
530    * @dev Modifier to make a function callable only when the contract is not paused.
531    */
532   modifier whenNotPaused() {
533     require(!paused);
534     _;
535   }
536 
537   /**
538    * @dev Modifier to make a function callable only when the contract is paused.
539    */
540   modifier whenPaused() {
541     require(paused);
542     _;
543   }
544 
545   /**
546    * @dev called by the owner to pause, triggers stopped state
547    */
548   function pause() onlyOwner whenNotPaused public {
549     paused = true;
550     emit Pause();
551   }
552 
553   /**
554    * @dev called by the owner to unpause, returns to normal state
555    */
556   function unpause() onlyOwner whenPaused public {
557     paused = false;
558     emit Unpause();
559   }
560 }
561 
562 
563 contract TCNXToken is  FreezableToken, BurnableToken, Pausable
564 {
565     
566     address public fundsWallet = 0x368E1ED074e2F6bBEca5731C8BaE8460d1cA2529;
567 
568     // 20B total supply
569     uint256 public totalSupply = 20 * 1000000000 ether;
570 
571     uint256 public blockDate = 1561852800;
572 
573     constructor() public {
574         transferOwnership(fundsWallet);
575         balances[fundsWallet] = totalSupply;
576         Transfer(0x0, fundsWallet, totalSupply);
577     }
578     
579 
580     function name() public pure returns (string _name) {
581         return "Tercet Network";
582     }
583 
584     function symbol() public pure returns (string _symbol) {
585         return "TCNX";
586     }
587 
588     function decimals() public pure returns (uint8 _decimals) {
589         return 18;
590     }
591 
592     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
593         require(!paused);
594         require(!isBlocked(_from, _value));
595 
596         return super.transferFrom(_from, _to, _value);
597     }
598 
599     function transfer(address _to, uint256 _value) public returns (bool _success) {
600         require(!paused);
601         require(!isBlocked(msg.sender, _value));
602         return super.transfer(_to, _value);
603     }
604 
605     function isBlocked(address _from, uint256 _value) returns(bool _blocked){
606         if(_from != fundsWallet || now > blockDate){
607             return false;
608         }
609         if(balances[_from].sub(_value) < totalSupply.mul(50).div(100)){
610             return true;
611         }
612         return false;
613     }
614 }