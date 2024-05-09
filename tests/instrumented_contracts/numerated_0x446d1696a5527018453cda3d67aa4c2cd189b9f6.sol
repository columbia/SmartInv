1 contract GreedPit {
2     
3     address private owner;
4     
5     //Stored variables
6     uint private balance = 0;
7     uint private uniqueUsers = 0;
8     uint private usersProfits = 0;
9     uint private rescues = 0;
10     uint private collectedFees = 0;
11     uint private jumpFee = 10;
12     uint private baseMultiplier = 110;
13     uint private maxMultiplier = 200;
14     uint private payoutOrder = 0;
15     uint private rescueRecord = 0;
16     uint timeOfLastDeposit = now;
17     address private hero = 0x0;
18     
19     mapping (address => User) private users;
20     Entry[] private entries;
21     
22     event Jump(address who, uint deposit, uint payout);
23     event Rescue(address who, address saviour, uint payout);
24     event NewHero(address who);
25     
26     //Set owner on contract creation
27     function GreedPit() {
28         owner = msg.sender;
29     }
30 
31     modifier onlyowner { if (msg.sender == owner) _ }
32     
33     struct User {
34         uint id;
35         address addr;
36         string nickname;
37         uint rescueCount;
38         uint rescueTokens;
39     }
40     
41     struct Entry {
42         address entryAddress;
43         uint deposit;
44         uint payout;
45         uint tokens;
46     }
47 
48     //Fallback function
49     function() {
50         init();
51     }
52     
53     function init() private{
54         //Only deposits >0.1ETH are allowed to join
55         if (msg.value < 100 finney) {
56             return;
57         }
58         
59         jumpIn();
60         
61         //Prevent cheap trolls from reviving the pit if it dies (death = ~3months without deposits)
62         if (msg.value > 5)
63             timeOfLastDeposit = now;
64     }
65     
66     //Join the pit
67     function jumpIn() private {
68         
69         //Limit deposits to 50ETH
70 		uint dValue = 100 finney;
71 		if (msg.value > 50 ether) {
72 		    //Make sure we receied the money before refunding the surplus
73 		    if (this.balance >= balance + collectedFees + msg.value)
74 			    msg.sender.send(msg.value - 50 ether);	
75 			dValue = 50 ether;
76 		}
77 		else { dValue = msg.value; }
78 
79         //Add new users to the users array if he's a new player
80         addNewUser(msg.sender);
81         
82         //Make sure that only up to 5 rescue tokens are spent at a time
83         uint tokensToUse = users[msg.sender].rescueTokens >= 5 ? 5 : users[msg.sender].rescueTokens;
84         uint tokensUsed = 0;
85         
86         //Enforce lower payouts if too many people stuck in the pit
87         uint randMultiplier = rand(50);
88         uint currentEntries = entries.length - payoutOrder;
89         randMultiplier = currentEntries > 15 ? (randMultiplier / 2) : randMultiplier;
90         randMultiplier = currentEntries > 25 ? 0 : randMultiplier;
91         //Incentive to join if the pit is nearly empty (+50% random multiplier)
92         randMultiplier = currentEntries <= 5 && dValue <= 20 ? randMultiplier * 3 / 2 : randMultiplier;
93         
94         //Calculate the optimal amount of rescue tokens to spend
95         while (tokensToUse > 0 && (baseMultiplier + randMultiplier + tokensUsed*10) < maxMultiplier)
96         {
97             tokensToUse--;
98             tokensUsed++;
99         }
100         
101         uint finalMultiplier = (baseMultiplier + randMultiplier + tokensUsed*10);
102         
103         if (finalMultiplier > maxMultiplier)
104             finalMultiplier = maxMultiplier;
105             
106         //Add new entry to the entries array    
107         if (msg.value < 50 ether)
108             entries.push(Entry(msg.sender, msg.value, (msg.value * (finalMultiplier) / 100), tokensUsed));
109         else
110             entries.push(Entry(msg.sender, 50 ether,((50 ether) * (finalMultiplier) / 100), tokensUsed));
111 
112         //Trigger jump event
113         if (msg.value < 50 ether)
114             Jump(msg.sender, msg.value, (msg.value * (finalMultiplier) / 100));
115         else
116             Jump(msg.sender, 50 ether, ((50 ether) * (finalMultiplier) / 100));
117 
118         users[msg.sender].rescueTokens -= tokensUsed;
119         
120         //Collect fees and update contract balance
121         balance += (dValue * (100 - jumpFee)) / 100;
122         collectedFees += (dValue * jumpFee) / 100;
123         
124         bool saviour = false;
125         
126         //Pay pending entries if the new balance allows for it
127         while (balance > entries[payoutOrder].payout) {
128             
129             saviour = false;
130             
131             uint entryPayout = entries[payoutOrder].payout;
132             uint entryDeposit = entries[payoutOrder].deposit;
133             uint profit = entryPayout - entryDeposit;
134             uint saviourShare = 0;
135             
136             //Give credit & reward for the rescue if the user saved someone else
137             if (users[msg.sender].addr != entries[payoutOrder].entryAddress)
138             {
139                 users[msg.sender].rescueCount++;
140                 //Double or triple token bonus if the user is taking a moderate/high risk to help those trapped
141                 if (entryDeposit >= 1 ether) {
142                     users[msg.sender].rescueTokens += dValue < 20 || currentEntries < 15 ? 1 : 2;
143                     users[msg.sender].rescueTokens += dValue < 40 || currentEntries < 25 ? 0 : 1;
144                 }
145                 saviour = true;
146             }
147             
148             bool isHero = false;
149             
150             isHero = entries[payoutOrder].entryAddress == hero;
151             
152             //Share profit with saviour if the gain is substantial enough and the saviour invested enough (hero exempt)
153             if (saviour && !isHero && profit > 20 * entryDeposit / 100 && profit > 100 finney && dValue >= 5 ether)
154             {
155                 if (dValue < 10 ether)
156                    saviourShare = 3 + rand(5);
157                 else if (dValue >= 10 ether && dValue < 25 ether)
158                   saviourShare = 7 + rand(8);
159                 else if (dValue >= 25 ether && dValue < 40 ether)
160                    saviourShare = 12 + rand(13);
161                 else if (dValue >= 40 ether)
162                    saviourShare = rand(50);
163                    
164                 saviourShare *= profit / 100;
165                    
166                 msg.sender.send(saviourShare);
167             }
168             
169             uint payout = entryPayout - saviourShare;
170             entries[payoutOrder].entryAddress.send(payout);
171             
172             //Trigger rescue event
173             Rescue(entries[payoutOrder].entryAddress, msg.sender, payout);
174 
175             balance -= entryPayout;
176             usersProfits += entryPayout;
177             
178             rescues++;
179             payoutOrder++;
180         }
181         
182         //Check for new Hero of the Pit
183         if (saviour && users[msg.sender].rescueCount > rescueRecord)
184         {
185             rescueRecord = users[msg.sender].rescueCount;
186             hero = msg.sender;
187             //Trigger new hero event
188             NewHero(msg.sender);
189         }
190     }
191     
192     //Generate random number between 1 & max
193     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
194     function rand(uint max) constant private returns (uint256 result){
195         uint256 factor = FACTOR * 100 / max;
196         uint256 lastBlockNumber = block.number - 1;
197         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
198     
199         return uint256((uint256(hashVal) / factor)) % max + 1;
200     }
201     
202     function addNewUser(address Address) private
203     {
204         if (users[Address].addr == address(0))
205         {
206             users[Address].id = ++uniqueUsers;
207             users[Address].addr = Address;
208             users[Address].nickname = 'UnnamedPlayer';
209             users[Address].rescueCount = 0;
210             users[Address].rescueTokens = 0;
211         }
212     }
213     
214     //Transfer earnings from fees to the owner
215     function collectFees() onlyowner {
216         if (collectedFees == 0) throw;
217 
218         owner.send(collectedFees);
219         collectedFees = 0;
220     }
221 
222     //Contract management
223     function changeOwner(address newOwner) onlyowner {
224         owner = newOwner;
225     }
226     
227     function changeBaseMultiplier(uint multi) onlyowner {
228         if (multi < 110 || multi > 150) throw;
229         
230         baseMultiplier = multi;
231     }
232     
233     function changeMaxMultiplier(uint multi) onlyowner {
234         if (multi < 200 || multi > 300) throw;
235         
236         maxMultiplier = multi;
237     }
238     
239     function changeFee(uint fee) onlyowner {
240         if (fee < 0 || fee > 10) throw;
241         
242         jumpFee = fee;
243     }
244     
245     
246     //JSON functions
247     function setNickname(string name) {
248         addNewUser(msg.sender);
249         
250         if (bytes(name).length >= 2 && bytes(name).length <= 16)
251             users[msg.sender].nickname = name;
252     }
253     
254     function currentBalance() constant returns (uint pitBalance, string info) {
255         pitBalance = balance / 1 finney;
256         info = 'The balance of the pit in Finneys (contract balance minus fees).';
257     }
258     
259     function heroOfThePit() constant returns (address theHero, string nickname, uint peopleSaved, string info) {
260         theHero = hero;  
261         nickname = users[theHero].nickname;
262         peopleSaved = rescueRecord;
263         info = 'The current rescue record holder. All hail!';
264     }
265     
266     function userName(address Address) constant returns (string nickname) {
267         nickname = users[Address].nickname;
268     }
269     
270     function totalRescues() constant returns (uint rescueCount, string info) {
271         rescueCount = rescues;
272         info = 'The number of times that people have been rescued from the pit (aka the number of times people made a profit).';
273     }
274     
275     function multipliers() constant returns (uint BaseMultiplier, uint MaxMultiplier, string info) {
276         BaseMultiplier = baseMultiplier;
277         MaxMultiplier = maxMultiplier;
278         info = 'The multipliers applied to all deposits: the final multiplier is a random number between the multpliers shown divided by 100. By default x1.1~x1.5 (up to x2 if rescue tokens are used, granting +0.1 per token). It determines the amount of money you will get when rescued (a saviour share might be deducted).';
279     }
280     
281     function pitFee() constant returns (uint feePercentage, string info) {
282         feePercentage = jumpFee;
283         info = 'The fee percentage applied to all deposits. It can change to speed payouts (max 10%).';
284     }
285     
286     function nextPayoutGoal() constant returns (uint finneys, string info) {
287         finneys = (entries[payoutOrder].payout - balance) / 1 finney;
288         info = 'The amount of Finneys (Ethers * 1000) that need to be deposited for the next payout to be executed.';
289     }
290     
291     function unclaimedFees() constant returns (uint ethers, string info) {
292         ethers = collectedFees / 1 ether;
293         info = 'The amount of Ethers obtained through fees that have not yet been collected by the owner.';
294     }
295     
296     function totalEntries() constant returns (uint count, string info) {
297         count = entries.length;
298         info = 'The number of times that people have jumped into the pit.';
299     }
300     
301     function totalUsers() constant returns (uint users, string info) {
302         users = uniqueUsers;
303         info = 'The number of unique users that have joined the pit.';
304     }
305     
306     function awaitingPayout() constant returns (uint count, string info) {
307         count = entries.length - payoutOrder;
308         info = 'The number of people waiting to be saved.';
309     }
310     
311     function entryDetails(uint index) constant returns (address user, string nickName, uint deposit, uint payout, uint tokensUsed, string info)
312     {
313         if (index <= entries.length) {
314             user = entries[index].entryAddress;
315             nickName = users[entries[index].entryAddress].nickname;
316             deposit = entries[index].deposit / 1 finney;
317             payout = entries[index].payout / 1 finney;
318             tokensUsed = entries[index].tokens;
319             info = 'Entry info: user address, name, expected payout in Finneys (approximate), rescue tokens used.';
320         }
321     }
322     
323     function userId(address user) constant returns (uint id, string info) {
324         id = users[user].id;
325         info = 'The id of the user, represents the order in which he first joined the pit.';
326     }
327     
328     function userTokens(address user) constant returns (uint tokens, string info) {
329         tokens = users[user].addr != address(0x0) ? users[user].rescueTokens : 0;
330         info = 'The number of Rescue Tokens the user has. Tokens are awarded when your deposits save people, and used automatically on your next deposit. They provide a 0.1 multiplier increase per token. (+0.5 max)';
331     }
332     
333     function userRescues(address user) constant returns(uint rescueCount, string info) {
334         rescueCount = users[user].addr != address(0x0) ? users[user].rescueCount : 0;
335         info = 'The number of times the user has rescued someone from the pit.';
336     }
337     
338     function userProfits() constant returns(uint profits, string info) {
339         profits = usersProfits / 1 finney;
340         info = 'The combined earnings of all users in Finney.';
341     }
342     
343     //Destroy the contract after ~3 months of inactivity at the owner's discretion
344     function recycle() onlyowner
345     {
346         if (now >= timeOfLastDeposit + 10 weeks) 
347         { 
348             //Refund the current balance
349             if (balance > 0) 
350             {
351                 entries[0].entryAddress.send(balance);
352             }
353             
354             //Destroy the contract
355             selfdestruct(owner);
356         }
357     }
358 }