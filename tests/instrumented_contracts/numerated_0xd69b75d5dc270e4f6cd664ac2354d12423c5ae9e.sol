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
55 contract POOH {
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
67     function Owned() public {
68         owner = msg.sender;
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
109     /**
110      * Events
111      */
112     event Deposit(uint256 amount, address depositer);
113     event Purchase(uint256 amountSpent, uint256 tokensReceived);
114     event Payout(uint256 amount, address creditor);
115     event Dividends(uint256 amount);
116    
117     /**
118      * Structs
119      */
120     struct Participant {
121         address etherAddress;
122         uint256 payout;
123     }
124 
125     //Total ETH managed over the lifetime of the contract
126     uint256 throughput;
127     //Total ETH received from dividends
128     uint256 dividends;
129     //The percent to return to depositers. 100 for 00%, 200 to double, etc.
130     uint256 public multiplier;
131     //Where in the line we are with creditors
132     uint256 public payoutOrder = 0;
133     //How much is owed to people
134     uint256 public backlog = 0;
135     //The creditor line
136     Participant[] public participants;
137     //How much each person is owed
138     mapping(address => uint256) public creditRemaining;
139     //What we will be buying
140     POOH weak_hands;
141 
142     /**
143      * Constructor
144      */
145     function IronHands(uint multiplierPercent, address pooh) public {
146         multiplier = multiplierPercent;
147         weak_hands = POOH(pooh);
148     }
149     
150     
151     /**
152      * Fallback function allows anyone to send money for the cost of gas which
153      * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.
154      */
155     function() payable public {
156     }
157     
158     /**
159      * Deposit ETH to get in line to be credited back the multiplier as a percent,
160      * add that ETH to the pool, get the dividends and put them in the pool,
161      * then pay out who we owe and buy more tokens.
162      */ 
163     function deposit() payable public {
164         //You have to send more than 1000000 wei.
165         require(msg.value > 1000000);
166         //Compute how much to pay them
167         uint256 amountCredited = (msg.value * multiplier) / 100;
168         //Get in line to be paid back.
169         participants.push(Participant(msg.sender, amountCredited));
170         //Increase the backlog by the amount owed
171         backlog += amountCredited;
172         //Increase the amount owed to this address
173         creditRemaining[msg.sender] += amountCredited;
174         //Emit a deposit event.
175         emit Deposit(msg.value, msg.sender);
176         //If I have dividends
177         if(myDividends() > 0){
178             //Withdraw dividends
179             withdraw();
180         }
181         //Pay people out and buy more tokens.
182         payout();
183     }
184     
185     /**
186      * Take 50% of the money and spend it on tokens, which will pay dividends later.
187      * Take the other 50%, and use it to pay off depositors.
188      */
189     function payout() public {
190         //Take everything in the pool
191         uint balance = address(this).balance;
192         //It needs to be something worth splitting up
193         require(balance > 1);
194         //Increase our total throughput
195         throughput += balance;
196         //Split it into two parts
197         uint investment = balance / 2;
198         //Take away the amount we are investing from the amount to send
199         balance -= investment;
200         //Invest it in more tokens.
201         uint256 tokens = weak_hands.buy.value(investment).gas(1000000)(msg.sender);
202         //Record that tokens were purchased
203         emit Purchase(investment, tokens);
204         //While we still have money to send
205         while (balance > 0) {
206             //Either pay them what they are owed or however much we have, whichever is lower.
207             uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
208             //if we have something to pay them
209             if(payoutToSend > 0){
210                 //subtract how much we've spent
211                 balance -= payoutToSend;
212                 //subtract the amount paid from the amount owed
213                 backlog -= payoutToSend;
214                 //subtract the amount remaining they are owed
215                 creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;
216                 //credit their account the amount they are being paid
217                 participants[payoutOrder].payout -= payoutToSend;
218                 //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.
219                 if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()){
220                     //Record that they were paid
221                     emit Payout(payoutToSend, participants[payoutOrder].etherAddress);
222                 }else{
223                     //undo the accounting, they are being skipped because they are not payable.
224                     balance += payoutToSend;
225                     backlog += payoutToSend;
226                     creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;
227                     participants[payoutOrder].payout += payoutToSend;
228                 }
229 
230             }
231             //If we still have balance left over
232             if(balance > 0){
233                 // go to the next person in line
234                 payoutOrder += 1;
235             }
236             //If we've run out of people to pay, stop
237             if(payoutOrder >= participants.length){
238                 return;
239             }
240         }
241     }
242     
243     /**
244      * Number of tokens the contract owns.
245      */
246     function myTokens() public view returns(uint256){
247         return weak_hands.myTokens();
248     }
249     
250     /**
251      * Number of dividends owed to the contract.
252      */
253     function myDividends() public view returns(uint256){
254         return weak_hands.myDividends(true);
255     }
256     
257     /**
258      * Number of dividends received by the contract.
259      */
260     function totalDividends() public view returns(uint256){
261         return dividends;
262     }
263     
264     
265     /**
266      * Request dividends be paid out and added to the pool.
267      */
268     function withdraw() public {
269         uint256 balance = address(this).balance;
270         weak_hands.withdraw.gas(1000000)();
271         uint256 dividendsPaid = address(this).balance - balance;
272         dividends += dividendsPaid;
273         emit Dividends(dividendsPaid);
274     }
275     
276     /**
277      * Number of participants who are still owed.
278      */
279     function backlogLength() public view returns (uint256){
280         return participants.length - payoutOrder;
281     }
282     
283     /**
284      * Total amount still owed in credit to depositors.
285      */
286     function backlogAmount() public view returns (uint256){
287         return backlog;
288     } 
289     
290     /**
291      * Total number of deposits in the lifetime of the contract.
292      */
293     function totalParticipants() public view returns (uint256){
294         return participants.length;
295     }
296     
297     /**
298      * Total amount of ETH that the contract has delt with so far.
299      */
300     function totalSpent() public view returns (uint256){
301         return throughput;
302     }
303     
304     /**
305      * Amount still owed to an individual address
306      */
307     function amountOwed(address anAddress) public view returns (uint256) {
308         return creditRemaining[anAddress];
309     }
310      
311      /**
312       * Amount owed to this person.
313       */
314     function amountIAmOwed() public view returns (uint256){
315         return amountOwed(msg.sender);
316     }
317     
318     /**
319      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
320      */
321     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPooh(tokenAddress) returns (bool success) {
322         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
323     }
324     
325 }