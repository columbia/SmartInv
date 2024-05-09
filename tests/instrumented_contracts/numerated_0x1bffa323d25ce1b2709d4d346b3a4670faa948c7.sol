1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {    uint256 c = a * b;    assert(a == 0 || c / a == b);    return c;  }
6 
7   function div(uint256 a, uint256 b) internal constant returns (uint256) {
8     // assert(b > 0); // Solidity automatically throws when dividing by 0
9     uint256 c = a / b;
10     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) constant returns (uint256);
30   function transfer(address to, uint256 value) returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint256 _value) returns (bool) {
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of.
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) allowed;
75 
76 
77   /**
78    * @dev Transfer tokens from one address to another
79    * @param _from address The address which you want to send tokens from
80    * @param _to address The address which you want to transfer to
81    * @param _value uint256 the amout of tokens to be transfered
82    */
83   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
84     var _allowance = allowed[_from][msg.sender];
85 
86     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
87     // require (_value <= _allowance);
88 
89     balances[_to] = balances[_to].add(_value);
90     balances[_from] = balances[_from].sub(_value);
91     allowed[_from][msg.sender] = _allowance.sub(_value);
92     Transfer(_from, _to, _value);
93     return true;
94   }
95 
96   /**
97    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
98    * @param _spender The address which will spend the funds.
99    * @param _value The amount of tokens to be spent.
100    */
101   function approve(address _spender, uint256 _value) returns (bool) {
102 
103     // To change the approve amount you first have to reduce the addresses`
104     //  allowance to zero by calling `approve(_spender, 0)` if it is not
105     //  already 0 to mitigate the race condition described here:
106     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifing the amount of tokens still avaible for the spender.
119    */
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124 }
125 
126 
127 contract Stars is StandardToken {
128 
129   string public name = "Stars";
130   string public symbol = "STR";
131   uint public decimals = 8;
132   uint public INITIAL_SUPPLY = 60000000 * 10**8;  // 100 millions tokens
133 
134   /**
135    * @dev Contructor that gives msg.sender all of existing tokens.
136    */
137   function Stars() {
138     totalSupply = INITIAL_SUPPLY;
139     balances[msg.sender] = INITIAL_SUPPLY;
140   }
141 }
142 
143 
144 contract Ownable {
145   address public owner;
146 
147 
148   /**
149    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
150    * account.
151    */
152   function Ownable() {
153     owner = msg.sender;
154   }
155 
156 
157   /**
158    * @dev Throws if called by any account other than the owner.
159    */
160   modifier onlyOwner() {
161     require(msg.sender == owner);
162     _;
163   }
164 
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) onlyOwner {
171     if (newOwner != address(0)) {
172       owner = newOwner;
173     }
174   }
175 
176 }
177 
178 
179 contract Pausable is Ownable {
180   event Pause();
181   event Unpause();
182 
183   bool public paused = false;
184 
185 
186   /**
187    * @dev modifier to allow actions only when the contract IS paused
188    */
189   modifier whenNotPaused() {
190     require(!paused);
191     _;
192   }
193 
194   /**
195    * @dev modifier to allow actions only when the contract IS NOT paused
196    */
197   modifier whenPaused {
198     require(paused);
199     _;
200   }
201 
202   /**
203    * @dev called by the owner to pause, triggers stopped state
204    */
205   function pause() onlyOwner whenNotPaused returns (bool) {
206     paused = true;
207     Pause();
208     return true;
209   }
210 
211   /**
212    * @dev called by the owner to unpause, returns to normal state
213    */
214   function unpause() onlyOwner whenPaused returns (bool) {
215     paused = false;
216     Unpause();
217     return true;
218   }
219 }
220 
221 
222 contract StarsICO is Pausable {
223   using SafeMath for uint256;
224 
225   uint256 public constant MAX_GAS_PRICE = 50000000000 wei;    // maximum gas price for contribution transactions
226 
227   // start and end timestamps where investments are allowed (both inclusive)
228   uint256 public startTime;
229   uint256 public endTime;
230 
231   // address where funds are collected
232   address public wallet_address;
233 
234   // address of the Stars token
235   address public token_address;
236 
237   // how many token units a buyer gets per wei
238   uint256 public rate;
239 
240   // upper capacity tokens to sold
241   uint256 public capTokens;
242 
243   // amount of raised money in wei
244   uint256 public weiRaised;
245   uint256 public tokensSold;
246 
247   /**
248    * event for token purchase logging
249    * @param purchaser who paid for the tokens
250    * @param beneficiary who got the tokens
251    * @param value weis paid for purchase
252    * @param amount amount of tokens purchased
253    */
254   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
255 
256   // verifies that the gas price is lower than 50 gwei
257   modifier validGasPrice() {
258     require(tx.gasprice <= MAX_GAS_PRICE);
259     _;
260   }
261 
262   function StarsICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet_address, address _token_address, uint256 _cap) {
263     // require(_startTime >= now);
264     require(_endTime >= _startTime);
265     require(_rate > 0);
266     require(_wallet_address != 0x0);
267     require(_token_address != 0x0);
268     require(_cap > 0);
269 
270     startTime = _startTime;
271     endTime = _endTime;
272     rate = _rate;
273     wallet_address = _wallet_address;
274     token_address = _token_address;
275     capTokens = _cap;
276   }
277 
278   // fallback function can be used to buy tokens
279   function () payable {
280     buyTokens(msg.sender);
281   }
282 
283   // low level token purchase function
284   function buyTokens(address beneficiary) whenNotPaused validGasPrice private {
285     require(beneficiary != 0x0);
286     require(validPurchase());
287 
288     uint256 weiAmount = msg.value;
289     uint256 tokens = convertWeiToTokens(weiAmount);
290 
291     wallet_address.transfer(msg.value);
292     Stars tok = Stars(token_address);
293     if (tok.transferFrom(wallet_address, beneficiary, tokens)) {
294       // update state
295       weiRaised = weiRaised.add(weiAmount);
296       tokensSold = tokensSold.add(tokens);
297       TokenPurchase(beneficiary, beneficiary, weiAmount, tokens);
298     }
299   }
300 
301   // @return true if the transaction can buy tokens
302   function validPurchase() internal constant returns (bool) {
303     bool withinPeriod = now >= startTime && now <= endTime;
304     bool nonZeroPurchase = msg.value != 0;
305     bool withinCap = tokensSold.add(convertWeiToTokens(msg.value)) <= capTokens;
306     return withinPeriod && nonZeroPurchase && withinCap;
307   }
308 
309   function convertWeiToTokens(uint256 weiAmount) constant returns (uint256) {
310     // calculate token amount to be created
311     uint256 tokens = weiAmount.div(10 ** 10);
312     tokens = tokens.mul(rate);
313     return tokens;
314   }
315 }