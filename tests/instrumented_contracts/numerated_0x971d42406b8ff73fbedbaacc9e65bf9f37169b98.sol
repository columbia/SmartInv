1 // File: contracts/IERC20.sol
2 
3 // solium-disable linebreak-style
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11 
12   function totalSupply() external view returns (uint256);
13 
14   function balanceOf(address who) external view returns (uint256);
15 
16   function allowance(address owner, address spender)
17     external view returns (uint256);
18 
19   function transfer(address to, uint256 value) external returns (bool);
20 
21   function approve(address spender, uint256 value)
22     external returns (bool);
23 
24   function transferFrom(address from, address to, uint256 value)
25     external returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 // File: contracts/SafeMath.sol
41 
42 // solium-disable linebreak-style
43 pragma solidity ^0.5.0;
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that revert on error
48  */
49 library SafeMath {
50 
51     /**
52     * @dev Multiplies two numbers, reverts on overflow.
53     */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59             return 0;
60         }
61 
62         uint256 c = a * b;
63         require(c / a == b);
64 
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b > 0); // Solidity only automatically asserts when dividing by 0
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81     */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90     * @dev Adds two numbers, reverts on overflow.
91     */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a);
95 
96         return c;
97     }
98 
99     /**
100     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
101     * reverts when dividing by zero.
102     */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0);
105         return a % b;
106     }
107 }
108 
109 // File: contracts/ERC20.sol
110 
111 // solium-disable linebreak-style
112 pragma solidity ^0.5.0;
113 
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
121  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract ERC20 is IERC20 {
124     using SafeMath for uint256;
125 
126     mapping (address => uint256) internal _balances;
127 
128     mapping (address => mapping (address => uint256)) internal _allowed;
129 
130     uint256 internal _totalSupply;
131 
132     /**
133     * @dev Total number of tokens in existence
134     */
135     function totalSupply() public view returns (uint256) {
136         return _totalSupply;
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param owner The address to query the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function balanceOf(address owner) public view returns (uint256) {
145         return _balances[owner];
146     }
147 
148     /**
149     * @dev Function to check the amount of tokens that an owner allowed to a spender.
150     * @param owner address The address which owns the funds.
151     * @param spender address The address which will spend the funds.
152     * @return A uint256 specifying the amount of tokens still available for the spender.
153     */
154     function allowance(
155         address owner,
156         address spender
157     )
158       public
159       view
160       returns (uint256)
161     {
162         return _allowed[owner][spender];
163     }
164 
165     /**
166     * @dev Transfer token for a specified address
167     * @param to The address to transfer to.
168     * @param value The amount to be transferred.
169     */
170     function transfer(address to, uint256 value) public returns (bool) {
171         _transfer(msg.sender, to, value);
172         return true;
173     }
174 
175     /**
176     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177     * Beware that changing an allowance with this method brings the risk that someone may use both the old
178     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181     * @param spender The address which will spend the funds.
182     * @param value The amount of tokens to be spent.
183     */
184     function approve(address spender, uint256 value) public returns (bool) {
185         require(spender != address(0));
186 
187         _allowed[msg.sender][spender] = value;
188         emit Approval(msg.sender, spender, value);
189         return true;
190     }
191 
192     /**
193     * @dev Transfer tokens from one address to another
194     * @param from address The address which you want to send tokens from
195     * @param to address The address which you want to transfer to
196     * @param value uint256 the amount of tokens to be transferred
197     */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 value
202     )
203       public
204       returns (bool)
205     {
206         require(value <= _allowed[from][msg.sender]);
207 
208         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
209         _transfer(from, to, value);
210         return true;
211     }
212 
213     /**
214     * @dev Increase the amount of tokens that an owner allowed to a spender.
215     * approve should be called when allowed_[_spender] == 0. To increment
216     * allowed value is better to use this function to avoid 2 calls (and wait until
217     * the first transaction is mined)
218     * From MonolithDAO Token.sol
219     * @param spender The address which will spend the funds.
220     * @param addedValue The amount of tokens to increase the allowance by.
221     */
222     function increaseAllowance(
223         address spender,
224         uint256 addedValue
225     )
226       public
227       returns (bool)
228     {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
232         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233         return true;
234     }
235 
236     /**
237     * @dev Decrease the amount of tokens that an owner allowed to a spender.
238     * approve should be called when allowed_[_spender] == 0. To decrement
239     * allowed value is better to use this function to avoid 2 calls (and wait until
240     * the first transaction is mined)
241     * From MonolithDAO Token.sol
242     * @param spender The address which will spend the funds.
243     * @param subtractedValue The amount of tokens to decrease the allowance by.
244     */
245     function decreaseAllowance(
246         address spender,
247         uint256 subtractedValue
248     )
249       public
250       returns (bool)
251     {
252         require(spender != address(0));
253 
254         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
255         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
256         return true;
257     }
258 
259     /**
260     * @dev Transfer token for a specified addresses
261     * @param from The address to transfer from.
262     * @param to The address to transfer to.
263     * @param value The amount to be transferred.
264     */
265     function _transfer(address from, address to, uint256 value) internal {
266         require(value <= _balances[from]);
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273   
274 }
275 
276 // File: contracts/ERC20Burnable.sol
277 
278 // solium-disable linebreak-style
279 pragma solidity ^0.5.0;
280 
281 
282 /**
283  * @title Burnable Token
284  * @dev Token that can be irreversibly burned (destroyed).
285  */
286 contract ERC20Burnable is ERC20 {
287     /**
288     * @dev Internal function that burns an amount of the token of a given
289     * account.
290     * @param account The account whose tokens will be burnt.
291     * @param value The amount that will be burnt.
292     */
293     function _burn(address account, uint256 value) internal {
294         require(account != address(0));
295         require(value <= _balances[account]);
296 
297         _totalSupply = _totalSupply.sub(value);
298         _balances[account] = _balances[account].sub(value);
299         emit Transfer(account, address(0), value);
300         emit Burn(account, msg.sender, value);
301     }
302 
303     event Burn(address indexed from, address indexed burner, uint256 value);
304 }
305 
306 // File: contracts/ERC20Mintable.sol
307 
308 // solium-disable linebreak-style
309 pragma solidity ^0.5.0;
310 
311 
312 /**
313  * @title ERC20Mintable
314  * @dev ERC20 minting logic
315  */
316 contract ERC20Mintable is ERC20 {
317     
318     /**
319     * @dev Internal function that mints an amount of the token and assigns it to
320     * an account. This encapsulates the modification of balances such that the
321     * proper events are emitted.
322     * @param account The account that will receive the created tokens.
323     * @param value The amount that will be created.
324     */
325     function _mint(address account, uint256 value) internal {
326         require(account != address(0));
327         _totalSupply = _totalSupply.add(value);
328         _balances[account] = _balances[account].add(value);
329         emit Transfer(address(0), account, value);
330         emit Mint(account, msg.sender, value);
331     }
332 
333     event Mint(address indexed to, address indexed minter, uint256 value);
334 }
335 
336 // File: contracts/TokenDetails.sol
337 
338 // solium-disable linebreak-style
339 pragma solidity ^0.5.0;
340 
341 
342 contract TokenDetails {
343 
344     string internal _name;
345     string internal _symbol;
346     
347     /**
348     * @return the name of the token.
349     */
350     function name() public view returns(string memory) {
351         return _name;
352     }
353 
354     /**
355     * @return the symbol of the token.
356     */
357     function symbol() public view returns(string memory) {
358         return _symbol;
359     }
360 
361 }
362 
363 // File: contracts/ERC20Details.sol
364 
365 // solium-disable linebreak-style
366 pragma solidity ^0.5.0;
367 
368 
369 contract ERC20Details is TokenDetails {
370 
371     uint8 internal _decimals;
372 
373     /**
374     * @return the number of decimals of the token.
375     */
376     function decimals() public view returns(uint8) {
377         return _decimals;
378     }
379 
380 }
381 
382 // File: contracts/Ownable.sol
383 
384 // solium-disable linebreak-style
385 pragma solidity ^0.5.0;
386 
387 /**
388  * @title Ownable
389  * @dev The Ownable contract has an owner address, and provides basic authorization control
390  * functions, this simplifies the implementation of "user permissions".
391  */
392 contract Ownable {
393     address private _owner;
394 
395     event OwnershipTransferred(
396         address indexed previousOwner,
397         address indexed newOwner
398     );
399 
400     /**
401     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
402     * account.
403     */
404     constructor() internal {
405         _owner = msg.sender;
406         emit OwnershipTransferred(address(0), _owner);
407     }
408 
409     /**
410     * @return the address of the owner.
411     */
412     function owner() public view returns(address) {
413         return _owner;
414     }
415 
416     /**
417     * @dev Throws if called by any account other than the owner.
418     */
419     modifier onlyOwner() {
420         require(isOwner());
421         _;
422     }
423 
424     /**
425     * @return true if `msg.sender` is the owner of the contract.
426     */
427     function isOwner() public view returns(bool) {
428         return msg.sender == _owner;
429     }
430 
431     /**
432     * @dev Allows the current owner to relinquish control of the contract.
433     * @notice Renouncing to ownership will leave the contract without an owner.
434     * It will not be possible to call the functions with the `onlyOwner`
435     * modifier anymore.
436     */
437     function renounceOwnership() public onlyOwner {
438         emit OwnershipTransferred(_owner, address(0));
439         _owner = address(0);
440     }
441 
442     /**
443     * @dev Allows the current owner to transfer control of the contract to a newOwner.
444     * @param newOwner The address to transfer ownership to.
445     */
446     function transferOwnership(address newOwner) public onlyOwner {
447         _transferOwnership(newOwner);
448     }
449 
450     /**
451     * @dev Transfers control of the contract to a newOwner.
452     * @param newOwner The address to transfer ownership to.
453     */
454     function _transferOwnership(address newOwner) internal {
455         require(newOwner != address(0));
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 }
460 
461 // File: contracts\AoraCoin.sol
462 
463 // solium-disable linebreak-style
464 pragma solidity ^0.5.0;
465 
466 
467 
468 
469 
470 contract AoraCoin is ERC20Burnable, ERC20Mintable, ERC20Details, Ownable {
471     constructor () public {
472         _decimals = 18;
473         _name = "AORA COIN";
474         _symbol = "AORA";
475         _totalSupply = 650000000 ether; // TODO: Check
476         _balances[msg.sender] = _totalSupply;
477     }
478 
479     function burn(uint value) public onlyOwner {
480         _burn(msg.sender, value);
481     }
482 
483     function mint(address to, uint value) public onlyOwner { 
484         _mint(to, value);
485     }
486 
487     function claimTokens(address _token) public onlyOwner {
488         address payable owner = address(uint160(owner()));
489         
490         if (_token == address(0)) {
491             owner.transfer(address(this).balance);
492             return;
493         }
494 
495         IERC20 token = IERC20(_token);
496         uint balance = token.balanceOf(address(this));
497         token.transfer(owner, balance);
498         emit ClaimedTokens(_token, owner, balance);
499     }
500 
501     // Emitted when calimTokens function is invoked.
502     event ClaimedTokens(address tokenAddress, address ownerAddress, uint amount);
503 }