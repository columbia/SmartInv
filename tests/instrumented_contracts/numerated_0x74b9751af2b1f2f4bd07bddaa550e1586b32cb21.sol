1 pragma solidity ^0.4.3;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) constant returns (uint256);
34   function transfer(address to, uint256 value) returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) returns (bool) {
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
61   function balanceOf(address _owner) constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) returns (bool);
71   function approve(address spender, uint256 value) returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) allowed;
79 
80 
81   /**
82    * @dev Transfer tokens from one address to another
83    * @param _from address The address which you want to send tokens from
84    * @param _to address The address which you want to transfer to
85    * @param _value uint256 the amout of tokens to be transfered
86    */
87   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_to] = balances[_to].add(_value);
94     balances[_from] = balances[_from].sub(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifing the amount of tokens still avaible for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 
128 }
129 
130 
131 contract Stars is StandardToken {
132 
133   string public name = "Stars";
134   string public symbol = "STR";
135   uint public decimals = 8;
136   uint public INITIAL_SUPPLY = 60000000 * 10**8;  // 100 millions tokens
137 
138   /**
139    * @dev Contructor that gives msg.sender all of existing tokens.
140    */
141   function Stars() {
142     totalSupply = INITIAL_SUPPLY;
143     balances[msg.sender] = INITIAL_SUPPLY;
144   }
145 }
146 
147 
148 contract Ownable {
149   address public owner;
150 
151 
152   /**
153    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
154    * account.
155    */
156   function Ownable() {
157     owner = msg.sender;
158   }
159 
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169 
170   /**
171    * @dev Allows the current owner to transfer control of the contract to a newOwner.
172    * @param newOwner The address to transfer ownership to.
173    */
174   function transferOwnership(address newOwner) onlyOwner {
175     if (newOwner != address(0)) {
176       owner = newOwner;
177     }
178   }
179 
180 }
181 
182 
183 contract Pausable is Ownable {
184   event Pause();
185   event Unpause();
186 
187   bool public paused = false;
188 
189 
190   /**
191    * @dev modifier to allow actions only when the contract IS paused
192    */
193   modifier whenNotPaused() {
194     require(!paused);
195     _;
196   }
197 
198   /**
199    * @dev modifier to allow actions only when the contract IS NOT paused
200    */
201   modifier whenPaused {
202     require(paused);
203     _;
204   }
205 
206   /**
207    * @dev called by the owner to pause, triggers stopped state
208    */
209   function pause() onlyOwner whenNotPaused returns (bool) {
210     paused = true;
211     Pause();
212     return true;
213   }
214 
215   /**
216    * @dev called by the owner to unpause, returns to normal state
217    */
218   function unpause() onlyOwner whenPaused returns (bool) {
219     paused = false;
220     Unpause();
221     return true;
222   }
223 }
224 
225 
226 contract StarsICO is Pausable {
227   using SafeMath for uint256;
228 
229   uint256 public constant MAX_GAS_PRICE = 50000000000 wei;    // maximum gas price for contribution transactions
230 
231   // start and end timestamps where investments are allowed (both inclusive)
232   uint256 public startTime;
233   uint256 public endTime;
234 
235   // address where funds are collected
236   address public wallet_address;
237 
238   // address of the Stars token
239   address public token_address;
240 
241   // how many token units a buyer gets per wei
242   uint256 public rate;
243 
244   // upper capacity tokens to sold
245   uint256 public capTokens;
246 
247   // amount of raised money in wei
248   uint256 public weiRaised;
249   uint256 public tokensSold;
250 
251   /**
252    * event for token purchase logging
253    * @param purchaser who paid for the tokens
254    * @param beneficiary who got the tokens
255    * @param value weis paid for purchase
256    * @param amount amount of tokens purchased
257    */
258   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
259 
260   // verifies that the gas price is lower than 50 gwei
261   modifier validGasPrice() {
262     require(tx.gasprice <= MAX_GAS_PRICE);
263     _;
264   }
265 
266   function StarsICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet_address, address _token_address, uint256 _cap) {
267     // require(_startTime >= now);
268     require(_endTime >= _startTime);
269     require(_rate > 0);
270     require(_wallet_address != 0x0);
271     require(_token_address != 0x0);
272     require(_cap > 0);
273 
274     startTime = _startTime;
275     endTime = _endTime;
276     rate = _rate;
277     wallet_address = _wallet_address;
278     token_address = _token_address;
279     capTokens = _cap;
280   }
281 
282   // fallback function can be used to buy tokens
283   function () payable {
284     buyTokens(msg.sender);
285   }
286 
287   // low level token purchase function
288   function buyTokens(address beneficiary) whenNotPaused validGasPrice private {
289     require(beneficiary != 0x0);
290     require(validPurchase());
291 
292     uint256 weiAmount = msg.value;
293     uint256 tokens = convertWeiToTokens(weiAmount);
294 
295     wallet_address.transfer(msg.value);
296     Stars tok = Stars(token_address);
297     if (tok.transferFrom(wallet_address, beneficiary, tokens)) {
298       // update state
299       weiRaised = weiRaised.add(weiAmount);
300       tokensSold = tokensSold.add(tokens);
301       TokenPurchase(beneficiary, beneficiary, weiAmount, tokens);
302     }
303   }
304 
305   // @return true if the transaction can buy tokens
306   function validPurchase() internal constant returns (bool) {
307     bool withinPeriod = now >= startTime && now <= endTime;
308     bool nonZeroPurchase = msg.value != 0;
309     bool withinCap = tokensSold.add(convertWeiToTokens(msg.value)) <= capTokens;
310     return withinPeriod && nonZeroPurchase && withinCap;
311   }
312 
313   function convertWeiToTokens(uint256 weiAmount) constant returns (uint256) {
314     // calculate token amount to be created
315     uint256 tokens = weiAmount.div(10 ** 10);
316     tokens = tokens.mul(rate);
317     return tokens;
318   }
319 }