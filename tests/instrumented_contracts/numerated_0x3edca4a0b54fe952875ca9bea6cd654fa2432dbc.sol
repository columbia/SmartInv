1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48 
49     // SafeMath.sub will throw if there is not enough balance.
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) public constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public constant returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86 
87     uint256 _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    *
102    * Beware that changing an allowance with this method brings the risk that someone may use both the old
103    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106    * @param _spender The address which will spend the funds.
107    * @param _value The amount of tokens to be spent.
108    */
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125   /**
126    * approve should be called when allowed[_spender] == 0. To increment
127    * allowed value is better to use this function to avoid 2 calls (and wait until
128    * the first transaction is mined)
129    * From MonolithDAO Token.sol
130    */
131   function increaseApproval (address _spender, uint _addedValue)
132     returns (bool success) {
133     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138   function decreaseApproval (address _spender, uint _subtractedValue)
139     returns (bool success) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 }
150 
151 contract Ownable {
152   address public owner;
153 
154 
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner public {
181     require(newOwner != address(0));
182     OwnershipTransferred(owner, newOwner);
183     owner = newOwner;
184   }
185 }
186 
187 contract MintableToken is StandardToken, Ownable {
188   event Mint(address indexed to, uint256 amount);
189   event MintFinished();
190 
191   bool public mintingFinished = false;
192 
193 
194   modifier canMint() {
195     require(!mintingFinished);
196     _;
197   }
198 
199   /**
200    * @dev Function to mint tokens
201    * @param _to The address that will receive the minted tokens.
202    * @param _amount The amount of tokens to mint.
203    * @return A boolean that indicates if the operation was successful.
204    */
205   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
206     totalSupply = totalSupply.add(_amount);
207     balances[_to] = balances[_to].add(_amount);
208     Mint(_to, _amount);
209     Transfer(0x0, _to, _amount);
210     return true;
211   }
212 
213   /**
214    * @dev Function to stop minting new tokens.
215    * @return True if the operation was successful.
216    */
217   function finishMinting() onlyOwner public returns (bool) {
218     mintingFinished = true;
219     MintFinished();
220     return true;
221   }
222 }
223 
224 contract ChurchCoin is MintableToken {
225   string public name = "CHURCH COIN";
226   string public symbol = "CRC";
227   uint256 public decimals = 18;
228 }
229 
230 contract Crowdsale {
231   using SafeMath for uint256;
232 
233   // The token being sold
234   MintableToken public token;
235 
236   // start and end timestamps where investments are allowed (both inclusive)
237   uint256 public startTime;
238   uint256 public endTime;
239 
240   // address where funds are collected
241   address public wallet;
242 
243   // how many token units a buyer gets per wei
244   uint256 public rate;  
245 
246   // how many token units a buyer gets per wei
247   uint256 public cap;
248 
249   // amount of raised money in wei
250   uint256 public weiRaised;
251 
252   /**
253    * event for token purchase logging
254    * @param purchaser who paid for the tokens
255    * @param beneficiary who got the tokens
256    * @param value weis paid for purchase
257    * @param amount amount of tokens purchased
258    */
259   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
260 
261 
262   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet) {
263     token = createTokenContract();
264     startTime = _startTime;
265     endTime = _endTime;
266     rate = _rate;
267     cap = _cap;
268     wallet = _wallet;
269   }
270 
271   // creates the token to be sold.
272   // override this method to have crowdsale of a specific mintable token.
273   function createTokenContract() internal returns (MintableToken) {
274     return new MintableToken();
275   }
276 
277 
278   // fallback function can be used to buy tokens
279   function () payable {
280     buyTokens(msg.sender);
281   }
282 
283   // low level token purchase function
284   function buyTokens(address beneficiary) public payable {
285     require(beneficiary != 0x0);
286     require(validPurchase());
287 
288     uint256 weiAmount = msg.value;
289 
290     // calculate token amount to be created
291     uint256 tokens = weiAmount.mul(rate);
292 
293     // update state
294     weiRaised = weiRaised.add(weiAmount);
295 
296     token.mint(beneficiary, tokens);
297     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
298 
299     forwardFunds();
300   }
301 
302   // send ether to the fund collection wallet
303   // override to create custom fund forwarding mechanisms
304   function forwardFunds() internal {
305     wallet.transfer(msg.value);
306   }
307 
308   // @return true if the transaction can buy tokens
309   function validPurchase() internal constant returns (bool) {
310     bool withinPeriod = now >= startTime && now <= endTime;
311     bool withinCap = weiRaised.add(msg.value) <= cap;
312     bool nonZeroPurchase = msg.value != 0;
313     return withinPeriod && nonZeroPurchase && withinCap;
314   }
315 
316   // @return true if crowdsale event has ended
317   function hasEnded() public constant returns (bool) {
318     bool capReached = weiRaised >= cap;
319 
320     return now > endTime || capReached;
321   }
322 }
323 
324 contract ChurchCrowdsale is Crowdsale {
325 
326   uint256 _startTime = 0;
327   uint256 _endTime = 1514764799; // 31st Dec 2017 23:59 UTC
328   uint256 _rate = 1000;
329   uint256 _cap = 400000000000000000000; // 400 ETH, 
330   address _wallet = 0x85A363699C6864248a6FfCA66e4a1A5cCf9f5567;
331   
332   // Hardcoding constuctor parameters for simplicity: https://etherscanio.freshdesk.com/support/solutions/articles/16000053599-contract-verification-constructor-arguments
333 
334   function ChurchCrowdsale() Crowdsale(_startTime, _endTime, _rate, _cap, _wallet) {          
335   }
336 
337   // creates the token to be sold.
338   // override this method to have crowdsale of a specific MintableToken token.
339   function createTokenContract() internal returns (MintableToken) {
340     return new ChurchCoin();
341   }
342 }