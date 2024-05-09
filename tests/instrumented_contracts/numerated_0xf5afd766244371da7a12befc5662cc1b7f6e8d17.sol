1 pragma solidity ^0.4.0;
2 
3 contract ERC20Interface {
4   function totalSupply() public constant returns (uint);
5   function balanceOf(address tokenOwner) public constant returns (uint balance);
6   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7   function transfer(address to, uint tokens) public returns (bool success);
8   function approve(address spender, uint tokens) public returns (bool success);
9   function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11   event Transfer(address indexed from, address indexed to, uint tokens);
12   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract WorkIt is ERC20Interface {
16 
17   // non-fixed supply ERC20 implementation
18   string public constant name = "WorkIt Token";
19   string public constant symbol = "WIT";
20   uint _totalSupply = 0;
21   mapping(address => uint) balances;
22   mapping(address => mapping(address => uint)) allowances;
23 
24   function totalSupply() public constant returns (uint) {
25     return _totalSupply;
26   }
27 
28   function balanceOf(address tokenOwner) public constant returns (uint balance) {
29     return balances[tokenOwner];
30   }
31 
32   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
33     return allowances[tokenOwner][spender];
34   }
35 
36   function transfer(address to, uint tokens) public returns (bool success) {
37     require(balances[msg.sender] >= tokens);
38     balances[msg.sender] = balances[msg.sender] - tokens;
39     balances[to] = balances[to] + tokens;
40     emit Transfer(msg.sender, to, tokens);
41     return true;
42   }
43 
44   function approve(address spender, uint tokens) public returns (bool success) {
45     allowances[msg.sender][spender] = tokens;
46     emit Approval(msg.sender, spender, tokens);
47     return true;
48   }
49 
50   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
51     require(allowances[from][msg.sender] >= tokens);
52     require(balances[from] >= tokens);
53     allowances[from][msg.sender] = allowances[from][msg.sender] - tokens;
54     balances[from] = balances[from] - tokens;
55     balances[to] = balances[to] + tokens;
56     emit Transfer(from, to, tokens);
57     return true;
58   }
59 
60   // End ERC-20 implementation
61 
62   struct WeekCommittment {
63     uint daysCompleted;
64     uint daysCommitted;
65     mapping(uint => uint) workoutProofs;
66     uint tokensCommitted;
67     uint tokensEarned;
68     bool tokensPaid;
69   }
70 
71   struct WeekData {
72     bool initialized;
73     uint totalPeopleCompleted;
74     uint totalPeople;
75     uint totalDaysCommitted;
76     uint totalDaysCompleted;
77     uint totalTokensCompleted;
78     uint totalTokens;
79   }
80 
81   uint public weiPerToken = 1000000000000000; // 1000 WITs per eth
82   uint secondsPerDay = 86400;
83   uint daysPerWeek = 7;
84 
85   mapping(uint => WeekData) public dataPerWeek;
86   mapping (address => mapping(uint => WeekCommittment)) public commitments;
87 
88   mapping(uint => string) imageHashes;
89   uint imageHashCount;
90 
91   uint public startDate;
92   address public owner;
93 
94   constructor() public {
95     owner = msg.sender;
96     // Round down to the nearest day at 00:00Z (UTC -6)
97     startDate = (block.timestamp / secondsPerDay) * secondsPerDay - 60 * 6;
98   }
99 
100   event Log(string message);
101 
102   // Fallback function executed when ethereum is received with no function call
103   function () public payable {
104     buyTokens(msg.value / weiPerToken);
105   }
106 
107   // Buy tokens
108   function buyTokens(uint tokens) public payable {
109     require(msg.value >= tokens * weiPerToken);
110     balances[msg.sender] += tokens;
111     _totalSupply += tokens;
112   }
113 
114   // Commit to exercising this week
115   function commitToWeek(uint tokens, uint _days) public {
116     // Need at least 10 tokens to participate
117     if (balances[msg.sender] < tokens || tokens < 10) {
118       emit Log("You need to bet at least 10 tokens to commit");
119       require(false);
120     }
121     if (_days == 0) {
122       emit Log("You cannot register for 0 days of activity");
123       require(false);
124     }
125     if (_days > daysPerWeek) {
126       emit Log("You cannot register for more than 7 days per week");
127       require(false);
128     }
129     if (_days > daysPerWeek - currentDayOfWeek()) {
130       emit Log("It is too late in the week for you to register");
131       require(false);
132     }
133 
134     WeekCommittment storage commitment = commitments[msg.sender][currentWeek()];
135 
136     if (commitment.tokensCommitted != 0) {
137       emit Log("You have already committed to this week");
138       require(false);
139     }
140     balances[0x0] = balances[0x0] + tokens;
141     balances[msg.sender] = balances[msg.sender] - tokens;
142     emit Transfer(msg.sender, 0x0, tokens);
143 
144     initializeWeekData(currentWeek());
145     WeekData storage data = dataPerWeek[currentWeek()];
146     data.totalPeople++;
147     data.totalTokens += tokens;
148     data.totalDaysCommitted += _days;
149 
150     commitment.daysCommitted = _days;
151     commitment.daysCompleted = 0;
152     commitment.tokensCommitted = tokens;
153     commitment.tokensEarned = 0;
154     commitment.tokensPaid = false;
155   }
156 
157   // Payout your available balance based on your activity in previous weeks
158   function payout() public {
159     require(currentWeek() > 0);
160     for (uint activeWeek = currentWeek() - 1; true; activeWeek--) {
161       WeekCommittment storage committment = commitments[msg.sender][activeWeek];
162       if (committment.tokensPaid) {
163         break;
164       }
165       if (committment.daysCommitted == 0) {
166         committment.tokensPaid = true;
167         // Handle edge case and avoid -1
168         if (activeWeek == 0) break;
169         continue;
170       }
171       initializeWeekData(activeWeek);
172       WeekData storage week = dataPerWeek[activeWeek];
173       uint tokensFromPool = 0;
174       uint tokens = committment.tokensCommitted * committment.daysCompleted / committment.daysCommitted;
175       if (week.totalPeopleCompleted == 0) {
176         tokensFromPool = (week.totalTokens - week.totalTokensCompleted) / week.totalPeople;
177         tokens = 0;
178       } else if (committment.daysCompleted == committment.daysCommitted) {
179         tokensFromPool = (week.totalTokens - week.totalTokensCompleted) / week.totalPeopleCompleted;
180       }
181       uint totalTokens = tokensFromPool + tokens;
182       if (totalTokens == 0) {
183         committment.tokensPaid = true;
184         // Handle edge case and avoid -1
185         if (activeWeek == 0) break;
186         continue;
187       }
188       balances[0x0] = balances[0x0] - totalTokens;
189       balances[msg.sender] = balances[msg.sender] + totalTokens;
190       emit Transfer(0x0, msg.sender, totalTokens);
191       committment.tokensEarned = totalTokens;
192       committment.tokensPaid = true;
193 
194       // Handle edge case and avoid -1
195       if (activeWeek == 0) break;
196     }
197   }
198 
199   // Post image data to the blockchain and log completion
200   // TODO: If not committed for this week use last weeks tokens and days (if it exists)
201   function postProof(string proofHash) public {
202     WeekCommittment storage committment = commitments[msg.sender][currentWeek()];
203     if (committment.daysCompleted > currentDayOfWeek()) {
204       emit Log("You have already uploaded proof for today");
205       require(false);
206     }
207     if (committment.tokensCommitted == 0) {
208       emit Log("You have not committed to this week yet");
209       require(false);
210     }
211     if (committment.workoutProofs[currentDayOfWeek()] != 0) {
212       emit Log("Proof has already been stored for this day");
213       require(false);
214     }
215     if (committment.daysCompleted >= committment.daysCommitted) {
216       // Don't allow us to go over our committed days
217       return;
218     }
219     committment.workoutProofs[currentDayOfWeek()] = storeImageString(proofHash);
220     committment.daysCompleted++;
221 
222     initializeWeekData(currentWeek());
223     WeekData storage week = dataPerWeek[currentWeek()];
224     week.totalDaysCompleted++;
225     week.totalTokensCompleted = week.totalTokens * week.totalDaysCompleted / week.totalDaysCommitted;
226     if (committment.daysCompleted >= committment.daysCommitted) {
227       week.totalPeopleCompleted++;
228     }
229   }
230 
231   // Withdraw tokens to eth
232   function withdraw(uint tokens) public returns (bool success) {
233     require(balances[msg.sender] >= tokens);
234     uint weiToSend = tokens * weiPerToken;
235     require(address(this).balance >= weiToSend);
236     balances[msg.sender] = balances[msg.sender] - tokens;
237     _totalSupply -= tokens;
238     return msg.sender.send(tokens * weiPerToken);
239   }
240 
241   // Store an image string and get back a numerical identifier
242   function storeImageString(string hash) public returns (uint index) {
243     imageHashes[++imageHashCount] = hash;
244     return imageHashCount;
245   }
246 
247   // Initialize a week data struct
248   function initializeWeekData(uint _week) public {
249     if (dataPerWeek[_week].initialized) return;
250     WeekData storage week = dataPerWeek[_week];
251     week.initialized = true;
252     week.totalTokensCompleted = 0;
253     week.totalPeopleCompleted = 0;
254     week.totalTokens = 0;
255     week.totalPeople = 0;
256     week.totalDaysCommitted = 0;
257     week.totalDaysCompleted = 0;
258   }
259 
260   // Get the current day (from contract creation)
261   function currentDay() public view returns (uint day) {
262     return (block.timestamp - startDate) / secondsPerDay;
263   }
264 
265   // Get the current week (from contract creation)
266   function currentWeek() public view returns (uint week) {
267     return currentDay() / daysPerWeek;
268   }
269 
270   // Get current relative day of week (0-6)
271   function currentDayOfWeek() public view returns (uint dayIndex) {
272     // Uses the floor to calculate offset
273     return currentDay() - (currentWeek() * daysPerWeek);
274   }
275 }