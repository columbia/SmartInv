1 pragma solidity ^0.4.25;
2 // v0.4.25+commit.59dbf8f1
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address private _owner;
74 
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() internal {
85     _owner = msg.sender;
86     emit OwnershipTransferred(address(0), _owner);
87   }
88 
89   /**
90    * @return the address of the owner.
91    */
92   function owner() public view returns(address) {
93     return _owner;
94   }
95 
96   /**
97    * @dev Throws if called by any account other than the owner.
98    */
99   modifier onlyOwner() {
100     require(isOwner());
101     _;
102   }
103 
104   /**
105    * @return true if `msg.sender` is the owner of the contract.
106    */
107   function isOwner() public view returns(bool) {
108     return msg.sender == _owner;
109   }
110 
111   /**
112    * @dev Allows the current owner to relinquish control of the contract.
113    * @notice Renouncing to ownership will leave the contract without an owner.
114    * It will not be possible to call the functions with the `onlyOwner`
115    * modifier anymore.
116    */
117   function renounceOwnership() public onlyOwner {
118     emit OwnershipTransferred(_owner, address(0));
119     _owner = address(0);
120   }
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) public onlyOwner {
127     _transferOwnership(newOwner);
128   }
129 
130   /**
131    * @dev Transfers control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function _transferOwnership(address newOwner) internal {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(_owner, newOwner);
137     _owner = newOwner;
138   }
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 interface IERC20 {
146   function totalSupply() external view returns (uint256);
147 
148   function balanceOf(address who) external view returns (uint256);
149 
150   function allowance(address owner, address spender)
151     external view returns (uint256);
152 
153   function transfer(address to, uint256 value) external returns (bool);
154 
155   function approve(address spender, uint256 value)
156     external returns (bool);
157 
158   function transferFrom(address from, address to, uint256 value)
159     external returns (bool);
160 
161   event Transfer(
162     address indexed from,
163     address indexed to,
164     uint256 value
165   );
166 
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
179  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract ERC20 is IERC20 {
182   using SafeMath for uint256;
183 
184   mapping (address => uint256) internal _balances;
185 
186   mapping (address => mapping (address => uint256)) private _allowed;
187 
188   uint256 internal _totalSupply;
189 
190   /**
191   * @dev Total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return _totalSupply;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param owner The address to query the balance of.
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address owner) public view returns (uint256) {
203     return _balances[owner];
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param owner address The address which owns the funds.
209    * @param spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address owner,
214     address spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return _allowed[owner][spender];
221   }
222 
223   /**
224   * @dev Transfer token for a specified address
225   * @param to The address to transfer to.
226   * @param value The amount to be transferred.
227   */
228   function transfer(address to, uint256 value) public returns (bool) {
229     _transfer(msg.sender, to, value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param spender The address which will spend the funds.
240    * @param value The amount of tokens to be spent.
241    */
242   function approve(address spender, uint256 value) public returns (bool) {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = value;
246     emit Approval(msg.sender, spender, value);
247     return true;
248   }
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param from address The address which you want to send tokens from
253    * @param to address The address which you want to transfer to
254    * @param value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(
257     address from,
258     address to,
259     uint256 value
260   )
261     public
262     returns (bool)
263   {
264     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
265     _transfer(from, to, value);
266     return true;
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    * approve should be called when allowed_[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param spender The address which will spend the funds.
276    * @param addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseAllowance(
279     address spender,
280     uint256 addedValue
281   )
282     public
283     returns (bool)
284   {
285     require(spender != address(0));
286 
287     _allowed[msg.sender][spender] = (
288       _allowed[msg.sender][spender].add(addedValue));
289     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed_[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param spender The address which will spend the funds.
300    * @param subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseAllowance(
303     address spender,
304     uint256 subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     require(spender != address(0));
310 
311     _allowed[msg.sender][spender] = (
312       _allowed[msg.sender][spender].sub(subtractedValue));
313     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
314     return true;
315   }
316 
317   /**
318   * @dev Transfer token for a specified addresses
319   * @param from The address to transfer from.
320   * @param to The address to transfer to.
321   * @param value The amount to be transferred.
322   */
323   function _transfer(address from, address to, uint256 value) internal {
324     require(to != address(0));
325 
326     _balances[from] = _balances[from].sub(value);
327     _balances[to] = _balances[to].add(value);
328     emit Transfer(from, to, value);
329   }
330 
331   /**
332    * @dev Internal function that mints an amount of the token and assigns it to
333    * an account. This encapsulates the modification of balances such that the
334    * proper events are emitted.
335    * @param account The account that will receive the created tokens.
336    * @param value The amount that will be created.
337    */
338   function _mint(address account, uint256 value) internal {
339     require(account != address(0));
340 
341     _totalSupply = _totalSupply.add(value);
342     _balances[account] = _balances[account].add(value);
343     emit Transfer(address(0), account, value);
344   }
345 
346   /**
347    * @dev Internal function that burns an amount of the token of a given
348    * account.
349    * @param account The account whose tokens will be burnt.
350    * @param value The amount that will be burnt.
351    */
352   function _burn(address account, uint256 value) internal {
353     require(account != address(0));
354 
355     _totalSupply = _totalSupply.sub(value);
356     _balances[account] = _balances[account].sub(value);
357     emit Transfer(account, address(0), value);
358   }
359 
360   /**
361    * @dev Internal function that burns an amount of the token of a given
362    * account, deducting from the sender's allowance for said account. Uses the
363    * internal burn function.
364    * @param account The account whose tokens will be burnt.
365    * @param value The amount that will be burnt.
366    */
367   function _burnFrom(address account, uint256 value) internal {
368     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
369     // this function needs to emit an event with the updated approval.
370     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
371       value);
372     _burn(account, value);
373   }
374 }
375 
376 contract splitableToken is ERC20,Ownable{
377     using SafeMath for uint256;using SafeMath for uint256;
378     address[] private holders;
379     constructor() public{
380         holders.push(msg.sender);
381     }
382     function transfer(address to, uint256 value) public returns (bool) {
383         _addHolder(to);
384         super.transfer(to, value);
385         return true;
386     }
387     function _addHolder(address holder) internal{
388         for(uint i = 0; i < holders.length; i++){
389             if(holders[i] == holder){
390                 return;
391             }
392         }
393         holders.push(holder);
394     }
395     function splitStock(uint splitNumber) public onlyOwner{
396         require(splitNumber > 1);
397         for(uint i = 0; i < holders.length; i++){
398             uint sendingAmount = _balances[holders[i]].mul(splitNumber.sub(1));
399             _balances[holders[i]] = _balances[holders[i]].mul(splitNumber);
400             emit Transfer(address(this),holders[i],sendingAmount);
401         }
402         _totalSupply = _totalSupply.mul(splitNumber);
403     }
404 }
405 
406 contract ERC20BasicInterface {
407     function totalSupply() public view returns (uint256);
408     function balanceOf(address who) public view returns (uint256);
409     function transfer(address to, uint256 value) public returns (bool);
410     function transferFrom(address from, address to, uint256 value) public returns (bool);
411     event Transfer(address indexed from, address indexed to, uint256 value);
412 
413     uint8 public decimals;
414 }
415 
416 
417 contract HBToken is splitableToken{
418   uint8 public decimals = 0;
419   string public name = "HB TEST D0";
420   string public symbol = "HBD0";
421   bool public locked = false;
422   constructor() public {
423      uint _initialSupply = 10000000;
424      _balances[msg.sender] = _initialSupply;
425      _totalSupply = _initialSupply;
426      emit Transfer(address(this),msg.sender,_initialSupply);
427   }
428 
429    // This is a modifier whether transfering token is available or not
430     modifier isValidTransfer() {
431         require(!locked);
432         _;
433     }
434     function transfer(address to, uint256 value) public isValidTransfer returns (bool) {
435         return super.transfer(to,value);
436     }
437 
438     /**
439     * @dev Owner can lock the feature to transfer token
440     */
441     function setLocked(bool _locked) onlyOwner public {
442         locked = _locked;
443     }
444 
445     /**
446     * @dev Function someone send ERC20 Token to this contract address
447     */
448     function sendERC20Token (address _tokenAddress, address _to, uint _amount) public onlyOwner{
449         ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);
450         require(token.transfer(_to,_amount));
451     }
452 
453     /**
454     * @dev Function someone send Ether to this contract address
455     */
456     function sendEther (address _to, uint _amount) public onlyOwner{
457         _to.transfer(_amount);
458     }
459 }