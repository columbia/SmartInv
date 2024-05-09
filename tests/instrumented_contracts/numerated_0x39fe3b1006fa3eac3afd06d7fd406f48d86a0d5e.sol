1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public constant returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   /**
27   * @dev transfer token for a specified address
28   * @param _to The address to transfer to.
29   * @param _value The amount to be transferred.
30   */
31   function transfer(address _to, uint256 _value) public returns (bool) {
32     require(_to != address(0));
33 
34     // SafeMath.sub will throw if there is not enough balance.
35     balances[msg.sender] = balances[msg.sender].sub(_value);
36     balances[_to] = balances[_to].add(_value);
37     Transfer(msg.sender, _to, _value);
38     return true;
39   }
40 
41   /**
42   * @dev Gets the balance of the specified address.
43   * @param _owner The address to query the the balance of.
44   * @return An uint256 representing the amount owned by the passed address.
45   */
46   function balanceOf(address _owner) public constant returns (uint256 balance) {
47     return balances[_owner];
48   }
49 
50 }
51 
52 /**
53  * @title Standard ERC20 token
54  *
55  * @dev Implementation of the basic standard token.
56  * @dev https://github.com/ethereum/EIPs/issues/20
57  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
58  */
59 contract StandardToken is ERC20, BasicToken {
60 
61   mapping (address => mapping (address => uint256)) allowed;
62 
63 
64   /**
65    * @dev Transfer tokens from one address to another
66    * @param _from address The address which you want to send tokens from
67    * @param _to address The address which you want to transfer to
68    * @param _value uint256 the amount of tokens to be transferred
69    */
70   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     uint256 _allowance = allowed[_from][msg.sender];
74 
75     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
76     // require (_value <= _allowance);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = _allowance.sub(_value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   /**
86    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
87    *
88    * Beware that changing an allowance with this method brings the risk that someone may use both the old
89    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
90    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
91    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92    * @param _spender The address which will spend the funds.
93    * @param _value The amount of tokens to be spent.
94    */
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Function to check the amount of tokens that an owner allowed to a spender.
103    * @param _owner address The address which owns the funds.
104    * @param _spender address The address which will spend the funds.
105    * @return A uint256 specifying the amount of tokens still available for the spender.
106    */
107   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
108     return allowed[_owner][_spender];
109   }
110 
111   /**
112    * approve should be called when allowed[_spender] == 0. To increment
113    * allowed value is better to use this function to avoid 2 calls (and wait until
114    * the first transaction is mined)
115    * From MonolithDAO Token.sol
116    */
117   function increaseApproval (address _spender, uint _addedValue)
118   returns (bool success) {
119     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124   function decreaseApproval (address _spender, uint _subtractedValue)
125   returns (bool success) {
126     uint oldValue = allowed[msg.sender][_spender];
127     if (_subtractedValue > oldValue) {
128       allowed[msg.sender][_spender] = 0;
129     } else {
130       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131     }
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136 }
137 
138 
139 library SafeMath {
140   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
141     uint256 c = a * b;
142     assert(a == 0 || c / a == b);
143     return c;
144   }
145 
146   function div(uint256 a, uint256 b) internal constant returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return c;
151   }
152 
153   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   function add(uint256 a, uint256 b) internal constant returns (uint256) {
159     uint256 c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 contract Ownable {
166   address public owner;
167 
168 
169   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171 
172   /**
173    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
174    * account.
175    */
176   function Ownable() {
177     owner = msg.sender;
178   }
179 
180 
181   /**
182    * @dev Throws if called by any account other than the owner.
183    */
184   modifier onlyOwner() {
185     require(msg.sender == owner);
186     _;
187   }
188 
189 
190   /**
191    * @dev Allows the current owner to transfer control of the contract to a newOwner.
192    * @param newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address newOwner) onlyOwner public {
195     require(newOwner != address(0));
196     OwnershipTransferred(owner, newOwner);
197     owner = newOwner;
198   }
199 
200 }
201 
202 
203 contract FRNCoinCrowdsale is Ownable {
204   using SafeMath for uint256;
205 
206   // The token being sold
207   StandardToken public token;
208 
209   // start and end timestamps where investments are allowed (both inclusive)
210   uint256 public endTime;
211 
212   // address where funds are collected
213   address public wallet;
214   address public tokenPoolAddress;
215 
216   // how many token units a buyer gets per wei
217   uint256 public rate;
218 
219   // amount of raised money in wei
220   uint256 public weiRaised;
221 
222   /**
223    * event for token purchase logging
224    * @param purchaser who paid for the tokens
225    * @param beneficiary who got the tokens
226    * @param value weis paid for purchase
227    * @param amount amount of tokens purchased
228    */
229   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
230 
231 
232   function FRNCoinCrowdsale(
233     uint256 _endTime,
234     uint256 _rate,
235     address _wallet,
236     address tokenAddress,
237     address _tokenHolder
238   ) Ownable() {
239     require(_endTime > 0);
240     require(_rate > 0);
241     require(_wallet != 0x0);
242     require(_tokenHolder != 0x0);
243 
244     token = StandardToken(tokenAddress);
245     endTime = _endTime;
246     rate = _rate;
247     wallet = _wallet;
248     tokenPoolAddress = _tokenHolder;
249   }
250 
251   // fallback function can be used to buy tokens
252   function () public payable {
253     buyTokens(msg.sender);
254   }
255 
256   function updateRate(uint256 _rate) onlyOwner external returns (bool) {
257     require(_rate > 0);
258     rate = _rate;
259     return true;
260   }
261 
262   function updateWallet(address _wallet) onlyOwner external returns (bool) {
263     require(_wallet != 0x0);
264     wallet = _wallet;
265 
266     return true;
267   }
268 
269   function updateTokenAddress(address _tokenAddress) onlyOwner external returns (bool) {
270     require(_tokenAddress != 0x0);
271     token = StandardToken(_tokenAddress);
272 
273     return true;
274   }
275 
276   function updateTokenPoolAddress(address _tokenHolder) onlyOwner external returns (bool) {
277     require(_tokenHolder != 0x0);
278     tokenPoolAddress = _tokenHolder;
279     return true;
280   }
281 
282   function updateEndTime(uint256 _endTime) onlyOwner external returns (bool){
283     endTime = _endTime;
284     return true;
285   }
286 
287   // low level token purchase function
288   function buyTokens(address beneficiary) public payable returns (bool){
289     require(beneficiary != 0x0);
290     require(validPurchase());
291 
292     uint256 weiAmount = msg.value;
293 
294     // calculate token amount to be created
295     uint256 tokens = weiAmount.mul(rate);
296     // calculate bonus based on investment amount
297     if (weiAmount >= 20 ether)
298         tokens += (tokens.div(100)).mul(50);
299     else if (weiAmount >= 10 ether)
300         tokens += (tokens.div(100)).mul(30);
301     else if (weiAmount >= 5 ether)
302         tokens += (tokens.div(100)).mul(15);
303     else
304         tokens += (tokens.div(100)).mul(5);
305     // update state
306     weiRaised = weiRaised.add(weiAmount);
307 
308     token.transferFrom(tokenPoolAddress, beneficiary, tokens);
309     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
310 
311     forwardFunds();
312 
313     return true;
314   }
315 
316   // send ether to the fund collection wallet
317   // override to create custom fund forwarding mechanisms
318   function forwardFunds() internal {
319     wallet.transfer(msg.value);
320   }
321 
322   // @return true if the transaction can buy tokens
323   function validPurchase() internal constant returns (bool) {
324     bool nonZeroPurchase = msg.value != 0;
325     return !hasEnded() && nonZeroPurchase;
326   }
327 
328   // @return true if crowdsale event has ended
329   function hasEnded() public constant returns (bool) {
330     return now > endTime;
331   }
332 
333   // @return true if crowdsale event has not ended
334   function isRunning() public constant returns (bool) {
335     return now < endTime;
336   }
337 
338 }