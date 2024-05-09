1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title MultiOwnable
213  */
214 contract MultiOwnable {
215   address public root;
216   mapping (address => address) public owners; // owner => parent of owner
217   
218   /**
219   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
220   * account.
221   */
222   constructor() public {
223     root = msg.sender;
224     owners[root] = root;
225   }
226   
227   /**
228   * @dev Throws if called by any account other than the owner.
229   */
230   modifier onlyOwner() {
231     require(owners[msg.sender] != 0);
232     _;
233   }
234   
235   /**
236   * @dev Adding new owners
237   */
238   function newOwner(address _owner) onlyOwner external returns (bool) {
239     require(_owner != 0);
240     owners[_owner] = msg.sender;
241     return true;
242   }
243   
244   /**
245     * @dev Deleting owners
246     */
247   function deleteOwner(address _owner) onlyOwner external returns (bool) {
248     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
249     owners[_owner] = 0;
250     return true;
251   }
252 }
253 
254 
255 /**
256  * @title Burnable Token
257  * @dev Token that can be irreversibly burned (destroyed).
258  */
259 contract BurnableToken is BasicToken {
260 
261   event Burn(address indexed burner, uint256 value);
262 
263   /**
264    * @dev Burns a specific amount of tokens.
265    * @param _value The amount of token to be burned.
266    */
267   function burn(uint256 _value) public {
268     _burn(msg.sender, _value);
269   }
270 
271   function _burn(address _who, uint256 _value) internal {
272     require(_value <= balances[_who]);
273     // no need to require value <= totalSupply, since that would imply the
274     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
275 
276     balances[_who] = balances[_who].sub(_value);
277     totalSupply_ = totalSupply_.sub(_value);
278     emit Burn(_who, _value);
279     emit Transfer(_who, address(0), _value);
280   }
281 }
282 
283 
284 /**
285  * @title Basic token
286  * @dev Basic version of StandardToken, with no allowances.
287  */
288 contract Blacklisted is MultiOwnable {
289 
290   mapping(address => bool) public blacklist;
291 
292   /**
293   * @dev Throws if called by any account other than the owner.
294   */
295   modifier notBlacklisted() {
296     require(blacklist[msg.sender] == false);
297     _;
298   }
299 
300   /**
301    * @dev Adds single address to blacklist.
302    * @param _villain Address to be added to the blacklist
303    */
304   function addToBlacklist(address _villain) external onlyOwner {
305     blacklist[_villain] = true;
306   }
307 
308   /**
309    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
310    * @param _villains Addresses to be added to the blacklist
311    */
312   function addManyToBlacklist(address[] _villains) external onlyOwner {
313     for (uint256 i = 0; i < _villains.length; i++) {
314       blacklist[_villains[i]] = true;
315     }
316   }
317 
318   /**
319    * @dev Removes single address from blacklist.
320    * @param _villain Address to be removed to the blacklist
321    */
322   function removeFromBlacklist(address _villain) external onlyOwner {
323     blacklist[_villain] = false;
324   }
325 }
326 
327 
328 /**
329  * @title Mintable token
330  * @dev Simple ERC20 Token example, with mintable token creation
331  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
332  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
333  */
334 contract MintableToken is StandardToken, MultiOwnable {
335   event Mint(address indexed to, uint256 amount);
336   event MintFinished();
337 
338   bool public mintingFinished = false;
339 
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     totalSupply_ = totalSupply_.add(_amount);
354     balances[_to] = balances[_to].add(_amount);
355     emit Mint(_to, _amount);
356     emit Transfer(address(0), _to, _amount);
357     return true;
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() onlyOwner canMint public returns (bool) {
365     mintingFinished = true;
366     emit MintFinished();
367     return true;
368   }
369 }
370 
371 
372 /**
373  * @title HUMToken
374  * @dev ERC20 HUMToken.
375  * Note they can later distribute these tokens as they wish using `transfer` and other
376  * `StandardToken` functions.
377  */
378 contract HUMToken is MintableToken, BurnableToken, Blacklisted {
379 
380   string public constant name = "HUMToken"; // solium-disable-line uppercase
381   string public constant symbol = "HUM"; // solium-disable-line uppercase
382   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
383 
384   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
385 
386   bool public isUnlocked = false;
387   
388   /**
389    * @dev Constructor that gives msg.sender all of existing tokens.
390    */
391   constructor(address _wallet) public {
392     totalSupply_ = INITIAL_SUPPLY;
393     balances[_wallet] = INITIAL_SUPPLY;
394     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
395   }
396 
397   modifier onlyTransferable() {
398     require(isUnlocked || owners[msg.sender] != 0);
399     _;
400   }
401 
402   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
403       return super.transferFrom(_from, _to, _value);
404   }
405 
406   function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
407       return super.transfer(_to, _value);
408   }
409   
410   function unlockTransfer() public onlyOwner {
411       isUnlocked = true;
412   }
413   
414   function lockTransfer() public onlyOwner {
415       isUnlocked = false;
416   }
417 
418 }