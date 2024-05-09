1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 
82 contract Vote {
83   using SafeMath for uint256;
84   struct Proposal {
85     uint deadline;
86     mapping(address => uint) votes;
87     uint yeas;
88     uint nays;
89     string reason;
90     bytes data;
91     address target;
92   }
93   struct Deposit {
94     uint balance;
95     uint lockedUntil;
96   }
97 
98   event Proposed(
99     uint proposalId,
100     uint deadline,
101     address target
102   );
103 
104   event Executed(
105     uint indexed proposalId
106   );
107 
108   event Vote(
109     uint indexed proposalId,
110     address indexed voter,
111     uint yeas,
112     uint nays,
113     uint totalYeas,
114     uint totalNays
115   );
116 
117   ERC20 public token;
118   uint public proposalDuration;
119   Proposal[] public proposals;
120   mapping(address => Deposit) public deposits;
121   mapping(address => bool) public proposers;
122 
123   constructor(address _token) {
124     proposers[msg.sender] = true;
125     token = ERC20(_token);
126     proposalDuration = 5;
127     // Start with a passed proposal to increase the duration to 24 hours.
128     // Having a short initial proposalDuration makes testing easier, but 24
129     // hours is a more reasonable time frame for voting. Having a pre-approved
130     // proposal to increase the time means it only has to be executed, and not
131     // voted on, as proposing a vote and voting on it within a 5 second
132     // duration could be very difficult to accomplish on a main network.
133     proposals.push(Proposal({
134       deadline: block.timestamp,
135       yeas: 1,
136       nays: 0,
137       reason: "",
138       // ABI Encoded setProposalDuration(60*60*24)
139       data: hex"7d007ac10000000000000000000000000000000000000000000000000000000000015180",
140       target: this
141     }));
142   }
143 
144   // In order to vote on a proposal, voters must deposit tokens in the contract
145   function deposit(uint units) public {
146     require(token.transferFrom(msg.sender, address(this), units), "Transfer failed");
147     deposits[msg.sender].balance = deposits[msg.sender].balance.add(units);
148   }
149 
150   // Once all proposals a user has voted on have completed, they may withdraw
151   // their tokens from the contract.
152   function withdraw(uint units) external {
153     require(deposits[msg.sender].balance >= units, "Insufficient balance");
154     require(deposits[msg.sender].lockedUntil < block.timestamp, "Deposit locked");
155     deposits[msg.sender].balance = deposits[msg.sender].balance.sub(units);
156     token.transfer(msg.sender, units);
157   }
158 
159   // A user may cast a number of yea or nay votes equal to the number of tokens
160   // they have deposited in the contract. This will lock the user's deposit
161   // until the voting ends for this proposal. Locking deposits ensures the user
162   // cannot vote, then transfer tokens away and use them to vote again.
163   function vote(uint proposalId, uint yeas, uint nays) public {
164 
165     require(
166       proposals[proposalId].deadline > block.timestamp,
167       "Voting closed"
168     );
169     if(proposals[proposalId].deadline > deposits[msg.sender].lockedUntil) {
170       // The voter's deposit is locked until the proposal deadline
171       deposits[msg.sender].lockedUntil = proposals[proposalId].deadline;
172     }
173     // Track vote counts to ensure voters can only vote their deposited tokens
174     proposals[proposalId].votes[msg.sender] = proposals[proposalId].votes[msg.sender].add(yeas).add(nays);
175     require(proposals[proposalId].votes[msg.sender] <= deposits[msg.sender].balance, "Insufficient balance");
176 
177     // Presumably only one of these will change.
178     proposals[proposalId].yeas = proposals[proposalId].yeas.add(yeas);
179     proposals[proposalId].nays = proposals[proposalId].nays.add(nays);
180 
181     emit Vote(proposalId, msg.sender, yeas, nays, proposals[proposalId].yeas, proposals[proposalId].nays);
182   }
183 
184   // depositAndVote allows users to call deposit() and vote() in a single
185   // transaction.
186   function depositAndVote(uint proposalId, uint yeas, uint nays) external {
187     deposit(yeas.add(nays));
188     vote(proposalId, yeas, nays);
189   }
190 
191   // Authorized proposers may issue proposals. They must provide the contract
192   // data, the target contract, and a reason for the proposal. The reason will
193   // probably be a swarm / ipfs URL with a longer explanation.
194   function propose(bytes data, address target, string reason) external {
195     require(proposers[msg.sender], "Invalid proposer");
196     require(data.length > 0, "Invalid proposal");
197     uint proposalId = proposals.push(Proposal({
198       deadline: block.timestamp + proposalDuration,
199       yeas: 0,
200       nays: 0,
201       reason: reason,
202       data: data,
203       target: target
204     }));
205     emit Proposed(
206       proposalId - 1,
207       block.timestamp + proposalDuration,
208       target
209     );
210   }
211 
212   // If a proposal has passed, it may be executed exactly once. Executed
213   // proposals will have the data zeroed out, discounting gas for the submitter
214   // and effectively marking the proposal as executed.
215   function execute(uint proposalId) external {
216     Proposal memory proposal = proposals[proposalId];
217     require(
218       // Voting is complete when the deadline passes, or a majority of all
219       // token holders have voted yea.
220       proposal.deadline < block.timestamp || proposal.yeas > (token.totalSupply() / 2),
221       "Voting is not complete"
222     );
223     require(proposal.data.length > 0, "Already executed");
224     if(proposal.yeas > proposal.nays) {
225       proposal.target.call(proposal.data);
226       emit Executed(proposalId);
227     }
228     // Even if the vote failed, we can still clean out the data
229     proposals[proposalId].data = "";
230   }
231 
232   // As the result of a vote, proposers may be authorized or deauthorized
233   function setProposer(address proposer, bool value) public {
234     require(msg.sender == address(this), "Setting a proposer requires a vote");
235     proposers[proposer] = value;
236   }
237 
238   // As the result of a vote, the duration of voting on a proposal can be
239   // changed
240   function setProposalDuration(uint value) public {
241     require(msg.sender == address(this), "Setting a duration requires a vote");
242     proposalDuration = value;
243   }
244 
245   function proposalDeadline(uint proposalId) public view returns (uint) {
246     return proposals[proposalId].deadline;
247   }
248 
249   function proposalData(uint proposalId) public view returns (bytes) {
250     return proposals[proposalId].data;
251   }
252 
253   function proposalReason(uint proposalId) public view returns (string) {
254     return proposals[proposalId].reason;
255   }
256 
257   function proposalTarget(uint proposalId) public view returns (address) {
258     return proposals[proposalId].target;
259   }
260 
261   function proposalVotes(uint proposalId) public view returns (uint[]) {
262     uint[] memory votes = new uint[](2);
263     votes[0] = proposals[proposalId].yeas;
264     votes[1] = proposals[proposalId].nays;
265     return votes;
266   }
267 }