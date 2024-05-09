1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b > 0); // Solidity only automatically asserts when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two numbers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender)
77         external view returns (uint256);
78 
79     function transfer(address to, uint256 value) external returns (bool);
80 
81     function approve(address spender, uint256 value)
82         external returns (bool);
83 
84     function transferFrom(address from, address to, uint256 value)
85         external returns (bool);
86 
87     event Transfer(
88         address indexed from,
89         address indexed to,
90         uint256 value
91     );
92 
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping (address => uint256) private _balances;
110 
111     mapping (address => mapping (address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116      * @dev Fix for the ERC20 short address attack. BiMoney
117      */
118     modifier onlyPayloadSize(uint size) {
119         require(msg.data.length >= size + 4);
120         _;
121     }
122 
123     /**
124     * @dev Total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     * @param owner The address to query the balance of.
133     * @return An uint256 representing the amount owned by the passed address.
134     */
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param owner address The address which owns the funds.
142      * @param spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(
146         address owner,
147         address spender
148      )
149         public
150         view
151         returns (uint256)
152     {
153         return _allowed[owner][spender];
154     }
155 
156     /**
157     * @dev Transfer token for a specified address
158     * @param to The address to transfer to.
159     * @param value The amount to be transferred.
160     */
161     function transfer(address to, uint256 value) public onlyPayloadSize(2 * 32) returns (bool) {
162         require(value <= _balances[msg.sender]);
163         require(to != address(0));
164 
165         _balances[msg.sender] = _balances[msg.sender].sub(value);
166         _balances[to] = _balances[to].add(value);
167         emit Transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param spender The address which will spend the funds.
178      * @param value The amount of tokens to be spent.
179      */
180     function approve(address spender, uint256 value) public returns (bool) {
181         require(spender != address(0));
182         // avoid race condition
183         require((value == 0) || (_allowed[msg.sender][spender] == 0));
184 
185         _allowed[msg.sender][spender] = value;
186         emit Approval(msg.sender, spender, value);
187         return true;
188     }
189 
190     /**
191      * @dev Transfer tokens from one address to another
192      * @param from address The address which you want to send tokens from
193      * @param to address The address which you want to transfer to
194      * @param value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 value
200     )
201         public onlyPayloadSize(3 * 32)
202         returns (bool)
203     {
204         require(value <= _balances[from]);
205         require(value <= _allowed[from][msg.sender]);
206         require(to != address(0));
207 
208         _balances[from] = _balances[from].sub(value);
209         _balances[to] = _balances[to].add(value);
210         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
211         emit Transfer(from, to, value);
212         return true;
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      * approve should be called when allowed_[_spender] == 0. To increment
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * @param spender The address which will spend the funds.
222      * @param addedValue The amount of tokens to increase the allowance by.
223      */
224     function increaseAllowance(
225         address spender,
226         uint256 addedValue
227     )
228         public
229         returns (bool)
230     {
231         require(spender != address(0));
232 
233         _allowed[msg.sender][spender] = (
234             _allowed[msg.sender][spender].add(addedValue));
235         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236         return true;
237     }
238 
239     /**
240      * @dev Decrease the amount of tokens that an owner allowed to a spender.
241      * approve should be called when allowed_[_spender] == 0. To decrement
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param spender The address which will spend the funds.
246      * @param subtractedValue The amount of tokens to decrease the allowance by.
247      */
248     function decreaseAllowance(
249         address spender,
250         uint256 subtractedValue
251     )
252         public
253         returns (bool)
254     {
255         require(spender != address(0));
256 
257         _allowed[msg.sender][spender] = (
258             _allowed[msg.sender][spender].sub(subtractedValue));
259         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
260         return true;
261     }
262 
263     /**
264      * @dev Internal function that mints an amount of the token and assigns it to
265      * an account. This encapsulates the modification of balances such that the
266      * proper events are emitted.
267      * @param account The account that will receive the created tokens.
268      * @param amount The amount that will be created.
269      */
270     function _mint(address account, uint256 amount) internal {
271         require(account != 0);
272         _totalSupply = _totalSupply.add(amount);
273         _balances[account] = _balances[account].add(amount);
274         emit Transfer(address(0), account, amount);
275     }
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account.
280      * @param account The account whose tokens will be burnt.
281      * @param amount The amount that will be burnt.
282      */
283     function _burn(address account, uint256 amount) internal {
284         require(account != 0);
285         require(amount <= _balances[account]);
286 
287         _totalSupply = _totalSupply.sub(amount);
288         _balances[account] = _balances[account].sub(amount);
289         emit Transfer(account, address(0), amount);
290     }
291 
292 }
293 
294 /**
295  * @title Ownable
296  * @dev The Ownable contract has an owner address, and provides basic authorization control
297  * functions, this simplifies the implementation of "user permissions".
298  */
299 contract Ownable {
300     address private _owner;
301 
302     event OwnershipTransferred(
303         address indexed previousOwner,
304         address indexed newOwner
305     );
306 
307     /**
308      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
309      * account.
310      */
311     constructor() public {
312         _owner = msg.sender;
313     }
314 
315     /**
316      * @return the address of the owner.
317      */
318     function owner() public view returns(address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if called by any account other than the owner.
324      */
325     modifier onlyOwner() {
326         require(isOwner());
327         _;
328     }
329 
330     /**
331      * @return true if `msg.sender` is the owner of the contract.
332      */
333     function isOwner() public view returns(bool) {
334         return msg.sender == _owner;
335     }
336 
337     /**
338      * @dev Allows the current owner to transfer control of the contract to a newOwner.
339      * @param newOwner The address to transfer ownership to.
340      */
341     function transferOwnership(address newOwner) public onlyOwner {
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers control of the contract to a newOwner.
347      * @param newOwner The address to transfer ownership to.
348      */
349     function _transferOwnership(address newOwner) internal {
350         require(newOwner != address(0));
351         emit OwnershipTransferred(_owner, newOwner);
352         _owner = newOwner;
353     }
354 }
355 
356 /**
357  * @title Pausable
358  * @dev Base contract which allows children to implement an emergency stop mechanism.
359  */
360 contract Pausable is Ownable {
361     event Paused();
362     event Unpaused();
363 
364     bool private _paused = false;
365 
366     /**
367      * @return true if the contract is paused, false otherwise.
368      */
369     function paused() public view returns(bool) {
370         return _paused;
371     }
372 
373     /**
374      * @dev Modifier to make a function callable only when the contract is not paused.
375      */
376     modifier whenNotPaused() {
377         require(!_paused);
378         _;
379     }
380 
381     /**
382      * @dev Modifier to make a function callable only when the contract is paused.
383      */
384     modifier whenPaused() {
385         require(_paused);
386         _;
387     }
388 
389     /**
390      * @dev called by the owner to pause, triggers stopped state
391      */
392     function pause() public onlyOwner whenNotPaused {
393         _paused = true;
394         emit Paused();
395     }
396 
397     /**
398      * @dev called by the owner to unpause, returns to normal state
399      */
400     function unpause() public onlyOwner whenPaused {
401         _paused = false;
402         emit Unpaused();
403     }
404 }
405 
406 contract ERC20Pausable is ERC20, Pausable {
407 
408     function transfer(
409         address to,
410         uint256 value
411     )
412         public
413         whenNotPaused
414         returns (bool)
415     {
416         return super.transfer(to, value);
417     }
418 
419     function transferFrom(
420         address from,
421         address to,
422         uint256 value
423     )
424         public
425         whenNotPaused
426         returns (bool)
427     {
428         return super.transferFrom(from, to, value);
429     }
430 
431     function approve(
432         address spender,
433         uint256 value
434     )
435         public
436         whenNotPaused
437         returns (bool)
438     {
439         return super.approve(spender, value);
440     }
441 
442     function increaseAllowance(
443         address spender,
444         uint addedValue
445     )
446         public
447         whenNotPaused
448         returns (bool success)
449     {
450         return super.increaseAllowance(spender, addedValue);
451     }
452 
453     function decreaseAllowance(
454         address spender,
455         uint subtractedValue
456     )
457         public
458         whenNotPaused
459         returns (bool success)
460     {
461         return super.decreaseAllowance(spender, subtractedValue);
462     }
463 }
464 
465 /**
466  * @title Burnable Token
467  * @dev Token that can be irreversibly burned (destroyed).
468  */
469 contract ERC20Burnable is ERC20, Ownable {
470 
471     /**
472      * @dev Burns a specific amount of tokens.
473      * @param value The amount of token to be burned.
474      */
475     function burn(uint256 value) public onlyOwner {
476         _burn(msg.sender, value);
477     }
478 
479     /**
480      * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
481      * an additional Burn event.
482      */
483     function _burn(address who, uint256 value) internal {
484         super._burn(who, value);
485     }
486 }
487 
488 /**
489  * @title BMToken
490  * @dev BiMoney Token contract
491  */
492 contract BMToken is ERC20Pausable, ERC20Burnable {
493     using SafeMath for uint256;
494 
495     string public name = "BiMoney";
496     string public symbol = "BM";
497     uint256 public decimals = 18;
498     
499     constructor(uint256 initialSupply, string tokenName, uint256 decimalUnits, string tokenSymbol ) public {
500         name = tokenName;                   // Set the name for display purposes
501         symbol = tokenSymbol;               // Set the symbol for display purposes
502         decimals = decimalUnits;            // Amount of decimals for display purposes
503         _mint(msg.sender, initialSupply);   // Give the creator all initial tokens
504     }
505 }