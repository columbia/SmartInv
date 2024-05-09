1 pragma solidity ^0.4.15;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: contracts/GRAD.sol
36 
37 contract GRAD {
38     using SafeMath for uint256;
39 
40     string public name = "Gadus";
41 
42     string public symbol = "GRAD";
43 
44     uint public decimals = 18;
45 
46     uint256 public totalSupply;
47 
48     address owner;
49 
50     mapping(address => uint256) balances;
51 
52     mapping (address => mapping (address => uint256)) allowed;
53 
54     event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
55 
56     event Mint (address indexed to, uint256  amount);
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     // construtor
61     function GRAD() public{
62         owner = msg.sender;
63     }
64 
65      /**
66       * @dev Mint token to tagret parametred
67       * @param _to address The address which you want to mint to
68       * @param _value uint256 the amout of tokens to be transfered
69       */
70 
71     function mint(address _to, uint256 _value) onlyOwner public returns (bool){
72         balances[_to] = balances[_to].add(_value);
73         totalSupply = totalSupply.add(_value);
74         Mint(_to, _value);
75         return true;
76     }
77 
78     /**
79      * @dev Transfer tokens from one address to another
80      * @param _from address The address which you want to send tokens from
81      * @param _to address The address which you want to transfer to
82      * @param _value uint256 the amout of tokens to be transfered
83      */
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     var _allowance = allowed[_from][msg.sender];
86 
87     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
88     // require (_value <= _allowance);
89 
90     balances[_to] = balances[_to].add(_value);
91     balances[_from] = balances[_from].sub(_value);
92     allowed[_from][msg.sender] = _allowance.sub(_value);
93     Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    * @param _spender The address which will spend the funds.
100    * @param _value The amount of tokens to be spent.
101    */
102   function approve(address _spender, uint256 _value) public returns (bool) {
103 
104     // To change the approve amount you first have to reduce the addresses`
105     //  allowance to zero by calling `approve(_spender, 0)` if it is not
106     //  already 0 to mitigate the race condition described here:
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
109 
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifing the amount of tokens still avaible for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146   modifier onlyOwner() {
147     require(msg.sender == owner);
148     _;
149   }
150 }
151 
152 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160   address public owner;
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner {
186     if (newOwner != address(0)) {
187       owner = newOwner;
188     }
189   }
190 
191 }
192 
193 // File: contracts/Sale.sol
194 
195 /**
196  * @title Crowdsale
197  * @dev Crowdsale is a base contract for managing a token crowdsale.
198  * Crowdsales have a start and end block, where investors can make
199  * token purchases and the crowdsale will assign them tokens based
200  * on a token per ETH rate. Funds collected are forwarded to a wallet
201  * as they arrive.
202  */
203 contract Sale is Ownable{
204   using SafeMath for uint256;
205 
206   // The token being sold
207   GRAD public token;
208 
209   // start and end block where investments are allowed (both inclusive)
210   uint256 public startBlock;
211   uint256 public endBlock;
212 
213   // address where funds are collected
214   address public wallet;
215 
216   // how many token units a buyer gets per wei
217   uint256 public rate;
218 
219   // amount of raised money in wei
220   uint256 public weiRaised;
221 
222   bool private isSaleActive;
223   /**
224    * event for token purchase logging
225    * @param purchaser who paid for the tokens
226    * @param beneficiary who got the tokens
227    * @param value weis paid for purchase
228    * @param amount amount of tokens purchased
229    */
230   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
231 
232 
233   function Sale(uint256 _startBlock, uint256 _rate, address _wallet) public {
234     require(_startBlock >= block.number);
235     require(_rate > 0);
236     require(_wallet != 0x0);
237 
238     owner = msg.sender;
239     token = createTokenContract();
240     startBlock = _startBlock;
241     rate = _rate;
242     wallet = _wallet;
243   }
244 
245   // creates the token to be sold.
246   // override this method to have crowdsale of a specific mintable token.
247   function createTokenContract() internal returns (GRAD) {
248     return new GRAD();
249   }
250 
251 
252   // fallback function can be used to buy tokens
253   function () payable public {
254     buyTokens(msg.sender);
255   }
256 
257   // low level token purchase function
258   function buyTokens(address beneficiary) payable public {
259     require(beneficiary != 0x0);
260     require(validPurchase());
261 
262     uint256 weiAmount = msg.value;
263 
264     // calculate token amount to be created
265     uint256 tokens = weiAmount.mul(rate);
266 
267     uint256 bonus = calclulateBonus(weiAmount);
268 
269     // update state
270     weiRaised = weiRaised.add(weiAmount);
271 
272     token.mint(beneficiary, tokens.add(bonus));
273     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens.add(bonus));
274 
275     forwardFunds();
276   }
277 
278   // send ether to the fund collection wallet
279   // override to create custom fund forwarding mechanisms
280   function forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 
284   //
285   function calclulateBonus(uint256 _weiAmount) internal pure returns (uint256) {
286     uint256 weiAmount = _weiAmount;
287     // 7% over 10 eth
288     // 5% over 5 eth
289     // 3 over 2.5 eth
290     if (weiAmount >= 1e18 * 10) {
291       return (weiAmount.mul(7)).div(100);
292     } else if (weiAmount >= 1e18 * 5) {
293       return (weiAmount.mul(5)).div(100);
294     } else if (weiAmount >= 1e17 * 25) {
295       return (weiAmount.mul(3)).div(100);
296     } else {
297       return 0;
298     }
299 
300   }
301 
302   // @return true if the transaction can buy tokens
303   function validPurchase() internal constant returns (bool) {
304     uint256 current = block.number;
305     bool withinPeriod = current >= startBlock;
306     bool withinSaleRunning = isSaleActive;
307     bool nonZeroPurchase = msg.value != 0;
308     return withinPeriod && nonZeroPurchase && withinSaleRunning;
309   }
310 
311 
312   //disable if enabled
313   function disableSale() onlyOwner() public returns (bool) {
314     require(isSaleActive == true);
315     isSaleActive = false;
316     return true;
317   }
318 
319   // enable if diabled
320   function enableSale()  onlyOwner() public returns (bool) {
321     require(isSaleActive == false);
322     isSaleActive = true;
323     return true;
324   }
325 
326   // retruns true if sale is currently active
327   function saleStatus() public constant returns (bool){
328     return isSaleActive;
329   }
330 
331 }