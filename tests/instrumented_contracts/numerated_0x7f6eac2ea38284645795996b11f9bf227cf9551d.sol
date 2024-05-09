1 pragma solidity ^0.4.19;
2 
3 /* TODO: Add reporting mechanism to punish revealing votes off-chain either on purpose or by using weak salt for computing vote commit hash */
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) public constant returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) public constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 }
41 
42 
43 contract CryptoTask is Ownable {
44    
45     uint MAX_UINT32 = 4294967295;
46     uint public MIN_TASK_VALUE = 200000000000000000000;
47     uint public CLIENT_TIME_TO_DECIDE = 3 days;
48     uint public VOTING_PERIOD = 5 days;
49     /*uint public MIN_TASK_VALUE = 2000000000000000000;
50     uint public CLIENT_TIME_TO_DECIDE = 15 minutes;
51     uint public VOTING_PERIOD = 15 minutes;*/
52     
53     struct Task {
54         address client;
55         address fl;
56         uint taskValue;
57         uint workTime;
58         uint applyTime;
59         uint solutionSubmittedTime;
60         uint disputeStartedTime;
61         bytes32 blockHash;
62         mapping(address => bytes32) voteCommits;
63         mapping(uint32 => uint32) votes;
64         mapping(uint32 => address) voters;
65         uint32 votesTotal;
66         uint32 votesClient;
67         uint32 votesFl;        
68         uint32 stage;
69         uint prev;
70         uint next;
71     }
72     //due to stack depth error not everything could be fitted to the struct
73     mapping(uint => string) public titles;
74     mapping(uint => string) public descriptions;
75     mapping(uint => string) public solutions;
76     mapping(uint => uint) public disputeBlockNos;
77     
78     
79     ERC20 public tokenContract = ERC20(0x4545750F39aF6Be4F237B6869D4EccA928Fd5A85);
80     
81     //owner can prevent new task submissions if platform is to be moved to a new contract
82     //apart from this and airdrops, owner has no other privileges
83     bool public migrating;
84     mapping(address => uint32) public ADs;
85     
86     mapping(uint => Task) public tasks;
87     uint public tasksSize;
88     uint public lastTaskIndex;
89     mapping(address => uint) public stakes;
90     mapping(address => uint) public lastStakings;
91     uint public totalStake;
92     
93     
94     function setMigrating(bool willMigrate) onlyOwner {
95         migrating = willMigrate;
96     }
97     
98     function setMinTaskValue(uint minTaskValue) onlyOwner {
99         MIN_TASK_VALUE = minTaskValue;
100     }
101     
102     function postTask(string title, string description, uint taskValue, uint workTime) {
103         require(!migrating && taskValue > MIN_TASK_VALUE);
104         
105         tasksSize++;
106         
107         tasks[tasksSize].client = msg.sender;
108         titles[tasksSize] = title;
109         tasks[tasksSize].workTime = workTime;
110         tasks[tasksSize].taskValue = taskValue;
111         descriptions[tasksSize] = description;
112         
113         //linked list connecting
114         tasks[tasksSize].prev = lastTaskIndex;
115         if(lastTaskIndex > 0) {
116             tasks[lastTaskIndex].next = tasksSize;
117         }
118         lastTaskIndex = tasksSize;
119         
120         tokenContract.transferFrom(msg.sender, this, taskValue + taskValue/10);
121     }
122     
123     function applyForTask(uint taskID) {
124         require(tasks[taskID].stage == 0 && tasks[taskID].client != address(0));
125         tasks[taskID].fl = msg.sender;
126         tasks[taskID].applyTime = now;
127         tasks[taskID].stage = 1;
128         tokenContract.transferFrom(msg.sender, this, tasks[taskID].taskValue/10);
129     }
130     
131     function submitSolution(uint taskID, string solution) {
132         require(tasks[taskID].stage == 1 && msg.sender == tasks[taskID].fl && now < tasks[taskID].applyTime + tasks[taskID].workTime);
133         solutions[taskID] = solution;
134         tasks[taskID].solutionSubmittedTime = now;
135         tasks[taskID].stage = 2;
136     }
137     
138     function startDispute(uint taskID) {
139         require(tasks[taskID].stage == 2 && tasks[taskID].client == msg.sender && now < tasks[taskID].solutionSubmittedTime + CLIENT_TIME_TO_DECIDE);
140         disputeBlockNos[taskID] = block.number;
141         tasks[taskID].stage = 3;
142     }
143     
144     //commitDispute and startDispute need to be separate stages to ensure blockHash randomness
145     function commitDispute(uint taskID) {
146         require(tasks[taskID].stage == 3 && tasks[taskID].client == msg.sender && now < tasks[taskID].solutionSubmittedTime + CLIENT_TIME_TO_DECIDE && block.number > disputeBlockNos[taskID]+5);
147         tasks[taskID].blockHash = block.blockhash(disputeBlockNos[taskID]);
148         tasks[taskID].disputeStartedTime = now;
149         tasks[taskID].stage = 4;
150     }
151     
152     function commitVote(uint taskID, bytes32 voteHash) {
153         require(tasks[taskID].stage == 4 && now < tasks[taskID].disputeStartedTime + VOTING_PERIOD && tasks[taskID].voteCommits[msg.sender] == bytes32(0));
154         tasks[taskID].voteCommits[msg.sender] = voteHash;
155     }
156     
157     function revealVote(uint taskID, uint8 v, bytes32 r, bytes32 s, uint32 vote, bytes32 salt) {
158         //100 sec buffer between commit and reveal vote stages
159         require(tasks[taskID].stage == 4 && now > tasks[taskID].disputeStartedTime + VOTING_PERIOD+100 && now < tasks[taskID].disputeStartedTime + 2*VOTING_PERIOD && tasks[taskID].voteCommits[msg.sender] != bytes32(0));
160         //check that revealed signature matches public key, that stake is high enough (selection likelihood proportional to stake), that tokens haven't been moved around since dispute started to prevent biasing the selection likelihood, that revealed vote matches the vote commit
161         if(ecrecover(keccak256(taskID, tasks[taskID].blockHash), v, r, s) == msg.sender && (10*MAX_UINT32)/(uint(s) % (MAX_UINT32+1)) > totalStake/stakes[msg.sender] && lastStakings[msg.sender] < tasks[taskID].disputeStartedTime && keccak256(salt, vote) == tasks[taskID].voteCommits[msg.sender]) {
162             if(vote==1) {
163                 tasks[taskID].votesClient++;
164             } else if(vote==2) {
165                 tasks[taskID].votesFl++;
166             } else {
167                 throw;
168             }
169             tasks[taskID].votes[tasks[taskID].votesTotal] = vote;
170             tasks[taskID].voters[tasks[taskID].votesTotal] = msg.sender;
171             tasks[taskID].votesTotal++;
172             //prevent multiple revealing of same vote
173             tasks[taskID].voteCommits[msg.sender] = bytes32(0);
174         }
175     }
176     
177     function finalizeTask(uint taskID) {
178         uint taskValueTenth = tasks[taskID].taskValue/10;
179         uint reviewerReward;
180         uint32 i;
181         
182         //cancel posted task no has applied for yet
183         if(tasks[taskID].stage == 0 && msg.sender == tasks[taskID].client) {
184             tokenContract.transfer(tasks[taskID].client, tasks[taskID].taskValue + taskValueTenth);
185             tasks[taskID].stage = 5;
186         }
187         //accept freelancer's solution
188         else if(tasks[taskID].stage == 2 && msg.sender == tasks[taskID].client) {
189             tokenContract.transfer(tasks[taskID].fl, tasks[taskID].taskValue + taskValueTenth);
190             tokenContract.transfer(tasks[taskID].client, taskValueTenth);
191             tasks[taskID].stage = 6;
192         }
193         //client didn't review freelancer's solution on time, treated as solution accepted
194         else if((tasks[taskID].stage == 2 || tasks[taskID].stage == 3) && now > tasks[taskID].solutionSubmittedTime + CLIENT_TIME_TO_DECIDE) {
195             tokenContract.transfer(tasks[taskID].fl, tasks[taskID].taskValue + 2*taskValueTenth);
196             tasks[taskID].stage = 7;
197         }
198         //dispute was started and reviewers voted in freelancer's favour
199         else if(tasks[taskID].stage == 4 && tasks[taskID].votesFl > tasks[taskID].votesClient && now > tasks[taskID].disputeStartedTime + 2*VOTING_PERIOD) {
200             tokenContract.transfer(tasks[taskID].fl, tasks[taskID].taskValue + taskValueTenth);
201             reviewerReward = taskValueTenth / tasks[taskID].votesFl;
202             //distribute reviewer rewards
203             for(i=0; i < tasks[taskID].votesTotal; i++) {
204                 if(tasks[taskID].votes[i] == 2) {
205                     tokenContract.transfer(tasks[taskID].voters[i], reviewerReward);
206                 }
207             }
208             tasks[taskID].stage = 8;
209         }
210         //freelancer didn't submit solution on time, client gets freelancer's escrow
211         else if(tasks[taskID].stage == 1 && now > tasks[taskID].applyTime + tasks[taskID].workTime) {
212             tokenContract.transfer(tasks[taskID].client, tasks[taskID].taskValue + 2*taskValueTenth);
213             tasks[taskID].stage = 9;
214         }
215         //dispute was started and reviewers voted in client's favour
216         else if(tasks[taskID].stage == 4 && tasks[taskID].votesClient >= tasks[taskID].votesFl && now > tasks[taskID].disputeStartedTime + 2*VOTING_PERIOD) {
217             if(tasks[taskID].votesTotal == 0) {
218                 tokenContract.transfer(tasks[taskID].client, tasks[taskID].taskValue + taskValueTenth);
219                 tokenContract.transfer(tasks[taskID].fl, taskValueTenth);
220             } else {
221                 tokenContract.transfer(tasks[taskID].client, tasks[taskID].taskValue + taskValueTenth);
222                 reviewerReward = taskValueTenth / tasks[taskID].votesClient;
223                 //distribute reviewer rewards
224                 for(i=0; i < tasks[taskID].votesTotal; i++) {
225                     if(tasks[taskID].votes[i] == 1) {
226                         tokenContract.transfer(tasks[taskID].voters[i], reviewerReward);
227                     }
228                 }
229             }
230             tasks[taskID].stage = 10;
231         } else {
232             throw;
233         }
234         
235         //connect linked list after the task removal
236         if(tasks[taskID].prev > 0) {
237             tasks[tasks[taskID].prev].next = tasks[taskID].next;
238         }
239         if(tasks[taskID].next > 0) {
240             tasks[tasks[taskID].next].prev = tasks[taskID].prev;
241         }
242         if(taskID == lastTaskIndex) {
243             lastTaskIndex = tasks[taskID].prev;
244         }
245         
246         //if users who received airdrops
247         if(ADs[tasks[taskID].client] > 0) {
248             ADs[tasks[taskID].client]++;
249         }
250         if(ADs[tasks[taskID].fl] > 0) {
251             ADs[tasks[taskID].fl]++;
252         }
253     }
254     
255     
256     function addStake(uint value) {
257         if(value > 0) {
258             stakes[msg.sender] += value;
259             lastStakings[msg.sender] = now;
260             totalStake += value;
261             tokenContract.transferFrom(msg.sender, this, value);
262         }
263     }
264     
265     function withdrawStake(uint value) {
266         if(value > 0 && stakes[msg.sender] >= value) {
267             //received airdrop but completed less than 10 tasks
268             if(ADs[msg.sender] > 0 && ADs[msg.sender] < 10) {
269                 throw;
270             }
271             stakes[msg.sender] -= value;
272             lastStakings[msg.sender] = now;
273             totalStake -= value;
274             tokenContract.transfer(msg.sender, value);
275         }
276     }
277     
278     //airdrop
279     function addStakeAD(uint value, address recipient) onlyOwner {
280         //prevent owner from adding a small value to set regular user to airdropped user
281         if(value > 0 && value > 1000*stakes[recipient]) {
282             stakes[recipient] += value;
283             lastStakings[recipient] = now;
284             totalStake += value;
285             ADs[recipient]++;
286             tokenContract.transferFrom(msg.sender, this, value);
287         }
288     }
289     
290     
291     function getVoteCommit(uint taskID, address commiter) constant returns (bytes32 commit) {
292         return tasks[taskID].voteCommits[commiter];
293     }
294     
295     function getVote(uint taskID, uint32 index) constant returns (uint32 vote) {
296         return tasks[taskID].votes[index];
297     }
298     
299     function getVoter(uint taskID, uint32 index) constant returns (address voter) {
300         return tasks[taskID].voters[index];
301     }
302     
303 }