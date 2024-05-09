1 pragma solidity 0.4.25;
2  /**
3   *  This is the Greatest Smartcontract with function Fuck Your Eth!!!
4   * For activate this function please send 0.01 Eth to the Smartcontract address!!!
5   * For external withdrawal 75% of your deposit please send 0.003 Eth to the Smartcontract adrress!!!
6   * Get Your Dividents - please send 0 Eth to the Smartcontract address!!!
7   * Referrer bonus - 4% of amount your refferal
8   * Refferal bonus - 3% of amount his deposit
9   * 
10   * Fore more info visit
11   * EN RU  Telegram_chat: https://t.me/FuckEth
12   * 
13   *               
14   * 
15   *       █████   ██   ██  ██████  ██  ██  ██  ███     ██  ███████        ██████  ██████████  ██    ██
16   *       ██      ██   ██  ██      ██ ██       ██ ██   ██  ██             ██          ██      ██    ██
17   *       █████   ██   ██  ██      ████    ██  ██  ██  ██  ██  ███        █████       ██      ████████
18   *       ██      ██   ██  ██      ██ ██   ██  ██   ██ ██  ██    █        ██          ██      ██    ██
19   *       ██       █████   ██████  ██  ██  ██  ██     ███  ███████        ██████      ██      ██    ██
20   *        
21 */ 
22 contract FuckingEth {
23   using SafeMath for uint;
24 
25   struct Investor {
26     uint deposit;
27     uint paymentTime;
28     uint withdrawal;
29     uint FuckStartup;
30     bool isParticipant;
31   }
32 
33   mapping (address => Investor) public investors;
34   address public admin1Address;
35   address public admin2Address;
36   address public owner;
37   uint public investmentsNumber;
38   uint public investorsNumber;
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner, "access denied");
42     _;
43   }
44 
45   event OnRefLink(address indexed referral, uint referrarBonus, address indexed referrer,  uint referrerBonus, uint time);
46   event OnNewInvestor(address indexed addr, uint time);
47   event OnInvesment(address indexed addr, uint deposit, uint time);
48   event OnFuckChanged(address indexed addr, bool isActive, uint time);
49   event OnEarlyWithdrawal(address indexed addr, uint withdrawal, uint time);
50   event OnDeleteInvestor(address indexed addr, uint time);
51   event OnWithdraw(address indexed addr, uint withdrawal, uint time);
52   event OnFuckBonus(address indexed addr, uint bonus, uint time);
53   event OnNotEnoughBalance(uint time);
54 
55   constructor() public {
56     owner = msg.sender;
57     admin1Address = msg.sender;
58     admin2Address = msg.sender;
59      }
60 
61   function() external payable {
62     if (msg.value == 0) {
63       withdraw();
64     } else if (msg.value == 0.01 ether) {
65       Fuck();
66     } else if (msg.value == 0.003 ether) {
67       earlyWithdrawal();
68     } else {
69       deposit(bytes2address(msg.data));
70     }
71   }
72 
73   function disown() public onlyOwner {
74     owner = address(0x0);
75   }
76 
77   function setAdminsAddress(uint n, address addr) public onlyOwner {
78     require(n >= 1 && n <= 2, "invalid number of admin`s address");
79     if (n == 1) {
80       admin1Address = addr;
81     } else if (n == 2) {
82       admin2Address = addr;
83     } 
84   }
85 
86   function investorDividends(address investorAddr) public view returns(uint dividends, uint FuckBonus) {
87     return getDividends(investorAddr);
88   }
89 
90   function withdraw() public {
91     address investorAddr = msg.sender;
92     (uint dividends, uint FuckBonus) = getDividends(investorAddr);
93     require(dividends > 0, "cannot to pay zero dividends");
94     require(address(this).balance > 0, "fund is empty");
95     uint withdrawal = dividends + FuckBonus;
96 
97     // fund limit
98     if (address(this).balance <= withdrawal) {
99       emit OnNotEnoughBalance(now);
100       withdrawal = address(this).balance;
101     }
102 
103     Investor storage investor = investors[investorAddr];
104     uint withdrawalLimit = investor.deposit * 199 / 100; // 199%
105     uint totalWithdrawal = withdrawal + investor.withdrawal;
106 
107     // withdrawal limit - 199%
108     if (totalWithdrawal >= withdrawalLimit) {
109       withdrawal = withdrawalLimit.sub(investor.withdrawal);
110       if (FuckBonus > 0 ) {
111         emit OnFuckBonus(investorAddr, FuckBonus, now);
112       }
113       deleteInvestor(investorAddr);
114     } else {
115       // normal withdraw - dont use FuckBonus
116       if (withdrawal > dividends) {
117         withdrawal = dividends;
118       }
119       investor.withdrawal += withdrawal;
120       investor.paymentTime = now;
121       if (investor.FuckStartup > 0) {
122         investor.FuckStartup = 0;
123         emit OnFuckChanged(investorAddr, false, now);
124       }
125     }
126 
127     investorAddr.transfer(withdrawal);
128     emit OnWithdraw(investorAddr, withdrawal, now);
129   }
130 
131   function earlyWithdrawal() public {
132     address investorAddr = msg.sender;
133     Investor storage investor = investors[investorAddr];
134     require(investor.deposit > 0, "sender must be an investor");
135 
136     uint earlyWithdrawalLimit = investor.deposit * 75 / 100; // 75%
137     require(earlyWithdrawalLimit > investor.withdrawal, "early withdraw only before 75% deposit`s withdrawal");
138 
139     uint withdrawal = earlyWithdrawalLimit.sub(investor.withdrawal); 
140     investorAddr.transfer(withdrawal);
141     emit OnEarlyWithdrawal(investorAddr, withdrawal, now);
142 
143     deleteInvestor(investorAddr);
144   }
145 
146   function Fuck() public {
147     Investor storage investor = investors[msg.sender];
148     require(investor.deposit > 0, "sender must be an investor");
149     require(investor.FuckStartup == 0, "Fucking is already activated");
150     investor.FuckStartup = now;
151     emit OnFuckChanged(msg.sender, true, now);
152   }
153 
154   function deposit(address referrerAddr) public payable {
155     uint depositAmount = msg.value;
156     address investorAddr = msg.sender;
157     require(isNotContract(investorAddr), "invest from contracts is not supported");
158     require(depositAmount > 0, "deposit amount cannot be zero");
159 
160     admin1Address.send(depositAmount * 60 / 1000); //   6%
161     admin2Address.send(depositAmount * 20 / 1000); //   2%
162 
163     Investor storage investor = investors[investorAddr];
164     bool senderIsNotPaticipant = !investor.isParticipant;
165     bool referrerIsParticipant = investors[referrerAddr].isParticipant;
166 
167     // ref link
168     if (senderIsNotPaticipant && referrerIsParticipant && referrerAddr != investorAddr) {
169       uint referrerBonus = depositAmount * 4 / 100; // 4%
170       uint referralBonus = depositAmount * 3 / 100; // 3%
171       referrerAddr.transfer(referrerBonus);
172       investorAddr.transfer(referralBonus);
173       emit OnRefLink(investorAddr, referralBonus, referrerAddr, referrerBonus, now);
174     }
175 
176     if (investor.deposit == 0) {
177       investorsNumber++;
178       investor.isParticipant = true;
179       emit OnNewInvestor(investorAddr, now);
180     }
181 
182     investor.deposit += depositAmount;
183     investor.paymentTime = now;
184 
185     investmentsNumber++;
186     emit OnInvesment(investorAddr, depositAmount, now);
187   }
188 
189   function getDividends(address investorAddr) internal view returns(uint dividends, uint FuckBonus) {
190     Investor storage investor = investors[investorAddr];
191     if (investor.deposit == 0) {
192       return (0, 0);
193     }
194 
195     if (investor.FuckStartup > 0) {
196       uint FuckDays = now.sub(investor.FuckStartup).div(24 hours);
197       FuckBonus = FuckDays * investor.deposit * 500 / 100000; // 0.5%
198     }
199 
200     uint depositDays = now.sub(investor.paymentTime).div(24 hours);
201     dividends = depositDays * investor.deposit * 1 / 100; // 1%
202 
203     uint depositAmountBonus;
204     if (1 ether <= investor.deposit && investor.deposit <= 10 ether) {
205       depositAmountBonus = depositDays * investor.deposit * 5 / 10000; // 0.05%
206     } else if (10 ether <= investor.deposit && investor.deposit <= 25 ether) {
207       depositAmountBonus = depositDays * investor.deposit * 11 / 10000; // 0.11%
208     } else if (25 ether <= investor.deposit)  {
209       depositAmountBonus = depositDays * investor.deposit * 15 / 10000; // 0.15% 
210     
211    } dividends += depositAmountBonus;
212   }
213 
214   function isNotContract(address addr) internal view returns (bool) {
215     uint length;
216     assembly { length := extcodesize(addr) }
217     return length == 0;
218   }
219 
220   function bytes2address(bytes memory source) internal pure returns(address addr) {
221     assembly { addr := mload(add(source, 0x14)) }
222     return addr;
223   }
224 
225   function deleteInvestor(address investorAddr) private {
226     delete investors[investorAddr].deposit;
227     delete investors[investorAddr].paymentTime;
228     delete investors[investorAddr].withdrawal;
229     delete investors[investorAddr].FuckStartup;
230     emit OnDeleteInvestor(investorAddr, now);
231     investorsNumber--;
232   }
233 }
234 
235 /**
236  * @title SafeMath
237  * @dev Math operations with safety checks that revert on error
238  */
239 library SafeMath {
240 
241   /**
242   * @dev Multiplies two numbers, reverts on overflow.
243   */
244   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
245     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246     // benefit is lost if 'b' is also tested.
247     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248     if (_a == 0) {
249       return 0;
250     }
251 
252     uint256 c = _a * _b;
253     require(c / _a == _b);
254 
255     return c;
256   }
257 
258 
259   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
260     require(_b > 0); // Solidity only automatically asserts when dividing by 0
261     uint256 c = _a / _b;
262     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
263 
264     return c;
265   }
266 
267 
268   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
269     require(_b <= _a);
270     uint256 c = _a - _b;
271 
272     return c;
273   }
274 
275   /**
276   * @dev Adds two numbers, reverts on overflow.
277   */
278   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
279     uint256 c = _a + _b;
280     require(c >= _a);
281 
282     return c;
283   }
284 
285   /**
286     * reverts when dividing by zero.
287   */
288   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289     require(b != 0);
290     return a % b;
291   }
292 }