1 //A BurnableOpenPayment is instantiated with a specified payer and a commitThreshold.
2 //The recipient is not set when the contract is instantiated.
3 
4 //The constructor is payable, so the contract can be instantiated with initial funds.
5 //In addition, anyone can add more funds to the Payment by calling addFunds.
6 
7 //All behavior of the contract is directed by the payer, but
8 //the payer can never directly recover the payment,
9 //unless he calls the recover() function before anyone else commit()s.
10 
11 //If the BOP is in the Open state,
12 //anyone can become the recipient by contributing the commitThreshold with commit().
13 //This changes the state from Open to Committed. The BOP will never return to the Open state.
14 //The recipient will never be changed once it's been set via commit().
15 
16 //In the committed state,
17 //the payer can at any time choose to burn or release to the recipient any amount of funds.
18 
19 pragma solidity ^ 0.4.10;
20 contract BurnableOpenPaymentFactory {
21 	event NewBOP(address indexed contractAddress, address newBOPAddress, address payer, uint commitThreshold, bool hasDefaultRelease, uint defaultTimeoutLength, string initialPayerString);
22 
23 	//contract address array
24 	address[]public contracts;
25 
26 	function getContractCount()
27 	public
28 	constant
29 	returns(uint) {
30 		return contracts.length;
31 	}
32 
33 	function newBurnableOpenPayment(address payer, uint commitThreshold, bool hasDefaultRelease, uint defaultTimeoutLength, string initialPayerString)
34 	public
35 	payable
36 	returns(address) {
37 		//pass along any ether to the constructor
38 		address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, commitThreshold, hasDefaultRelease, defaultTimeoutLength, initialPayerString);
39 		NewBOP(this, newBOPAddr, payer, commitThreshold, hasDefaultRelease, defaultTimeoutLength, initialPayerString);
40 
41 		//save created BOPs in contract array
42 		contracts.push(newBOPAddr);
43 
44 		return newBOPAddr;
45 	}
46 }
47 
48 contract BurnableOpenPayment {
49 	//BOP will start with a payer but no recipient (recipient==0x0)
50 	address public payer;
51 	address public recipient;
52 	address constant burnAddress = 0x0;
53 	
54 	//Set to true if fundsRecovered is called
55 	bool recovered = false;
56 
57 	//Note that these will track, but not influence the BOP logic.
58 	uint public amountDeposited;
59 	uint public amountBurned;
60 	uint public amountReleased;
61 
62 	//payerString and recipientString enable rudimentary communication/publishing.
63 	//Although the two parties might quickly move to another medium with better privacy or convenience,
64 	//beginning with this is nice because it's already trustless/transparent/signed/pseudonymous/etc.
65 	string public payerString;
66 	string public recipientString;
67 
68 	//Amount of ether a prospective recipient must pay to permanently become the recipient. See commit().
69 	uint public commitThreshold;
70 
71 	//What if the payer falls off the face of the planet?
72 	//A BOP is instantiated with or without defaultRelease, which cannot be changed after instantiation.
73 	bool public hasDefaultRelease;
74 
75 	//if hasDefaultRelease == True, how long should we wait allowing the default release to be called?
76 	uint public defaultTimeoutLength;
77 
78 	//Calculated from defaultTimeoutLength in commit(),
79 	//and recaluclated whenever the payer (or possibly the recipient) calls delayhasDefaultRelease()
80 	uint public defaultTriggerTime;
81 
82 	//Most action happens in the Committed state.
83 	enum State {
84 		Open,
85 		Committed,
86 		Expended
87 	}
88 	State public state;
89 	//Note that a BOP cannot go from Committed back to Open, but it can go from Expended back to Committed
90 	//(this would retain the committed recipient). Search for Expended and Unexpended events to see how this works.
91 
92 	modifier inState(State s) {
93 		require(s == state);
94 		_;
95 	}
96 	modifier onlyPayer() {
97 		require(msg.sender == payer);
98 		_;
99 	}
100 	modifier onlyRecipient() {
101 		require(msg.sender == recipient);
102 		_;
103 	}
104 	modifier onlyPayerOrRecipient() {
105 		require((msg.sender == payer) || (msg.sender == recipient));
106 		_;
107 	}
108 
109 	event Created(address indexed contractAddress, address payer, uint commitThreshold, bool hasDefaultRelease, uint defaultTimeoutLength, string initialPayerString);
110 	event FundsAdded(uint amount); //The payer has added funds to the BOP.
111 	event PayerStringUpdated(string newPayerString);
112 	event RecipientStringUpdated(string newRecipientString);
113 	event FundsRecovered();
114 	event Committed(address recipient);
115 	event FundsBurned(uint amount);
116 	event FundsReleased(uint amount);
117 	event Expended();
118 	event Unexpended();
119 	event DefaultReleaseDelayed();
120 	event DefaultReleaseCalled();
121 
122 	function BurnableOpenPayment(address _payer, uint _commitThreshold, bool _hasDefaultRelease, uint _defaultTimeoutLength, string _payerString)
123 	public
124 	payable {
125 		Created(this, _payer, _commitThreshold, _hasDefaultRelease, _defaultTimeoutLength, _payerString);
126 
127 		if (msg.value > 0) {
128 			FundsAdded(msg.value);
129 			amountDeposited += msg.value;
130 		}
131 
132 		state = State.Open;
133 		payer = _payer;
134 
135 		commitThreshold = _commitThreshold;
136 
137 		hasDefaultRelease = _hasDefaultRelease;
138 		if (hasDefaultRelease)
139 			defaultTimeoutLength = _defaultTimeoutLength;
140 
141 		payerString = _payerString;
142 	}
143 
144 	function getFullState()
145 	public
146 	constant
147 	returns(State, address, string, address, string, uint, uint, uint, uint, uint, bool, uint, uint) {
148 		return (state, payer, payerString, recipient, recipientString, this.balance, commitThreshold, amountDeposited, amountBurned, amountReleased, hasDefaultRelease, defaultTimeoutLength, defaultTriggerTime);
149 	}
150 
151 	function addFunds()
152 	public
153 	payable {
154 		require(msg.value > 0);
155 
156 		FundsAdded(msg.value);
157 		amountDeposited += msg.value;
158 		if (state == State.Expended) {
159 			state = State.Committed;
160 			Unexpended();
161 		}
162 	}
163 
164 	function recoverFunds()
165 	public
166 	onlyPayer()
167 	inState(State.Open) {
168 	    recovered = true;
169 		FundsRecovered();
170 		selfdestruct(payer);
171 	}
172 
173 	function commit()
174 	public
175 	inState(State.Open)
176 	payable{
177 		require(msg.value >= commitThreshold);
178 
179 		if (msg.value > 0) {
180 			FundsAdded(msg.value);
181 			amountDeposited += msg.value;
182 		}
183 
184 		recipient = msg.sender;
185 		state = State.Committed;
186 		Committed(recipient);
187 
188 		if (hasDefaultRelease) {
189 			defaultTriggerTime = now + defaultTimeoutLength;
190 		}
191 	}
192 
193 	function internalBurn(uint amount)
194 	private
195 	inState(State.Committed) {
196 		burnAddress.transfer(amount);
197 
198 		amountBurned += amount;
199 		FundsBurned(amount);
200 
201 		if (this.balance == 0) {
202 			state = State.Expended;
203 			Expended();
204 		}
205 	}
206 
207 	function burn(uint amount)
208 	public
209 	inState(State.Committed)
210 	onlyPayer() {
211 		internalBurn(amount);
212 	}
213 
214 	function internalRelease(uint amount)
215 	private
216 	inState(State.Committed) {
217 		recipient.transfer(amount);
218 
219 		amountReleased += amount;
220 		FundsReleased(amount);
221 
222 		if (this.balance == 0) {
223 			state = State.Expended;
224 			Expended();
225 		}
226 	}
227 
228 	function release(uint amount)
229 	public
230 	inState(State.Committed)
231 	onlyPayer() {
232 		internalRelease(amount);
233 	}
234 
235 	function setPayerString(string _string)
236 	public
237 	onlyPayer() {
238 		payerString = _string;
239 		PayerStringUpdated(payerString);
240 	}
241 
242 	function setRecipientString(string _string)
243 	public
244 	onlyRecipient() {
245 		recipientString = _string;
246 		RecipientStringUpdated(recipientString);
247 	}
248 
249 	function delayDefaultRelease()
250 	public
251 	onlyPayerOrRecipient()
252 	inState(State.Committed) {
253 		require(hasDefaultRelease);
254 
255 		defaultTriggerTime = now + defaultTimeoutLength;
256 		DefaultReleaseDelayed();
257 	}
258 
259 	function callDefaultRelease()
260 	public
261 	onlyPayerOrRecipient()
262 	inState(State.Committed) {
263 		require(hasDefaultRelease);
264 		require(now >= defaultTriggerTime);
265 
266 		if (hasDefaultRelease) {
267 			internalRelease(this.balance);
268 		}
269 		DefaultReleaseCalled();
270 	}
271 }