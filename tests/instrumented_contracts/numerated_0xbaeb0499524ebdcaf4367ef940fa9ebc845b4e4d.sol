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
73     function BurnableOpenPayment(address _payer, uint _commitThreshold, DefaultAction _defaultAction, uint _defaultTimeoutLength, string _payerString)
74     public
75     payable {
76         if (msg.value > 0) {
77             FundsAdded(msg.value);
78             amountDeposited += msg.value;
79         }
80             
81         state = State.Open;
82         payer = _payer;
83         
84         commitThreshold = _commitThreshold;
85         
86         defaultAction = _defaultAction;
87         if (defaultAction != DefaultAction.None) 
88             defaultTimeoutLength = _defaultTimeoutLength;
89         
90         payerString = _payerString;
91     }
92     
93     function getFullState()
94     public
95     constant
96     returns (State, string, address, string, uint, uint, uint, uint) {
97         return (state, payerString, recipient, recipientString, amountDeposited, amountBurned, amountReleased, defaultTriggerTime);
98     }
99     
100     function addFunds()
101     public
102     onlyPayer()
103     payable {
104         if (msg.value == 0) throw;
105         
106         FundsAdded(msg.value);
107         amountDeposited += msg.value;
108         if (state == State.Expended) {
109             state = State.Committed;
110             Unexpended();
111         }
112     }
113     
114     function recoverFunds()
115     public
116     onlyPayer()
117     inState(State.Open)
118     {
119         FundsRecovered();
120         selfdestruct(payer);
121     }
122     
123     function commit()
124     public
125     inState(State.Open)
126     payable
127     {
128         if (msg.value < commitThreshold) throw;
129         
130         if (msg.value > 0) {
131             FundsAdded(msg.value);
132             amountDeposited += msg.value;
133         }
134         
135         recipient = msg.sender;
136         state = State.Committed;
137         Committed(recipient);
138         
139         if (defaultAction != DefaultAction.None) {
140             defaultTriggerTime = now + defaultTimeoutLength;
141         }
142     }
143     
144     function internalBurn(uint amount)
145     private
146     inState(State.Committed)
147     returns (bool)
148     {
149         bool success = burnAddress.send(amount);
150         if (success) {
151             FundsBurned(amount);
152             amountBurned += amount;
153         }
154         
155         if (this.balance == 0) {
156             state = State.Expended;
157             Expended();
158         }
159         
160         return success;
161     }
162     
163     function burn(uint amount)
164     public
165     inState(State.Committed)
166     onlyPayer()
167     returns (bool)
168     {
169         return internalBurn(amount);
170     }
171     
172     function internalRelease(uint amount)
173     private
174     inState(State.Committed)
175     returns (bool)
176     {
177         bool success = recipient.send(amount);
178         if (success) {
179             FundsReleased(amount);
180             amountReleased += amount;
181         }
182         
183         if (this.balance == 0) {
184             state = State.Expended;
185             Expended();
186         }
187         return success;
188     }
189     
190     function release(uint amount)
191     public
192     inState(State.Committed)
193     onlyPayer()
194     returns (bool)
195     {
196         return internalRelease(amount);
197     }
198     
199     function setPayerString(string _string)
200     public
201     onlyPayer()
202     {
203         payerString = _string;
204         PayerStringUpdated(payerString);
205     }
206     
207     function setRecipientString(string _string)
208     public
209     onlyRecipient()
210     {
211         recipientString = _string;
212         RecipientStringUpdated(recipientString);
213     }
214     
215     function delayDefaultAction()
216     public
217     onlyPayerOrRecipient()
218     inState(State.Committed)
219     {
220         if (defaultAction == DefaultAction.None) throw;
221         
222         DefaultActionDelayed();
223         defaultTriggerTime = now + defaultTimeoutLength;
224     }
225     
226     function callDefaultAction()
227     public
228     onlyPayerOrRecipient()
229     inState(State.Committed)
230     {
231         if (defaultAction == DefaultAction.None) throw;
232         if (now < defaultTriggerTime) throw;
233         
234         DefaultActionCalled();
235         if (defaultAction == DefaultAction.Burn) {
236             internalBurn(this.balance);
237         }
238         else if (defaultAction == DefaultAction.Release) {
239             internalRelease(this.balance);
240         }
241     }
242 }
243 
244 contract BurnableOpenPaymentFactory {
245     event NewBOP(address newBOPAddress, address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString);
246     
247     function newBurnableOpenPayment(address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString)
248     public
249     payable
250     returns (address) {
251         //pass along any ether to the constructor
252         address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
253         NewBOP(newBOPAddr, payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
254         return newBOPAddr;
255     }
256 }