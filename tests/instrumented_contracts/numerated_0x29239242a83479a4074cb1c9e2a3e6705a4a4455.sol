1 pragma solidity ^0.5.10;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner, "Not authorized operation");
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0), "Address shouldn't be zero");
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b <= a, "SafeMath: subtraction overflow");
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0, "SafeMath: division by zero");
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         require(b != 0, "SafeMath: modulo by zero");
147         return a % b;
148     }
149 }
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 {
156   uint256 public totalSupply;
157   function balanceOf(address who) public view returns (uint256);
158   function transfer(address to, uint256 value) public returns (bool);
159   function allowance(address owner, address spender) public view returns (uint256);
160   function transferFrom(address from, address to, uint256 value) public returns (bool);
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(address indexed owner, address indexed spender, uint256 value);
163   event Transfer(address indexed from, address indexed to, uint256 value);
164 
165 
166 }
167 
168 /**
169  * @dev Collection of functions related to the address type,
170  */
171 library Address {
172     /**
173      * @dev Returns true if `account` is a contract.
174      *
175      * This test is non-exhaustive, and there may be false-negatives: during the
176      * execution of a contract's constructor, its address will be reported as
177      * not containing a contract.
178      *
179      * > It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies in extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { size := extcodesize(account) }
190         return size > 0;
191     }
192 }
193 
194 /**
195  * @title Tozex ERC20 Mintable token
196  * @dev Issue: contact support@tozex.io
197  * @author Tozex.io
198  */
199 contract MintableToken is ERC20, Ownable {
200   using Address for address;
201   using SafeMath for uint256;
202 
203   string public name;
204   string public symbol;
205   uint8 public decimals;
206   uint256 public totalSupply;
207   address public tokenOwner;
208   address private crowdsale;
209 
210   mapping(address => uint256) balances;
211   mapping(address => mapping(address => uint256)) internal allowed;
212 
213   event SetCrowdsale(address indexed _crowdsale);
214   event Mint(address indexed to, uint256 amount);
215   event MintFinished();
216   event UnlockToken();
217   event LockToken();
218   event Burn();
219 
220   bool public mintingFinished = false;
221   bool public locked = false;
222 
223 
224   modifier canMint() {
225     require(!mintingFinished);
226     _;
227   }
228 
229   modifier canTransfer() {
230     require(!locked || msg.sender == owner);
231     _;
232   }
233 
234   modifier onlyCrowdsale() {
235     require(msg.sender == crowdsale);
236     _;
237   }
238 
239   modifier onlyAuthorized() {
240     require(msg.sender == owner || msg.sender == crowdsale);
241     _;
242   }
243 
244   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
245     name = _name;
246     symbol = _symbol;
247     decimals = _decimals;
248     totalSupply = 0;
249     balances[msg.sender] = totalSupply;
250     emit Transfer(address(0), msg.sender, totalSupply);
251   }
252 
253   /**
254    * @dev Function to mint tokens
255    * @param _amount The amount of tokens to mint.
256    * @return A boolean that indicates if the operation was successful.
257    */
258   function mint(address _to, uint256 _amount) public onlyAuthorized canMint returns (bool) {
259     totalSupply = totalSupply.add(_amount);
260     balances[_to] = balances[_to].add(_amount);
261     emit Mint(_to, _amount);
262     emit Transfer(address(0), _to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner public canMint returns (bool) {
271     mintingFinished = true;
272     emit MintFinished();
273     return true;
274   }
275 
276   function burn(uint256 _value) public onlyAuthorized returns (bool) {
277     totalSupply = totalSupply.sub(_value);
278     balances[address(this)] = balances[address(this)].sub(_value);
279     emit Burn();
280     emit Transfer(address(this), address(0), _value);
281     return true;
282   }
283   /**
284   * @dev transfer token for a specified address
285   * @param _to The address to transfer to.
286   * @param _value The amount to be transferred.
287   */
288 
289   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
290     require(_to != address(0));
291     require(_value <= balances[msg.sender]);
292 
293     // SafeMath.sub will throw if there is not enough balance.
294     balances[msg.sender] = balances[msg.sender].sub(_value);
295     balances[_to] = balances[_to].add(_value);
296     emit Transfer(msg.sender, _to, _value);
297     return true;
298   }
299 
300   function transferFromContract(address _to, uint256 _value) public onlyOwner returns (bool) {
301     require(_to != address(0));
302     require(_value <= balances[address(this)]);
303     balances[address(this)] = balances[address(this)].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     emit Transfer(address(this), _to, _value);
306     return true;
307   }
308 
309   /**
310   * @dev Gets the balance of the specified address.
311   * @param _owner The address to query the the balance of.
312   * @return An uint256 representing the amount owned by the passed address.
313   */
314   function balanceOf(address _owner) public view returns (uint256 balance) {
315     return balances[_owner];
316   }
317 
318   /**
319    * @dev Transfer tokens from one address to another
320    * @param _from address The address which you want to send tokens from
321    * @param _to address The address which you want to transfer to
322    * @param _value uint256 the amount of tokens to be transferred
323    */
324   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
325     require(_to != address(0));
326     require(_value <= balances[_from]);
327     require(_value <= allowed[_from][msg.sender]);
328 
329     balances[_from] = balances[_from].sub(_value);
330     balances[_to] = balances[_to].add(_value);
331     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
332     emit Transfer(_from, _to, _value);
333     return true;
334   }
335 
336   /**
337    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338    *
339    * Beware that changing an allowance with this method brings the risk that someone may use both the old
340    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
341    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
342    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343    * @param _spender The address which will spend the funds.
344    * @param _value The amount of tokens to be spent.
345    */
346   function approve(address _spender, uint256 _value) public returns (bool) {
347     allowed[msg.sender][_spender] = _value;
348     emit Approval(msg.sender, _spender, _value);
349     return true;
350   }
351 
352   /**
353    * @dev Function to check the amount of tokens that an owner allowed to a spender.
354    * @param _owner address The address which owns the funds.
355    * @param _spender address The address which will spend the funds.
356    * @return A uint256 specifying the amount of tokens still available for the spender.
357    */
358   function allowance(address _owner, address _spender) public view returns (uint256) {
359     return allowed[_owner][_spender];
360   }
361 
362   /**
363    * @dev Increase the amount of tokens that an owner allowed to a spender.
364    *
365    * approve should be called when allowed[_spender] == 0. To increment
366    * allowed value is better to use this function to avoid 2 calls (and wait until
367    * the first transaction is mined)
368    * From MonolithDAO Token.sol
369    * @param _spender The address which will spend the funds.
370    * @param _addedValue The amount of tokens to increase the allowance by.
371    */
372   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
373     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
374     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375     return true;
376   }
377 
378   /**
379    * @dev Decrease the amount of tokens that an owner allowed to a spender.
380    *
381    * approve should be called when allowed[_spender] == 0. To decrement
382    * allowed value is better to use this function to avoid 2 calls (and wait until
383    * the first transaction is mined)
384    * From MonolithDAO Token.sol
385    * @param _spender The address which will spend the funds.
386    * @param _subtractedValue The amount of tokens to decrease the allowance by.
387    */
388   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
389     uint oldValue = allowed[msg.sender][_spender];
390 
391     if (_subtractedValue > oldValue) {
392       allowed[msg.sender][_spender] = 0;
393     } else {
394       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
395     }
396 
397     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398     return true;
399   }
400 
401   function unlockToken() public onlyCrowdsale returns (bool) {
402     locked = false;
403     emit UnlockToken();
404     return true;
405   }
406 
407   function lockToken() public onlyCrowdsale returns (bool) {
408     locked = true;
409     emit LockToken();
410     return true;
411   }
412 
413   function setCrowdsale(address _crowdsale) public onlyOwner returns (bool) {
414     require(_crowdsale.isContract());
415     crowdsale = _crowdsale;
416 
417     emit SetCrowdsale(_crowdsale);
418     return true;
419   }
420 }