1 pragma solidity 0.5.0;
2 
3 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract MultiSigWallet {
6 	/*
7 	 *  Events
8 	 */
9 	event Confirmation(address indexed sender, uint256 indexed transactionId);
10 	event Revocation(address indexed sender, uint256 indexed transactionId);
11 	event Submission(uint256 indexed transactionId);
12 	event Execution(uint256 indexed transactionId);
13 	event ExecutionFailure(uint256 indexed transactionId);
14 	event Deposit(address indexed sender, uint256 value);
15 	event OwnerAddition(address indexed owner);
16 	event OwnerRemoval(address indexed owner);
17 	event RequirementChange(uint256 required);
18 
19 	/*
20 	 *  Constants
21 	 */
22 	uint256 public constant MAX_OWNER_COUNT = 50;
23 
24 	/*
25 	 *  Storage
26 	 */
27 	mapping(uint256 => Transaction) public transactions;
28 	mapping(uint256 => mapping(address => bool)) public confirmations;
29 	mapping(address => bool) public isOwner;
30 	address[] public owners;
31 	uint256 public required;
32 	uint256 public transactionCount;
33 
34 	struct Transaction {
35 		address destination;
36 		uint256 value;
37 		bytes data;
38 		bool executed;
39 	}
40 
41 	/*
42 	 *  Modifiers
43 	 */
44 	modifier onlyWallet() {
45 		require(msg.sender == address(this));
46 		_;
47 	}
48 
49 	modifier ownerDoesNotExist(address owner) {
50 		require(!isOwner[owner]);
51 		_;
52 	}
53 
54 	modifier ownerExists(address owner) {
55 		require(isOwner[owner]);
56 		_;
57 	}
58 
59 	modifier transactionExists(uint256 transactionId) {
60 		require(transactions[transactionId].destination != address(0));
61 		_;
62 	}
63 
64 	modifier confirmed(uint256 transactionId, address owner) {
65 		require(confirmations[transactionId][owner]);
66 		_;
67 	}
68 
69 	modifier notConfirmed(uint256 transactionId, address owner) {
70 		require(!confirmations[transactionId][owner]);
71 		_;
72 	}
73 
74 	modifier notExecuted(uint256 transactionId) {
75 		require(!transactions[transactionId].executed);
76 		_;
77 	}
78 
79 	modifier notNull(address _address) {
80 		require(_address != address(0));
81 		_;
82 	}
83 
84 	modifier validRequirement(uint256 ownerCount, uint256 _required) {
85 		require(
86 			ownerCount <= MAX_OWNER_COUNT &&
87 				_required <= ownerCount &&
88 				_required != 0 &&
89 				ownerCount != 0
90 		);
91 		_;
92 	}
93 
94 	/// @dev Fallback function allows to deposit ether.
95 	function() external payable {
96 		if (msg.value > 0) emit Deposit(msg.sender, msg.value);
97 	}
98 
99 	/*
100 	 * Public functions
101 	 */
102 	/// @dev Contract constructor sets initial owners and required number of confirmations.
103 	/// @param _owners List of initial owners.
104 	/// @param _required Number of required confirmations.
105 	constructor(address[] memory _owners, uint256 _required)
106 		public
107 		validRequirement(_owners.length, _required)
108 	{
109 		for (uint256 i = 0; i < _owners.length; i++) {
110 			require(!isOwner[_owners[i]] && _owners[i] != address(0));
111 			isOwner[_owners[i]] = true;
112 		}
113 		owners = _owners;
114 		required = _required;
115 	}
116 
117 	/// @dev Allows to add a new owner. Transaction has to be sent by wallet.
118 	/// @param owner Address of new owner.
119 	function addOwner(address owner)
120 		public
121 		onlyWallet
122 		ownerDoesNotExist(owner)
123 		notNull(owner)
124 		validRequirement(owners.length + 1, required)
125 	{
126 		isOwner[owner] = true;
127 		owners.push(owner);
128 		emit OwnerAddition(owner);
129 	}
130 
131 	/// @dev Allows to remove an owner. Transaction has to be sent by wallet.
132 	/// @param owner Address of owner.
133 	function removeOwner(address owner) public onlyWallet ownerExists(owner) {
134 		isOwner[owner] = false;
135 		for (uint256 i = 0; i < owners.length - 1; i++)
136 			if (owners[i] == owner) {
137 				owners[i] = owners[owners.length - 1];
138 				break;
139 			}
140 		owners.length -= 1;
141 		if (required > owners.length) changeRequirement(owners.length);
142 		emit OwnerRemoval(owner);
143 	}
144 
145 	/// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
146 	/// @param owner Address of owner to be replaced.
147 	/// @param newOwner Address of new owner.
148 	function replaceOwner(address owner, address newOwner)
149 		public
150 		onlyWallet
151 		ownerExists(owner)
152 		ownerDoesNotExist(newOwner)
153 	{
154 		for (uint256 i = 0; i < owners.length; i++)
155 			if (owners[i] == owner) {
156 				owners[i] = newOwner;
157 				break;
158 			}
159 		isOwner[owner] = false;
160 		isOwner[newOwner] = true;
161 		emit OwnerRemoval(owner);
162 		emit OwnerAddition(newOwner);
163 	}
164 
165 	/// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
166 	/// @param _required Number of required confirmations.
167 	function changeRequirement(uint256 _required)
168 		public
169 		onlyWallet
170 		validRequirement(owners.length, _required)
171 	{
172 		required = _required;
173 		emit RequirementChange(_required);
174 	}
175 
176 	/// @dev Allows an owner to submit and confirm a transaction.
177 	/// @param destination Transaction target address.
178 	/// @param value Transaction ether value.
179 	/// @param data Transaction data payload.
180 	/// @return Returns transaction ID.
181 	function submitTransaction(
182 		address destination,
183 		uint256 value,
184 		bytes memory data
185 	) public returns (uint256 transactionId) {
186 		transactionId = addTransaction(destination, value, data);
187 		confirmTransaction(transactionId);
188 	}
189 
190 	/// @dev Allows an owner to confirm a transaction.
191 	/// @param transactionId Transaction ID.
192 	function confirmTransaction(uint256 transactionId)
193 		public
194 		ownerExists(msg.sender)
195 		transactionExists(transactionId)
196 		notConfirmed(transactionId, msg.sender)
197 	{
198 		confirmations[transactionId][msg.sender] = true;
199 		emit Confirmation(msg.sender, transactionId);
200 		executeTransaction(transactionId);
201 	}
202 
203 	/// @dev Allows an owner to revoke a confirmation for a transaction.
204 	/// @param transactionId Transaction ID.
205 	function revokeConfirmation(uint256 transactionId)
206 		public
207 		ownerExists(msg.sender)
208 		confirmed(transactionId, msg.sender)
209 		notExecuted(transactionId)
210 	{
211 		confirmations[transactionId][msg.sender] = false;
212 		emit Revocation(msg.sender, transactionId);
213 	}
214 
215 	/// @dev Allows anyone to execute a confirmed transaction.
216 	/// @param transactionId Transaction ID.
217 	function executeTransaction(uint256 transactionId)
218 		public
219 		ownerExists(msg.sender)
220 		confirmed(transactionId, msg.sender)
221 		notExecuted(transactionId)
222 	{
223 		if (isConfirmed(transactionId)) {
224 			Transaction storage txn = transactions[transactionId];
225 			txn.executed = true;
226 			if (
227 				external_call(
228 					txn.destination,
229 					txn.value,
230 					txn.data.length,
231 					txn.data
232 				)
233 			) emit Execution(transactionId);
234 			else {
235 				emit ExecutionFailure(transactionId);
236 				txn.executed = false;
237 			}
238 		}
239 	}
240 
241 	// call has been separated into its own function in order to take advantage
242 	// of the Solidity's code generator to produce a loop that copies tx.data into memory.
243 	function external_call(
244 		address destination,
245 		uint256 value,
246 		uint256 dataLength,
247 		bytes memory data
248 	) private returns (bool) {
249 		bool result;
250 		assembly {
251 			let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
252 			let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
253 			result := call(
254 				sub(gas, 34710), // 34710 is the value that solidity is currently emitting
255 				// It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
256 				// callNewAccountGas (25000, in case the destination address does not exist and needs creating)
257 				destination,
258 				value,
259 				d,
260 				dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
261 				x,
262 				0 // Output is ignored, therefore the output size is zero
263 			)
264 		}
265 		return result;
266 	}
267 
268 	/// @dev Returns the confirmation status of a transaction.
269 	/// @param transactionId Transaction ID.
270 	/// @return Confirmation status.
271 	function isConfirmed(uint256 transactionId) public view returns (bool) {
272 		uint256 count = 0;
273 		for (uint256 i = 0; i < owners.length; i++) {
274 			if (confirmations[transactionId][owners[i]]) count += 1;
275 			if (count == required) return true;
276 		}
277 	}
278 
279 	/*
280 	 * Internal functions
281 	 */
282 	/// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
283 	/// @param destination Transaction target address.
284 	/// @param value Transaction ether value.
285 	/// @param data Transaction data payload.
286 	/// @return Returns transaction ID.
287 	function addTransaction(
288 		address destination,
289 		uint256 value,
290 		bytes memory data
291 	) internal notNull(destination) returns (uint256 transactionId) {
292 		transactionId = transactionCount;
293 		transactions[transactionId] = Transaction({
294 			destination: destination,
295 			value: value,
296 			data: data,
297 			executed: false
298 		});
299 		transactionCount += 1;
300 		emit Submission(transactionId);
301 	}
302 
303 	/*
304 	 * Web3 call functions
305 	 */
306 	/// @dev Returns number of confirmations of a transaction.
307 	/// @param transactionId Transaction ID.
308 	/// @return Number of confirmations.
309 	function getConfirmationCount(uint256 transactionId)
310 		public
311 		view
312 		returns (uint256 count)
313 	{
314 		for (uint256 i = 0; i < owners.length; i++)
315 			if (confirmations[transactionId][owners[i]]) count += 1;
316 	}
317 
318 	/// @dev Returns total number of transactions after filers are applied.
319 	/// @param pending Include pending transactions.
320 	/// @param executed Include executed transactions.
321 	/// @return Total number of transactions after filters are applied.
322 	function getTransactionCount(bool pending, bool executed)
323 		public
324 		view
325 		returns (uint256 count)
326 	{
327 		for (uint256 i = 0; i < transactionCount; i++)
328 			if (
329 				(pending && !transactions[i].executed) ||
330 				(executed && transactions[i].executed)
331 			) count += 1;
332 	}
333 
334 	/// @dev Returns list of owners.
335 	/// @return List of owner addresses.
336 	function getOwners() public view returns (address[] memory) {
337 		return owners;
338 	}
339 
340 	/// @dev Returns array with owner addresses, which confirmed transaction.
341 	/// @param transactionId Transaction ID.
342 	/// @return Returns array of owner addresses.
343 	function getConfirmations(uint256 transactionId)
344 		public
345 		view
346 		returns (address[] memory _confirmations)
347 	{
348 		address[] memory confirmationsTemp = new address[](owners.length);
349 		uint256 count = 0;
350 		uint256 i;
351 		for (i = 0; i < owners.length; i++)
352 			if (confirmations[transactionId][owners[i]]) {
353 				confirmationsTemp[count] = owners[i];
354 				count += 1;
355 			}
356 		_confirmations = new address[](count);
357 		for (i = 0; i < count; i++) _confirmations[i] = confirmationsTemp[i];
358 	}
359 
360 	/// @dev Returns list of transaction IDs in defined range.
361 	/// @param from Index start position of transaction array.
362 	/// @param to Index end position of transaction array.
363 	/// @param pending Include pending transactions.
364 	/// @param executed Include executed transactions.
365 	/// @return Returns array of transaction IDs.
366 	function getTransactionIds(
367 		uint256 from,
368 		uint256 to,
369 		bool pending,
370 		bool executed
371 	) public view returns (uint256[] memory _transactionIds) {
372 		uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
373 		uint256 count = 0;
374 		uint256 i;
375 		for (i = 0; i < transactionCount; i++)
376 			if (
377 				(pending && !transactions[i].executed) ||
378 				(executed && transactions[i].executed)
379 			) {
380 				transactionIdsTemp[count] = i;
381 				count += 1;
382 			}
383 		_transactionIds = new uint256[](to - from);
384 		for (i = from; i < to; i++)
385 			_transactionIds[i - from] = transactionIdsTemp[i];
386 	}
387 }