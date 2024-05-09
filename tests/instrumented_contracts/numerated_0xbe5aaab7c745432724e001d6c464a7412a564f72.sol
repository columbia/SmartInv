1 //A BurnableOpenPayment is instantiated with a specified payer and a commitThreshold.
2 //The recipient is not set when the contract is instantiated.
3 
4 //The constructor is payable, so the contract can be instantiated with initial funds.
5 //Only the payer can fund the Payment after instantiation.
6 
7 //All behavior of the contract is directed by the payer, but
8 //the payer can never directly recover the payment unless he becomes the recipient.
9 
10 //Anyone can become the recipient by contributing the commitThreshold.
11 //The recipient cannot change once it's been set.
12 
13 //The payer can at any time choose to burn or release to the recipient any amount of funds.
14 
15 pragma solidity ^0.4.10;
16 
17 contract BurnableOpenPayment {
18     //BOP will start with a payer but no recipient (recipient==0x0)
19     address public payer;
20     address public recipient;
21     address constant burnAddress = 0x0;
22     
23     //Note that these will track, but not influence the BOP logic.
24     uint public amountDeposited;
25     uint public amountBurned;
26     uint public amountReleased;
27     
28     //payerString and recipientString enable rudimentary communication/publishing.
29     //Although the two parties might quickly move to another medium with better privacy or convenience,
30     //beginning with this is nice because it's already trustless/transparent/signed/pseudonymous/etc.
31     string public payerString;
32     string public recipientString;
33     
34     //Amount of ether a prospective recipient must pay to become (permanently) the recipient. See commit().
35     uint public commitThreshold;
36     
37     //What if the payer falls off the face of the planet?
38     //A BOP is instantiated with a chosen defaultAction, and this cannot be changed.
39     enum DefaultAction {None, Release, Burn}
40     DefaultAction public defaultAction;
41     
42     //if defaultAction != None, how long should we wait before giving up?
43     //Set in constructor:
44     uint public defaultTimeoutLength;
45     
46     //Calculated from defaultTimeoutLength on a successful recipient commit(),
47     //as well as whenever the payer (or possibly the recipient) calls delayDefaultAction()
48     uint public defaultTriggerTime;
49     
50     //Most action happens in the Committed state.
51     enum State {Open, Committed, Expended}
52     State public state;
53     //Note that a BOP cannot go from Committed back to Open, but it can go from Expended back to Committed
54     //(this would retain the committed recipient). Search for Expended and Unexpended events to see how this works.
55     
56     modifier inState(State s) { if (s != state) throw; _; }
57     modifier onlyPayer() { if (msg.sender != payer) throw; _; }
58     modifier onlyRecipient() { if (msg.sender != recipient) throw; _; }
59     modifier onlyPayerOrRecipient() { if ((msg.sender != payer) && (msg.sender != recipient)) throw; _; }
60     
61     event FundsAdded(uint amount);//The payer has added funds to the BOP.
62     event PayerStringUpdated(string newPayerString);
63     event RecipientStringUpdated(string newRecipientString);
64     event FundsRecovered();
65     event Committed(address recipient);
66     event FundsBurned(uint amount);
67     event FundsReleased(uint amount);
68     event Expended();
69     event Unexpended();
70     event DefaultActionDelayed();
71     event DefaultActionCalled();
72     
73     function BurnableOpenPayment(address _payer, string _payerString, uint _commitThreshold, DefaultAction _defaultAction, uint _defaultTimeoutLength)
74     public
75     payable {
76         if (msg.value > 0) {
77             FundsAdded(msg.value);
78             amountDeposited += msg.value;
79         }
80             
81         state = State.Open;
82         payer = _payer;
83         payerString = _payerString;
84         PayerStringUpdated(payerString);
85         
86         commitThreshold = _commitThreshold;
87         
88         defaultAction = _defaultAction;
89         if (defaultAction != DefaultAction.None) 
90             defaultTimeoutLength = _defaultTimeoutLength;
91     }
92     
93     function getFullState()
94     public 
95     returns (State, string, address, string, uint, uint, uint, uint) {
96         return (state, payerString, recipient, recipientString, amountDeposited, amountBurned, amountReleased, defaultTriggerTime);
97     }
98     
99     function addFunds()
100     public
101     onlyPayer()
102     payable {
103         if (msg.value == 0) throw;
104         
105         FundsAdded(msg.value);
106         amountDeposited += msg.value;
107         if (state == State.Expended) {
108             state = State.Committed;
109             Unexpended();
110         }
111     }
112     
113     function recoverFunds()
114     public
115     onlyPayer()
116     inState(State.Open)
117     {
118         FundsRecovered();
119         selfdestruct(payer);
120     }
121     
122     function commit()
123     public
124     inState(State.Open)
125     payable
126     {
127         if (msg.value < commitThreshold) throw;
128         
129         if (msg.value > 0) {
130             FundsAdded(msg.value);
131             amountDeposited += msg.value;
132         }
133         
134         recipient = msg.sender;
135         state = State.Committed;
136         Committed(recipient);
137         
138         if (defaultAction != DefaultAction.None) {
139             defaultTriggerTime = now + defaultTimeoutLength;
140         }
141     }
142     
143     function internalBurn(uint amount)
144     private
145     inState(State.Committed)
146     returns (bool)
147     {
148         bool success = burnAddress.send(amount);
149         if (success) {
150             FundsBurned(amount);
151             amountBurned += amount;
152         }
153         
154         if (this.balance == 0) {
155             state = State.Expended;
156             Expended();
157         }
158         
159         return success;
160     }
161     
162     function burn(uint amount)
163     public
164     inState(State.Committed)
165     onlyPayer()
166     returns (bool)
167     {
168         return internalBurn(amount);
169     }
170     
171     function internalRelease(uint amount)
172     private
173     inState(State.Committed)
174     returns (bool)
175     {
176         bool success = recipient.send(amount);
177         if (success) {
178             FundsReleased(amount);
179             amountReleased += amount;
180         }
181         
182         if (this.balance == 0) {
183             state = State.Expended;
184             Expended();
185         }
186         return success;
187     }
188     
189     function release(uint amount)
190     public
191     inState(State.Committed)
192     onlyPayer()
193     returns (bool)
194     {
195         return internalRelease(amount);
196     }
197     
198     function setPayerString(string _string)
199     public
200     onlyPayer()
201     {
202         payerString = _string;
203         PayerStringUpdated(payerString);
204     }
205     
206     function setRecipientString(string _string)
207     public
208     onlyRecipient()
209     {
210         recipientString = _string;
211         RecipientStringUpdated(recipientString);
212     }
213     
214     function delayDefaultAction()
215     public
216     onlyPayerOrRecipient()
217     inState(State.Committed)
218     {
219         if (defaultAction == DefaultAction.None) throw;
220         
221         DefaultActionDelayed();
222         defaultTriggerTime = now + defaultTimeoutLength;
223     }
224     
225     function callDefaultAction()
226     public
227     onlyPayerOrRecipient()
228     inState(State.Committed)
229     {
230         if (defaultAction == DefaultAction.None) throw;
231         if (now < defaultTriggerTime) throw;
232         
233         DefaultActionCalled();
234         if (defaultAction == DefaultAction.Burn) {
235             internalBurn(this.balance);
236         }
237         else if (defaultAction == DefaultAction.Release) {
238             internalRelease(this.balance);
239         }
240     }
241 }
242 
243 contract BurnableOpenPaymentFactory {
244     event NewBOP(address newBOPAddress);
245     
246     function newBurnableOpenPayment(address payer, string payerString, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength)
247     public
248     payable
249     returns (address) {
250         //pass along any ether to the constructor
251         address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, payerString, commitThreshold, defaultAction, defaultTimeoutLength);
252         NewBOP(newBOPAddr);
253         return newBOPAddr;
254     }
255 }