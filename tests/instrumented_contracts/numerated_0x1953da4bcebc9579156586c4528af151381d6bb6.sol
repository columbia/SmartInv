1 //A BurnableOpenPayment is instantiated with a specified payer and a commitThreshold.
2 //The recipient is not set when the contract is instantiated.
3 
4 //The constructor is payable, so the contract can be instantiated with initial funds.
5 //Only the payer can fund the Payment after instantiation.
6 
7 //All behavior of the contract is directed by the payer, but
8 //the payer can never directly recover the payment,
9 //unless he calls the recover() function before anyone else commit()s.
10 
11 //Anyone can become the recipient by contributing the commitThreshold with commit().
12 //The recipient will never be changed once it's been set via commit().
13 
14 //The payer can at any time choose to burn or release to the recipient any amount of funds.
15 
16 pragma solidity ^0.4.10;
17 
18 contract BurnableOpenPayment {
19     //BOP will start with a payer but no recipient (recipient==0x0)
20     address public payer;
21     address public recipient;
22     address constant burnAddress = 0x0;
23     
24     //Note that these will track, but not influence the BOP logic.
25     uint public amountDeposited;
26     uint public amountBurned;
27     uint public amountReleased;
28     
29     //payerString and recipientString enable rudimentary communication/publishing.
30     //Although the two parties might quickly move to another medium with better privacy or convenience,
31     //beginning with this is nice because it's already trustless/transparent/signed/pseudonymous/etc.
32     string public payerString;
33     string public recipientString;
34     
35     //Amount of ether a prospective recipient must pay to permanently become the recipient. See commit().
36     uint public commitThreshold;
37     
38     //What if the payer falls off the face of the planet?
39     //A BOP is instantiated with a chosen defaultAction, which cannot be changed after instantiation.
40     enum DefaultAction {None, Release, Burn}
41     DefaultAction public defaultAction;
42     
43     //if defaultAction != None, how long should we wait allowing the default action to be called?
44     uint public defaultTimeoutLength;
45     
46     //Calculated from defaultTimeoutLength in commit(),
47     //and recaluclated whenever the payer (or possibly the recipient) calls delayDefaultAction()
48     uint public defaultTriggerTime;
49     
50     //Most action happens in the Committed state.
51     enum State {Open, Committed, Expended}
52     State public state;
53     //Note that a BOP cannot go from Committed back to Open, but it can go from Expended back to Committed
54     //(this would retain the committed recipient). Search for Expended and Unexpended events to see how this works.
55     
56     modifier inState(State s) { require(s == state); _; }
57     modifier onlyPayer() { require(msg.sender == payer); _; }
58     modifier onlyRecipient() { require(msg.sender == recipient); _; }
59     modifier onlyPayerOrRecipient() { require((msg.sender == payer) || (msg.sender == recipient)); _; }
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
104         require(msg.value > 0);
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
128         require(msg.value >= commitThreshold);
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
147     {
148         burnAddress.transfer(amount);
149         
150         amountBurned += amount;
151         FundsBurned(amount);
152         
153         if (this.balance == 0) {
154             state = State.Expended;
155             Expended();
156         }
157     }
158     
159     function burn(uint amount)
160     public
161     inState(State.Committed)
162     onlyPayer()
163     {
164         internalBurn(amount);
165     }
166     
167     function internalRelease(uint amount)
168     private
169     inState(State.Committed)
170     {
171         recipient.transfer(amount);
172         
173         amountReleased += amount;
174         FundsReleased(amount);
175         
176         if (this.balance == 0) {
177             state = State.Expended;
178             Expended();
179         }
180     }
181     
182     function release(uint amount)
183     public
184     inState(State.Committed)
185     onlyPayer()
186     {
187         internalRelease(amount);
188     }
189     
190     function setPayerString(string _string)
191     public
192     onlyPayer()
193     {
194         payerString = _string;
195         PayerStringUpdated(payerString);
196     }
197     
198     function setRecipientString(string _string)
199     public
200     onlyRecipient()
201     {
202         recipientString = _string;
203         RecipientStringUpdated(recipientString);
204     }
205     
206     function delayDefaultAction()
207     public
208     onlyPayerOrRecipient()
209     inState(State.Committed)
210     {
211         require(defaultAction != DefaultAction.None);
212         
213         defaultTriggerTime = now + defaultTimeoutLength;
214         DefaultActionDelayed();
215     }
216     
217     function callDefaultAction()
218     public
219     onlyPayerOrRecipient()
220     inState(State.Committed)
221     {
222         require(defaultAction != DefaultAction.None);
223         require(now >= defaultTriggerTime);
224         
225         if (defaultAction == DefaultAction.Burn) {
226             internalBurn(this.balance);
227         }
228         else if (defaultAction == DefaultAction.Release) {
229             internalRelease(this.balance);
230         }
231         DefaultActionCalled();
232     }
233 }
234 
235 contract BurnableOpenPaymentFactory {
236     event NewBOP(address newBOPAddress, address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString);
237     
238     function newBurnableOpenPayment(address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString)
239     public
240     payable
241     returns (address) {
242         //pass along any ether to the constructor
243         address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
244         NewBOP(newBOPAddr, payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
245         return newBOPAddr;
246     }
247 }