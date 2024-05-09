1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8 
9   uint256 public totalSupply;
10 
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   function transferFrom(address from, address to, uint256 value) returns (bool);
14   function approve(address spender, uint256 value) returns (bool);
15   function allowance(address owner, address spender) constant returns (uint256);
16   
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) onlyOwner {
86     if (newOwner != address(0)) {
87       owner = newOwner;
88     }
89   }
90 
91 }
92 
93 
94 /**
95  * Standard ERC20 token
96  *
97  * https://github.com/ethereum/EIPs/issues/20
98  * Based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 
102 /// @title Proof Presale Token (PROOFP)
103 
104 contract ProofPresaleToken is ERC20, Ownable {
105 
106   using SafeMath for uint256;
107 
108   mapping(address => uint) balances;
109   mapping (address => mapping (address => uint)) allowed;
110 
111   string public name = "Proof Presale Token";
112   string public symbol = "PROOFP";
113   uint8 public decimals = 18;
114   bool public mintingFinished = false;
115 
116   event Mint(address indexed to, uint256 amount);
117   event MintFinished();
118 
119   function ProofPresaleToken() {}
120 
121 
122   // TODO : need to replace throw by 0.4.11 solidity compiler syntax
123   function() payable {
124     revert();
125   }
126 
127   function transfer(address _to, uint _value) returns (bool success) {
128 
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131 
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142 
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   function balanceOf(address _owner) constant returns (uint balance) {
148     return balances[_owner];
149   }
150 
151   function approve(address _spender, uint _value) returns (bool success) {
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   function allowance(address _owner, address _spender) constant returns (uint remaining) {
158     return allowed[_owner][_spender];
159   }
160     
161     
162   modifier canMint() {
163     require(!mintingFinished);
164     _;
165   }
166 
167   /**
168    * Function to mint tokens
169    * @param _to The address that will recieve the minted tokens.
170    * @param _amount The amount of tokens to mint.
171    * @return A boolean that indicates if the operation was successful.
172    */
173 
174   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
175     totalSupply = totalSupply.add(_amount);
176     balances[_to] = balances[_to].add(_amount);
177     Mint(_to, _amount);
178     return true;
179   }
180 
181   /**
182    * @dev Function to stop minting new tokens.
183    * @return True if the operation was successful.
184    */
185   function finishMinting() onlyOwner returns (bool) {
186     mintingFinished = true;
187     MintFinished();
188     return true;
189   }
190 
191   
192   
193 }
194 
195 
196 /**
197  * @title Pausable
198  * @dev Base contract which allows children to implement an emergency stop mechanism.
199  */
200 contract Pausable is Ownable {
201   event Pause();
202   event Unpause();
203 
204   bool public paused = false;
205 
206 
207   /**
208    * @dev modifier to allow actions only when the contract IS paused
209    */
210   modifier whenNotPaused() {
211     require(!paused);
212     _;
213   }
214 
215   /**
216    * @dev modifier to allow actions only when the contract IS NOT paused
217    */
218   modifier whenPaused {
219     require(paused);
220     _;
221   }
222 
223   /**
224    * @dev called by the owner to pause, triggers stopped state
225    */
226   function pause() onlyOwner whenNotPaused returns (bool) {
227     paused = true;
228     Pause();
229     return true;
230   }
231 
232   /**
233    * @dev called by the owner to unpause, returns to normal state
234    */
235   function unpause() onlyOwner whenPaused returns (bool) {
236     paused = false;
237     Unpause();
238     return true;
239   }
240 }
241 
242 
243 /**
244  * @title Crowdsale 
245  * @dev Crowdsale is a base contract for managing a token crowdsale.
246  * Crowdsales have a start and end block, where investors can make
247  * token purchases and the crowdsale will assign them tokens based
248  * on a token per ETH rate. Funds collected are forwarded to a wallet 
249  * as they arrive.
250  */
251  
252 contract Crowdsale is Pausable {
253   using SafeMath for uint256;
254 
255   // The token being sold
256   ProofPresaleToken public token;
257 
258   // address where funds are collected
259   address public wallet;
260 
261   // amount of raised money in wei
262   uint256 public weiRaised;
263 
264   // cap above which the crowdsale is ended
265   uint256 public cap;
266 
267   uint256 public minInvestment;
268 
269   uint256 public rate;
270 
271   bool public isFinalized;
272 
273   string public contactInformation;
274 
275   uint256 public tokenDecimals;
276 
277   bool private rentrancy_lock = false;
278 
279   
280 
281   /**
282    * event for token purchase logging
283    * @param purchaser who paid for the tokens
284    * @param beneficiary who got the tokens
285    * @param value weis paid for purchase
286    * @param amount amount of tokens purchased
287    */ 
288   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
289 
290   /**
291    * event for signaling finished crowdsale
292    */
293   event Finalized();
294 
295 
296 
297 
298   function Crowdsale() {
299 
300     token = createTokenContract();
301     wallet = 0xaCF472DBcfA46cF9E9842e2734bE2b138fB13C41;
302     rate = 20;
303     tokenDecimals = 18;
304     minInvestment = (10**18)/400;  //minimum investment in wei  (=10 ether)
305     cap = 295257 * (10**18);  //cap in tokens base units (=295257 tokens)
306   }
307 
308   // creates the token to be sold. 
309   function createTokenContract() internal returns (ProofPresaleToken) {
310     return new ProofPresaleToken();
311   }
312 
313 
314   // fallback function to buy tokens
315   function () payable {
316     buyTokens(msg.sender);
317   }
318 
319   // low level token purchase function
320   function buyTokens(address beneficiary) payable whenNotPaused {
321     require(beneficiary != 0x0);
322     require(validPurchase());
323 
324 
325     uint256 weiAmount = msg.value;
326     // compute amount of tokens created
327     uint256 tokens = weiAmount.mul(rate);
328 
329     // update weiRaised
330     weiRaised = weiRaised.add(weiAmount);
331 
332     token.mint(beneficiary, tokens);
333     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
334     forwardFunds();
335   }
336 
337   // send ether to the fund collection wallet
338   // override to create custom fund forwarding mechanisms
339   function forwardFunds() internal {
340     wallet.transfer(msg.value);
341   }
342 
343   // return true if the transaction can buy tokens
344   function validPurchase() internal constant returns (bool) {
345 
346     uint256 weiAmount = weiRaised.add(msg.value);
347     bool notSmallAmount = msg.value >= minInvestment;
348     bool withinCap = weiAmount.mul(rate) <= cap;
349 
350     return (notSmallAmount && withinCap);
351   }
352 
353   function finalize() onlyOwner {
354     require(!isFinalized);
355     require(hasEnded());
356 
357     token.finishMinting();
358     Finalized();
359 
360     isFinalized = true;
361   }
362 
363   function setContactInformation(string info) onlyOwner {
364       contactInformation = info;
365   }
366 
367 
368   // @return true if crowdsale event has ended
369   function hasEnded() public constant returns (bool) {
370     bool capReached = (weiRaised.mul(rate) >= cap);
371     return capReached;
372   }
373     
374   /**
375    * 
376    * @author Remco Bloemen <remco@2π.com>
377    * @dev Prevents a contract from calling itself, directly or indirectly.
378    * @notice If you mark a function `nonReentrant`, you should also
379    * mark it `external`. Calling one nonReentrant function from
380    * another is not supported. Instead, you can implement a
381    * `private` function doing the actual work, and a `external`
382    * wrapper marked as `nonReentrant`.
383    */
384   
385   // TODO need to set nonReentrant modifier where necessary
386 
387   modifier nonReentrant() {
388     require(!rentrancy_lock);
389     rentrancy_lock = true;
390     _;
391     rentrancy_lock = false;
392   }
393 
394 
395 }