1 //sol Wallet
2 // Multi-sig, daily-limited account proxy/wallet.
3 // @authors:
4 // Gav Wood <g@ethdev.com>
5 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
6 // single, or, crucially, each of a number of, designated owners.
7 // usage:
8 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
9 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
10 // interior is executed.
11 
12 pragma solidity ^0.4.13;
13 
14 contract multiowned {
15 
16 	// TYPES
17 
18 	// struct for the status of a pending operation.
19 	struct PendingState {
20 		uint yetNeeded;
21 		uint ownersDone;
22 		uint index;
23 	}
24 
25 	// EVENTS
26 
27 	// this contract only has six types of events: it can accept a confirmation, in which case
28 	// we record owner and operation (hash) alongside it.
29 	event Confirmation(address owner, bytes32 operation);
30 	event Revoke(address owner, bytes32 operation);
31 	// some others are in the case of an owner changing.
32 	event OwnerChanged(address oldOwner, address newOwner);
33 	event OwnerAdded(address newOwner);
34 	event OwnerRemoved(address oldOwner);
35 	// the last one is emitted if the required signatures change
36 	event RequirementChanged(uint newRequirement);
37 
38 	// MODIFIERS
39 
40 	// simple single-sig function modifier.
41 	modifier onlyowner {
42 		if (isOwner(msg.sender))
43 			_;
44 	}
45 	// multi-sig function modifier: the operation must have an intrinsic hash in order
46 	// that later attempts can be realised as the same underlying operation and
47 	// thus count as confirmations.
48 	modifier onlymanyowners(bytes32 _operation) {
49 		if (confirmAndCheck(_operation))
50 			_;
51 	}
52 
53 	// METHODS
54 
55 	// constructor is given number of sigs required to do protected "onlymanyowners" transactions
56 	// as well as the selection of addresses capable of confirming them.
57 	function multiowned(address[] _owners, uint _required) {
58 		require(_required > 0);
59 		require(_owners.length >= _required);
60 		m_numOwners = _owners.length;
61 		for (uint i = 0; i < _owners.length; ++i) {
62 			m_owners[1 + i] = uint(_owners[i]);
63 			m_ownerIndex[uint(_owners[i])] = 1 + i;
64 		}
65 		m_required = _required;
66 	}
67 
68 	// Revokes a prior confirmation of the given operation
69 	function revoke(bytes32 _operation) external {
70 		uint ownerIndex = m_ownerIndex[uint(msg.sender)];
71 		// make sure they're an owner
72 		if (ownerIndex == 0) return;
73 		uint ownerIndexBit = 2**ownerIndex;
74 		var pending = m_pending[_operation];
75 		if (pending.ownersDone & ownerIndexBit > 0) {
76 			pending.yetNeeded++;
77 			pending.ownersDone -= ownerIndexBit;
78 			Revoke(msg.sender, _operation);
79 		}
80 	}
81 
82 	// Replaces an owner `_from` with another `_to`.
83 	function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
84 		if (isOwner(_to)) return;
85 		uint ownerIndex = m_ownerIndex[uint(_from)];
86 		if (ownerIndex == 0) return;
87 
88 		clearPending();
89 		m_owners[ownerIndex] = uint(_to);
90 		m_ownerIndex[uint(_from)] = 0;
91 		m_ownerIndex[uint(_to)] = ownerIndex;
92 		OwnerChanged(_from, _to);
93 	}
94 
95 	function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
96 		if (isOwner(_owner)) return;
97 
98 		clearPending();
99 		if (m_numOwners >= c_maxOwners)
100 			reorganizeOwners();
101 		if (m_numOwners >= c_maxOwners)
102 			return;
103 		m_numOwners++;
104 		m_owners[m_numOwners] = uint(_owner);
105 		m_ownerIndex[uint(_owner)] = m_numOwners;
106 		OwnerAdded(_owner);
107 	}
108 
109 	function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
110 		uint ownerIndex = m_ownerIndex[uint(_owner)];
111 		if (ownerIndex == 0) return;
112 		if (m_required > m_numOwners - 1) return;
113 
114 		m_owners[ownerIndex] = 0;
115 		m_ownerIndex[uint(_owner)] = 0;
116 		clearPending();
117 		reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
118 		OwnerRemoved(_owner);
119 	}
120 
121 	function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
122 		if (_newRequired == 0) return;
123 		if (_newRequired > m_numOwners) return;
124 		m_required = _newRequired;
125 		clearPending();
126 		RequirementChanged(_newRequired);
127 	}
128 
129 	// Gets an owner by 0-indexed position (using numOwners as the count)
130 	function getOwner(uint ownerIndex) external constant returns (address) {
131 		return address(m_owners[ownerIndex + 1]);
132 	}
133 
134 	function isOwner(address _addr) returns (bool) {
135 		return m_ownerIndex[uint(_addr)] > 0;
136 	}
137 
138 	function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
139 		var pending = m_pending[_operation];
140 		uint ownerIndex = m_ownerIndex[uint(_owner)];
141 
142 		// make sure they're an owner
143 		if (ownerIndex == 0) return false;
144 
145 		// determine the bit to set for this owner.
146 		uint ownerIndexBit = 2**ownerIndex;
147 		return !(pending.ownersDone & ownerIndexBit == 0);
148 	}
149 
150 	// INTERNAL METHODS
151 
152 	function confirmAndCheck(bytes32 _operation) internal returns (bool) {
153 		// determine what index the present sender is:
154 		uint ownerIndex = m_ownerIndex[uint(msg.sender)];
155 		// make sure they're an owner
156 		if (ownerIndex == 0) return;
157 
158 		var pending = m_pending[_operation];
159 		// if we're not yet working on this operation, switch over and reset the confirmation status.
160 		if (pending.yetNeeded == 0) {
161 			// reset count of confirmations needed.
162 			pending.yetNeeded = m_required;
163 			// reset which owners have confirmed (none) - set our bitmap to 0.
164 			pending.ownersDone = 0;
165 			pending.index = m_pendingIndex.length++;
166 			m_pendingIndex[pending.index] = _operation;
167 		}
168 		// determine the bit to set for this owner.
169 		uint ownerIndexBit = 2**ownerIndex;
170 		// make sure we (the message sender) haven't confirmed this operation previously.
171 		if (pending.ownersDone & ownerIndexBit == 0) {
172 			Confirmation(msg.sender, _operation);
173 			// ok - check if count is enough to go ahead.
174 			if (pending.yetNeeded == 1) {
175 				// enough confirmations: reset and run interior.
176 				delete m_pendingIndex[m_pending[_operation].index];
177 				delete m_pending[_operation];
178 				return true;
179 			}
180 			else
181 			{
182 				// not enough: record that this owner in particular confirmed.
183 				pending.yetNeeded--;
184 				pending.ownersDone |= ownerIndexBit;
185 			}
186 		}
187 	}
188 
189 	function reorganizeOwners() private {
190 		uint free = 1;
191 		while (free < m_numOwners)
192 		{
193 			while (free < m_numOwners && m_owners[free] != 0) free++;
194 			while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
195 			if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
196 			{
197 				m_owners[free] = m_owners[m_numOwners];
198 				m_ownerIndex[m_owners[free]] = free;
199 				m_owners[m_numOwners] = 0;
200 			}
201 		}
202 	}
203 
204 	function clearPending() internal {
205 		uint length = m_pendingIndex.length;
206 		for (uint i = 0; i < length; ++i)
207 			if (m_pendingIndex[i] != 0)
208 				delete m_pending[m_pendingIndex[i]];
209 		delete m_pendingIndex;
210 	}
211 
212 	// FIELDS
213 
214 	// the number of owners that must confirm the same operation before it is run.
215 	uint public m_required;
216 	// pointer used to find a free slot in m_owners
217 	uint public m_numOwners;
218 
219 	// list of owners
220 	uint[256] m_owners;
221 	uint constant c_maxOwners = 250;
222 	// index on the list of owners to allow reverse lookup
223 	mapping(uint => uint) m_ownerIndex;
224 	// the ongoing operations.
225 	mapping(bytes32 => PendingState) m_pending;
226 	bytes32[] m_pendingIndex;
227 }
228 
229 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
230 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
231 // uses is specified in the modifier.
232 contract daylimit is multiowned {
233 
234 	// METHODS
235 
236 	// constructor - stores initial daily limit and records the present day's index.
237 	function daylimit(uint _limit) {
238 		m_dailyLimit = _limit;
239 		m_lastDay = today();
240 	}
241 	// (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
242 	function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
243 		m_dailyLimit = _newLimit;
244 	}
245 	// resets the amount already spent today. needs many of the owners to confirm.
246 	function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
247 		m_spentToday = 0;
248 	}
249 
250 	// INTERNAL METHODS
251 
252 	// checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
253 	// returns true. otherwise just returns false.
254 	function underLimit(uint _value) internal onlyowner returns (bool) {
255 		// reset the spend limit if we're on a different day to last time.
256 		if (today() > m_lastDay) {
257 			m_spentToday = 0;
258 			m_lastDay = today();
259 		}
260 		// check to see if there's enough left - if so, subtract and return true.
261 		// overflow protection                    // dailyLimit check
262 		if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
263 			m_spentToday += _value;
264 			return true;
265 		}
266 		return false;
267 	}
268 	// determines today's index.
269 	function today() private constant returns (uint) { return now / 1 days; }
270 
271 	// FIELDS
272 
273 	uint public m_dailyLimit;
274 	uint public m_spentToday;
275 	uint public m_lastDay;
276 }
277 
278 // interface contract for multisig proxy contracts; see below for docs.
279 contract multisig {
280 
281 	// EVENTS
282 
283 	// logged events:
284 	// Funds has arrived into the wallet (record how much).
285 	event Deposit(address _from, uint value);
286 	// Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
287 	event SingleTransact(address owner, uint value, address to, bytes data, address created);
288 	// Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
289 	event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data, address created);
290 	// Confirmation still needed for a transaction.
291 	event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
292 
293 	// FUNCTIONS
294 
295 	// TODO: document
296 	function changeOwner(address _from, address _to) external;
297 	function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);
298 	function confirm(bytes32 _h) returns (bool o_success);
299 }
300 
301 contract creator {
302 	function doCreate(uint _value, bytes _code) internal returns (address o_addr) {
303 		bool failed;
304 		assembly {
305 			o_addr := create(_value, add(_code, 0x20), mload(_code))
306 			failed := iszero(extcodesize(o_addr))
307 		}
308 		require(!failed);
309 	}
310 }
311 
312 // usage:
313 // bytes32 h = Wallet(w).from(oneOwner).execute(to, value, data);
314 // Wallet(w).from(anotherOwner).confirm(h);
315 contract Wallet is multisig, multiowned, daylimit, creator {
316 
317 	// TYPES
318 
319 	// Transaction structure to remember details of transaction lest it need be saved for a later call.
320 	struct Transaction {
321 		address to;
322 		uint value;
323 		bytes data;
324 	}
325 
326 	// METHODS
327 
328 	// constructor - just pass on the owner array to the multiowned and
329 	// the limit to daylimit
330 	function Wallet(address[] _owners, uint _required, uint _daylimit)
331 			multiowned(_owners, _required) daylimit(_daylimit) {
332 	}
333 
334 	// kills the contract sending everything to `_to`.
335 	function kill(address _to) onlymanyowners(sha3(msg.data)) external {
336 		suicide(_to);
337 	}
338 
339 	// gets called when no other function matches
340 	function() payable {
341 		// just being sent some cash?
342 		if (msg.value > 0)
343 			Deposit(msg.sender, msg.value);
344 	}
345 
346 	// Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
347 	// If not, goes into multisig process. We provide a hash on return to allow the sender to provide
348 	// shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
349 	// and _data arguments). They still get the option of using them if they want, anyways.
350 	function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 o_hash) {
351 		// first, take the opportunity to check that we're under the daily limit.
352 		if ((_data.length == 0 && underLimit(_value)) || m_required == 1) {
353 			// yes - just execute the call.
354 			address created;
355 			if (_to == 0) {
356 				created = create(_value, _data);
357 			} else {
358 				require(_to.call.value(_value)(_data));
359 			}
360 			SingleTransact(msg.sender, _value, _to, _data, created);
361 		} else {
362 			// determine our operation hash.
363 			o_hash = sha3(msg.data, block.number);
364 			// store if it's new
365 			if (m_txs[o_hash].to == 0 && m_txs[o_hash].value == 0 && m_txs[o_hash].data.length == 0) {
366 				m_txs[o_hash].to = _to;
367 				m_txs[o_hash].value = _value;
368 				m_txs[o_hash].data = _data;
369 			}
370 			if (!confirm(o_hash)) {
371 				ConfirmationNeeded(o_hash, msg.sender, _value, _to, _data);
372 			}
373 		}
374 	}
375 
376 	function create(uint _value, bytes _code) internal returns (address o_addr) {
377 		return doCreate(_value, _code);
378 	}
379 
380 	// confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
381 	// to determine the body of the transaction from the hash provided.
382 	function confirm(bytes32 _h) onlymanyowners(_h) returns (bool o_success) {
383 		if (m_txs[_h].to != 0 || m_txs[_h].value != 0 || m_txs[_h].data.length != 0) {
384 			address created;
385 			if (m_txs[_h].to == 0) {
386 				created = create(m_txs[_h].value, m_txs[_h].data);
387 			} else {
388 				require(m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data));
389 			}
390 
391 			MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data, created);
392 			delete m_txs[_h];
393 			return true;
394 		}
395 	}
396 
397 	// INTERNAL METHODS
398 
399 	function clearPending() internal {
400 		uint length = m_pendingIndex.length;
401 		for (uint i = 0; i < length; ++i)
402 			delete m_txs[m_pendingIndex[i]];
403 		super.clearPending();
404 	}
405 
406 	// FIELDS
407 
408 	// pending transactions we have at present.
409 	mapping (bytes32 => Transaction) m_txs;
410 }