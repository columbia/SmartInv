1 pragma solidity ^0.4.21;
2 
3 /**
4  * 
5  * 
6  *                
7  *
8  * ATTENTION!
9  * 
10  * This code? IS NOT DESIGNED FOR ACTUAL USE.
11  * 
12  * The author of this code really wishes you wouldn't send your ETH to it, but it's been
13  * done with P3D and there are very happy users because of it.
14  * 
15  * No, seriously. It's probablly illegal anyway. So don't do it.
16  * 
17  * Let me repeat that: Don't actually send money to this contract. You are 
18  * likely breaking several local and national laws in doing so.
19  * 
20  * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T 
21  * teams at your door. I wrote this code because I wanted to experiment
22  * with smart contracts, and I think code should be open source. So consider
23  * it public domain, No Rights Reserved. Participating in pyramid schemes
24  * is genuinely illegal so just don't even think about going beyond
25  * reading the code and understanding how it works.
26  * 
27  * Seriously. I'm not kidding. It's probablly broken in some critical way anyway
28  * and will suck all your money out your wallet, install a virus on your computer
29  * sleep with your wife, kidnap your children and sell them into slavery,
30  * make you forget to file your taxes, and give you cancer.
31  * 
32  * 
33  * What it does:
34  * 
35  * It takes 50% of the ETH in it and buys tokens.
36  * It takes 50% of the ETH in it and pays back depositors.
37  * Depositors get in line and are paid out in order of deposit, plus the deposit
38  * percent.
39  * The tokens collect dividends, which in turn pay into the payout pool
40  * to be split 50/50.
41  * 
42  * If you're seeing this contract in it's initial configuration, it should be
43  * set to 200% (double deposits), and pointed at PoWH:
44  * 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe
45  * 
46  * But you should verify this for yourself.
47  *  
48  *  
49  */
50 
51 contract ERC20Interface {
52     function transfer(address to, uint256 tokens) public returns (bool success);
53 }
54 
55 contract REV {
56     
57     function buy(address) public payable returns(uint256);
58     function withdraw() public;
59     function myTokens() public view returns(uint256);
60     function myDividends(bool) public view returns(uint256);
61 }
62 
63 contract Owned {
64     address public owner;
65     address public ownerCandidate;
66 
67     constructor() public {
68         owner = 0xc42559F88481e1Df90f64e5E9f7d7C6A34da5691;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     function changeOwner(address _newOwner) public onlyOwner {
77         ownerCandidate = _newOwner;
78     }
79     
80     function acceptOwnership() public {
81         require(msg.sender == ownerCandidate);  
82         owner = ownerCandidate;
83     }
84     
85 }
86 
87 contract IronHands is Owned {
88     
89     /**
90      * Modifiers
91      */
92      
93     /**
94      * Only owners are allowed.
95      */
96     modifier onlyOwner(){
97         require(msg.sender == owner);
98         _;
99     }
100     
101     /**
102      * The tokens can never be stolen.
103      */
104     modifier notPooh(address aContract){
105         require(aContract != address(weak_hands));
106         _;
107     }
108 
109     modifier limitBuy() { 
110         if(msg.value > limit) { // check if the transaction is over limit eth (1000 finney = 1 eth)
111             revert(); // if so : revert the transaction
112             
113         }
114         _;
115     }
116    
117     /**
118      * Events
119      */
120     event Deposit(uint256 amount, address depositer);
121     event Purchase(uint256 amountSpent, uint256 tokensReceived);
122     event Payout(uint256 amount, address creditor);
123     event Dividends(uint256 amount);
124    
125     /**
126      * Structs
127      */
128     struct Participant {
129         address etherAddress;
130         uint256 payout;
131     }
132 
133     //Total ETH managed over the lifetime of the contract
134     uint256 throughput;
135     //Total ETH received from dividends
136     uint256 dividends;
137     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
138     uint256 public multiplier;
139     //Where in the line we are with creditors
140     uint256 public payoutOrder = 0;
141     //How much is owed to people
142     uint256 public backlog = 0;
143     //The creditor line
144     Participant[] public participants;
145     //How much each person is owed
146     mapping(address => uint256) public creditRemaining;
147     //What we will be buying
148     REV weak_hands;
149     // Limitation
150     uint256 public limit = 50 finney; // 1000 = 1eth, 100 = 0,1 eth | 50 finney = 0.05 eth
151 
152     /**
153      * Constructor
154      */
155      /*  */
156     constructor() public {
157         address cntrct = 0x05215FCE25902366480696F38C3093e31DBCE69A; // contract address
158         multiplier = 125; // 200 to double | 125 = 25% more
159         weak_hands = REV(cntrct);
160     }
161     
162     
163     /**
164      * Fallback function allows anyone to send money for the cost of gas which
165      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
166      */
167     function() payable public {
168     }
169     
170     /**
171      * Deposit ETH to get in line to be credited back the multiplier as a percent,
172      * add that ETH to the pool, get the dividends and put them in the pool,
173      * then pay out who we owe and buy more tokens.
174      */ 
175     function deposit() payable public limitBuy() {
176         //You have to send more than 1000000 wei.
177         require(msg.value > 1000000);
178         //Compute how much to pay them
179         uint256 amountCredited = (msg.value * multiplier) / 100;
180         //Get in line to be paid back.
181         participants.push(Participant(msg.sender, amountCredited));
182         //Increase the backlog by the amount owed
183         backlog += amountCredited;
184         //Increase the amount owed to this address
185         creditRemaining[msg.sender] += amountCredited;
186         //Emit a deposit event.
187         emit Deposit(msg.value, msg.sender);
188         //If I have dividends
189         if(myDividends() > 0){
190             //Withdraw dividends
191             withdraw();
192         }
193         //Pay people out and buy more tokens.
194         payout();
195     }
196     
197     /**
198      * Take 25% of the money and spend it on tokens, which will pay dividends later.
199      * Take the other 75%, and use it to pay off depositors.
200      */
201     function payout() public {
202         //Take everything in the pool
203         uint balance = address(this).balance;
204         //It needs to be something worth splitting up
205         require(balance > 1);
206         //Increase our total throughput
207         throughput += balance;
208         //calculate 25% of investment
209         uint256 investment = balance / 4;
210         //Take away the amount we are investing(25%) from the amount to send(75%)
211         balance -= investment;
212         //Invest it in more tokens.
213         uint256 tokens = weak_hands.buy.value(investment).gas(1000000)(msg.sender);
214         //Record that tokens were purchased
215         emit Purchase(investment, tokens);
216         //While we still have money to send
217         while (balance > 0) {
218             //Either pay them what they are owed or however much we have, whichever is lower.
219             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
220             //if we have something to pay them
221             if(payoutToSend > 0){
222                 //subtract how much we've spent
223                 balance -= payoutToSend;
224                 //subtract the amount paid from the amount owed
225                 backlog -= payoutToSend;
226                 //subtract the amount remaining they are owed
227                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
228                 //credit their account the amount they are being paid
229                 participants[payoutOrder].payout -= payoutToSend;
230                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
231                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()){
232                     //Record that they were paid
233                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
234                 }else{
235                     //undo the accounting, they are being skipped because they are not payable.
236                     balance += payoutToSend;
237                     backlog += payoutToSend;
238                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
239                     participants[payoutOrder].payout += payoutToSend;
240                 }
241 
242             }
243             //If we still have balance left over
244             if(balance > 0){
245                 // go to the next person in line
246                 payoutOrder += 1;
247             }
248             //If we've run out of people to pay, stop
249             if(payoutOrder >= participants.length){
250                 return;
251             }
252         }
253     }
254     
255     /**
256      * Number of tokens the contract owns.
257      */
258     function myTokens() public view returns(uint256){
259         return weak_hands.myTokens();
260     }
261     
262     /**
263      * Number of dividends owed to the contract.
264      */
265     function myDividends() public view returns(uint256){
266         return weak_hands.myDividends(true);
267     }
268     
269     /**
270      * Number of dividends received by the contract.
271      */
272     function totalDividends() public view returns(uint256){
273         return dividends;
274     }
275     
276     
277     /**
278      * Request dividends be paid out and added to the pool.
279      */
280     function withdraw() public {
281         uint256 balance = address(this).balance;
282         weak_hands.withdraw.gas(1000000)();
283         uint256 dividendsPaid = address(this).balance - balance;
284         dividends += dividendsPaid;
285         emit Dividends(dividendsPaid);
286     }
287     
288     /**
289      * Number of participants who are still owed.
290      */
291     function backlogLength() public view returns (uint256){
292         return participants.length - payoutOrder;
293     }
294     
295     /**
296      * Total amount still owed in credit to depositors.
297      */
298     function backlogAmount() public view returns (uint256){
299         return backlog;
300     } 
301     
302     /**
303      * Total number of deposits in the lifetime of the contract.
304      */
305     function totalParticipants() public view returns (uint256){
306         return participants.length;
307     }
308     
309     /**
310      * Total amount of ETH that the contract has delt with so far.
311      */
312     function totalSpent() public view returns (uint256){
313         return throughput;
314     }
315     
316     /**
317      * Amount still owed to an individual address
318      */
319     function amountOwed(address anAddress) public view returns (uint256) {
320         return creditRemaining[anAddress];
321     }
322      
323      /**
324       * Amount owed to this person.
325       */
326     function amountIAmOwed() public view returns (uint256){
327         return amountOwed(msg.sender);
328     }
329     
330     /**
331      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
332      */
333     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPooh(tokenAddress) returns (bool success) {
334         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
335     }
336     
337     function changeLimit(uint256 newLimit) public onlyOwner returns (uint256) {
338         limit = newLimit * 1 finney;
339         return limit;
340     }
341 }