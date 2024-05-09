1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 }
66 
67 contract Crowdsale {
68   using SafeMath for uint256;
69   ERC20 public token;
70   address public wallet;
71   uint256 public rate;
72   uint256 public weiRaised;
73   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
74 
75   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
76     require(_rate > 0);
77     require(_wallet != address(0));
78     require(_token != address(0));
79     rate = _rate;
80     wallet = _wallet;
81     token = _token;
82   }
83 
84   function () external payable {
85     buyTokens(msg.sender);
86   }
87 
88   function buyTokens(address _beneficiary) public payable {
89     uint256 weiAmount = msg.value;
90     _preValidatePurchase(_beneficiary, weiAmount);
91     uint256 tokens = _getTokenAmount(weiAmount);
92     weiRaised = weiRaised.add(weiAmount);
93     _processPurchase(_beneficiary, tokens);
94     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
95     _updatePurchasingState(_beneficiary, weiAmount);
96     _forwardFunds();
97     _postValidatePurchase(_beneficiary, weiAmount);
98   }
99 
100   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
101     require(_beneficiary != address(0));
102     require(_weiAmount != 0);
103   }
104 
105   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
106   }
107 
108   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
109     token.transfer(_beneficiary, _tokenAmount);
110   }
111 
112   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
113     _deliverTokens(_beneficiary, _tokenAmount);
114   }
115 
116   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
117   }
118 
119   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
120     return _weiAmount.mul(rate);
121   }
122 
123   function _forwardFunds() internal {
124     wallet.transfer(msg.value);
125   }
126 }
127 
128 contract TimedCrowdsale is Crowdsale {
129   using SafeMath for uint256;
130   uint256 public openingTime;
131   uint256 public closingTime;
132 
133   modifier onlyWhileOpen {
134     require(now >= openingTime && now <= closingTime);
135     _;
136   }
137 
138   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
139     require(_openingTime >= now);
140     require(_closingTime >= _openingTime);
141     openingTime = _openingTime;
142     closingTime = _closingTime;
143   }
144 
145   function hasClosed() public view returns (bool) {
146     return now > closingTime;
147   }
148   
149   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
150     super._preValidatePurchase(_beneficiary, _weiAmount);
151   }
152 }
153 
154 contract CappedCrowdsale is Crowdsale {
155   using SafeMath for uint256;
156   uint256 public cap;
157 
158   function CappedCrowdsale(uint256 _cap) public {
159     require(_cap > 0);
160     cap = _cap;
161   }
162 
163   function capReached() public view returns (bool) {
164     return weiRaised >= cap;
165   }
166 
167   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
168     super._preValidatePurchase(_beneficiary, _weiAmount);
169     require(weiRaised.add(_weiAmount) <= cap);
170   }
171 }
172 
173 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
174   using SafeMath for uint256;
175   bool public isFinalized = false;
176   event Finalized();
177 
178   function finalize() onlyOwner public {
179     require(!isFinalized);
180     require(hasClosed());
181     finalization();
182     Finalized();
183     isFinalized = true;
184   }
185 
186   function finalization() internal {
187   }
188 }
189 
190 contract RefundVault is Ownable {
191   using SafeMath for uint256;
192   enum State { Active, Refunding, Closed }
193   mapping (address => uint256) public deposited;
194   address public wallet;
195   State public state;
196 
197   event Closed();
198   event RefundsEnabled();
199   event Refunded(address indexed beneficiary, uint256 weiAmount);
200 
201   function RefundVault(address _wallet) public {
202     require(_wallet != address(0));
203     wallet = _wallet;
204     state = State.Active;
205   }
206 
207   function deposit(address investor) onlyOwner public payable {
208     require(state == State.Active);
209     deposited[investor] = deposited[investor].add(msg.value);
210   }
211 
212   function close() onlyOwner public {
213     require(state == State.Active);
214     state = State.Closed;
215     Closed();
216     wallet.transfer(this.balance);
217   }
218 
219   function enableRefunds() onlyOwner public {
220     require(state == State.Active);
221     state = State.Refunding;
222     RefundsEnabled();
223   }
224 
225   function refund(address investor) public {
226     require(state == State.Refunding);
227     uint256 depositedValue = deposited[investor];
228     deposited[investor] = 0;
229     investor.transfer(depositedValue);
230     Refunded(investor, depositedValue);
231   }
232 }
233 
234 contract RefundableCrowdsale is FinalizableCrowdsale {
235   using SafeMath for uint256;
236   uint256 public goal;
237   RefundVault public vault;
238 
239   function RefundableCrowdsale(uint256 _goal) public {
240     require(_goal > 0);
241     vault = new RefundVault(wallet);
242     goal = _goal;
243   }
244 
245   function claimRefund() public {
246     require(isFinalized);
247     require(!goalReached());
248     vault.refund(msg.sender);
249   }
250 
251   function goalReached() public view returns (bool) {
252     return weiRaised >= goal;
253   }
254 
255   function finalization() internal {
256     if (goalReached()) {
257       vault.close();
258     } else {
259       vault.enableRefunds();
260     }
261     super.finalization();
262   }
263 
264   function _forwardFunds() internal {
265     vault.deposit.value(msg.value)(msg.sender);
266   }
267 }
268 
269 contract EladCrowdsale is RefundableCrowdsale, CappedCrowdsale {
270   uint8 public constant decimals = 18;
271   
272   uint256 private constant _goal = 200 * 10 ** uint256(decimals);
273   uint256 private constant _openingTime = 1524470400;
274   uint256 private constant _closingTime = 1527494400;
275   uint256 private constant _cap = 3000 * 10 ** uint256(decimals);
276   uint256 private constant _rate = 5000;
277   address private constant _wallet = 0x58d313d393fb5e3f729047768ce7a81b115509f1;
278   ERC20 private _token = ERC20(0x81176f21249aAE53b4de4d507A847F33c26fa794);
279 
280   function EladCrowdsale() public
281     Crowdsale(_rate, _wallet, _token)
282     CappedCrowdsale(_cap)
283     TimedCrowdsale(_openingTime, _closingTime)
284     RefundableCrowdsale(_goal) {
285     require(_goal <= _cap);
286   }
287 
288   function isOpen() public view returns (bool) {
289     return now >= openingTime && now <= closingTime;
290   }
291 
292   function allocateRemainingTokens() onlyOwner public {
293     require(isFinalized);
294     uint256 remaining = token.balanceOf(this);
295     token.transfer(owner, remaining);
296   }
297 }