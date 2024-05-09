1 pragma solidity 0.4.15;
2 
3 // This code was taken from https://etherscan.io/address/0x3931E02C9AcB4f68D7617F19617A20acD3642607#code
4 // This was a presale from ProofSuite.com
5 // This was based on https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/Crowdsale.sol from what I saw
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68 function transferOwnership(address newOwner) onlyOwner {
69     require(newOwner != address(0));
70     owner = newOwner;
71  }
72 
73 }
74 
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev modifier to allow actions only when the contract IS paused
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev modifier to allow actions only when the contract IS NOT paused
97    */
98   modifier whenPaused {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused returns (bool) {
107     paused = true;
108     Pause();
109     return true;
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused returns (bool) {
116     paused = false;
117     Unpause();
118     return true;
119   }
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 {
127 
128   uint256 public totalSupply;
129 
130   function balanceOf(address _owner) constant returns (uint256);
131   function transfer(address _to, uint256 _value) returns (bool);
132   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
133   function approve(address _spender, uint256 _value) returns (bool);
134   function allowance(address _owner, address _spender) constant returns (uint256);
135 
136   event Transfer(address indexed _from, address indexed _to, uint256 _value);
137   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
138 
139 }
140 
141 /**
142  * @title ZilleriumPresaleToken (ZILL)
143  * Standard Mintable ERC20 Token
144  * https://github.com/ethereum/EIPs/issues/20
145  * Based on code by FirstBlood:
146  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 
149 contract ZilleriumPresaleToken is ERC20, Ownable {
150 
151   using SafeMath for uint256;
152 
153   mapping(address => uint) balances;
154   mapping (address => mapping (address => uint)) allowed;
155 
156   string public constant name = "Zillerium Presale Token";
157   string public constant symbol = "ZILL";
158   uint8 public constant decimals = 18;
159   bool public mintingFinished = false;
160 
161   event Mint(address indexed to, uint256 amount);
162   event MintFinished();
163 
164   function ZilleriumPresaleToken() {}
165 
166 
167   function() payable {
168     revert();
169   }
170 
171   function balanceOf(address _owner) constant returns (uint256) {
172     return balances[_owner];
173   }
174 
175   function transfer(address _to, uint _value) returns (bool) {
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179 
180     Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   function transferFrom(address _from, address _to, uint _value) returns (bool) {
185     var _allowance = allowed[_from][msg.sender];
186 
187     balances[_to] = balances[_to].add(_value);
188     balances[_from] = balances[_from].sub(_value);
189     allowed[_from][msg.sender] = _allowance.sub(_value);
190 
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   function approve(address _spender, uint _value) returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   function allowance(address _owner, address _spender) constant returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205 
206   modifier canMint() {
207     require(!mintingFinished);
208     _;
209   }
210 
211   /**
212    * Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217    // canMint removed from this line - the function kept failing on canMint
218   function mint(address _to, uint256 _amount) onlyOwner  returns (bool) {
219     totalSupply = totalSupply.add(_amount);
220     balances[_to] = balances[_to].add(_amount);
221     Mint(_to, _amount);
222     return true;
223   }
224 
225   /**
226    * Function to stop minting new tokens.
227    * @return True if the operation was successful.
228    */
229   function finishMinting() onlyOwner returns (bool) {
230     mintingFinished = true;
231     MintFinished();
232     return true;
233   }
234 
235   function allowMinting() onlyOwner returns (bool) {
236     mintingFinished = false;
237     return true;
238   }
239 
240 }
241 
242 /**
243  * @title ZilleriumPresale
244  * ZilleriumPresale allows investors to make
245  * token purchases and assigns them tokens based
246  * on a token per ETH rate. Funds collected are forwarded to a wallet
247  * as they arrive.
248  */
249 
250 contract ZilleriumPresale is Pausable {
251   using SafeMath for uint256;
252 
253   ZilleriumPresaleToken public token;
254 
255 
256   address public wallet; //wallet towards which the funds are forwarded
257   uint256 public weiRaised; //total amount of ether raised
258   uint256 public cap; // cap above which the presale ends
259   uint256 public minInvestment; // minimum investment
260   uint256 public rate; // number of tokens for one ether
261   bool public isFinalized;
262   string public contactInformation;
263 
264 
265   /**
266    * event for token purchase logging
267    * @param purchaser who paid for the tokens
268    * @param beneficiary who got the tokens
269    * @param value weis paid for purchase
270    * @param amount amount of tokens purchased
271    */
272   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
273 
274   /**
275    * event for signaling finished crowdsale
276    */
277   event Finalized();
278 
279 
280   function ZilleriumPresale() {
281 
282     token = createTokenContract();
283     wallet = 0x898091cB76927EE5B41a731EE15dDFdd0560a67b; // live
284     //  wallet = 0x48884f1f259a4fdbb22b77b56bfd486fe7784304; // testing
285     rate = 100;
286     minInvestment = 1 * (10**16);  //minimum investment in wei  (=.01 ether, this is based on wei being 10 to 18)
287     cap = 16600 * (10**18);  //cap in token base units (=295257 tokens)
288 
289   }
290 
291   // creates presale token
292   function createTokenContract() internal returns (ZilleriumPresaleToken) {
293     return new ZilleriumPresaleToken();
294   }
295 
296   // fallback function to buy tokens
297   function () payable {
298     buyTokens(msg.sender);
299   }
300 
301   /**
302    * Low level token purchse function
303    * @param beneficiary will recieve the tokens.
304    */
305   function buyTokens(address beneficiary) payable whenNotPaused {
306     require(beneficiary != 0x0);
307     require(validPurchase());
308 
309 
310     uint256 weiAmount = msg.value;
311     // update weiRaised
312     weiRaised = weiRaised.add(weiAmount);
313     // compute amount of tokens created
314     uint256 tokens = weiAmount.mul(rate);
315 
316     token.mint(beneficiary, tokens);
317     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
318     forwardFunds();
319   }
320 
321   // send ether to the fund collection wallet
322   function forwardFunds() internal {
323     wallet.transfer(msg.value);
324   }
325 
326   // return true if the transaction can buy tokens
327   function validPurchase() internal constant returns (bool) {
328 
329     uint256 weiAmount = weiRaised.add(msg.value);
330     bool notSmallAmount = msg.value >= minInvestment;
331     bool withinCap = weiAmount.mul(rate) <= cap;
332 
333     return (notSmallAmount && withinCap);
334   }
335 
336   //allow owner to finalize the presale once the presale is ended
337   function finalize() onlyOwner {
338     require(!isFinalized);
339     require(hasEnded());
340 
341     token.finishMinting();
342     Finalized();
343 
344     isFinalized = true;
345   }
346 
347 
348   function setContactInformation(string info) onlyOwner {
349       contactInformation = info;
350   }
351 
352 
353   //return true if crowdsale event has ended
354   function hasEnded() public constant returns (bool) {
355     bool capReached = (weiRaised.mul(rate) >= cap);
356     return capReached;
357   }
358 
359 }