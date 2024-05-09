1 // File: contracts/FrozenToken.sol
2 
3 /**
4  * Source Code first verified at https://etherscan.io on Wednesday, October 11, 2017
5  (UTC) */
6 
7 //! FrozenToken ECR20-compliant token contract
8 //! By Parity Technologies, 2017.
9 //! Released under the Apache Licence 2.
10 
11 pragma solidity ^0.5.0;
12 
13 // Owned contract.
14 contract Owned {
15 	modifier only_owner { require (msg.sender == owner, "Only owner"); _; }
16 
17 	event NewOwner(address indexed old, address indexed current);
18 
19 	function setOwner(address _new) public only_owner { emit NewOwner(owner, _new); owner = _new; }
20 
21 	address public owner;
22 }
23 
24 // FrozenToken, a bit like an ECR20 token (though not - as it doesn't
25 // implement most of the API).
26 // All token balances are generally non-transferable.
27 // All "tokens" belong to the owner (who is uniquely liquid) at construction.
28 // Liquid accounts can make other accounts liquid and send their tokens
29 // to other axccounts.
30 contract FrozenToken is Owned {
31 	event Transfer(address indexed from, address indexed to, uint256 value);
32 
33 	// this is as basic as can be, only the associated balance & allowances
34 	struct Account {
35 		uint balance;
36 		bool liquid;
37 	}
38 
39 	// constructor sets the parameters of execution, _totalSupply is all units
40 	constructor(uint _totalSupply, address _owner)
41         public
42 		when_non_zero(_totalSupply)
43 	{
44 		totalSupply = _totalSupply;
45 		owner = _owner;
46 		accounts[_owner].balance = totalSupply;
47 		accounts[_owner].liquid = true;
48 	}
49 
50 	// balance of a specific address
51 	function balanceOf(address _who) public view returns (uint256) {
52 		return accounts[_who].balance;
53 	}
54 
55 	// make an account liquid: only liquid accounts can do this.
56 	function makeLiquid(address _to)
57 		public
58 		when_liquid(msg.sender)
59 		returns(bool)
60 	{
61 		accounts[_to].liquid = true;
62 		return true;
63 	}
64 
65 	// transfer
66 	function transfer(address _to, uint256 _value)
67 		public
68 		when_owns(msg.sender, _value)
69 		when_liquid(msg.sender)
70 		returns(bool)
71 	{
72 		emit Transfer(msg.sender, _to, _value);
73 		accounts[msg.sender].balance -= _value;
74 		accounts[_to].balance += _value;
75 
76 		return true;
77 	}
78 
79 	// no default function, simple contract only, entry-level users
80 	function() external {
81 		assert(false);
82 	}
83 
84 	// the balance should be available
85 	modifier when_owns(address _owner, uint _amount) {
86 		require (accounts[_owner].balance >= _amount);
87 		_;
88 	}
89 
90 	modifier when_liquid(address who) {
91 		require (accounts[who].liquid);
92 		_;
93 	}
94 
95 	// a value should be > 0
96 	modifier when_non_zero(uint _value) {
97 		require (_value > 0);
98 		_;
99 	}
100 
101 	// Available token supply
102 	uint public totalSupply;
103 
104 	// Storage and mapping of all balances & allowances
105 	mapping (address => Account) accounts;
106 
107 	// Conventional metadata.
108 	string public constant name = "DOT Allocation Indicator";
109 	string public constant symbol = "DOT";
110 	uint8 public constant decimals = 3;
111 }
112 
113 // File: contracts/Claims.sol
114 
115 pragma solidity 0.5.13;
116 
117 
118 /// @author Web3 Foundation
119 /// @title  Claims
120 ///         Allows allocations to be claimed to Polkadot public keys.
121 contract Claims is Owned {
122 
123     // The maximum number contained by the type `uint`. Used to freeze the contract from claims.
124     uint constant public UINT_MAX =  115792089237316195423570985008687907853269984665640564039457584007913129639935;
125 
126     struct Claim {
127         uint    index;          // Index for short address.
128         bytes32 pubKey;         // x25519 public key.
129         bool    hasIndex;       // Has the index been set?
130         uint    vested;         // Amount of allocation that is vested.
131     }
132 
133     // The address of the allocation indicator contract.
134     FrozenToken public allocationIndicator; // 0xb59f67A8BfF5d8Cd03f6AC17265c550Ed8F33907
135 
136     // The next index to be assigned.
137     uint public nextIndex;
138 
139     // Maps allocations to `Claim` data.
140     mapping (address => Claim) public claims;
141 
142     // A mapping from pubkey to the sale amount from second sale.
143     mapping (bytes32 => uint) public saleAmounts;
144 
145     // A mapping of pubkeys => an array of ethereum addresses that have made a claim for this pubkey.
146     // - Used for getting the balance. 
147     mapping (bytes32 => address[]) public claimsForPubkey;
148 
149     // Addresses that already claimed so we can easily grab them from state.
150     address[] public claimed;
151 
152     // Amended keys, old address => new address. New address is allowed to claim for old address.
153     mapping (address => address) public amended;
154 
155     // Block number that the set up delay ends.
156     uint public endSetUpDelay;
157 
158     // Event for when an allocation address amendment is made.
159     event Amended(address indexed original, address indexed amendedTo);
160     // Event for when an allocation is claimed to a Polkadot address.
161     event Claimed(address indexed eth, bytes32 indexed dot, uint indexed idx);
162     // Event for when an index is assigned to an allocation.
163     event IndexAssigned(address indexed eth, uint indexed idx);
164     // Event for when vesting is set on an allocation.
165     event Vested(address indexed eth, uint amount);
166     // Event for when vesting is increased on an account.
167     event VestedIncreased(address indexed eth, uint newTotal);
168     // Event that triggers when a new sale injection is made.
169     event InjectedSaleAmount(bytes32 indexed pubkey, uint newTotal);
170 
171     constructor(address _owner, address _allocations, uint _setUpDelay) public {
172         require(_owner != address(0x0), "Must provide an owner address.");
173         require(_allocations != address(0x0), "Must provide an allocations address.");
174         require(_setUpDelay > 0, "Must provide a non-zero argument to _setUpDelay.");
175 
176         owner = _owner;
177         allocationIndicator = FrozenToken(_allocations);
178         
179         endSetUpDelay = block.number + _setUpDelay;
180     }
181 
182     /// Allows owner to manually amend allocations to a new address that can claim.
183     /// @dev The given arrays must be same length and index must map directly.
184     /// @param _origs An array of original (allocation) addresses.
185     /// @param _amends An array of the new addresses which can claim those allocations.
186     function amend(address[] calldata _origs, address[] calldata _amends)
187         external
188         only_owner
189     {
190         require(
191             _origs.length == _amends.length,
192             "Must submit arrays of equal length."
193         );
194 
195         for (uint i = 0; i < _amends.length; i++) {
196             require(!hasClaimed(_origs[i]), "Address has already claimed.");
197             require(hasAllocation(_origs[i]), "Ethereum address has no DOT allocation.");
198             amended[_origs[i]] = _amends[i];
199             emit Amended(_origs[i], _amends[i]);
200         }
201     }
202 
203     /// Allows owner to manually toggle vesting onto allocations.
204     /// @param _eths The addresses for which to set vesting.
205     /// @param _vestingAmts The amounts that the accounts are vested.
206     function setVesting(address[] calldata _eths, uint[] calldata _vestingAmts)
207         external
208         only_owner
209     {
210         require(_eths.length == _vestingAmts.length, "Must submit arrays of equal length.");
211 
212         for (uint i = 0; i < _eths.length; i++) {
213             Claim storage claimData = claims[_eths[i]];
214             require(!hasClaimed(_eths[i]), "Account must not be claimed.");
215             require(claimData.vested == 0, "Account must not be vested already.");
216             require(_vestingAmts[i] != 0, "Vesting amount must be greater than zero.");
217             claimData.vested = _vestingAmts[i];
218             emit Vested(_eths[i], _vestingAmts[i]);
219         }
220     }
221 
222     /// Allows owner to increase the vesting on an allocation, whether it is claimed or not.
223     /// @param _eths The addresses for which to increase vesting.
224     /// @param _vestingAmts The amounts to increase the vesting for each account.
225     function increaseVesting(address[] calldata _eths, uint[] calldata _vestingAmts)
226         external
227         only_owner
228     {
229         require(_eths.length == _vestingAmts.length, "Must submit arrays of equal length.");
230 
231         for (uint i = 0; i < _eths.length; i++) {
232             Claim storage claimData = claims[_eths[i]];
233             // Does not require that the allocation is unclaimed.
234             // Does not require that vesting has already been set or not.
235             require(_vestingAmts[i] > 0, "Vesting amount must be greater than zero.");
236             uint oldVesting = claimData.vested;
237             uint newVesting = oldVesting + _vestingAmts[i];
238             // Check for overflow.
239             require(newVesting > oldVesting, "Overflow in addition.");
240             claimData.vested = newVesting;
241             emit VestedIncreased(_eths[i], newVesting);
242         }
243     }
244 
245     /// Allows owner to increase the `saleAmount` for a pubkey by the injected amount.
246     /// @param _pubkeys The public keys that will have their balances increased.
247     /// @param _amounts The amounts to increase the balance of pubkeys.
248     function injectSaleAmount(bytes32[] calldata _pubkeys, uint[] calldata _amounts)
249         external
250         only_owner
251     {
252         require(_pubkeys.length == _amounts.length);
253 
254         for (uint i = 0; i < _pubkeys.length; i++) {
255             bytes32 pubkey = _pubkeys[i];
256             uint amount = _amounts[i];
257 
258             // Checks that input is not zero.
259             require(amount > 0, "Must inject a sale amount greater than zero.");
260 
261             uint oldValue = saleAmounts[pubkey];
262             uint newValue = oldValue + amount;
263             // Check for overflow.
264             require(newValue > oldValue, "Overflow in addition");
265             saleAmounts[pubkey] = newValue;
266 
267             emit InjectedSaleAmount(pubkey, newValue);
268         }
269     }
270 
271     /// A helper function that allows anyone to check the balances of public keys.
272     /// @param _who The public key to check the balance of.
273     function balanceOfPubkey(bytes32 _who) public view returns (uint) {
274         address[] storage frozenTokenHolders = claimsForPubkey[_who];
275         if (frozenTokenHolders.length > 0) {
276             uint total;
277             for (uint i = 0; i < frozenTokenHolders.length; i++) {
278                 total += allocationIndicator.balanceOf(frozenTokenHolders[i]);
279             }
280             return total + saleAmounts[_who];
281         }
282         return saleAmounts[_who];
283     }
284 
285     /// Freezes the contract from any further claims.
286     /// @dev Protected by the `only_owner` modifier.
287     function freeze() external only_owner {
288         endSetUpDelay = UINT_MAX;
289     }
290 
291     /// Allows anyone to assign a batch of indices onto unassigned and unclaimed allocations.
292     /// @dev This function is safe because all the necessary checks are made on `assignNextIndex`.
293     /// @param _eths An array of allocation addresses to assign indices for.
294     /// @return bool True is successful.
295     function assignIndices(address[] calldata _eths)
296         external
297         protected_during_delay
298     {
299         for (uint i = 0; i < _eths.length; i++) {
300             require(assignNextIndex(_eths[i]), "Assigning the next index failed.");
301         }
302     }
303 
304     /// Claims an allocation associated with an `_eth` address to a `_pubKey` public key.
305     /// @dev Can only be called by the `_eth` address or the amended address for the allocation.
306     /// @param _eth The allocation address to claim.
307     /// @param _pubKey The Polkadot public key to claim.
308     /// @return True if successful.
309     function claim(address _eth, bytes32 _pubKey)
310         external
311         after_set_up_delay
312         has_allocation(_eth)
313         not_claimed(_eth)
314     {
315         require(_pubKey != bytes32(0), "Failed to provide an Ed25519 or SR25519 public key.");
316         
317         if (amended[_eth] != address(0x0)) {
318             require(amended[_eth] == msg.sender, "Address is amended and sender is not the amendment.");
319         } else {
320             require(_eth == msg.sender, "Sender is not the allocation address.");
321         }
322 
323         if (claims[_eth].index == 0 && !claims[_eth].hasIndex) {
324             require(assignNextIndex(_eth), "Assigning the next index failed.");
325         }
326 
327         claims[_eth].pubKey = _pubKey;
328         claimed.push(_eth);
329         claimsForPubkey[_pubKey].push(_eth);
330 
331         emit Claimed(_eth, _pubKey, claims[_eth].index);
332     }
333 
334     /// Get the length of `claimed`.
335     /// @return uint The number of accounts that have claimed.
336     function claimedLength()
337         external view returns (uint)
338     {   
339         return claimed.length;
340     }
341 
342     /// Get whether an allocation has been claimed.
343     /// @return bool True if claimed.
344     function hasClaimed(address _eth)
345         public view returns (bool)
346     {
347         return claims[_eth].pubKey != bytes32(0);
348     }
349 
350     /// Get whether an address has an allocation.
351     /// @return bool True if has a balance of FrozenToken.
352     function hasAllocation(address _eth)
353         public view returns (bool)
354     {
355         uint bal = allocationIndicator.balanceOf(_eth);
356         return bal > 0;
357     }
358 
359     /// Assings an index to an allocation address.
360     /// @dev Public function.
361     /// @param _eth The allocation address.
362     function assignNextIndex(address _eth)
363         has_allocation(_eth)
364         not_claimed(_eth)
365         internal returns (bool)
366     {
367         require(claims[_eth].index == 0, "Cannot reassign an index.");
368         require(!claims[_eth].hasIndex, "Address has already been assigned an index.");
369         uint idx = nextIndex;
370         nextIndex++;
371         claims[_eth].index = idx;
372         claims[_eth].hasIndex = true;
373         emit IndexAssigned(_eth, idx);
374         return true;
375     }
376 
377     /// @dev Requires that `_eth` address has DOT allocation.
378     modifier has_allocation(address _eth) {
379         require(hasAllocation(_eth), "Ethereum address has no DOT allocation.");
380         _;
381     }
382 
383     /// @dev Requires that `_eth` address has not claimed.
384     modifier not_claimed(address _eth) {
385         require(
386             claims[_eth].pubKey == bytes32(0),
387             "Account has already claimed."
388         );
389         _;
390     }
391 
392     /// @dev Requires that the function with this modifier is evoked after `endSetUpDelay`.
393     modifier after_set_up_delay {
394         require(
395             block.number >= endSetUpDelay,
396             "This function is only evocable after the setUpDelay has elapsed."
397         );
398         _;
399     }
400 
401     /// @dev Requires that the function with this modifier is evoked only by owner before `endSetUpDelay`.
402     modifier protected_during_delay {
403         if (block.number < endSetUpDelay) {
404             require(
405                 msg.sender == owner,
406                 "Only owner is allowed to call this function before the end of the set up delay."
407             );
408         }
409         _;
410     }
411 }