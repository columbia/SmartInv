1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // 'BVK' token contract
5 //
6 // Deployed to : 0x52715678056616FB4cE3D457b70b41e4BBd54540
7 // Symbol      : BVK
8 // Name        : Big Value Koin
9 // Total supply: 38460000000000000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // Made by Rémy Boulanouar for Velox Savings
15 // ----------------------------------------------------------------------------
16 
17 
18 /**
19  * Math operations with safety checks
20  */
21 library SafeMath {
22   function mul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint a, uint b) internal returns (uint) {
29     uint c = a / b;
30     return c;
31   }
32 
33   function sub(uint a, uint b) internal returns (uint) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint a, uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 
44   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a >= b ? a : b;
46   }
47 
48   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a < b ? a : b;
50   }
51 
52   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a >= b ? a : b;
54   }
55 
56   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a < b ? a : b;
58   }
59 
60   function assert(bool assertion) internal {
61     if (!assertion) {
62       revert();
63     }
64   }
65 }
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20Basic {
73   uint public totalSupply;
74   function balanceOf(address who) public constant returns (uint);
75   function transfer(address to, uint value) public;
76   event Transfer(address indexed from, address indexed to, uint value);
77 }
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint;
85 
86   mapping(address => uint) balances;
87 
88   /**
89    * @dev Fix for the ERC20 short address attack.
90    */
91   modifier onlyPayloadSize(uint size) {
92      if(msg.data.length < size + 4) {
93        revert();
94      }
95      _;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public constant returns (uint);
126   function transferFrom(address from, address to, uint value) public;
127   function approve(address spender, uint value) public;
128   event Approval(address indexed owner, address indexed spender, uint value);
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implemantation of the basic standart token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is BasicToken, ERC20 {
139 
140   mapping (address => mapping (address => uint)) allowed;
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     balances[_to] = balances[_to].add(_value);
152     balances[_from] = balances[_from].sub(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155   }
156 
157   /**
158    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint _value) public {
163 
164     // To change the approve amount you first have to reduce the addresses`
165     //  allowance to zero by calling `approve(_spender, 0)` if it is not
166     //  already 0 to mitigate the race condition described here:
167     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
169 
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens than an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint specifing the amount of tokens still avaible for the spender.
179    */
180   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198   function Ownable() public {
199     owner = msg.sender;
200   }
201 
202   /**
203    * @dev Throws if called by any account other than the owner.
204    */
205   modifier onlyOwner() {
206     if (msg.sender != owner) {
207       revert();
208     }
209     _;
210   }
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.
215    */
216   function transferOwnership(address newOwner) public onlyOwner {
217     if (newOwner != address(0)) {
218       owner = newOwner;
219     }
220   }
221 }
222 
223 /**
224  * @title Mintable token
225  * @dev Simple ERC20 Token example, with mintable token creation
226  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
227  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
228  */
229 
230 contract MintableToken is StandardToken, Ownable {
231   event Mint(address indexed to, uint value);
232   event MintFinished();
233 
234   bool public mintingFinished = false;
235   uint public totalSupply = 0;
236 
237 
238   modifier canMint() {
239     if(mintingFinished) revert();
240     _;
241   }
242 
243   /**
244    * @dev Function to mint tokens
245    * @param _to The address that will recieve the minted tokens.
246    * @param _amount The amount of tokens to mint.
247    * @return A boolean that indicates if the operation was successful.
248    */
249   function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
250     totalSupply = totalSupply.add(_amount);
251     balances[_to] = balances[_to].add(_amount);
252     Mint(_to, _amount);
253     return true;
254   }
255 
256   /**
257    * @dev Function to stop minting new tokens.
258    * @return True if the operation was successful.
259    */
260   function finishMinting() public onlyOwner returns (bool) {
261     mintingFinished = true;
262     MintFinished();
263     return true;
264   }
265 }
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
282     if (paused) revert();
283     _;
284   }
285 
286   /**
287    * @dev modifier to allow actions only when the contract IS NOT paused
288    */
289   modifier whenPaused {
290     if (!paused) revert();
291     _;
292   }
293 
294   /**
295    * @dev called by the owner to pause, triggers stopped state
296    */
297   function pause() public onlyOwner whenNotPaused returns (bool) {
298     paused = true;
299     Pause();
300     return true;
301   }
302 
303   /**
304    * @dev called by the owner to unpause, returns to normal state
305    */
306   function unpause() public onlyOwner whenPaused returns (bool) {
307     paused = false;
308     Unpause();
309     return true;
310   }
311 }
312 
313 /**
314  * Pausable token
315  *
316  * Simple ERC20 Token example, with pausable token creation
317  **/
318 contract PausableToken is StandardToken, Pausable {
319 
320   function transfer(address _to, uint _value) public whenNotPaused {
321     super.transfer(_to, _value);
322   }
323 
324   function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
325     super.transferFrom(_from, _to, _value);
326   }
327 }
328 
329 /**
330  * @title TokenTimelock
331  * @dev TokenTimelock is a token holder contract that will allow a
332  * beneficiary to extract the tokens after a time has passed
333  */
334 contract TokenTimelock {
335 
336   // ERC20 basic token contract being held
337   ERC20Basic token;
338 
339   // beneficiary of tokens after they are released
340   address beneficiary;
341 
342   // timestamp where token release is enabled
343   uint releaseTime;
344 
345   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) public {
346     require(_releaseTime > now);
347     token = _token;
348     beneficiary = _beneficiary;
349     releaseTime = _releaseTime;
350   }
351 
352   /**
353    * @dev beneficiary claims tokens held by time lock
354    */
355   function claim() public {
356     require(msg.sender == beneficiary);
357     require(now >= releaseTime);
358 
359     uint amount = token.balanceOf(this);
360     require(amount > 0);
361 
362     token.transfer(beneficiary, amount);
363   }
364 }
365 
366 /**
367  * @title BVK Token
368  * @dev Big Value Koin Token Contract
369  */
370 contract BVKToken is PausableToken, MintableToken {
371   using SafeMath for uint256;
372 
373   string public name = "Big Value Koin";
374   string public symbol = "BVK";
375   uint public decimals = 18;
376 
377   /**
378    * @dev mint timelocked tokens
379    */
380   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public 
381     onlyOwner canMint returns (TokenTimelock) {
382 
383     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
384     mint(timelock, _amount);
385 
386     return timelock;
387   }
388 
389 }