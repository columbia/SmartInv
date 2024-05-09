1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address private _owner;
73 
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() internal {
84     _owner = msg.sender;
85     emit OwnershipTransferred(address(0), _owner);
86   }
87 
88   /**
89    * @return the address of the owner.
90    */
91   function owner() public view returns(address) {
92     return _owner;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(isOwner());
100     _;
101   }
102 
103   /**
104    * @return true if `msg.sender` is the owner of the contract.
105    */
106   function isOwner() public view returns(bool) {
107     return msg.sender == _owner;
108   }
109 
110   /**
111    * @dev Allows the current owner to relinquish control of the contract.
112    * @notice Renouncing to ownership will leave the contract without an owner.
113    * It will not be possible to call the functions with the `onlyOwner`
114    * modifier anymore.
115    */
116   function renounceOwnership() public onlyOwner {
117     emit OwnershipTransferred(_owner, address(0));
118     _owner = address(0);
119   }
120 
121   /**
122    * @dev Allows the current owner to transfer control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) public onlyOwner {
126     _transferOwnership(newOwner);
127   }
128 
129   /**
130    * @dev Transfers control of the contract to a newOwner.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function _transferOwnership(address newOwner) internal {
134     require(newOwner != address(0));
135     emit OwnershipTransferred(_owner, newOwner);
136     _owner = newOwner;
137   }
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 interface IERC20 {
145   function totalSupply() external view returns (uint256);
146 
147   function balanceOf(address who) external view returns (uint256);
148 
149   function allowance(address owner, address spender)
150     external view returns (uint256);
151 
152   function transfer(address to, uint256 value) external returns (bool);
153 
154   function approve(address spender, uint256 value)
155     external returns (bool);
156 
157   function transferFrom(address from, address to, uint256 value)
158     external returns (bool);
159 
160   event Transfer(
161     address indexed from,
162     address indexed to,
163     uint256 value
164   );
165 
166   event Approval(
167     address indexed owner,
168     address indexed spender,
169     uint256 value
170   );
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
178  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract ERC20 is IERC20 {
181   using SafeMath for uint256;
182 
183   mapping (address => uint256) internal _balances;
184 
185   mapping (address => mapping (address => uint256)) private _allowed;
186 
187   uint256 internal _totalSupply;
188 
189   /**
190   * @dev Total number of tokens in existence
191   */
192   function totalSupply() public view returns (uint256) {
193     return _totalSupply;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param owner The address to query the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address owner) public view returns (uint256) {
202     return _balances[owner];
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param owner address The address which owns the funds.
208    * @param spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(
212     address owner,
213     address spender
214    )
215     public
216     view
217     returns (uint256)
218   {
219     return _allowed[owner][spender];
220   }
221 
222   /**
223   * @dev Transfer token for a specified address
224   * @param to The address to transfer to.
225   * @param value The amount to be transferred.
226   */
227   function transfer(address to, uint256 value) public returns (bool) {
228     _transfer(msg.sender, to, value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param spender The address which will spend the funds.
239    * @param value The amount of tokens to be spent.
240    */
241   function approve(address spender, uint256 value) public returns (bool) {
242     require(spender != address(0));
243 
244     _allowed[msg.sender][spender] = value;
245     emit Approval(msg.sender, spender, value);
246     return true;
247   }
248 
249   /**
250    * @dev Transfer tokens from one address to another
251    * @param from address The address which you want to send tokens from
252    * @param to address The address which you want to transfer to
253    * @param value uint256 the amount of tokens to be transferred
254    */
255   function transferFrom(
256     address from,
257     address to,
258     uint256 value
259   )
260     public
261     returns (bool)
262   {
263     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
264     _transfer(from, to, value);
265     return true;
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseAllowance(
278     address spender,
279     uint256 addedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].add(addedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed_[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param spender The address which will spend the funds.
299    * @param subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseAllowance(
302     address spender,
303     uint256 subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     require(spender != address(0));
309 
310     _allowed[msg.sender][spender] = (
311       _allowed[msg.sender][spender].sub(subtractedValue));
312     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313     return true;
314   }
315 
316   /**
317   * @dev Transfer token for a specified addresses
318   * @param from The address to transfer from.
319   * @param to The address to transfer to.
320   * @param value The amount to be transferred.
321   */
322   function _transfer(address from, address to, uint256 value) internal {
323     require(to != address(0));
324 
325     _balances[from] = _balances[from].sub(value);
326     _balances[to] = _balances[to].add(value);
327     emit Transfer(from, to, value);
328   }
329 
330   /**
331    * @dev Internal function that mints an amount of the token and assigns it to
332    * an account. This encapsulates the modification of balances such that the
333    * proper events are emitted.
334    * @param account The account that will receive the created tokens.
335    * @param value The amount that will be created.
336    */
337   function _mint(address account, uint256 value) internal {
338     require(account != address(0));
339 
340     _totalSupply = _totalSupply.add(value);
341     _balances[account] = _balances[account].add(value);
342     emit Transfer(address(0), account, value);
343   }
344 
345   /**
346    * @dev Internal function that burns an amount of the token of a given
347    * account.
348    * @param account The account whose tokens will be burnt.
349    * @param value The amount that will be burnt.
350    */
351   function _burn(address account, uint256 value) internal {
352     require(account != address(0));
353 
354     _totalSupply = _totalSupply.sub(value);
355     _balances[account] = _balances[account].sub(value);
356     emit Transfer(account, address(0), value);
357   }
358 
359   /**
360    * @dev Internal function that burns an amount of the token of a given
361    * account, deducting from the sender's allowance for said account. Uses the
362    * internal burn function.
363    * @param account The account whose tokens will be burnt.
364    * @param value The amount that will be burnt.
365    */
366   function _burnFrom(address account, uint256 value) internal {
367     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
368     // this function needs to emit an event with the updated approval.
369     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
370       value);
371     _burn(account, value);
372   }
373 }
374 
375 contract splitableToken is ERC20,Ownable{
376     using SafeMath for uint256;using SafeMath for uint256;
377     address[] private holders;
378     constructor() public{
379         holders.push(msg.sender);
380     }
381     function transfer(address to, uint256 value) public returns (bool) {
382         _addHolder(to);
383         super.transfer(to, value);
384         return true;
385     }
386     function _addHolder(address holder) internal{
387         for(uint i = 0; i < holders.length; i++){
388             if(holders[i] == holder){
389                 return;
390             }
391         }
392         holders.push(holder);
393     }
394     function splitStock(uint splitNumber) public onlyOwner{
395         require(splitNumber > 1);
396         for(uint i = 0; i < holders.length; i++){
397             uint sendingAmount = _balances[holders[i]].mul(splitNumber.sub(1));
398             _balances[holders[i]] = _balances[holders[i]].mul(splitNumber);
399             emit Transfer(address(this),holders[i],sendingAmount);
400         }
401         _totalSupply = _totalSupply.mul(splitNumber);
402     }
403 }
404 
405 contract ERC20BasicInterface {
406     function totalSupply() public view returns (uint256);
407     function balanceOf(address who) public view returns (uint256);
408     function transfer(address to, uint256 value) public returns (bool);
409     function transferFrom(address from, address to, uint256 value) public returns (bool);
410     event Transfer(address indexed from, address indexed to, uint256 value);
411 
412     uint8 public decimals;
413 }
414 
415 
416 contract Token is splitableToken{
417   uint8 public decimals = 0;
418   string public name = "crypto currency school coin";
419   string public symbol = "CCSC";
420   bool public locked = false;
421   constructor() public {
422      uint _initialSupply = 1000000000;
423      _balances[msg.sender] = _initialSupply;
424      _totalSupply = _initialSupply;
425      emit Transfer(address(this),msg.sender,_initialSupply);
426   }
427 
428    // This is a modifier whether transfering token is available or not
429     modifier isValidTransfer() {
430         require(!locked);
431         _;
432     }
433     function transfer(address to, uint256 value) public isValidTransfer returns (bool) {
434         return super.transfer(to,value);
435     }
436 
437     /**
438     * @dev Owner can lock the feature to transfer token
439     */
440     function setLocked(bool _locked) onlyOwner public {
441         locked = _locked;
442     }
443 
444     /**
445     * @dev Function someone send ERC20 Token to this contract address
446     */
447     function sendERC20Token (address _tokenAddress, address _to, uint _amount) public onlyOwner{
448         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
449         require(token.transfer(_to,_amount));
450     }
451 
452     /**
453     * @dev Function someone send Ether to this contract address
454     */
455     function sendEther (address _to, uint _amount) public onlyOwner{
456         _to.transfer(_amount);
457     }
458 }