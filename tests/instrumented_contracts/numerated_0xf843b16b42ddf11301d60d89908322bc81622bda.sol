1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
135 
136 /**
137  * @title Burnable Token
138  * @dev Token that can be irreversibly burned (destroyed).
139  */
140 contract BurnableToken is BasicToken {
141 
142     event Burn(address indexed burner, uint256 value);
143 
144     /**
145      * @dev Burns a specific amount of tokens.
146      * @param _value The amount of token to be burned.
147      */
148     function burn(uint256 _value) public {
149         require(_value <= balances[msg.sender]);
150         // no need to require value <= totalSupply, since that would imply the
151         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
152 
153         address burner = msg.sender;
154         balances[burner] = balances[burner].sub(_value);
155         totalSupply = totalSupply.sub(_value);
156         Burn(burner, _value);
157     }
158 }
159 
160 // File: contracts/Distribution.sol
161 
162 /**
163  * @title Distribution contract
164  * @dev see https://send.sd/distribution
165  */
166 contract Distribution is Ownable {
167   using SafeMath for uint256;
168 
169   uint16 public stages;
170   uint256 public stageDuration;
171   uint256 public startTime;
172 
173   uint256 public soldTokens;
174   uint256 public bonusClaimedTokens;
175   uint256 public raisedETH;
176   uint256 public raisedUSD;
177 
178   uint256 public weiUsdRate;
179 
180   BurnableToken public token;
181 
182   bool public isActive;
183   uint256 public cap;
184   uint256 public stageCap;
185 
186   mapping (address => mapping (uint16 => uint256)) public contributions;
187   mapping (uint16 => uint256) public sold;
188   mapping (uint16 => bool) public burned;
189   mapping (address => mapping (uint16 => bool)) public claimed;
190 
191   event NewPurchase(
192     address indexed purchaser,
193     uint256 sdtAmount,
194     uint256 usdAmount,
195     uint256 ethAmount
196   );
197 
198   event NewBonusClaim(
199     address indexed purchaser,
200     uint256 sdtAmount
201   );
202 
203   function Distribution(
204       uint16 _stages,
205       uint256 _stageDuration,
206       address _token
207   ) public {
208     stages = _stages;
209     stageDuration = _stageDuration;
210     isActive = false;
211     token = BurnableToken(_token);
212   }
213 
214   /**
215    * @dev contribution function
216    */
217   function () external payable {
218     require(isActive);
219     require(weiUsdRate > 0);
220     require(getStage() < stages);
221 
222     uint256 usd = msg.value / weiUsdRate;
223     uint256 tokens = computeTokens(usd);
224     uint16 stage = getStage();
225 
226     sold[stage] = sold[stage].add(tokens);
227     require(sold[stage] < stageCap);
228 
229     contributions[msg.sender][stage] = contributions[msg.sender][stage].add(tokens);
230     soldTokens = soldTokens.add(tokens);
231     raisedETH = raisedETH.add(msg.value);
232     raisedUSD = raisedUSD.add(usd);
233 
234     NewPurchase(msg.sender, tokens, usd, msg.value);
235     token.transfer(msg.sender, tokens);
236   }
237 
238   /**
239    * @dev Initialize distribution
240    * @param _cap uint256 The amount of tokens for distribution
241    */
242   function init(uint256 _cap, uint256 _startTime) public onlyOwner {
243     require(!isActive);
244     require(token.balanceOf(this) == _cap);
245     require(_startTime > block.timestamp);
246 
247     startTime = _startTime;
248     cap = _cap;
249     stageCap = cap / stages;
250     isActive = true;
251   }
252 
253   /**
254    * @dev retrieve bonus from specified stage
255    * @param _stage uint16 The stage
256    */
257   function claimBonus(uint16 _stage) public {
258     require(!claimed[msg.sender][_stage]);
259     require(getStage() > _stage);
260 
261     if (!burned[_stage]) {
262       token.burn(stageCap.sub(sold[_stage]).sub(sold[_stage].mul(computeBonus(_stage)).div(1 ether)));
263       burned[_stage] = true;
264     }
265 
266     uint256 tokens = computeAddressBonus(_stage);
267     token.transfer(msg.sender, tokens);
268     bonusClaimedTokens = bonusClaimedTokens.add(tokens);
269     claimed[msg.sender][_stage] = true;
270 
271     NewBonusClaim(msg.sender, tokens);
272   }
273 
274   /**
275    * @dev set an exchange rate in wei
276    * @param _rate uint256 The new exchange rate
277    */
278   function setWeiUsdRate(uint256 _rate) public onlyOwner {
279     require(_rate > 0);
280     weiUsdRate = _rate;
281   }
282 
283   /**
284    * @dev retrieve ETH
285    * @param _amount uint256 The new exchange rate
286    * @param _address address The address to receive ETH
287    */
288   function forwardFunds(uint256 _amount, address _address) public onlyOwner {
289     _address.transfer(_amount);
290   }
291 
292   /**
293    * @dev compute tokens given a USD value
294    * @param _usd uint256 Value in USD
295    */
296   function computeTokens(uint256 _usd) public view returns(uint256) {
297     return _usd.mul(1000000000000000000 ether).div(
298       soldTokens.mul(19800000000000000000).div(cap).add(200000000000000000)
299     );
300   }
301 
302   /**
303    * @dev current stage
304    */
305   function getStage() public view returns(uint16) {
306     require(block.timestamp >= startTime);
307     return uint16(uint256(block.timestamp).sub(startTime).div(stageDuration));
308   }
309 
310   /**
311    * @dev compute bonus (%) for a specified stage
312    * @param _stage uint16 The stage
313    */
314   function computeBonus(uint16 _stage) public view returns(uint256) {
315     return uint256(100000000000000000).sub(sold[_stage].mul(100000).div(441095890411));
316   }
317 
318   /**
319    * @dev compute for a specified stage
320    * @param _stage uint16 The stage
321    */
322   function computeAddressBonus(uint16 _stage) public view returns(uint256) {
323     return contributions[msg.sender][_stage].mul(computeBonus(_stage)).div(1 ether);
324   }
325 
326   //////////
327   // Safety Methods
328   //////////
329   /// @notice This method can be used by the controller to extract mistakenly
330   ///  sent tokens to this contract.
331   /// @param _token The address of the token contract that you want to recover
332   ///  set to 0 in case you want to extract ether.
333   function claimTokens(address _token) public onlyOwner {
334     // owner can claim any token but SDT
335     require(_token != address(token));
336     if (_token == 0x0) {
337       owner.transfer(this.balance);
338       return;
339     }
340 
341     ERC20Basic erc20token = ERC20Basic(_token);
342     uint256 balance = erc20token.balanceOf(this);
343     erc20token.transfer(owner, balance);
344     ClaimedTokens(_token, owner, balance);
345   }
346 
347   event ClaimedTokens(
348     address indexed _token,
349     address indexed _controller,
350     uint256 _amount
351   );
352 }