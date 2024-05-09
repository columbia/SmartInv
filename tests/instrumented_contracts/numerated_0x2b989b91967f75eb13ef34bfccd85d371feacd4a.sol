1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 Mockup object 
6 */
7 contract ElementhToken {
8     
9   bool public mintingFinished = false;
10     function mint(address _to, uint256 _amount) public returns (bool) {
11     if(_to != address(0)) mintingFinished = false;
12     if(_amount != 0) mintingFinished = false;
13     return true;
14     }
15 
16     function burn(address _to, uint256 _amount) public returns (bool) {
17     if(_to != address(0)) mintingFinished = false;
18     if(_amount != 0) mintingFinished = false;
19     return true;
20     }
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     mapping(address => bool)  internal owners;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82      * account.
83      */
84     function Ownable() public{
85         owners[msg.sender] = true;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(owners[msg.sender] == true);
93         _;
94     }
95 
96     function addOwner(address newAllowed) onlyOwner public {
97         owners[newAllowed] = true;
98     }
99 
100     function removeOwner(address toRemove) onlyOwner public {
101         owners[toRemove] = false;
102     }
103 
104     function isOwner() public view returns(bool){
105         return owners[msg.sender] == true;
106     }
107 
108 }
109 
110 
111 
112 /**
113  * @title Crowdsale
114  * @dev Crowdsale is a base contract for managing a token crowdsale.
115  * Crowdsales have a start and end timestamps, where investors can make
116  * token purchases and the crowdsale will assign them tokens based
117  * on a token per ETH rate. Funds collected are forwarded to a wallet
118  * as they arrive. The contract requires a MintableToken that will be
119  * minted as contributions arrive, note that the crowdsale contract
120  * must be owner of the token in order to be able to mint it.
121  */
122 contract PreFund is Ownable {
123   using SafeMath for uint256;
124 
125   mapping (address => uint256) public deposited;
126   mapping (address => uint256) public claimed;
127 
128   // The token being sold
129   ElementhToken public token;
130 
131   // start and end timestamps where investments are allowed (both inclusive)
132   uint256 public startTime;
133   uint256 public endTime;
134 
135   // address where funds are collected
136   address public wallet;
137 
138 
139   // how many token units a buyer gets per wei
140   uint256 public rate;
141 
142   bool public refundEnabled;
143 
144   event Refunded(address indexed beneficiary, uint256 weiAmount);
145   event AddDeposit(address indexed beneficiary, uint256 value);
146   event LogClaim(address indexed holder, uint256 amount);
147 
148   function setStartTime(uint256 _startTime) public onlyOwner{
149     startTime = _startTime;
150   }
151 
152   function setEndTime(uint256 _endTime) public onlyOwner{
153     endTime = _endTime;
154   }
155 
156   function setWallet(address _wallet) public onlyOwner{
157     wallet = _wallet;
158   }
159 
160   function setRate(uint256 _rate) public onlyOwner{
161     rate = _rate;
162   }
163 
164   function setRefundEnabled(bool _refundEnabled) public onlyOwner{
165     refundEnabled = _refundEnabled;
166   }
167 
168   function PreFund(uint256 _startTime, uint256 _endTime, address _wallet, ElementhToken _token) public {
169     require(_startTime >= now);
170     require(_endTime >= _startTime);
171     require(_wallet != address(0));
172     require(_token != address(0));
173 
174     token = _token;
175     startTime = _startTime;
176     endTime = _endTime;
177     wallet = _wallet;
178     refundEnabled = false;
179   }
180 
181   function () external payable {
182     deposit(msg.sender);
183   }
184 
185   function addFunds() public payable onlyOwner {}
186 
187   // low level token purchase function
188   function deposit(address beneficiary) public payable {
189     require(beneficiary != address(0));
190     require(validPurchase());
191 
192     deposited[beneficiary] = deposited[beneficiary].add(msg.value);
193 
194     uint256 weiAmount = msg.value;
195     AddDeposit(beneficiary, weiAmount);
196   }
197 
198   // @return true if the transaction can buy tokens
199   function validPurchase() internal view returns (bool) {
200     bool withinPeriod = now >= startTime && now <= endTime;
201     bool nonZeroPurchase = msg.value != 0;
202     return withinPeriod && nonZeroPurchase;
203   }
204 
205 
206   // send ether to the fund collection wallet
207   function forwardFunds() onlyOwner public {
208     require(now >= endTime);
209     wallet.transfer(this.balance);
210   }
211 
212   function claimToken() public {
213     require (msg.sender != address(0));
214     require (now >= endTime);
215     require (deposited[msg.sender] > 0);
216     require (claimed[msg.sender] == 0);
217 
218     uint tokens = deposited[msg.sender] * rate;
219     token.mint(msg.sender, tokens);
220     claimed[msg.sender] = tokens;
221 
222     LogClaim(msg.sender, tokens);
223   }
224   
225 
226   function refundWallet(address _wallet) onlyOwner public {
227     refundFunds(_wallet);
228   }
229 
230   function claimRefund() public {
231     refundFunds(msg.sender);
232   }
233 
234   function refundFunds(address _wallet) internal {
235     require(_wallet != address(0));
236     require(deposited[_wallet] > 0);
237 
238     if(claimed[msg.sender] > 0){
239       require(now > endTime);
240       require(refundEnabled);
241       token.burn(_wallet, claimed[_wallet]);
242       claimed[_wallet] = 0;
243     } else {
244       require(now < endTime);
245     }
246 
247     uint256 depositedValue = deposited[_wallet];
248     deposited[_wallet] = 0;
249     
250     _wallet.transfer(depositedValue);
251     
252     Refunded(_wallet, depositedValue);
253 
254   }
255 
256 }