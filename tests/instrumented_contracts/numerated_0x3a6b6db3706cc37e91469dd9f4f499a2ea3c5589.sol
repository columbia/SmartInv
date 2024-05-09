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
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77   mapping(address => uint256) balances;
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 }
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public constant returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119   mapping (address => mapping (address => uint256)) internal allowed;
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 }
182 /**
183  * @title Mintable token
184  * @dev Simple ERC20 Token example, with mintable token creation
185  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
186  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
187  */
188 contract MintableToken is StandardToken, Ownable {
189   event Mint(address indexed to, uint256 amount);
190   event MintFinished();
191   bool public mintingFinished = false;
192   modifier canMint() {
193     require(!mintingFinished);
194     _;
195   }
196   /**
197    * @dev Function to mint tokens
198    * @param _to The address that will receive the minted tokens.
199    * @param _amount The amount of tokens to mint.
200    * @return A boolean that indicates if the operation was successful.
201    */
202   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
203     totalSupply = totalSupply.add(_amount);
204     balances[_to] = balances[_to].add(_amount);
205     Mint(_to, _amount);
206     Transfer(address(0), _to, _amount);
207     return true;
208   }
209   /**
210    * @dev Function to stop minting new tokens.
211    * @return True if the operation was successful.
212    */
213   function finishMinting() onlyOwner public returns (bool) {
214     mintingFinished = true;
215     MintFinished();
216     return true;
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
251     require(_wallet != address(0));
252     token = createTokenContract();
253     startTime = _startTime;
254     endTime = _endTime;
255     rate = _rate;
256     wallet = _wallet;
257   }
258   // creates the token to be sold.
259   // override this method to have crowdsale of a specific mintable token.
260   function createTokenContract() internal returns (MintableToken) {
261     return new MintableToken();
262   }
263   // fallback function can be used to buy tokens
264   function () payable {
265     buyTokens(msg.sender);
266   }
267   // low level token purchase function
268   function buyTokens(address beneficiary) public payable {
269     require(beneficiary != address(0));
270     require(validPurchase());
271     uint256 weiAmount = msg.value;
272     // calculate token amount to be created
273     uint256 tokens = weiAmount.mul(rate);
274     // update state
275     weiRaised = weiRaised.add(weiAmount);
276     token.mint(beneficiary, tokens);
277     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
278     forwardFunds();
279   }
280   // send ether to the fund collection wallet
281   // override to create custom fund forwarding mechanisms
282   function forwardFunds() internal {
283     wallet.transfer(msg.value);
284   }
285   // @return true if the transaction can buy tokens
286   function validPurchase() internal constant returns (bool) {
287     bool withinPeriod = now >= startTime && now <= endTime;
288     bool nonZeroPurchase = msg.value != 0;
289     return withinPeriod && nonZeroPurchase;
290   }
291   // @return true if crowdsale event has ended
292   function hasEnded() public constant returns (bool) {
293     return now > endTime;
294   }
295 }
296 
297 contract FaceblockCrowdsale is Crowdsale {
298     function FaceblockCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) 
299         Crowdsale(_startTime, _endTime, _rate, _wallet)
300     {
301 
302     }
303 
304     function createTokenContract() internal returns (MintableToken) {
305         return new FaceblockToken();
306     }
307 }
308 
309 contract FaceblockToken is MintableToken {
310     string public constant name = "FaceblockToken";
311     string public constant symbol = "FBL";
312     uint8 public constant decimals = 18;
313 }