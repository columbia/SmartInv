1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.9;
3 
4 /// @title Parts of Four Token
5 contract P4CToken {
6 	string public constant name = "Parts of Four Coin";
7 	string public constant symbol = "P4C";
8 	uint8 public constant decimals = 18;
9 
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13 	/// @notice The block number this contract was created in. Stored here so web3 scripts can easily access it and use
14 	/// @notice it to scan for InternalTransfer and NewRedistributedSupply events
15 	uint256 public immutable creationBlock;
16 
17 	/// @notice This determines whether the 3% is deducted from transactions.
18 	bool public deductTaxes = true;
19 
20 	/// @notice The original supply of P4C.
21 	uint256 public constant originalSupply = 4_000_000_000_000e18;
22 
23 	/// @notice The current supply of internal P4C. This goes down when funds are burnt, as well as when supply is
24 	/// @notice redistributed.
25 	uint256 public totalInternalSupply = originalSupply;
26 
27 	/// @notice This is the internal supply held in non-excluded addresses.
28 	uint256 public internalSupplyInNonExcludedAddresses;
29 
30 	// @notice This 1e18 times a factor that adjusts internal balances to external balances. For example, if an account
31 	// @notice has an internal balance of 1e18 and this factor is 1.5e18, the external balance of that account will be
32 	// @notice 1.5e18.
33 	uint256 public adjustmentFactor = 1e18;
34 
35 	// @notice The owner of the contract, set to the address that instantiated the contract. Only `contractOwner` may
36 	// @notice add or remove excluded addresses.
37 	address public immutable contractOwner;
38 
39 	// @notice This is a list of excluded addresses. Transfers involving these addresses don't have the 3% tax taken out
40 	// @notice of them, and they don't receive token redistribution (ie. their balances are adjusted downwards every
41 	// @notice time `adjustmentFactor` is increased.
42 	address[] public excludedAddresses;
43 	// @notice A map where addresses in `excludedAddresses` map to `true`.
44 	mapping (address => bool) excludedAddressesMap;
45 
46 	// @notice This is a mapping of addresses to the number of *internal* tokens they hold. This is *different* from the
47 	// @notice values that are used in contract calls, as those are adjusted by `adjustmentFactor`.
48 	mapping (address => uint256) public internalBalances;
49 
50 	// @notice This event is emitted when tokens are transferred from `_from` to `_to`. `_internalSentValue` is the
51 	// @notice number of internal tokens transferred *before* any fees are deducted (ie. the recipient will actually get
52 	// @notice 3% less unless `_from` or `_to` is an excluded address).
53 	event InternalTransfer(address _from, address _to, uint256 _internalSentValue);
54 	// @notice This event is fired when an excluded address is added.
55 	event AddedExcludedAddress(address _addr);
56 	// @notice This event is fired when an address is removed from the excluded address list.
57 	event RemovedExcludedAddress(address _addr);
58 	// @notice Called when deduct taxes setting is changed.
59 	event SetDeductTaxes(bool _enabled);
60 
61 	// Token authorisations. `_authorisee` can withdraw up to `allowed[_authoriser][_authroisee]` from `_authoriser`'s
62 	// account. Multiple transfers can be made so long as they do not cumulatively exceed the given amount. This is in
63 	// *EXTERNAL* tokens.
64 	mapping (address => mapping (address => uint256)) allowed;
65 
66 	constructor() {
67 		creationBlock = block.number;
68 		contractOwner = msg.sender;
69 		addExcludedAddress(msg.sender);
70 		internalBalances[contractOwner] = originalSupply;
71 	}
72 
73 	/// @notice Derive an external amount from an internal amount. (This will return a different result every time it's
74 	/// @notice called, as the amount it's being adjusted by changes when transfers are made.)
75 	function internalToExternalAmount(uint256 _internalAmount) view internal returns (uint256) {
76 		return (_internalAmount * adjustmentFactor) / 1e18;
77 	}
78 
79 	/// @notice Derive an internal amount from an external amount. (This will return a different result every time it's
80 	/// @notice called, as the amount it's being adjusted by changes when transfers are made.)
81 	function externalToInternalAmount(uint256 _externalAmount) view internal returns (uint256) {
82 		return (_externalAmount * 1e18) / adjustmentFactor;
83 	}
84 
85 	/// @notice The total external supply of the contract.
86 	function totalSupply() public view returns (uint256) {
87 		return internalToExternalAmount(totalInternalSupply);
88 	}
89 
90 	/// @notice Designate an address as excluded. Transactions to and from excluded addresses don't incur taxes, and
91 	/// @notice they don't receive token redistribution either (which in practice means that their balances are adjusted
92 	/// @notice downwards every time `adjustmentFactor` is increased). This may only be called by `contractOwner`.
93 	function addExcludedAddress(address _addr) public {
94 		require(msg.sender == contractOwner, "This function is callable only by the contract owner.");
95 		require(!excludedAddressesMap[_addr], "_addr is already an excluded address.");
96 
97 		internalSupplyInNonExcludedAddresses -= internalBalances[_addr];
98 		excludedAddressesMap[_addr] = true;
99 		excludedAddresses.push(_addr);
100 
101 		emit AddedExcludedAddress(_addr);
102 	}
103 
104 	/// @notice Remove the designation of excluded address from `_addr`.  Transactions to and from excluded addresses
105 	/// @notice don't incur taxes, and they don't receive token redistribution either (which in practice means that
106 	/// @notice their balances are adjusted downwards every time `adjustmentFactor` is increased). This may only be
107 	/// @notice called by `contractOwner`.
108 	function removeExcludedAddress(address _addr) public {
109 		require(msg.sender == contractOwner, "This function is callable only by the contract owner.");
110 		require(_addr != contractOwner, "contractOwner must be an excluded address for correct contract behaviour.");
111 		require(!!excludedAddressesMap[_addr], "_addr is not an excluded address.");
112 
113 		internalSupplyInNonExcludedAddresses += internalBalances[_addr];
114 		excludedAddressesMap[_addr] = false;
115 		for (uint i; i < excludedAddresses.length; i++) {
116 			if (excludedAddresses[i] == _addr) {
117 				if (i != excludedAddresses.length-1)
118 					excludedAddresses[i] = excludedAddresses[excludedAddresses.length-1];
119 
120 				excludedAddresses.pop();
121 				break;
122 			}
123 		}
124 
125 		emit RemovedExcludedAddress(_addr);
126 	}
127 
128 	/// @notice Set whether or not we deduct 3% from every transaction. This may only be called by `contractOwner`.
129 	function setDeductTaxes(bool _deductTaxes) public {
130 		require(msg.sender == contractOwner, "This function is callable only by the contract owner.");
131 		require(_deductTaxes != deductTaxes, "deductTaxes is already that value");
132 		deductTaxes = _deductTaxes;
133 		emit SetDeductTaxes(_deductTaxes);
134 	}
135 
136 	/// @notice Get the external balance of `_owner`.
137 	function balanceOf(address _owner) public view returns (uint256 balance) {
138 		return internalToExternalAmount(internalBalances[_owner]);
139 	}
140 
141 	/// @notice Approve `_spender` to remove up to `_value` in external tokens *at the time the withdraw happens* from
142 	/// @notice `msg.sender`'s account. Multiple withdraws may be made from a single `approve()` call so long as the
143 	/// @notice sum of the external values at the time of each individual call do not exceed `_value`.
144 	function approve(address _spender, uint256 _value) public returns (bool success) {
145 		allowed[msg.sender][_spender] = _value;
146 		emit Approval(msg.sender, _spender, _value);
147 		return true;
148 	}
149 
150 	/// @notice This returns the number of external tokens `_spender` is allowed to transfer on behalf of `_owner`.
151 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
152 		return allowed[_owner][_spender];
153 	}
154 
155 	/// @notice Transfer `_value` external tokens from `msg.sender`'s account to `_to`'s account. If neither
156 	/// @notice `msg.sender` nor `_to` are excluded addresses, `_to` will receive only 97% of `_value`. 1% will be
157 	/// @notice burned, 1% will be redistributed equally among non-excluded addresses, and 1% will be sent to
158 	/// @notice `contractOwner`.
159 	function transfer(address _to, uint256 _value) public returns (bool success) {
160 		return transferCommon(msg.sender, _to, _value);
161 	}
162 
163 	/// @notice Transfers `_value` from `_from` to `_to`, if `_from` has previously called `approve()` with the correct
164 	/// @notice arguments. Transfers work in the same way as `transfer()`.
165 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166 		require(allowed[_from][msg.sender] >= _value, "Sender has insufficient authorisation.");
167 		allowed[_from][msg.sender] -= _value;
168 
169 		return transferCommon(_from, _to, _value);
170 	}
171 
172 	/// @notice This transfers `_value` from `_from` to `_to`, WITHOUT CHECKING FOR AUTHORISATION.
173 	function transferCommon(address _from, address _to, uint256 _value) internal returns (bool success) {
174 		uint256 internalValue = externalToInternalAmount(_value);
175 		require(internalValue <= internalBalances[_from], "Transfer source has insufficient balance.");
176 
177 		uint256 internalReceivedValue;
178 		if (!excludedAddressesMap[_from] && !excludedAddressesMap[_to] && deductTaxes) {
179 			uint256 onePercent = internalValue / 100;
180 			internalReceivedValue = internalValue - onePercent * 3;
181 			internalSupplyInNonExcludedAddresses -= onePercent * 3;
182 
183 			// This is the adjustment resulting from just this transaction.
184 			uint256 readjustmentFactor =
185 				((internalSupplyInNonExcludedAddresses + onePercent) * 1e18) /
186 				internalSupplyInNonExcludedAddresses;
187 			adjustmentFactor = (adjustmentFactor * readjustmentFactor) / 1e18;
188 
189 			internalBalances[contractOwner] += onePercent;
190 
191 			uint256 removedFunds;
192 			for (uint i; i < excludedAddresses.length; i++) {
193 				// Because this is rounded down, excludedAddresses will slowly lose funds as more transactions are made.
194 				// However, due to the fact that transactions are expensive and we have such a high precision, this
195 				// doesn't make a difference in practice.
196 				uint256 oldBalance = internalBalances[excludedAddresses[i]];
197 				uint256 newBalance = ((oldBalance * 1e18) / readjustmentFactor);
198 				internalBalances[excludedAddresses[i]] = newBalance;
199 				removedFunds += oldBalance - newBalance;
200 			}
201 
202 			// Decrement the total supply by 2% of the transfer amount plus the internal amount that's been taken from
203 			// excludedAddresses.
204 			totalInternalSupply -= removedFunds + onePercent*2;
205 		} else {
206 			if (excludedAddressesMap[_from] && !excludedAddressesMap[_to])
207 				internalSupplyInNonExcludedAddresses += internalValue;
208 			if (!excludedAddressesMap[_from] && excludedAddressesMap[_to])
209 				internalSupplyInNonExcludedAddresses -= internalValue;
210 
211 			internalReceivedValue = internalValue;
212 		}
213 
214 		internalBalances[_to] += internalReceivedValue;
215 		internalBalances[_from] -= internalValue;
216 
217 		emit Transfer(_from, _to, _value);
218 		emit InternalTransfer(_from, _to, internalValue);
219 
220 		return true;
221 	}
222 }