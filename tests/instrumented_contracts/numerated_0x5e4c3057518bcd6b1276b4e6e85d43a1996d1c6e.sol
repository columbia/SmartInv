1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address _who) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
102     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (_a == 0) {
106       return 0;
107     }
108 
109     c = _a * _b;
110     assert(c / _a == _b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
118     // assert(_b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = _a / _b;
120     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
121     return _a / _b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     assert(_b <= _a);
129     return _a - _b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
136     c = _a + _b;
137     assert(c >= _a);
138     return c;
139   }
140 }
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149     using SafeMath for uint256;
150 
151     mapping(address => uint256) internal balances;
152 
153     uint256 internal totalSupply_;
154 
155     /**
156      * @dev Total number of tokens in existence
157      */
158     function totalSupply() public view returns (uint256) {
159         return totalSupply_;
160     }
161 
162     /**
163      * @dev Transfer token for a specified address
164      * @param _to The address to transfer to.
165      * @param _value The amount to be transferred.
166      */
167     function transfer(address _to, uint256 _value) public returns (bool) {
168         require(_value <= balances[msg.sender]);
169         require(_to != address(0));
170 
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         emit Transfer(msg.sender, _to, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Gets the balance of the specified address.
179      * @param _owner The address to query the the balance of.
180      * @return An uint256 representing the amount owned by the passed address.
181      */
182     function balanceOf(address _owner) public view returns (uint256) {
183         return balances[_owner];
184     }
185 
186 }
187 
188 
189 
190 
191 
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198     function allowance(address _owner, address _spender)
199         public view returns (uint256);
200 
201     function transferFrom(address _from, address _to, uint256 _value)
202         public returns (bool);
203 
204     function approve(address _spender, uint256 _value) public returns (bool);
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210 }
211 
212 
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * https://github.com/ethereum/EIPs/issues/20
219  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222     mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225     /**
226      * @dev Transfer tokens from one address to another
227      * @param _from address The address which you want to send tokens from
228      * @param _to address The address which you want to transfer to
229      * @param _value uint256 the amount of tokens to be transferred
230      */
231     function transferFrom(
232         address _from,
233         address _to,
234         uint256 _value
235     )
236         public
237         returns (bool)
238     {
239         require(_value <= balances[_from]);
240         require(_value <= allowed[_from][msg.sender]);
241         require(_to != address(0));
242 
243         balances[_from] = balances[_from].sub(_value);
244         balances[_to] = balances[_to].add(_value);
245         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246         emit Transfer(_from, _to, _value);
247         return true;
248     }
249 
250     /**
251      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252      * Beware that changing an allowance with this method brings the risk that someone may use both the old
253      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      * @param _spender The address which will spend the funds.
257      * @param _value The amount of tokens to be spent.
258      */
259     function approve(address _spender, uint256 _value) public returns (bool) {
260         allowed[msg.sender][_spender] = _value;
261         emit Approval(msg.sender, _spender, _value);
262         return true;
263     }
264 
265     /**
266      * @dev Function to check the amount of tokens that an owner allowed to a spender.
267      * @param _owner address The address which owns the funds.
268      * @param _spender address The address which will spend the funds.
269      * @return A uint256 specifying the amount of tokens still available for the spender.
270      */
271     function allowance(
272         address _owner,
273         address _spender
274      )
275         public
276         view
277         returns (uint256)
278     {
279         return allowed[_owner][_spender];
280     }
281 
282     /**
283      * @dev Increase the amount of tokens that an owner allowed to a spender.
284      * approve should be called when allowed[_spender] == 0. To increment
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * @param _spender The address which will spend the funds.
289      * @param _addedValue The amount of tokens to increase the allowance by.
290      */
291     function increaseApproval(
292         address _spender,
293         uint256 _addedValue
294     )
295         public
296         returns (bool)
297     {
298         allowed[msg.sender][_spender] = (
299             allowed[msg.sender][_spender].add(_addedValue));
300         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301         return true;
302     }
303 
304     /**
305      * @dev Decrease the amount of tokens that an owner allowed to a spender.
306      * approve should be called when allowed[_spender] == 0. To decrement
307      * allowed value is better to use this function to avoid 2 calls (and wait until
308      * the first transaction is mined)
309      * From MonolithDAO Token.sol
310      * @param _spender The address which will spend the funds.
311      * @param _subtractedValue The amount of tokens to decrease the allowance by.
312      */
313     function decreaseApproval(
314         address _spender,
315         uint256 _subtractedValue
316     )
317         public
318         returns (bool)
319     {
320         uint256 oldValue = allowed[msg.sender][_spender];
321         if (_subtractedValue >= oldValue) {
322             allowed[msg.sender][_spender] = 0;
323         } else {
324             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325         }
326         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327         return true;
328     }
329 }
330 
331 
332 
333 /**
334  * @title Burnable Token
335  * @dev Token that can be irreversibly burned (destroyed).
336  */
337 contract BurnableToken is StandardToken, Ownable {
338     event Burn(address indexed burner, uint256 value);
339 
340 
341     /**
342      * @dev Burns a specific amount of tokens.
343      * @param _value The amount of token to be burned.
344      * @param _who The user whose token should be burned.
345      */
346     function burn(address _who, uint256 _value) onlyOwner internal {
347         require(_value <= balances[_who]);
348         // no need to require value <= totalSupply, since that would imply the
349         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
350 
351         balances[_who] = balances[_who].sub(_value);
352         totalSupply_ = totalSupply_.sub(_value);
353         emit Burn(_who, _value);
354         emit Transfer(_who, address(0), _value);
355     }
356 }
357 
358 
359 
360 
361 
362 
363 
364 
365 
366 
367 /**
368  * @title Pausable
369  * @dev Base contract which allows children to implement an emergency stop mechanism.
370  */
371 contract Pausable is Ownable {
372   event Pause();
373   event Unpause();
374 
375   bool public paused = false;
376 
377 
378   /**
379    * @dev Modifier to make a function callable only when the contract is not paused.
380    */
381   modifier whenNotPaused() {
382     require(!paused);
383     _;
384   }
385 
386   /**
387    * @dev Modifier to make a function callable only when the contract is paused.
388    */
389   modifier whenPaused() {
390     require(paused);
391     _;
392   }
393 
394   /**
395    * @dev called by the owner to pause, triggers stopped state
396    */
397   function pause() public onlyOwner whenNotPaused {
398     paused = true;
399     emit Pause();
400   }
401 
402   /**
403    * @dev called by the owner to unpause, returns to normal state
404    */
405   function unpause() public onlyOwner whenPaused {
406     paused = false;
407     emit Unpause();
408   }
409 }
410 
411 
412 
413 /**
414  * @title Pausable token
415  * @dev StandardToken modified with pausable transfers.
416  **/
417 contract PausableToken is StandardToken, Pausable {
418     function transfer(
419         address _to,
420         uint256 _value
421     )
422         public
423         whenNotPaused
424         returns (bool)
425     {
426         return super.transfer(_to, _value);
427     }
428 
429     function transferFrom(
430         address _from,
431         address _to,
432         uint256 _value
433     )
434         public
435         whenNotPaused
436         returns (bool)
437     {
438         return super.transferFrom(_from, _to, _value);
439     }
440 
441     function approve(
442         address _spender,
443         uint256 _value
444     )
445         public
446         whenNotPaused
447         returns (bool)
448     {
449         return super.approve(_spender, _value);
450     }
451 
452     function increaseApproval(
453         address _spender,
454         uint _addedValue
455     )
456         public
457         whenNotPaused
458         returns (bool success)
459     {
460         return super.increaseApproval(_spender, _addedValue);
461     }
462 
463     function decreaseApproval(
464         address _spender,
465         uint _subtractedValue
466     )
467         public
468         whenNotPaused
469         returns (bool success)
470     {
471         return super.decreaseApproval(_spender, _subtractedValue);
472     }
473 }
474 
475 
476 
477 
478 
479 
480 
481 
482 
483 /**
484  * @title Mintable token
485  * @dev Simple ERC20 Token example, with mintable token creation
486  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
487  */
488 contract MintableToken is StandardToken, Ownable {
489     event Mint(address indexed to, uint256 amount);
490     event MintFinished();
491 
492     bool public mintingFinished = false;
493 
494 
495     modifier canMint() {
496         require(!mintingFinished);
497         _;
498     }
499 
500     modifier hasMintPermission() {
501         require(msg.sender == owner);
502         _;
503     }
504 
505     /**
506      * @dev Function to mint tokens
507      * @param _to The address that will receive the minted tokens.
508      * @param _amount The amount of tokens to mint.
509      * @return A boolean that indicates if the operation was successful.
510      */
511     function mint(
512         address _to,
513         uint256 _amount
514     )
515         public
516         hasMintPermission
517         canMint
518         returns (bool)
519     {
520         totalSupply_ = totalSupply_.add(_amount);
521         balances[_to] = balances[_to].add(_amount);
522         emit Mint(_to, _amount);
523         emit Transfer(address(0), _to, _amount);
524         return true;
525     }
526 
527     /**
528      * @dev Function to stop minting new tokens.
529      * @return True if the operation was successful.
530      */
531     function finishMinting() public onlyOwner canMint returns (bool) {
532         mintingFinished = true;
533         emit MintFinished();
534         return true;
535     }
536 }
537 
538 
539 
540 /**
541  * @title Capped token
542  * @dev Mintable token with a token cap.
543  */
544 contract CappedToken is MintableToken {
545     uint256 public cap;
546 
547     constructor(uint256 _cap) public {
548         require(_cap > 0);
549         cap = _cap;
550     }
551 
552     /**
553      * @dev Function to mint tokens
554      * @param _to The address that will receive the minted tokens.
555      * @param _amount The amount of tokens to mint.
556      * @return A boolean that indicates if the operation was successful.
557      */
558     function mint(
559         address _to,
560         uint256 _amount
561     )
562         public
563         returns (bool)
564     {
565         require(totalSupply_.add(_amount) <= cap);
566 
567         return super.mint(_to, _amount);
568     }
569 }
570 
571 
572 
573 contract CryptoControlToken is BurnableToken, PausableToken, CappedToken {
574     string public name = "CryptoControl";
575     string public symbol = "CCIO";
576     uint8 public decimals = 8;
577     string public contactInformation = "contact@cryptocontrol.io";
578 
579 
580     constructor () CappedToken(100000000000000000) {}
581 }