1 pragma solidity 0.4.25;
2 
3 
4 contract EthRV {
5   using SafeMath for uint;
6 
7   struct Investor {
8     uint deposit;
9     uint paymentTime;
10     uint withdrawal;
11     uint boostStartup;
12     bool isParticipant;
13   }
14 
15   mapping (address => Investor) public investors;
16   address public admin1Address;
17   address public admin2Address;
18   address public admin3Address;
19   address public owner;
20   uint public investmentsNumber;
21   uint public investorsNumber;
22 
23   modifier onlyOwner() {
24     require(msg.sender == owner, "access denied");
25     _;
26   }
27 
28   event OnRefLink(address indexed referral, uint referrarBonus, address indexed referrer,  uint referrerBonus, uint time);
29   event OnNewInvestor(address indexed addr, uint time);
30   event OnInvesment(address indexed addr, uint deposit, uint time);
31   event OnBoostChanged(address indexed addr, bool isActive, uint time);
32   event OnEarlyWithdrawal(address indexed addr, uint withdrawal, uint time);
33   event OnDeleteInvestor(address indexed addr, uint time);
34   event OnWithdraw(address indexed addr, uint withdrawal, uint time);
35   event OnBoostBonus(address indexed addr, uint bonus, uint time);
36   event OnNotEnoughBalance(uint time);
37 
38   constructor() public {
39     owner = msg.sender;
40     admin1Address = msg.sender;
41     admin2Address = msg.sender;
42     admin3Address = msg.sender;
43   }
44 
45   function() external payable {
46     if (msg.value == 0) {
47       withdraw();
48     } else if (msg.value == 0.0077777 ether) {
49       boost();
50     } else if (msg.value == 0.0088888 ether) {
51       earlyWithdrawal();
52     } else {
53       deposit(bytes2address(msg.data));
54     }
55   }
56 
57   function disown() public onlyOwner {
58     owner = address(0x0);
59   }
60 
61   function setAdminsAddress(uint n, address addr) public onlyOwner {
62     require(n >= 1 && n <= 3, "invalid number of admin`s address");
63     if (n == 1) {
64       admin1Address = addr;
65     } else if (n == 2) {
66       admin2Address = addr;
67     } else {
68       admin3Address = addr;
69     }
70   }
71 
72   function investorDividends(address investorAddr) public view returns(uint dividends, uint boostBonus) {
73     return getDividends(investorAddr);
74   }
75 
76   function withdraw() public {
77     address investorAddr = msg.sender;
78     (uint dividends, uint boostBonus) = getDividends(investorAddr);
79     require(dividends > 0, "cannot to pay zero dividends");
80     require(address(this).balance > 0, "fund is empty");
81     uint withdrawal = dividends + boostBonus;
82 
83     // fund limit
84     if (address(this).balance <= withdrawal) {
85       emit OnNotEnoughBalance(now);
86       withdrawal = address(this).balance;
87     }
88 
89     Investor storage investor = investors[investorAddr];
90     uint withdrawalLimit = investor.deposit * 200 / 100; // 200%
91     uint totalWithdrawal = withdrawal + investor.withdrawal;
92 
93     // withdrawal limit - 200%
94     if (totalWithdrawal >= withdrawalLimit) {
95       withdrawal = withdrawalLimit.sub(investor.withdrawal);
96       if (boostBonus > 0 ) {
97         emit OnBoostBonus(investorAddr, boostBonus, now);
98       }
99       deleteInvestor(investorAddr);
100     } else {
101       // normal withdraw - dont use boostBonus
102       if (withdrawal > dividends) {
103         withdrawal = dividends;
104       }
105       investor.withdrawal += withdrawal;
106       investor.paymentTime = now;
107       if (investor.boostStartup > 0) {
108         investor.boostStartup = 0;
109         emit OnBoostChanged(investorAddr, false, now);
110       }
111     }
112 
113     investorAddr.transfer(withdrawal);
114     emit OnWithdraw(investorAddr, withdrawal, now);
115   }
116 
117   function earlyWithdrawal() public {
118     address investorAddr = msg.sender;
119     Investor storage investor = investors[investorAddr];
120     require(investor.deposit > 0, "sender must be an investor");
121 
122     uint earlyWithdrawalLimit = investor.deposit * 70 / 100; // 70%
123     require(earlyWithdrawalLimit > investor.withdrawal, "early withdraw only before 70% deposit`s withdrawal");
124 
125     uint withdrawal = earlyWithdrawalLimit.sub(investor.withdrawal); 
126     investorAddr.transfer(withdrawal);
127     emit OnEarlyWithdrawal(investorAddr, withdrawal, now);
128 
129     deleteInvestor(investorAddr);
130   }
131 
132   function boost() public {
133     Investor storage investor = investors[msg.sender];
134     require(investor.deposit > 0, "sender must be an investor");
135     require(investor.boostStartup == 0, "boost is already activated");
136     investor.boostStartup = now;
137     emit OnBoostChanged(msg.sender, true, now);
138   }
139 
140   function deposit(address referrerAddr) public payable {
141     uint depositAmount = msg.value;
142     address investorAddr = msg.sender;
143     require(isNotContract(investorAddr), "invest from contracts is not supported");
144     require(depositAmount > 0, "deposit amount cannot be zero");
145 
146     admin1Address.send(depositAmount * 70 / 1000); //   7%
147     admin2Address.send(depositAmount * 15 / 1000); // 1.5%
148     admin3Address.send(depositAmount * 15 / 1000); // 1.5%
149 
150     Investor storage investor = investors[investorAddr];
151     bool senderIsNotPaticipant = !investor.isParticipant;
152     bool referrerIsParticipant = investors[referrerAddr].isParticipant;
153 
154     // ref link
155     if (senderIsNotPaticipant && referrerIsParticipant && referrerAddr != investorAddr) {
156       uint referrerBonus = depositAmount * 3 / 100; // 3%
157       uint referralBonus = depositAmount * 1 / 100; // 1%
158       referrerAddr.transfer(referrerBonus);
159       investorAddr.transfer(referralBonus);
160       emit OnRefLink(investorAddr, referralBonus, referrerAddr, referrerBonus, now);
161     }
162 
163     if (investor.deposit == 0) {
164       investorsNumber++;
165       investor.isParticipant = true;
166       emit OnNewInvestor(investorAddr, now);
167     }
168 
169     investor.deposit += depositAmount;
170     investor.paymentTime = now;
171 
172     investmentsNumber++;
173     emit OnInvesment(investorAddr, depositAmount, now);
174   }
175 
176   function getDividends(address investorAddr) internal view returns(uint dividends, uint boostBonus) {
177     Investor storage investor = investors[investorAddr];
178     if (investor.deposit == 0) {
179       return (0, 0);
180     }
181 
182     if (investor.boostStartup > 0) {
183       uint boostDays = now.sub(investor.boostStartup).div(24 hours);
184       boostBonus = boostDays * investor.deposit * 5 / 100000; // 0.005%
185     }
186 
187     uint depositDays = now.sub(investor.paymentTime).div(24 hours);
188     dividends = depositDays * investor.deposit * 1 / 100; // 1%
189 
190     uint depositAmountBonus;
191     if (10 ether <= investor.deposit && investor.deposit <= 50 ether) {
192       depositAmountBonus = depositDays * investor.deposit * 5 / 10000; // 0.05%
193     } else if (50 ether < investor.deposit) {
194       depositAmountBonus = depositDays * investor.deposit * 11 / 10000; // 0.11%
195     }
196 
197     dividends += depositAmountBonus;
198   }
199 
200   function isNotContract(address addr) internal view returns (bool) {
201     uint length;
202     assembly { length := extcodesize(addr) }
203     return length == 0;
204   }
205 
206   function bytes2address(bytes memory source) internal pure returns(address addr) {
207     assembly { addr := mload(add(source, 0x14)) }
208     return addr;
209   }
210 
211   function deleteInvestor(address investorAddr) private {
212     delete investors[investorAddr].deposit;
213     delete investors[investorAddr].paymentTime;
214     delete investors[investorAddr].withdrawal;
215     delete investors[investorAddr].boostStartup;
216     emit OnDeleteInvestor(investorAddr, now);
217     investorsNumber--;
218   }
219 }
220 
221 /**
222  * @title SafeMath
223  * @dev Math operations with safety checks that revert on error
224  */
225 library SafeMath {
226 
227   /**
228   * @dev Multiplies two numbers, reverts on overflow.
229   */
230   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
231     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
232     // benefit is lost if 'b' is also tested.
233     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
234     if (_a == 0) {
235       return 0;
236     }
237 
238     uint256 c = _a * _b;
239     require(c / _a == _b);
240 
241     return c;
242   }
243 
244   /**
245   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
246   */
247   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
248     require(_b > 0); // Solidity only automatically asserts when dividing by 0
249     uint256 c = _a / _b;
250     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
251 
252     return c;
253   }
254 
255   /**
256   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
257   */
258   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
259     require(_b <= _a);
260     uint256 c = _a - _b;
261 
262     return c;
263   }
264 
265   /**
266   * @dev Adds two numbers, reverts on overflow.
267   */
268   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
269     uint256 c = _a + _b;
270     require(c >= _a);
271 
272     return c;
273   }
274 
275   /**
276   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
277   * reverts when dividing by zero.
278   */
279   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280     require(b != 0);
281     return a % b;
282   }
283 }