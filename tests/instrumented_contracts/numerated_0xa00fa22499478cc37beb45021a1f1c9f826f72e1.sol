1 contract Ambi {
2     function getNodeAddress(bytes32) constant returns (address);
3     function addNode(bytes32, address) external returns (bool);
4     function hasRelation(bytes32, bytes32, address) constant returns (bool);
5 }
6 
7 contract AmbiEnabled {
8     Ambi ambiC;
9     bytes32 public name;
10 
11     modifier checkAccess(bytes32 _role) {
12         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
13             _
14         }
15     }
16     
17     function getAddress(bytes32 _name) returns (address) {
18         return ambiC.getNodeAddress(_name);
19     }
20 
21     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
22         if(address(ambiC) != 0x0){
23             return false;
24         }
25         Ambi ambiContract = Ambi(_ambi);
26         if(ambiContract.getNodeAddress(_name)!=address(this)) {
27             bool isNode = ambiContract.addNode(_name, address(this));
28             if (!isNode){
29                 return false;
30             }   
31         }
32         name = _name;
33         ambiC = ambiContract;
34         return true;
35     }
36 
37     function remove(){
38         if(msg.sender == address(ambiC)){
39             suicide(msg.sender);
40         }
41     }
42 }
43 
44 contract ElcoinDb {
45     function getBalance(address addr) constant returns(uint balance);
46 }
47 
48 contract ElcoinInterface {
49     function rewardTo(address _to, uint _amount) returns (bool);
50 }
51 
52 contract PosRewards is AmbiEnabled {
53 
54     event Reward(address indexed beneficiary, uint indexed cycle, uint value, uint position);
55 
56     uint public cycleLength; // PoS will be ready to send each cycleLength seconds
57     uint public startTime;   // starting at startTime
58     uint public cycleLimit;  // and will stop after cycleLimit cycles pass
59     uint public minimalRewardedBalance; // but only those accounts having balance
60                              // >= minimalRewardedBalance will get reward
61     uint[] public bannedCycles;
62 
63     enum RewardStatuses { Unsent, Sent, TooSmallToSend }
64 
65     struct Account {
66         address recipient;
67         RewardStatuses status;
68     }
69 
70     // cycleNumber => (address => minimalBalance)
71     mapping (uint => mapping (address => int)) public accountsBalances;
72     // cycleNumber => Account[]
73     mapping (uint => Account[]) public accountsUsed;
74 
75     function PosRewards() {
76         cycleLength = 864000; // 864000 seconds = 10 days, 14400 = 4 hours
77         cycleLimit = 255; // that's 9 + 9 + 9 + 9 + 219, see getRate() for info
78         minimalRewardedBalance = 1000000; // 1 coin
79         startTime = now;
80     }
81 
82     // USE THIS FUNCTION ONLY IN NEW CONTRACT, IT WILL CORRUPT ALREADY COLLECTED DATA!
83     // startTime should be set to the time when PoS starts (on Dec 17, probably block 705000 or so).
84     // It should be at 12:00 Moscow time, this would be the start of all PoS cycles.
85     function setStartTime(uint _startTime) checkAccess("owner") {
86         startTime = _startTime;
87     }
88 
89     // this allows to end PoS before 2550 days pass or to extend it further
90     function setCycleLimit(uint _cycleLimit) checkAccess("owner") {
91         cycleLimit = _cycleLimit;
92     }
93 
94     // this allows to disable PoS sending for some of the cycles in case we
95     // need to send custom PoS. This will be 100% used on first deploy.
96     function setBannedCycles(uint[] _cycles) checkAccess("owner") {
97         bannedCycles = _cycles;
98     }
99 
100     // set to 0 to reward everyone
101     function setMinimalRewardedBalance(uint _balance) checkAccess("owner") {
102         minimalRewardedBalance = _balance;
103     }
104 
105     function kill() checkAccess("owner") {
106         suicide(msg.sender); // kills this contract and sends remaining funds back to msg.sender
107     }
108 
109     // First 90 days 50% yearly
110     // Next 90 days 40%
111     // Next 90 days 30%
112     // Next 90 days 20%
113     // Next 2190 days 10%
114     function getRate(uint cycle) constant returns (uint) {
115         if (cycle <= 9) {
116             return 50;
117         }
118         if (cycle <= 18) {
119             return 40;
120         }
121         if (cycle <= 27) {
122             return 30;
123         }
124         if (cycle <= 35) { // not 36 because 36 is elDay
125             return 20;
126         }
127         if (cycle == 36) {
128             return 40;
129         }
130         if (cycle <= cycleLimit) {
131             if (cycle % 36 == 0) {
132                 // Every 360th day, reward amounts double.
133                 // The elDay lasts precisely 24 hours, and after that, reward amounts revert to their original values.
134                 return 20;
135             }
136 
137             return 10;
138         }
139         return 0;
140     }
141 
142     // Cycle numeration starts from 1, 0 will be handled as not valid cycle
143     function currentCycle() constant returns (uint) {
144         if (startTime > now) {
145             return 0;
146         }
147 
148         return 1 + ((now - startTime) / cycleLength);
149     }
150 
151     function _isCycleValid(uint _cycle) constant internal returns (bool) {
152         if (_cycle >= currentCycle() || _cycle == 0) {
153             return false;
154         }
155         for (uint i; i<bannedCycles.length; i++) {
156             if (bannedCycles[i] == _cycle) {
157                 return false;
158             }
159         }
160 
161         return true;
162     }
163 
164     // Returns how much Elcoin would be granted for user's minimal balance X in cycle Y
165     // The function is optimized to work with whole integer arithmetics
166     function getInterest(uint amount, uint cycle) constant returns (uint) {
167         return (amount * getRate(cycle)) / 3650;
168     }
169 
170     // This function logs the balances after the transfer to be used in further calculations
171     function transfer(address _from, address _to) checkAccess("elcoin") {
172         if (startTime == 0) {
173             return; // the easy way to disable PoS
174         }
175 
176         _storeBalanceRecord(_from);
177         _storeBalanceRecord(_to);
178     }
179 
180     function _storeBalanceRecord(address _addr) internal {
181         ElcoinDb db = ElcoinDb(getAddress("elcoinDb"));
182         uint cycle = currentCycle();
183 
184         if (cycle > cycleLimit) {
185             return;
186         }
187 
188         int balance = int(db.getBalance(_addr));
189         bool accountNotUsedInCycle = (accountsBalances[cycle][_addr] == 0);
190 
191         // We'll use -1 to mark accounts that have zero balance because
192         // mappings return 0 for unexisting records and there is no way to
193         // differ them without additional data structure
194         if (accountsBalances[cycle][_addr] != -1 && (accountNotUsedInCycle || accountsBalances[cycle][_addr] > balance)) {
195             if (balance == 0) {
196                 balance = -1;
197             }
198             accountsBalances[cycle][_addr] = balance;
199 
200             if (accountNotUsedInCycle) {
201                 // do this only once for each account in each cycle
202                 accountsUsed[cycle].push(Account(_addr, RewardStatuses.Unsent));
203             }
204         }
205     }
206 
207     // Get minimal balance for address in some cycle
208     function getMinimalBalance(uint _cycle, address _addr) constant returns(int) {
209         int balance = accountsBalances[_cycle][_addr];
210         if (balance == -1) {
211             balance = 0;
212         }
213 
214         return balance;
215     }
216 
217     // Get information from accountsUsed structure
218     function getAccountInfo(uint _cycle, uint _position) constant returns(address, RewardStatuses, int) {
219         return (
220             accountsUsed[_cycle][_position].recipient,
221             accountsUsed[_cycle][_position].status,
222             accountsBalances[_cycle][accountsUsed[_cycle][_position].recipient]
223           );
224     }
225 
226     // Get information from accountsUsed structure
227     function getRewardsCount(uint _cycle) constant returns(uint) {
228         return accountsUsed[_cycle].length;
229     }
230 
231     function sendReward(uint _cycle, uint _position) returns(bool) {
232         // Check that parameters are in valid ranges
233         if (!_isCycleValid(_cycle) || _position >= accountsUsed[_cycle].length) {
234             return false;
235         }
236 
237         // Check that this reward was not sent
238         Account claimant = accountsUsed[_cycle][_position];
239         if (claimant.status != RewardStatuses.Unsent) {
240             return false;
241         }
242 
243         // Check that this reward passes the conditions
244         int minimalAccountBalance = accountsBalances[_cycle][claimant.recipient];
245         if (minimalAccountBalance < int(minimalRewardedBalance)) {
246             claimant.status = RewardStatuses.TooSmallToSend;
247             return false;
248         }
249 
250         uint rewardAmount = getInterest(uint(minimalAccountBalance), _cycle);
251 
252         // We are ready to send the reward
253         ElcoinInterface elcoin = ElcoinInterface(getAddress("elcoin"));
254         bool result = elcoin.rewardTo(claimant.recipient, rewardAmount);
255         if (result) {
256             Reward(claimant.recipient, _cycle, rewardAmount, _position);
257             claimant.status = RewardStatuses.Sent;
258         }
259 
260         return true;
261     }
262 }