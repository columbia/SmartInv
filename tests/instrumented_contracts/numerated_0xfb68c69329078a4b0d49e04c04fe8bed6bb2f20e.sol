1 /* Keep4r – kp4r.network - 2020 */
2 
3 pragma solidity 0.6.6;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint);
10     function approve(address spender, uint amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint) {
18         uint c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint a, uint b) internal pure returns (uint) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
27         require(b <= a, errorMessage);
28         uint c = a - b;
29 
30         return c;
31     }
32     function mul(uint a, uint b) internal pure returns (uint) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint a, uint b) internal pure returns (uint) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint c = a / b;
49 
50         return c;
51     }
52 }
53 
54 contract Keep4rPresale {
55     using SafeMath for uint256;
56 
57     // cannot purchase until started
58     bool public started;
59 
60     IERC20 KP4R;
61     address kp4rAddress;
62 
63     address public manager;
64     address public managerPending;
65     uint256 constant managerS = 80;
66     uint256 public managerWithdrawn;
67     address public overseer;
68     address public overseerPending;
69     uint256 constant overseerS = 20;
70     uint256 public overseerWithdrawn;
71 
72     uint256 public unitPrice = 1e18/2;
73     uint256 public minimumOrder = 100000;
74     uint256 public BP = 100000;
75 
76     /** @notice the date when purchased KP4R can be claimed */
77     uint256 public unlocksOn;
78 
79     /** @notice the date when KP4R can no longer be purchased from the contract */
80     uint256 public endsOn;
81 
82     /** @notice percentage bonus actived upon purchasing more than the trigger
83     * value. */
84     uint256 public bonusTrigger;
85     uint256 public bonusPercentage;
86 
87     // Stats:
88     uint256 public totalForSale;
89     uint256 public totalSold;
90     uint256 public totalSettled;
91     uint256 public weiRaised;
92 
93     mapping(address => uint256) public balance;
94 
95     event Purchase (address indexed buyer, uint256 amount, uint256 price);
96 
97     constructor(address _kp4r) public {
98         manager = msg.sender;
99         overseer = msg.sender;
100         KP4R = IERC20(_kp4r);
101         kp4rAddress = _kp4r;
102     }
103 
104     modifier onlyManager {
105         require( msg.sender == manager, "Only the manager can call this function." );
106         _;
107     }
108 
109     modifier onlyOverseer {
110         require( msg.sender == overseer, "Only the overseer can call this function.");
111         _;
112     }
113 
114     function transferRole(address _new) public {
115         require(msg.sender == manager || msg.sender == overseer, "!manager or overseer");
116         if (msg.sender == manager) { managerPending = _new; return; }
117         if (msg.sender == overseer) { overseerPending = _new; return; }
118     }
119 
120     function acceptRole() public {
121         require(msg.sender == managerPending || msg.sender == overseerPending, "!managerPending or overseerPending");
122         if (msg.sender == managerPending) { manager = managerPending; managerPending = address(0); return; }
123         if (msg.sender == overseerPending) { overseer = overseerPending; managerPending = address(0); return; }
124     }
125 
126     function managerSetPrice(uint256 _price) public onlyManager {
127         unitPrice = _price;
128     }
129 
130     function managerSetMinimum(uint256 _minimum) public onlyManager {
131         minimumOrder = _minimum;
132     }
133 
134     function managerSetBonus(uint256 _trigger, uint256 _percentage) public onlyManager {
135         bonusTrigger = _trigger;
136         bonusPercentage = _percentage;
137     }
138 
139     function managerDeposit(uint256 _amount) public onlyManager {
140         KP4R.transferFrom(msg.sender, address(this), _amount);
141         totalForSale = totalForSale.add(_amount);
142     }
143 
144     /** @notice manager can reclaim unsold tokens */
145     function managerReclaim(uint256 _amount) public onlyManager {
146         // calculate the amount of tokens that haven not been sold
147         // and settled and are thus reclaimable:
148         uint256 unreclaimable = totalSold.sub(totalSettled);
149         uint256 reclaimable = KP4R.balanceOf(address(this)).sub(unreclaimable);
150         require(_amount <= reclaimable, "cannot withdraw already sold tokens");
151 
152         // transfer the tokens to the manager
153         KP4R.transfer(msg.sender, _amount);
154         totalForSale = totalForSale.sub(_amount);
155     }
156 
157     function managerWithdraw(uint256 _amount) public onlyManager {
158         require(managerWithdrawn.add(_amount) <= weiRaised.mul(managerS).div(100), "cannot withdraw more than the managers share");
159         managerWithdrawn = managerWithdrawn.add(_amount);
160         msg.sender.transfer(_amount);
161     }
162 
163     function overseerWithdraw(uint _amount) public onlyOverseer {
164         require(overseerWithdrawn.add(_amount) <= weiRaised.mul(overseerS).div(100), "cannot withdraw more than overseerS");
165         overseerWithdrawn = overseerWithdrawn.add(_amount);
166         msg.sender.transfer(_amount);
167     }
168 
169     function managerClose(uint256 amount) public onlyManager {
170         require(block.timestamp > endsOn.add(31536000).mul(2), "must wait until 6 months past end date");
171         msg.sender.transfer(amount);
172     }
173 
174     function managerImportBalance(address acc, uint256 bal) public onlyManager {
175         balance[acc] = balance[acc].add(bal);
176     }
177 
178     function managerForceUnlock() public onlyManager {
179         unlocksOn = block.timestamp-1;
180     }
181 
182     function managerSetBP(uint256 bp) public onlyManager {
183         require(bp > 100, "basis points too low");
184         BP = bp;
185     }
186 
187     function start(uint256 _unlocksOn, uint256 _endsOn, uint256 _price, uint256 _minimumOrder) public onlyManager {
188         require(!started, "already started");
189         unlocksOn = _unlocksOn;
190         endsOn = _endsOn;
191         unitPrice = _price;
192         minimumOrder = _minimumOrder;
193         started = true;
194     }
195 
196     /** @notice The amount of KP4R remaining */
197     function remaining() public view returns (uint256) {
198         return KP4R.balanceOf(address(this));
199     }
200 
201     /** @notice purchase KP4R at the current unit price */
202     function purchase() public payable {
203         require(started, "token sale has not yet started");
204         require(msg.value > minimumOrder, "amount purchased is too small");
205         require(block.timestamp < endsOn, "presale has ended");
206 
207         // calculate the amount of KP4R purchasable
208         uint256 _kp4r = calculateAmountPurchased(msg.value);
209         require(_kp4r <= KP4R.balanceOf(address(this)), "not enough KP4R left");
210 
211         // update the users balance
212         balance[msg.sender] = balance[msg.sender].add(_kp4r);
213         totalSold = totalSold.add(_kp4r);
214         weiRaised = weiRaised.add(msg.value);
215 
216         emit Purchase(msg.sender, _kp4r, msg.value);
217     }
218 
219     /** @notice calculates the amount purchasedfor a given amount of eth */
220     function calculateAmountPurchased(uint256 _value) public view returns (uint256) {
221 
222         uint256 _kp4r = _value.mul(BP).div(unitPrice).mul(1e18).div(BP);
223 
224         if (_value > bonusTrigger) {
225             uint256 _bonus = _kp4r.mul(bonusPercentage).div(10000);
226             if (_kp4r.add(_bonus) <= KP4R.balanceOf(address(this))) {
227                 _kp4r = _kp4r.add(_bonus);
228             }
229         }
230         
231         return _kp4r;
232     }
233 
234     /** @notice claim you eth */
235     function claim() public {
236         require(block.timestamp > unlocksOn, "presale has not unlocked yet");
237         require(balance[msg.sender] > 0, "nothing to withdraw");
238         uint256 bal = balance[msg.sender];
239         balance[msg.sender] = 0;
240         KP4R.transfer(msg.sender, bal);
241         totalSettled = totalSettled.add(bal);
242     }
243 
244     // fallbacks to allow users to send to the contract to purchase KP4R
245     receive() external payable { purchase(); }
246     fallback() external payable { purchase(); }
247 }