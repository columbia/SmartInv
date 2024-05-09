1 pragma solidity ^0.4.21;
2 
3 /**
4  * 
5  * 
6  * EPX/PHX Doubler
7  * - Takes 50% of the ETH in it and buys tokens.
8  * - Takes 50% of the ETH in it and pays back depositors.
9  * - Depositors get in line and are paid out in order of deposit, plus the multipler percent.
10  * - The tokens collect dividends, which in turn pay into the payout pool to be split 50/50.
11  * 
12  * - PHX mined by this contract will be sold and reinvested in the doubler :)
13  * 
14  * - Code from BoomerangLiquidyFund: https://gist.github.com/TSavo/2401671fbfdb6ac384a556914934c64f
15  * - Original BLF PoWH3D doubler: 0xE58b65d1c0C8e8b2a0e3A3AcEC633271531084ED        
16  *
17  * 
18  * ATTENTION!
19  * 
20  * This code? IS NOT DESIGNED FOR ACTUAL USE.
21  * 
22  * The author of this code really wishes you wouldn't send your ETH to it.
23  * 
24  * No, seriously. It's probablly illegal anyway. So don't do it.
25  * 
26  * Let me repeat that: Don't actually send money to this contract. You are 
27  * likely breaking several local and national laws in doing so.
28  * 
29  * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T 
30  * teams at your door. I wrote this code because I wanted to experiment
31  * with smart contracts, and I think code should be open source. So consider
32  * it public domain, No Rights Reserved. Participating in pyramid schemes
33  * is genuinely illegal so just don't even think about going beyond
34  * reading the code and understanding how it works.
35  * 
36  * Seriously. I'm not kidding. It's probablly broken in some critical way anyway
37  * and will suck all your money out your wallet, install a virus on your computer
38  * sleep with your wife, kidnap your children and sell them into slavery,
39  * make you forget to file your taxes, and give you cancer.
40  * 
41  * So.... tl;dr: This contract sucks, don't send money to it.
42  *  
43  */
44 
45 contract ERC20Interface {
46     function transfer(address to, uint256 tokens) public returns (bool success);
47 }
48 
49 contract EPX {
50 
51     function fund() public payable returns(uint256){}
52     function withdraw() public {}
53     function dividends(address) public returns(uint256) {}
54     function balanceOf() public view returns(uint256) {}
55 }
56 
57 contract PHX {
58     function mine() public {}
59 }
60 
61 contract Owned {
62     address public owner;
63     address public ownerCandidate;
64 
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73     
74     function changeOwner(address _newOwner) public onlyOwner {
75         ownerCandidate = _newOwner;
76     }
77     
78     function acceptOwnership() public {
79         require(msg.sender == ownerCandidate);  
80         owner = ownerCandidate;
81     }
82     
83 }
84 
85 contract IronHands is Owned {
86     
87     
88     address phxContract = 0x14b759A158879B133710f4059d32565b4a66140C;
89     
90     /**
91      * Modifiers
92      */
93      
94     /**
95      * Only owners are allowed.
96      */
97     modifier onlyOwner(){
98         require(msg.sender == owner);
99         _;
100     }
101     
102     /**
103      * The tokens can never be stolen.
104      */
105     modifier notEthPyramid(address aContract){
106         require(aContract != address(ethpyramid));
107         _;
108     }
109    
110     /**
111      * Events
112      */
113     event Deposit(uint256 amount, address depositer);
114     event Purchase(uint256 amountSpent, uint256 tokensReceived);
115     event Payout(uint256 amount, address creditor);
116     event Dividends(uint256 amount);
117     event Donation(uint256 amount, address donator);
118     event ContinuityBreak(uint256 position, address skipped, uint256 amount);
119     event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);
120 
121     /**
122      * Structs
123      */
124     struct Participant {
125         address etherAddress;
126         uint256 payout;
127     }
128 
129     //Total ETH managed over the lifetime of the contract
130     uint256 throughput;
131     //Total ETH received from dividends
132     uint256 dividends;
133     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
134     uint256 public multiplier;
135     //Where in the line we are with creditors
136     uint256 public payoutOrder = 0;
137     //How much is owed to people
138     uint256 public backlog = 0;
139     //The creditor line
140     Participant[] public participants;
141     //How much each person is owed
142     mapping(address => uint256) public creditRemaining;
143     //What we will be buying
144     EPX ethpyramid;
145     PHX phx;
146 
147     /**
148      * Constructor
149      */
150     function IronHands(uint multiplierPercent, address addr) public {
151         multiplier = multiplierPercent;
152         ethpyramid = EPX(addr);
153         phx = PHX(phxContract);
154     }
155     
156     
157     function minePhx() public onlyOwner {
158         phx.mine.gas(1000000)();
159         
160     }
161     
162     /**
163      * Fallback function allows anyone to send money for the cost of gas which
164      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
165      */
166     function() payable public {
167     }
168     
169     /**
170      * Deposit ETH to get in line to be credited back the multiplier as a percent,
171      * add that ETH to the pool, get the dividends and put them in the pool,
172      * then pay out who we owe and buy more tokens.
173      */ 
174     function deposit() payable public {
175         //You have to send more than 1000000 wei.
176         require(msg.value > 1000000);
177         //Compute how much to pay them
178         uint256 amountCredited = (msg.value * multiplier) / 100;
179         //Get in line to be paid back.
180         participants.push(Participant(msg.sender, amountCredited));
181         //Increase the backlog by the amount owed
182         backlog += amountCredited;
183         //Increase the amount owed to this address
184         creditRemaining[msg.sender] += amountCredited;
185         //Emit a deposit event.
186         emit Deposit(msg.value, msg.sender);
187         //If I have dividends
188         if(myDividends() > 0){
189             //Withdraw dividends
190             withdraw();
191         }
192         //Pay people out and buy more tokens.
193         payout();
194     }
195     
196     /**
197      * Take 50% of the money and spend it on tokens, which will pay dividends later.
198      * Take the other 50%, and use it to pay off depositors.
199      */
200     function payout() public {
201         //Take everything in the pool
202         uint balance = address(this).balance;
203         //It needs to be something worth splitting up
204         require(balance > 1);
205         //Increase our total throughput
206         throughput += balance;
207         //Split it into two parts
208         uint investment = balance / 2;
209         //Take away the amount we are investing from the amount to send
210         balance -= investment;
211         //Invest it in more tokens.
212         address(ethpyramid).call.value(investment).gas(1000000)();
213         //Record that tokens were purchased
214         //emit Purchase(investment, tokens);
215         //While we still have money to send
216         while (balance > 0) {
217             //Either pay them what they are owed or however much we have, whichever is lower.
218             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
219             //if we have something to pay them
220             if(payoutToSend > 0){
221                 //subtract how much we've spent
222                 balance -= payoutToSend;
223                 //subtract the amount paid from the amount owed
224                 backlog -= payoutToSend;
225                 //subtract the amount remaining they are owed
226                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
227                 //credit their account the amount they are being paid
228                 participants[payoutOrder].payout -= payoutToSend;
229                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
230                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()){
231                     //Record that they were paid
232                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
233                 }else{
234                     //undo the accounting, they are being skipped because they are not payable.
235                     balance += payoutToSend;
236                     backlog += payoutToSend;
237                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
238                     participants[payoutOrder].payout += payoutToSend;
239                 }
240 
241             }
242             //If we still have balance left over
243             if(balance > 0){
244                 // go to the next person in line
245                 payoutOrder += 1;
246             }
247             //If we've run out of people to pay, stop
248             if(payoutOrder >= participants.length){
249                 return;
250             }
251         }
252     }
253     
254     /**
255      * Number of tokens the contract owns.
256      */
257     function myTokens() public view returns(uint256){
258         return ethpyramid.balanceOf();
259     }
260     
261     /**
262      * Number of dividends owed to the contract.
263      */
264     function myDividends() public view returns(uint256){
265         return ethpyramid.dividends(address(this));
266     }
267     
268     /**
269      * Number of dividends received by the contract.
270      */
271     function totalDividends() public view returns(uint256){
272         return dividends;
273     }
274     
275     
276     /**
277      * Request dividends be paid out and added to the pool.
278      */
279     function withdraw() public {
280         uint256 balance = address(this).balance;
281         ethpyramid.withdraw.gas(1000000)();
282         uint256 dividendsPaid = address(this).balance - balance;
283         dividends += dividendsPaid;
284         emit Dividends(dividendsPaid);
285     }
286     
287     /**
288      * A charitible contribution will be added to the pool.
289      */
290     function donate() payable public {
291         emit Donation(msg.value, msg.sender);
292     }
293     
294     /**
295      * Number of participants who are still owed.
296      */
297     function backlogLength() public view returns (uint256){
298         return participants.length - payoutOrder;
299     }
300     
301     /**
302      * Total amount still owed in credit to depositors.
303      */
304     function backlogAmount() public view returns (uint256){
305         return backlog;
306     } 
307     
308     /**
309      * Total number of deposits in the lifetime of the contract.
310      */
311     function totalParticipants() public view returns (uint256){
312         return participants.length;
313     }
314     
315     /**
316      * Total amount of ETH that the contract has delt with so far.
317      */
318     function totalSpent() public view returns (uint256){
319         return throughput;
320     }
321     
322     /**
323      * Amount still owed to an individual address
324      */
325     function amountOwed(address anAddress) public view returns (uint256) {
326         return creditRemaining[anAddress];
327     }
328      
329      /**
330       * Amount owed to this person.
331       */
332     function amountIAmOwed() public view returns (uint256){
333         return amountOwed(msg.sender);
334     }
335     
336     /**
337      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
338      */
339     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notEthPyramid(tokenAddress) returns (bool success) {
340         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
341     }
342     
343 }