1 pragma solidity ^0.4.11;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51   mapping(address => uint256) balances;
52   /**
53   * @dev transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) public constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 }
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public constant returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * @dev https://github.com/ethereum/EIPs/issues/20
90  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, BasicToken {
93   mapping (address => mapping (address => uint256)) internal allowed;
94   /**
95    * @dev Transfer tokens from one address to another
96    * @param _from address The address which you want to send tokens from
97    * @param _to address The address which you want to transfer to
98    * @param _value uint256 the amount of tokens to be transferred
99    */
100   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[_from]);
103     require(_value <= allowed[_from][msg.sender]);
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110   /**
111    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    *
113    * Beware that changing an allowance with this method brings the risk that someone may use both the old
114    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     Approval(msg.sender, _spender, _value);
123     return true;
124   }
125   /**
126    * @dev Function to check the amount of tokens that an owner allowed to a spender.
127    * @param _owner address The address which owns the funds.
128    * @param _spender address The address which will spend the funds.
129    * @return A uint256 specifying the amount of tokens still available for the spender.
130    */
131   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
132     return allowed[_owner][_spender];
133   }
134   /**
135    * approve should be called when allowed[_spender] == 0. To increment
136    * allowed value is better to use this function to avoid 2 calls (and wait until
137    * the first transaction is mined)
138    * From MonolithDAO Token.sol
139    */
140   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
141     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 }
156 /**
157  * @title Mintable token
158  * @dev Simple ERC20 Token example, with mintable token creation
159  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
160  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
161  */
162 contract MintableToken is StandardToken, Ownable {
163   event Mint(address indexed to, uint256 amount);
164   event MintFinished();
165   bool public mintingFinished = false;
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170   /**
171    * @dev Function to mint tokens
172    * @param _to The address that will receive the minted tokens.
173    * @param _amount The amount of tokens to mint.
174    * @return A boolean that indicates if the operation was successful.
175    */
176   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
177     totalSupply = totalSupply.add(_amount);
178     balances[_to] = balances[_to].add(_amount);
179     Mint(_to, _amount);
180     Transfer(address(0), _to, _amount);
181     return true;
182   }
183   /**
184    * @dev Function to stop minting new tokens.
185    * @return True if the operation was successful.
186    */
187   function finishMinting() onlyOwner public returns (bool) {
188     mintingFinished = true;
189     MintFinished();
190     return true;
191   }
192 }
193 /**
194  * @title SafeMath
195  * @dev Math operations with safety checks that throw on error
196  */
197 library SafeMath {
198   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
199     uint256 c = a * b;
200     assert(a == 0 || c / a == b);
201     return c;
202   }
203   function div(uint256 a, uint256 b) internal constant returns (uint256) {
204     // assert(b > 0); // Solidity automatically throws when dividing by 0
205     uint256 c = a / b;
206     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207     return c;
208   }
209   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
210     assert(b <= a);
211     return a - b;
212   }
213   function add(uint256 a, uint256 b) internal constant returns (uint256) {
214     uint256 c = a + b;
215     assert(c >= a);
216     return c;
217   }
218 }
219 /**
220  * @title Crowdsale
221  * @dev Crowdsale is a base contract for managing a token crowdsale.
222  * Crowdsales have a start and end timestamps, where investors can make
223  * token purchases and the crowdsale will assign them tokens based
224  * on a token per ETH rate. Funds collected are forwarded to a wallet
225  * as they arrive.
226  */
227 contract Crowdsale {
228   using SafeMath for uint256;
229   // The token being sold
230   MintableToken public token;
231   // start and end timestamps where investments are allowed (both inclusive)
232   uint256 public startTime;
233   uint256 public endTime;
234   // address where funds are collected
235   address public wallet;
236   // how many token units a buyer gets per wei
237   uint256 public rate;
238   // amount of raised money in wei
239   uint256 public weiRaised;
240   /**
241    * event for token purchase logging
242    * @param purchaser who paid for the tokens
243    * @param beneficiary who got the tokens
244    * @param value weis paid for purchase
245    * @param amount amount of tokens purchased
246    */
247   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
248   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
249     require(_startTime >= now);
250     require(_endTime >= _startTime);
251     require(_rate > 0);
252     require(_wallet != address(0));
253     token = createTokenContract();
254     startTime = _startTime;
255     endTime = _endTime;
256     rate = _rate;
257     wallet = _wallet;
258   }
259   // creates the token to be sold.
260   // override this method to have crowdsale of a specific mintable token.
261   function createTokenContract() internal returns (MintableToken) {
262     return new MintableToken();
263   }
264   // fallback function can be used to buy tokens
265   function () payable {
266     buyTokens(msg.sender);
267   }
268   // low level token purchase function
269   function buyTokens(address beneficiary) public payable {
270     require(beneficiary != address(0));
271     require(validPurchase());
272     uint256 weiAmount = msg.value;
273     // calculate token amount to be created
274     uint256 tokens = weiAmount.mul(rate);
275     // update state
276     weiRaised = weiRaised.add(weiAmount);
277     token.mint(beneficiary, tokens);
278     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
279     forwardFunds();
280   }
281   // send ether to the fund collection wallet
282   // override to create custom fund forwarding mechanisms
283   function forwardFunds() internal {
284     wallet.transfer(msg.value);
285   }
286   // @return true if the transaction can buy tokens
287   function validPurchase() internal constant returns (bool) {
288     bool withinPeriod = now >= startTime && now <= endTime;
289     bool nonZeroPurchase = msg.value != 0;
290     return withinPeriod && nonZeroPurchase;
291   }
292   // @return true if crowdsale event has ended
293   function hasEnded() public constant returns (bool) {
294     return now > endTime;
295   }
296 }
297 /**
298  * @title CappedCrowdsale
299  * @dev Extension of Crowdsale with a max amount of funds raised
300  */
301 contract CappedCrowdsale is Crowdsale {
302   using SafeMath for uint256;
303   uint256 public cap;
304   function CappedCrowdsale(uint256 _cap) {
305     require(_cap > 0);
306     cap = _cap;
307   }
308   // overriding Crowdsale#validPurchase to add extra cap logic
309   // @return true if investors can buy at the moment
310   function validPurchase() internal constant returns (bool) {
311     bool withinCap = weiRaised.add(msg.value) <= cap;
312     return super.validPurchase() && withinCap;
313   }
314   // overriding Crowdsale#hasEnded to add cap logic
315   // @return true if crowdsale event has ended
316   function hasEnded() public constant returns (bool) {
317     bool capReached = weiRaised >= cap;
318     return super.hasEnded() || capReached;
319   }
320 }
321 /**
322  * @title Burnable Token
323  * @dev Token that can be irreversibly burned (destroyed).
324  */
325 contract BurnableToken is StandardToken {
326     event Burn(address indexed burner, uint256 value);
327     /**
328      * @dev Burns a specific amount of tokens.
329      * @param _value The amount of token to be burned.
330      */
331     function burn(uint256 _value) public {
332         require(_value > 0);
333         require(_value <= balances[msg.sender]);
334         // no need to require value <= totalSupply, since that would imply the
335         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
336         address burner = msg.sender;
337         balances[burner] = balances[burner].sub(_value);
338         totalSupply = totalSupply.sub(_value);
339         Burn(burner, _value);
340     }
341 }
342 contract VentureCoin is MintableToken, BurnableToken {
343   string public name = "VentureCoin"; 
344   string public symbol = "VCN";
345   uint public decimals = 18;
346   uint public INITIAL_SUPPLY = 666000000 * (10 ** decimals);
347   function VentureCoin(address _beneficierwallet) {
348     totalSupply = INITIAL_SUPPLY;
349     balances[_beneficierwallet] = INITIAL_SUPPLY;
350   }
351 }
352 contract VentureCoinCrowdsale is CappedCrowdsale {
353   function VentureCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _capped) 
354     CappedCrowdsale(_capped)
355     Crowdsale(_startTime, _endTime, _rate, _wallet) 
356     { }
357   
358   // creates the token to be sold.
359   // override this method to have crowdsale of a specific MintableToken token.
360   function createTokenContract() internal returns (MintableToken) {
361     return new VentureCoin( address(0xad6E6dd7B3649102eE5649fC4290af639A87f707) );
362   }
363 }