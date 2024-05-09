1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   function totalSupply() public constant returns (uint);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev Fix for the ERC20 short address attack.
71   */
72   modifier onlyPayloadSize(uint size) {
73       require(!(msg.data.length < (size * 32 + 4)));
74       _;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     emit Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135   * @param _spender The address which will spend the funds.
136   * @param _value The amount of tokens to be spent.
137   */
138   function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool) {
139     // To change the approve amount you first have to reduce the addresses`
140     //  allowance to zero by calling `approve(_spender, 0)` if it is not
141     //  already 0 to mitigate the race condition described here:
142     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
144 
145     allowed[msg.sender][_spender] = _value;
146     emit Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 }
160 
161 
162 contract UpgradedStandardToken is StandardToken {
163   // those methods are called by the legacy contract
164   // and they must ensure msg.sender to be the contract address
165   uint public _totalSupply;
166   function transferByLegacy(address from, address to, uint value) public returns (bool);
167   function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
168   function approveByLegacy(address from, address spender, uint value) public returns (bool);
169 }
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181   /**
182    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183    * account.
184    */
185   constructor() public {
186     owner = msg.sender;
187   }
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     require(msg.sender == owner);
194     _;
195   }
196 
197   /**
198    * @dev Allows the current owner to transfer control of the contract to a newOwner.
199    * @param newOwner The address to transfer ownership to.
200    */
201   function transferOwnership(address newOwner) public onlyOwner {
202     require(newOwner != address(0));
203     emit OwnershipTransferred(owner, newOwner);
204     owner = newOwner;
205   }
206 }
207 
208 contract StandardTokenWithFees is StandardToken, Ownable {
209 
210   // Additional variables for use if transaction fees ever became necessary
211   uint256 public basisPointsRate = 0;
212   uint256 public maximumFee = 0;
213   uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;
214   uint256 constant MAX_SETTABLE_FEE = 50;
215 
216   string public name;
217   string public symbol;
218   uint8 public decimals;
219   uint public _totalSupply;
220 
221   uint public constant MAX_UINT = 2**256 - 1;
222 
223   function calcFee(uint _value) constant public returns (uint) {
224     uint fee = (_value.mul(basisPointsRate)).div(10000);
225     if (fee > maximumFee) {
226       fee = maximumFee;
227     }
228     return fee;
229   }
230 
231   function transfer(address _to, uint _value) public returns (bool) {
232     uint fee = calcFee(_value);
233     uint sendAmount = _value.sub(fee);
234 
235     super.transfer(_to, sendAmount);
236     if (fee > 0) {
237       super.transfer(owner, fee);
238     }
239   }
240 
241   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
242     require(_to != address(0));
243     require(_value <= balances[_from]);
244     require(_value <= allowed[_from][msg.sender]);
245 
246     uint fee = calcFee(_value);
247     uint sendAmount = _value.sub(fee);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(sendAmount);
251     if (allowed[_from][msg.sender] < MAX_UINT) {
252       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     }
254     emit Transfer(_from, _to, sendAmount);
255     if (fee > 0) {
256       balances[owner] = balances[owner].add(fee);
257       emit Transfer(_from, owner, fee);
258     }
259     return true;
260   }
261 
262   function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
263     // Ensure transparency by hardcoding limit beyond which fees can never be added
264     require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
265     require(newMaxFee < MAX_SETTABLE_FEE);
266 
267     basisPointsRate = newBasisPoints;
268     maximumFee = newMaxFee.mul(uint(10)**decimals);
269 
270     emit Params(basisPointsRate, maximumFee);
271   }
272 
273   // Called if contract ever adds fees
274   event Params(uint feeBasisPoints, uint maxFee);
275 }
276 
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is not paused.
290    */
291   modifier whenNotPaused() {
292     require(!paused);
293     _;
294   }
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is paused.
298    */
299   modifier whenPaused() {
300     require(paused);
301     _;
302   }
303 
304   /**
305    * @dev called by the owner to pause, triggers stopped state
306    */
307   function pause() onlyOwner whenNotPaused public {
308     paused = true;
309     emit Pause();
310   }
311 
312   /**
313    * @dev called by the owner to unpause, returns to normal state
314    */
315   function unpause() onlyOwner whenPaused public {
316     paused = false;
317     emit Unpause();
318   }
319 }
320 
321 
322 contract BlackList is Ownable {
323 
324   // Getter to allow the same blacklist to be used also by other contracts (including upgraded contract)
325   function getBlackListStatus(address _maker) external constant returns (bool) {
326     return isBlackListed[_maker];
327   }
328 
329   mapping (address => bool) public isBlackListed;
330 
331   function addBlackList (address _evilUser) public onlyOwner {
332     isBlackListed[_evilUser] = true;
333     emit AddedBlackList(_evilUser);
334   }
335 
336   function removeBlackList (address _clearedUser) public onlyOwner {
337     isBlackListed[_clearedUser] = false;
338     emit RemovedBlackList(_clearedUser);
339   }
340 
341   event AddedBlackList(address indexed _user);
342 
343   event RemovedBlackList(address indexed _user);
344 }
345 
346 contract ElementiumToken is Pausable, StandardTokenWithFees, BlackList {
347 
348   address public upgradedAddress;
349   bool public deprecated;
350 
351   //  The contract can be initialized with a number of tokens
352   //  All the tokens are deposited to the owner address
353   //
354   // @param _initialSupply Initial supply of the contract
355   // @param _name Token Name
356   // @param _symbol Token symbol
357   // @param _decimals Token decimals
358   constructor(uint _initialSupply, string _name, string _symbol, uint8 _decimals) public {
359     _totalSupply = _initialSupply;
360     name = _name;
361     symbol = _symbol;
362     decimals = _decimals;
363     balances[owner] = _initialSupply;
364     deprecated = false;
365   }
366 
367   // Forward ERC20 methods to upgraded contract if this one is deprecated
368   function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
369     require(!isBlackListed[msg.sender]);
370     if (deprecated) {
371       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
372     } else {
373       return super.transfer(_to, _value);
374     }
375   }
376 
377   // Forward ERC20 methods to upgraded contract if this one is deprecated
378   function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
379     require(!isBlackListed[_from]);
380     if (deprecated) {
381       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
382     } else {
383       return super.transferFrom(_from, _to, _value);
384     }
385   }
386 
387   // Forward ERC20 methods to upgraded contract if this one is deprecated
388   function balanceOf(address who) public constant returns (uint) {
389     if (deprecated) {
390       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
391     } else {
392       return super.balanceOf(who);
393     }
394   }
395 
396   // Allow checks of balance at time of deprecation
397   function oldBalanceOf(address who) public constant returns (uint) {
398     if (deprecated) {
399       return super.balanceOf(who);
400     }
401   }
402 
403   // Forward ERC20 methods to upgraded contract if this one is deprecated
404   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
405     if (deprecated) {
406       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
407     } else {
408       return super.approve(_spender, _value);
409     }
410   }
411 
412   // Forward ERC20 methods to upgraded contract if this one is deprecated
413   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
414     if (deprecated) {
415       return StandardToken(upgradedAddress).allowance(_owner, _spender);
416     } else {
417       return super.allowance(_owner, _spender);
418     }
419   }
420 
421   // Deprecate current contract in favour of a new one
422   function deprecate(address _upgradedAddress) public onlyOwner {
423     require(_upgradedAddress != address(0));
424     deprecated = true;
425     upgradedAddress = _upgradedAddress;
426     emit Deprecate(_upgradedAddress);
427   }
428 
429   // Total amount of token
430   function totalSupply() public constant returns (uint) {
431     if (deprecated) {
432       return StandardToken(upgradedAddress).totalSupply();
433     } else {
434       return _totalSupply;
435     }
436   }
437 
438   // Issue a new amount of tokens
439   // these tokens are deposited into the owner address
440   //
441   // @param _amount Number of tokens to be issued
442   function issue(uint amount) public onlyOwner {
443     balances[owner] = balances[owner].add(amount);
444     _totalSupply = _totalSupply.add(amount);
445     emit Issue(amount);
446     emit Transfer(address(0), owner, amount);
447   }
448 
449   // Redeem tokens.
450   // These tokens are withdrawn from the owner address
451   // if the balance must be enough to cover the redeem
452   // or the call will fail.
453   // @param _amount Number of tokens to be issued
454   function redeem(uint amount) public onlyOwner {
455     _totalSupply = _totalSupply.sub(amount);
456     balances[owner] = balances[owner].sub(amount);
457     emit Redeem(amount);
458     emit Transfer(owner, address(0), amount);
459   }
460 
461   function destroyBlackFunds (address _blackListedUser) public onlyOwner {
462     require(isBlackListed[_blackListedUser]);
463     uint dirtyFunds = balanceOf(_blackListedUser);
464     balances[_blackListedUser] = 0;
465     _totalSupply = _totalSupply.sub(dirtyFunds);
466     emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
467   }
468 
469   event DestroyedBlackFunds(address indexed _blackListedUser, uint _balance);
470 
471   // Called when new token are issued
472   event Issue(uint amount);
473 
474   // Called when tokens are redeemed
475   event Redeem(uint amount);
476 
477   // Called when contract is deprecated
478   event Deprecate(address newAddress);
479 }