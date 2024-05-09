1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   event Transfer(address indexed from, address indexed to, uint value);
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint;
75 
76   mapping(address => uint) balances;
77 
78   /**
79    * @dev Fix for the ERC20 short address attack.
80    */
81   modifier onlyPayloadSize(uint size) {
82      if(msg.data.length < size + 4) {
83        throw;
84      }
85      _;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint);
117   function transferFrom(address from, address to, uint value);
118   function approve(address spender, uint value);
119   event Approval(address indexed owner, address indexed spender, uint value);
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implemantation of the basic standart token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is BasicToken, ERC20 {
131 
132   mapping (address => mapping (address => uint)) allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint the amout of tokens to be transfered
140    */
141   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
142     var _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // if (_value > _allowance) throw;
146 
147     balances[_to] = balances[_to].add(_value);
148     balances[_from] = balances[_from].sub(_value);
149     allowed[_from][msg.sender] = _allowance.sub(_value);
150     Transfer(_from, _to, _value);
151   }
152 
153   /**
154    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint _value) {
159 
160     // To change the approve amount you first have to reduce the addresses`
161     //  allowance to zero by calling `approve(_spender, 0)` if it is not
162     //  already 0 to mitigate the race condition described here:
163     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
165 
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens than an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint specifing the amount of tokens still avaible for the spender.
175    */
176   function allowance(address _owner, address _spender) constant returns (uint remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180 }
181 
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control
186  * functions, this simplifies the implementation of "user permissions".
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   /**
193    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194    * account.
195    */
196   function Ownable() {
197     owner = msg.sender;
198   }
199 
200 
201   /**
202    * @dev Throws if called by any account other than the owner.
203    */
204   modifier onlyOwner() {
205     if (msg.sender != owner) {
206       throw;
207     }
208     _;
209   }
210 
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.
215    */
216   function transferOwnership(address newOwner) onlyOwner {
217     if (newOwner != address(0)) {
218       owner = newOwner;
219     }
220   }
221 
222 }
223 
224 
225 /**
226  * @title Mintable token
227  * @dev Simple ERC20 Token example, with mintable token creation
228  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
229  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
230  */
231 
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint value);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237   uint public totalSupply = 0;
238 
239 
240   modifier canMint() {
241     if(mintingFinished) throw;
242     _;
243   }
244 
245   /**
246    * @dev Function to mint tokens
247    * @param _to The address that will recieve the minted tokens.
248    * @param _amount The amount of tokens to mint.
249    * @return A boolean that indicates if the operation was successful.
250    */
251   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
252     totalSupply = totalSupply.add(_amount);
253     balances[_to] = balances[_to].add(_amount);
254     Mint(_to, _amount);
255     return true;
256   }
257 
258   /**
259    * @dev Function to stop minting new tokens.
260    * @return True if the operation was successful.
261    */
262   function finishMinting() onlyOwner returns (bool) {
263     mintingFinished = true;
264     MintFinished();
265     return true;
266   }
267 }
268 
269 
270 /**
271  * @title Pausable
272  * @dev Base contract which allows children to implement an emergency stop mechanism.
273  */
274 contract Pausable is Ownable {
275   event Pause();
276   event Unpause();
277 
278   bool public paused = false;
279 
280 
281   /**
282    * @dev modifier to allow actions only when the contract IS paused
283    */
284   modifier whenNotPaused() {
285     if (paused) throw;
286     _;
287   }
288 
289   /**
290    * @dev modifier to allow actions only when the contract IS NOT paused
291    */
292   modifier whenPaused {
293     if (!paused) throw;
294     _;
295   }
296 
297   /**
298    * @dev called by the owner to pause, triggers stopped state
299    */
300   function pause() onlyOwner whenNotPaused returns (bool) {
301     paused = true;
302     Pause();
303     return true;
304   }
305 
306   /**
307    * @dev called by the owner to unpause, returns to normal state
308    */
309   function unpause() onlyOwner whenPaused returns (bool) {
310     paused = false;
311     Unpause();
312     return true;
313   }
314 }
315 
316 
317 /**
318  * Pausable token
319  *
320  * Simple ERC20 Token example, with pausable token creation
321  **/
322 
323 contract PausableToken is StandardToken, Pausable {
324 
325   function transfer(address _to, uint _value) whenNotPaused {
326     super.transfer(_to, _value);
327   }
328 
329   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
330     super.transferFrom(_from, _to, _value);
331   }
332 }
333 
334 
335 /**
336  * @title TokenTimelock
337  * @dev TokenTimelock is a token holder contract that will allow a
338  * beneficiary to extract the tokens after a time has passed
339  */
340 contract TokenTimelock {
341 
342   // ERC20 basic token contract being held
343   ERC20Basic token;
344 
345   // beneficiary of tokens after they are released
346   address beneficiary;
347 
348   // timestamp where token release is enabled
349   uint releaseTime;
350 
351   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
352     require(_releaseTime > now);
353     token = _token;
354     beneficiary = _beneficiary;
355     releaseTime = _releaseTime;
356   }
357 
358   /**
359    * @dev beneficiary claims tokens held by time lock
360    */
361   function claim() {
362     require(msg.sender == beneficiary);
363     require(now >= releaseTime);
364 
365     uint amount = token.balanceOf(this);
366     require(amount > 0);
367 
368     token.transfer(beneficiary, amount);
369   }
370 }
371 
372 
373 /**
374  * @title X3Token
375  * @dev X3 Token contract
376  */
377 contract X3Token is PausableToken, MintableToken {
378   using SafeMath for uint256;
379 
380   string public name = "X3Token";
381   string public symbol = "X3T";
382   uint public decimals = 18;
383 
384   /**
385    * @dev mint timelocked tokens
386    */
387   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
388     onlyOwner canMint returns (TokenTimelock) {
389 
390     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
391     mint(timelock, _amount);
392 
393     return timelock;
394   }
395 
396 }