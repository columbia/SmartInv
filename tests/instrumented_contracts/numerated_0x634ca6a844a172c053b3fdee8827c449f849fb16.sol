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
259 
260 
261     /**
262      * @dev Approve an address to spend another addresses' tokens.
263      * @param owner The address that owns the tokens.
264      * @param spender The address that will spend the tokens.
265      * @param value The number of tokens that can be spent.
266      */
267     function _approve(address owner, address spender, uint256 value) internal {
268         require(spender != address(0));
269         require(owner != address(0));
270 
271         _allowed[owner][spender] = value;
272         emit Approval(owner, spender, value);
273     }
274 
275 
276 }
277 
278 
279 
280 
281 contract ERC20Pausable is ERC20, Pausable {
282     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
283         return super.transfer(to, value);
284     }
285 
286     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
287         return super.transferFrom(from, to, value);
288     }
289 
290     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
291         return super.approve(spender, value);
292     }
293 
294     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
295         return super.increaseAllowance(spender, addedValue);
296     }
297 
298     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
299         return super.decreaseAllowance(spender, subtractedValue);
300     }
301 }
302 
303 
304 
305 
306 
307 
308 contract MBTCcontract is Ownable {
309 
310   // the token being sold
311   MBTCToken public token;
312   uint256 constant public tokenDecimals = 18;
313 
314   // totalSupply
315   uint256 public totalSupply = 100000000 * (10 ** uint256(tokenDecimals));
316 
317 
318   constructor () public {
319 
320     token = createTokenContract();
321     token.unpause();
322   }
323 
324 
325 
326 
327 
328   //
329   // Token related operations
330   //
331 
332   // creates the token to be sold.
333   // override this method to have crowdsale of a specific mintable token.
334   function createTokenContract() internal returns (MBTCToken) {
335     return new MBTCToken();
336   }
337 
338   // enable token transferability
339   function enableTokenTransferability() external onlyOwner {
340     token.unpause();
341   }
342 
343   // disable token transferability
344   function disableTokenTransferability() external onlyOwner {
345     token.pause();
346   }
347 
348   // transfer token to designated address
349   function transfer(address to, uint256 value) external onlyOwner returns (bool ok)  {
350     uint256 converterdValue = value * (10 ** uint256(tokenDecimals));
351     return token.transfer(to, converterdValue);
352    }
353 
354 
355 
356 }
357 
358 
359 
360 
361 
362 contract MBTCToken is ERC20Pausable {
363   string constant public name = "Marvelous Business Transaction Coin";
364   string constant public symbol = "MBTC";
365   uint8 constant public decimals = 18;
366   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
367   uint256 constant INITIAL_SUPPLY = 100000000 * TOKEN_UNIT;
368 
369 
370   constructor () public {
371     // Set untransferable by default to the token
372     paused = true;
373     // asign all tokens to the contract creator
374     totalSupply = INITIAL_SUPPLY;
375 
376     _balances[msg.sender] = INITIAL_SUPPLY;
377   }
378 
379 
380 
381 }
382 
383 
384 
385 library SafeMath {
386     /**
387     * @dev Multiplies two unsigned integers, reverts on overflow.
388     */
389     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
390         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
391         // benefit is lost if 'b' is also tested.
392         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
393         if (a == 0) {
394             return 0;
395         }
396 
397         uint256 c = a * b;
398         require(c / a == b);
399 
400         return c;
401     }
402 
403     /**
404     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
405     */
406     function div(uint256 a, uint256 b) internal pure returns (uint256) {
407         // Solidity only automatically asserts when dividing by 0
408         require(b > 0);
409         uint256 c = a / b;
410         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
411 
412         return c;
413     }
414 
415     /**
416     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
417     */
418     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
419         require(b <= a);
420         uint256 c = a - b;
421 
422         return c;
423     }
424 
425     /**
426     * @dev Adds two unsigned integers, reverts on overflow.
427     */
428     function add(uint256 a, uint256 b) internal pure returns (uint256) {
429         uint256 c = a + b;
430         require(c >= a);
431 
432         return c;
433     }
434 
435     /**
436     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
437     * reverts when dividing by zero.
438     */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         require(b != 0);
441         return a % b;
442     }
443 }