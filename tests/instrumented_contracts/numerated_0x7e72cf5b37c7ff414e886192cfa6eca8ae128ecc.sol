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
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 /**
70  * @title Crowdsale 
71  * @dev Crowdsale is a base contract for managing a token crowdsale.
72  * Crowdsales have a start and end timestamps, where investors can make
73  * token purchases and the crowdsale will assign them tokens based
74  * on a token per ETH rate. Funds collected are forwarded to a wallet 
75  * as they arrive.
76  */
77 contract Crowdsale {
78   using SafeMath for uint256;
79   // The token being sold
80   MintableToken public token;
81   // start and end timestamps where investments are allowed (both inclusive)
82   uint256 public startTime;
83   uint256 public endTime;
84   // address where funds are collected
85   address public wallet;
86   // how many token units a buyer gets per wei
87   uint256 public rate;
88   // amount of raised money in wei
89   uint256 public weiRaised;
90   /**
91    * event for token purchase logging
92    * @param purchaser who paid for the tokens
93    * @param beneficiary who got the tokens
94    * @param value weis paid for purchase
95    * @param amount amount of tokens purchased
96    */ 
97   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
98   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
99     require(_startTime >= now);
100     require(_endTime >= _startTime);
101     require(_rate > 0);
102     require(_wallet != 0x0);
103     token = createTokenContract();
104     startTime = _startTime;
105     endTime = _endTime;
106     rate = _rate;
107     wallet = _wallet;
108   }
109   // creates the token to be sold. 
110   // override this method to have crowdsale of a specific mintable token.
111   function createTokenContract() internal returns (MintableToken) {
112     return new MintableToken();
113   }
114   // fallback function can be used to buy tokens
115   function () payable {
116     buyTokens(msg.sender);
117   }
118   // low level token purchase function
119   function buyTokens(address beneficiary) payable {
120     require(beneficiary != 0x0);
121     require(validPurchase());
122     uint256 weiAmount = msg.value;
123     // calculate token amount to be created
124     uint256 tokens = weiAmount.mul(rate);
125     // update state
126     weiRaised = weiRaised.add(weiAmount);
127     token.mint(beneficiary, tokens);
128     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
129     forwardFunds();
130   }
131   // send ether to the fund collection wallet
132   // override to create custom fund forwarding mechanisms
133   function forwardFunds() internal {
134     wallet.transfer(msg.value);
135   }
136   // @return true if the transaction can buy tokens
137   function validPurchase() internal constant returns (bool) {
138     bool withinPeriod = now >= startTime && now <= endTime;
139     bool nonZeroPurchase = msg.value != 0;
140     return withinPeriod && nonZeroPurchase;
141   }
142   // @return true if crowdsale event has ended
143   function hasEnded() public constant returns (bool) {
144     return now > endTime;
145   }
146 }
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances. 
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153   mapping(address => uint256) balances;
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) returns (bool) {
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of. 
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) constant returns (uint256 balance) {
171     return balances[_owner];
172   }
173 }
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) constant returns (uint256);
180   function transferFrom(address from, address to, uint256 value) returns (bool);
181   function approve(address spender, uint256 value) returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192   mapping (address => mapping (address => uint256)) allowed;
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amout of tokens to be transfered
198    */
199   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
200     var _allowance = allowed[_from][msg.sender];
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203     balances[_to] = balances[_to].add(_value);
204     balances[_from] = balances[_from].sub(_value);
205     allowed[_from][msg.sender] = _allowance.sub(_value);
206     Transfer(_from, _to, _value);
207     return true;
208   }
209   /**
210    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) returns (bool) {
215     // To change the approve amount you first have to reduce the addresses`
216     //  allowance to zero by calling `approve(_spender, 0)` if it is not
217     //  already 0 to mitigate the race condition described here:
218     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifing the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
231     return allowed[_owner][_spender];
232   }
233 }
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract MintableToken is StandardToken, Ownable {
241   event Mint(address indexed to, uint256 amount);
242   event MintFinished();
243   bool public mintingFinished = false;
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248   /**
249    * @dev Function to mint tokens
250    * @param _to The address that will recieve the minted tokens.
251    * @param _amount The amount of tokens to mint.
252    * @return A boolean that indicates if the operation was successful.
253    */
254   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
255     totalSupply = totalSupply.add(_amount);
256     balances[_to] = balances[_to].add(_amount);
257     Mint(_to, _amount);
258     Transfer(0x0, _to, _amount);
259     return true;
260   }
261   /**
262    * @dev Function to stop minting new tokens.
263    * @return True if the operation was successful.
264    */
265   function finishMinting() onlyOwner returns (bool) {
266     mintingFinished = true;
267     MintFinished();
268     return true;
269   }
270 }
271 contract EverhuskToken is MintableToken {
272     string public constant name = "EverhuskToken";
273     string public constant symbol = "SUKH";
274     uint8 public constant decimals = 18;
275 }
276 contract EverhuskCrowdsale is Crowdsale {
277     function EverhuskCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) 
278         Crowdsale(_startTime, _endTime, _rate, _wallet)
279     {
280     }
281     function createTokenContract() internal returns (MintableToken) {
282         return new EverhuskToken();
283     }
284 }