1 pragma solidity ^0.4.24;
2 
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
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
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
67 
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = 0x6C25AbD85AD13Bea51Ae93D04d89Af87475a961C;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 interface IERC20 {
139   function totalSupply() external view returns (uint256);
140 
141   function balanceOf(address _who) external view returns (uint256);
142 
143   function allowance(address _owner, address _spender)
144     external view returns (uint256);
145 
146   function transfer(address _to, uint256 _value) external returns (bool);
147 
148   function approve(address _spender, uint256 _value)
149     external returns (bool);
150 
151   function transferFrom(address _from, address _to, uint256 _value)
152     external returns (bool);
153 
154   event Transfer(
155     address indexed from,
156     address indexed to,
157     uint256 value
158   );
159 
160   event Approval(
161     address indexed owner,
162     address indexed spender,
163     uint256 value
164   );
165 }
166 
167 
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
174  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract ERC20 is IERC20, Ownable {
177   using SafeMath for uint256;
178 
179   mapping (address => uint256) private balances_;
180 
181   mapping (address => mapping (address => uint256)) private allowed_;
182   
183   uint256 private totalSupply_;
184   uint256 public tokensSold;
185   
186   address public fundsWallet = 0x1defDc87eF32479928eeB933891907Fb56818821;
187   
188   constructor() public {
189       totalSupply_ = 10000000000e18;
190       balances_[address(this)] = 10000000000e18;
191       emit Transfer(address(0), address(this), totalSupply_);
192       tokensSold = 0;
193   }
194 
195 
196   /**
197   * @dev Total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances_[_owner];
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed_[_owner][_spender];
227   }
228 
229   /**
230   * @dev Transfer token for a specified address
231   * @param _to The address to transfer to.
232   * @param _value The amount to be transferred.
233   */
234   function transfer(address _to, uint256 _value) public returns (bool) {
235     require(_value <= balances_[msg.sender]);
236     require(_to != address(0));
237 
238     balances_[msg.sender] = balances_[msg.sender].sub(_value);
239     balances_[_to] = balances_[_to].add(_value);
240     emit Transfer(msg.sender, _to, _value);
241     return true;
242   }
243   
244   
245   /**
246    * Allows the owner to withdraw XPI tokens from the contract
247    * @param _value The total amount of tokens to be withdrawn
248    * @return true if function executes successfully, false otherwise
249    * */
250   function withdrawXPI(uint256 _value) public onlyOwner returns(bool){
251     require(_value <= balances_[address(this)]);
252     balances_[owner] = balances_[owner].add(_value);
253     balances_[address(this)] = balances_[address(this)].sub(_value);
254     emit Transfer(address(this), owner, _value);
255     return true;
256   }
257   
258   
259   /**
260    * Enables investors to purchase XPI tokens by simply sending ETH 
261    * to the contract address.
262    * */
263   function() public payable {
264       buyTokens(msg.sender);
265   }
266   
267 
268   function buyTokens(address _investor) public payable returns(bool) {
269     require(_investor != address(0));
270     require(msg.value >= 5e15 && msg.value <= 5e18);
271     require(tokensSold < 6000000000e18);
272     uint256 XPiToTransfer = msg.value.mul(20000000);
273     if(msg.value < 5e16) {
274         dispatchTokens(_investor, XPiToTransfer);
275         return true;
276     } else if(msg.value < 1e17) {
277         XPiToTransfer = XPiToTransfer.add((XPiToTransfer.mul(20)).div(100));
278         dispatchTokens(_investor, XPiToTransfer);
279         return true;
280     } else if(msg.value < 5e17) {
281         XPiToTransfer = XPiToTransfer.add((XPiToTransfer.mul(30)).div(100));
282         dispatchTokens(_investor, XPiToTransfer);
283         return true;
284     } else if(msg.value < 1e18) {
285         XPiToTransfer = XPiToTransfer.add((XPiToTransfer.mul(50)).div(100));
286         dispatchTokens(_investor, XPiToTransfer);
287         return true;
288     } else if(msg.value >= 1e18) {
289         XPiToTransfer = XPiToTransfer.mul(2);
290         dispatchTokens(_investor, XPiToTransfer);
291         return true;
292     }
293   }
294   
295   function dispatchTokens(address _investor, uint256 _XPiToTransfer) internal {
296       balances_[address(this)] = balances_[address(this)].sub(_XPiToTransfer);
297       balances_[_investor] = balances_[_investor].add(_XPiToTransfer);
298       emit Transfer(address(this), _investor, _XPiToTransfer);
299       tokensSold = tokensSold.add(_XPiToTransfer);
300       fundsWallet.transfer(msg.value);
301   }
302   
303 
304   /**
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed_[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Transfer tokens from one address to another
321    * @param _from address The address which you want to send tokens from
322    * @param _to address The address which you want to transfer to
323    * @param _value uint256 the amount of tokens to be transferred
324    */
325   function transferFrom(
326     address _from,
327     address _to,
328     uint256 _value
329   )
330     public
331     returns (bool)
332   {
333     require(_value <= balances_[_from]);
334     require(_value <= allowed_[_from][msg.sender]);
335     require(_to != address(0));
336 
337     balances_[_from] = balances_[_from].sub(_value);
338     balances_[_to] = balances_[_to].add(_value);
339     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
340     emit Transfer(_from, _to, _value);
341     return true;
342   }
343 
344   /**
345    * @dev Increase the amount of tokens that an owner allowed to a spender.
346    * approve should be called when allowed_[_spender] == 0. To increment
347    * allowed value is better to use this function to avoid 2 calls (and wait until
348    * the first transaction is mined)
349    * From MonolithDAO Token.sol
350    * @param _spender The address which will spend the funds.
351    * @param _addedValue The amount of tokens to increase the allowance by.
352    */
353   function increaseApproval(
354     address _spender,
355     uint256 _addedValue
356   )
357     public
358     returns (bool)
359   {
360     allowed_[msg.sender][_spender] = (
361       allowed_[msg.sender][_spender].add(_addedValue));
362     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
363     return true;
364   }
365 
366   /**
367    * @dev Decrease the amount of tokens that an owner allowed to a spender.
368    * approve should be called when allowed_[_spender] == 0. To decrement
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _subtractedValue The amount of tokens to decrease the allowance by.
374    */
375   function decreaseApproval(
376     address _spender,
377     uint256 _subtractedValue
378   )
379     public
380     returns (bool)
381   {
382     uint256 oldValue = allowed_[msg.sender][_spender];
383     if (_subtractedValue >= oldValue) {
384       allowed_[msg.sender][_spender] = 0;
385     } else {
386       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
387     }
388     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
389     return true;
390   }
391 
392 
393   /**
394    * @dev Internal function that burns an amount of the token of a given
395    * account.
396    * @param _account The account whose tokens will be burnt.
397    * @param _amount The amount that will be burnt.
398    */
399   function _burn(address _account, uint256 _amount) internal {
400     require(_account != 0);
401     require(_amount <= balances_[_account]);
402 
403     totalSupply_ = totalSupply_.sub(_amount);
404     balances_[_account] = balances_[_account].sub(_amount);
405     emit Transfer(_account, address(0), _amount);
406   }
407 
408   /**
409    * @dev Internal function that burns an amount of the token of a given
410    * account, deducting from the sender's allowance for said account. Uses the
411    * internal _burn function.
412    * @param _account The account whose tokens will be burnt.
413    * @param _amount The amount that will be burnt.
414    */
415   function _burnFrom(address _account, uint256 _amount) internal {
416     require(_amount <= allowed_[_account][msg.sender]);
417 
418     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
419     // this function needs to emit an event with the updated approval.
420     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
421       _amount);
422     _burn(_account, _amount);
423   }
424 }
425 
426 
427 
428 /**
429  * @title Burnable Token
430  * @dev Token that can be irreversibly burned (destroyed).
431  */
432 contract ERC20Burnable is ERC20 {
433 
434   event TokensBurned(address indexed burner, uint256 value);
435 
436   /**
437    * @dev Burns a specific amount of tokens.
438    * @param _value The amount of token to be burned.
439    */
440   function burn(uint256 _value) public {
441     _burn(msg.sender, _value);
442   }
443 
444   /**
445    * @dev Burns a specific amount of tokens from the target address and decrements allowance
446    * @param _from address The address which you want to send tokens from
447    * @param _value uint256 The amount of token to be burned
448    */
449   function burnFrom(address _from, uint256 _value) public {
450     _burnFrom(_from, _value);
451   }
452 
453   /**
454    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
455    * an additional Burn event.
456    */
457   function _burn(address _who, uint256 _value) internal {
458     super._burn(_who, _value);
459     emit TokensBurned(_who, _value);
460   }
461 }
462 
463 
464 contract XPiBlock is ERC20Burnable {
465     
466     string public name;
467     string public symbol;
468     uint8 public decimals;
469     
470     constructor() public {
471         name = "XPiBlock";
472         symbol = "XPI";
473         decimals = 18;
474     }
475 }