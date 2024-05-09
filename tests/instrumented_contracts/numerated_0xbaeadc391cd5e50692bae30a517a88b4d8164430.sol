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
87     bool internal ownerCanTerminate;
88     uint internal ticketValue;
89     uint internal feePerTicket;
90 
91     Candidate[] internal candidates;
92     mapping(address => Entrant) internal entrants;
93     uint internal totalVotes;
94     uint internal totalBalance;
95 
96     bool internal closed;
97     uint internal winningCandidateIndex;
98     uint internal winningVotes;
99     uint internal winningsPerVote;
100 
101     modifier onlyOwner { 
102         require (msg.sender == owner, 'Must be owner');
103         _; 
104     }
105              
106     modifier onlyWhenOpen { 
107         require (closed == false, 'Cannot execute whilst open');
108         _; 
109     }
110             
111     modifier onlyWhenClosed { 
112         require (closed == true, 'Cannot execute whilst closed');
113         _; 
114     }
115 
116     modifier onlyWithValidCandidate(uint candidateIndex) { 
117         require (candidateIndex >= 0, 'Index must be valid');
118         require (candidateIndex < candidates.length, 'Index must be valid');
119         _; 
120     }
121                 
122     constructor(uint _ticketValue, uint _feePerTicket, uint candidateCount) public {
123         require (candidateCount > 0, 'Candidate count must be more than 1');
124         require (candidateCount <= MAX_CANDIDATES, 'Candidate count must be less than max');
125 
126         owner = msg.sender;
127         ownerCanTerminate = true;
128         ticketValue = _ticketValue;
129         feePerTicket = _feePerTicket;
130 
131         for (uint index = 0; index < candidateCount; index++) {
132             candidates.push(Candidate({
133                 votes: 0,
134                 balance: 0,
135                 entrants: new address[](0)
136             }));
137         }
138     }
139 
140     function getOwner() external view returns (address) {
141         return owner;
142     }
143 
144     function getOwnerCanTerminate() external view returns (bool) {
145         return ownerCanTerminate;
146     }
147 
148     function getClosed() external view returns (bool) {
149         return closed;
150     }
151 
152     function getFeePerTicket() external view returns (uint) {
153         return feePerTicket;
154     }
155 
156     function getTicketValue() external view returns (uint) {
157         return ticketValue;
158     }
159 
160     function getAllCandidateBalances() external view returns (uint[]) {
161         uint candidateLength = candidates.length;
162         uint[] memory balances = new uint[](candidateLength);
163         
164         for (uint index = 0; index < candidateLength; index++) {
165             balances[index] = candidates[index].balance;
166         }
167 
168         return balances;
169     }
170 
171     function getAllCandidateVotes() external view returns (uint[]) {
172         uint candidateLength = candidates.length;
173         uint[] memory votes = new uint[](candidateLength);
174         
175         for (uint index = 0; index < candidateLength; index++) {
176             votes[index] = candidates[index].votes;
177         }
178 
179         return votes;
180     }
181 
182     function getCandidateEntrants(uint candidateIndex) external view onlyWithValidCandidate(candidateIndex) returns (address[]) {
183         return candidates[candidateIndex].entrants;
184     }
185 
186     function getTotalVotes() external view returns (uint) {
187         return totalVotes;
188     }
189 
190     function getTotalBalance() external view returns (uint) {
191         return totalBalance;
192     }
193 
194     function getWinningCandidateIndex() external view onlyWhenClosed returns (uint) {
195         return winningCandidateIndex;
196     }
197 
198     function getWinningVotes() external view onlyWhenClosed returns (uint) {
199         return winningVotes;
200     }
201 
202     function getWinningsPerVote() external view onlyWhenClosed returns (uint) {
203         return winningsPerVote;
204     }
205 
206     function hasCurrentUserEntered() external view returns (bool) {
207         return entrants[msg.sender].sender != 0x0;
208     }
209 
210     function getCurrentEntrantVotes() external view returns (uint[]) {
211         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
212 
213         return entrants[msg.sender].candidateVotes;
214     }
215 
216     function getCurrentEntrantPaidState() external view returns (bool) {
217         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
218 
219         return entrants[msg.sender].paid;
220     }
221 
222     function getCurrentEntrantWinnings() external view onlyWhenClosed returns (uint) {
223         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
224         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
225 
226         return SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
227     }
228 
229     function enter(uint candidateIndex) external payable onlyWhenOpen onlyWithValidCandidate(candidateIndex) {
230         require (msg.value == ticketValue, 'Ticket value is incorrect');
231 
232         if (entrants[msg.sender].sender == 0x0) {
233             entrants[msg.sender] = Entrant({
234                 candidateVotes: new uint[](candidates.length),
235                 sender: msg.sender,
236                 paid: false
237             });
238 
239             candidates[candidateIndex].entrants.push(msg.sender);
240         }
241 
242         entrants[msg.sender].candidateVotes[candidateIndex]++;
243 
244         totalVotes++;
245         candidates[candidateIndex].votes++;
246         
247         uint valueAfterFee = SafeMath.sub(msg.value, feePerTicket);
248         candidates[candidateIndex].balance = SafeMath.add(candidates[candidateIndex].balance, valueAfterFee);
249 
250         totalBalance = SafeMath.add(totalBalance, valueAfterFee);
251 
252         owner.transfer(feePerTicket);
253     }
254 
255     function close(uint _winningCandidateIndex) external onlyOwner onlyWhenOpen onlyWithValidCandidate(_winningCandidateIndex) {
256         closed = true;
257 
258         winningCandidateIndex = _winningCandidateIndex;
259 
260         uint balance = address(this).balance;
261         winningVotes = candidates[winningCandidateIndex].votes;
262         if (winningVotes > 0) {    
263             winningsPerVote = SafeMath.div(balance, winningVotes);
264             uint totalWinnings = SafeMath.mul(winningsPerVote, winningVotes);
265 
266             if (totalWinnings < balance) {
267                 owner.transfer(SafeMath.sub(balance, totalWinnings));
268             }
269         } else {
270             owner.transfer(balance);
271         }
272     }
273 
274     function withdraw() external onlyWhenClosed {
275         require (entrants[msg.sender].sender != 0x0, 'Current user has not entered');
276         require (entrants[msg.sender].candidateVotes[winningCandidateIndex] > 0, 'Current user did not vote for the winner');
277         require (entrants[msg.sender].paid == false, 'User has already been paid');
278 
279         entrants[msg.sender].paid = true;
280 
281         uint totalWinnings = SafeMath.mul(winningsPerVote, entrants[msg.sender].candidateVotes[winningCandidateIndex]);
282 
283         msg.sender.transfer(totalWinnings);
284     }
285 
286     function preventOwnerTerminating() external onlyOwner {
287         ownerCanTerminate = false;
288     }
289 
290     function terminate() external onlyOwner {
291         require (ownerCanTerminate == true, 'Owner cannot terminate');
292 
293         selfdestruct(owner);
294     }
295 }