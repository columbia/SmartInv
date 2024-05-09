1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, April 28, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.9;
6 
7 
8 
9 /**
10  * @title Standard ERC20 token
11  *
12  * @dev Implementation of the basic standard token.
13  * https://eips.ethereum.org/EIPS/eip-20
14  * Originally based on code by FirstBlood:
15  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
16  *
17  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
18  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
19  * compliant implementations may not do it.
20  */
21 
22 
23 
24  contract Ownable {
25      address private _owner;
26 
27      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29      /**
30       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31       * account.
32       */
33      constructor () internal {
34          _owner = msg.sender;
35          emit OwnershipTransferred(address(0), _owner);
36      }
37 
38      /**
39       * @return the address of the owner.
40       */
41      function owner() public view returns (address) {
42          return _owner;
43      }
44 
45      /**
46       * @dev Throws if called by any account other than the owner.
47       */
48      modifier onlyOwner() {
49          require(isOwner());
50          _;
51      }
52 
53      /**
54       * @return true if `msg.sender` is the owner of the contract.
55       */
56      function isOwner() public view returns (bool) {
57          return msg.sender == _owner;
58      }
59 
60      /**
61       * @dev Allows the current owner to relinquish control of the contract.
62       * It will not be possible to call the functions with the `onlyOwner`
63       * modifier anymore.
64       * @notice Renouncing ownership will leave the contract without an owner,
65       * thereby removing any functionality that is only available to the owner.
66       */
67      function renounceOwnership() public onlyOwner {
68          emit OwnershipTransferred(_owner, address(0));
69          _owner = address(0);
70      }
71 
72      /**
73       * @dev Allows the current owner to transfer control of the contract to a newOwner.
74       * @param newOwner The address to transfer ownership to.
75       */
76      function transferOwnership(address newOwner) public onlyOwner {
77          _transferOwnership(newOwner);
78      }
79 
80      /**
81       * @dev Transfers control of the contract to a newOwner.
82       * @param newOwner The address to transfer ownership to.
83       */
84      function _transferOwnership(address newOwner) internal {
85          require(newOwner != address(0));
86          emit OwnershipTransferred(_owner, newOwner);
87          _owner = newOwner;
88      }
89  }
90 
91 
92 
93  contract Pausable is Ownable {
94    event Pause();
95    event Unpause();
96 
97    bool public paused = false;
98 
99 
100    /**
101     * @dev Modifier to make a function callable only when the contract is not paused.
102     */
103    modifier whenNotPaused() {
104      require(!paused);
105      _;
106    }
107 
108    /**
109     * @dev Modifier to make a function callable only when the contract is paused.
110     */
111    modifier whenPaused() {
112      require(paused);
113      _;
114    }
115 
116    /**
117     * @dev called by the owner to pause, triggers stopped state
118     */
119    function pause() onlyOwner whenNotPaused public {
120      paused = true;
121      emit Pause();
122    }
123 
124    /**
125     * @dev called by the owner to unpause, returns to normal state
126     */
127    function unpause() onlyOwner whenPaused public {
128      paused = false;
129      emit Unpause();
130    }
131  }
132 
133 
134 contract IERC20 {
135     function transfer(address to, uint256 value) external returns (bool);
136 
137     function approve(address spender, uint256 value) external returns (bool);
138 
139     function transferFrom(address from, address to, uint256 value) external returns (bool);
140 
141     function totalSupply() external view returns (uint256);
142 
143     function balanceOf(address who) external view returns (uint256);
144 
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 contract ERC20 is IERC20 {
153     using SafeMath for uint256;
154 
155     mapping (address => uint256) public _balances;
156 
157     mapping (address => mapping (address => uint256)) private _allowed;
158 
159     uint256 public totalSupply;
160 
161 
162     /**
163      * @dev Gets the balance of the specified address.
164      * @param owner The address to query the balance of.
165      * @return A uint256 representing the amount owned by the passed address.
166      */
167     function balanceOf(address owner) public view returns (uint256) {
168         return _balances[owner];
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param owner address The address which owns the funds.
174      * @param spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address owner, address spender) public view returns (uint256) {
178         return _allowed[owner][spender];
179     }
180 
181     /**
182      * @dev Transfer token to a specified address
183      * @param to The address to transfer to.
184      * @param value The amount to be transferred.
185      */
186     function transfer(address to, uint256 value) public returns (bool) {
187         _transfer(msg.sender, to, value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      * Beware that changing an allowance with this method brings the risk that someone may use both the old
194      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      * @param spender The address which will spend the funds.
198      * @param value The amount of tokens to be spent.
199      */
200     function approve(address spender, uint256 value) public returns (bool) {
201         _approve(msg.sender, spender, value);
202         return true;
203     }
204 
205     /**
206      * @dev Transfer tokens from one address to another.
207      * Note that while this function emits an Approval event, this is not required as per the specification,
208      * and other compliant implementations may not emit the event.
209      * @param from address The address which you want to send tokens from
210      * @param to address The address which you want to transfer to
211      * @param value uint256 the amount of tokens to be transferred
212      */
213     function transferFrom(address from, address to, uint256 value) public returns (bool) {
214         _transfer(from, to, value);
215         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
216         return true;
217     }
218 
219     /**
220      * @dev Increase the amount of tokens that an owner allowed to a spender.
221      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * Emits an Approval event.
226      * @param spender The address which will spend the funds.
227      * @param addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
230         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
231         return true;
232     }
233 
234     /**
235      * @dev Decrease the amount of tokens that an owner allowed to a spender.
236      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * Emits an Approval event.
241      * @param spender The address which will spend the funds.
242      * @param subtractedValue The amount of tokens to decrease the allowance by.
243      */
244     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
245         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
246         return true;
247     }
248 
249     /**
250      * @dev Transfer token for a specified addresses
251      * @param from The address to transfer from.
252      * @param to The address to transfer to.
253      * @param value The amount to be transferred.
254      */
255     function _transfer(address from, address to, uint256 value) internal {
256         require(to != address(0));
257 
258         _balances[from] = _balances[from].sub(value);
259         _balances[to] = _balances[to].add(value);
260         emit Transfer(from, to, value);
261     }
262 
263 
264 
265     /**
266      * @dev Approve an address to spend another addresses' tokens.
267      * @param owner The address that owns the tokens.
268      * @param spender The address that will spend the tokens.
269      * @param value The number of tokens that can be spent.
270      */
271     function _approve(address owner, address spender, uint256 value) internal {
272         require(spender != address(0));
273         require(owner != address(0));
274 
275         _allowed[owner][spender] = value;
276         emit Approval(owner, spender, value);
277     }
278 
279 
280 }
281 
282 
283 
284 
285 contract ERC20Pausable is ERC20, Pausable {
286     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
287         return super.transfer(to, value);
288     }
289 
290     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
291         return super.transferFrom(from, to, value);
292     }
293 
294     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
295         return super.approve(spender, value);
296     }
297 
298     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
299         return super.increaseAllowance(spender, addedValue);
300     }
301 
302     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
303         return super.decreaseAllowance(spender, subtractedValue);
304     }
305 }
306 
307 
308 
309 
310 
311 
312 contract MVITc is Ownable {
313 
314   // the token being sold
315   MVITtoken public token;
316   uint256 constant public tokenDecimals = 18;
317 
318   // totalSupply
319   uint256 public totalSupply = 90000000 * (10 ** uint256(tokenDecimals));
320 
321 
322   constructor () public {
323 
324     token = createTokenContract();
325     token.unpause();
326   }
327 
328 
329 
330 
331 
332   //
333   // Token related operations
334   //
335 
336   // creates the token to be sold.
337   // override this method to have crowdsale of a specific mintable token.
338   function createTokenContract() internal returns (MVITtoken) {
339     return new MVITtoken();
340   }
341 
342   // enable token transferability
343   function enableTokenTransferability() external onlyOwner {
344     token.unpause();
345   }
346 
347   // disable token transferability
348   function disableTokenTransferability() external onlyOwner {
349     token.pause();
350   }
351 
352   // transfer token to designated address
353   function transfer(address to, uint256 value) external onlyOwner returns (bool ok)  {
354     uint256 converterdValue = value * (10 ** uint256(tokenDecimals));
355     return token.transfer(to, converterdValue);
356    }
357 
358 
359 
360 }
361 
362 
363 
364 
365 
366 contract MVITtoken is ERC20Pausable {
367   string constant public name = "MVIT Token";
368   string constant public symbol = "MVT";
369   uint8 constant public decimals = 18;
370   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
371   uint256 constant INITIAL_SUPPLY = 90000000 * TOKEN_UNIT;
372 
373 
374   constructor () public {
375     // Set untransferable by default to the token
376     paused = true;
377     // asign all tokens to the contract creator
378     totalSupply = INITIAL_SUPPLY;
379 
380     _balances[msg.sender] = INITIAL_SUPPLY;
381   }
382 
383 
384 
385 }
386 
387 
388 
389 library SafeMath {
390     /**
391     * @dev Multiplies two unsigned integers, reverts on overflow.
392     */
393     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
394         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
395         // benefit is lost if 'b' is also tested.
396         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
397         if (a == 0) {
398             return 0;
399         }
400 
401         uint256 c = a * b;
402         require(c / a == b);
403 
404         return c;
405     }
406 
407     /**
408     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
409     */
410     function div(uint256 a, uint256 b) internal pure returns (uint256) {
411         // Solidity only automatically asserts when dividing by 0
412         require(b > 0);
413         uint256 c = a / b;
414         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
415 
416         return c;
417     }
418 
419     /**
420     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
421     */
422     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
423         require(b <= a);
424         uint256 c = a - b;
425 
426         return c;
427     }
428 
429     /**
430     * @dev Adds two unsigned integers, reverts on overflow.
431     */
432     function add(uint256 a, uint256 b) internal pure returns (uint256) {
433         uint256 c = a + b;
434         require(c >= a);
435 
436         return c;
437     }
438 
439     /**
440     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
441     * reverts when dividing by zero.
442     */
443     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b != 0);
445         return a % b;
446     }
447 }