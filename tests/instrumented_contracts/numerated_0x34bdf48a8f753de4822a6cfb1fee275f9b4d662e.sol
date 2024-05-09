1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal pure returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal pure returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal pure returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) constant public returns (uint);
59   function transfer(address to, uint value) public;
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint;
70 
71   mapping(address => uint) balances;
72 
73   /**
74    * @dev Fix for the ERC20 short address attack.
75    */
76   modifier onlyPayloadSize(uint size) {
77      assert(msg.data.length >= size + 4);
78      _;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  public {
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) constant public returns (uint balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant  public returns (uint);
110   function transferFrom(address from, address to, uint value)  public;
111   function approve(address spender, uint value)  public;
112   event Approval(address indexed owner, address indexed spender, uint value);
113 }
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implemantation of the basic standart token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is BasicToken, ERC20 {
124 
125   mapping (address => mapping (address => uint)) allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)  public {
135     uint _allowance;
136     _allowance = allowed[_from][msg.sender];
137 
138     require(_allowance >= _value);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     emit Transfer(_from, _to, _value);
144   }
145 
146   /**
147    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint _value)  public {
152 
153     // To change the approve amount you first have to reduce the addresses`
154     //  allowance to zero by calling `approve(_spender, 0)` if it is not
155     //  already 0 to mitigate the race condition described here:
156     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
158 
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens than an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint specifing the amount of tokens still avaible for the spender.
168    */
169   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173 }
174 
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   constructor()  public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner  public {
208     if (newOwner != address(0)) {
209       owner = newOwner;
210     }
211   }
212 
213 }
214 
215 
216 /**
217  * @title Mintable token
218  * @dev Simple ERC20 Token example, with mintable token creation
219  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
220  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
221  */
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint value);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228   uint public totalSupply = 0;
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will recieve the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint _amount) onlyOwner canMint  public returns (bool) {
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     emit Mint(_to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner  public returns (bool) {
253     mintingFinished = true;
254     emit MintFinished();
255     return true;
256   }
257 }
258 
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Ownable {
265   event Pause();
266   event Unpause();
267 
268   bool public paused = false;
269 
270 
271   /**
272    * @dev modifier to allow actions only when the contract IS paused
273    */
274   modifier whenNotPaused() {
275     // if (paused) throw;
276     require(!paused);
277     _;
278   }
279 
280   /**
281    * @dev modifier to allow actions only when the contract IS NOT paused
282    */
283   modifier whenPaused {
284     require(paused);
285     _;
286   }
287 
288   /**
289    * @dev called by the owner to pause, triggers stopped state
290    */
291   function pause() onlyOwner whenNotPaused  public returns (bool) {
292     paused = true;
293     emit Pause();
294     return true;
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused  public returns (bool) {
301     paused = false;
302     emit Unpause();
303     return true;
304   }
305 }
306 
307 
308 /**
309  * Pausable token
310  *
311  * Simple ERC20 Token example, with pausable token creation
312  **/
313 
314 contract PausableToken is StandardToken, Pausable {
315 
316   function transfer(address _to, uint _value) whenNotPaused  public {
317     super.transfer(_to, _value);
318   }
319 
320   function transferFrom(address _from, address _to, uint _value) whenNotPaused  public {
321     super.transferFrom(_from, _to, _value);
322   }
323 }
324 
325 
326 /**
327  * @title TokenTimelock
328  * @dev TokenTimelock is a token holder contract that will allow a
329  * beneficiary to extract the tokens after a time has passed
330  */
331 contract TokenTimelock {
332 
333   // ERC20 basic token contract being held
334   ERC20Basic token;
335 
336   // beneficiary of tokens after they are released
337   address public beneficiary;
338 
339   // timestamp where token release is enabled
340   uint public releaseTime;
341 
342   constructor(ERC20Basic _token, address _beneficiary, uint _releaseTime)  public {
343     require(_releaseTime > now);
344     token = _token;
345     beneficiary = _beneficiary;
346     releaseTime = _releaseTime;
347   }
348 
349   /**
350    * @dev beneficiary claims tokens held by time lock
351    */
352   function claim()  public {
353     require(msg.sender == beneficiary);
354     require(now >= releaseTime);
355 
356     uint amount = token.balanceOf(this);
357     require(amount > 0);
358 
359     token.transfer(beneficiary, amount);
360   }
361 }
362 
363 
364 /**
365  * @title BKC Token
366  * @dev BKC Token contract
367  */
368 contract BKCToken is PausableToken, MintableToken {
369   using SafeMath for uint256;
370 
371   string public name = "BKC Token";
372   string public symbol = "BKC";
373   uint public decimals = 18;
374 
375   /**
376    * @dev mint timelocked tokens
377    */
378   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public
379     onlyOwner canMint returns (TokenTimelock) {
380 
381     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
382     mint(timelock, _amount);
383 
384     return timelock;
385   }
386 
387   mapping (address => string) public  keys;
388   event LogRegister (address user, string key);
389   // Value should be a public key.  Read full key import policy.
390   // Manually registering requires a base58
391   // encoded using the STEEM, BTS, or EOS public key format.
392   function register(string key) public {
393       assert(bytes(key).length <= 64);
394       keys[msg.sender] = key;
395       emit LogRegister(msg.sender, key);
396     }
397 
398   // If the user transfers ETH to contract, it will revert
399   function () public payable{ revert(); }
400 }