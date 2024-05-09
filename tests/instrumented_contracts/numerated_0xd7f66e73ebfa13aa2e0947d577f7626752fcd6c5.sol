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
61     event Created(address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString);
62     event FundsAdded(uint amount);//The payer has added funds to the BOP.
63     event PayerStringUpdated(string newPayerString);
64     event RecipientStringUpdated(string newRecipientString);
65     event FundsRecovered();
66     event Committed(address recipient);
67     event FundsBurned(uint amount);
68     event FundsReleased(uint amount);
69     event Expended();
70     event Unexpended();
71     event DefaultActionDelayed();
72     event DefaultActionCalled();
73     
74     function BurnableOpenPayment(address _payer, uint _commitThreshold, DefaultAction _defaultAction, uint _defaultTimeoutLength, string _payerString)
75     public
76     payable {
77         Created(_payer, _commitThreshold, _defaultAction, _defaultTimeoutLength, _payerString);
78         
79         if (msg.value > 0) {
80             FundsAdded(msg.value);
81             amountDeposited += msg.value;
82         }
83             
84         state = State.Open;
85         payer = _payer;
86         
87         commitThreshold = _commitThreshold;
88         
89         defaultAction = _defaultAction;
90         if (defaultAction != DefaultAction.None) 
91             defaultTimeoutLength = _defaultTimeoutLength;
92         
93         payerString = _payerString;
94     }
95     
96     function getFullState()
97     public
98     constant
99     returns (State, address, string, address, string, uint, uint, uint, uint, uint, DefaultAction, uint, uint) {
100         return (state, payer, payerString, recipient, recipientString, this.balance, commitThreshold, amountDeposited, amountBurned, amountReleased, defaultAction, defaultTimeoutLength, defaultTriggerTime);
101     }
102     
103     function addFunds()
104     public
105     onlyPayer()
106     payable {
107         require(msg.value > 0);
108         
109         FundsAdded(msg.value);
110         amountDeposited += msg.value;
111         if (state == State.Expended) {
112             state = State.Committed;
113             Unexpended();
114         }
115     }
116     
117     function recoverFunds()
118     public
119     onlyPayer()
120     inState(State.Open)
121     {
122         FundsRecovered();
123         selfdestruct(payer);
124     }
125     
126     function commit()
127     public
128     inState(State.Open)
129     payable
130     {
131         require(msg.value >= commitThreshold);
132         
133         if (msg.value > 0) {
134             FundsAdded(msg.value);
135             amountDeposited += msg.value;
136         }
137         
138         recipient = msg.sender;
139         state = State.Committed;
140         Committed(recipient);
141         
142         if (defaultAction != DefaultAction.None) {
143             defaultTriggerTime = now + defaultTimeoutLength;
144         }
145     }
146     
147     function internalBurn(uint amount)
148     private
149     inState(State.Committed)
150     {
151         burnAddress.transfer(amount);
152         
153         amountBurned += amount;
154         FundsBurned(amount);
155         
156         if (this.balance == 0) {
157             state = State.Expended;
158             Expended();
159         }
160     }
161     
162     function burn(uint amount)
163     public
164     inState(State.Committed)
165     onlyPayer()
166     {
167         internalBurn(amount);
168     }
169     
170     function internalRelease(uint amount)
171     private
172     inState(State.Committed)
173     {
174         recipient.transfer(amount);
175         
176         amountReleased += amount;
177         FundsReleased(amount);
178         
179         if (this.balance == 0) {
180             state = State.Expended;
181             Expended();
182         }
183     }
184     
185     function release(uint amount)
186     public
187     inState(State.Committed)
188     onlyPayer()
189     {
190         internalRelease(amount);
191     }
192     
193     function setPayerString(string _string)
194     public
195     onlyPayer()
196     {
197         payerString = _string;
198         PayerStringUpdated(payerString);
199     }
200     
201     function setRecipientString(string _string)
202     public
203     onlyRecipient()
204     {
205         recipientString = _string;
206         RecipientStringUpdated(recipientString);
207     }
208     
209     function delayDefaultAction()
210     public
211     onlyPayerOrRecipient()
212     inState(State.Committed)
213     {
214         require(defaultAction != DefaultAction.None);
215         
216         defaultTriggerTime = now + defaultTimeoutLength;
217         DefaultActionDelayed();
218     }
219     
220     function callDefaultAction()
221     public
222     onlyPayerOrRecipient()
223     inState(State.Committed)
224     {
225         require(defaultAction != DefaultAction.None);
226         require(now >= defaultTriggerTime);
227         
228         if (defaultAction == DefaultAction.Burn) {
229             internalBurn(this.balance);
230         }
231         else if (defaultAction == DefaultAction.Release) {
232             internalRelease(this.balance);
233         }
234         DefaultActionCalled();
235     }
236 }
237 
238 contract BurnableOpenPaymentFactory {
239     event NewBOP(address newBOPAddress, address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString);
240     
241     function newBurnableOpenPayment(address payer, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength, string initialPayerString)
242     public
243     payable
244     returns (address) {
245         //pass along any ether to the constructor
246         address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
247         NewBOP(newBOPAddr, payer, commitThreshold, defaultAction, defaultTimeoutLength, initialPayerString);
248         return newBOPAddr;
249     }
250 }