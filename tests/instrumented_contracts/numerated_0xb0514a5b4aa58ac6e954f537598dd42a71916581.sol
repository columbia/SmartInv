1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 /**
73  * @title Standard ERC20 token
74  *
75  * @dev Implementation of the basic standard token.
76  * @dev https://github.com/ethereum/EIPs/issues/20
77  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83 
84   /**
85    * @dev Transfer tokens from one address to another
86    * @param _from address The address which you want to send tokens from
87    * @param _to address The address which you want to transfer to
88    * @param _value uint256 the amount of tokens to be transferred
89    */
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     emit Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   /**
103    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
104    *
105    * Beware that changing an allowance with this method brings the risk that someone may use both the old
106    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
107    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
108    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109    * @param _spender The address which will spend the funds.
110    * @param _value The amount of tokens to be spent.
111    */
112   function approve(address _spender, uint256 _value) public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     emit Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) public view returns (uint256) {
125     return allowed[_owner][_spender];
126   }
127 
128   /**
129    * @dev Increase the amount of tokens that an owner allowed to a spender.
130    *
131    * approve should be called when allowed[_spender] == 0. To increment
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    * @param _spender The address which will spend the funds.
136    * @param _addedValue The amount of tokens to increase the allowance by.
137    */
138   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144   /**
145    * @dev Decrease the amount of tokens that an owner allowed to a spender.
146    *
147    * approve should be called when allowed[_spender] == 0. To decrement
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * From MonolithDAO Token.sol
151    * @param _spender The address which will spend the funds.
152    * @param _subtractedValue The amount of tokens to decrease the allowance by.
153    */
154   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
155     uint oldValue = allowed[msg.sender][_spender];
156     if (_subtractedValue > oldValue) {
157       allowed[msg.sender][_spender] = 0;
158     } else {
159       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160     }
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165 }
166 
167 
168 /**
169  * @title MultiOwnable
170  */
171 contract MultiOwnable {
172   address public root;
173   mapping (address => address) public owners; // owner => parent of owner
174   
175   /**
176   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177   * account.
178   */
179   constructor() public {
180     root = msg.sender;
181     owners[root] = root;
182   }
183   
184   /**
185   * @dev Throws if called by any account other than the owner.
186   */
187   modifier onlyOwner() {
188     require(owners[msg.sender] != 0);
189     _;
190   }
191   
192   /**
193   * @dev Adding new owners
194   */
195   function newOwner(address _owner) onlyOwner external returns (bool) {
196     require(_owner != 0);
197     require(owners[_owner] == 0);
198     owners[_owner] = msg.sender;
199     return true;
200   }
201   
202   /**
203     * @dev Deleting owners
204     */
205   function deleteOwner(address _owner) onlyOwner external returns (bool) {
206     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
207     owners[_owner] = 0;
208     return true;
209   }
210 }
211 
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 contract MintableToken is StandardToken, MultiOwnable {
220   event Mint(address indexed to, uint256 amount);
221   event MintFinished();
222 
223   bool public mintingFinished = false;
224 
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will receive the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
238     totalSupply_ = totalSupply_.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     emit Mint(_to, _amount);
241     emit Transfer(address(0), _to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() onlyOwner canMint public returns (bool) {
250     mintingFinished = true;
251     emit MintFinished();
252     return true;
253   }
254 }
255 
256 
257 /**
258  * @title SafeMath
259  * @dev Math operations with safety checks that throw on error
260  */
261 library SafeMath {
262 
263   /**
264   * @dev Multiplies two numbers, throws on overflow.
265   */
266   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267     if (a == 0) {
268       return 0;
269     }
270     uint256 c = a * b;
271     assert(c / a == b);
272     return c;
273   }
274 
275   /**
276   * @dev Integer division of two numbers, truncating the quotient.
277   */
278   function div(uint256 a, uint256 b) internal pure returns (uint256) {
279     // assert(b > 0); // Solidity automatically throws when dividing by 0
280     // uint256 c = a / b;
281     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282     return a / b;
283   }
284 
285   /**
286   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
287   */
288   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289     assert(b <= a);
290     return a - b;
291   }
292 
293   /**
294   * @dev Adds two numbers, throws on overflow.
295   */
296   function add(uint256 a, uint256 b) internal pure returns (uint256) {
297     uint256 c = a + b;
298     assert(c >= a);
299     return c;
300   }
301 }
302 
303 
304 
305 
306 /**
307  * @title Burnable Token
308  * @dev Token that can be irreversibly burned (destroyed).
309  */
310 contract BurnableToken is BasicToken {
311 
312   event Burn(address indexed burner, uint256 value);
313 
314   /**
315    * @dev Burns a specific amount of tokens.
316    * @param _value The amount of token to be burned.
317    */
318   function burn(uint256 _value) public {
319     _burn(msg.sender, _value);
320   }
321 
322   function _burn(address _who, uint256 _value) internal {
323     require(_value <= balances[_who]);
324     // no need to require value <= totalSupply, since that would imply the
325     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
326 
327     balances[_who] = balances[_who].sub(_value);
328     totalSupply_ = totalSupply_.sub(_value);
329     emit Burn(_who, _value);
330     emit Transfer(_who, address(0), _value);
331   }
332 }
333 
334 
335 
336 /**
337  * @title Basic token
338  * @dev Basic version of StandardToken, with no allowances.
339  */
340 contract Blacklisted is MultiOwnable {
341 
342   mapping(address => bool) public blacklist;
343 
344   /**
345   * @dev Throws if called by any account other than the owner.
346   */
347   modifier notBlacklisted() {
348     require(blacklist[msg.sender] == false);
349     _;
350   }
351 
352   /**
353    * @dev Adds single address to blacklist.
354    * @param _villain Address to be added to the blacklist
355    */
356   function addToBlacklist(address _villain) external onlyOwner {
357     blacklist[_villain] = true;
358   }
359 
360   /**
361    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
362    * @param _villains Addresses to be added to the blacklist
363    */
364   function addManyToBlacklist(address[] _villains) external onlyOwner {
365     for (uint256 i = 0; i < _villains.length; i++) {
366       blacklist[_villains[i]] = true;
367     }
368   }
369 
370   /**
371    * @dev Removes single address from blacklist.
372    * @param _villain Address to be removed to the blacklist
373    */
374   function removeFromBlacklist(address _villain) external onlyOwner {
375     blacklist[_villain] = false;
376   }
377 }
378 
379 /**
380  * @title HUMToken
381  * @dev ERC20 HUMToken.
382  * Note they can later distribute these tokens as they wish using `transfer` and other
383  * `StandardToken` functions.
384  */
385 contract HUMToken is MintableToken, BurnableToken, Blacklisted {
386 
387   string public constant name = "HUMToken"; // solium-disable-line uppercase
388   string public constant symbol = "HUM"; // solium-disable-line uppercase
389   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
390 
391   uint256 public constant INITIAL_SUPPLY = 125000 * 1000 * 1000 * (10 ** uint256(decimals)); // 125,000,000,000 HUM
392 
393   bool public isUnlocked = false;
394   
395   /**
396    * @dev Constructor that gives msg.sender all of existing tokens.
397    */
398   constructor(address _wallet) public {
399     totalSupply_ = INITIAL_SUPPLY;
400     balances[_wallet] = INITIAL_SUPPLY;
401     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
402   }
403 
404   modifier onlyTransferable() {
405     require(isUnlocked || owners[msg.sender] != 0);
406     _;
407   }
408 
409   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
410       return super.transferFrom(_from, _to, _value);
411   }
412 
413   function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
414       return super.transfer(_to, _value);
415   }
416   
417   function unlockTransfer() public onlyOwner {
418       isUnlocked = true;
419   }
420   
421   function lockTransfer() public onlyOwner {
422       isUnlocked = false;
423   }
424 
425 }