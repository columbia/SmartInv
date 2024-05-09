1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
66     // benefit is lost if 'b' is also tested.
67     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68     if (a == 0) {
69       return 0;
70     }
71 
72     c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     // uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return a / b;
85   }
86 
87   /**
88   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
99     c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 contract BGAudit is Ownable {
106 
107     using SafeMath for uint;
108 
109     event AddedAuditor(address indexed auditor);
110     event BannedAuditor(address indexed auditor);
111     event AllowedAuditor(address indexed auditor);
112 
113     event CreatedAudit(uint indexed id);
114     event ReviewingAudit(uint indexed id);
115     event AuditorRewarded(uint indexed id, address indexed auditor, uint indexed reward);
116 
117     event AuditorStaked(uint indexed id, address indexed auditor, uint indexed amount);
118     event WithdrawedStake(uint indexed id, address indexed auditor, uint indexed amount);
119     event SlashedStake(uint indexed id, address indexed auditor);
120 
121     enum AuditStatus { New, InProgress, InReview, Completed }
122 
123     struct Auditor {
124         bool banned;
125         address addr;
126         uint totalEarned;
127         uint completedAudits;
128         uint[] stakedAudits; // array of audit IDs they've staked
129         mapping(uint => bool) stakedInAudit; // key is AuditID; useful so we don't need to loop through the audits array above
130         mapping(uint => bool) canWithdrawStake; // Audit ID => can withdraw stake or not
131     }
132 
133     struct Audit {
134         AuditStatus status;
135         address owner;
136         uint id;
137         uint totalReward; // total reward shared b/w all auditors
138         uint remainingReward; // keep track of how much reward is left
139         uint stake; // required stake for each auditor in wei
140         uint endTime; // scheduled end time for the audit
141         uint maxAuditors; // max auditors allowed for this Audit
142         address[] participants; // array of auditor that have staked
143     }
144 
145     //=== Storage
146     uint public stakePeriod = 90 days; // number of days to wait before stake can be withdrawn
147     uint public maxAuditDuration = 365 days; // max amount of time for a security audit
148     Audit[] public audits;
149     mapping(address => Auditor) public auditors;
150 
151     //=== Owner related
152     function transfer(address _to, uint _amountInWei) external onlyOwner {
153         require(address(this).balance > _amountInWei);
154         _to.transfer(_amountInWei);
155     }
156 
157     function setStakePeriod(uint _days) external onlyOwner {
158         stakePeriod = _days * 1 days;
159     }
160 
161     function setMaxAuditDuration(uint _days) external onlyOwner {
162         maxAuditDuration = _days * 1 days;
163     }
164 
165 
166     //=== Auditors
167     function addAuditor(address _auditor) external onlyOwner {
168         require(auditors[_auditor].addr == address(0)); // Only add if they're not already added
169 
170         auditors[_auditor].banned = false;
171         auditors[_auditor].addr = _auditor;
172         auditors[_auditor].completedAudits = 0;
173         auditors[_auditor].totalEarned = 0;
174         emit AddedAuditor(_auditor);
175     }
176 
177     function banAuditor(address _auditor) external onlyOwner {
178         require(auditors[_auditor].addr != address(0));
179         auditors[_auditor].banned = true;
180         emit BannedAuditor(_auditor);
181     }
182 
183     function allowAuditor(address _auditor) external onlyOwner {
184         require(auditors[_auditor].addr != address(0));
185         auditors[_auditor].banned = false;
186         emit AllowedAuditor(_auditor);
187     }
188 
189 
190     //=== Audits and Rewards
191     function createAudit(uint _stake, uint _endTimeInDays, uint _maxAuditors) external payable onlyOwner {
192         uint endTime = _endTimeInDays * 1 days;
193         require(endTime < maxAuditDuration);
194         require(block.timestamp + endTime * 1 days > block.timestamp);
195         require(msg.value > 0 && _maxAuditors > 0 && _stake > 0);
196 
197         Audit memory audit;
198         audit.status = AuditStatus.New;
199         audit.owner = msg.sender;
200         audit.id = audits.length;
201         audit.totalReward = msg.value;
202         audit.remainingReward = audit.totalReward;
203         audit.stake = _stake;
204         audit.endTime = block.timestamp + endTime;
205         audit.maxAuditors = _maxAuditors;
206 
207         audits.push(audit); // push into storage
208         emit CreatedAudit(audit.id);
209     }
210 
211     function reviewAudit(uint _id) external onlyOwner {
212         require(audits[_id].status == AuditStatus.InProgress);
213         require(block.timestamp >= audits[_id].endTime);
214         audits[_id].endTime = block.timestamp; // override the endTime to when it actually ended
215         audits[_id].status = AuditStatus.InReview;
216         emit ReviewingAudit(_id);
217     }
218 
219     function rewardAuditor(uint _id, address _auditor, uint _reward) external onlyOwner {
220 
221         audits[_id].remainingReward.sub(_reward);
222         audits[_id].status = AuditStatus.Completed;
223 
224         auditors[_auditor].totalEarned.add(_reward);
225         auditors[_auditor].completedAudits.add(1);
226         auditors[_auditor].canWithdrawStake[_id] = true; // allow them to withdraw their stake after stakePeriod
227         _auditor.transfer(_reward);
228         emit AuditorRewarded(_id, _auditor, _reward);
229     }
230 
231     function slashStake(uint _id, address _auditor) external onlyOwner {
232         require(auditors[_auditor].addr != address(0));
233         require(auditors[_auditor].stakedInAudit[_id]); // participated in audit
234         auditors[_auditor].canWithdrawStake[_id] = false;
235         emit SlashedStake(_id, _auditor);
236     }
237 
238     //=== User Actions
239     function stake(uint _id) public payable {
240         // Check conditions of the Audit
241         require(msg.value == audits[_id].stake);
242         require(block.timestamp < audits[_id].endTime);
243         require(audits[_id].participants.length < audits[_id].maxAuditors);
244         require(audits[_id].status == AuditStatus.New || audits[_id].status == AuditStatus.InProgress);
245 
246         // Check conditions of the Auditor
247         require(auditors[msg.sender].addr == msg.sender && !auditors[msg.sender].banned); // auditor is authorized
248         require(!auditors[msg.sender].stakedInAudit[_id]); //check if auditor has staked for this audit already
249 
250         // Update audit's states
251         audits[_id].status = AuditStatus.InProgress;
252         audits[_id].participants.push(msg.sender);
253 
254         // Update auditor's states
255         auditors[msg.sender].stakedInAudit[_id] = true;
256         auditors[msg.sender].stakedAudits.push(_id);
257         emit AuditorStaked(_id, msg.sender, msg.value);
258     }
259 
260     function withdrawStake(uint _id) public {
261         require(audits[_id].status == AuditStatus.Completed);
262         require(auditors[msg.sender].canWithdrawStake[_id]);
263         require(block.timestamp >= audits[_id].endTime + stakePeriod);
264 
265         auditors[msg.sender].canWithdrawStake[_id] = false; //prevent replay attack
266         address(msg.sender).transfer(audits[_id].stake); // do this last to prevent re-entrancy
267         emit WithdrawedStake(_id, msg.sender, audits[_id].stake);
268     }
269 
270     //=== Getters
271     function auditorHasStaked(uint _id, address _auditor) public view returns(bool) {
272         return auditors[_auditor].stakedInAudit[_id];
273     }
274 
275     function auditorCanWithdrawStake(uint _id, address _auditor) public view returns(bool) {
276         if(auditors[_auditor].stakedInAudit[_id] && auditors[_auditor].canWithdrawStake[_id]) {
277             return true;
278         }
279         return false;
280     }
281 
282     // return a list of ids that _auditor has staked in
283     function getStakedAudits(address _auditor) public view returns(uint[]) {
284         return auditors[_auditor].stakedAudits;
285     }
286 
287     // return a list of auditors that participated in this audit
288     function getAuditors(uint _id) public view returns(address[]) {
289         return audits[_id].participants;
290     }
291 }