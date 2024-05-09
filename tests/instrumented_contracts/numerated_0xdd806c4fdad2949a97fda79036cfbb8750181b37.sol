1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error
31  */
32 library SafeMath {
33     /**
34     * @dev Multiplies two unsigned integers, reverts on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath::mul: Integer overflow");
46 
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0, "SafeMath::div: Invalid divisor zero");
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a, "SafeMath::sub: Integer underflow");
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Adds two unsigned integers, reverts on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath::add: Integer overflow");
78 
79         return c;
80     }
81 
82     /**
83     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
84     * reverts when dividing by zero.
85     */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0, "SafeMath::mod: Invalid divisor zero");
88         return a % b;
89     }
90 }
91 
92 /**
93  * @title Void
94  * @dev Collects failed proposal fees.
95  */
96 contract Void {}
97 
98 
99 /**
100  * @title Governance
101  * @dev Plutocratic voting system.
102  */
103 contract Governance {
104     using SafeMath for uint;
105 
106     event Execute(uint indexed proposalId);
107     event Propose(uint indexed proposalId, address indexed proposer, address indexed target, bytes data);
108     event RemoveVote(uint indexed proposalId, address indexed voter);
109     event Terminate(uint indexed proposalId);
110     event Vote(uint indexed proposalId, address indexed voter, bool approve, uint weight);
111 
112     enum Result { Pending, Yes, No }
113 
114     struct Proposal {
115         Result result;
116         address target;
117         bytes data;
118         address proposer;
119         address feeRecipient;
120         uint fee;
121         uint startTime;
122         uint yesCount;
123         uint noCount;
124     }
125 
126     uint public constant OPEN_VOTE_PERIOD = 2 days;
127     uint public constant VETO_PERIOD = 2 days;
128     uint public constant TOTAL_VOTE_PERIOD = OPEN_VOTE_PERIOD + VETO_PERIOD;
129 
130     uint public proposalFee;
131     IERC20 public token;
132     Void public void;
133 
134     Proposal[] public proposals;
135 
136     // Proposal Id => Voter => Yes Votes
137     mapping(uint => mapping(address => uint)) public yesVotes;
138 
139     // Proposal Id => Voter => No Votes
140     mapping(uint => mapping(address => uint)) public noVotes;
141 
142     // Voter => Deposit
143     mapping (address => uint) public deposits;
144 
145     // Voter => Withdraw timestamp
146     mapping (address => uint) public withdrawTimes;
147 
148     constructor(IERC20 _token, uint _initialProposalFee) public {
149         token = _token;
150         proposalFee = _initialProposalFee;
151         void = new Void();
152     }
153 
154     function deposit(uint amount) public {
155         require(token.transferFrom(msg.sender, address(this), amount), "Governance::deposit: Transfer failed");
156         deposits[msg.sender] = deposits[msg.sender].add(amount);
157     }
158 
159     function withdraw(uint amount) public {
160         require(time() > withdrawTimes[msg.sender], "Governance::withdraw: Voters with an active proposal cannot withdraw");
161         deposits[msg.sender] = deposits[msg.sender].sub(amount);
162         require(token.transfer(msg.sender, amount), "Governance::withdraw: Transfer failed");
163     }
164 
165     function propose(address target, bytes memory data) public returns (uint) {
166         return proposeWithFeeRecipient(msg.sender, target, data);
167     }
168 
169     function proposeWithFeeRecipient(address feeRecipient, address target, bytes memory data) public returns (uint) {
170         require(msg.sender != address(this) && target != address(token), "Governance::proposeWithFeeRecipient: Invalid proposal");
171         require(token.transferFrom(msg.sender, address(this), proposalFee), "Governance::proposeWithFeeRecipient: Transfer failed");
172 
173         uint proposalId = proposals.length;
174 
175         // Create a new proposal and vote yes
176         Proposal memory proposal;
177         proposal.target = target;
178         proposal.data = data;
179         proposal.proposer = msg.sender;
180         proposal.feeRecipient = feeRecipient;
181         proposal.fee = proposalFee;
182         proposal.startTime = time();
183         proposal.yesCount = proposalFee;
184 
185         proposals.push(proposal);
186 
187         emit Propose(proposalId, msg.sender, target, data);
188 
189         return proposalId;
190     }
191 
192     function voteYes(uint proposalId) public {
193         Proposal storage proposal = proposals[proposalId];
194         require(time() <= proposal.startTime.add(OPEN_VOTE_PERIOD), "Governance::voteYes: Proposal is no longer accepting yes votes");
195 
196         uint proposalEndTime = proposal.startTime.add(TOTAL_VOTE_PERIOD);
197         if (proposalEndTime > withdrawTimes[msg.sender]) withdrawTimes[msg.sender] = proposalEndTime;
198 
199         uint weight = deposits[msg.sender].sub(yesVotes[proposalId][msg.sender]);
200         proposal.yesCount = proposal.yesCount.add(weight);
201         yesVotes[proposalId][msg.sender] = deposits[msg.sender];
202 
203         emit Vote(proposalId, msg.sender, true, weight);
204     }
205 
206     function voteNo(uint proposalId) public {
207         Proposal storage proposal = proposals[proposalId];
208         require(proposal.result == Result.Pending, "Governance::voteNo: Proposal is already finalized");
209 
210         uint proposalEndTime = proposal.startTime.add(TOTAL_VOTE_PERIOD);
211         uint _time = time();
212         require(_time <= proposalEndTime, "Governance::voteNo: Proposal is no longer in voting period");
213 
214         uint _deposit = deposits[msg.sender];
215         uint weight = _deposit.sub(noVotes[proposalId][msg.sender]);
216         proposal.noCount = proposal.noCount.add(weight);
217         noVotes[proposalId][msg.sender] = _deposit;
218 
219         emit Vote(proposalId, msg.sender, false, weight);
220 
221         // Finalize the vote and burn the proposal fee if no votes outnumber yes votes and open voting has ended
222         if (_time > proposal.startTime.add(OPEN_VOTE_PERIOD) && proposal.noCount >= proposal.yesCount) {
223             proposal.result = Result.No;
224             require(token.transfer(address(void), proposal.fee), "Governance::voteNo: Transfer to void failed");
225             emit Terminate(proposalId);
226         } else if (proposalEndTime > withdrawTimes[msg.sender]) {
227             withdrawTimes[msg.sender] = proposalEndTime;
228         }
229 
230     }
231 
232     function removeVote(uint proposalId) public {
233         Proposal storage proposal = proposals[proposalId];
234         require(proposal.result == Result.Pending, "Governance::removeVote: Proposal is already finalized");
235         require(time() <= proposal.startTime.add(TOTAL_VOTE_PERIOD), "Governance::removeVote: Proposal is no longer in voting period");
236 
237         proposal.yesCount = proposal.yesCount.sub(yesVotes[proposalId][msg.sender]);
238         proposal.noCount = proposal.noCount.sub(noVotes[proposalId][msg.sender]);
239         delete yesVotes[proposalId][msg.sender];
240         delete noVotes[proposalId][msg.sender];
241 
242         emit RemoveVote(proposalId, msg.sender);
243     }
244 
245     function finalize(uint proposalId) public {
246         Proposal storage proposal = proposals[proposalId];
247         require(proposal.result == Result.Pending, "Governance::finalize: Proposal is already finalized");
248         uint _time = time();
249 
250         if (proposal.yesCount > proposal.noCount) {
251             require(_time > proposal.startTime.add(TOTAL_VOTE_PERIOD), "Governance::finalize: Proposal cannot be executed until end of veto period");
252 
253             proposal.result = Result.Yes;
254             require(token.transfer(proposal.feeRecipient, proposal.fee), "Governance::finalize: Return proposal fee failed");
255             proposal.target.call(proposal.data);
256 
257             emit Execute(proposalId);
258         } else {
259             require(_time > proposal.startTime.add(OPEN_VOTE_PERIOD), "Governance::finalize: Proposal cannot be terminated until end of yes vote period");
260 
261             proposal.result = Result.No;
262             require(token.transfer(address(void), proposal.fee), "Governance::finalize: Transfer to void failed");
263 
264             emit Terminate(proposalId);
265         }
266     }
267 
268     function setProposalFee(uint fee) public {
269         require(msg.sender == address(this), "Governance::setProposalFee: Proposal fee can only be set via governance");
270         proposalFee = fee;
271     }
272 
273     function time() public view returns (uint) {
274         return block.timestamp;
275     }
276 
277     function getProposal(uint proposalId) external view returns (Proposal memory) {
278         return proposals[proposalId];
279     }
280 
281     function getProposalsCount() external view returns (uint) {
282         return proposals.length;
283     }
284 
285 }
286 
287 
288 /**
289  * @title HumanityGovernance
290  * @dev Plutocratic voting system that uses Humanity token for voting and proposal fees.
291  */
292 contract HumanityGovernance is Governance {
293 
294     constructor(IERC20 humanity, uint proposalFee) public
295         Governance(humanity, proposalFee) {}
296 
297 }