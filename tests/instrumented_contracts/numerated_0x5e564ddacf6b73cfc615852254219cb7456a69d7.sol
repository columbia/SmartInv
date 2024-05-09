1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         if(a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b, "NaN");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         require(b > 0, "NaN");
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20         require(b <= a, "NaN");
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         require(c >= a, "NaN");
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
32         require(b != 0, "NaN");
33         return a % b;
34     }
35 }
36 
37 contract Roles {
38     mapping(string => mapping(address => bool)) private rules;
39 
40     event RoleAdded(string indexed role, address indexed to);
41     event RoleRemoved(string indexed role, address indexed to);
42 
43     modifier onlyHasRole(string _role) {
44         require(rules[_role][msg.sender], "Access denied");
45         _;
46     }
47 
48     function hasRole(string _role, address _to) view public returns(bool) {
49         require(_to != address(0), "Zero address");
50 
51         return rules[_role][_to];
52     }
53 
54     function addRole(string _role, address _to) internal {
55         require(_to != address(0), "Zero address");
56 
57         rules[_role][_to] = true;
58 
59         emit RoleAdded(_role, _to);
60     }
61 
62     function removeRole(string _role, address _to) internal {
63         require(_to != address(0), "Zero address");
64 
65         rules[_role][_to] = false;
66         
67         emit RoleRemoved(_role, _to);
68     }
69 }
70 
71 contract Goeth is Roles {
72     using SafeMath for uint;
73 
74     struct Investor {
75         uint invested;
76         uint payouts;
77         uint first_invest;
78         uint last_payout;
79         address referrer;
80     }
81 
82     struct Admin {
83         uint percent;
84         uint timeout;
85         uint min_balance;
86         uint last_withdraw;
87     }
88 
89     uint constant public COMMISSION = 0;
90     uint constant public REFBONUS = 5;
91     uint constant public CASHBACK = 5;
92     uint constant public DRAWTIMEOUT = 1 days;
93     uint constant public MAXPAYOUT = 40;
94 
95     address public beneficiary = 0xa5451D1a11B3e2eE537423b724fa8F9FaAc1DD62;
96 
97     mapping(address => Investor) public investors;
98     mapping(address => bool) public blockeds;
99 
100     uint[] public draw_size = [5, 3, 2];
101     uint public last_draw = block.timestamp;
102     address[] public top = new address[](draw_size.length);
103     
104     mapping(address => Admin) public admins;
105 
106     event Payout(address indexed holder, uint etherAmount);
107     event Deposit(address indexed holder, uint etherAmount, address referrer);
108     event RefBonus(address indexed from, address indexed to, uint etherAmount);
109     event CashBack(address indexed holder, uint etherAmount);
110     event WithdrawEther(address indexed to, uint etherAmount);
111     event Blocked(address indexed holder);
112     event UnBlocked(address indexed holder);
113     event TopWinner(address indexed holder, uint top, uint etherAmount);
114 
115     constructor() {
116         addRole("manager", 0x17a709173819d7c2E42DBB70643c848450093874);
117         addRole("manager", 0x2d15b5caFEE3f0fC2FA778b875987f756D64c789);
118 
119         admins[0x1295Cd3f1D825E49B9775497cF9B082c5719C099] = Admin(30, 7 days, 0, 0);
120         admins[0x9F31c056b518B8492016F08931F7C274d344d21C] = Admin(35, 7 days, 0, 0);
121         admins[0x881AF76148D151E886d2F4a74A1d548d1587E7AE] = Admin(35, 7 days, 0, 0);
122         admins[0x42966e110901FAD6f1A55ADCC8219b541D60b258] = Admin(35, 7 days, 50 ether, 0);
123         admins[0x07DD5923F0B52AB77cC2739330d1139a38b024F3] = Admin(35, 7 days, 50 ether, 0);
124         admins[0x470942C45601F995716b00f3F6A122ec6D1A36ce] = Admin(2, 0, 0, 0);
125         admins[0xe75f7128367B4C0a8856E412920B96db3476e7C9] = Admin(3, 0, 0, 0);
126         admins[0x9cc869eE8720BF720B8804Ad12146e43bbd5022d] = Admin(3, 0, 0, 0);
127     }
128 
129     function investorBonusSize(address _to) view public returns(uint) {
130         uint b = investors[_to].invested;
131 
132         if(b >= 50 ether) return 5;
133         if(b >= 20 ether) return 3;
134         if(b >= 10 ether) return 2;
135         if(b >= 5 ether) return 1;
136         return 0;
137     }
138 
139     function bonusSize() view public returns(uint) {
140         uint b = address(this).balance;
141 
142         if(b >= 2500 ether) return 10;
143         if(b >= 1000 ether) return 8;
144         if(b >= 500 ether) return 7;
145         if(b >= 200 ether) return 6;
146         return 5;
147     }
148 
149     function payoutSize(address _to) view public returns(uint) {
150         uint invested = investors[_to].invested;
151         uint max = invested.div(100).mul(MAXPAYOUT);
152         if(invested == 0 || investors[_to].payouts >= max) return 0;
153 
154         uint bonus = bonusSize().add(investorBonusSize(_to));
155         uint payout = invested.mul(bonus).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
156 
157         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
158     }
159 
160     function bytesToAddress(bytes bys) pure private returns(address addr) {
161         assembly {
162             addr := mload(add(bys, 20))
163         }
164     }
165 
166     function _checkReinvest(address _to) private {
167         if(investors[_to].last_payout > 0 && block.timestamp > investors[_to].last_payout + 22 days) {
168             uint c = (block.timestamp - investors[_to].last_payout) / 22 days;
169             for(uint i = 0; i < c; i++) {
170                 investors[_to].invested = investors[_to].invested.add(investors[_to].invested.div(100).mul(20));
171                 _reCalcTop(_to);
172             }
173         }
174     }
175 
176     function _reCalcTop(address _to) private {
177         uint b = investors[_to].invested;
178         for(uint i = 0; i < draw_size.length; i++) {
179             if(investors[top[i]].invested < b) {
180                 for(uint j = draw_size.length - 1; j > i; j--) {
181                     top[j] = top[j - 1];
182                 }
183 
184                 top[i] = _to;
185                 break;
186             }
187         }
188     }
189 
190     function() payable external {
191         if(hasRole("manager", msg.sender)) {
192             require(msg.data.length > 0, "Send the address in data");
193             
194             address addr = bytesToAddress(msg.data);
195 
196             require(!hasRole("manager", addr) && admins[addr].percent == 0, "This address is manager");
197 
198             if(!blockeds[addr]) {
199                 blockeds[addr] = true;
200                 emit Blocked(addr);
201             }
202             else {
203                 blockeds[addr] = false;
204                 emit UnBlocked(addr);
205             }
206             
207             if(msg.value > 0) {
208                 msg.sender.transfer(msg.value);
209             }
210 
211             return;
212         }
213 
214         if(investors[msg.sender].invested > 0 && !blockeds[msg.sender]) {
215             _checkReinvest(msg.sender);
216             uint payout = payoutSize(msg.sender);
217 
218             require(msg.value > 0 || payout > 0, "No payouts");
219 
220             if(payout > 0) {
221                 investors[msg.sender].last_payout = block.timestamp;
222                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
223 
224                 msg.sender.transfer(payout);
225 
226                 emit Payout(msg.sender, payout);
227 
228                 //if(investors[msg.sender].payouts >= investors[msg.sender].invested.add(investors[msg.sender].invested.div(100).mul(MAXPAYOUT))) {
229                 //    delete investors[msg.sender];
230                 //}
231             }
232         }
233         
234         if(msg.value > 0) {
235             require(msg.value >= 0.01 ether, "Minimum investment amount 0.01 ether");
236 
237             investors[msg.sender].last_payout = block.timestamp;
238             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
239 
240             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
241 
242             if(investors[msg.sender].first_invest == 0) {
243                 investors[msg.sender].first_invest = block.timestamp;
244 
245                 if(msg.data.length > 0) {
246                     address ref = bytesToAddress(msg.data);
247 
248                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
249                         investors[msg.sender].referrer = ref;
250 
251                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
252                         ref.transfer(ref_bonus);
253 
254                         emit RefBonus(msg.sender, ref, ref_bonus);
255 
256                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
257                         investors[msg.sender].invested = investors[msg.sender].invested.add(cashback_bonus);
258 
259                         emit CashBack(msg.sender, cashback_bonus);
260                     }
261                 }
262             }
263 
264             _reCalcTop(msg.sender);
265 
266             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
267         }
268     }
269 
270     function draw() public {
271         require(block.timestamp > last_draw + DRAWTIMEOUT, "The drawing is available 1 time in 24 hours");
272 
273         last_draw = block.timestamp;
274 
275         uint balance = address(this).balance;
276 
277         for(uint i = 0; i < draw_size.length; i++) {
278             if(top[i] != address(0)) {
279                 uint amount = balance.div(100).mul(draw_size[i]);
280                 top[i].transfer(amount);
281 
282                 emit TopWinner(top[i], i + 1, amount);
283             }
284         }
285     }
286 
287     function withdrawEther(address _to) public {
288         Admin storage admin = admins[msg.sender];
289         uint balance = address(this).balance;
290 
291         require(admin.percent > 0, "Access denied");
292         require(admin.timeout == 0 || block.timestamp > admin.last_withdraw.add(admin.timeout), "Timeout");
293         require(_to != address(0), "Zero address");
294         require(balance > 0, "Not enough balance");
295 
296         uint amount = balance > admin.min_balance ? balance.div(100).mul(admin.percent) : balance;
297 
298         admin.last_withdraw = block.timestamp;
299 
300         _to.transfer(amount);
301 
302         emit WithdrawEther(_to, amount);
303     }
304 }