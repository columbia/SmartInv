1 pragma solidity ^0.4.24;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: contracts/Sweepstake.sol
70 
71 contract Sweepstake {
72     uint constant MAX_CANDIDATES = 100;
73 
74     struct Candidate {
75         uint votes;
76         uint balance;
77         address[] entrants;
78     }
79     
80     struct Entrant {
81         uint[] candidateVotes;
82         address sender;
83         bool paid;
84     }
85 
86     address internal owner;
87     bool internal ownerCanTerminateEarly;
88     uint internal ticketValue;
89     uint internal feePerTicket;
90     uint internal withdrawalAfterClosureWindowInSeconds;
91 
92     Candidate[] internal candidates;
93     mapping(address => Entrant) internal entrants;
94     uint internal totalVotes;
95     uint internal totalBalance;
96 
97     bool internal closed;
98     uint internal closedTime;
99 
100     uint internal winningCandidateIndex;
101     uint internal winningVotes;
102     uint internal winningsPerVote;
103 
104     modifier onlyOwner { 
105         require (msg.sender == owner, 'Must be owner');
106         _; 
107     }
108              
109     modifier onlyWhenOpen { 
110         require (closed == false, 'Cannot execute whilst open');
111         _; 
112     }
113             
114     modifier onlyWhenClosed { 
115         require (closed == true, 'Cannot execute whilst closed');
116         _; 
117     }
118 
119     modifier onlyWithValidCandidate(uint candidateIndex) { 
120         require (candidateIndex >= 0, 'Index must be valid');
121         require (candidateIndex < candidates.length, 'Index must be valid');
122         _; 
123     }
124                 
125     constructor(
126         uint _ticketValue,
127         uint _feePerTicket,
128         uint candidateCount,
129         uint _withdrawalAfterClosureWindowInSeconds
130     ) public {
131         require (candidateCount > 0, 'Candidate count must be more than 1');
132         require (candidateCount <= MAX_CANDIDATES, 'Candidate count must be less than max');
133 
134         owner = msg.sender;
135         ownerCanTerminateEarly = true;
136         ticketValue = _ticketValue;
137         feePerTicket = _feePerTicket;
138         withdrawalAfterClosureWindowInSeconds = _withdrawalAfterClosureWindowInSeconds;
139 
140         for (uint index = 0; index < candidateCount; index++) {
141             candidates.push(Candidate({
142                 votes: 0,
143                 balance: 0,
144                 entrants: new address[](0)
145             }));
146         }
147     }
148 
149     function getOwner() external view returns (address) {
150         return owner;
151     }
152 
153     function getOwnerCanTerminateEarly() external view returns (bool) {
154         return ownerCanTerminateEarly;
155     }
156 
157     function getClosed() external view returns (bool) {
158         return closed;
159     }
160 
161     function getClosedTime() external view returns (uint) {
162         return closedTime;
163     }
164 
165     function getWithdrawalAfterClosureWindowInSeconds() external view returns (uint) {
166         return withdrawalAfterClosureWindowInSeconds;
167     }
168 
169     function getNow() external view returns (uint) {
170         return now;
171     }
172 
173     function getFeePerTicket() external view returns (uint) {
174         return feePerTicket;
175     }
176 
177     function getTicketValue() external view returns (uint) {
178         return ticketValue;
179     }
180 
181     function getAllCandidateBalances() external view returns (uint[]) {
182         uint candidateLength = candidates.length;
183         uint[] memory balances = new uint[](candidateLength);
184         
185         for (uint index = 0; index < candidateLength; index++) {
186             balances[index] = candidates[index].balance;
187         }
188 
189         return balances;
190     }
191 
192     function getAllCandidateVotes() external view returns (uint[]) {
193         uint candidateLength = candidates.length;
194         uint[] memory votes = new uint[](candidateLength);
195         
196         for (uint index = 0; index < candidateLength; index++) {
197             votes[index] = candidates[index].votes;
198         }
199 
200         return votes;
201     }
202 
203     function getCandidateEntrants(uint candidateIndex) external view onlyWithValidCandidate(candidateIndex) returns (address[]) {
204         return candidates[candidateIndex].entrants;
205     }
206 
207     function getTotalVotes() external view returns (uint) {
208         return totalVotes;
209     }
210 
211     function getTotalBalance() external view returns (uint) {
212         return totalBalance;
213     }
214 
215     function getWinningCandidateIndex() external view onlyWhenClosed returns (uint) {
216         return winningCandidateIndex;
217     }
218 
219     function getWinningVotes() external view onlyWhenClosed returns (uint) {
220         return winningVotes;
221     }
222 
223     function getWinningsPerVote() external view onlyWhenClosed returns (uint) {
224         return winningsPerVote;
225     }
226 
227     function hasCurrentUserEntered() external view returns (bool) {
228         return entrants[msg.sender].sender != 0x0;
229     }
230 
231     function getCurrentEntrantVotes() external view returns (uint[]) {
232         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
233 
234         return entrants[msg.sender].candidateVotes;
235     }
236 
237     function getCurrentEntrantPaidState() external view returns (bool) {
238         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
239 
240         return entrants[msg.sender].paid;
241     }
242 
243     function getCurrentEntrantWinnings() external view onlyWhenClosed returns (uint) {
244         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
245         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
246 
247         return SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
248     }
249 
250     function enter(uint candidateIndex) external payable onlyWhenOpen onlyWithValidCandidate(candidateIndex) {
251         require (msg.value == ticketValue, 'Ticket value is incorrect');
252 
253         if (entrants[msg.sender].sender == 0x0) {
254             entrants[msg.sender] = Entrant({
255                 candidateVotes: new uint[](candidates.length),
256                 sender: msg.sender,
257                 paid: false
258             });
259 
260             candidates[candidateIndex].entrants.push(msg.sender);
261         }
262 
263         entrants[msg.sender].candidateVotes[candidateIndex]++;
264 
265         totalVotes++;
266         candidates[candidateIndex].votes++;
267         
268         uint valueAfterFee = SafeMath.sub(msg.value, feePerTicket);
269         candidates[candidateIndex].balance = SafeMath.add(candidates[candidateIndex].balance, valueAfterFee);
270 
271         totalBalance = SafeMath.add(totalBalance, valueAfterFee);
272 
273         owner.transfer(feePerTicket);
274     }
275 
276     function close(uint _winningCandidateIndex) external onlyOwner onlyWhenOpen onlyWithValidCandidate(_winningCandidateIndex) {
277         closed = true;
278         closedTime = now;
279 
280         winningCandidateIndex = _winningCandidateIndex;
281 
282         uint balance = address(this).balance;
283         winningVotes = candidates[winningCandidateIndex].votes;
284         if (winningVotes > 0) {    
285             winningsPerVote = SafeMath.div(balance, winningVotes);
286             uint totalWinnings = SafeMath.mul(winningsPerVote, winningVotes);
287 
288             if (totalWinnings < balance) {
289                 owner.transfer(SafeMath.sub(balance, totalWinnings));
290             }
291         } else {
292             owner.transfer(balance);
293         }
294     }
295 
296     function withdraw() external onlyWhenClosed {
297         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
298         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
299         require (entrants[msg.sender].paid == false, 'User has already been paid');
300         require (now < SafeMath.add(closedTime, withdrawalAfterClosureWindowInSeconds));
301         
302         entrants[msg.sender].paid = true;
303 
304         uint totalWinnings = SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
305 
306         msg.sender.transfer(totalWinnings);
307     }
308 
309     function preventOwnerTerminatingEarly() external onlyOwner {
310         ownerCanTerminateEarly = false;
311     }
312 
313     function terminate() external onlyOwner {
314         if (ownerCanTerminateEarly == false) {
315             if (closed == false) {
316                 revert('Owner cannot terminate while a round is open');
317             }
318 
319             if (now < SafeMath.add(closedTime, withdrawalAfterClosureWindowInSeconds)) {
320                 revert('Owner cannot terminate until withdrawal window has passed');
321             }
322         }
323 
324         selfdestruct(owner);
325     }
326 }