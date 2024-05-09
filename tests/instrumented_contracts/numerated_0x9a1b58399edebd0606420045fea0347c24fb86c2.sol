1 pragma solidity 0.5.9;
2 
3 // File: contracts/FrozenToken.sol
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, October 11, 2017
7  (UTC) */
8 
9 //! FrozenToken ECR20-compliant token contract
10 //! By Parity Technologies, 2017.
11 //! Released under the Apache Licence 2.
12 
13 pragma solidity ^0.5.0;
14 
15 // Owned contract.
16 contract Owned {
17 	modifier only_owner { require (msg.sender == owner, "Only owner"); _; }
18 
19 	event NewOwner(address indexed old, address indexed current);
20 
21 	function setOwner(address _new) public only_owner { emit NewOwner(owner, _new); owner = _new; }
22 
23 	address public owner;
24 }
25 
26 // FrozenToken, a bit like an ECR20 token (though not - as it doesn't
27 // implement most of the API).
28 // All token balances are generally non-transferable.
29 // All "tokens" belong to the owner (who is uniquely liquid) at construction.
30 // Liquid accounts can make other accounts liquid and send their tokens
31 // to other axccounts.
32 contract FrozenToken is Owned {
33 	event Transfer(address indexed from, address indexed to, uint256 value);
34 
35 	// this is as basic as can be, only the associated balance & allowances
36 	struct Account {
37 		uint balance;
38 		bool liquid;
39 	}
40 
41 	// constructor sets the parameters of execution, _totalSupply is all units
42 	constructor(uint _totalSupply, address _owner)
43         public
44 		when_non_zero(_totalSupply)
45 	{
46 		totalSupply = _totalSupply;
47 		owner = _owner;
48 		accounts[_owner].balance = totalSupply;
49 		accounts[_owner].liquid = true;
50 	}
51 
52 	// balance of a specific address
53 	function balanceOf(address _who) public view returns (uint256) {
54 		return accounts[_who].balance;
55 	}
56 
57 	// make an account liquid: only liquid accounts can do this.
58 	function makeLiquid(address _to)
59 		public
60 		when_liquid(msg.sender)
61 		returns(bool)
62 	{
63 		accounts[_to].liquid = true;
64 		return true;
65 	}
66 
67 	// transfer
68 	function transfer(address _to, uint256 _value)
69 		public
70 		when_owns(msg.sender, _value)
71 		when_liquid(msg.sender)
72 		returns(bool)
73 	{
74 		emit Transfer(msg.sender, _to, _value);
75 		accounts[msg.sender].balance -= _value;
76 		accounts[_to].balance += _value;
77 
78 		return true;
79 	}
80 
81 	// no default function, simple contract only, entry-level users
82 	function() external {
83 		assert(false);
84 	}
85 
86 	// the balance should be available
87 	modifier when_owns(address _owner, uint _amount) {
88 		require (accounts[_owner].balance >= _amount);
89 		_;
90 	}
91 
92 	modifier when_liquid(address who) {
93 		require (accounts[who].liquid);
94 		_;
95 	}
96 
97 	// a value should be > 0
98 	modifier when_non_zero(uint _value) {
99 		require (_value > 0);
100 		_;
101 	}
102 
103 	// Available token supply
104 	uint public totalSupply;
105 
106 	// Storage and mapping of all balances & allowances
107 	mapping (address => Account) accounts;
108 
109 	// Conventional metadata.
110 	string public constant name = "DOT Allocation Indicator";
111 	string public constant symbol = "DOT";
112 	uint8 public constant decimals = 3;
113 }
114 
115 // File: contracts/Claims.sol
116 
117 /// @author Web3 Foundation
118 /// @title  Claims
119 ///         Allows allocations to be claimed to Polkadot public keys.
120 contract Claims is Owned {
121 
122     struct Claim {
123         uint    index;          // Index for short address.
124         bytes32 pubKey;         // Ed25519/SR25519 public key.
125         bool    hasIndex;       // Has the index been set?
126         uint    vested;         // Amount of allocation that is vested.
127     }
128 
129     // The address of the allocation indicator contract.
130     FrozenToken public allocationIndicator; // 0xb59f67A8BfF5d8Cd03f6AC17265c550Ed8F33907
131 
132     // The next index to be assigned.
133     uint public nextIndex;
134 
135     // Maps allocations to `Claim` data.
136     mapping (address => Claim) public claims;
137 
138     // Addresses that already claimed so we can easily grab them from state.
139     address[] public claimed;
140 
141     // Amended keys, old address => new address. New address is allowed to claim for old address.
142     mapping (address => address) public amended;
143 
144     // Event for when an allocation address amendment is made.
145     event Amended(address indexed original, address indexed amendedTo);
146     // Event for when an allocation is claimed to a Polkadot address.
147     event Claimed(address indexed eth, bytes32 indexed dot, uint indexed idx);
148     // Event for when an index is assigned to an allocation.
149     event IndexAssigned(address indexed eth, uint indexed idx);
150     // Event for when vesting is set on an allocation.
151     event Vested(address indexed eth, uint amount);
152 
153     constructor(address _owner, address _allocations) public {
154         require(_owner != address(0x0), "Must provide an owner address");
155         require(_allocations != address(0x0), "Must provide an allocations address");
156 
157         owner = _owner;
158         allocationIndicator = FrozenToken(_allocations);
159     }
160 
161     /// Allows owner to manually amend allocations to a new address that can claim.
162     /// @dev The given arrays must be same length and index must map directly.
163     /// @param _origs An array of original (allocation) addresses.
164     /// @param _amends An array of the new addresses which can claim those allocations.
165     function amend(address[] calldata _origs, address[] calldata _amends)
166         external
167         only_owner
168     {
169         require(
170             _origs.length == _amends.length,
171             "Must submit arrays of equal length."
172         );
173 
174         for (uint i = 0; i < _amends.length; i++) {
175             require(!hasClaimed(_origs[i]), "Address has already claimed");
176             amended[_origs[i]] = _amends[i];
177             emit Amended(_origs[i], _amends[i]);
178         }
179     }
180 
181     /// Allows owner to manually toggle vesting onto allocations.
182     /// @param _eths The addresses for which to set vesting.
183     /// @param _vestingAmts The amounts that the accounts are vested.
184     function setVesting(address[] calldata _eths, uint[] calldata _vestingAmts)
185         external
186         only_owner
187     {
188         require(_eths.length == _vestingAmts.length, "Must submit arrays of equal length");
189 
190         for (uint i = 0; i < _eths.length; i++) {
191             Claim storage claimData = claims[_eths[i]];
192             require(!hasClaimed(_eths[i]), "Account must not be claimed");
193             require(claimData.vested == 0, "Account must not be vested already");
194             require(_vestingAmts[i] != 0, "Vesting amount must be greater than zero");
195             claimData.vested = _vestingAmts[i];
196             emit Vested(_eths[i], _vestingAmts[i]);
197         }
198     }
199 
200     /// Allows anyone to assign a batch of indices onto unassigned and unclaimed allocations.
201     /// @dev This function is safe because all the necessary checks are made on `assignNextIndex`.
202     /// @param _eths An array of all€ocation addresses to assign indices for.
203     /// @return bool True is successful.
204     function assignIndices(address[] calldata _eths)
205         external
206     {
207         for (uint i = 0; i < _eths.length; i++) {
208             require(assignNextIndex(_eths[i]), "Assigning the next index failed");
209         }
210     }
211 
212     /// Claims an allocation associated with an `_eth` address to a `_pubKey` public key.
213     /// @dev Can only be called by the `_eth` address or the amended address for the allocation.
214     /// @param _eth The allocation address to claim.
215     /// @param _pubKey The Polkadot public key to claim.
216     /// @return True if successful.
217     function claim(address _eth, bytes32 _pubKey)
218         external
219         has_allocation(_eth)
220         not_claimed(_eth)
221     {
222         require(_pubKey != bytes32(0), "Failed to provide an Ed25519 or SR25519 public key");
223         
224         if (amended[_eth] != address(0x0)) {
225             require(amended[_eth] == msg.sender, "Address is amended and sender is not the amendment");
226         } else {
227             require(_eth == msg.sender, "Sender is not the allocation address");
228         }
229 
230         if (claims[_eth].index == 0 && !claims[_eth].hasIndex) {
231             require(assignNextIndex(_eth), "Assigning the next index failed");
232         }
233 
234         claims[_eth].pubKey = _pubKey;
235         claimed.push(_eth);
236 
237         emit Claimed(_eth, _pubKey, claims[_eth].index);
238     }
239 
240     /// Get the length of `claimed`.
241     /// @return uint The number of accounts that have claimed.
242     function claimedLength()
243         external view returns (uint)
244     {   
245         return claimed.length;
246     }
247 
248     /// Get whether an allocation has been claimed.
249     /// @return bool True if claimed.
250     function hasClaimed(address _eth)
251         has_allocation(_eth)
252         public view returns (bool)
253     {
254         return claims[_eth].pubKey != bytes32(0);
255     }
256 
257     /// Assings an index to an allocation address.
258     /// @dev Public function.
259     /// @param _eth The allocation address.
260     function assignNextIndex(address _eth)
261         has_allocation(_eth)
262         not_claimed(_eth)
263         internal returns (bool)
264     {
265         require(claims[_eth].index == 0, "Cannot reassign an index.");
266         require(!claims[_eth].hasIndex, "Address has already been assigned an index");
267         uint idx = nextIndex;
268         nextIndex++;
269         claims[_eth].index = idx;
270         claims[_eth].hasIndex = true;
271         emit IndexAssigned(_eth, idx);
272         return true;
273     }
274 
275     /// @dev Requires that `_eth` address has DOT allocation.
276     modifier has_allocation(address _eth) {
277         uint bal = allocationIndicator.balanceOf(_eth);
278         require(
279             bal > 0,
280             "Ethereum address has no DOT allocation"
281         );
282         _;
283     }
284 
285     /// @dev Requires that `_eth` address has not claimed.
286     modifier not_claimed(address _eth) {
287         require(
288             claims[_eth].pubKey == bytes32(0),
289             "Account has already claimed."
290         );
291         _;
292     }
293 }