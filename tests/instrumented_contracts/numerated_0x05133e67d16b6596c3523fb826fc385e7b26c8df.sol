1 pragma solidity ^0.4.24;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b > 0); // Solidity only automatically asserts when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b <= a);
37     uint256 c = a - b;
38 
39     return c;
40   }
41 
42   /**
43   * @dev Adds two numbers, reverts on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     require(c >= a);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54   * reverts when dividing by zero.
55   */
56   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b != 0);
58     return a % b;
59   }
60 }
61 contract Sweepstake {
62     uint constant MAX_CANDIDATES = 100;
63 
64     struct Candidate {
65         uint votes;
66         uint balance;
67         address[] entrants;
68     }
69     
70     struct Entrant {
71         uint[] candidateVotes;
72         address sender;
73         bool paid;
74     }
75 
76     address internal owner;
77     bool internal ownerCanTerminate;
78     uint internal ticketValue;
79     uint internal feePerTicket;
80     uint internal withdrawalAfterClosureWindowInDays;
81 
82     Candidate[] internal candidates;
83     mapping(address => Entrant) internal entrants;
84     uint internal totalVotes;
85     uint internal totalBalance;
86 
87     bool internal closed;
88     uint internal closedTime;
89 
90     uint internal winningCandidateIndex;
91     uint internal winningVotes;
92     uint internal winningsPerVote;
93 
94     modifier onlyOwner { 
95         require (msg.sender == owner, 'Must be owner');
96         _; 
97     }
98              
99     modifier onlyWhenOpen { 
100         require (closed == false, 'Cannot execute whilst open');
101         _; 
102     }
103             
104     modifier onlyWhenClosed { 
105         require (closed == true, 'Cannot execute whilst closed');
106         _; 
107     }
108 
109     modifier onlyWithValidCandidate(uint candidateIndex) { 
110         require (candidateIndex >= 0, 'Index must be valid');
111         require (candidateIndex < candidates.length, 'Index must be valid');
112         _; 
113     }
114                 
115     constructor(
116         uint _ticketValue,
117         uint _feePerTicket,
118         uint candidateCount,
119         uint _withdrawalAfterClosureWindowInDays
120     ) public {
121         require (candidateCount > 0, 'Candidate count must be more than 1');
122         require (candidateCount <= MAX_CANDIDATES, 'Candidate count must be less than max');
123 
124         owner = msg.sender;
125         ownerCanTerminate = true;
126         ticketValue = _ticketValue;
127         feePerTicket = _feePerTicket;
128         withdrawalAfterClosureWindowInDays = _withdrawalAfterClosureWindowInDays;
129 
130         for (uint index = 0; index < candidateCount; index++) {
131             candidates.push(Candidate({
132                 votes: 0,
133                 balance: 0,
134                 entrants: new address[](0)
135             }));
136         }
137     }
138 
139     function getOwner() external view returns (address) {
140         return owner;
141     }
142 
143     function getOwnerCanTerminate() external view returns (bool) {
144         return ownerCanTerminate;
145     }
146 
147     function getClosed() external view returns (bool) {
148         return closed;
149     }
150 
151     function getClosedTime() external view returns (uint) {
152         return closedTime;
153     }
154 
155     function getWithdrawalAfterClosureWindowInDays() external view returns (uint) {
156         return withdrawalAfterClosureWindowInDays;
157     }
158 
159     function getFeePerTicket() external view returns (uint) {
160         return feePerTicket;
161     }
162 
163     function getTicketValue() external view returns (uint) {
164         return ticketValue;
165     }
166 
167     function getAllCandidateBalances() external view returns (uint[]) {
168         uint candidateLength = candidates.length;
169         uint[] memory balances = new uint[](candidateLength);
170         
171         for (uint index = 0; index < candidateLength; index++) {
172             balances[index] = candidates[index].balance;
173         }
174 
175         return balances;
176     }
177 
178     function getAllCandidateVotes() external view returns (uint[]) {
179         uint candidateLength = candidates.length;
180         uint[] memory votes = new uint[](candidateLength);
181         
182         for (uint index = 0; index < candidateLength; index++) {
183             votes[index] = candidates[index].votes;
184         }
185 
186         return votes;
187     }
188 
189     function getCandidateEntrants(uint candidateIndex) external view onlyWithValidCandidate(candidateIndex) returns (address[]) {
190         return candidates[candidateIndex].entrants;
191     }
192 
193     function getTotalVotes() external view returns (uint) {
194         return totalVotes;
195     }
196 
197     function getTotalBalance() external view returns (uint) {
198         return totalBalance;
199     }
200 
201     function getWinningCandidateIndex() external view onlyWhenClosed returns (uint) {
202         return winningCandidateIndex;
203     }
204 
205     function getWinningVotes() external view onlyWhenClosed returns (uint) {
206         return winningVotes;
207     }
208 
209     function getWinningsPerVote() external view onlyWhenClosed returns (uint) {
210         return winningsPerVote;
211     }
212 
213     function hasCurrentUserEntered() external view returns (bool) {
214         return entrants[msg.sender].sender != 0x0;
215     }
216 
217     function getCurrentEntrantVotes() external view returns (uint[]) {
218         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
219 
220         return entrants[msg.sender].candidateVotes;
221     }
222 
223     function getCurrentEntrantPaidState() external view returns (bool) {
224         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
225 
226         return entrants[msg.sender].paid;
227     }
228 
229     function getCurrentEntrantWinnings() external view onlyWhenClosed returns (uint) {
230         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
231         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
232 
233         return SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
234     }
235 
236     function enter(uint candidateIndex) external payable onlyWhenOpen onlyWithValidCandidate(candidateIndex) {
237         require (msg.value == ticketValue, 'Ticket value is incorrect');
238 
239         if (entrants[msg.sender].sender == 0x0) {
240             entrants[msg.sender] = Entrant({
241                 candidateVotes: new uint[](candidates.length),
242                 sender: msg.sender,
243                 paid: false
244             });
245 
246             candidates[candidateIndex].entrants.push(msg.sender);
247         }
248 
249         entrants[msg.sender].candidateVotes[candidateIndex]++;
250 
251         totalVotes++;
252         candidates[candidateIndex].votes++;
253         
254         uint valueAfterFee = SafeMath.sub(msg.value, feePerTicket);
255         candidates[candidateIndex].balance = SafeMath.add(candidates[candidateIndex].balance, valueAfterFee);
256 
257         totalBalance = SafeMath.add(totalBalance, valueAfterFee);
258 
259         owner.transfer(feePerTicket);
260     }
261 
262     function close(uint _winningCandidateIndex) external onlyOwner onlyWhenOpen onlyWithValidCandidate(_winningCandidateIndex) {
263         closed = true;
264         closedTime = now;
265 
266         winningCandidateIndex = _winningCandidateIndex;
267 
268         uint balance = address(this).balance;
269         winningVotes = candidates[winningCandidateIndex].votes;
270         if (winningVotes > 0) {    
271             winningsPerVote = SafeMath.div(balance, winningVotes);
272             uint totalWinnings = SafeMath.mul(winningsPerVote, winningVotes);
273 
274             if (totalWinnings < balance) {
275                 owner.transfer(SafeMath.sub(balance, totalWinnings));
276             }
277         } else {
278             owner.transfer(balance);
279         }
280     }
281 
282     function withdraw() external onlyWhenClosed {
283         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
284         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
285         require (entrants[msg.sender].paid == false, 'User has already been paid');
286         require (now < (closedTime + (withdrawalAfterClosureWindowInDays * 1 days)));
287         
288         entrants[msg.sender].paid = true;
289 
290         uint totalWinnings = SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
291 
292         msg.sender.transfer(totalWinnings);
293     }
294 
295     function preventOwnerTerminating() external onlyOwner {
296         ownerCanTerminate = false;
297     }
298 
299     function terminate() external onlyOwner {
300         require (ownerCanTerminate == true, 'Owner cannot terminate');
301 
302         selfdestruct(owner);
303     }
304 }