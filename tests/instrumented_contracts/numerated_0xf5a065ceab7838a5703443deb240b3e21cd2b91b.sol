1 pragma solidity ^0.5.7;
2 
3 
4 
5 /**
6  * @title Standard ERC20 token
7  *
8  * @dev Implementation of the basic standard token.
9  * https://eips.ethereum.org/EIPS/eip-20
10  * Originally based on code by FirstBlood:
11  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
12  *
13  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
14  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
15  * compliant implementations may not do it.
16  */
17 
18 
19 
20  contract Ownable {
21      address private _owner;
22 
23      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25      /**
26       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27       * account.
28       */
29      constructor () internal {
30          _owner = msg.sender;
31          emit OwnershipTransferred(address(0), _owner);
32      }
33 
34      /**
35       * @return the address of the owner.
36       */
37      function owner() public view returns (address) {
38          return _owner;
39      }
40 
41      /**
42       * @dev Throws if called by any account other than the owner.
43       */
44      modifier onlyOwner() {
45          require(isOwner());
46          _;
47      }
48 
49      /**
50       * @return true if `msg.sender` is the owner of the contract.
51       */
52      function isOwner() public view returns (bool) {
53          return msg.sender == _owner;
54      }
55 
56      /**
57       * @dev Allows the current owner to relinquish control of the contract.
58       * It will not be possible to call the functions with the `onlyOwner`
59       * modifier anymore.
60       * @notice Renouncing ownership will leave the contract without an owner,
61       * thereby removing any functionality that is only available to the owner.
62       */
63      function renounceOwnership() public onlyOwner {
64          emit OwnershipTransferred(_owner, address(0));
65          _owner = address(0);
66      }
67 
68      /**
69       * @dev Allows the current owner to transfer control of the contract to a newOwner.
70       * @param newOwner The address to transfer ownership to.
71       */
72      function transferOwnership(address newOwner) public onlyOwner {
73          _transferOwnership(newOwner);
74      }
75 
76      /**
77       * @dev Transfers control of the contract to a newOwner.
78       * @param newOwner The address to transfer ownership to.
79       */
80      function _transferOwnership(address newOwner) internal {
81          require(newOwner != address(0));
82          emit OwnershipTransferred(_owner, newOwner);
83          _owner = newOwner;
84      }
85  }
86 
87 
88 
89  contract Pausable is Ownable {
90    event Pause();
91    event Unpause();
92 
93    bool public paused = false;
94 
95 
96    /**
97     * @dev Modifier to make a function callable only when the contract is not paused.
98     */
99    modifier whenNotPaused() {
100      require(!paused);
101      _;
102    }
103 
104    /**
105     * @dev Modifier to make a function callable only when the contract is paused.
106     */
107    modifier whenPaused() {
108      require(paused);
109      _;
110    }
111 
112    /**
113     * @dev called by the owner to pause, triggers stopped state
114     */
115    function pause() onlyOwner whenNotPaused public {
116      paused = true;
117      emit Pause();
118    }
119 
120    /**
121     * @dev called by the owner to unpause, returns to normal state
122     */
123    function unpause() onlyOwner whenPaused public {
124      paused = false;
125      emit Unpause();
126    }
127  }
128 
129 
130 contract IERC20 {
131     function transfer(address to, uint256 value) external returns (bool);
132 
133     function approve(address spender, uint256 value) external returns (bool);
134 
135     function transferFrom(address from, address to, uint256 value) external returns (bool);
136 
137     function totalSupply() external view returns (uint256);
138 
139     function balanceOf(address who) external view returns (uint256);
140 
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 contract ERC20 is IERC20 {
149     using SafeMath for uint256;
150 
151     mapping (address => uint256) public _balances;
152 
153     mapping (address => mapping (address => uint256)) private _allowed;
154 
155     uint256 public totalSupply;
156 
157 
158     /**
159      * @dev Gets the balance of the specified address.
160      * @param owner The address to query the balance of.
161      * @return A uint256 representing the amount owned by the passed address.
162      */
163     function balanceOf(address owner) public view returns (uint256) {
164         return _balances[owner];
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param owner address The address which owns the funds.
170      * @param spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address owner, address spender) public view returns (uint256) {
174         return _allowed[owner][spender];
175     }
176 
177     /**
178      * @dev Transfer token to a specified address
179      * @param to The address to transfer to.
180      * @param value The amount to be transferred.
181      */
182     function transfer(address to, uint256 value) public returns (bool) {
183         _transfer(msg.sender, to, value);
184         return true;
185     }
186 
187     /**
188      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param spender The address which will spend the funds.
194      * @param value The amount of tokens to be spent.
195      */
196     function approve(address spender, uint256 value) public returns (bool) {
197         _approve(msg.sender, spender, value);
198         return true;
199     }
200 
201     /**
202      * @dev Transfer tokens from one address to another.
203      * Note that while this function emits an Approval event, this is not required as per the specification,
204      * and other compliant implementations may not emit the event.
205      * @param from address The address which you want to send tokens from
206      * @param to address The address which you want to transfer to
207      * @param value uint256 the amount of tokens to be transferred
208      */
209     function transferFrom(address from, address to, uint256 value) public returns (bool) {
210         _transfer(from, to, value);
211         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
212         return true;
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * Emits an Approval event.
222      * @param spender The address which will spend the funds.
223      * @param addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
226         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
227         return true;
228     }
229 
230     /**
231      * @dev Decrease the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param subtractedValue The amount of tokens to decrease the allowance by.
239      */
240     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Transfer token for a specified addresses
247      * @param from The address to transfer from.
248      * @param to The address to transfer to.
249      * @param value The amount to be transferred.
250      */
251     function _transfer(address from, address to, uint256 value) internal {
252         require(to != address(0));
253 
254         _balances[from] = _balances[from].sub(value);
255         _balances[to] = _balances[to].add(value);
256         emit Transfer(from, to, value);
257     }
258 
259     /**
260      * @dev Internal function that mints an amount of the token and assigns it to
261      * an account. This encapsulates the modification of balances such that the
262      * proper events are emitted.
263      * @param account The account that will receive the created tokens.
264      * @param value The amount that will be created.
265      */
266     function _mint(address account, uint256 value) internal {
267         require(account != address(0));
268 
269         totalSupply = totalSupply.add(value);
270         _balances[account] = _balances[account].add(value);
271         emit Transfer(address(0), account, value);
272     }
273 
274     /**
275      * @dev Internal function that burns an amount of the token of a given
276      * account.
277      * @param account The account whose tokens will be burnt.
278      * @param value The amount that will be burnt.
279      */
280     function _burn(address account, uint256 value) internal {
281         require(account != address(0));
282 
283         totalSupply = totalSupply.sub(value);
284         _balances[account] = _balances[account].sub(value);
285         emit Transfer(account, address(0), value);
286     }
287 
288     /**
289      * @dev Approve an address to spend another addresses' tokens.
290      * @param owner The address that owns the tokens.
291      * @param spender The address that will spend the tokens.
292      * @param value The number of tokens that can be spent.
293      */
294     function _approve(address owner, address spender, uint256 value) internal {
295         require(spender != address(0));
296         require(owner != address(0));
297 
298         _allowed[owner][spender] = value;
299         emit Approval(owner, spender, value);
300     }
301 
302     /**
303      * @dev Internal function that burns an amount of the token of a given
304      * account, deducting from the sender's allowance for said account. Uses the
305      * internal burn function.
306      * Emits an Approval event (reflecting the reduced allowance).
307      * @param account The account whose tokens will be burnt.
308      * @param value The amount that will be burnt.
309      */
310     function _burnFrom(address account, uint256 value) internal {
311         _burn(account, value);
312         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
313     }
314 
315 }
316 
317 
318 
319 
320 contract ERC20Pausable is ERC20, Pausable {
321     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
322         return super.transfer(to, value);
323     }
324 
325     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
326         return super.transferFrom(from, to, value);
327     }
328 
329     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
330         return super.approve(spender, value);
331     }
332 
333     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
334         return super.increaseAllowance(spender, addedValue);
335     }
336 
337     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
338         return super.decreaseAllowance(spender, subtractedValue);
339     }
340 }
341 
342 
343 
344 
345 
346 
347 contract SRVcontract is Pausable {
348   using SafeMath for uint256;
349 
350   mapping(address => uint256) _balances;
351 
352   mapping (address => mapping (address => uint256)) internal allowed;
353 
354   // the token being sold
355   SRVToken public token;
356   uint256 constant public tokenDecimals = 18;
357 
358   // totalSupply
359   uint256 public totalSupply = 1500000000 * (10 ** uint256(tokenDecimals));
360 
361   // to send tokens to
362   address constant public walletOriginal = 0x4DaD1DD22a3fD0dDBf873f8846925ceC4661f563;
363 
364 
365 
366   constructor () public {
367 
368     token = createTokenContract();
369     token.unpause();
370     token.transfer(walletOriginal, totalSupply);
371 
372 
373 
374   }
375 
376 
377 
378   //
379   // Token related operations
380   //
381 
382   // creates the token to be sold.
383   // override this method to have crowdsale of a specific mintable token.
384   function createTokenContract() internal returns (SRVToken) {
385     return new SRVToken();
386   }
387 
388   // enable token transferability
389   function enableTokenTransferability() external onlyOwner {
390     token.unpause();
391   }
392 
393   // disable token transferability
394   function disableTokenTransferability() external onlyOwner {
395     token.pause();
396   }
397 
398 
399 }
400 
401 
402 
403 
404 
405 contract SRVToken is ERC20Pausable {
406   string constant public name = "SRV";
407   string constant public symbol = "SRV";
408   uint256 constant public decimals = 18;
409   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
410   uint256 constant INITIAL_SUPPLY = 1500000000 * TOKEN_UNIT;
411 
412 
413   constructor () public {
414     // Set untransferable by default to the token
415     paused = true;
416     // asign all tokens to the contract creator
417     totalSupply = INITIAL_SUPPLY;
418 
419     _balances[msg.sender] = INITIAL_SUPPLY;
420   }
421 
422 }
423 
424 
425 
426 library SafeMath {
427     /**
428     * @dev Multiplies two unsigned integers, reverts on overflow.
429     */
430     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
431         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
432         // benefit is lost if 'b' is also tested.
433         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
434         if (a == 0) {
435             return 0;
436         }
437 
438         uint256 c = a * b;
439         require(c / a == b);
440 
441         return c;
442     }
443 
444     /**
445     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
446     */
447     function div(uint256 a, uint256 b) internal pure returns (uint256) {
448         // Solidity only automatically asserts when dividing by 0
449         require(b > 0);
450         uint256 c = a / b;
451         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
452 
453         return c;
454     }
455 
456     /**
457     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
458     */
459     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
460         require(b <= a);
461         uint256 c = a - b;
462 
463         return c;
464     }
465 
466     /**
467     * @dev Adds two unsigned integers, reverts on overflow.
468     */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a);
472 
473         return c;
474     }
475 
476     /**
477     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
478     * reverts when dividing by zero.
479     */
480     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
481         require(b != 0);
482         return a % b;
483     }
484 }