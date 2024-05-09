1 //A BurnableOpenPayment is instantiated with a specified payer and a serviceDeposit.
2 //The worker is not set when the contract is instantiated.
3 
4 //The constructor is payable, so the contract can be instantiated with initial funds.
5 //In addition, anyone can add more funds to the Payment by calling addFunds.
6 
7 //All behavior of the contract is directed by the payer, but
8 //the payer can never directly recover the payment,
9 //unless he calls the recover() function before anyone else commit()s.
10 
11 //If the BOP is in the Open state,
12 //anyone can become the worker by contributing the serviceDeposit with commit().
13 //This changes the state from Open to Committed. The BOP will never return to the Open state.
14 //The worker will never be changed once it's been set via commit().
15 
16 //In the committed state,
17 //the payer can at any time choose to burn or release to the worker any amount of funds.
18 
19 pragma solidity ^ 0.4.10;
20 contract BurnableOpenPaymentFactory {
21 	event NewBOP(address indexed newBOPAddress, address payer, uint serviceDeposit, uint autoreleaseTime, string title, string initialStatement);
22 
23 	//contract address array
24 	address[]public BOPs;
25 
26 	function getBOPCount()
27 	public
28 	constant
29 	returns(uint) {
30 		return BOPs.length;
31 	}
32 
33 	function newBurnableOpenPayment(address payer, uint serviceDeposit, uint autoreleaseInterval, string title, string initialStatement)
34 	public
35 	payable
36 	returns(address) {
37 		//pass along any ether to the constructor
38 		address newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, serviceDeposit, autoreleaseInterval, title, initialStatement);
39 		NewBOP(newBOPAddr, payer, serviceDeposit, autoreleaseInterval, title, initialStatement);
40 
41 		//save created BOPs in contract array
42 		BOPs.push(newBOPAddr);
43 
44 		return newBOPAddr;
45 	}
46 }
47 
48 contract BurnableOpenPayment {
49     //title will never change
50     string public title;
51     
52 	//BOP will start with a payer but no worker (worker==0x0)
53 	address public payer;
54 	address public worker;
55 	address constant burnAddress = 0x0;
56 	
57 	//Set to true if fundsRecovered is called
58 	bool recovered = false;
59 
60 	//Note that these will track, but not influence the BOP logic.
61 	uint public amountDeposited;
62 	uint public amountBurned;
63 	uint public amountReleased;
64 
65 	//Amount of ether a prospective worker must pay to permanently become the worker. See commit().
66 	uint public serviceDeposit;
67 
68 	//How long should we wait before allowing the default release to be called?
69 	uint public autoreleaseInterval;
70 
71 	//Calculated from autoreleaseInterval in commit(),
72 	//and recaluclated whenever the payer (or possibly the worker) calls delayhasDefaultRelease()
73 	//After this time, auto-release can be called by the Worker.
74 	uint public autoreleaseTime;
75 
76 	//Most action happens in the Committed state.
77 	enum State {
78 		Open,
79 		Committed,
80 		Closed
81 	}
82 	State public state;
83 	//Note that a BOP cannot go from Committed back to Open, but it can go from Closed back to Committed
84 	//(this would retain the committed worker). Search for Closed and Unclosed events to see how this works.
85 
86 	modifier inState(State s) {
87 		require(s == state);
88 		_;
89 	}
90 	modifier onlyPayer() {
91 		require(msg.sender == payer);
92 		_;
93 	}
94 	modifier onlyWorker() {
95 		require(msg.sender == worker);
96 		_;
97 	}
98 	modifier onlyPayerOrWorker() {
99 		require((msg.sender == payer) || (msg.sender == worker));
100 		_;
101 	}
102 
103 	event Created(address indexed contractAddress, address payer, uint serviceDeposit, uint autoreleaseInterval, string title);
104 	event FundsAdded(address from, uint amount); //The payer has added funds to the BOP.
105 	event PayerStatement(string statement);
106 	event WorkerStatement(string statement);
107 	event FundsRecovered();
108 	event Committed(address worker);
109 	event FundsBurned(uint amount);
110 	event FundsReleased(uint amount);
111 	event Closed();
112 	event Unclosed();
113 	event AutoreleaseDelayed();
114 	event AutoreleaseTriggered();
115 
116 	function BurnableOpenPayment(address _payer, uint _serviceDeposit, uint _autoreleaseInterval, string _title, string initialStatement)
117 	public
118 	payable {
119 		Created(this, _payer, _serviceDeposit, _autoreleaseInterval, _title);
120 
121 		if (msg.value > 0) {
122 		    //Here we use tx.origin instead of msg.sender (msg.sender is just the factory contract)
123 			FundsAdded(tx.origin, msg.value);
124 			amountDeposited += msg.value;
125 		}
126 		
127 		title = _title;
128 
129 		state = State.Open;
130 		payer = _payer;
131 
132 		serviceDeposit = _serviceDeposit;
133 
134 		autoreleaseInterval = _autoreleaseInterval;
135 
136 		if (bytes(initialStatement).length > 0)
137 		    PayerStatement(initialStatement);
138 	}
139 
140 	function getFullState()
141 	public
142 	constant
143 	returns(address, string, State, address, uint, uint, uint, uint, uint, uint, uint) {
144 		return (payer, title, state, worker, this.balance, serviceDeposit, amountDeposited, amountBurned, amountReleased, autoreleaseInterval, autoreleaseTime);
145 	}
146 
147 	function addFunds()
148 	public
149 	payable {
150 		require(msg.value > 0);
151 
152 		FundsAdded(msg.sender, msg.value);
153 		amountDeposited += msg.value;
154 		if (state == State.Closed) {
155 			state = State.Committed;
156 			Unclosed();
157 		}
158 	}
159 
160 	function recoverFunds()
161 	public
162 	onlyPayer()
163 	inState(State.Open) {
164 	    recovered = true;
165 		FundsRecovered();
166 		selfdestruct(payer);
167 	}
168 
169 	function commit()
170 	public
171 	inState(State.Open)
172 	payable{
173 		require(msg.value == serviceDeposit);
174 
175 		if (msg.value > 0) {
176 			FundsAdded(msg.sender, msg.value);
177 			amountDeposited += msg.value;
178 		}
179 
180 		worker = msg.sender;
181 		state = State.Committed;
182 		Committed(worker);
183 
184 		autoreleaseTime = now + autoreleaseInterval;
185 	}
186 
187 	function internalBurn(uint amount)
188 	private
189 	inState(State.Committed) {
190 		burnAddress.transfer(amount);
191 
192 		amountBurned += amount;
193 		FundsBurned(amount);
194 
195 		if (this.balance == 0) {
196 			state = State.Closed;
197 			Closed();
198 		}
199 	}
200 
201 	function burn(uint amount)
202 	public
203 	inState(State.Committed)
204 	onlyPayer() {
205 		internalBurn(amount);
206 	}
207 
208 	function internalRelease(uint amount)
209 	private
210 	inState(State.Committed) {
211 		worker.transfer(amount);
212 
213 		amountReleased += amount;
214 		FundsReleased(amount);
215 
216 		if (this.balance == 0) {
217 			state = State.Closed;
218 			Closed();
219 		}
220 	}
221 
222 	function release(uint amount)
223 	public
224 	inState(State.Committed)
225 	onlyPayer() {
226 		internalRelease(amount);
227 	}
228 
229 	function logPayerStatement(string statement)
230 	public
231 	onlyPayer() {
232 	    PayerStatement(statement);
233 	}
234 
235 	function logWorkerStatement(string statement)
236 	public
237 	onlyWorker() {
238 		WorkerStatement(statement);
239 	}
240 
241 	function delayAutorelease()
242 	public
243 	onlyPayer()
244 	inState(State.Committed) {
245 		autoreleaseTime = now + autoreleaseInterval;
246 		AutoreleaseDelayed();
247 	}
248 
249 	function triggerAutorelease()
250 	public
251 	onlyWorker()
252 	inState(State.Committed) {
253 		require(now >= autoreleaseTime);
254 
255         AutoreleaseTriggered();
256 		internalRelease(this.balance);
257 	}
258 }