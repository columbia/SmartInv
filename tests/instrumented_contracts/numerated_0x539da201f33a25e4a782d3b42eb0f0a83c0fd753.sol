1 pragma solidity 0.5.2;
2 
3 // File: contracts/MultiSigWallet.sol
4 
5 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
6 /// @author Stefan George - <stefan.george@consensys.net>
7 contract MultiSigWallet {
8 
9 	uint constant public MAX_OWNER_COUNT = 50;
10 
11 	event Confirmation(address indexed sender, uint indexed transactionId);
12 	event Revocation(address indexed sender, uint indexed transactionId);
13 	event Submission(uint indexed transactionId);
14 	event Execution(uint indexed transactionId);
15 	event ExecutionFailure(uint indexed transactionId);
16 	event Deposit(address indexed sender, uint value);
17 	event OwnerAddition(address indexed owner);
18 	event OwnerRemoval(address indexed owner);
19 	event RequirementChange(uint required);
20 
21 	mapping (uint => Transaction) public transactions;
22 	mapping (uint => mapping (address => bool)) public confirmations;
23 	mapping (address => bool) public isOwner;
24 	address[] public owners;
25 	uint public required;
26 	uint public transactionCount;
27 
28 	struct Transaction {
29 		address destination;
30 		uint value;
31 		bytes data;
32 		bool executed;
33 	}
34 
35 	modifier onlyWallet() {
36 		if (msg.sender != address(this))
37 			revert();
38 		_;
39 	}
40 
41 	modifier ownerDoesNotExist(address owner) {
42 		if (isOwner[owner])
43 			revert();
44 		_;
45 	}
46 
47 	modifier ownerExists(address owner) {
48 		if (!isOwner[owner])
49 			revert();
50 		_;
51 	}
52 
53 	modifier transactionExists(uint transactionId) {
54 		if (transactions[transactionId].destination == address(0))
55 			revert();
56 		_;
57 	}
58 
59 	modifier confirmed(uint transactionId, address owner) {
60 		if (!confirmations[transactionId][owner])
61 			revert();
62 		_;
63 	}
64 
65 	modifier notConfirmed(uint transactionId, address owner) {
66 		if (confirmations[transactionId][owner])
67 			revert();
68 		_;
69 	}
70 
71 	modifier notExecuted(uint transactionId) {
72 		if (transactions[transactionId].executed)
73 			revert();
74 		_;
75 	}
76 
77 	modifier notNull(address _address) {
78 		if (_address == address(0))
79 			revert();
80 		_;
81 	}
82 
83 	modifier validRequirement(uint ownerCount, uint _required) {
84 		if (   ownerCount > MAX_OWNER_COUNT
85 			|| _required > ownerCount
86 				|| _required == 0
87 					|| ownerCount == 0)
88 					revert();
89 					_;
90 	}
91 
92 	/// @dev Fallback function allows to deposit ether.
93 	function()
94 	external
95 	payable
96 	{
97 		if (msg.value > 0)
98 			emit Deposit(msg.sender, msg.value);
99 	}
100 
101 	/*
102 	* Public functions
103 	*/
104 	/// @dev Contract constructor sets initial owners and required number of confirmations.
105 	/// @param _owners List of initial owners.
106 	/// @param _required Number of required confirmations.
107 	constructor(address[] memory _owners, uint _required)
108 	public
109 	validRequirement(_owners.length, _required)
110 	{
111 		for (uint i=0; i<_owners.length; i++) {
112 			if (isOwner[_owners[i]] || _owners[i] == address(0))
113 				revert();
114 			isOwner[_owners[i]] = true;
115 		}
116 		owners = _owners;
117 		required = _required;
118 	}
119 
120 	/// @dev Allows to add a new owner. Transaction has to be sent by wallet.
121 	/// @param owner Address of new owner.
122 	function addOwner(address owner)
123 	public
124 	onlyWallet
125 	ownerDoesNotExist(owner)
126 	notNull(owner)
127 	validRequirement(owners.length + 1, required)
128 	{
129 		isOwner[owner] = true;
130 		owners.push(owner);
131 		emit OwnerAddition(owner);
132 	}
133 
134 	/// @dev Allows to remove an owner. Transaction has to be sent by wallet.
135 	/// @param owner Address of owner.
136 	function removeOwner(address owner)
137 	public
138 	onlyWallet
139 	ownerExists(owner)
140 	{
141 		isOwner[owner] = false;
142 		for (uint i=0; i<owners.length - 1; i++)
143 		if (owners[i] == owner) {
144 			owners[i] = owners[owners.length - 1];
145 			break;
146 		}
147 		owners.length -= 1;
148 		if (required > owners.length)
149 			changeRequirement(owners.length);
150 		emit OwnerRemoval(owner);
151 	}
152 
153 	/// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
154 	/// @param owner Address of owner to be replaced.
155 	/// @param owner Address of new owner.
156 	function replaceOwner(address owner, address newOwner)
157 	public
158 	onlyWallet
159 	ownerExists(owner)
160 	ownerDoesNotExist(newOwner)
161 	{
162 		for (uint i=0; i<owners.length; i++)
163 		if (owners[i] == owner) {
164 			owners[i] = newOwner;
165 			break;
166 		}
167 		isOwner[owner] = false;
168 		isOwner[newOwner] = true;
169 		emit OwnerRemoval(owner);
170 		emit OwnerAddition(newOwner);
171 	}
172 
173 	/// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
174 	/// @param _required Number of required confirmations.
175 	function changeRequirement(uint _required)
176 	public
177 	onlyWallet
178 	validRequirement(owners.length, _required)
179 	{
180 		required = _required;
181 		emit RequirementChange(_required);
182 	}
183 
184 	/// @dev Allows an owner to submit and confirm a transaction.
185 	/// @param destination Transaction target address.
186 	/// @param value Transaction ether value.
187 	/// @param data Transaction data payload.
188 	/// @return Returns transaction ID.
189 	function submitTransaction(address destination, uint value, bytes memory data)
190 	public
191 	returns (uint transactionId)
192 	{
193 		transactionId = addTransaction(destination, value, data);
194 		confirmTransaction(transactionId);
195 	}
196 
197 	/// @dev Allows an owner to confirm a transaction.
198 	/// @param transactionId Transaction ID.
199 	function confirmTransaction(uint transactionId)
200 	public
201 	ownerExists(msg.sender)
202 	transactionExists(transactionId)
203 	notConfirmed(transactionId, msg.sender)
204 	{
205 		confirmations[transactionId][msg.sender] = true;
206 		emit Confirmation(msg.sender, transactionId);
207 		executeTransaction(transactionId);
208 	}
209 
210 	/// @dev Allows an owner to revoke a confirmation for a transaction.
211 	/// @param transactionId Transaction ID.
212 	function revokeConfirmation(uint transactionId)
213 	public
214 	ownerExists(msg.sender)
215 	confirmed(transactionId, msg.sender)
216 	notExecuted(transactionId)
217 	{
218 		confirmations[transactionId][msg.sender] = false;
219 		emit Revocation(msg.sender, transactionId);
220 	}
221 
222 	/// @dev Allows anyone to execute a confirmed transaction.
223 	/// @param transactionId Transaction ID.
224 	function executeTransaction(uint transactionId)
225 	public
226 	notExecuted(transactionId)
227 	{
228 		if (isConfirmed(transactionId)) {
229 			Transaction storage transaction = transactions[transactionId];
230 			transaction.executed = true;
231 
232 			bool success;
233 			bytes memory _returnData;
234 			(success, _returnData) = transaction.destination.call.value(transaction.value)(transaction.data);
235 			if (success)
236 				emit Execution(transactionId);
237 			else {
238 				emit ExecutionFailure(transactionId);
239 				transaction.executed = false;
240 			}
241 		}
242 	}
243 
244 	/// @dev Returns the confirmation status of a transaction.
245 	/// @param transactionId Transaction ID.
246 	/// @return Confirmation status.
247 	function isConfirmed(uint transactionId)
248 	public
249 	view
250 	returns (bool)
251 	{
252 		uint count = 0;
253 		for (uint i=0; i<owners.length; i++) {
254 			if (confirmations[transactionId][owners[i]])
255 				count += 1;
256 			if (count == required)
257 				return true;
258 		}
259 	}
260 
261 	/*
262 	* Internal functions
263 	*/
264 	/// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
265 	/// @param destination Transaction target address.
266 	/// @param value Transaction ether value.
267 	/// @param data Transaction data payload.
268 	/// @return Returns transaction ID.
269 	function addTransaction(address destination, uint value, bytes memory data)
270 	internal
271 	notNull(destination)
272 	returns (uint transactionId)
273 	{
274 		transactionId = transactionCount;
275 		transactions[transactionId] = Transaction({
276 			destination: destination,
277 			value: value,
278 			data: data,
279 			executed: false
280 		});
281 		transactionCount += 1;
282 		emit Submission(transactionId);
283 	}
284 
285 	/*
286 	* Web3 call functions
287 	*/
288 	/// @dev Returns number of confirmations of a transaction.
289 	/// @param transactionId Transaction ID.
290 	/// @return Number of confirmations.
291 	function getConfirmationCount(uint transactionId)
292 	public
293 	view
294 	returns (uint count)
295 	{
296 		for (uint i=0; i<owners.length; i++)
297 		if (confirmations[transactionId][owners[i]])
298 			count += 1;
299 	}
300 
301 	/// @dev Returns total number of transactions after filers are applied.
302 	/// @param pending Include pending transactions.
303 	/// @param executed Include executed transactions.
304 	/// @return Total number of transactions after filters are applied.
305 	function getTransactionCount(bool pending, bool executed)
306 	public
307 	view
308 	returns (uint count)
309 	{
310 		for (uint i=0; i<transactionCount; i++)
311 		if (   pending && !transactions[i].executed
312 			|| executed && transactions[i].executed)
313 		count += 1;
314 	}
315 
316 	/// @dev Returns list of owners.
317 	/// @return List of owner addresses.
318 	function getOwners()
319 	public
320 	view
321 	returns (address[] memory)
322 	{
323 		return owners;
324 	}
325 
326 	/// @dev Returns array with owner addresses, which confirmed transaction.
327 	/// @param transactionId Transaction ID.
328 	/// @return Returns array of owner addresses.
329 	function getConfirmations(uint transactionId)
330 	public
331 	view
332 	returns (address[] memory _confirmations)
333 	{
334 		address[] memory confirmationsTemp = new address[](owners.length);
335 		uint count = 0;
336 		uint i;
337 		for (i=0; i<owners.length; i++)
338 		if (confirmations[transactionId][owners[i]]) {
339 			confirmationsTemp[count] = owners[i];
340 			count += 1;
341 		}
342 		_confirmations = new address[](count);
343 		for (i=0; i<count; i++)
344 		_confirmations[i] = confirmationsTemp[i];
345 	}
346 
347 	/// @dev Returns list of transaction IDs in defined range.
348 	/// @param from Index start position of transaction array.
349 	/// @param to Index end position of transaction array.
350 	/// @param pending Include pending transactions.
351 	/// @param executed Include executed transactions.
352 	/// @return Returns array of transaction IDs.
353 	function getTransactionIds(uint from, uint to, bool pending, bool executed)
354 	public
355 	view
356 	returns (uint[] memory _transactionIds)
357 	{
358 		uint[] memory transactionIdsTemp = new uint[](transactionCount);
359 		uint count = 0;
360 		uint i;
361 		for (i=0; i<transactionCount; i++)
362 		if (   pending && !transactions[i].executed
363 			|| executed && transactions[i].executed)
364 		{
365 			transactionIdsTemp[count] = i;
366 			count += 1;
367 		}
368 		_transactionIds = new uint[](to - from);
369 		for (i=from; i<to; i++)
370 		_transactionIds[i - from] = transactionIdsTemp[i];
371 	}
372 }