1 pragma solidity ^0.4.14;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) returns (bool);
24   function approve(address spender, uint256 value) returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances. 
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) returns (bool) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of. 
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner {
188     require(newOwner != address(0));      
189     owner = newOwner;
190   }
191 
192 }
193 
194 
195 /**
196  * @title DatumGenesisToken
197  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
198  * Note they can later distribute these tokens as they wish using `transfer` and other
199  * `StandardToken` functions.
200  */
201 contract DatumGenesisToken is StandardToken, Ownable {
202 
203   string public name = "DAT Genesis Token";           //The Token's name: e.g. Dat Genesis Tokens
204   uint8 public decimals = 18;                         //Number of decimals of the smallest unit
205   string public symbol = "DATG";                             //An identifier: e.g. REP
206                                            
207   uint256 public constant INITIAL_SUPPLY = 75000000 ether;
208 
209   // Flag that determines if the token is transferable or not.
210   bool public transfersEnabled = false;
211 
212   /**
213    * @dev Contructor that gives msg.sender all of existing tokens. 
214    */
215   function DatumGenesisToken() {
216     totalSupply = INITIAL_SUPPLY;
217     balances[msg.sender] = INITIAL_SUPPLY;
218   }
219 
220 
221    /// @notice Enables token holders to transfer their tokens freely if true
222    /// @param _transfersEnabled True if transfers are allowed in the clone
223    function enableTransfers(bool _transfersEnabled) onlyOwner {
224       transfersEnabled = _transfersEnabled;
225    }
226 
227   function transferFromContract(address _to, uint256 _value) onlyOwner returns (bool success) {
228     return super.transfer(_to, _value);
229   }
230 
231   function transfer(address _to, uint256 _value) returns (bool success) {
232     require(transfersEnabled);
233     return super.transfer(_to, _value);
234   }
235 
236   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
237     require(transfersEnabled);
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve(address _spender, uint256 _value) returns (bool) {
242       require(transfersEnabled);
243       return super.approve(_spender, _value);
244   }
245 }
246 
247 
248 
249 /**
250  * @title  
251  * @dev DatCrowdSale is a contract for managing a token crowdsale.
252  * DatCrowdSale have a start and end date, where investors can make
253  * token purchases and the crowdsale will assign them tokens based
254  * on a token per ETH rate. Funds collected are forwarded to a refundable valut 
255  * as they arrive.
256  */
257 contract DatCrowdPreSale is Ownable {
258   using SafeMath for uint256;
259 
260   // The token being sold
261   DatumGenesisToken public token;
262 
263   // start and end date where investments are allowed (both inclusive)
264   uint256 public startDate = 1502460000; //Fri, 11 Aug 2017 14:00:00 +00:00
265   uint256 public endDate = 1505138400; //Mon, 11 Sep 2017 14:00:00 +00:00
266 
267   // Minimum amount to participate
268   uint256 public minimumParticipationAmount = 100000000000000000 wei; //0.1 ether
269 
270   // Maximum amount to participate
271   uint256 public maximalParticipationAmount = 1000000000000000000000 wei; //1000 ether
272 
273   // address where funds are collected
274   address wallet;
275 
276   // how many token units a buyer gets per ether
277   uint256 rate = 15000;
278 
279   // amount of raised money in wei
280   uint256 public weiRaised;
281 
282   //flag for final of crowdsale
283   bool public isFinalized = false;
284 
285   //cap for the sale
286   uint256 public cap = 5000000000000000000000 wei; //5000 ether
287  
288 
289 
290 
291   event Finalized();
292 
293   /**
294    * event for token purchase logging
295    * @param purchaser who paid for the tokens
296    * @param beneficiary who got the tokens
297    * @param value weis paid for purchase
298    * @param amount amount of tokens purchased
299    */ 
300   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
301 
302 
303 
304   /**
305   * @notice Log an event for each funding contributed during the public phase
306   * @notice Events are not logged when the constructor is being executed during
307   *         deployment, so the preallocations will not be logged
308   */
309   event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);
310 
311 
312   
313   function DatCrowdPreSale(address _wallet) {
314     token = createTokenContract();
315     wallet = _wallet;
316   }
317 
318 
319 // creates the token to be sold. 
320   // override this method to have crowdsale of a specific datum token.
321   function createTokenContract() internal returns (DatumGenesisToken) {
322     return new DatumGenesisToken();
323 }
324 
325   // fallback function can be used to buy tokens
326   function () payable {
327     buyTokens(msg.sender);
328   }
329 
330   // low level token purchase function
331   function buyTokens(address beneficiary) payable {
332     require(beneficiary != 0x0);
333     require(validPurchase());
334 
335     //get ammount in wei
336     uint256 weiAmount = msg.value;
337 
338     // calculate token amount to be created
339     uint256 tokens = weiAmount.mul(rate);
340 
341     //purchase tokens and transfer to beneficiary
342     token.transferFromContract(beneficiary, tokens);
343 
344     // update state
345     weiRaised = weiRaised.add(weiAmount);
346 
347     //Token purchase event
348     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
349 
350     //forward funds to wallet
351     forwardFunds();
352   }
353 
354   //send tokens to the given address used for investors with other conditions, only contract owner can call this
355   function transferTokensManual(address beneficiary, uint256 amount) onlyOwner {
356     require(beneficiary != 0x0);
357     require(amount != 0);
358     require(weiRaised.add(amount) <= cap);
359 
360     //transfer tokens
361     token.transferFromContract(beneficiary, amount);
362 
363     // update state
364     weiRaised = weiRaised.add(amount);
365 
366     //Token purchase event
367     TokenPurchase(wallet, beneficiary, 0, amount);
368 
369   }
370 
371    /// @notice Enables token holders to transfer their tokens freely if true
372    /// @param _transfersEnabled True if transfers are allowed in the clone
373    function enableTransfers(bool _transfersEnabled) onlyOwner {
374       token.enableTransfers(_transfersEnabled);
375    }
376 
377   // send ether to the fund collection wallet
378   // override to create custom fund forwarding mechanisms
379   function forwardFunds() internal {
380     wallet.transfer(msg.value);
381   }
382 
383   // should be called after crowdsale ends or to emergency stop the sale
384   function finalize() onlyOwner {
385     require(!isFinalized);
386     Finalized();
387     isFinalized = true;
388   }
389 
390 
391   // @return true if the transaction can buy tokens
392   // check for valid time period, min amount and within cap
393   function validPurchase() internal constant returns (bool) {
394     bool withinPeriod = startDate <= now && endDate >= now;
395     bool nonZeroPurchase = msg.value != 0;
396     bool minAmount = msg.value >= minimumParticipationAmount;
397     bool withinCap = weiRaised.add(msg.value) <= cap;
398 
399     return withinPeriod && nonZeroPurchase && minAmount && !isFinalized && withinCap;
400   }
401 
402     // @return true if the goal is reached
403   function capReached() public constant returns (bool) {
404     return weiRaised >= cap;
405   }
406 
407   // @return true if crowdsale event has ended
408   function hasEnded() public constant returns (bool) {
409     return isFinalized;
410   }
411 
412 }