1 pragma solidity ^0.4.18;
2 
3 // File: contracts/OpenZeppelin/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/OpenZeppelin/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: contracts/OpenZeppelin/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72     using SafeMath for uint256;
73 
74     mapping(address => uint256) balances;
75 
76     uint256 totalSupply_;
77 
78     /**
79     * @dev total number of tokens in existence
80     */
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84 
85     /**
86     * @dev transfer token for a specified address
87     * @param _to The address to transfer to.
88     * @param _value The amount to be transferred.
89     */
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[msg.sender]);
93 
94         // SafeMath.sub will throw if there is not enough balance.
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /**
102     * @dev Gets the balance of the specified address.
103     * @param _owner The address to query the the balance of.
104     * @return An uint256 representing the amount owned by the passed address.
105     */
106     function balanceOf(address _owner) public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110 }
111 
112 // File: contracts/OpenZeppelin/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120     event Burn(address indexed burner, uint256 value);
121 
122     /**
123      * @dev Burns a specific amount of tokens.
124      * @param _value The amount of token to be burned.
125      */
126     function burn(uint256 _value) public {
127         require(_value <= balances[msg.sender]);
128         // no need to require value <= totalSupply, since that would imply the
129         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131         address burner = msg.sender;
132         balances[burner] = balances[burner].sub(_value);
133         totalSupply_ = totalSupply_.sub(_value);
134         Burn(burner, _value);
135         Transfer(burner, address(0), _value);
136     }
137 }
138 
139 // File: contracts/OpenZeppelin/ERC20.sol
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146     function allowance(address owner, address spender) public view returns (uint256);
147     function transferFrom(address from, address to, uint256 value) public returns (bool);
148     function approve(address spender, uint256 value) public returns (bool);
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 // File: contracts/OpenZeppelin/ERC827.sol
153 
154 /**
155    @title ERC827 interface, an extension of ERC20 token standard
156    Interface of a ERC827 token, following the ERC20 standard with extra
157    methods to transfer value and data and execute calls in transfers and
158    approvals.
159  */
160 contract ERC827 is ERC20 {
161 
162     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
163     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
164     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
165 
166 }
167 
168 // File: contracts/OpenZeppelin/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179     mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182     /**
183      * @dev Transfer tokens from one address to another
184      * @param _from address The address which you want to send tokens from
185      * @param _to address The address which you want to transfer to
186      * @param _value uint256 the amount of tokens to be transferred
187      */
188     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189         require(_to != address(0));
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202      *
203      * Beware that changing an allowance with this method brings the risk that someone may use both the old
204      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      * @param _spender The address which will spend the funds.
208      * @param _value The amount of tokens to be spent.
209      */
210     function approve(address _spender, uint256 _value) public returns (bool) {
211         allowed[msg.sender][_spender] = _value;
212         Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216     /**
217      * @dev Function to check the amount of tokens that an owner allowed to a spender.
218      * @param _owner address The address which owns the funds.
219      * @param _spender address The address which will spend the funds.
220      * @return A uint256 specifying the amount of tokens still available for the spender.
221      */
222     function allowance(address _owner, address _spender) public view returns (uint256) {
223         return allowed[_owner][_spender];
224     }
225 
226     /**
227      * @dev Increase the amount of tokens that an owner allowed to a spender.
228      *
229      * approve should be called when allowed[_spender] == 0. To increment
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * @param _spender The address which will spend the funds.
234      * @param _addedValue The amount of tokens to increase the allowance by.
235      */
236     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242     /**
243      * @dev Decrease the amount of tokens that an owner allowed to a spender.
244      *
245      * approve should be called when allowed[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253         uint oldValue = allowed[msg.sender][_spender];
254         if (_subtractedValue > oldValue) {
255             allowed[msg.sender][_spender] = 0;
256         } else {
257             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258         }
259         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263 }
264 
265 // File: contracts/OpenZeppelin/ERC827Token.sol
266 
267 /**
268    @title ERC827, an extension of ERC20 token standard
269    Implementation the ERC827, following the ERC20 standard with extra
270    methods to transfer value and data and execute calls in transfers and
271    approvals.
272    Uses OpenZeppelin StandardToken.
273  */
274 contract ERC827Token is ERC827, StandardToken {
275 
276     /**
277        @dev Addition to ERC20 token methods. It allows to
278        approve the transfer of value and execute a call with the sent data.
279        Beware that changing an allowance with this method brings the risk that
280        someone may use both the old and the new allowance by unfortunate
281        transaction ordering. One possible solution to mitigate this race condition
282        is to first reduce the spender's allowance to 0 and set the desired value
283        afterwards:
284        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285        @param _spender The address that will spend the funds.
286        @param _value The amount of tokens to be spent.
287        @param _data ABI-encoded contract call to call `_to` address.
288        @return true if the call function was executed successfully
289      */
290     function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
291         require(_spender != address(this));
292 
293         super.approve(_spender, _value);
294 
295         require(_spender.call(_data));
296 
297         return true;
298     }
299 
300     /**
301        @dev Addition to ERC20 token methods. Transfer tokens to a specified
302        address and execute a call with the sent data on the same transaction
303        @param _to address The address which you want to transfer to
304        @param _value uint256 the amout of tokens to be transfered
305        @param _data ABI-encoded contract call to call `_to` address.
306        @return true if the call function was executed successfully
307      */
308     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
309         require(_to != address(this));
310 
311         super.transfer(_to, _value);
312 
313         require(_to.call(_data));
314         return true;
315     }
316 
317     /**
318        @dev Addition to ERC20 token methods. Transfer tokens from one address to
319        another and make a contract call on the same transaction
320        @param _from The address which you want to send tokens from
321        @param _to The address which you want to transfer to
322        @param _value The amout of tokens to be transferred
323        @param _data ABI-encoded contract call to call `_to` address.
324        @return true if the call function was executed successfully
325      */
326     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
327         require(_to != address(this));
328 
329         super.transferFrom(_from, _to, _value);
330 
331         require(_to.call(_data));
332         return true;
333     }
334 
335     /**
336      * @dev Addition to StandardToken methods. Increase the amount of tokens that
337      * an owner allowed to a spender and execute a call with the sent data.
338      *
339      * approve should be called when allowed[_spender] == 0. To increment
340      * allowed value is better to use this function to avoid 2 calls (and wait until
341      * the first transaction is mined)
342      * From MonolithDAO Token.sol
343      * @param _spender The address which will spend the funds.
344      * @param _addedValue The amount of tokens to increase the allowance by.
345      * @param _data ABI-encoded contract call to call `_spender` address.
346      */
347     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
348         require(_spender != address(this));
349 
350         super.increaseApproval(_spender, _addedValue);
351 
352         require(_spender.call(_data));
353 
354         return true;
355     }
356 
357     /**
358      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
359      * an owner allowed to a spender and execute a call with the sent data.
360      *
361      * approve should be called when allowed[_spender] == 0. To decrement
362      * allowed value is better to use this function to avoid 2 calls (and wait until
363      * the first transaction is mined)
364      * From MonolithDAO Token.sol
365      * @param _spender The address which will spend the funds.
366      * @param _subtractedValue The amount of tokens to decrease the allowance by.
367      * @param _data ABI-encoded contract call to call `_spender` address.
368      */
369     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
370         require(_spender != address(this));
371 
372         super.decreaseApproval(_spender, _subtractedValue);
373 
374         require(_spender.call(_data));
375 
376         return true;
377     }
378 
379 }
380 
381 // File: contracts/OpenZeppelin/Ownable.sol
382 
383 /**
384  * @title Ownable
385  * @dev The Ownable contract has an owner address, and provides basic authorization control
386  * functions, this simplifies the implementation of "user permissions".
387  */
388 contract Ownable {
389     address public owner;
390 
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394 
395     /**
396      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
397      * account.
398      */
399     function Ownable() public {
400         owner = msg.sender;
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         require(msg.sender == owner);
408         _;
409     }
410 
411     /**
412      * @dev Allows the current owner to transfer control of the contract to a newOwner.
413      * @param newOwner The address to transfer ownership to.
414      */
415     function transferOwnership(address newOwner) public onlyOwner {
416         require(newOwner != address(0));
417         OwnershipTransferred(owner, newOwner);
418         owner = newOwner;
419     }
420 
421 }
422 
423 // File: contracts/OpenZeppelin/Pausable.sol
424 
425 /**
426  * @title Pausable
427  * @dev Base contract which allows children to implement an emergency stop mechanism.
428  */
429 contract Pausable is Ownable {
430     event Pause();
431     event Unpause();
432 
433     bool public paused = false;
434 
435 
436     /**
437      * @dev Modifier to make a function callable only when the contract is not paused.
438      */
439     modifier whenNotPaused() {
440         require(!paused);
441         _;
442     }
443 
444     /**
445      * @dev Modifier to make a function callable only when the contract is paused.
446      */
447     modifier whenPaused() {
448         require(paused);
449         _;
450     }
451 
452     /**
453      * @dev called by the owner to pause, triggers stopped state
454      */
455     function pause() onlyOwner whenNotPaused public {
456         paused = true;
457         Pause();
458     }
459 
460     /**
461      * @dev called by the owner to unpause, returns to normal state
462      */
463     function unpause() onlyOwner whenPaused public {
464         paused = false;
465         Unpause();
466     }
467 }
468 
469 // File: contracts/OpenZeppelin/PausableToken.sol
470 
471 /**
472  * @title Pausable token
473  * @dev StandardToken modified with pausable transfers.
474  **/
475 contract PausableToken is StandardToken, Pausable {
476 
477     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
478         return super.transfer(_to, _value);
479     }
480 
481     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
482         return super.transferFrom(_from, _to, _value);
483     }
484 
485     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
486         return super.approve(_spender, _value);
487     }
488 
489     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
490         return super.increaseApproval(_spender, _addedValue);
491     }
492 
493     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
494         return super.decreaseApproval(_spender, _subtractedValue);
495     }
496 }
497 
498 // File: contracts/PausableERC827Token.sol
499 
500 /**
501  * @title Pausable ERC827 token
502  * @dev ERC827 token modified with pausable functions.
503  **/
504 contract PausableERC827Token is ERC827Token, PausableToken {
505 
506     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
507         return super.transfer(_to, _value, _data);
508     }
509 
510     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
511         return super.transferFrom(_from, _to, _value, _data);
512     }
513 
514     function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
515         return super.approve(_spender, _value, _data);
516     }
517 
518     function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {
519         return super.increaseApproval(_spender, _addedValue, _data);
520     }
521 
522     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {
523         return super.decreaseApproval(_spender, _subtractedValue, _data);
524     }
525 }
526 
527 // File: contracts/BerryToken.sol
528 
529 contract BerryToken is PausableERC827Token, BurnableToken {
530 
531     string public constant name = "Berry";
532     string public constant symbol = "BERRY";
533     uint32 public constant decimals = 14;
534 
535     function BerryToken() public {
536         totalSupply_ = 400000000E14;
537         balances[owner] = totalSupply_; // Add all tokens to issuer balance (crowdsale in this case)
538     }
539 
540 }