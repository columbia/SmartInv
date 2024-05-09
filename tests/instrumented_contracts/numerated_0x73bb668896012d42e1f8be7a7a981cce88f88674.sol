1 pragma solidity ^0.4.17;
2 
3 
4 contract ERC20Basic {
5     
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   
11 }
12 
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   /**
50   * @dev transfer token for a specified address
51   * @param _to The address to transfer to.
52   * @param _value The amount to be transferred.
53   */
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     // SafeMath.sub will throw if there is not enough balance.
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83 
84   /**
85    * @dev Transfer tokens from one address to another
86    * @param _from address The address which you want to send tokens from
87    * @param _to address The address which you want to transfer to
88    * @param _value uint256 the amount of tokens to be transferred
89    */
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113 
114   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
115     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
116     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131 }
132 
133 /**
134  * @title Ownable
135  * @dev The Ownable contract has an owner address, and provides basic authorization control
136  * functions, this simplifies the implementation of "user permissions".
137  */
138 contract Ownable {
139   address public owner;
140 
141 
142   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function Ownable() public {
150     owner = msg.sender;
151   }
152 
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162 }
163 
164 contract MOKEN is StandardToken {
165     string public name = "MOKEN";
166     string public symbol = "MOKN";
167     uint256 public decimals = 18;
168 
169     uint256 constant INITIAL_SUPPLY = 17000000 * 10**18;
170     function MOKEN () public {
171        balances[msg.sender] = INITIAL_SUPPLY;
172     }
173 }
174 
175 contract Crowdsale is Ownable {
176   using SafeMath for uint256;
177 
178    // The token being sold
179   MOKEN public token;
180 
181   // start and end timestamps where investments are allowed (both inclusive)
182   uint256 public startTime;
183   uint256 public endTime;
184 
185   // address where funds are collected
186   address public wallet;
187 
188   // how many token units a buyer gets per wei
189   uint256 public rate;
190 
191   // amount of raised money in wei
192   uint256 public weiRaised;
193 
194   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
195 
196 
197   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
198     require(_startTime >= now);
199     require(_endTime >= _startTime);
200     require(_rate > 0);
201     require(_wallet != address(0));
202 
203     startTime = _startTime;
204     endTime = _endTime;
205     rate = _rate;
206     wallet = _wallet;
207     token = createTokenContract();
208   }
209 
210 // creates the token to be sold.
211 // override this method to have crowdsale of a specific mintable token.
212 function createTokenContract() internal returns (MOKEN) {
213     return new MOKEN();
214   }
215 
216 
217   // fallback function can be used to buy tokens
218   function () external payable {
219     buyTokens(msg.sender);
220   }
221 
222   // low level token purchase function
223 function buyTokens(address beneficiary) public payable {
224     require(beneficiary != address(0));
225     require(validPurchase());
226 
227     uint256 weiAmount = msg.value;
228 
229     // calculate token amount to be created
230     uint256 tokens = weiAmount.mul(rate);
231 
232     // update state
233     weiRaised = weiRaised.add(weiAmount);
234 
235     // transfer tokens purchased 
236     ERC20(token).transfer(beneficiary, tokens);
237 
238     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
239 
240     forwardFunds();
241 }
242 
243 function transferTokens(address beneficiary,uint tokens) onlyOwner public {
244     require(beneficiary != address(0));
245 
246     // transfer tokens purchased 
247     ERC20(token).transfer(beneficiary, tokens);
248 
249 }
250 
251 
252   function forwardFunds() internal {
253     wallet.transfer(msg.value);
254   }
255 
256 
257   function validPurchase() internal view returns (bool) {
258     bool withinPeriod = block.timestamp >= startTime && block.timestamp <= endTime;
259     bool nonZeroPurchase = msg.value != 0;
260     return withinPeriod && nonZeroPurchase;
261   }
262 
263 
264   function hasEnded() public view returns (bool) {
265     return now > endTime;
266   }
267   
268   function setRate(uint256 _rate) public onlyOwner{
269       rate = _rate;
270   }
271   
272   function setWallet(address _wallet) public onlyOwner{
273       wallet = _wallet;
274   }
275   
276   function setStartTime(uint256 _startTime) public onlyOwner{
277       startTime = _startTime;
278   }
279   
280   function setEndTime(uint256 _endTime) public onlyOwner{
281       endTime = _endTime;
282   }
283   
284   
285 }
286 
287 contract CappedCrowdsale is Crowdsale {
288 
289   using SafeMath for uint256;
290 
291   uint256 public cap;
292 
293   function CappedCrowdsale(uint256 _cap,uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) 
294     Crowdsale (_startTime, _endTime, _rate, _wallet) public {
295     require(_cap > 0);
296     cap = _cap;
297   }
298 
299  
300   function validPurchase() internal view returns (bool) {
301     uint256 count = weiRaised.add(msg.value);
302     bool withinCap =  count <= cap;
303     return super.validPurchase() && withinCap;
304   }
305 
306 
307   function hasEnded() public view returns (bool) {
308     bool capReached = weiRaised >= cap;
309     return super.hasEnded() || capReached;
310   }
311 
312 }