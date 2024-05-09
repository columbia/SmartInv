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
18     address public payer;
19     address public recipient;
20     address constant burnAddress = 0x0;
21     
22     string public payerString;
23     string public recipientString;
24     
25     uint public commitThreshold;
26     
27     enum DefaultAction {None, Release, Burn}
28     DefaultAction public defaultAction;
29     uint public defaultTimeoutLength;
30     uint public defaultTriggerTime;
31     
32     enum State {Open, Committed, Expended}
33     State public state;
34     
35     modifier inState(State s) { if (s != state) throw; _; }
36     modifier onlyPayer() { if (msg.sender != payer) throw; _; }
37     modifier onlyRecipient() { if (msg.sender != recipient) throw; _; }
38     modifier onlyPayerOrRecipient() { if ((msg.sender != payer) && (msg.sender != recipient)) throw; _; }
39     
40     event FundsAdded(uint amount);
41     event PayerStringUpdated(string newPayerString);
42     event RecipientStringUpdated(string newRecipientString);
43     event FundsRecovered();
44     event Committed(address recipient);
45     event FundsBurned(uint amount);
46     event FundsReleased(uint amount);
47     event Expended();
48     event Unexpended();
49     event DefaultActionDelayed();
50     event DefaultActionCalled();
51     
52     function BurnableOpenPayment(address _payer, string _payerString, uint _commitThreshold, DefaultAction _defaultAction, uint _defaultTimeoutLength)
53     public
54     payable {
55         state = State.Open;
56         payer = _payer;
57         payerString = _payerString;
58         PayerStringUpdated(payerString);
59         commitThreshold = _commitThreshold;
60         defaultAction = _defaultAction;
61         defaultTimeoutLength = _defaultTimeoutLength;
62     }
63     
64     function addFunds()
65     public
66     onlyPayer()
67     payable {
68         if (msg.value == 0) throw;
69         FundsAdded(msg.value);
70         if (state == State.Expended) {
71             state = State.Committed;
72             Unexpended();
73         }
74     }
75     
76     function recoverFunds()
77     public
78     onlyPayer()
79     inState(State.Open)
80     {
81         FundsRecovered();
82         selfdestruct(payer);
83     }
84     
85     function commit()
86     public
87     inState(State.Open)
88     payable
89     {
90         if (msg.value < commitThreshold) throw;
91         recipient = msg.sender;
92         state = State.Committed;
93         Committed(recipient);
94         
95         if (this.balance == 0) {
96             state = State.Expended;
97             Expended();
98         }
99         
100         if (defaultAction != DefaultAction.None) {
101             defaultTriggerTime = now + defaultTimeoutLength;
102         }
103     }
104     
105     function internalBurn(uint amount)
106     private
107     inState(State.Committed)
108     returns (bool)
109     {
110         bool success = burnAddress.send(amount);
111         if (success) {
112             FundsBurned(amount);
113         }
114         if (this.balance == 0) {
115             state = State.Expended;
116             Expended();
117         }
118         return success;
119     }
120     
121     function burn(uint amount)
122     public
123     inState(State.Committed)
124     onlyPayer()
125     returns (bool)
126     {
127         return internalBurn(amount);
128     }
129     
130     function internalRelease(uint amount)
131     private
132     inState(State.Committed)
133     returns (bool)
134     {
135         bool success = recipient.send(amount);
136         if (success) {
137             FundsReleased(amount);
138         }
139         if (this.balance == 0) {
140             state = State.Expended;
141             Expended();
142         }
143         return success;
144     }
145     
146     function release(uint amount)
147     public
148     inState(State.Committed)
149     onlyPayer()
150     returns (bool)
151     {
152         return internalRelease(amount);
153     }
154     
155     function setPayerString(string _string)
156     public
157     onlyPayer()
158     {
159         payerString = _string;
160         PayerStringUpdated(payerString);
161     }
162     
163     function setRecipientString(string _string)
164     public
165     onlyRecipient()
166     {
167         recipientString = _string;
168         RecipientStringUpdated(recipientString);
169     }
170     
171     function delayDefaultAction()
172     public
173     onlyPayerOrRecipient()
174     inState(State.Committed)
175     {
176         if (defaultAction == DefaultAction.None) throw;
177         
178         DefaultActionDelayed();
179         defaultTriggerTime = now + defaultTimeoutLength;
180     }
181     
182     function callDefaultAction()
183     public
184     onlyPayerOrRecipient()
185     inState(State.Committed)
186     {
187         if (defaultAction == DefaultAction.None) throw;
188         if (now < defaultTriggerTime) throw;
189         
190         DefaultActionCalled();
191         if (defaultAction == DefaultAction.Burn) {
192             internalBurn(this.balance);
193         }
194         else if (defaultAction == DefaultAction.Release) {
195             internalRelease(this.balance);
196         }
197     }
198 }
199 
200 contract BurnableOpenPaymentFactory {
201     event NewBOP(address newBOPAddress);
202     
203     function newBurnableOpenPayment(address payer, string payerString, uint commitThreshold, BurnableOpenPayment.DefaultAction defaultAction, uint defaultTimeoutLength)
204     public
205     payable
206     returns (address) {
207         //pass along any ether to the constructor
208         address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, payerString, commitThreshold, defaultAction, defaultTimeoutLength);
209         NewBOP(newBOPAddr);
210         return newBOPAddr;
211     }
212 }