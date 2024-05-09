1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) external onlyOwner {
36     require(newOwner != address(0));
37     owner = newOwner;
38   }
39 }
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) public constant returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public constant returns (uint256 balance) {
112     return balances[_owner];
113   }
114 }
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 }
196 
197 
198 /**
199  * @title Mintable token
200  * @dev Simple ERC20 Token example, with mintable token creation
201  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
202  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
203  */
204 
205 contract MintableToken is StandardToken, Ownable {
206   event Mint(address indexed to, uint256 amount);
207   event MintFinished();
208 
209   bool public mintingFinished = false;
210 
211 
212   modifier canMint() {
213     require(!mintingFinished);
214     _;
215   }
216 
217   /**
218    * @dev Function to mint tokens
219    * @param _to The address that will recieve the minted tokens.
220    * @param _amount The amount of tokens to mint.
221    * @return A boolean that indicates if the operation was successful.
222    */
223   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
224     totalSupply = totalSupply.add(_amount);
225     balances[_to] = balances[_to].add(_amount);
226     Mint(_to, _amount);
227     return true;
228   }
229 
230   /**
231    * @dev Function to stop minting new tokens.
232    * @return True if the operation was successful.
233    */
234   function finishMinting() public onlyOwner returns (bool) {
235     mintingFinished = true;
236     MintFinished();
237     return true;
238   }
239 }
240 
241 
242 /**
243  * @title Pausable
244  * @dev Base contract which allows children to implement an emergency stop mechanism.
245  */
246 contract Pausable is Ownable {
247   event Pause();
248   event Unpause();
249 
250   bool public paused = false;
251 
252 
253   /**
254    * @dev modifier to allow actions only when the contract IS paused
255    */
256   modifier whenNotPaused() {
257     require(!paused);
258     _;
259   }
260 
261   /**
262    * @dev modifier to allow actions only when the contract IS NOT paused
263    */
264   modifier whenPaused {
265     require(paused);
266     _;
267   }
268 
269   /**
270    * @dev called by the owner to pause, triggers stopped state
271    */
272   function pause() public onlyOwner whenNotPaused returns (bool) {
273     paused = true;
274     Pause();
275     return true;
276   }
277 
278   /**
279    * @dev called by the owner to unpause, returns to normal state
280    */
281   function unpause() public onlyOwner whenPaused returns (bool) {
282     paused = false;
283     Unpause();
284     return true;
285   }
286 }
287 
288 
289 /**
290  * Pausable token
291  *
292  * Simple ERC20 Token example, with pausable token creation
293  **/
294 
295 contract PausableToken is StandardToken, Pausable {
296 
297   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
298     super.transfer(_to, _value);
299   }
300 
301   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
302     super.transferFrom(_from, _to, _value);
303   }
304 }
305 
306 
307 /**
308  * @title HeroOrigenToken
309  * @dev Hero Origen Token contract
310  */
311 contract HeroOrigenToken is PausableToken, MintableToken {
312   using SafeMath for uint256;
313 
314   string public constant name = "Hero Origen Token";
315   string public constant symbol = "HERO";
316   uint8 public constant decimals = 18;
317 }
318 
319 
320 /**
321  * @title MainSale
322  * @dev The main HERO token sale contract
323  *
324  */
325 contract MainSale is Ownable {
326   using SafeMath for uint256;
327   event TokensPurchased(address indexed buyer, uint256 ether_amount);
328   event MainSaleClosed();
329 
330   HeroOrigenToken public token = new HeroOrigenToken();
331 
332   address public multisigVault = 0x1706024467ef8C9C4648Da6FC35f2C995Ac79CF6;
333 
334   uint256 public totalReceived = 0;
335   uint256 public hardcap = 250000 ether;
336   uint256 public minimum = 10 ether;
337 
338   uint256 public altDeposits = 0;
339   uint256 public start = 1511178900; //new Date("November 20, 2017 11:55:00").getTime() / 1000
340   bool public saleOngoing = true;
341 
342   /**
343    * @dev modifier to allow token creation only when the sale IS ON
344    */
345   modifier isSaleOn() {
346     require(start <= now && saleOngoing);
347     _;
348   }
349 
350   /**
351    * @dev modifier to prevent buying tokens below the minimum required
352    */
353   modifier isAtLeastMinimum() {
354     require(msg.value >= minimum);
355     _;
356   }
357 
358   /**
359    * @dev modifier to allow token creation only when the hardcap has not been reached
360    */
361   modifier isUnderHardcap() {
362     require(totalReceived + altDeposits <= hardcap);
363     _;
364   }
365 
366   function MainSale() public {
367     token.pause();
368   }
369 
370   /*
371    * @dev Receive eth from the sender
372    * @param sender the sender to receive tokens.
373    */
374   function acceptPayment(address sender) public isAtLeastMinimum isUnderHardcap isSaleOn payable {
375     totalReceived = totalReceived.add(msg.value);
376     multisigVault.transfer(this.balance);
377     TokensPurchased(sender, msg.value);
378   }
379 
380   /**
381    * @dev Allows the owner to set the starting time.
382    * @param _start the new _start
383    */
384   function setStart(uint256 _start) external onlyOwner {
385     start = _start;
386   }
387 
388   /**
389    * @dev Allows the owner to set the minimum purchase.
390    * @param _minimum the new _minimum
391    */
392   function setMinimum(uint256 _minimum) external onlyOwner {
393     minimum = _minimum;
394   }
395 
396   /**
397    * @dev Allows the owner to set the hardcap.
398    * @param _hardcap the new hardcap
399    */
400   function setHardcap(uint256 _hardcap) external onlyOwner {
401     hardcap = _hardcap;
402   }
403 
404   /**
405    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
406    * @param totalAltDeposits total amount ETH equivalent
407    */
408   function setAltDeposits(uint256 totalAltDeposits) external onlyOwner {
409     altDeposits = totalAltDeposits;
410   }
411 
412   /**
413    * @dev Allows the owner to set the multisig contract.
414    * @param _multisigVault the multisig contract address
415    */
416   function setMultisigVault(address _multisigVault) external onlyOwner {
417     require(_multisigVault != address(0));
418     multisigVault = _multisigVault;
419   }
420 
421   /**
422    * @dev Allows the owner to stop the sale
423    * @param _saleOngoing whether the sale is ongoing or not
424    */
425   function setSaleOngoing(bool _saleOngoing) external onlyOwner {
426     saleOngoing = _saleOngoing;
427   }
428 
429   /**
430    * @dev Allows the owner to close the sale and stop accepting ETH.
431    * The ownership of the token contract is transfered to this owner.
432    */
433   function closeSale() external onlyOwner {
434     token.transferOwnership(owner);
435     MainSaleClosed();
436   }
437 
438   /**
439    * @dev Allows the owner to transfer ERC20 tokens to the multisig vault
440    * @param _token the contract address of the ERC20 contract
441    */
442   function retrieveTokens(address _token) external onlyOwner {
443     ERC20 foreignToken = ERC20(_token);
444     foreignToken.transfer(multisigVault, foreignToken.balanceOf(this));
445   }
446 
447   /**
448    * @dev Fallback function which receives ether
449    */
450   function() external payable {
451     acceptPayment(msg.sender);
452   }
453 }