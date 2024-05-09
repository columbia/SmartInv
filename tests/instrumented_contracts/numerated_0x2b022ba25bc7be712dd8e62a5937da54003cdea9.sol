1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner {
39     require(newOwner != address(0));      
40     owner = newOwner;
41   }
42 }
43 /**
44  * @title Basic token
45  * @dev Basic version of StandardToken, with no allowances. 
46  */
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49   mapping(address => uint256) balances;
50   /**
51   * @dev transfer token for a specified address
52   * @param _to The address to transfer to.
53   * @param _value The amount to be transferred.
54   */
55   function transfer(address _to, uint256 _value) returns (bool) {
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of. 
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) constant returns (uint256 balance) {
67     return balances[_owner];
68   }
69 }
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address owner, address spender) constant returns (uint256);
76   function transferFrom(address from, address to, uint256 value) returns (bool);
77   function approve(address spender, uint256 value) returns (bool);
78   event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 /**
81  * @title Standard ERC20 token
82  *
83  * @dev Implementation of the basic standard token.
84  * @dev https://github.com/ethereum/EIPs/issues/20
85  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  */
87 contract StandardToken is ERC20, BasicToken {
88   mapping (address => mapping (address => uint256)) allowed;
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amount of tokens to be transferred
94    */
95   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
96     var _allowance = allowed[_from][msg.sender];
97     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
98     // require (_value <= _allowance);
99     balances[_from] = balances[_from].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     allowed[_from][msg.sender] = _allowance.sub(_value);
102     Transfer(_from, _to, _value);
103     return true;
104   }
105   /**
106    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) returns (bool) {
111     // To change the approve amount you first have to reduce the addresses`
112     //  allowance to zero by calling `approve(_spender, 0)` if it is not
113     //  already 0 to mitigate the race condition described here:
114     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120   /**
121    * @dev Function to check the amount of tokens that an owner allowed to a spender.
122    * @param _owner address The address which owns the funds.
123    * @param _spender address The address which will spend the funds.
124    * @return A uint256 specifying the amount of tokens still available for the spender.
125    */
126   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127     return allowed[_owner][_spender];
128   }
129   
130     /*
131    * approve should be called when allowed[_spender] == 0. To increment
132    * allowed value is better to use this function to avoid 2 calls (and wait until 
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    */
136   function increaseApproval (address _spender, uint _addedValue) 
137     returns (bool success) {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142   function decreaseApproval (address _spender, uint _subtractedValue) 
143     returns (bool success) {
144     uint oldValue = allowed[msg.sender][_spender];
145     if (_subtractedValue > oldValue) {
146       allowed[msg.sender][_spender] = 0;
147     } else {
148       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
149     }
150     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151     return true;
152   }
153 }
154 /**
155  * @title Mintable token
156  * @dev Simple ERC20 Token example, with mintable token creation
157  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
158  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
159  */
160 contract MintableToken is StandardToken, Ownable {
161   event Mint(address indexed to, uint256 amount);
162   event MintFinished();
163   bool public mintingFinished = false;
164   modifier canMint() {
165     require(!mintingFinished);
166     _;
167   }
168   /**
169    * @dev Function to mint tokens
170    * @param _to The address that will receive the minted tokens.
171    * @param _amount The amount of tokens to mint.
172    * @return A boolean that indicates if the operation was successful.
173    */
174   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
175     totalSupply = totalSupply.add(_amount);
176     balances[_to] = balances[_to].add(_amount);
177     Mint(_to, _amount);
178     Transfer(0x0, _to, _amount);
179     return true;
180   }
181   /**
182    * @dev Function to stop minting new tokens.
183    * @return True if the operation was successful.
184    */
185   function finishMinting() onlyOwner returns (bool) {
186     mintingFinished = true;
187     MintFinished();
188     return true;
189   }
190 }
191 contract DogCoin is MintableToken {
192   string public name = "DogCoin";
193   string public symbol = "DOG";
194   uint256 public decimals = 18;
195 }
196 /**
197  * @title SafeMath
198  * @dev Math operations with safety checks that throw on error
199  */
200 library SafeMath {
201   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
202     uint256 c = a * b;
203     assert(a == 0 || c / a == b);
204     return c;
205   }
206   function div(uint256 a, uint256 b) internal constant returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return c;
211   }
212   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
213     assert(b <= a);
214     return a - b;
215   }
216   function add(uint256 a, uint256 b) internal constant returns (uint256) {
217     uint256 c = a + b;
218     assert(c >= a);
219     return c;
220   }
221 }
222 /**
223  * @title Crowdsale 
224  * @dev Crowdsale is a base contract for managing a token crowdsale.
225  * Crowdsales have a start and end timestamps, where investors can make
226  * token purchases and the crowdsale will assign them tokens based
227  * on a token per ETH rate. Funds collected are forwarded to a wallet 
228  * as they arrive.
229  */
230 contract Crowdsale {
231   using SafeMath for uint256;
232   // The token being sold
233   MintableToken public token;
234   // start and end timestamps where investments are allowed (both inclusive)
235   uint256 public startTime;
236   uint256 public endTime;
237   // address where funds are collected
238   address public wallet;
239   // how many token units a buyer gets per wei
240   uint256 public rate;
241   // amount of raised money in wei
242   uint256 public weiRaised;
243   /**
244    * event for token purchase logging
245    * @param purchaser who paid for the tokens
246    * @param beneficiary who got the tokens
247    * @param value weis paid for purchase
248    * @param amount amount of tokens purchased
249    */ 
250   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
251   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
252     require(_startTime >= now);
253     require(_endTime >= _startTime);
254     require(_rate > 0);
255     require(_wallet != 0x0);
256     token = createTokenContract();
257     startTime = _startTime;
258     endTime = _endTime;
259     rate = _rate;
260     wallet = _wallet;
261   }
262   // creates the token to be sold. 
263   // override this method to have crowdsale of a specific mintable token.
264   function createTokenContract() internal returns (MintableToken) {
265     return new MintableToken();
266   }
267   // fallback function can be used to buy tokens
268   function () payable {
269     buyTokens(msg.sender);
270   }
271   // low level token purchase function
272   function buyTokens(address beneficiary) payable {
273     require(beneficiary != 0x0);
274     require(validPurchase());
275     uint256 weiAmount = msg.value;
276     // calculate token amount to be created
277     uint256 tokens = weiAmount.mul(rate);
278     // update state
279     weiRaised = weiRaised.add(weiAmount);
280     token.mint(beneficiary, tokens);
281     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
282     forwardFunds();
283   }
284   // send ether to the fund collection wallet
285   // override to create custom fund forwarding mechanisms
286   function forwardFunds() internal {
287     wallet.transfer(msg.value);
288   }
289   // @return true if the transaction can buy tokens
290   function validPurchase() internal constant returns (bool) {
291     bool withinPeriod = now >= startTime && now <= endTime;
292     bool nonZeroPurchase = msg.value != 0;
293     return withinPeriod && nonZeroPurchase;
294   }
295   // @return true if crowdsale event has ended
296   function hasEnded() public constant returns (bool) {
297     return now > endTime;
298   }
299 }
300 /**
301  * @title CappedCrowdsale
302  * @dev Extension of Crowsdale with a max amount of funds raised
303  */
304 contract CappedCrowdsale is Crowdsale {
305   using SafeMath for uint256;
306   uint256 public cap;
307   function CappedCrowdsale(uint256 _cap) {
308     require(_cap > 0);
309     cap = _cap;
310   }
311   // overriding Crowdsale#validPurchase to add extra cap logic
312   // @return true if investors can buy at the moment
313   function validPurchase() internal constant returns (bool) {
314     bool withinCap = weiRaised.add(msg.value) <= cap;
315     return super.validPurchase() && withinCap;
316   }
317   // overriding Crowdsale#hasEnded to add cap logic
318   // @return true if crowdsale event has ended
319   function hasEnded() public constant returns (bool) {
320     bool capReached = weiRaised >= cap;
321     return super.hasEnded() || capReached;
322   }
323 }
324 contract DogCoinCrowdsale is CappedCrowdsale {
325   function DogCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
326   	CappedCrowdsale(_cap)
327     Crowdsale(_startTime, _endTime, _rate, _wallet)  {
328     	
329   }
330  
331   // creates the token to be sold.
332   // override this method to have crowdsale of a specific MintableToken token.
333   function createTokenContract() internal returns (MintableToken) {
334     return new DogCoin();
335   }
336 }