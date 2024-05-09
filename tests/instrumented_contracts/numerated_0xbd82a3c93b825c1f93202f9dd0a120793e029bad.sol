1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'SCU' 'Space.Cloud.Unit Token' token contract
5 //
6 // Symbol      : SCU
7 // Name        : Space.Cloud.Unit
8 // Total supply: 150,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // (c) openzepplin / Smart Contract Solutions, Inc 2016. The MIT Licence.
12 // (c) C.Sprajc / SCU GmbH 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 /*
16 import "../openzepplin/contracts/math/SafeMath.sol";
17 import "../openzepplin/contracts/ownership/Ownable.sol";
18 import "../openzepplin/contracts/token/ERC20/DetailedERC20.sol";
19 import "../openzepplin/contracts/token/ERC20/PausableToken.sol";
20 import "../openzepplin/contracts/token/ERC20/CappedToken.sol";
21 import "../openzepplin/contracts/token/ERC20/BurnableToken.sol";*/
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30     /**
31     * @dev Multiplies two numbers, throws on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         c = a * b;
42         assert(c / a == b);
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers, truncating the quotient.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         // uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return a / b;
54     }
55 
56     /**
57     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     /**
65     * @dev Adds two numbers, throws on overflow.
66     */
67     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68         c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     address public owner;
81 
82     event OwnershipTransferred(
83         address indexed previousOwner,
84         address indexed newOwner
85     );
86 
87 
88     /**
89      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
90      * account.
91      */
92     constructor() public {
93         owner = msg.sender;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     /**
105      * @dev Allows the current owner to transfer control of the contract to a newOwner.
106      * @param _newOwner The address to transfer ownership to.
107      */
108     function transferOwnership(address _newOwner) public onlyOwner {
109         _transferOwnership(_newOwner);
110     }
111 
112     /**
113      * @dev Transfers control of the contract to a newOwner.
114      * @param _newOwner The address to transfer ownership to.
115      */
116     function _transferOwnership(address _newOwner) internal {
117         require(_newOwner != address(0));
118         emit OwnershipTransferred(owner, _newOwner);
119         owner = _newOwner;
120     }
121 }
122 
123 /**
124  * @title Pausable
125  * @dev Base contract which allows children to implement an emergency stop mechanism.
126  */
127 contract Pausable is Ownable {
128     event Pause();
129     event Unpause();
130 
131     bool public paused = false;
132 
133     /**
134      * @dev Modifier to make a function callable only when the contract is not paused.
135      */
136     modifier whenNotPaused() {
137         require(!paused || msg.sender == owner);
138         _;
139     }
140 
141     /**
142      * @dev Modifier to make a function callable only when the contract is paused.
143      */
144     modifier whenPaused() {
145         require(paused && msg.sender != owner);
146         _;
147     }
148 
149     /**
150      * @dev called by the owner to pause, triggers stopped state
151      */
152     function pause() onlyOwner public {
153         paused = true;
154         emit Pause();
155     }
156 
157     /**
158      * @dev called by the owner to unpause, returns to normal state
159      */
160     function unpause() onlyOwner public {
161         paused = false;
162         emit Unpause();
163     }
164 }
165 
166 /**
167  * @title ERC20Basic
168  * @dev Simpler version of ERC20 interface
169  * See https://github.com/ethereum/EIPs/issues/179
170  */
171 contract ERC20Basic {
172     function totalSupply() public view returns (uint256);
173     function balanceOf(address who) public view returns (uint256);
174     function transfer(address to, uint256 value) public returns (bool);
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 }
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183     function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186     function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189     function approve(address spender, uint256 value) public returns (bool);
190     event Approval(
191         address indexed owner,
192         address indexed spender,
193         uint256 value
194     );
195 }
196 
197 /**
198  * @title DetailedERC20 token
199  * @dev The decimals are only for visualization purposes.
200  * All the operations are done using the smallest and indivisible token unit,
201  * just as on Ethereum all the operations are done in wei.
202  */
203 contract DetailedERC20 is ERC20 {
204     string public name;
205     string public symbol;
206     uint8 public decimals;
207 
208     constructor() public {
209         // Fields have to be set by child constructor
210     }
211 
212     /*constructor(string _name, string _symbol, uint8 _decimals) public {
213         name = _name;
214         symbol = _symbol;
215         decimals = _decimals;
216     }*/
217 }
218 
219 /**
220  * @title Basic token
221  * @dev Basic version of StandardToken, with no allowances.
222  */
223 contract BasicToken is ERC20Basic {
224     using SafeMath for uint256;
225 
226     mapping(address => uint256) balances;
227 
228     uint256 totalSupply_;
229 
230     /**
231     * @dev Total number of tokens in existence
232     */
233     function totalSupply() public view returns (uint256) {
234         return totalSupply_;
235     }
236 
237     /**
238     * @dev Transfer token for a specified address
239     * @param _to The address to transfer to.
240     * @param _value The amount to be transferred.
241     */
242     function transfer(address _to, uint256 _value) public returns (bool) {
243         require(_to != address(0));
244         require(_value <= balances[msg.sender]);
245 
246         balances[msg.sender] = balances[msg.sender].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         emit Transfer(msg.sender, _to, _value);
249         return true;
250     }
251 
252     /**
253     * @dev Gets the balance of the specified address.
254     * @param _owner The address to query the the balance of.
255     * @return An uint256 representing the amount owned by the passed address.
256     */
257     function balanceOf(address _owner) public view returns (uint256) {
258         return balances[_owner];
259     }
260 }
261 
262 /**
263  * @title Standard ERC20 token
264  *
265  * @dev Implementation of the basic standard token.
266  * https://github.com/ethereum/EIPs/issues/20
267  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
268  */
269 contract StandardToken is ERC20, BasicToken {
270 
271     mapping (address => mapping (address => uint256)) internal allowed;
272 
273 
274     /**
275      * @dev Transfer tokens from one address to another
276      * @param _from address The address which you want to send tokens from
277      * @param _to address The address which you want to transfer to
278      * @param _value uint256 the amount of tokens to be transferred
279      */
280     function transferFrom(
281         address _from,
282         address _to,
283         uint256 _value
284     )
285     public
286     returns (bool)
287     {
288         require(_to != address(0));
289         require(_value <= balances[_from]);
290         require(_value <= allowed[_from][msg.sender]);
291 
292         balances[_from] = balances[_from].sub(_value);
293         balances[_to] = balances[_to].add(_value);
294         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295         emit Transfer(_from, _to, _value);
296         return true;
297     }
298 
299     /**
300      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
301      * Beware that changing an allowance with this method brings the risk that someone may use both the old
302      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
303      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      * @param _spender The address which will spend the funds.
306      * @param _value The amount of tokens to be spent.
307      */
308     function approve(address _spender, uint256 _value) public returns (bool) {
309         allowed[msg.sender][_spender] = _value;
310         emit Approval(msg.sender, _spender, _value);
311         return true;
312     }
313 
314     /**
315      * @dev Function to check the amount of tokens that an owner allowed to a spender.
316      * @param _owner address The address which owns the funds.
317      * @param _spender address The address which will spend the funds.
318      * @return A uint256 specifying the amount of tokens still available for the spender.
319      */
320     function allowance(
321         address _owner,
322         address _spender
323     )
324     public
325     view
326     returns (uint256)
327     {
328         return allowed[_owner][_spender];
329     }
330 
331     /**
332      * @dev Increase the amount of tokens that an owner allowed to a spender.
333      * approve should be called when allowed[_spender] == 0. To increment
334      * allowed value is better to use this function to avoid 2 calls (and wait until
335      * the first transaction is mined)
336      * From MonolithDAO Token.sol
337      * @param _spender The address which will spend the funds.
338      * @param _addedValue The amount of tokens to increase the allowance by.
339      */
340     function increaseApproval(
341         address _spender,
342         uint256 _addedValue
343     )
344     public
345     returns (bool)
346     {
347         allowed[msg.sender][_spender] = (
348         allowed[msg.sender][_spender].add(_addedValue));
349         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350         return true;
351     }
352 
353     /**
354      * @dev Decrease the amount of tokens that an owner allowed to a spender.
355      * approve should be called when allowed[_spender] == 0. To decrement
356      * allowed value is better to use this function to avoid 2 calls (and wait until
357      * the first transaction is mined)
358      * From MonolithDAO Token.sol
359      * @param _spender The address which will spend the funds.
360      * @param _subtractedValue The amount of tokens to decrease the allowance by.
361      */
362     function decreaseApproval(
363         address _spender,
364         uint256 _subtractedValue
365     )
366     public
367     returns (bool)
368     {
369         uint256 oldValue = allowed[msg.sender][_spender];
370         if (_subtractedValue > oldValue) {
371             allowed[msg.sender][_spender] = 0;
372         } else {
373             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374         }
375         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376         return true;
377     }
378 }
379 
380 /**
381  * @title Burnable Token
382  * @dev Token that can be irreversibly burned (destroyed).
383  */
384 contract BurnableToken is BasicToken {
385 
386     event Burn(address indexed burner, uint256 value);
387 
388     /**
389      * @dev Burns a specific amount of tokens.
390      * @param _value The amount of token to be burned.
391      */
392     function burn(uint256 _value) public {
393         _burn(msg.sender, _value);
394     }
395 
396     function _burn(address _who, uint256 _value) internal {
397         require(_value <= balances[_who]);
398         // no need to require value <= totalSupply, since that would imply the
399         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
400 
401         balances[_who] = balances[_who].sub(_value);
402         totalSupply_ = totalSupply_.sub(_value);
403         emit Burn(_who, _value);
404         emit Transfer(_who, address(0), _value);
405     }
406 }
407 
408 /**
409  * @title Mintable token
410  * @dev Simple ERC20 Token example, with mintable token creation
411  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
412  */
413 contract MintableToken is StandardToken, Ownable {
414     event Mint(address indexed to, uint256 amount);
415 
416     /**
417      * @dev Function to mint tokens
418      * @param _to The address that will receive the minted tokens.
419      * @param _amount The amount of tokens to mint.
420      * @return A boolean that indicates if the operation was successful.
421      */
422     function mint(
423         address _to,
424         uint256 _amount
425     )
426     onlyOwner
427     public
428     returns (bool)
429     {
430         totalSupply_ = totalSupply_.add(_amount);
431         balances[_to] = balances[_to].add(_amount);
432         emit Mint(_to, _amount);
433         emit Transfer(address(0), _to, _amount);
434         return true;
435     }
436 }
437 
438 /**
439  * @title Capped token
440  * @dev Mintable token with a token cap.
441  */
442 contract CappedToken is MintableToken {
443 
444     uint256 public cap;
445 
446     constructor() public {
447         // cap is set in child constructor
448     }
449 
450     /** cap is set in child constructor
451     constructor(uint256 _cap) public {
452         require(_cap > 0);
453         cap = _cap;
454     }
455     */
456 
457     /**
458      * @dev Function to mint tokens
459      * @param _to The address that will receive the minted tokens.
460      * @param _amount The amount of tokens to mint.
461      * @return A boolean that indicates if the operation was successful.
462      */
463     function mint(
464         address _to,
465         uint256 _amount
466     )
467     public
468     returns (bool)
469     {
470         require(totalSupply_.add(_amount) <= cap);
471 
472         return super.mint(_to, _amount);
473     }
474 }
475 
476 /**
477  * @title Pausable token
478  * @dev StandardToken modified with pausable transfers.
479  **/
480 contract PausableToken is StandardToken, Pausable {
481 
482     function transfer(
483         address _to,
484         uint256 _value
485     )
486     public
487     whenNotPaused
488     returns (bool)
489     {
490         return super.transfer(_to, _value);
491     }
492 
493     /** Allow transferFrom even if paused. This is for crowdsale contracts
494     function transferFrom(
495         address _from,
496         address _to,
497         uint256 _value
498     )
499     public
500     whenNotPaused
501     returns (bool)
502     {
503         return super.transferFrom(_from, _to, _value);
504     }
505     */
506 
507     function approve(
508         address _spender,
509         uint256 _value
510     )
511     public
512     whenNotPaused
513     returns (bool)
514     {
515         return super.approve(_spender, _value);
516     }
517 
518     function increaseApproval(
519         address _spender,
520         uint _addedValue
521     )
522     public
523     whenNotPaused
524     returns (bool success)
525     {
526         return super.increaseApproval(_spender, _addedValue);
527     }
528 
529     function decreaseApproval(
530         address _spender,
531         uint _subtractedValue
532     )
533     public
534     whenNotPaused
535     returns (bool success)
536     {
537         return super.decreaseApproval(_spender, _subtractedValue);
538     }
539 }
540 
541 
542 
543 contract SCU is StandardToken, DetailedERC20, Ownable, PausableToken, CappedToken, BurnableToken {
544     constructor() public {
545         // DetailedERC20:
546         symbol = "SCU";
547         name = "Space.Cloud.Unit";
548         decimals = 18;
549          // CappedToken:
550         cap = 150000000 * 10**uint(decimals);
551         // BasicToken:
552         totalSupply_ = 0;
553         // StandardToken:
554         // balances[owner] = totalSupply_;
555         // emit Transfer(address(0), owner, totalSupply_);
556     }
557 }