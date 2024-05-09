1 pragma solidity ^0.4.16;
2 
3 /**
4  *  @title ERC827 interface, an extension of ERC20 token standard
5  *   Interface of a ERC827 token, following the ERC20 standard with extra
6  *  methods to transfer value and data and execute calls in transfers and
7  *  approvals.
8  */
9 contract ERC827 {
10 
11     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
12     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
13     function transferFrom(
14         address _from,
15         address _to,
16         uint256 _value,
17         bytes _data
18     ) public returns (bool);
19 
20 }
21 
22 /**
23  * @title ERC20Basic
24  * @dev Simpler version of ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/179
26  */
27 contract ERC20Basic {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     /**
63     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85     using SafeMath for *;
86 
87     mapping(address => uint256) balances;
88     uint256 totalSupply_;
89 
90     /**
91     * @dev total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return totalSupply_;
95     }
96 
97     /**
98     * @dev transfer token for a specified address
99     * @param _to The address to transfer to.
100     * @param _value The amount to be transferred.
101     */
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_to != address(0));
104         require(_value <= balances[msg.sender]);
105 
106         // SafeMath.sub will throw if there is not enough balance.
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of.
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balances[_owner];
120     }
121 
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129     function allowance(address owner, address spender) public view returns (uint256);
130     function transferFrom(address from, address to, uint256 value) public returns (bool);
131     function approve(address spender, uint256 value) public returns (bool);
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
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
144     mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _from address The address which you want to send tokens from
150     * @param _to address The address which you want to transfer to
151     * @param _value uint256 the amount of tokens to be transferred
152     */
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     *
168     * Beware that changing an allowance with this method brings the risk that someone may use both the old
169     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     * @param _spender The address which will spend the funds.
173     * @param _value The amount of tokens to be spent.
174     */
175     function approve(address _spender, uint256 _value) public returns (bool) {
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182     * @dev Function to check the amount of tokens that an owner allowed to a spender.
183     * @param _owner address The address which owns the funds.
184     * @param _spender address The address which will spend the funds.
185     * @return A uint256 specifying the amount of tokens still available for the spender.
186     */
187     function allowance(address _owner, address _spender) public view returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190 
191     /**
192     * @dev Increase the amount of tokens that an owner allowed to a spender.
193     *
194     * approve should be called when allowed[_spender] == 0. To increment
195     * allowed value is better to use this function to avoid 2 calls (and wait until
196     * the first transaction is mined)
197     * From MonolithDAO Token.sol
198     * @param _spender The address which will spend the funds.
199     * @param _addedValue The amount of tokens to increase the allowance by.
200     */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     /**
208     * @dev Decrease the amount of tokens that an owner allowed to a spender.
209     *
210     * approve should be called when allowed[_spender] == 0. To decrement
211     * allowed value is better to use this function to avoid 2 calls (and wait until
212     * the first transaction is mined)
213     * From MonolithDAO Token.sol
214     * @param _spender The address which will spend the funds.
215     * @param _subtractedValue The amount of tokens to decrease the allowance by.
216     */
217     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220           allowed[msg.sender][_spender] = 0;
221         } else {
222           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228 }
229 
230 /**
231  *  @title ERC827, an extension of ERC20 token standard
232  *  Implementation the ERC827, following the ERC20 standard with extra
233  *  methods to transfer value and data and execute calls in transfers and
234  *  approvals.
235  *  Uses OpenZeppelin StandardToken.
236  */
237 
238 contract ERC827Token is ERC827, StandardToken {
239 
240 /**
241  *  @dev Addition to ERC20 token methods. It allows to
242  *  approve the transfer of value and execute a call with the sent data.
243  *  Beware that changing an allowance with this method brings the risk that
244  *  someone may use both the old and the new allowance by unfortunate
245  *  transaction ordering. One possible solution to mitigate this race condition
246  *  is to first reduce the spender's allowance to 0 and set the desired value
247  *  afterwards:
248  *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249  *  
250  *  @param _spender The address that will spend the funds.
251  *  @param _value The amount of tokens to be spent.
252  *  @param _data ABI-encoded contract call to call `_to` address.
253  *  @return true if the call function was executed successfully
254  */
255   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
256     require(_spender != address(this));
257 
258     super.approve(_spender, _value);
259 
260     require(_spender.call(_data));
261 
262     return true;
263   }
264 
265   /**
266      @dev Addition to ERC20 token methods. Transfer tokens to a specified
267      address and execute a call with the sent data on the same transaction
268 
269      @param _to address The address which you want to transfer to
270      @param _value uint256 the amout of tokens to be transfered
271      @param _data ABI-encoded contract call to call `_to` address.
272 
273      @return true if the call function was executed successfully
274    */
275   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
276     require(_to != address(this));
277 
278     super.transfer(_to, _value);
279 
280     require(_to.call(_data));
281     return true;
282   }
283 
284   /**
285      @dev Addition to ERC20 token methods. Transfer tokens from one address to
286      another and make a contract call on the same transaction
287 
288      @param _from The address which you want to send tokens from
289      @param _to The address which you want to transfer to
290      @param _value The amout of tokens to be transferred
291      @param _data ABI-encoded contract call to call `_to` address.
292 
293      @return true if the call function was executed successfully
294    */
295   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
296     require(_to != address(this));
297 
298     super.transferFrom(_from, _to, _value);
299 
300     require(_to.call(_data));
301     return true;
302   }
303 
304   /**
305    * @dev Addition to StandardToken methods. Increase the amount of tokens that
306    * an owner allowed to a spender and execute a call with the sent data.
307    *
308    * approve should be called when allowed[_spender] == 0. To increment
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _addedValue The amount of tokens to increase the allowance by.
314    * @param _data ABI-encoded contract call to call `_spender` address.
315    */
316   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
317     require(_spender != address(this));
318 
319     super.increaseApproval(_spender, _addedValue);
320 
321     require(_spender.call(_data));
322 
323     return true;
324   }
325 
326   /**
327    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
328    * an owner allowed to a spender and execute a call with the sent data.
329    *
330    * approve should be called when allowed[_spender] == 0. To decrement
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _subtractedValue The amount of tokens to decrease the allowance by.
336    * @param _data ABI-encoded contract call to call `_spender` address.
337    */
338   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
339     require(_spender != address(this));
340 
341     super.decreaseApproval(_spender, _subtractedValue);
342 
343     require(_spender.call(_data));
344 
345     return true;
346   }
347 
348 }
349 
350 /**
351  * @title Ownable
352  * @dev The Ownable contract has an owner address, and provides basic authorization control
353  * functions, this simplifies the implementation of "user permissions".
354  */
355 contract Ownable {
356     address public owner;
357 
358 
359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
360 
361 
362     /**
363     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
364     * account.
365     */
366     function Ownable() public {
367         owner = msg.sender;
368     }
369 
370     /**
371     * @dev Throws if called by any account other than the owner.
372     */
373     modifier onlyOwner() {
374         require(msg.sender == owner);
375         _;
376     }
377 
378     /**
379     * @dev Allows the current owner to transfer control of the contract to a newOwner.
380     * @param newOwner The address to transfer ownership to.
381     */
382     function transferOwnership(address newOwner) public onlyOwner {
383         require(newOwner != address(0));
384         OwnershipTransferred(owner, newOwner);
385         owner = newOwner;
386     }
387 
388 }
389 
390 /**
391  * @title Pausable
392  * @dev Base contract which allows children to implement an emergency stop mechanism.
393  */
394 contract Pausable is Ownable {
395     event Pause();
396     event Unpause();
397 
398     bool public paused = false;
399 
400 
401     /**
402     * @dev Modifier to make a function callable only when the contract is not paused.
403     */
404     modifier whenNotPaused() {
405         require(!paused);
406         _;
407     }
408 
409     /**
410     * @dev Modifier to make a function callable only when the contract is paused.
411     */
412     modifier whenPaused() {
413         require(paused);
414         _;
415     }
416 
417     /**
418     * @dev called by the owner to pause, triggers stopped state
419     */
420     function pause() onlyOwner whenNotPaused public {
421         paused = true;
422         Pause();
423     }
424 
425     /**
426     * @dev called by the owner to unpause, returns to normal state
427     */
428     function unpause() onlyOwner whenPaused public {
429       paused = false;
430       Unpause();
431     }
432 }
433 
434 /**
435  * @title Burnable Token
436  * @dev Token that can be irreversibly burned (destroyed).
437  */
438 contract BurnableToken is BasicToken {
439 
440     event Burn(address indexed burner, uint256 value);
441 
442     /**
443     * @dev Burns a specific amount of tokens.
444     * @param _value The amount of token to be burned.
445     */
446     function burn(uint256 _value) public {
447         require(_value <= balances[msg.sender]);
448         // no need to require value <= totalSupply, since that would imply the
449         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
450 
451         address burner = msg.sender;
452         balances[burner] = balances[burner].sub(_value);
453         totalSupply_ = totalSupply_.sub(_value);
454         Burn(burner, _value);
455     }
456 }
457 
458 /**
459  * @title Pausable token
460  * @dev StandardToken modified with pausable transfers.
461  **/
462 contract PausableToken is BurnableToken, StandardToken, Pausable {
463 
464     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
465         return super.transfer(_to, _value);
466     }
467 
468     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
469         return super.transferFrom(_from, _to, _value);
470     }
471 
472     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
473         return super.approve(_spender, _value);
474     }
475 
476     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
477         return super.increaseApproval(_spender, _addedValue);
478     }
479 
480     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
481         return super.decreaseApproval(_spender, _subtractedValue);
482     }
483 }
484 
485 /**
486  * @title Mintable token
487  * @dev Simple ERC20 Token example, with mintable token creation
488  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
489  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
490  */
491 contract MintableToken is PausableToken {
492     event Mint(address indexed to, uint256 amount);
493     event MintFinished();
494 
495     bool public mintingFinished = false;
496 
497 
498     modifier canMint() {
499         require(!mintingFinished);
500         _;
501     }
502 
503     /**
504     * @dev Function to mint tokens
505     * @param _to The address that will receive the minted tokens.
506     * @param _amount The amount of tokens to mint.
507     * @return A boolean that indicates if the operation was successful.
508     */
509     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
510         totalSupply_ = totalSupply_.add(_amount);
511         balances[_to] = balances[_to].add(_amount);
512         Mint(_to, _amount);
513         Transfer(address(0), _to, _amount);
514         return true;
515     }
516 
517     /**
518     * @dev Function to stop minting new tokens.
519     * @return True if the operation was successful.
520     */
521     function finishMinting() onlyOwner canMint public returns (bool) {
522         mintingFinished = true;
523         MintFinished();
524         return true;
525     }
526 }
527 
528 contract ShittyToken is Ownable, MintableToken, ERC827Token {
529 
530     using SafeMath for *;
531 
532     string public constant NAME = "Shitty Token"; // solium-disable-line uppercase
533     string public constant SYMBOL = "SHIT"; // solium-disable-line uppercase
534     uint8 public constant DECIMALS = 18; // solium-disable-line uppercase
535     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
536 
537     /**
538     * @dev Constructor that gives msg.sender all of existing tokens.
539     */
540     function TokenUnionToken() public {
541         totalSupply_ = INITIAL_SUPPLY;
542         balances[msg.sender] = INITIAL_SUPPLY;
543         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
544     }
545     
546 }