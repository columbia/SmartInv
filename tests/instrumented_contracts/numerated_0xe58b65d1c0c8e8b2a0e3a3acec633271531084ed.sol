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
192     //How much each person is owed
193     mapping(address => uint256) public creditRemaining;
194     //What we will be buying
195     POWH weak_hands;
196 
197     /**
198      * Constructor
199      */
200     function IronHands(uint multiplierPercent, address powh) public {
201         multiplier = multiplierPercent;
202         weak_hands = POWH(powh);
203     }
204     
205     
206     /**
207      * Fallback function allows anyone to send money for the cost of gas which
208      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
209      */
210     function() payable public {
211     }
212     
213     /**
214      * Deposit ETH to get in line to be credited back the multiplier as a percent,
215      * add that ETH to the pool, get the dividends and put them in the pool,
216      * then pay out who we owe and buy more tokens.
217      */ 
218     function deposit() payable public {
219         //You have to send more than 1000000 wei.
220         require(msg.value > 1000000);
221         //Compute how much to pay them
222         uint256 amountCredited = (msg.value * multiplier) / 100;
223         //Get in line to be paid back.
224         participants.push(Participant(msg.sender, amountCredited));
225         //Increase the backlog by the amount owed
226         backlog += amountCredited;
227         //Increase the amount owed to this address
228         creditRemaining[msg.sender] += amountCredited;
229         //Emit a deposit event.
230         emit Deposit(msg.value, msg.sender);
231         //If I have dividends
232         if(myDividends() > 0){
233             //Withdraw dividends
234             withdraw();
235         }
236         //Pay people out and buy more tokens.
237         payout();
238     }
239     
240     /**
241      * Take 50% of the money and spend it on tokens, which will pay dividends later.
242      * Take the other 50%, and use it to pay off depositors.
243      */
244     function payout() public {
245         //Take everything in the pool
246         uint balance = address(this).balance;
247         //It needs to be something worth splitting up
248         require(balance > 1);
249         //Increase our total throughput
250         throughput += balance;
251         //Split it into two parts
252         uint investment = balance / 2;
253         //Take away the amount we are investing from the amount to send
254         balance -= investment;
255         //Invest it in more tokens.
256         uint256 tokens = weak_hands.buy.value(investment).gas(1000000)(msg.sender);
257         //Record that tokens were purchased
258         emit Purchase(investment, tokens);
259         //While we still have money to send
260         while (balance > 0) {
261             //Either pay them what they are owed or however much we have, whichever is lower.
262             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
263             //if we have something to pay them
264             if(payoutToSend > 0){
265                 //subtract how much we've spent
266                 balance -= payoutToSend;
267                 //subtract the amount paid from the amount owed
268                 backlog -= payoutToSend;
269                 //subtract the amount remaining they are owed
270                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
271                 //credit their account the amount they are being paid
272                 participants[payoutOrder].payout -= payoutToSend;
273                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
274                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()){
275                     //Record that they were paid
276                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
277                 }else{
278                     //undo the accounting, they are being skipped because they are not payable.
279                     balance += payoutToSend;
280                     backlog += payoutToSend;
281                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
282                     participants[payoutOrder].payout += payoutToSend;
283                 }
284 
285             }
286             //If we still have balance left over
287             if(balance > 0){
288                 // go to the next person in line
289                 payoutOrder += 1;
290             }
291             //If we've run out of people to pay, stop
292             if(payoutOrder >= participants.length){
293                 return;
294             }
295         }
296     }
297     
298     /**
299      * Number of tokens the contract owns.
300      */
301     function myTokens() public view returns(uint256){
302         return weak_hands.myTokens();
303     }
304     
305     /**
306      * Number of dividends owed to the contract.
307      */
308     function myDividends() public view returns(uint256){
309         return weak_hands.myDividends(true);
310     }
311     
312     /**
313      * Number of dividends received by the contract.
314      */
315     function totalDividends() public view returns(uint256){
316         return dividends;
317     }
318     
319     
320     /**
321      * Request dividends be paid out and added to the pool.
322      */
323     function withdraw() public {
324         uint256 balance = address(this).balance;
325         weak_hands.withdraw.gas(1000000)();
326         uint256 dividendsPaid = address(this).balance - balance;
327         dividends += dividendsPaid;
328         emit Dividends(dividendsPaid);
329     }
330     
331     /**
332      * A charitible contribution will be added to the pool.
333      */
334     function donate() payable public {
335         emit Donation(msg.value, msg.sender);
336     }
337     
338     /**
339      * Number of participants who are still owed.
340      */
341     function backlogLength() public view returns (uint256){
342         return participants.length - payoutOrder;
343     }
344     
345     /**
346      * Total amount still owed in credit to depositors.
347      */
348     function backlogAmount() public view returns (uint256){
349         return backlog;
350     } 
351     
352     /**
353      * Total number of deposits in the lifetime of the contract.
354      */
355     function totalParticipants() public view returns (uint256){
356         return participants.length;
357     }
358     
359     /**
360      * Total amount of ETH that the contract has delt with so far.
361      */
362     function totalSpent() public view returns (uint256){
363         return throughput;
364     }
365     
366     /**
367      * Amount still owed to an individual address
368      */
369     function amountOwed(address anAddress) public view returns (uint256) {
370         return creditRemaining[anAddress];
371     }
372      
373      /**
374       * Amount owed to this person.
375       */
376     function amountIAmOwed() public view returns (uint256){
377         return amountOwed(msg.sender);
378     }
379     
380     /**
381      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
382      */
383     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
384         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
385     }
386     
387 }