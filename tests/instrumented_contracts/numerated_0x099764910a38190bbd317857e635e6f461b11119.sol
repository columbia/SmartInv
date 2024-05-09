1 pragma solidity ^0.4.21;
2 
3 /**
4  * 
5  *            _       ____  ___      _ _   _       _ _           
6  *           (_)     (_)  \/  |     | | | (_)     | (_)          
7  *  _ __ ___  _ _ __  _| .  . |_   _| | |_ _ _ __ | |_  ___ _ __ 
8  * | '_ ` _ \| | '_ \| | |\/| | | | | | __| | '_ \| | |/ _ \ '__|
9  * | | | | | | | | | | | |  | | |_| | | |_| | |_) | | |  __/ |   
10  * |_| |_| |_|_|_| |_|_\_|  |_/\__,_|_|\__|_| .__/|_|_|\___|_|   
11  *                                        | |                  
12  *                                        |_|  
13  * - 150% return, 0.005 ETH max deposit
14  * - Code from BoomerangLiquidyFund: https://gist.github.com/TSavo/2401671fbfdb6ac384a556914934c64f
15  * - Original BLF Doubler contract: 0xE58b65d1c0C8e8b2a0e3A3AcEC633271531084ED
16  * 
17  * - Why? So the chain moves fast and you have some funny shit to buy when you're watching charts all day
18  *      - Plus it provides micro volume to P3D so the contract balance isn't stagnant for long periods
19  * 
20  *      - In addition, if this contract ever gains a good amount of P3D tokens it will very easily 1.5x people's 0.005 ETH :)
21  * 
22  *
23  * ATTENTION!
24  * 
25  * This code? IS NOT DESIGNED FOR ACTUAL USE.
26  * 
27  * The author of this code really wishes you wouldn't send your ETH to it.
28  * 
29  * No, seriously. It's probablly illegal anyway. So don't do it.
30  * 
31  * Let me repeat that: Don't actually send money to this contract. You are 
32  * likely breaking several local and national laws in doing so.
33  * 
34  * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T 
35  * teams at your door. I wrote this code because I wanted to experiment
36  * with smart contracts, and I think code should be open source. So consider
37  * it public domain, No Rights Reserved. Participating in pyramid schemes
38  * is genuinely illegal so just don't even think about going beyond
39  * reading the code and understanding how it works.
40  * 
41  * Seriously. I'm not kidding. It's probablly broken in some critical way anyway
42  * and will suck all your money out your wallet, install a virus on your computer
43  * sleep with your wife, kidnap your children and sell them into slavery,
44  * make you forget to file your taxes, and give you cancer.
45  * 
46  * So.... tl;dr: This contract sucks, don't send money to it.
47  * 
48  * What it does:
49  * 
50  * It takes 50% of the ETH in it and buys tokens.
51  * It takes 50% of the ETH in it and pays back depositors.
52  * Depositors get in line and are paid out in order of deposit, plus the deposit
53  * percent.
54  * The tokens collect dividends, which in turn pay into the payout pool
55  * to be split 50/50.
56  * 
57  * If your seeing this contract in it's initial configuration, it should be
58  * set to 200% (double deposits), and pointed at PoWH:
59  * 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe
60  * 
61  * But you should verify this for yourself.
62  *  
63  *  
64  */
65 
66 contract ERC20Interface {
67     function transfer(address to, uint256 tokens) public returns (bool success);
68 }
69 
70 contract POWH {
71     
72     function buy(address) public payable returns(uint256);
73     function withdraw() public;
74     function myTokens() public view returns(uint256);
75     function myDividends(bool) public view returns(uint256);
76 }
77 
78 contract Owned {
79     address public owner;
80     address public ownerCandidate;
81 
82     function Owned() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90     
91     function changeOwner(address _newOwner) public onlyOwner {
92         ownerCandidate = _newOwner;
93     }
94     
95     function acceptOwnership() public {
96         require(msg.sender == ownerCandidate);  
97         owner = ownerCandidate;
98     }
99     
100 }
101 
102 contract IronHands is Owned {
103     
104     /**
105      * Modifiers
106      */
107      
108     /**
109      * Only owners are allowed.
110      */
111     modifier onlyOwner(){
112         require(msg.sender == owner);
113         _;
114     }
115     
116     /**
117      * The tokens can never be stolen.
118      */
119     modifier notPowh(address aContract){
120         require(aContract != address(weak_hands));
121         _;
122     }
123    
124     /**
125      * Events
126      */
127     event Deposit(uint256 amount, address depositer);
128     event Purchase(uint256 amountSpent, uint256 tokensReceived);
129     event Payout(uint256 amount, address creditor);
130     event Dividends(uint256 amount);
131     event Donation(uint256 amount, address donator);
132     event ContinuityBreak(uint256 position, address skipped, uint256 amount);
133     event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);
134 
135     /**
136      * Structs
137      */
138     struct Participant {
139         address etherAddress;
140         uint256 payout;
141     }
142 
143     //Total ETH managed over the lifetime of the contract
144     uint256 throughput;
145     //Total ETH received from dividends
146     uint256 dividends;
147     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
148     uint256 public multiplier;
149     //Where in the line we are with creditors
150     uint256 public payoutOrder = 0;
151     //How much is owed to people
152     uint256 public backlog = 0;
153     //The creditor line
154     Participant[] public participants;
155     //How much each person is owed
156     mapping(address => uint256) public creditRemaining;
157     //What we will be buying
158     POWH weak_hands;
159 
160     /**
161      * Constructor
162      */
163     function IronHands(uint multiplierPercent, address powh) public {
164         multiplier = multiplierPercent;
165         weak_hands = POWH(powh);
166     }
167     
168     
169     /**
170      * Fallback function allows anyone to send money for the cost of gas which
171      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
172      */
173     function() payable public {
174     }
175     
176     /**
177      * Deposit ETH to get in line to be credited back the multiplier as a percent,
178      * add that ETH to the pool, get the dividends and put them in the pool,
179      * then pay out who we owe and buy more tokens.
180      */ 
181     function deposit() payable public {
182         //You have to send more than 1000000 wei and <= 0.005 ETH
183         require(msg.value > 1000000 && msg.value <= 5000000000000000);
184         //Compute how much to pay them
185         uint256 amountCredited = (msg.value * multiplier) / 100;
186         //Get in line to be paid back.
187         participants.push(Participant(msg.sender, amountCredited));
188         //Increase the backlog by the amount owed
189         backlog += amountCredited;
190         //Increase the amount owed to this address
191         creditRemaining[msg.sender] += amountCredited;
192         //Emit a deposit event.
193         emit Deposit(msg.value, msg.sender);
194         //If I have dividends
195         if(myDividends() > 0){
196             //Withdraw dividends
197             withdraw();
198         }
199         //Pay people out and buy more tokens.
200         payout();
201     }
202     
203     /**
204      * Take 50% of the money and spend it on tokens, which will pay dividends later.
205      * Take the other 50%, and use it to pay off depositors.
206      */
207     function payout() public {
208         //Take everything in the pool
209         uint balance = address(this).balance;
210         //It needs to be something worth splitting up
211         require(balance > 1);
212         //Increase our total throughput
213         throughput += balance;
214         //Split it into two parts
215         uint investment = balance / 2;
216         //Take away the amount we are investing from the amount to send
217         balance -= investment;
218         //Invest it in more tokens.
219         uint256 tokens = weak_hands.buy.value(investment).gas(1000000)(msg.sender);
220         //Record that tokens were purchased
221         emit Purchase(investment, tokens);
222         //While we still have money to send
223         while (balance > 0) {
224             //Either pay them what they are owed or however much we have, whichever is lower.
225             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
226             //if we have something to pay them
227             if(payoutToSend > 0){
228                 //subtract how much we've spent
229                 balance -= payoutToSend;
230                 //subtract the amount paid from the amount owed
231                 backlog -= payoutToSend;
232                 //subtract the amount remaining they are owed
233                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
234                 //credit their account the amount they are being paid
235                 participants[payoutOrder].payout -= payoutToSend;
236                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
237                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()){
238                     //Record that they were paid
239                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
240                 }else{
241                     //undo the accounting, they are being skipped because they are not payable.
242                     balance += payoutToSend;
243                     backlog += payoutToSend;
244                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
245                     participants[payoutOrder].payout += payoutToSend;
246                 }
247 
248             }
249             //If we still have balance left over
250             if(balance > 0){
251                 // go to the next person in line
252                 payoutOrder += 1;
253             }
254             //If we've run out of people to pay, stop
255             if(payoutOrder >= participants.length){
256                 return;
257             }
258         }
259     }
260     
261     /**
262      * Number of tokens the contract owns.
263      */
264     function myTokens() public view returns(uint256){
265         return weak_hands.myTokens();
266     }
267     
268     /**
269      * Number of dividends owed to the contract.
270      */
271     function myDividends() public view returns(uint256){
272         return weak_hands.myDividends(true);
273     }
274     
275     /**
276      * Number of dividends received by the contract.
277      */
278     function totalDividends() public view returns(uint256){
279         return dividends;
280     }
281     
282     
283     /**
284      * Request dividends be paid out and added to the pool.
285      */
286     function withdraw() public {
287         uint256 balance = address(this).balance;
288         weak_hands.withdraw.gas(1000000)();
289         uint256 dividendsPaid = address(this).balance - balance;
290         dividends += dividendsPaid;
291         emit Dividends(dividendsPaid);
292     }
293     
294     /**
295      * A charitible contribution will be added to the pool.
296      */
297     function donate() payable public {
298         emit Donation(msg.value, msg.sender);
299     }
300     
301     /**
302      * Number of participants who are still owed.
303      */
304     function backlogLength() public view returns (uint256){
305         return participants.length - payoutOrder;
306     }
307     
308     /**
309      * Total amount still owed in credit to depositors.
310      */
311     function backlogAmount() public view returns (uint256){
312         return backlog;
313     } 
314     
315     /**
316      * Total number of deposits in the lifetime of the contract.
317      */
318     function totalParticipants() public view returns (uint256){
319         return participants.length;
320     }
321     
322     /**
323      * Total amount of ETH that the contract has delt with so far.
324      */
325     function totalSpent() public view returns (uint256){
326         return throughput;
327     }
328     
329     /**
330      * Amount still owed to an individual address
331      */
332     function amountOwed(address anAddress) public view returns (uint256) {
333         return creditRemaining[anAddress];
334     }
335      
336      /**
337       * Amount owed to this person.
338       */
339     function amountIAmOwed() public view returns (uint256){
340         return amountOwed(msg.sender);
341     }
342     
343     /**
344      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
345      */
346     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPowh(tokenAddress) returns (bool success) {
347         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
348     }
349     
350 }