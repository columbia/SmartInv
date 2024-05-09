1 //A BurnablePayment is instantiated with one "opening agent" (Payer or Worker), a title, an initial deposit, a commitThreshold, and an autoreleaseInterval.
2 //If the opening agent is the payer:
3 //    The contract starts in the PayerOpened state.
4 //    Payer is expected to request some service via the title and additional statements.
5 //    The initial deposit represents the amount Payer will pay for the service.
6 //    Another user can claim the job by calling commit() and becoming the worker.
7 //If the opening agent is the worker:
8 //    The contract starts in the WorkerOpened state.
9 //    Worker is expected to offer some service via the title and additional statements.
10 //    The initial deposit serves as collateral that a payer will have control over.
11 //    Another user can claim the service by calling commit() and becoming the payer.
12 
13 //While in either Open state,
14 //    The opening agent can call recover() to destroy the contract and refund all deposited funds.
15 //    The opening agent can log statements to add additional details, clarifications, or corrections.
16 //    Anyone can enter the contract as the open role by contributing the commitThreshold with commit();
17 //        this changes the state to Committed.
18 
19 //Upon changing from either Open state -> Committed:
20 //    AutoreleaseTime is set to (now + autoreleaseInterval).
21 
22 //In the Committed state:
23 //    Both roles are permanent.
24 //    Both Payer and Worker can log statements.
25 //    Payer can at any time choose to burn() or release() to Worker any amount of funds.
26 //    Payer can delayAutorelease(), setting the autoreleaseTime to (now + autoreleaseInterval), any number of times.
27 //    If autoreleaseTime comes, Worker can triggerAutorelease() to claim all ether remaining in the payment.
28 //    Once the balance of the payment is 0, the state changes to Closed.
29 
30 //In the Closed state:
31 //    Payer and Worker can still log statements.
32 //    If addFunds() is called, the contract returns to the Committed state.
33 
34 pragma solidity ^ 0.4.2;
35 
36 contract BurnablePaymentFactory {
37     
38     //contract address array
39     address[]public BPs;
40 
41     event NewBurnablePayment(
42         address indexed bpAddress, 
43         bool payerOpened, 
44         address creator, 
45         uint deposited, 
46         uint commitThreshold, 
47         uint autoreleaseInterval, 
48         string title, 
49         string initialStatement
50     );  
51 
52     function newBP(bool payerOpened, address creator, uint commitThreshold, uint autoreleaseInterval, string title, string initialStatement)
53     public
54     payable
55     returns (address newBPAddr) 
56     {
57         //pass along any ether to the constructor
58         newBPAddr = (new BurnablePayment).value(msg.value)(payerOpened, creator, commitThreshold, autoreleaseInterval, title, initialStatement);
59         NewBurnablePayment(newBPAddr, payerOpened, creator, msg.value, commitThreshold, autoreleaseInterval, title, initialStatement);
60 
61         BPs.push(newBPAddr);
62 
63         return newBPAddr;
64     }
65 
66     function getBPCount()
67     public
68     constant
69     returns(uint) 
70     {
71         return BPs.length;
72     }
73 }
74 
75 contract BurnablePayment {
76     //title will never change
77     string public title;
78     
79     //BP will start with a payer or a worker but not both
80     address public payer;
81     address public worker;
82     address constant BURN_ADDRESS = 0x0;
83     
84     //Set to true if fundsRecovered is called
85     bool recovered = false;
86 
87     //Note that these will track, but not influence the BP logic.
88     uint public amountDeposited;
89     uint public amountBurned;
90     uint public amountReleased;
91 
92     //Amount of ether that must be deposited via commit() to become the second party of the BP.
93     uint public commitThreshold;
94 
95     //How long should we wait before allowing the default release to be called?
96     uint public autoreleaseInterval;
97 
98     //Calculated from autoreleaseInterval in commit(),
99     //and recaluclated whenever the payer (or possibly the worker) calls delayhasDefaultRelease()
100     //After this time, auto-release can be called by the Worker.
101     uint public autoreleaseTime;
102 
103     //Most action happens in the Committed state.
104     enum State {
105         PayerOpened,
106         WorkerOpened,
107         Committed,
108         Closed
109     }
110 
111     //Note that a BP cannot go from Committed back to either Open state, but it can go from Closed back to Committed
112     //Search for Closed and Unclosed events to see how this works.
113     State public state;
114 
115     modifier inState(State s) {
116         require(s == state);
117         _;
118     }
119     modifier inOpenState() {
120         require(state == State.PayerOpened || state == State.WorkerOpened);
121         _;
122     }
123     modifier onlyPayer() {
124         require(msg.sender == payer);
125         _;
126     }
127     modifier onlyWorker() {
128         require(msg.sender == worker);
129         _;
130     }
131     modifier onlyPayerOrWorker() {
132         require((msg.sender == payer) || (msg.sender == worker));
133         _;
134     }
135     modifier onlyCreatorWhileOpen() {
136         if (state == State.PayerOpened) {
137             require(msg.sender == payer);
138         } else if (state == State.WorkerOpened) {
139             require(msg.sender == worker);
140         } else {
141             revert();        
142         }
143         _;
144     }
145 
146     event Created(address indexed contractAddress, bool payerOpened, address creator, uint commitThreshold, uint autoreleaseInterval, string title);
147     event FundsAdded(address from, uint amount); //The payer has added funds to the BP.
148     event PayerStatement(string statement);
149     event WorkerStatement(string statement);
150     event FundsRecovered();
151     event Committed(address committer);
152     event FundsBurned(uint amount);
153     event FundsReleased(uint amount);
154     event Closed();
155     event Unclosed();
156     event AutoreleaseDelayed();
157     event AutoreleaseTriggered();
158 
159     function BurnablePayment(bool payerIsOpening, address creator, uint _commitThreshold, uint _autoreleaseInterval, string _title, string initialStatement)
160     public
161     payable 
162     {
163         Created(this, payerIsOpening, creator, _commitThreshold, autoreleaseInterval, title);
164 
165         if (msg.value > 0) {
166             //Here we use tx.origin instead of msg.sender (msg.sender is just the factory contract)
167             FundsAdded(tx.origin, msg.value);
168             amountDeposited += msg.value;
169         }
170         
171         title = _title;
172 
173         if (payerIsOpening) {
174             state = State.PayerOpened;
175             payer = creator;
176         } else {
177             state = State.WorkerOpened;
178             worker = creator;
179         }
180 
181         commitThreshold = _commitThreshold;
182         autoreleaseInterval = _autoreleaseInterval;
183 
184         if (bytes(initialStatement).length > 0) {
185             if (payerIsOpening) {
186                 PayerStatement(initialStatement);
187             } else {
188                 WorkerStatement(initialStatement);              
189             }
190         }
191     }
192 
193     function addFunds()
194     public
195     payable
196     onlyPayerOrWorker()
197     {
198         require(msg.value > 0);
199 
200         FundsAdded(msg.sender, msg.value);
201         amountDeposited += msg.value;
202         if (state == State.Closed) {
203             state = State.Committed;
204             Unclosed();
205         }
206     }
207 
208     function recoverFunds()
209     public
210     onlyCreatorWhileOpen()
211     {
212         recovered = true;
213         FundsRecovered();
214         
215         if (state == State.PayerOpened)
216             selfdestruct(payer);
217         else if (state == State.WorkerOpened)
218             selfdestruct(worker);
219     }
220 
221     function commit()
222     public
223     inOpenState()
224     payable 
225     {
226         require(msg.value == commitThreshold);
227 
228         if (msg.value > 0) {
229             FundsAdded(msg.sender, msg.value);
230             amountDeposited += msg.value;
231         }
232 
233         if (state == State.PayerOpened)
234             worker = msg.sender;
235         else
236             payer = msg.sender;
237         state = State.Committed;
238         
239         Committed(msg.sender);
240 
241         autoreleaseTime = now + autoreleaseInterval;
242     }
243 
244     function internalBurn(uint amount)
245     private 
246     {
247         BURN_ADDRESS.transfer(amount);
248 
249         amountBurned += amount;
250         FundsBurned(amount);
251 
252         if (this.balance == 0) {
253             state = State.Closed;
254             Closed();
255         }
256     }
257 
258     function burn(uint amount)
259     public
260     inState(State.Committed)
261     onlyPayer() 
262     {
263         internalBurn(amount);
264     }
265 
266     function internalRelease(uint amount)
267     private 
268     {
269         worker.transfer(amount);
270 
271         amountReleased += amount;
272         FundsReleased(amount);
273 
274         if (this.balance == 0) {
275             state = State.Closed;
276             Closed();
277         }
278     }
279 
280     function release(uint amount)
281     public
282     inState(State.Committed)
283     onlyPayer() 
284     {
285         internalRelease(amount);
286     }
287 
288     function logPayerStatement(string statement)
289     public
290     onlyPayer() 
291     {
292         PayerStatement(statement);
293     }
294 
295     function logWorkerStatement(string statement)
296     public
297     onlyWorker() 
298     {
299         WorkerStatement(statement);
300     }
301 
302     function delayAutorelease()
303     public
304     onlyPayer()
305     inState(State.Committed) 
306     {
307         autoreleaseTime = now + autoreleaseInterval;
308         AutoreleaseDelayed();
309     }
310 
311     function triggerAutorelease()
312     public
313     onlyWorker()
314     inState(State.Committed) 
315     {
316         require(now >= autoreleaseTime);
317 
318         AutoreleaseTriggered();
319         internalRelease(this.balance);
320     }
321     
322     function getFullState()
323     public
324     constant
325     returns(State, address, address, string, uint, uint, uint, uint, uint, uint, uint) {
326         return (state, payer, worker, title, this.balance, commitThreshold, amountDeposited, amountBurned, amountReleased, autoreleaseInterval, autoreleaseTime);
327     }
328 }