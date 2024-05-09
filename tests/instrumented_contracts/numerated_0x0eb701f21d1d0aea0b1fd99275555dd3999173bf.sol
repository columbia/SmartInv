1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     if (newOwner != address(0)) {
67       owner = newOwner;
68     }
69   }
70 
71 }
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev modifier to allow actions only when the contract IS paused
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev modifier to allow actions only when the contract IS NOT paused
95    */
96   modifier whenPaused {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() onlyOwner whenNotPaused returns (bool) {
105     paused = true;
106     Pause();
107     return true;
108   }
109 
110   /**
111    * @dev called by the owner to unpause, returns to normal state
112    */
113   function unpause() onlyOwner whenPaused returns (bool) {
114     paused = false;
115     Unpause();
116     return true;
117   }
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 {
125 
126   uint256 public totalSupply;
127   
128   function balanceOf(address _owner) constant returns (uint256);
129   function transfer(address _to, uint256 _value) returns (bool);
130   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
131   function approve(address _spender, uint256 _value) returns (bool);
132   function allowance(address _owner, address _spender) constant returns (uint256);
133   
134   event Transfer(address indexed _from, address indexed _to, uint256 _value);
135   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136 
137 }
138 
139 /**
140  * @title ProofPresaleToken (PROOFP) 
141  * Standard Mintable ERC20 Token
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood:
144  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 
147 contract ProofPresaleToken is ERC20, Ownable {
148 
149   using SafeMath for uint256;
150 
151   mapping(address => uint) balances;
152   mapping (address => mapping (address => uint)) allowed;
153 
154   string public constant name = "Proof Presale Token";
155   string public constant symbol = "PPT";
156   uint8 public constant decimals = 18;
157   bool public mintingFinished = false;
158 
159   event Mint(address indexed to, uint256 amount);
160   event MintFinished();
161 
162   function ProofPresaleToken() {}
163 
164 
165   function() payable {
166     revert();
167   }
168 
169   function balanceOf(address _owner) constant returns (uint256) {
170     return balances[_owner];
171   }
172     
173   function transfer(address _to, uint _value) returns (bool) {
174 
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177 
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   function transferFrom(address _from, address _to, uint _value) returns (bool) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     balances[_to] = balances[_to].add(_value);
186     balances[_from] = balances[_from].sub(_value);
187     allowed[_from][msg.sender] = _allowance.sub(_value);
188 
189     Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   function approve(address _spender, uint _value) returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   function allowance(address _owner, address _spender) constant returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202     
203     
204   modifier canMint() {
205     require(!mintingFinished);
206     _;
207   }
208 
209   /**
210    * Function to mint tokens
211    * @param _to The address that will recieve the minted tokens.
212    * @param _amount The amount of tokens to mint.
213    * @return A boolean that indicates if the operation was successful.
214    */
215   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
216     totalSupply = totalSupply.add(_amount);
217     balances[_to] = balances[_to].add(_amount);
218     Mint(_to, _amount);
219     return true;
220   }
221 
222   /**
223    * Function to stop minting new tokens.
224    * @return True if the operation was successful.
225    */
226   function finishMinting() onlyOwner returns (bool) {
227     mintingFinished = true;
228     MintFinished();
229     return true;
230   }
231 
232   
233 }
234 
235 /**
236  * @title ProofPresale 
237  * ProofPresale allows investors to make
238  * token purchases and assigns them tokens based
239  * on a token per ETH rate. Funds collected are forwarded to a wallet 
240  * as they arrive.
241  */
242  
243 contract ProofPresale is Pausable {
244   using SafeMath for uint256;
245 
246   ProofPresaleToken public token; 
247   
248   
249   address public wallet; //wallet towards which the funds are forwarded
250   uint256 public weiRaised; //total amount of ether raised
251   uint256 public cap; // cap above which the presale ends
252   uint256 public minInvestment; // minimum investment (10 ether)
253   uint256 public rate; // number of tokens for one ether (20)
254   bool public isFinalized;
255   string public contactInformation;
256 
257 
258   /**
259    * event for token purchase logging
260    * @param purchaser who paid for the tokens
261    * @param beneficiary who got the tokens
262    * @param value weis paid for purchase
263    * @param amount amount of tokens purchased
264    */ 
265   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
266 
267   /**
268    * event for signaling finished crowdsale
269    */
270   event Finalized();
271 
272 
273   function ProofPresale() {
274     
275     token = createTokenContract();
276     wallet = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
277     rate = 20;
278     minInvestment = 10;  //minimum investment in wei  (=10 ether)
279     cap = 295257 * (10**18);  //cap in token base units (=295257 tokens)
280     
281   }
282 
283   // creates presale token
284   function createTokenContract() internal returns (ProofPresaleToken) {
285     return new ProofPresaleToken();
286   }
287 
288   // fallback function to buy tokens
289   function () payable {
290     buyTokens(msg.sender);
291   }
292   
293   /**
294    * Low level token purchse function
295    * @param beneficiary will recieve the tokens.
296    */
297   function buyTokens(address beneficiary) payable whenNotPaused {
298     require(beneficiary != 0x0);
299     require(validPurchase());
300 
301 
302     uint256 weiAmount = msg.value;
303     // update weiRaised
304     weiRaised = weiRaised.add(weiAmount);
305     // compute amount of tokens created
306     uint256 tokens = weiAmount.mul(rate);
307 
308     token.mint(beneficiary, tokens);
309     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
310     forwardFunds();
311   }
312 
313   // send ether to the fund collection wallet
314   function forwardFunds() internal {
315     wallet.transfer(msg.value);
316   }
317 
318   // return true if the transaction can buy tokens
319   function validPurchase() internal constant returns (bool) {
320 
321     uint256 weiAmount = weiRaised.add(msg.value);
322     bool notSmallAmount = msg.value >= minInvestment;
323     bool withinCap = weiAmount.mul(rate) <= cap;
324 
325     return (notSmallAmount && withinCap);
326   }
327 
328   //allow owner to finalize the presale once the presale is ended
329   function finalize() onlyOwner {
330     require(!isFinalized);
331     require(hasEnded());
332 
333     token.finishMinting();
334     Finalized();
335 
336     isFinalized = true;
337   }
338 
339 
340   function setContactInformation(string info) onlyOwner {
341       contactInformation = info;
342   }
343 
344 
345   //return true if crowdsale event has ended
346   function hasEnded() public constant returns (bool) {
347     bool capReached = (weiRaised.mul(rate) >= cap);
348     return capReached;
349   }
350 
351 }