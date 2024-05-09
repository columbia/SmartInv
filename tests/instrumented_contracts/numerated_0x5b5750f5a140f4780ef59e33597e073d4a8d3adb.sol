1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 /**
12  * @title ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/20
14  */
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) constant returns (uint256);
17   function transferFrom(address from, address to, uint256 value) returns (bool);
18   function approve(address spender, uint256 value) returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 /**
23  * @title ERC20Basic
24  * @dev Simpler version of ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/179
26  */
27 
28 
29 
30 /**
31  * @title Basic token
32  * @dev Basic version of StandardToken, with no allowances. 
33  */
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36 
37   mapping(address => uint256) balances;
38 
39   /**
40   * @dev transfer token for a specified address
41   * @param _to The address to transfer to.
42   * @param _value The amount to be transferred.
43   */
44   function transfer(address _to, uint256 _value) returns (bool) {
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of. 
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 
64 /**
65  * @title Crowdsale 
66  * @dev Crowdsale is a base contract for managing a token crowdsale.
67  * Crowdsales have a start and end block, where investors can make
68  * token purchases and the crowdsale will assign them tokens based
69  * on a token per ETH rate. Funds collected are forwarded to a wallet 
70  * as they arrive.
71  */
72 contract Crowdsale {
73   using SafeMath for uint256;
74 
75   // The token being sold
76   MintableToken public token;
77 
78   // start and end block where investments are allowed (both inclusive)
79   uint256 public startBlock;
80   uint256 public endBlock;
81 
82   // address where funds are collected
83   address public wallet;
84 
85   // how many token units a buyer gets per wei
86   uint256 public rate;
87 
88   // amount of raised money in wei
89   uint256 public weiRaised;
90 
91   /**
92    * event for token purchase logging
93    * @param purchaser who paid for the tokens
94    * @param beneficiary who got the tokens
95    * @param value weis paid for purchase
96    * @param amount amount of tokens purchased
97    */ 
98   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
99 
100 
101   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
102     require(_startBlock >= block.number);
103     require(_endBlock >= _startBlock);
104     require(_rate > 0);
105     require(_wallet != 0x0);
106 
107     token = createTokenContract();
108     startBlock = _startBlock;
109     endBlock = _endBlock;
110     rate = _rate;
111     wallet = _wallet;
112   }
113 
114   // creates the token to be sold. 
115   // override this method to have crowdsale of a specific mintable token.
116   function createTokenContract() internal returns (MintableToken) {
117     return new MintableToken();
118   }
119 
120 
121   // fallback function can be used to buy tokens
122   function () payable {
123     buyTokens(msg.sender);
124   }
125 
126   // low level token purchase function
127   function buyTokens(address beneficiary) payable {
128     require(beneficiary != 0x0);
129     require(validPurchase());
130 
131     uint256 weiAmount = msg.value;
132 
133     // calculate token amount to be created
134     uint256 tokens = weiAmount.mul(rate);
135 
136     // update state
137     weiRaised = weiRaised.add(weiAmount);
138 
139     token.mint(beneficiary, tokens);
140     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141 
142     forwardFunds();
143   }
144 
145   // send ether to the fund collection wallet
146   // override to create custom fund forwarding mechanisms
147   function forwardFunds() internal {
148     wallet.transfer(msg.value);
149   }
150 
151   // @return true if the transaction can buy tokens
152   function validPurchase() internal constant returns (bool) {
153     uint256 current = block.number;
154     bool withinPeriod = current >= startBlock && current <= endBlock;
155     bool nonZeroPurchase = msg.value != 0;
156     return withinPeriod && nonZeroPurchase;
157   }
158 
159   // @return true if crowdsale event has ended
160   function hasEnded() public constant returns (bool) {
161     return block.number > endBlock;
162   }
163 
164 
165 }
166 
167 
168 
169 
170 
171 /**
172  * @title Mintable token
173  * @dev Simple ERC20 Token example, with mintable token creation
174  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
175  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amout of tokens to be transfered
187    */
188   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
189     var _allowance = allowed[_from][msg.sender];
190 
191     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192     // require (_value <= _allowance);
193 
194     balances[_to] = balances[_to].add(_value);
195     balances[_from] = balances[_from].sub(_value);
196     allowed[_from][msg.sender] = _allowance.sub(_value);
197     Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) returns (bool) {
207 
208     // To change the approve amount you first have to reduce the addresses`
209     //  allowance to zero by calling `approve(_spender, 0)` if it is not
210     //  already 0 to mitigate the race condition described here:
211     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
213 
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifing the amount of tokens still avaible for the spender.
224    */
225   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229 }
230 contract Ownable {
231   address public owner;
232 
233 
234   /**
235    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236    * account.
237    */
238   function Ownable() {
239     owner = msg.sender;
240   }
241 
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251 
252   /**
253    * @dev Allows the current owner to transfer control of the contract to a newOwner.
254    * @param newOwner The address to transfer ownership to.
255    */
256   function transferOwnership(address newOwner) onlyOwner {
257     if (newOwner != address(0)) {
258       owner = newOwner;
259     }
260   }
261 
262 }
263 contract MintableToken is StandardToken, Ownable {
264   event Mint(address indexed to, uint256 amount);
265   event MintFinished();
266 
267   bool public mintingFinished = false;
268 
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will recieve the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
282     totalSupply = totalSupply.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     Mint(_to, _amount);
285     return true;
286   }
287 
288   /**
289    * @dev Function to stop minting new tokens.
290    * @return True if the operation was successful.
291    */
292   function finishMinting() onlyOwner returns (bool) {
293     mintingFinished = true;
294     MintFinished();
295     return true;
296   }
297 }
298 
299 /**
300  * @title Ownable
301  * @dev The Ownable contract has an owner address, and provides basic authorization control
302  * functions, this simplifies the implementation of "user permissions".
303  */
304 
305 
306 /**
307  * @title SafeMath
308  * @dev Math operations with safety checks that throw on error
309  */
310 library SafeMath {
311   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
312     uint256 c = a * b;
313     assert(a == 0 || c / a == b);
314     return c;
315   }
316 
317   function div(uint256 a, uint256 b) internal constant returns (uint256) {
318     // assert(b > 0); // Solidity automatically throws when dividing by 0
319     uint256 c = a / b;
320     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
321     return c;
322   }
323 
324   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
325     assert(b <= a);
326     return a - b;
327   }
328 
329   function add(uint256 a, uint256 b) internal constant returns (uint256) {
330     uint256 c = a + b;
331     assert(c >= a);
332     return c;
333   }
334 }
335 
336 /**
337  * @title Standard ERC20 token
338  *
339  * @dev Implementation of the basic standard token.
340  * @dev https://github.com/ethereum/EIPs/issues/20
341  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
342  */
343 
344 
345 
346 contract LooqToken is MintableToken {
347   string public name = "LOOQ TOKEN";
348   string public symbol = "LOQ";
349   uint256 public decimals = 18;
350 }
351 
352 
353 contract LooqCrowdsale is Crowdsale {
354 
355   function LooqCrowdsale() Crowdsale
356   (4121923, 4321932, 320, 0x33efB7930d066c52C8DfDc25494F9f600a90D0E1){}
357 
358 
359   // creates the token to be sold.
360   // override this method to have crowdsale of a specific MintableToken token.
361   function createTokenContract() internal returns (MintableToken) {
362     return new LooqToken();
363   }
364 
365 }