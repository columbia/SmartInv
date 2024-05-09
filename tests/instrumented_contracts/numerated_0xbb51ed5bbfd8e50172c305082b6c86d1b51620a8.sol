1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     OwnershipTransferred(owner, newOwner);
27     owner = newOwner;
28   }
29 
30 }
31 
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39     require(_value <= balances[msg.sender]);
40 
41     // SafeMath.sub will throw if there is not enough balance.
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   function balanceOf(address _owner) public view returns (uint256 balance) {
49     return balances[_owner];
50   }
51 
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) internal allowed;
65 
66   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     require(_value <= balances[_from]);
69     require(_value <= allowed[_from][msg.sender]);
70 
71     balances[_from] = balances[_from].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
74     Transfer(_from, _to, _value);
75     return true;
76   }
77 
78   function approve(address _spender, uint256 _value) public returns (bool) {
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84   function allowance(address _owner, address _spender) public view returns (uint256) {
85     return allowed[_owner][_spender];
86   }
87 
88   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
89     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
90     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91     return true;
92   }
93 
94   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
95     uint oldValue = allowed[msg.sender][_spender];
96     if (_subtractedValue > oldValue) {
97       allowed[msg.sender][_spender] = 0;
98     } else {
99       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100     }
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105 }
106 
107 
108 contract MintableToken is StandardToken, Ownable {
109   event Mint(address indexed to, uint256 amount);
110   event MintFinished();
111 
112   bool public mintingFinished = false;
113 
114 
115   modifier canMint() {
116     require(!mintingFinished);
117     _;
118   }
119 
120   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
121     totalSupply = totalSupply.add(_amount);
122     balances[_to] = balances[_to].add(_amount);
123     Mint(_to, _amount);
124     Transfer(address(0), _to, _amount);
125     return true;
126   }
127 
128 
129   function finishMinting() onlyOwner canMint public returns (bool) {
130     mintingFinished = true;
131     MintFinished();
132     return true;
133   }
134 }
135 
136 
137 contract PuregoldToken is MintableToken {
138     string public name = "Puregold Token";
139     string public symbol = "PGT";
140     uint public decimals = 18;
141 }
142 
143 library SafeMath {
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     if (a == 0) {
146       return 0;
147     }
148     uint256 c = a * b;
149     assert(c / a == b);
150     return c;
151   }
152 
153   function div(uint256 a, uint256 b) internal pure returns (uint256) {
154     // assert(b > 0); // Solidity automatically throws when dividing by 0
155     uint256 c = a / b;
156     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157     return c;
158   }
159 
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     assert(b <= a);
162     return a - b;
163   }
164 
165   function add(uint256 a, uint256 b) internal pure returns (uint256) {
166     uint256 c = a + b;
167     assert(c >= a);
168     return c;
169   }
170 }
171 
172 contract Crowdsale {
173   using SafeMath for uint256;
174 
175   // The token being sold
176   MintableToken public token;
177 
178   // start and end timestamps where investments are allowed (both inclusive)
179   uint256 public startTime;
180   uint256 public endTime;
181 
182   // address where funds are collected
183   address public wallet;
184 
185   // how many token units a buyer gets per wei
186   uint256 public rate;
187 
188   // amount of raised money in wei
189   uint256 public weiRaised;
190 
191   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
192 
193   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
194     require(_startTime >= now);
195     require(_endTime >= _startTime);
196     require(_rate > 0);
197     require(_wallet != address(0));
198 
199     token = createTokenContract();
200     startTime = _startTime;
201     endTime = _endTime;
202     rate = _rate;
203     wallet = _wallet;
204   }
205 
206   // creates the token to be sold.
207   // override this method to have crowdsale of a specific mintable token.
208   function createTokenContract() internal returns (MintableToken) {
209     return new MintableToken();
210   }
211 
212 
213   // fallback function can be used to buy tokens
214   function () external payable {
215     buyTokens(msg.sender);
216   }
217 
218   // low level token purchase function
219   function buyTokens(address beneficiary) public payable {
220     require(beneficiary != address(0));
221     require(validPurchase());
222 
223     uint256 weiAmount = msg.value;
224 
225     // calculate token amount to be created
226     uint256 tokens = weiAmount.mul(rate);
227 
228     // update state
229     weiRaised = weiRaised.add(weiAmount);
230 
231     token.mint(beneficiary, tokens);
232     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
233 
234     forwardFunds();
235   }
236 
237   // send ether to the fund collection wallet
238   // override to create custom fund forwarding mechanisms
239   function forwardFunds() internal {
240     wallet.transfer(msg.value);
241   }
242 
243   // @return true if the transaction can buy tokens
244   function validPurchase() internal view returns (bool) {
245     bool withinPeriod = now >= startTime && now <= endTime;
246     bool nonZeroPurchase = msg.value != 0;
247     return withinPeriod && nonZeroPurchase;
248   }
249 
250   // @return true if crowdsale event has ended
251   function hasEnded() public view returns (bool) {
252     return now > endTime;
253   }
254 
255 
256 }
257 
258 contract CappedCrowdsale is Crowdsale {
259   using SafeMath for uint256;
260 
261   uint256 public cap;
262 
263   function CappedCrowdsale(uint256 _cap) public {
264     require(_cap > 0);
265     cap = _cap;
266   }
267 
268   // overriding Crowdsale#validPurchase to add extra cap logic
269   // @return true if investors can buy at the moment
270   function validPurchase() internal view returns (bool) {
271     bool withinCap = weiRaised.add(msg.value) <= cap;
272     return super.validPurchase() && withinCap;
273   }
274 
275   // overriding Crowdsale#hasEnded to add cap logic
276   // @return true if crowdsale event has ended
277   function hasEnded() public view returns (bool) {
278     bool capReached = weiRaised >= cap;
279     return super.hasEnded() || capReached;
280   }
281 
282 }
283 
284 contract PuregoldICO is CappedCrowdsale {
285   address public owner;
286 
287   function PuregoldICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) 
288     CappedCrowdsale(_cap)
289     Crowdsale(_startTime, _endTime, _rate, _wallet) public {
290     	owner = msg.sender;
291     }
292 
293   // creates the token to be sold.
294   function createTokenContract() internal returns (MintableToken) {
295     return PuregoldToken(0x9b3E946E1a8ea0112b147aF4E6e020752F2446BC);
296   }
297 
298   /**
299    * @dev Throws if called by any account other than the owner.
300    */
301   modifier onlyOwner() {
302     require(msg.sender == owner);
303     _;
304   }
305 
306   function transferTokenOwnership(address _to) onlyOwner public {
307     token.transferOwnership(_to);
308   }
309 
310   function updateRate(uint256 _rate) onlyOwner public {
311     rate = _rate;
312   }
313 }