1 pragma solidity ^0.5.0;
2 
3 contract TestaExchange {
4     
5     ERC20Token testa = ERC20Token(0x1da65B1868e2d36d06d7A44DBD2Be98e49E1f7f9);
6     ERC20Token jTesta = ERC20Token(0xEc7B95ba343224A9ED1EEe230912055DcD7081CA);
7     
8     function stake(uint _value) public {
9         testa.transferFrom(msg.sender, address(this), _value);
10         jTesta.transfer(msg.sender, _value);
11     }
12     
13     function unstake(uint _value) public {
14         jTesta.transferFrom(msg.sender, address(this), _value);
15         testa.transfer(msg.sender, _value);
16     }
17     
18     function getStakedBalance() public view returns (uint) {
19         return testa.balanceOf(address(this));
20     }
21     
22     function balanceOf(address _owner) public view returns (uint) {
23         return jTesta.balanceOf(_owner);
24     }
25 
26 }
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a, "SafeMath: subtraction overflow");
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0, "SafeMath: division by zero");
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
119      * Reverts when dividing by zero.
120      *
121      * Counterpart to Solidity's `%` operator. This function uses a `revert`
122      * opcode (which leaves remaining gas untouched) while Solidity uses an
123      * invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0, "SafeMath: modulo by zero");
130         return a % b;
131     }
132 }
133 
134 /**
135  * @title Ownable
136  * @dev The Ownable contract has an owner address, and provides basic authorization control
137  * functions, this simplifies the implementation of "user permissions".
138  */
139 contract Ownable {
140   address public owner;
141 
142 
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   constructor() public {
148     owner = msg.sender;
149   }
150 
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156       require(msg.sender == owner);
157     _;
158   }
159 
160 
161   /**
162    * @dev Allows the current owner to transfer control of the contract to a newOwner.
163    * @param newOwner The address to transfer ownership to.
164    */
165   function transferOwnership(address newOwner) public onlyOwner {
166     if (newOwner != address(0)) {
167       owner = newOwner;
168     }
169   }
170 
171 }
172 
173 /**
174  * @title ERC20Basic
175  * @dev Simpler version of ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20Basic {
179   uint public totalSupply;
180   function balanceOf(address who) public view returns (uint);
181   function transfer(address to, uint value) public;
182   event Transfer(address indexed from, address indexed to, uint value);
183 }
184 
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances.
189  */
190 contract BasicToken is ERC20Basic {
191   using SafeMath for uint;
192 
193   mapping(address => uint) balances;
194 
195   /**
196   * @dev transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint _value) public {
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     emit Transfer(msg.sender, _to, _value);
204   }
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param _owner The address to query the the balance of.
209   * @return An uint representing the amount owned by the passed address.
210   */
211   function balanceOf(address _owner) public view returns (uint balance) {
212     return balances[_owner];
213   }
214 
215 }
216 
217 
218 /**
219  * @title ERC20 interface
220  * @dev see https://github.com/ethereum/EIPs/issues/20
221  */
222 contract ERC20 is ERC20Basic {
223   function allowance(address owner, address spender) public view returns (uint);
224   function transferFrom(address from, address to, uint value) public;
225   function approve(address spender, uint value) public;
226   event Approval(address indexed owner, address indexed spender, uint value);
227 }
228 
229 
230 /**
231  * @title Standard ERC20 token
232  *
233  * @dev Implemantation of the basic standart token.
234  * @dev https://github.com/ethereum/EIPs/issues/20
235  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
236  */
237 contract StandardToken is BasicToken, ERC20 {
238 
239   mapping (address => mapping (address => uint)) allowed;
240 
241 
242   /**
243    * @dev Transfer tokens from one address to another
244    * @param _from address The address which you want to send tokens from
245    * @param _to address The address which you want to transfer to
246    * @param _value uint the amout of tokens to be transfered
247    */
248   function transferFrom(address _from, address _to, uint _value) public {
249     uint256 _allowance = allowed[_from][msg.sender];
250 
251     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
252     // if (_value > _allowance) revert();
253 
254     balances[_to] = balances[_to].add(_value);
255     balances[_from] = balances[_from].sub(_value);
256     allowed[_from][msg.sender] = _allowance.sub(_value);
257     emit Transfer(_from, _to, _value);
258   }
259 
260   /**
261    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint _value) public {
266 
267     // To change the approve amount you first have to reduce the addresses`
268     //  allowance to zero by calling `approve(_spender, 0)` if it is not
269     //  already 0 to mitigate the race condition described here:
270     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert("approve revert");
272 
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens than an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint specifing the amount of tokens still avaible for the spender.
282    */
283   function allowance(address _owner, address _spender) public view returns (uint remaining) {
284     return allowed[_owner][_spender];
285   }
286 
287 }
288 
289 /**
290  * @title Mintable token
291  * @dev Simple ERC20 Token example, with mintable token creation
292  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
293  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
294  */
295 
296 contract MintableToken is StandardToken, Ownable {
297   event Mint(address indexed to, uint value);
298   event MintFinished();
299 
300   bool public mintingFinished = false;
301   uint public totalSupply = 0;
302 
303 
304   modifier canMint() {
305     if(mintingFinished) revert();
306     _;
307   }
308 
309   /**
310    * @dev Function to mint tokens
311    * @param _to The address that will recieve the minted tokens.
312    * @param _amount The amount of tokens to mint.
313    * @return A boolean that indicates if the operation was successful.
314    */
315   function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
316     totalSupply = totalSupply.add(_amount);
317     balances[_to] = balances[_to].add(_amount);
318     emit Mint(_to, _amount);
319     return true;
320   }
321 
322   /**
323    * @dev Function to stop minting new tokens.
324    * @return True if the operation was successful.
325    */
326   function finishMinting() public onlyOwner returns (bool) {
327     mintingFinished = true;
328     emit MintFinished();
329     return true;
330   }
331 }
332 
333 
334 /**
335  * @title Pausable
336  * @dev Base contract which allows children to implement an emergency stop mechanism.
337  */
338 contract Pausable is Ownable {
339   event Pause();
340   event Unpause();
341 
342   bool public paused = false;
343 
344 
345   /**
346    * @dev modifier to allow actions only when the contract IS paused
347    */
348   modifier whenNotPaused() {
349     if (paused) revert("it's paused");
350     _;
351   }
352 
353   /**
354    * @dev modifier to allow actions only when the contract IS NOT paused
355    */
356   modifier whenPaused {
357     if (!paused) revert("it's not paused");
358     _;
359   }
360 
361   /**
362    * @dev called by the owner to pause, triggers stopped state
363    */
364   function pause() public onlyOwner whenNotPaused returns (bool) {
365     paused = true;
366     emit Pause();
367     return true;
368   }
369 
370   /**
371    * @dev called by the owner to unpause, returns to normal state
372    */
373   function unpause() public onlyOwner whenPaused returns (bool) {
374     paused = false;
375     emit Unpause();
376     return true;
377   }
378 }
379 
380 
381 /**
382  * Pausable token
383  *
384  * Simple ERC20 Token example, with pausable token creation
385  **/
386 
387 contract PausableToken is StandardToken, Pausable {
388 
389   function transfer(address _to, uint _value) public whenNotPaused {
390     super.transfer(_to, _value);
391   }
392 
393   function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
394     super.transferFrom(_from, _to, _value);
395   }
396 }
397 
398 /**
399  * @title ERC20 Token
400  */
401 contract ERC20Token is PausableToken, MintableToken {
402   using SafeMath for uint256;
403 
404   string public name;
405   string public symbol;
406   uint public decimals;
407 
408   constructor(string memory _name, string memory _symbol, uint _decimals) public  {
409       name = _name;
410       symbol = _symbol;
411       decimals = _decimals;
412   }
413 }
414 
415 contract TestaToken is ERC20Token("Testa", "TESTA", 18) {
416     
417     constructor() public {
418         mint(owner, 7777777 * 10 ** decimals);
419     }
420     
421 }
422 
423 contract JTestaToken is ERC20Token("jTesta", "jTESTA", 18) {
424     
425     constructor() public {
426         mint(owner, 7777777 * 10 ** decimals);
427     }
428     
429 }