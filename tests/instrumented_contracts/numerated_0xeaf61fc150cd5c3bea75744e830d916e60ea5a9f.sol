1 // File: contracts/OpenZeppelin/ERC20Basic.sol
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 // File: contracts/OpenZeppelin/SafeMath.sol
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 // File: contracts/OpenZeppelin/BasicToken.sol
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70     using SafeMath for uint256;
71 
72     mapping(address => uint256) balances;
73 
74     uint256 totalSupply_;
75 
76     /**
77     * @dev total number of tokens in existence
78     */
79     function totalSupply() public view returns (uint256) {
80         return totalSupply_;
81     }
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         emit Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100     * @dev Gets the balance of the specified address.
101     * @param _owner The address to query the the balance of.
102     * @return An uint256 representing the amount owned by the passed address.
103     */
104     function balanceOf(address _owner) public view returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108 }
109 
110 // File: contracts/OpenZeppelin/BurnableToken.sol
111 
112 /**
113  * @title Burnable Token
114  * @dev Token that can be irreversibly burned (destroyed).
115  */
116 contract BurnableToken is BasicToken {
117 
118     event Burn(address indexed burner, uint256 value);
119 
120     /**
121      * @dev Burns a specific amount of tokens.
122      * @param _value The amount of token to be burned.
123      */
124     function burn(uint256 _value) public {
125         require(_value <= balances[msg.sender]);
126         // no need to require value <= totalSupply, since that would imply the
127         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
128 
129         address burner = msg.sender;
130         balances[burner] = balances[burner].sub(_value);
131         totalSupply_ = totalSupply_.sub(_value);
132         emit Burn(burner, _value);
133         emit Transfer(burner, address(0), _value);
134     }
135 }
136 
137 // File: contracts/OpenZeppelin/ERC20.sol
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144     function allowance(address owner, address spender) public view returns (uint256);
145     function transferFrom(address from, address to, uint256 value) public returns (bool);
146     function approve(address spender, uint256 value) public returns (bool);
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 // File: contracts/OpenZeppelin/ERC827.sol
151 
152 /**
153    @title ERC827 interface, an extension of ERC20 token standard
154    Interface of a ERC827 token, following the ERC20 standard with extra
155    methods to transfer value and data and execute calls in transfers and
156    approvals.
157  */
158 contract ERC827 is ERC20 {
159 
160     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
161     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
162     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
163 
164 }
165 
166 // File: contracts/OpenZeppelin/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177     mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180     /**
181      * @dev Transfer tokens from one address to another
182      * @param _from address The address which you want to send tokens from
183      * @param _to address The address which you want to transfer to
184      * @param _value uint256 the amount of tokens to be transferred
185      */
186     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187         require(_to != address(0));
188         require(_value <= balances[_from]);
189         require(_value <= allowed[_from][msg.sender]);
190 
191         balances[_from] = balances[_from].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194         emit Transfer(_from, _to, _value);
195         return true;
196     }
197 
198     /**
199      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200      *
201      * Beware that changing an allowance with this method brings the risk that someone may use both the old
202      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      * @param _spender The address which will spend the funds.
206      * @param _value The amount of tokens to be spent.
207      */
208     function approve(address _spender, uint256 _value) public returns (bool) {
209         allowed[msg.sender][_spender] = _value;
210         emit Approval(msg.sender, _spender, _value);
211         return true;
212     }
213 
214     /**
215      * @dev Function to check the amount of tokens that an owner allowed to a spender.
216      * @param _owner address The address which owns the funds.
217      * @param _spender address The address which will spend the funds.
218      * @return A uint256 specifying the amount of tokens still available for the spender.
219      */
220     function allowance(address _owner, address _spender) public view returns (uint256) {
221         return allowed[_owner][_spender];
222     }
223 
224     /**
225      * @dev Increase the amount of tokens that an owner allowed to a spender.
226      *
227      * approve should be called when allowed[_spender] == 0. To increment
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * @param _spender The address which will spend the funds.
232      * @param _addedValue The amount of tokens to increase the allowance by.
233      */
234     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Decrease the amount of tokens that an owner allowed to a spender.
242      *
243      * approve should be called when allowed[_spender] == 0. To decrement
244      * allowed value is better to use this function to avoid 2 calls (and wait until
245      * the first transaction is mined)
246      * From MonolithDAO Token.sol
247      * @param _spender The address which will spend the funds.
248      * @param _subtractedValue The amount of tokens to decrease the allowance by.
249      */
250     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251         uint oldValue = allowed[msg.sender][_spender];
252         if (_subtractedValue > oldValue) {
253             allowed[msg.sender][_spender] = 0;
254         } else {
255             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256         }
257         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 
261 }
262 
263 // File: contracts/OpenZeppelin/ERC827Token.sol
264 
265 /**
266    @title ERC827, an extension of ERC20 token standard
267    Implementation the ERC827, following the ERC20 standard with extra
268    methods to transfer value and data and execute calls in transfers and
269    approvals.
270    Uses OpenZeppelin StandardToken.
271  */
272 contract ERC827Token is ERC827, StandardToken {
273 
274     /**
275        @dev Addition to ERC20 token methods. It allows to
276        approve the transfer of value and execute a call with the sent data.
277        Beware that changing an allowance with this method brings the risk that
278        someone may use both the old and the new allowance by unfortunate
279        transaction ordering. One possible solution to mitigate this race condition
280        is to first reduce the spender's allowance to 0 and set the desired value
281        afterwards:
282        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283        @param _spender The address that will spend the funds.
284        @param _value The amount of tokens to be spent.
285        @param _data ABI-encoded contract call to call `_to` address.
286        @return true if the call function was executed successfully
287      */
288     function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
289         require(_spender != address(this));
290 
291         super.approve(_spender, _value);
292 
293         require(_spender.call(_data));
294 
295         return true;
296     }
297 
298     /**
299        @dev Addition to ERC20 token methods. Transfer tokens to a specified
300        address and execute a call with the sent data on the same transaction
301        @param _to address The address which you want to transfer to
302        @param _value uint256 the amout of tokens to be transfered
303        @param _data ABI-encoded contract call to call `_to` address.
304        @return true if the call function was executed successfully
305      */
306     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
307         require(_to != address(this));
308 
309         super.transfer(_to, _value);
310 
311         require(_to.call(_data));
312         return true;
313     }
314 
315     /**
316        @dev Addition to ERC20 token methods. Transfer tokens from one address to
317        another and make a contract call on the same transaction
318        @param _from The address which you want to send tokens from
319        @param _to The address which you want to transfer to
320        @param _value The amout of tokens to be transferred
321        @param _data ABI-encoded contract call to call `_to` address.
322        @return true if the call function was executed successfully
323      */
324     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
325         require(_to != address(this));
326 
327         super.transferFrom(_from, _to, _value);
328 
329         require(_to.call(_data));
330         return true;
331     }
332 
333     /**
334      * @dev Addition to StandardToken methods. Increase the amount of tokens that
335      * an owner allowed to a spender and execute a call with the sent data.
336      *
337      * approve should be called when allowed[_spender] == 0. To increment
338      * allowed value is better to use this function to avoid 2 calls (and wait until
339      * the first transaction is mined)
340      * From MonolithDAO Token.sol
341      * @param _spender The address which will spend the funds.
342      * @param _addedValue The amount of tokens to increase the allowance by.
343      * @param _data ABI-encoded contract call to call `_spender` address.
344      */
345     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
346         require(_spender != address(this));
347 
348         super.increaseApproval(_spender, _addedValue);
349 
350         require(_spender.call(_data));
351 
352         return true;
353     }
354 
355     /**
356      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
357      * an owner allowed to a spender and execute a call with the sent data.
358      *
359      * approve should be called when allowed[_spender] == 0. To decrement
360      * allowed value is better to use this function to avoid 2 calls (and wait until
361      * the first transaction is mined)
362      * From MonolithDAO Token.sol
363      * @param _spender The address which will spend the funds.
364      * @param _subtractedValue The amount of tokens to decrease the allowance by.
365      * @param _data ABI-encoded contract call to call `_spender` address.
366      */
367     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
368         require(_spender != address(this));
369 
370         super.decreaseApproval(_spender, _subtractedValue);
371 
372         require(_spender.call(_data));
373 
374         return true;
375     }
376 
377 }
378 
379 // File: contracts/OpenZeppelin/Ownable.sol
380 
381 /**
382  * @title Ownable
383  * @dev The Ownable contract has an owner address, and provides basic authorization control
384  * functions, this simplifies the implementation of "user permissions".
385  */
386 contract Ownable {
387     address public owner;
388 
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392 
393     /**
394      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
395      * account.
396      */
397     constructor() public {
398         owner = msg.sender;
399     }
400 
401     /**
402      * @dev Throws if called by any account other than the owner.
403      */
404     modifier onlyOwner() {
405         require(msg.sender == owner);
406         _;
407     }
408 
409     /**
410      * @dev Allows the current owner to transfer control of the contract to a newOwner.
411      * @param newOwner The address to transfer ownership to.
412      */
413     function transferOwnership(address newOwner) public onlyOwner {
414         require(newOwner != address(0));
415         emit OwnershipTransferred(owner, newOwner);
416         owner = newOwner;
417     }
418 
419 }
420 
421 // File: contracts/OpenZeppelin/Pausable.sol
422 
423 /**
424  * @title Pausable
425  * @dev Base contract which allows children to implement an emergency stop mechanism.
426  */
427 contract Pausable is Ownable {
428     event Pause();
429     event Unpause();
430 
431     bool public paused = false;
432 
433 
434     /**
435      * @dev Modifier to make a function callable only when the contract is not paused.
436      */
437     modifier whenNotPaused() {
438         require(!paused);
439         _;
440     }
441 
442     /**
443      * @dev Modifier to make a function callable only when the contract is paused.
444      */
445     modifier whenPaused() {
446         require(paused);
447         _;
448     }
449 
450     /**
451      * @dev called by the owner to pause, triggers stopped state
452      */
453     function pause() onlyOwner whenNotPaused public {
454         paused = true;
455         emit Pause();
456     }
457 
458     /**
459      * @dev called by the owner to unpause, returns to normal state
460      */
461     function unpause() onlyOwner whenPaused public {
462         paused = false;
463         emit Unpause();
464     }
465 }
466 
467 // File: contracts/OpenZeppelin/PausableToken.sol
468 
469 /**
470  * @title Pausable token
471  * @dev StandardToken modified with pausable transfers.
472  **/
473 contract PausableToken is StandardToken, Pausable {
474 
475     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
476         return super.transfer(_to, _value);
477     }
478 
479     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
480         return super.transferFrom(_from, _to, _value);
481     }
482 
483     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
484         return super.approve(_spender, _value);
485     }
486 
487     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
488         return super.increaseApproval(_spender, _addedValue);
489     }
490 
491     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
492         return super.decreaseApproval(_spender, _subtractedValue);
493     }
494 }
495 
496 // File: contracts/PausableERC827Token.sol
497 
498 /**
499  * @title Pausable ERC827 token
500  * @dev ERC827 token modified with pausable functions.
501  **/
502 contract PausableERC827Token is ERC827Token, PausableToken {
503 
504     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
505         return super.transfer(_to, _value, _data);
506     }
507 
508     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
509         return super.transferFrom(_from, _to, _value, _data);
510     }
511 
512     function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
513         return super.approve(_spender, _value, _data);
514     }
515 
516     function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {
517         return super.increaseApproval(_spender, _addedValue, _data);
518     }
519 
520     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {
521         return super.decreaseApproval(_spender, _subtractedValue, _data);
522     }
523 }
524 
525 // File: contracts/TypeToken.sol
526 
527 contract TypeToken is PausableERC827Token, BurnableToken {
528 
529     string public constant name = "Typerium";
530     string public constant symbol = "TYPE";
531     uint32 public constant decimals = 4;
532 
533     constructor() public {
534         totalSupply_ = 20000000000000;
535         balances[owner] = totalSupply_; // Add all tokens to issuer balance
536     }
537 }