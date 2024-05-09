1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract Finalizable is Ownable {
46 
47 	bool public isFinalized = false;
48 
49 	event Finalized();
50 
51 	function finalize() onlyOwner public {
52 		require (!isFinalized);
53 		//require (hasEnded());
54 
55 		finalization();
56 		Finalized();
57 
58 		isFinalized = true ;
59 	}
60 
61 	function finalization() internal {
62 
63 	}
64 }
65 
66 contract TopiaCoinSAFTSale is Ownable, Finalizable {
67 
68 	event PaymentExpected(bytes8 paymentIdentifier); // Event
69 	event PaymentExpectationCancelled(bytes8 paymentIdentifier); // Event
70 	event PaymentSubmitted(address payor, bytes8 paymentIdentifier, uint256 paymentAmount); // Event
71 	event PaymentAccepted(address payor, bytes8 paymentIdentifier, uint256 paymentAmount); // Event
72 	event PaymentRejected(address payor, bytes8 paymentIdentifier, uint256 paymentAmount); // Event
73 	event UnableToAcceptPayment(address payor, bytes8 paymentIdentifier, uint256 paymentAmount); // Event
74 	event UnableToRejectPayment(address payor, bytes8 paymentIdentifier, uint256 paymentAmount); // Event
75 	
76 	event SalesWalletUpdated(address oldWalletAddress, address newWalletAddress); // Event
77 	event PaymentManagerUpdated(address oldPaymentManager, address newPaymentManager); // Event
78 
79 	event SaleOpen(); // Event
80 	event SaleClosed(); // Event
81 
82 	mapping (bytes8 => Payment) payments;
83 	address salesWallet = 0x0;
84 	address paymentManager = 0x0;
85 	bool public saleStarted = false;
86 
87 	// Structure for storing payment infromation
88 	struct Payment {
89 		address from;
90 		bytes8 paymentIdentifier;
91 		bytes32 paymentHash;
92 		uint256 paymentAmount;
93 		uint date;
94 		uint8 status; 
95 	}
96 
97 	uint8 PENDING_STATUS = 10;
98 	uint8 PAID_STATUS = 20;
99 	uint8 ACCEPTED_STATUS = 22;
100 	uint8 REJECTED_STATUS = 40;
101 
102 	modifier onlyOwnerOrManager() {
103 		require(msg.sender == owner || msg.sender == paymentManager);
104 		_;
105 	}
106 
107 	function TopiaCoinSAFTSale(address _salesWallet, address _paymentManager) 
108 		Ownable () 
109 	{
110 		require (_salesWallet != 0x0);
111 
112 		salesWallet = _salesWallet;
113 		paymentManager = _paymentManager;
114 		saleStarted = false;
115 	}
116 
117 	// Updates the wallet to which all payments are sent.
118 	function updateSalesWallet(address _salesWallet) onlyOwner {
119 		require(_salesWallet != 0x0) ;
120 		require(_salesWallet != salesWallet);
121 
122 		address oldWalletAddress = salesWallet ;
123 		salesWallet = _salesWallet;
124 
125 		SalesWalletUpdated(oldWalletAddress, _salesWallet);
126 	}
127 
128 	// Updates the wallet to which all payments are sent.
129 	function updatePaymentManager(address _paymentManager) onlyOwner {
130 		require(_paymentManager != 0x0) ;
131 		require(_paymentManager != paymentManager);
132 
133 		address oldPaymentManager = paymentManager ;
134 		paymentManager = _paymentManager;
135 
136 		PaymentManagerUpdated(oldPaymentManager, _paymentManager);
137 	}
138 
139 	// Updates the state of the contact so that it will start accepting payments.
140 	function startSale() onlyOwner {
141 		require (!saleStarted);
142 		require (!isFinalized);
143 
144 		saleStarted = true;
145 		SaleOpen();
146 	}
147 
148 	// Instructs the contract that it should expect a payment with the given identifier to be made.
149 	function expectPayment(bytes8 _paymentIdentifier, bytes32 _paymentHash) onlyOwnerOrManager {
150 		// Sale must be running in order to expect payments
151 		require (saleStarted);
152 		require (!isFinalized);
153 
154 		// Sanity check the parameters
155 		require (_paymentIdentifier != 0x0);
156 
157 		// Look up the payment identifier.  We expect to find an empty Payment record.
158 		Payment storage p = payments[_paymentIdentifier];
159 
160 		require (p.status == 0);
161 		require (p.from == 0x0);
162 
163 		p.paymentIdentifier = _paymentIdentifier;
164 		p.paymentHash = _paymentHash;
165 		p.date = now;
166 		p.status = PENDING_STATUS;
167 
168 		payments[_paymentIdentifier] = p;
169 
170 		PaymentExpected(_paymentIdentifier);
171 	}
172 
173 	// Instruct the contract should stop expecting a payment with the given identifier
174 	function cancelExpectedPayment(bytes8 _paymentIdentifier) onlyOwnerOrManager {
175 				// Sale must be running in order to expect payments
176 		require (saleStarted);
177 		require (!isFinalized);
178 
179 		// Sanity check the parameters
180 		require (_paymentIdentifier != 0x0);
181 
182 		// Look up the payment identifier.  We expect to find an empty Payment record.
183 		Payment storage p = payments[_paymentIdentifier];
184 
185 		require(p.paymentAmount == 0);
186 		require(p.status == 0 || p.status == 10);
187 
188 		p.paymentIdentifier = 0x0;
189 		p.paymentHash = 0x0;
190 		p.date = 0;
191 		p.status = 0;
192 
193 		payments[_paymentIdentifier] = p;
194 
195 		PaymentExpectationCancelled(_paymentIdentifier);
196 	}
197 
198 	// Submits a payment to the contract with the spcified payment identifier.  If the contract is
199 	// not expecting the specified payment, then the payment is held.  Expected payemnts are automatically
200 	// accepted and forwarded to the sales wallet.
201 	function submitPayment(bytes8 _paymentIdentifier, uint32 nonce) payable {
202 		require (saleStarted);
203 		require (!isFinalized);
204 
205 		// Sanity Check the Parameters
206 		require (_paymentIdentifier != 0x0);
207 
208 		Payment storage p = payments[_paymentIdentifier];
209 
210 		require (p.status == PENDING_STATUS);
211 		require (p.from == 0x0);
212 		require (p.paymentHash != 0x0);
213 		require (msg.value > 0);
214 
215 		// Calculate the Payment Hash and insure it matches the expected hash
216 		require (p.paymentHash == calculateHash(_paymentIdentifier, msg.value, nonce)) ;
217 
218 		bool forwardPayment = (p.status == PENDING_STATUS);
219 		
220 		p.from = msg.sender;
221 		p.paymentIdentifier = _paymentIdentifier;
222 		p.date = now;
223 		p.paymentAmount = msg.value;
224 		p.status = PAID_STATUS;
225 
226 		payments[_paymentIdentifier] = p;
227 
228 		PaymentSubmitted (p.from, p.paymentIdentifier, p.paymentAmount);
229 
230 		if ( forwardPayment ) {
231 			sendPaymentToWallet (p) ;
232 		}
233 	}
234 
235 	// Accepts a pending payment and forwards the payment amount to the sales wallet.
236 	function acceptPayment(bytes8 _paymentIdentifier) onlyOwnerOrManager {
237 		// Sanity Check the Parameters
238 		require (_paymentIdentifier != 0x0);
239 
240 		Payment storage p = payments[_paymentIdentifier];
241 
242 		require (p.from != 0x0) ;
243 		require (p.status == PAID_STATUS);
244 
245 		sendPaymentToWallet(p);
246 	}
247 
248 	// Rejects a pending payment and returns the payment to the payer.
249 	function rejectPayment(bytes8 _paymentIdentifier) onlyOwnerOrManager {
250 		// Sanity Check the Parameters
251 		require (_paymentIdentifier != 0x0);
252 
253 		Payment storage p = payments[_paymentIdentifier] ;
254 
255 		require (p.from != 0x0) ;
256 		require (p.status == PAID_STATUS);
257 
258 		refundPayment(p) ;
259 	}
260 
261 	// ******** Utility Methods ********
262 	// Might be removed before deploying the Smart Contract Live.
263 
264 	// Returns the payment information for a particular payment identifier.
265 	function verifyPayment(bytes8 _paymentIdentifier) constant onlyOwnerOrManager returns (address from, uint256 paymentAmount, uint date, bytes32 paymentHash, uint8 status)  {
266 		Payment storage payment = payments[_paymentIdentifier];
267 
268 		return (payment.from, payment.paymentAmount, payment.date, payment.paymentHash, payment.status);
269 	}
270 
271 	// Kills this contract.  Used only during debugging.
272 	// TODO: Remove this method before deploying Smart Contract.
273 	function kill() onlyOwner {
274 		selfdestruct(msg.sender);
275 	}
276 
277 	// ******** Internal Methods ********
278 
279 	// Internal function that transfers the ether sent with a payment on to the sales wallet.
280 	function sendPaymentToWallet(Payment _payment) internal {
281 
282 		if ( salesWallet.send(_payment.paymentAmount) ) {
283 			_payment.status = ACCEPTED_STATUS;
284 
285 			payments[_payment.paymentIdentifier] = _payment;
286 
287 			PaymentAccepted (_payment.from, _payment.paymentIdentifier, _payment.paymentAmount);
288 		} else {
289 			UnableToAcceptPayment (_payment.from, _payment.paymentIdentifier, _payment.paymentAmount);
290 		}
291 	}
292 
293 	// Internal function that transfers the ether sent with a payment back to the sender.
294 	function refundPayment(Payment _payment) internal {
295 		if ( _payment.from.send(_payment.paymentAmount)  ) {
296 			_payment.status = REJECTED_STATUS;
297 
298 			payments[_payment.paymentIdentifier] = _payment;
299 
300 			PaymentRejected (_payment.from, _payment.paymentIdentifier, _payment.paymentAmount);
301 		} else {
302 			UnableToRejectPayment (_payment.from, _payment.paymentIdentifier, _payment.paymentAmount);
303 		}
304 	}
305 
306 	// Calculates the hash for the provided payment information.
307 	// TODO: Make this method internal before deploying Smart Contract.
308 	function calculateHash(bytes8 _paymentIdentifier, uint256 _amount, uint32 _nonce) constant returns (bytes32 hash) {
309 		return sha3(_paymentIdentifier, _amount, _nonce);
310 	}
311 
312 	function finalization() internal {
313 		saleStarted = false;
314 		SaleClosed();
315 	}
316 }