1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20Basic {
56   uint public totalSupply;
57   function balanceOf(address who) constant public returns (uint);
58   function transfer(address to, uint value) public;
59   event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint;
69 
70   mapping(address => uint) balances;
71 
72   /**
73    * @dev Fix for the ERC20 short address attack.
74    */
75   modifier onlyPayloadSize(uint size) {
76      assert(msg.data.length >= size + 4);
77      //if(msg.data.length < size + 4) {
78      //  throw;
79      //}
80      _;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  public {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) constant public returns (uint balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant  public returns (uint);
112   function transferFrom(address from, address to, uint value)  public;
113   function approve(address spender, uint value)  public;
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)  public {
137     uint _allowance;
138     _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // if (_value > _allowance) throw;
142     require(_allowance >= _value);
143 
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(_from, _to, _value);
148   }
149 
150   /**
151    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint _value)  public {
156 
157     // To change the approve amount you first have to reduce the addresses`
158     //  allowance to zero by calling `approve(_spender, 0)` if it is not
159     //  already 0 to mitigate the race condition described here:
160     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     // if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
162     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
163 
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens than an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint specifing the amount of tokens still avaible for the spender.
173    */
174   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
175     return allowed[_owner][_spender];
176   }
177 
178 }
179 
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   constructor()  public {
195     owner = msg.sender;
196   }
197 
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) onlyOwner  public {
213     if (newOwner != address(0)) {
214       owner = newOwner;
215     }
216   }
217 
218 }
219 
220 
221 /**
222  * @title Mintable token
223  * @dev Simple ERC20 Token example, with mintable token creation
224  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
225  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
226  */
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint value);
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233   uint public totalSupply = 0;
234 
235 
236   modifier canMint() {
237     // if(mintingFinished) throw;
238     require(!mintingFinished);
239     _;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will recieve the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint _amount) onlyOwner canMint  public returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     emit Mint(_to, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() onlyOwner  public returns (bool) {
260     mintingFinished = true;
261     emit MintFinished();
262     return true;
263   }
264 }
265 
266 
267 /**
268  * @title Pausable
269  * @dev Base contract which allows children to implement an emergency stop mechanism.
270  */
271 contract Pausable is Ownable {
272   event Pause();
273   event Unpause();
274 
275   bool public paused = false;
276 
277 
278   /**
279    * @dev modifier to allow actions only when the contract IS paused
280    */
281   modifier whenNotPaused() {
282     // if (paused) throw;
283     require(!paused);
284     _;
285   }
286 
287   /**
288    * @dev modifier to allow actions only when the contract IS NOT paused
289    */
290   modifier whenPaused {
291     // if (!paused) throw;
292     require(paused);
293     _;
294   }
295 
296   /**
297    * @dev called by the owner to pause, triggers stopped state
298    */
299   function pause() onlyOwner whenNotPaused  public returns (bool) {
300     paused = true;
301     emit Pause();
302     return true;
303   }
304 
305   /**
306    * @dev called by the owner to unpause, returns to normal state
307    */
308   function unpause() onlyOwner whenPaused  public returns (bool) {
309     paused = false;
310     emit Unpause();
311     return true;
312   }
313 }
314 
315 
316 /**
317  * Pausable token
318  *
319  * Simple ERC20 Token example, with pausable token creation
320  **/
321 
322 contract PausableToken is StandardToken, Pausable {
323 
324   function transfer(address _to, uint _value) whenNotPaused  public {
325     super.transfer(_to, _value);
326   }
327 
328   function transferFrom(address _from, address _to, uint _value) whenNotPaused  public {
329     super.transferFrom(_from, _to, _value);
330   }
331 }
332 
333 
334 /**
335  * @title TokenTimelock
336  * @dev TokenTimelock is a token holder contract that will allow a
337  * beneficiary to extract the tokens after a time has passed
338  */
339 contract TokenTimelock {
340 
341   // ERC20 basic token contract being held
342   ERC20Basic token;
343 
344   // beneficiary of tokens after they are released
345   address public beneficiary;
346 
347   // timestamp where token release is enabled
348   uint public releaseTime;
349 
350   constructor(ERC20Basic _token, address _beneficiary, uint _releaseTime)  public {
351     require(_releaseTime > now);
352     token = _token;
353     beneficiary = _beneficiary;
354     releaseTime = _releaseTime;
355   }
356 
357   /**
358    * @dev beneficiary claims tokens held by time lock
359    */
360   function claim()  public {
361     require(msg.sender == beneficiary);
362     require(now >= releaseTime);
363 
364     uint amount = token.balanceOf(this);
365     require(amount > 0);
366 
367     token.transfer(beneficiary, amount);
368   }
369 }
370 
371 
372 /**
373  * @title FACTSToken
374  * @dev Facts Token contract
375  */
376 contract FactsToken is PausableToken, MintableToken {
377   using SafeMath for uint256;
378 
379   string public name = "F4Token";
380   string public symbol = "FFFF";
381   uint public decimals = 18;
382 
383   /**
384    * @dev mint timelocked tokens
385    */
386   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public
387     onlyOwner canMint returns (TokenTimelock) {
388 
389     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
390     mint(timelock, _amount);
391 
392     return timelock;
393   }
394 
395   mapping (address => string) public  keys;
396   event LogRegister (address user, string key);
397   // Value should be a public key.  Read full key import policy.
398   // Manually registering requires a base58
399   // encoded using the STEEM, BTS, or EOS public key format.
400   function register(string key) public {
401       assert(bytes(key).length <= 64);
402       keys[msg.sender] = key;
403       emit LogRegister(msg.sender, key);
404     }
405 }