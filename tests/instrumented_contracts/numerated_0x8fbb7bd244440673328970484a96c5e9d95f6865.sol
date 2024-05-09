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
142   event Refunded(address indexed beneficiary, uint256 weiAmount);
143   event AddDeposit(address indexed beneficiary, uint256 value);
144   event LogClaim(address indexed holder, uint256 amount);
145 
146   function setStartTime(uint256 _startTime) public onlyOwner{
147     startTime = _startTime;
148   }
149 
150   function setEndTime(uint256 _endTime) public onlyOwner{
151     endTime = _endTime;
152   }
153 
154   function setWallet(address _wallet) public onlyOwner{
155     wallet = _wallet;
156   }
157 
158   function setRate(uint256 _rate) public onlyOwner{
159     rate = _rate;
160   }
161 
162 
163   function PreFund(uint256 _startTime, uint256 _endTime, address _wallet, ElementhToken _token) public {
164     require(_startTime >= now);
165     require(_endTime >= _startTime);
166     require(_wallet != address(0));
167     require(_token != address(0));
168 
169     token = _token;
170     startTime = _startTime;
171     endTime = _endTime;
172     wallet = _wallet;
173   }
174 
175   function () external payable {
176     deposit(msg.sender);
177   }
178 
179   // low level token purchase function
180   function deposit(address beneficiary) public payable {
181     require(beneficiary != address(0));
182     require(validPurchase());
183 
184     deposited[beneficiary] = deposited[beneficiary].add(msg.value);
185 
186     uint256 weiAmount = msg.value;
187     AddDeposit(beneficiary, weiAmount);
188   }
189 
190   // @return true if the transaction can buy tokens
191   function validPurchase() internal view returns (bool) {
192     bool withinPeriod = now >= startTime && now <= endTime;
193     bool nonZeroPurchase = msg.value != 0;
194     return withinPeriod && nonZeroPurchase;
195   }
196 
197 
198   // send ether to the fund collection wallet
199   function forwardFunds() onlyOwner public {
200     require(now >= endTime);
201     wallet.transfer(this.balance);
202   }
203 
204   function claimToken () public {
205     require (msg.sender != address(0));
206     require (now >= endTime);
207     require (deposited[msg.sender] != 0);
208     
209     uint tokens = deposited[msg.sender] * rate;
210 
211     token.mint(msg.sender, tokens);
212     deposited[msg.sender] = 0;
213     claimed[msg.sender] = tokens;
214 
215     LogClaim(msg.sender, tokens);
216   }
217   
218 
219   function refundWallet(address _wallet) onlyOwner public {
220     refundFunds(_wallet);
221   }
222 
223   function claimRefund() public {
224   	require(now <= endTime);
225     refundFunds(msg.sender);
226   }
227 
228   function refundFunds(address _wallet) internal {
229     require(_wallet != address(0));
230     require(deposited[_wallet] != 0);
231     uint256 depositedValue = deposited[_wallet];
232     deposited[_wallet] = 0;
233     _wallet.transfer(depositedValue);
234     if(claimed[_wallet] != 0){
235     	token.burn(_wallet, claimed[_wallet]);
236     	claimed[_wallet] = 0;
237     }
238     Refunded(_wallet, depositedValue);
239   }
240 
241 }