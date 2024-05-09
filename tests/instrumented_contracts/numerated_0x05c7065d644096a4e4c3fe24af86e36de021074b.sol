1 pragma solidity ^0.4.17;
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
13 contract Ownable {
14   address public owner;
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 }
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract SafeBasicToken is ERC20Basic {
71   using SafeMath for uint256;
72   mapping(address => uint256) balances;
73   modifier onlyPayloadSize(uint size) {
74      assert(msg.data.length >= size + 4);
75      _;
76   }
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
83     require(_to != address(0));
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public constant returns (uint256 balance) {
96     return balances[_owner];
97   }
98 }
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public constant returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract SafeStandardToken is ERC20, SafeBasicToken {
117   mapping (address => mapping (address => uint256)) allowed;
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     uint256 _allowance = allowed[_from][msg.sender];
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = _allowance.sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159   /**
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    */
165   function increaseApproval (address _spender, uint _addedValue) public
166     returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171   function decreaseApproval (address _spender, uint _subtractedValue) public
172     returns (bool success) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 }
183 contract LendConnect is SafeStandardToken{
184   string public constant name = "LendConnect Token";
185   string public constant symbol = "LCT";
186   uint256 public constant decimals = 18;
187   uint256 public constant INITIAL_SUPPLY = 6500000 * (10 ** uint256(decimals));
188   function LendConnect(address _ownerAddress) public {
189     totalSupply = INITIAL_SUPPLY;
190     balances[_ownerAddress] = INITIAL_SUPPLY;
191   }
192 }
193 contract Crowdsale is Ownable {
194   using SafeMath for uint256;
195   // The token being sold
196   LendConnect public token;
197   // start and end timestamps where investments are allowed (both inclusive
198   
199   uint256 public start_time = 1511377200;//11/22/2017 @ 7:00pm (UTC) or 8:00pm (CET)
200   uint256 public phase_1_Time = 1511809200;//11/27/2017 @ 7:00pm (UTC) or 8:00pm (CET)
201   uint256 public phase_2_Time = 1512241200;//12/02/2017 @ 7:00pm (UTC) or 8:00pm (CET)
202   uint256 public phase_3_Time = 1512673200;//12/07/2017 @ 7:00pm (UTC) or 8:00pm (CET)
203   uint256 public phase_4_Time = 1513105200;//12/12/2017 @ 7:00pm (UTC) or 8:00pm (CET)
204   uint256 public end_Time = 1513278000;//12/14/2017 @ 7:00pm (UTC) or 8:00pm (CET)
205   uint256 public phase_1_remaining_tokens  = 1000000 * (10 ** uint256(18));
206   uint256 public phase_2_remaining_tokens  = 1000000 * (10 ** uint256(18));
207   uint256 public phase_3_remaining_tokens  = 1000000 * (10 ** uint256(18));
208   uint256 public phase_4_remaining_tokens  = 1000000 * (10 ** uint256(18));
209   uint256 public phase_5_remaining_tokens  = 1000000 * (10 ** uint256(18));
210   mapping(address => uint256) phase_1_balances;
211   mapping(address => uint256) phase_2_balances;
212   mapping(address => uint256) phase_3_balances;
213   mapping(address => uint256) phase_4_balances;
214   mapping(address => uint256) phase_5_balances;
215   
216   
217   // address where funds are collected
218   address public wallet;
219   // how many token units a buyer gets per wei
220   uint256 public rate = 730;
221   // amount of raised money in wei
222   uint256 public weiRaised;
223   /**
224    * event for token purchase logging
225    * @param purchaser who paid for the tokens
226    * @param beneficiary who got the tokens
227    * @param value weis paid for purchase
228    * @param amount amount of tokens purchased
229    */
230   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
231   // rate change event
232   event RateChanged(address indexed owner, uint256 old_rate, uint256 new_rate);
233   
234   // constructor
235   function Crowdsale(address tokenContractAddress, address _walletAddress) public{
236     wallet = _walletAddress;
237     token = LendConnect(tokenContractAddress);
238   }
239   // fallback function can be used to buy tokens
240   function () payable public{
241     buyTokens(msg.sender);
242   }
243   // low level token purchase function
244   function buyTokens(address beneficiary) public payable {
245     require(beneficiary != 0x0);
246     require(validPurchase());
247     uint256 weiAmount = msg.value;
248     // calculate token amount to be created
249     uint256 tokens = weiAmount.mul(rate);
250     // Check is there are enough token available for current phase and per person  
251     require(isTokenAvailable(tokens));
252     // update state
253     weiRaised = weiRaised.add(weiAmount);
254     token.transfer(beneficiary, tokens);
255     //decrease phase supply and add user phase balance
256     updatePhaseSupplyAndBalance(tokens);
257     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
258     forwardFunds();
259   }
260   // check token availibility for current phase and max allowed token balance
261   function isTokenAvailable(uint256 _tokens) internal constant returns (bool){
262     uint256 current_time = now;
263     uint256 total_expected_tokens = 0;
264     if(current_time > start_time && current_time < phase_1_Time){
265       total_expected_tokens = _tokens + phase_1_balances[msg.sender];
266       return total_expected_tokens <= 10000 * (10 ** uint256(18)) &&
267         _tokens <= phase_1_remaining_tokens;
268     }
269     else if(current_time > phase_1_Time && current_time < phase_2_Time){
270       total_expected_tokens = _tokens + phase_2_balances[msg.sender];
271       return total_expected_tokens <= 2000 * (10 ** uint256(18)) &&
272         _tokens <= phase_2_remaining_tokens;
273     }
274     else if(current_time > phase_2_Time && current_time < phase_3_Time){
275       total_expected_tokens = _tokens + phase_3_balances[msg.sender];
276       return total_expected_tokens <= 2000 * (10 ** uint256(18)) &&
277         _tokens <= phase_3_remaining_tokens;
278     }
279     else if(current_time > phase_3_Time && current_time < phase_4_Time){
280       total_expected_tokens = _tokens + phase_4_balances[msg.sender];
281       return total_expected_tokens <= 3500 * (10 ** uint256(18)) &&
282         _tokens <= phase_4_remaining_tokens;
283     }
284     else{
285       total_expected_tokens = _tokens + phase_5_balances[msg.sender];
286       return total_expected_tokens <= 3500 * (10 ** uint256(18)) &&
287         _tokens <= phase_5_remaining_tokens;
288     }
289   }
290   // decrease phase supply and add user phase balance
291   function updatePhaseSupplyAndBalance(uint256 _tokens) internal {
292     uint256 current_time = now;
293     if(current_time > start_time && current_time < phase_1_Time){
294       phase_1_balances[msg.sender] = phase_1_balances[msg.sender].add(_tokens);
295       phase_1_remaining_tokens = phase_1_remaining_tokens - _tokens;
296     }
297     else if(current_time > phase_1_Time && current_time < phase_2_Time){
298       phase_2_balances[msg.sender] = phase_2_balances[msg.sender].add(_tokens);
299       phase_2_remaining_tokens = phase_2_remaining_tokens - _tokens;
300     }
301     else if(current_time > phase_2_Time && current_time < phase_3_Time){
302       phase_3_balances[msg.sender] = phase_3_balances[msg.sender].add(_tokens);
303       phase_3_remaining_tokens = phase_3_remaining_tokens - _tokens;
304     }
305     else if(current_time > phase_3_Time && current_time < phase_4_Time){
306       phase_4_balances[msg.sender] = phase_4_balances[msg.sender].add(_tokens);
307       phase_4_remaining_tokens = phase_4_remaining_tokens - _tokens;
308     }
309     else{
310       phase_5_balances[msg.sender] = phase_5_balances[msg.sender].add(_tokens);
311       phase_5_remaining_tokens = phase_5_remaining_tokens - _tokens;
312     }
313   }
314   // send ether to the fund collection wallet
315   // override to create custom fund forwarding mechanisms
316   function forwardFunds() internal {
317     wallet.transfer(msg.value);
318   }
319   // @return true if the transaction can buy tokens
320   function validPurchase() internal constant returns (bool) {
321     bool withinPeriod = now >= start_time && now <= end_Time;
322     bool nonZeroPurchase = msg.value != 0;
323     return withinPeriod && nonZeroPurchase;
324   }
325   // @return true if crowdsale event has ended
326   function hasEnded() public constant returns (bool) {
327     return now > end_Time;
328   }
329   // function to transfer token back to owner
330   function transferBack(uint256 tokens) onlyOwner public returns (bool){
331     token.transfer(owner, tokens);
332     return true;
333   }
334   // function to change rate
335   function changeRate(uint256 _rate) onlyOwner public returns (bool){
336     RateChanged(msg.sender, rate, _rate);
337     rate = _rate;
338     return true;
339   }
340   function tokenBalance() constant public returns (uint256){
341     return token.balanceOf(this);
342   }
343 }