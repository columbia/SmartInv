1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        throw;
81      }
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) constant returns (uint balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) constant returns (uint);
113   function transferFrom(address from, address to, uint value);
114   function approve(address spender, uint value);
115   event Approval(address indexed owner, address indexed spender, uint value);
116 }
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
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // if (_value > _allowance) throw;
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145   }
146 
147   /**
148    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint _value) {
153 
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
159 
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens than an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint specifing the amount of tokens still avaible for the spender.
169    */
170   function allowance(address _owner, address _spender) constant returns (uint remaining) {
171     return allowed[_owner][_spender];
172   }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   function Ownable() {
189     owner = msg.sender;
190   }
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     if (msg.sender != owner) {
197       throw;
198     }
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) onlyOwner {
207     if (newOwner != address(0)) {
208       owner = newOwner;
209     }
210   }
211 
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222   event Mint(address indexed to, uint value);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226   uint public totalSupply = 0;
227 
228   modifier canMint() {
229     if(mintingFinished) throw;
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will recieve the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
243     return true;
244   }
245 
246   /**
247    * @dev Function to stop minting new tokens.
248    * @return True if the operation was successful.
249    */
250   function finishMinting() onlyOwner returns (bool) {
251     mintingFinished = true;
252     MintFinished();
253     return true;
254   }
255 }
256 
257 /**
258  * @title Pausable
259  * @dev Base contract which allows children to implement an emergency stop mechanism.
260  */
261 contract Pausable is Ownable {
262   event Pause();
263   event Unpause();
264 
265   bool public paused = false;
266 
267   /**
268    * @dev modifier to allow actions only when the contract IS paused
269    */
270   modifier whenNotPaused() {
271     if (paused) throw;
272     _;
273   }
274 
275   /**
276    * @dev modifier to allow actions only when the contract IS NOT paused
277    */
278   modifier whenPaused {
279     if (!paused) throw;
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused returns (bool) {
287     paused = true;
288     Pause();
289     return true;
290   }
291 
292   /**
293    * @dev called by the owner to unpause, returns to normal state
294    */
295   function unpause() onlyOwner whenPaused returns (bool) {
296     paused = false;
297     Unpause();
298     return true;
299   }
300 }
301 
302 /**
303  * Pausable token
304  *
305  * Simple ERC20 Token example, with pausable token creation
306  **/
307 
308 contract PausableToken is StandardToken, Pausable {
309 
310   function transfer(address _to, uint _value) whenNotPaused {
311     super.transfer(_to, _value);
312   }
313 
314   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
315     super.transferFrom(_from, _to, _value);
316   }
317 }
318 
319 /**
320  * @title TokenTimelock
321  * @dev TokenTimelock is a token holder contract that will allow a
322  * beneficiary to extract the tokens after a time has passed
323  */
324 contract TokenTimelock {
325 
326   // ERC20 basic token contract being held
327   ERC20Basic token;
328 
329   // beneficiary of tokens after they are released
330   address beneficiary;
331 
332   // timestamp where token release is enabled
333   uint releaseTime;
334 
335   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
336     require(_releaseTime > now);
337     token = _token;
338     beneficiary = _beneficiary;
339     releaseTime = _releaseTime;
340   }
341 
342   /**
343    * @dev beneficiary claims tokens held by time lock
344    */
345   function claim() {
346     require(msg.sender == beneficiary);
347     require(now >= releaseTime);
348 
349     uint amount = token.balanceOf(this);
350     require(amount > 0);
351 
352     token.transfer(beneficiary, amount);
353   }
354 }
355 
356 contract EXToken is PausableToken, MintableToken {
357   using SafeMath for uint256;
358 
359   string public name = "2EX Token";
360   string public symbol = "2ex";
361   uint public decimals = 18;
362 
363   /**
364    * @dev mint timelocked tokens
365    */
366   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
367     onlyOwner canMint returns (TokenTimelock) {
368 
369     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
370     mint(timelock, _amount);
371 
372     return timelock;
373   }
374 }