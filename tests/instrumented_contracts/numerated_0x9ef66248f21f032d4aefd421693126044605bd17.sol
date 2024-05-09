1 pragma solidity 0.4.23;
2 
3 /*
4  * ATTENTION!
5  * 
6  * This code? IS NOT DESIGNED FOR ACTUAL USE.
7  * 
8  * The author of this code really wishes you wouldn't send your ETH to it.
9  * 
10  * No, seriously. It's probablly illegal anyway. So don't do it.
11  * 
12  * Let me repeat that: Don't actually send money to this contract. You are 
13  * likely breaking several local and national laws in doing so.
14  * 
15  * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T 
16  * teams at your door. I wrote this code because I wanted to experiment
17  * with smart contracts, and I think code should be open source. So consider
18  * it public domain, No Rights Reserved. Participating in pyramid schemes
19  * is genuinely illegal so just don't even think about going beyond
20  * reading the code and understanding how it works.
21  * 
22  * Seriously. I'm not kidding. It's probablly broken in some critical way anyway
23  * and will suck all your money out your wallet, install a virus on your computer
24  * sleep with your wife, kidnap your children and sell them into slavery,
25  * make you forget to file your taxes, and give you cancer.
26  * 
27  * So.... tl;dr: This contract sucks, don't send money to it.
28  * 
29  * What it does:
30  * 
31  * It takes 50% of the ETH in it and buys tokens.
32  * It takes 50% of the ETH in it and pays back depositors.
33  * Depositors get in line and are paid out in order of deposit, plus the deposit
34  * percent.
35  * The tokens collect dividends, which in turn pay into the payout pool
36  * to be split 50/50.
37  * 
38  * If your seeing this contract in it's initial configuration, it should be
39  * set to 200% (double deposits), and pointed at POTJ:
40  * 0xC28E860C9132D55A184F9af53FC85e90Aa3A0153
41  * 
42  * But you should verify this for yourself.
43  *  
44  *  
45  */
46 
47 contract ERC20Interface {
48     function transfer(address to, uint256 tokens) public returns (bool success);
49 }
50 
51 contract POTJ {
52     
53     function buy(address) public payable returns(uint256);
54     function withdraw() public;
55     function myTokens() public view returns(uint256);
56     function myDividends(bool) public view returns(uint256);
57 }
58 
59 contract Owned {
60     address public owner;
61     address public ownerCandidate;
62 
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     
72     function changeOwner(address _newOwner) public onlyOwner {
73         ownerCandidate = _newOwner;
74     }
75     
76     function acceptOwnership() public {
77         require(msg.sender == ownerCandidate);  
78         owner = ownerCandidate;
79     }
80     
81 }
82 
83 contract IronHands is Owned {
84     
85     /**
86      * Modifiers
87      */
88      
89     /**
90      * Only owners are allowed.
91      */
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     /**
98      * The tokens can never be stolen.
99      */
100     modifier notPotj(address aContract) {
101         require(aContract != address(potj));
102         _;
103     }
104    
105     /**
106      * Events
107      */
108     event Deposit(uint256 amount, address depositer);
109     event Purchase(uint256 amountSpent, uint256 tokensReceived);
110     event Payout(uint256 amount, address creditor);
111     event Dividends(uint256 amount);
112     event ContinuityBreak(uint256 position, address skipped, uint256 amount);
113     event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);
114 
115     /**
116      * Structs
117      */
118     struct Participant {
119         address etherAddress;
120         uint256 payout;
121     }
122 
123     //Total ETH managed over the lifetime of the contract
124     uint256 throughput;
125     //Total ETH received from dividends
126     uint256 dividends;
127     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
128     uint256 public multiplier;
129     //Where in the line we are with creditors
130     uint256 public payoutOrder = 0;
131     //How much is owed to people
132     uint256 public backlog = 0;
133     //The creditor line
134     Participant[] public participants;
135     //How much each person is owed
136     mapping(address => uint256) public creditRemaining;
137     //What we will be buying
138     POTJ potj;
139     
140     address sender;
141 
142     /**
143      * Constructor
144      */
145     function IronHands(uint multiplierPercent, address potjAddress) public {
146         multiplier = multiplierPercent;
147         potj = POTJ(potjAddress);
148         sender = msg.sender;
149     }
150     
151     
152     /**
153      * Fallback function allows anyone to send money for the cost of gas which
154      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
155      */
156     function() payable public {
157         if (msg.sender != address(potj)) {
158             deposit();
159         }
160     }
161     
162     /**
163      * Deposit ETH to get in line to be credited back the multiplier as a percent,
164      * add that ETH to the pool, get the dividends and put them in the pool,
165      * then pay out who we owe and buy more tokens.
166      */ 
167     function deposit() payable public {
168         //You have to send more than 1000000 wei.
169         require(msg.value > 1000000);
170         //Compute how much to pay them
171         uint256 amountCredited = (msg.value * multiplier) / 100;
172         //Get in line to be paid back.
173         participants.push(Participant(sender, amountCredited));
174         //Increase the backlog by the amount owed
175         backlog += amountCredited;
176         //Increase the amount owed to this address
177         creditRemaining[sender] += amountCredited;
178         //Emit a deposit event.
179         emit Deposit(msg.value, sender);
180         //If I have dividends
181         if(myDividends() > 0){
182             //Withdraw dividends
183             withdraw();
184         }
185         //Pay people out and buy more tokens.
186         payout();
187     }
188     
189     /**
190      * Take 50% of the money and spend it on tokens, which will pay dividends later.
191      * Take the other 50%, and use it to pay off depositors.
192      */
193     function payout() public {
194         //Take everything in the pool
195         uint balance = address(this).balance;
196         //It needs to be something worth splitting up
197         require(balance > 1);
198         //Increase our total throughput
199         throughput += balance;
200         //Split it into two parts
201         uint investment = balance / 2 ether + 1 szabo; // avoid rounding issues
202         //Take away the amount we are investing from the amount to send
203         balance -= investment;
204         //Invest it in more tokens.
205         uint256 tokens = potj.buy.value(investment).gas(1000000)(msg.sender);
206         //Record that tokens were purchased
207         emit Purchase(investment, tokens);
208         //While we still have money to send
209         while (balance > 0) {
210             //Either pay them what they are owed or however much we have, whichever is lower.
211             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
212             //if we have something to pay them
213             if(payoutToSend > 0) {
214                 //subtract how much we've spent
215                 balance -= payoutToSend;
216                 //subtract the amount paid from the amount owed
217                 backlog -= payoutToSend;
218                 //subtract the amount remaining they are owed
219                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
220                 //credit their account the amount they are being paid
221                 participants[payoutOrder].payout -= payoutToSend;
222                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
223                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()) {
224                     //Record that they were paid
225                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
226                 } else {
227                     //undo the accounting, they are being skipped because they are not payable.
228                     balance += payoutToSend;
229                     backlog += payoutToSend;
230                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
231                     participants[payoutOrder].payout += payoutToSend;
232                 }
233 
234             }
235             //If we still have balance left over
236             if(balance > 0) {
237                 // go to the next person in line
238                 payoutOrder += 1;
239             }
240             //If we've run out of people to pay, stop
241             if(payoutOrder >= participants.length) {
242                 return;
243             }
244         }
245     }
246     
247     /**
248      * Number of tokens the contract owns.
249      */
250     function myTokens() public view returns(uint256) {
251         return potj.myTokens();
252     }
253     
254     /**
255      * Number of dividends owed to the contract.
256      */
257     function myDividends() public view returns(uint256) {
258         return potj.myDividends(true);
259     }
260     
261     /**
262      * Number of dividends received by the contract.
263      */
264     function totalDividends() public view returns(uint256) {
265         return dividends;
266     }
267     
268     
269     /**
270      * Request dividends be paid out and added to the pool.
271      */
272     function withdraw() public {
273         uint256 balance = address(this).balance;
274         potj.withdraw.gas(1000000)();
275         uint256 dividendsPaid = address(this).balance - balance;
276         dividends += dividendsPaid;
277         emit Dividends(dividendsPaid);
278     }
279     
280     /**
281      * Number of participants who are still owed.
282      */
283     function backlogLength() public view returns (uint256) {
284         return participants.length - payoutOrder;
285     }
286     
287     /**
288      * Total amount still owed in credit to depositors.
289      */
290     function backlogAmount() public view returns (uint256) {
291         return backlog;
292     } 
293     
294     /**
295      * Total number of deposits in the lifetime of the contract.
296      */
297     function totalParticipants() public view returns (uint256) {
298         return participants.length;
299     }
300     
301     /**
302      * Total amount of ETH that the contract has delt with so far.
303      */
304     function totalSpent() public view returns (uint256) {
305         return throughput;
306     }
307     
308     /**
309      * Amount still owed to an individual address
310      */
311     function amountOwed(address anAddress) public view returns (uint256) {
312         return creditRemaining[anAddress];
313     }
314      
315      /**
316       * Amount owed to this person.
317       */
318     function amountIAmOwed() public view returns (uint256) {
319         return amountOwed(msg.sender);
320     }
321     
322     /**
323      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
324      */
325     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPotj(tokenAddress) returns (bool success) {
326         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
327     }
328     
329 }