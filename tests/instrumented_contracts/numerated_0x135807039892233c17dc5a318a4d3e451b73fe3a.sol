1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (_a == 0) {
51       return 0;
52     }
53 
54     uint256 c = _a * _b;
55     require(c / _a == _b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     require(_b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = _a / _b;
66     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     require(_b <= _a);
76     uint256 c = _a - _b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
85     uint256 c = _a + _b;
86     require(c >= _a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
108  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20 {
111   using SafeMath for uint256;
112 
113   mapping (address => uint256) private balances_;
114 
115   mapping (address => mapping (address => uint256)) private allowed_;
116 
117   uint256 private totalSupply_;
118 
119   /**
120   * @dev Total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256) {
132     return balances_[_owner];
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141   function allowance(
142     address _owner,
143     address _spender
144    )
145     public
146     view
147     returns (uint256)
148   {
149     return allowed_[_owner][_spender];
150   }
151 
152   /**
153   * @dev Transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_value <= balances_[msg.sender]);
159     require(_to != address(0));
160 
161     balances_[msg.sender] = balances_[msg.sender].sub(_value);
162     balances_[_to] = balances_[_to].add(_value);
163     emit Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed_[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address _from,
190     address _to,
191     uint256 _value
192   )
193     public
194     returns (bool)
195   {
196     require(_value <= balances_[_from]);
197     require(_value <= allowed_[_from][msg.sender]);
198     require(_to != address(0));
199 
200     balances_[_from] = balances_[_from].sub(_value);
201     balances_[_to] = balances_[_to].add(_value);
202     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed_[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed_[msg.sender][_spender] = (
224       allowed_[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed_[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed_[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed_[msg.sender][_spender] = 0;
248     } else {
249       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Internal function that mints an amount of the token and assigns it to
257    * an account. This encapsulates the modification of balances such that the
258    * proper events are emitted.
259    * @param _account The account that will receive the created tokens.
260    * @param _amount The amount that will be created.
261    */
262   function _mint(address _account, uint256 _amount) internal {
263     require(_account != 0);
264     totalSupply_ = totalSupply_.add(_amount);
265     balances_[_account] = balances_[_account].add(_amount);
266     emit Transfer(address(0), _account, _amount);
267   }
268 
269   /**
270    * @dev Internal function that burns an amount of the token of a given
271    * account.
272    * @param _account The account whose tokens will be burnt.
273    * @param _amount The amount that will be burnt.
274    */
275   function _burn(address _account, uint256 _amount) internal {
276     require(_account != 0);
277     require(_amount <= balances_[_account]);
278 
279     totalSupply_ = totalSupply_.sub(_amount);
280     balances_[_account] = balances_[_account].sub(_amount);
281     emit Transfer(_account, address(0), _amount);
282   }
283 
284   /**
285    * @dev Internal function that burns an amount of the token of a given
286    * account, deducting from the sender's allowance for said account. Uses the
287    * internal _burn function.
288    * @param _account The account whose tokens will be burnt.
289    * @param _amount The amount that will be burnt.
290    */
291   function _burnFrom(address _account, uint256 _amount) internal {
292     require(_amount <= allowed_[_account][msg.sender]);
293 
294     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
295     // this function needs to emit an event with the updated approval.
296     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
297       _amount);
298     _burn(_account, _amount);
299   }
300 }
301 
302 
303 
304 /**
305  * @title Ownable
306  * @dev The Ownable contract has an owner address, and provides basic authorization control
307  * functions, this simplifies the implementation of "user permissions".
308  */
309 contract Ownable {
310   address public owner;
311 
312 
313   event OwnershipRenounced(address indexed previousOwner);
314   event OwnershipTransferred(
315     address indexed previousOwner,
316     address indexed newOwner
317   );
318 
319 
320   /**
321    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
322    * account.
323    */
324   constructor() public {
325     owner = msg.sender;
326   }
327 
328   /**
329    * @dev Throws if called by any account other than the owner.
330    */
331   modifier onlyOwner() {
332     require(msg.sender == owner);
333     _;
334   }
335 
336   /**
337    * @dev Allows the current owner to relinquish control of the contract.
338    * @notice Renouncing to ownership will leave the contract without an owner.
339    * It will not be possible to call the functions with the `onlyOwner`
340    * modifier anymore.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 
367 
368 /**
369  * @title Mintable token
370  * @dev Simple ERC20 Token example, with mintable token creation
371  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
372  */
373 contract MintableToken is StandardToken, Ownable {
374   event Mint(address indexed to, uint256 amount);
375   event MintFinished();
376 
377   bool public mintingFinished = false;
378 
379 
380   modifier canMint() {
381     require(!mintingFinished);
382     _;
383   }
384 
385   modifier hasMintPermission() {
386     require(msg.sender == owner);
387     _;
388   }
389 
390   /**
391    * @dev Function to mint tokens
392    * @param _to The address that will receive the minted tokens.
393    * @param _amount The amount of tokens to mint.
394    * @return A boolean that indicates if the operation was successful.
395    */
396   function mint(
397     address _to,
398     uint256 _amount
399   )
400     public
401     hasMintPermission
402     canMint
403     returns (bool)
404   {
405     _mint(_to, _amount);
406     emit Mint(_to, _amount);
407     return true;
408   }
409 
410   /**
411    * @dev Function to stop minting new tokens.
412    * @return True if the operation was successful.
413    */
414   function finishMinting() public onlyOwner canMint returns (bool) {
415     mintingFinished = true;
416     emit MintFinished();
417     return true;
418   }
419 }
420 
421 
422 contract CafeCoin is MintableToken {
423 
424   string public constant name = "CCPAY";
425   string public constant symbol = "CCPAY";
426   uint8 public constant decimals = 18;
427 
428 
429 }