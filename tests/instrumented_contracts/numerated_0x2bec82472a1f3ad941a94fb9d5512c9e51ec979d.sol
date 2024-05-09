1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     c = _a * _b;
83     assert(c / _a == _b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     // assert(_b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = _a / _b;
93     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
94     return _a / _b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
101     assert(_b <= _a);
102     return _a - _b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
109     c = _a + _b;
110     assert(c >= _a);
111     return c;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) internal balances;
136 
137   uint256 internal totalSupply_;
138 
139   /**
140   * @dev Total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return totalSupply_;
144   }
145 
146   /**
147   * @dev Transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_value <= balances[msg.sender]);
153     require(_to != address(0));
154 
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     emit Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param _owner The address to query the the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address _owner) public view returns (uint256) {
167     return balances[_owner];
168   }
169 
170 }
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address _owner, address _spender)
178     public view returns (uint256);
179 
180   function transferFrom(address _from, address _to, uint256 _value)
181     public returns (bool);
182 
183   function approve(address _spender, uint256 _value) public returns (bool);
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * https://github.com/ethereum/EIPs/issues/20
196  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(
210     address _from,
211     address _to,
212     uint256 _value
213   )
214     public
215     returns (bool)
216   {
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219     require(_to != address(0));
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(
250     address _owner,
251     address _spender
252    )
253     public
254     view
255     returns (uint256)
256   {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint256 _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(
292     address _spender,
293     uint256 _subtractedValue
294   )
295     public
296     returns (bool)
297   {
298     uint256 oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue >= oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 
311 /**
312  * @title DividendDistributingToken
313  * @dev An ERC20-compliant token that distributes any Ether it receives to its token holders proportionate to their share.
314  *
315  * Implementation exactly based on: https://blog.pennyether.com/posts/realtime-dividend-token.html#the-token
316  *
317  * The user is responsible for when they transact tokens (transacting before a dividend payout is probably not ideal).
318  *
319  * `TokenizedProperty` inherits from `this` and is the front-facing contract representing the rights / ownership to a property.
320  */
321 contract DividendDistributingToken is StandardToken {
322   using SafeMath for uint256;
323 
324   uint256 public constant POINTS_PER_WEI = uint256(10) ** 32;
325 
326   uint256 public pointsPerToken = 0;
327   mapping(address => uint256) public credits;
328   mapping(address => uint256) public lastPointsPerToken;
329 
330   event DividendsDeposited(address indexed payer, uint256 amount);
331   event DividendsCollected(address indexed collector, uint256 amount);
332 
333   function collectOwedDividends() public {
334     creditAccount(msg.sender);
335 
336     uint256 _wei = credits[msg.sender] / POINTS_PER_WEI;
337 
338     credits[msg.sender] = 0;
339 
340     msg.sender.transfer(_wei);
341     emit DividendsCollected(msg.sender, _wei);
342   }
343 
344   function creditAccount(address _account) internal {
345     uint256 amount = balanceOf(_account).mul(pointsPerToken.sub(lastPointsPerToken[_account]));
346     credits[_account] = credits[_account].add(amount);
347     lastPointsPerToken[_account] = pointsPerToken;
348   }
349 
350   function deposit(uint256 _value) internal {
351     pointsPerToken = pointsPerToken.add(_value.mul(POINTS_PER_WEI) / totalSupply_);
352     emit DividendsDeposited(msg.sender, _value);
353   }
354 }
355 
356 
357 
358 contract LandRegistryInterface {
359   function getProperty(string _eGrid) public view returns (address property);
360 }
361 
362 
363 contract LandRegistryProxyInterface {
364   function owner() public view returns (address);
365   function landRegistry() public view returns (LandRegistryInterface);
366 }
367 
368 
369 contract WhitelistInterface {
370   function checkRole(address _operator, string _permission) public view;
371 }
372 
373 
374 contract WhitelistProxyInterface {
375   function whitelist() public view returns (WhitelistInterface);
376 }
377 
378 
379 /**
380  * @title TokenizedProperty
381  * @dev An asset-backed security token (a property as identified by its E-GRID (a UUID) in the (Swiss) land registry).
382  *
383  * Ownership of `this` must be transferred to `ShareholderDAO` before blockimmo will verify `this` as legitimate in `LandRegistry`.
384  * Until verified legitimate, transferring tokens is not possible (locked).
385  *
386  * Tokens can be freely listed on exchanges (especially decentralized / 0x).
387  *
388  * `this.owner` can make two suggestions that blockimmo will always (try) to take: `setManagementCompany` and `untokenize`.
389  * `this.owner` can also transfer or rescind ownership.
390  * See `ShareholderDAO` documentation for more information...
391  *
392  * Our legal framework requires a `TokenizedProperty` must be possible to `untokenize`.
393  * Un-tokenizing is also the first step to upgrading or an outright sale of `this`.
394  *
395  * For both:
396  *   1. `owner` emits an `UntokenizeRequest`
397  *   2. blockimmo removes `this` from the `LandRegistry`
398  *
399  * Upgrading:
400  *   3. blockimmo migrates `this` to the new `TokenizedProperty` (ie perfectly preserving `this.balances`)
401  *   4. blockimmo attaches `owner` to the property (1)
402  *   5. blockimmo adds the property to `LandRegistry`
403  *
404  * Outright sale:
405  *   3. blockimmo deploys a new `TokenizedProperty` and adds it to the `LandRegistry`
406  *   4. blockimmo configures and deploys a `TokenSale` for the property with `TokenSale.wallet == address(this)`
407  *      (raised Ether distributed to current token holders as a dividend payout)
408  *        - if the sale is unsuccessful, the new property is removed from the `LandRegistry`, and `this` is added back
409  */
410 contract TokenizedProperty is Ownable, DividendDistributingToken {
411   address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0xec8be1a5630364292e56d01129e8ee8a9578d7d8
412   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xc4c7497fbe1a886841a195a5d622cd60053c1376;
413 
414   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
415   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
416 
417   uint8 public constant decimals = 18;
418   uint256 public constant NUM_TOKENS = 1000000;
419   string public symbol;
420 
421   string public managementCompany;
422   string public name;
423 
424   mapping(address => uint256) public lastTransferBlock;
425   mapping(address => uint256) public minTransferAccepted;
426 
427   event MinTransferSet(address indexed account, uint256 minTransfer);
428   event ManagementCompanySet(string managementCompany);
429   event UntokenizeRequest();
430   event Generic(string generic);
431 
432   modifier isValid() {
433     LandRegistryInterface registry = LandRegistryInterface(registryProxy.landRegistry());
434     require(registry.getProperty(name) == address(this), "invalid TokenizedProperty");
435     _;
436   }
437 
438   constructor(string _eGrid, string _grundstuckNumber) public {
439     require(bytes(_eGrid).length > 0, "eGrid must be non-empty string");
440     require(bytes(_grundstuckNumber).length > 0, "grundstuck must be non-empty string");
441     name = _eGrid;
442     symbol = _grundstuckNumber;
443 
444     totalSupply_ = NUM_TOKENS * (uint256(10) ** decimals);
445     balances[msg.sender] = totalSupply_;
446     emit Transfer(address(0), msg.sender, totalSupply_);
447   }
448 
449   function () public payable {  // dividends
450     uint256 value = msg.value;
451     require(value > 0, "must send wei in fallback");
452 
453     address blockimmo = registryProxy.owner();
454     if (blockimmo != address(0)) {  // 1% blockimmo fee
455       uint256 fee = value / 100;
456       blockimmo.transfer(fee);
457       value = value.sub(fee);
458     }
459 
460     deposit(value);
461   }
462 
463   function setManagementCompany(string _managementCompany) public onlyOwner isValid {
464     managementCompany = _managementCompany;
465     emit ManagementCompanySet(managementCompany);
466   }
467 
468   function untokenize() public onlyOwner isValid {
469     emit UntokenizeRequest();
470   }
471 
472   function emitGenericProposal(string _generic) public onlyOwner isValid {
473     emit Generic(_generic);
474   }
475 
476   function transfer(address _to, uint256 _value) public isValid returns (bool) {
477     require(_value >= minTransferAccepted[_to], "tokens transferred less than _to's minimum accepted transfer");
478     transferBookKeeping(msg.sender, _to);
479     return super.transfer(_to, _value);
480   }
481 
482   function transferFrom(address _from, address _to, uint256 _value) public isValid returns (bool) {
483     require(_value >= minTransferAccepted[_to], "tokens transferred less than _to's minimum accepted transfer");
484     transferBookKeeping(_from, _to);
485     return super.transferFrom(_from, _to, _value);
486   }
487 
488   function setMinTransfer(uint256 _amount) public {
489     minTransferAccepted[msg.sender] = _amount;
490     emit MinTransferSet(msg.sender, _amount);
491   }
492 
493   function transferBookKeeping(address _from, address _to) internal {
494     whitelistProxy.whitelist().checkRole(_to, "authorized");
495 
496     creditAccount(_from);  // required for dividends...
497     creditAccount(_to);
498 
499     lastTransferBlock[_from] = block.number;  //required for voting
500     lastTransferBlock[_to] = block.number;
501   }
502 }