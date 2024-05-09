1 pragma solidity ^0.4.21;
2 
3 /**
4  * 
5  * 
6  *   __________                                                          
7  *   \______   \ ____   ____   _____   ________________    ____    ____  
8  *    |    |  _//  _ \ /  _ \ /     \_/ __ \_  __ \__  \  /    \  / ___\ 
9  *    |    |   (  <_> |  <_> )  Y Y  \  ___/|  | \// __ \|   |  \/ /_/  >
10  *    |______  /\____/ \____/|__|_|  /\___  >__|  (____  /___|  /\___  / 
11  *           \/                    \/     \/           \/     \//_____/  
12  *          .____    .__             .__    .___.__  __                  
13  *          |    |   |__| ________ __|__| __| _/|__|/  |_ ___.__.        
14  *          |    |   |  |/ ____/  |  \  |/ __ | |  \   __<   |  |        
15  *          |    |___|  < <_|  |  |  /  / /_/ | |  ||  |  \___  |        
16  *          |_______ \__|\__   |____/|__\____ | |__||__|  / ____|        
17  *                  \/      |__|             \/           \/             
18  *    _____          __               .__    ___________                .___
19  *   /     \  __ ___/  |_ __ _______  |  |   \_   _____/_ __  ____    __| _/
20  *  /  \ /  \|  |  \   __\  |  \__  \ |  |    |    __)|  |  \/    \  / __ | 
21  * /    Y    \  |  /|  | |  |  // __ \|  |__  |     \ |  |  /   |  \/ /_/ | 
22  * \____|__  /____/ |__| |____/(____  /____/  \___  / |____/|___|  /\____ | 
23  *         \/                       \/            \/             \/      \/ 
24  *     ___________            __               .__                          
25  *     \_   _____/___ _____ _/  |_ __ _________|__| ____    ____            
26  *      |    __)/ __ \\__  \\   __\  |  \_  __ \  |/    \  / ___\           
27  *      |     \\  ___/ / __ \|  | |  |  /|  | \/  |   |  \/ /_/  >          
28  *      \___  / \___  >____  /__| |____/ |__|  |__|___|  /\___  /           
29  *          \/      \/     \/                          \//_____/           
30  *                   _          _           _            _                      
31  *                  /\ \       /\ \        /\ \         /\ \     _              
32  *                  \ \ \     /  \ \      /  \ \       /  \ \   /\_\            
33  *                  /\ \_\   / /\ \ \    / /\ \ \     / /\ \ \_/ / /            
34  *                 / /\/_/  / / /\ \_\  / / /\ \ \   / / /\ \___/ /             
35  *                / / /    / / /_/ / / / / /  \ \_\ / / /  \/____/              
36  *               / / /    / / /__\/ / / / /   / / // / /    / / /               
37  *              / / /    / / /_____/ / / /   / / // / /    / / /                
38  *          ___/ / /__  / / /\ \ \  / / /___/ / // / /    / / /                 
39  *         /\__\/_/___\/ / /  \ \ \/ / /____\/ // / /    / / /                  
40  *         \/_________/\/_/    \_\/\/_________/ \/_/     \/_/                   
41  *          _       _    _                   _             _            _        
42  *         / /\    / /\ / /\                /\ \     _    /\ \         / /\      
43  *        / / /   / / // /  \              /  \ \   /\_\ /  \ \____   / /  \     
44  *       / /_/   / / // / /\ \            / /\ \ \_/ / // /\ \_____\ / / /\ \__  
45  *      / /\ \__/ / // / /\ \ \          / / /\ \___/ // / /\/___  // / /\ \___\ 
46  *     / /\ \___\/ // / /  \ \ \        / / /  \/____// / /   / / / \ \ \ \/___/ 
47  *    / / /\/___/ // / /___/ /\ \      / / /    / / // / /   / / /   \ \ \       
48  *   / / /   / / // / /_____/ /\ \    / / /    / / // / /   / / /_    \ \ \      
49  *  / / /   / / // /_________/\ \ \  / / /    / / / \ \ \__/ / //_/\__/ / /      
50  * / / /   / / // / /_       __\ \_\/ / /    / / /   \ \___\/ / \ \/___/ /       
51  * \/_/    \/_/ \_\___\     /____/_/\/_/     \/_/     \/_____/   \_____\/        
52  *                                                                                        
53  *                          .___ __________________ ________                
54  *       _____    ____    __| _/ \______   \_____  \\______ \               
55  *       \__  \  /    \  / __ |   |     ___/ _(__  < |    |  \              
56  *        / __ \|   |  \/ /_/ |   |    |    /       \|    `   \             
57  *       (____  /___|  /\____ |   |____|   /______  /_______  /             
58  *            \/     \/      \/                   \/        \/                    
59  *
60  * ATTENTION!
61  * 
62  * This code? IS NOT DESIGNED FOR ACTUAL USE.
63  * 
64  * The author of this code really wishes you wouldn't send your ETH to it.
65  * 
66  * No, seriously. It's probablly illegal anyway. So don't do it.
67  * 
68  * Let me repeat that: Don't actually send money to this contract. You are 
69  * likely breaking several local and national laws in doing so.
70  * 
71  * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T 
72  * teams at your door. I wrote this code because I wanted to experiment
73  * with smart contracts, and I think code should be open source. So consider
74  * it public domain, No Rights Reserved. Participating in pyramid schemes
75  * is genuinely illegal so just don't even think about going beyond
76  * reading the code and understanding how it works.
77  * 
78  * Seriously. I'm not kidding. It's probablly broken in some critical way anyway
79  * and will suck all your money out your wallet, install a virus on your computer
80  * sleep with your wife, kidnap your children and sell them into slavery,
81  * make you forget to file your taxes, and give you cancer.
82  * 
83  * So.... tl;dr: This contract sucks, don't send money to it.
84  * 
85  * What it does:
86  * 
87  * It takes 50% of the ETH in it and buys tokens.
88  * It takes 50% of the ETH in it and pays back depositors.
89  * Depositors get in line and are paid out in order of deposit, plus the deposit
90  * percent.
91  * The tokens collect dividends, which in turn pay into the payout pool
92  * to be split 50/50.
93  * 
94  * If your seeing this contract in it's initial configuration, it should be
95  * set to 200% (double deposits), and pointed at PoWH:
96  * 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe
97  * 
98  * But you should verify this for yourself.
99  *  
100  *  
101  */
102 
103 contract ERC20Interface {
104     function transfer(address to, uint256 tokens) public returns (bool success);
105 }
106 
107 contract POWH {
108     
109     function buy(address) public payable returns(uint256);
110     function withdraw() public;
111     function myTokens() public view returns(uint256);
112     function myDividends(bool) public view returns(uint256);
113 }
114 
115 contract Owned {
116     address public owner;
117     address public ownerCandidate;
118 
119     function Owned() public {
120         owner = msg.sender;
121     }
122 
123     modifier onlyOwner {
124         require(msg.sender == owner);
125         _;
126     }
127     
128     function changeOwner(address _newOwner) public onlyOwner {
129         ownerCandidate = _newOwner;
130     }
131     
132     function acceptOwnership() public {
133         require(msg.sender == ownerCandidate);  
134         owner = ownerCandidate;
135     }
136     
137 }
138 
139 contract IronHands is Owned {
140     
141     /**
142      * Modifiers
143      */
144      
145     /**
146      * Only owners are allowed.
147      */
148     modifier onlyOwner(){
149         require(msg.sender == owner);
150         _;
151     }
152     
153     /**
154      * The tokens can never be stolen.
155      */
156     modifier notPowh(address aContract){
157         require(aContract != address(weak_hands));
158         _;
159     }
160    
161     /**
162      * Events
163      */
164     event Deposit(uint256 amount, address depositer);
165     event Purchase(uint256 amountSpent, uint256 tokensReceived);
166     event Payout(uint256 amount, address creditor);
167     event Dividends(uint256 amount);
168     event Donation(uint256 amount, address donator);
169     event ContinuityBreak(uint256 position, address skipped, uint256 amount);
170     event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);
171 
172     /**
173      * Structs
174      */
175     struct Participant {
176         address etherAddress;
177         uint256 payout;
178     }
179 
180     //Total ETH managed over the lifetime of the contract
181     uint256 throughput;
182     //Total ETH received from dividends
183     uint256 dividends;
184     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
185     uint256 public multiplier;
186     //Where in the line we are with creditors
187     uint256 public payoutOrder = 0;
188     //How much is owed to people
189     uint256 public backlog = 0;
190     //The creditor line
191     Participant[] public participants;
192     //The people who have been skipped
193     mapping(address => uint256[]) public appeals;
194     //Their position in line to skip
195     mapping(address => uint256) public appealPosition;
196     //How much each person is owed
197     mapping(address => uint256) public creditRemaining;
198     //What we will be buying
199     POWH weak_hands;
200 
201     /**
202      * Constructor
203      */
204     function IronHands(uint multiplierPercent, address powh) public {
205         multiplier = multiplierPercent;
206         weak_hands = POWH(powh);
207     }
208     
209     
210     /**
211      * Fallback function allows anyone to send money for the cost of gas which
212      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
213      */
214     function() payable public {
215     }
216     
217     /**
218      * Deposit ETH to get in line to be credited back the multiplier as a percent,
219      * add that ETH to the pool, get the dividends and put them in the pool,
220      * then pay out who we owe and buy more tokens.
221      */ 
222     function deposit() payable public {
223         //You have to send more than 10 wei.
224         require(msg.value > 10);
225         //Compute how much to pay them
226         uint256 amountCredited = (msg.value * multiplier) / 100;
227         //Get in line to be paid back.
228         participants.push(Participant(msg.sender, amountCredited));
229         //Increase the backlog by the amount owed
230         backlog += amountCredited;
231         //Increase the amount owed to this address
232         creditRemaining[msg.sender] += amountCredited;
233         //Emit a deposit event.
234         emit Deposit(msg.value, msg.sender);
235         //If I have dividends
236         if(myDividends() > 0){
237             //Withdraw dividends
238             withdraw();
239         }
240         //Pay people out and buy more tokens.
241         payout();
242     }
243     
244     /**
245      * Take 50% of the money and spend it on tokens, which will pay dividends later.
246      * Take the other 50%, and use it to pay off depositors.
247      */
248     function payout() public {
249         //Take everything in the pool
250         uint balance = address(this).balance;
251         //It needs to be something worth splitting up
252         require(balance > 1);
253         //Increase our total throughput
254         throughput += balance;
255         //Split it into two parts
256         uint investment = balance / 2;
257         //Take away the amount we are investing from the amount to send
258         balance -= investment;
259         //Invest it in more tokens.
260         uint256 tokens = weak_hands.buy.value(investment).gas(1000000)(msg.sender);
261         //Record that tokens were purchased
262         emit Purchase(investment, tokens);
263         //While we still have money to send
264         while (balance > 0) {
265             //Either pay them what they are owed or however much we have, whichever is lower.
266             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
267             //if we have something to pay them
268             if(payoutToSend > 0){
269                 //credit their account the amount they are being paid
270                 participants[payoutOrder].payout -= payoutToSend;
271                 //subtract how much we've spent
272                 balance -= payoutToSend;
273                 //subtract the amount paid from the amount owed
274                 backlog -= payoutToSend;
275                 //subtract the amount remaining they are owed
276                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
277                 //Try and pay them
278                 participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)();
279                 //Record that they were paid
280                 emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
281             }
282             //If we still have balance left over
283             if(balance > 0){
284                 // go to the next person in line
285                 payoutOrder += 1;
286             }
287             //If we've run out of people to pay, stop
288             if(payoutOrder >= participants.length){
289                 return;
290             }
291         }
292     }
293     
294     /**
295      * Number of tokens the contract owns.
296      */
297     function myTokens() public view returns(uint256){
298         return weak_hands.myTokens();
299     }
300     
301     /**
302      * Number of dividends owed to the contract.
303      */
304     function myDividends() public view returns(uint256){
305         return weak_hands.myDividends(true);
306     }
307     
308     /**
309      * Number of dividends received by the contract.
310      */
311     function totalDividends() public view returns(uint256){
312         return dividends;
313     }
314     
315     
316     /**
317      * Request dividends be paid out and added to the pool.
318      */
319     function withdraw() public {
320         uint256 balance = address(this).balance;
321         weak_hands.withdraw.gas(1000000)();
322         uint256 dividendsPaid = address(this).balance - balance;
323         dividends += dividendsPaid;
324         emit Dividends(dividendsPaid);
325     }
326     
327     /**
328      * A charitible contribution will be added to the pool.
329      */
330     function donate() payable public {
331         emit Donation(msg.value, msg.sender);
332     }
333     
334     /**
335      * Number of participants who are still owed.
336      */
337     function backlogLength() public view returns (uint256){
338         return participants.length - payoutOrder;
339     }
340     
341     /**
342      * Total amount still owed in credit to depositors.
343      */
344     function backlogAmount() public view returns (uint256){
345         return backlog;
346     } 
347     
348     /**
349      * Total number of deposits in the lifetime of the contract.
350      */
351     function totalParticipants() public view returns (uint256){
352         return participants.length;
353     }
354     
355     /**
356      * Total amount of ETH that the contract has delt with so far.
357      */
358     function totalSpent() public view returns (uint256){
359         return throughput;
360     }
361     
362     /**
363      * Amount still owed to an individual address
364      */
365     function amountOwed(address anAddress) public view returns (uint256) {
366         return creditRemaining[anAddress];
367     }
368      
369      /**
370       * Amount owed to this person.
371       */
372     function amountIAmOwed() public view returns (uint256){
373         return amountOwed(msg.sender);
374     }
375     
376     /**
377      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
378      */
379     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
380         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
381     }
382     
383     /**
384      * This function is potentially dangerous and should never be used except in extreme cases.
385      * It's concievable that a malicious user could construct a contact with a payable function which expends
386      * all the gas in transfering ETH to it. Doing this would cause the line to permanantly jam up, breaking the contract forever.
387      * Calling this function will cause that address to be skipped over, allowing the contract to continue.
388      * The address who was skipped is allowed to call appeal to undo the damage and replace themselves in line in
389      * the event of a malicious operator.
390      */
391     function skip() public onlyOwner {
392         Participant memory skipped = participants[payoutOrder];
393         emit ContinuityBreak(payoutOrder, skipped.etherAddress, skipped.payout);
394         if(appeals[skipped.etherAddress].length == appealPosition[skipped.etherAddress]){
395             appeals[skipped.etherAddress].push(payoutOrder);
396         }else{
397             appeals[skipped.etherAddress][appealPosition[skipped.etherAddress]] = payoutOrder;
398         }
399         appealPosition[skipped.etherAddress] += 1;
400         payoutOrder += 1;
401     }
402 
403     /**
404      * It's concievable that a malicious user could construct a contact with a payable function which expends
405      * all the gas in transfering ETH to it. Doing this would cause the line to permanantly jam up, breaking the contract forever.
406      * Calling this function will cause the line to be backed up to the skipped person's position.
407      * It can only be done by the person who was skipped.
408      */
409     function appealSkip() public {
410         require(appealPosition[msg.sender] > 0);
411         appealPosition[msg.sender] -= 1;
412         uint appeal = appeals[msg.sender][appealPosition[msg.sender]];
413         require(payoutOrder > appeal);
414         emit ContinuityAppeal(payoutOrder, appeal, msg.sender);
415         payoutOrder = appeal;
416     }
417 }