1 pragma solidity ^0.4.16;
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
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // how many token units a buyer gets per wei
40   uint256 public rate;
41 
42   // amount of raised money in wei
43   uint256 public weiRaised;
44 
45   /**
46    * event for token purchase logging
47    * @param purchaser who paid for the tokens
48    * @param beneficiary who got the tokens
49    * @param value weis paid for purchase
50    * @param amount amount of tokens purchased
51    */
52   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
53 
54   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate) {
55     require(_endTime >= _startTime);
56     require(_rate > 0);
57 
58     token = createTokenContract();
59     startTime = _startTime;
60     endTime = _endTime;
61     rate = _rate;
62 
63   }
64 
65   // creates the token to be sold.
66   // override this method to have crowdsale of a specific mintable token.
67   function createTokenContract() internal returns (MintableToken) {
68     return new MintableToken();
69   }
70 
71 
72   // fallback function can be used to buy tokens
73   function () payable {
74     buyTokens(msg.sender);
75   }
76 
77   // low level token purchase function
78   function buyTokens(address beneficiary) public payable {
79     require(beneficiary != 0x0);
80     require(msg.value >= 0.5 ether);
81 
82     uint256 weiAmount = msg.value;
83 
84 
85     // calculate token amount to be created
86     uint256 tokens = weiAmount.mul(rate);
87 
88     // update state
89     weiRaised = weiRaised.add(weiAmount);
90 
91     token.mint(beneficiary, tokens);
92     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
93 
94   }
95 
96   // @return true if crowdsale event has ended
97   function hasEnded() public constant returns (bool) {
98     return now > endTime;
99   }
100 
101 
102 }
103 
104 
105 contract Ownable {
106   address public owner;
107 
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111 
112   /**
113    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
114    * account.
115    */
116   function Ownable() {
117     owner = msg.sender;
118   }
119 
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) onlyOwner public {
135     require(newOwner != address(0));
136     OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140 }
141 
142 
143 contract zHQPreSale is Crowdsale, Ownable {
144 
145   // number of participants in the SelfPay Pre-Sale
146   uint256 public numberOfPurchasers = 0;
147 
148   //Who bought for how much
149   mapping(address => uint256) bought;
150 
151   // Total zHQ
152   uint256 public zHQNumber = 0;
153 
154   // Ensure the gold level bonus can only be used once
155   bool public goldLevelBonusIsUsed = false;
156 
157   address dev;
158   address public owner;
159 
160   function zHQPreSale()
161     Crowdsale(1506837600, 1606837600, 300) public
162   {
163     // As goal needs to be met for a successful crowdsale the value needs to be less
164     // than or equal than a cap which is limit for accepted funds
165     owner = msg.sender;
166     dev = msg.sender;
167 
168   }
169 
170   //Need to update sale params after publish because of UI bug
171   //TODO: maybe get this reviewed by Josh
172   function configSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap) public {
173     startTime = _startTime;
174     endTime = _endTime;
175     rate = _rate;
176 
177     owner = msg.sender;
178   }
179 
180   //Refund when something goes wrong
181 
182   function refund(address _buyer, uint _weiAmount) onlyOwner public {
183     if(msg.sender == owner) {
184       if(bought[_buyer] > 0) {
185         _buyer.send(_weiAmount);
186         bought[_buyer] = bought[_buyer] - _weiAmount;
187       }
188     }
189   }
190 
191   // low level token purchase function
192   function buyTokens(address beneficiary) public payable {
193     require(beneficiary != 0x0);
194     require(msg.value >= 0.5 ether);
195 
196     uint256 weiAmount = msg.value;
197 
198     bought[beneficiary] += weiAmount;
199     // Calculate the number of tokens
200     uint256 tokens = weiAmount.mul(rate);
201 
202     token.mint(beneficiary, tokens);
203     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
204 
205     // update state
206     weiRaised = weiRaised.add(weiAmount);
207     numberOfPurchasers = numberOfPurchasers + 1;
208     zHQNumber = zHQNumber.add(tokens);
209 
210   }
211 
212   //end of sale withdrawl
213   //don't keep our junk on blockchain
214   function withdraw() public {
215     if(msg.sender == dev) {
216       selfdestruct(msg.sender);
217     }
218   }
219 
220 
221 }
222 
223 contract ERC20Basic {
224   uint256 public totalSupply;
225   function balanceOf(address who) public constant returns (uint256);
226   function transfer(address to, uint256 value) public returns (bool);
227   event Transfer(address indexed from, address indexed to, uint256 value);
228 }
229 
230 contract BasicToken is ERC20Basic {
231   using SafeMath for uint256;
232 
233   mapping(address => uint256) balances;
234 
235   /**
236   * @dev transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242 
243     // SafeMath.sub will throw if there is not enough balance.
244     balances[msg.sender] = balances[msg.sender].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     Transfer(msg.sender, _to, _value);
247     return true;
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param _owner The address to query the the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address _owner) public constant returns (uint256 balance) {
256     return balances[_owner];
257   }
258 
259 }
260 
261 
262 contract StandardToken is ERC20Basic, BasicToken {
263 
264   mapping (address => mapping (address => uint256)) allowed;
265 
266 
267   /**
268    * @dev Transfer tokens from one address to another
269    * @param _from address The address which you want to send tokens from
270    * @param _to address The address which you want to transfer to
271    * @param _value uint256 the amount of tokens to be transferred
272    */
273   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
274     require(_to != address(0));
275 
276     uint256 _allowance = allowed[_from][msg.sender];
277 
278     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
279     // require (_value <= _allowance);
280 
281     balances[_from] = balances[_from].sub(_value);
282     balances[_to] = balances[_to].add(_value);
283     allowed[_from][msg.sender] = _allowance.sub(_value);
284     Transfer(_from, _to, _value);
285     return true;
286   }
287 
288 
289 }
290 
291 
292 contract MintableToken is StandardToken, Ownable {
293   event Mint(address indexed to, uint256 amount);
294   event MintFinished();
295 
296   bool public mintingFinished = false;
297 
298 
299   modifier canMint() {
300     require(!mintingFinished);
301     _;
302   }
303 
304   /**
305    * @dev Function to mint tokens
306    * @param _to The address that will receive the minted tokens.
307    * @param _amount The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    */
310   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
311     totalSupply = totalSupply.add(_amount);
312     balances[_to] = balances[_to].add(_amount);
313     Mint(_to, _amount);
314     Transfer(0x0, _to, _amount);
315     return true;
316   }
317 
318   /**
319    * @dev Function to stop minting new tokens.
320    * @return True if the operation was successful.
321    */
322   function finishMinting() onlyOwner public returns (bool) {
323     mintingFinished = true;
324     MintFinished();
325     return true;
326   }
327 }
328 
329 contract zHQToken is MintableToken {
330     string public constant name = "zHQ Token";
331     string public constant symbol = "zHQ";
332     uint256 public decimals = 18;
333 
334     /**
335      * @dev Allows anyone to transfer the zHQ Token tokens once trading has started
336      * @param _to the recipient address of the tokens.
337      * @param _value number of tokens to be transfered.
338      */
339     function transfer(address _to, uint _value) public returns (bool){
340         return super.transfer(_to, _value);
341     }
342 
343 }