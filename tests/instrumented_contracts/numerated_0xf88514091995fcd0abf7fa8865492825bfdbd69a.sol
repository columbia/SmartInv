1 pragma solidity ^0.4.11;
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
33   function balanceOf(address who) public constant returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 /**
39  * @title ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/20
41  */
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public constant returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 
81 /**
82  * @title Standard ERC20 token
83  *
84  * @dev Implementation of the basic standard token.
85  * @dev https://github.com/ethereum/EIPs/issues/20
86  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
87  */
88 contract StandardToken is ERC20, BasicToken {
89 
90   mapping (address => mapping (address => uint256)) allowed;
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100 
101     uint256 _allowance = allowed[_from][msg.sender];
102 
103     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
104     // require (_value <= _allowance);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = _allowance.sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    *
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138 
139   /**
140    * approve should be called when allowed[_spender] == 0. To increment
141    * allowed value is better to use this function to avoid 2 calls (and wait until
142    * the first transaction is mined)
143    * From MonolithDAO Token.sol
144    */
145   function increaseApproval (address _spender, uint _addedValue)
146   returns (bool success) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval (address _spender, uint _subtractedValue)
153   returns (bool success) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164 }
165 
166 
167 contract Ownable {
168   address public owner;
169 
170   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172   /**
173    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
174    * account.
175    */
176   function Ownable() {
177     owner = msg.sender;
178   }
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) onlyOwner public {
193     require(newOwner != address(0));
194     OwnershipTransferred(owner, newOwner);
195     owner = newOwner;
196   }
197 }
198 
199 /**
200  * Main crowdsale contract.
201  */
202 contract DOCKCrowdsale is Ownable {
203   using SafeMath for uint256;
204 
205   // The token being sold
206   StandardToken public token;
207 
208   // start and end timestamps where investments are allowed (both inclusive)
209   uint256 public endTime;
210 
211   // address where funds are collected
212   address public wallet;
213   address public tokenPoolAddress;
214 
215   // how many token units a buyer gets per wei
216   uint256 public rate;
217 
218   // amount of raised money in wei
219   uint256 public weiRaised;
220 
221   /**
222    * event for token purchase logging
223    * @param purchaser who paid for the tokens
224    * @param beneficiary who got the tokens
225    * @param value weis paid for purchase
226    * @param amount amount of tokens purchased
227    */
228   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
229 
230 
231   function DOCKCrowdsale(
232     uint256 _endTime,
233     uint256 _rate,
234     address _wallet,
235     address tokenAddress,
236     address _tokenHolder
237   ) Ownable() {
238     require(_endTime > 0);
239     require(_rate > 0);
240     require(_wallet != 0x0);
241     require(_tokenHolder != 0x0);
242 
243     token = StandardToken(tokenAddress);
244     endTime = _endTime;
245     rate = _rate;
246     wallet = _wallet;
247     tokenPoolAddress = _tokenHolder;
248   }
249 
250   // fallback function can be used to buy tokens
251   function () public payable {
252     buyTokens(msg.sender);
253   }
254 
255   function updateRate(uint256 _rate) onlyOwner external returns (bool) {
256     require(_rate > 0);
257     rate = _rate;
258     return true;
259   }
260 
261   function updateWallet(address _wallet) onlyOwner external returns (bool) {
262     require(_wallet != 0x0);
263     wallet = _wallet;
264 
265     return true;
266   }
267 
268   function updateTokenAddress(address _tokenAddress) onlyOwner external returns (bool) {
269     require(_tokenAddress != 0x0);
270     token = StandardToken(_tokenAddress);
271 
272     return true;
273   }
274 
275   function updateTokenPoolAddress(address _tokenHolder) onlyOwner external returns (bool) {
276     require(_tokenHolder != 0x0);
277     tokenPoolAddress = _tokenHolder;
278     return true;
279   }
280 
281   function updateEndTime(uint256 _endTime) onlyOwner external returns (bool){
282     endTime = _endTime;
283     return true;
284   }
285 
286   // low level token purchase function
287   function buyTokens(address beneficiary) public payable returns (bool){
288     require(beneficiary != 0x0);
289     require(validPurchase());
290 
291     uint256 weiAmount = msg.value;
292 
293     // calculate token amount to be created
294     uint256 tokens = weiAmount.mul(rate);
295 
296     // update state
297     weiRaised = weiRaised.add(weiAmount);
298 
299     token.transferFrom(tokenPoolAddress, beneficiary, tokens);
300     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
301 
302     forwardFunds();
303 
304     return true;
305   }
306 
307   // send ether to the fund collection wallet
308   // override to create custom fund forwarding mechanisms
309   function forwardFunds() internal {
310     wallet.transfer(msg.value);
311   }
312 
313   // @return true if the transaction can buy tokens
314   function validPurchase() internal constant returns (bool) {
315     bool nonZeroPurchase = msg.value != 0;
316     return !hasEnded() && nonZeroPurchase;
317   }
318 
319   // @return true if crowdsale event has ended
320   function hasEnded() public constant returns (bool) {
321     return now > endTime;
322   }
323 
324 
325 }