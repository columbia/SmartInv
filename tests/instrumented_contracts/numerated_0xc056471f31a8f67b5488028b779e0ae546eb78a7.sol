1 pragma solidity ^0.4.21;
2 
3 // File: contracts/LikeCoinInterface.sol
4 
5 //    Copyright (C) 2017 LikeCoin Foundation Limited
6 //
7 //    This file is part of LikeCoin Smart Contract.
8 //
9 //    LikeCoin Smart Contract is free software: you can redistribute it and/or modify
10 //    it under the terms of the GNU General Public License as published by
11 //    the Free Software Foundation, either version 3 of the License, or
12 //    (at your option) any later version.
13 //
14 //    LikeCoin Smart Contract is distributed in the hope that it will be useful,
15 //    but WITHOUT ANY WARRANTY; without even the implied warranty of
16 //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 //    GNU General Public License for more details.
18 //
19 //    You should have received a copy of the GNU General Public License
20 //    along with LikeCoin Smart Contract.  If not, see <http://www.gnu.org/licenses/>.
21 
22 pragma solidity ^0.4.18;
23 
24 contract LikeCoinInterface {
25 	function balanceOf(address _owner) public constant returns (uint256 balance);
26 	function transfer(address _to, uint256 _value) public returns (bool success);
27 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28 	function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 // File: contracts/Ownable.sol
32 
33 contract Ownable {
34 
35 	address public owner;
36 	address public pendingOwner;
37 	address public operator;
38 
39 	event OwnershipTransferred(
40 		address indexed previousOwner,
41 		address indexed newOwner
42 	);
43 
44 	/**
45 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46 	 * account.
47 	 */
48 	constructor() public {
49 		owner = msg.sender;
50 	}
51 
52 	/**
53 	 * @dev Throws if called by any account other than the owner.
54 	 */
55 	modifier onlyOwner() {
56 		require(msg.sender == owner);
57 		_;
58 	}
59 
60 	/**
61 	 * @dev Modifier throws if called by any account other than the pendingOwner.
62 	 */
63 	modifier onlyPendingOwner() {
64 		require(msg.sender == pendingOwner);
65 		_;
66 	}
67 
68 	modifier ownerOrOperator {
69 		require(msg.sender == owner || msg.sender == operator);
70 		_;
71 	}
72 
73 	/**
74 	 * @dev Allows the current owner to set the pendingOwner address.
75 	 * @param newOwner The address to transfer ownership to.
76 	 */
77 	function transferOwnership(address newOwner) onlyOwner public {
78 		pendingOwner = newOwner;
79 	}
80 
81 	/**
82 	 * @dev Allows the pendingOwner address to finalize the transfer.
83 	 */
84 	function claimOwnership() onlyPendingOwner public {
85 		emit OwnershipTransferred(owner, pendingOwner);
86 		owner = pendingOwner;
87 		pendingOwner = address(0);
88 	}
89 
90 	function setOperator(address _operator) onlyOwner public {
91 		operator = _operator;
92 	}
93 
94 }
95 
96 // File: contracts/ArtMuseumBase.sol
97 
98 contract ArtMuseumBase is Ownable {
99 
100 	struct Artwork {
101 		uint8 artworkType;
102 		uint32 sequenceNumber;
103 		uint128 value;
104 		address player;
105 	}
106 	LikeCoinInterface public like;
107 
108 	/** array holding ids mapping of the curret artworks*/
109 	uint32[] public ids;
110 	/** the last sequence id to be given to the link artwork **/
111 	uint32 public lastId;
112 	/** the id of the oldest artwork */
113 	uint32 public oldest;
114 	/** the artwork belonging to a given id */
115 	mapping(uint32 => Artwork) artworks;
116 	/** the user purchase sequence number per each artwork type */
117 	mapping(address=>mapping(uint8 => uint32)) userArtworkSequenceNumber;
118 	/** the cost of each artwork type */
119 	uint128[] public costs;
120 	/** the value of each artwork type (cost - fee), so it's not necessary to compute it each time*/
121 	uint128[] public values;
122 	/** the fee to be paid each time an artwork is bought in percent*/
123 	uint8 public fee;
124 
125 	/** total number of artworks in the game (uint32 because of multiplication issues) */
126 	uint32 public numArtworks;
127 	/** The maximum of artworks allowed in the game */
128 	uint16 public maxArtworks;
129 	/** number of artworks per type */
130 	uint32[] numArtworksXType;
131 
132 	/** initializes the contract parameters */
133 	function init(address _likeAddr) public onlyOwner {
134 		require(like==address(0));
135 		like = LikeCoinInterface(_likeAddr);
136 		costs = [800 ether, 2000 ether, 5000 ether, 12000 ether, 25000 ether];
137 		setFee(5);
138 		maxArtworks = 1000;
139 		lastId = 1;
140 		oldest = 0;
141 	}
142 
143 	function deposit() payable public {
144 
145 	}
146 
147 	function withdrawBalance() public onlyOwner returns(bool res) {
148 		owner.transfer(address(this).balance);
149 		return true;
150 	}
151 
152 	/**
153 	 * allows the owner to collect the accumulated fees
154 	 * sends the given amount to the owner's address if the amount does not exceed the
155 	 * fees (cannot touch the players' balances)
156 	 * */
157 	function collectFees(uint128 amount) public onlyOwner {
158 		uint collectedFees = getFees();
159 		if (amount <= collectedFees) {
160 			like.transfer(owner,amount);
161 		}
162 	}
163 
164 	function getArtwork(uint32 artworkId) public constant returns(uint8 artworkType, uint32 sequenceNumber, uint128 value, address player) {
165 		return (artworks[artworkId].artworkType, artworks[artworkId].sequenceNumber, artworks[artworkId].value, artworks[artworkId].player);
166 	}
167 
168 	function getAllArtworks() public constant returns(uint32[] artworkIds,uint8[] types,uint32[] sequenceNumbers, uint128[] artworkValues) {
169 		uint32 id;
170 		artworkIds = new uint32[](numArtworks);
171 		types = new uint8[](numArtworks);
172 		sequenceNumbers = new uint32[](numArtworks);
173 		artworkValues = new uint128[](numArtworks);
174 		for (uint16 i = 0; i < numArtworks; i++) {
175 			id = ids[i];
176 			artworkIds[i] = id;
177 			types[i] = artworks[id].artworkType;
178 			sequenceNumbers[i] = artworks[id].sequenceNumber;
179 			artworkValues[i] = artworks[id].value;
180 		}
181 	}
182 
183 	function getAllArtworksByOwner() public constant returns(uint32[] artworkIds,uint8[] types,uint32[] sequenceNumbers, uint128[] artworkValues) {
184 		uint32 id;
185 		uint16 j = 0;
186 		uint16 howmany = 0;
187 		address player = address(msg.sender);
188 		for (uint16 k = 0; k < numArtworks; k++) {
189 			if (artworks[ids[k]].player == player)
190 				howmany++;
191 		}
192 		artworkIds = new uint32[](howmany);
193 		types = new uint8[](howmany);
194 		sequenceNumbers = new uint32[](howmany);
195 		artworkValues = new uint128[](howmany);
196 		for (uint16 i = 0; i < numArtworks; i++) {
197 			if (artworks[ids[i]].player == player) {
198 				id = ids[i];
199 				artworkIds[j] = id;
200 				types[j] = artworks[id].artworkType;
201 				sequenceNumbers[j] = artworks[id].sequenceNumber;
202 				artworkValues[j] = artworks[id].value;
203 				j++;
204 			}
205 		}
206 	}
207 
208 	function setCosts(uint128[] _costs) public onlyOwner {
209 		require(_costs.length >= costs.length);
210 		costs = _costs;
211 		setFee(fee);
212 	}
213 	
214 	function setFee(uint8 _fee) public onlyOwner {
215 		fee = _fee;
216 		for (uint8 i = 0; i < costs.length; i++) {
217 			if (i < values.length)
218 				values[i] = costs[i] - costs[i] / 100 * fee;
219 			else {
220 				values.push(costs[i] - costs[i] / 100 * fee);
221 				numArtworksXType.push(0);
222 			}
223 		}
224 	}
225 
226 	function getFees() public constant returns(uint) {
227 		uint reserved = 0;
228 		for (uint16 j = 0; j < numArtworks; j++)
229 			reserved += artworks[ids[j]].value;
230 		return like.balanceOf(this) - reserved;
231 	}
232 
233 
234 }
235 
236 // File: contracts/ArtMuseum.sol
237 
238 contract ArtMuseum is ArtMuseumBase {
239 
240 	address private _currentImplementation;
241 
242 
243 	function updateImplementation(address _newImplementation) onlyOwner public {
244 		require(_newImplementation != address(0));
245 		_currentImplementation = _newImplementation;
246 	}
247 
248 	function implementation() public view returns (address) {
249 		return _currentImplementation;
250 	}
251 
252 	function () payable public {
253 		address _impl = implementation();
254 		require(_impl != address(0));
255 	/*
256 	assembly {
257 		// Copy msg.data. We take full control of memory in this inline assembly
258 		// block because it will not return to Solidity code. We overwrite the
259 		// Solidity scratch pad at memory position 0.
260 		calldatacopy(0, 0, calldatasize)
261 		// Call the implementation.
262 		// out and outsize are 0 because we don't know the size yet.
263 		let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
264 		// Copy the returned data.
265 		returndatacopy(0, 0, returndatasize)
266 		switch result
267 		// delegatecall returns 0 on error.
268 		case 0 { revert(0, returndatasize) }
269 		default { return(0, returndatasize) }
270 	}
271 	*/
272 		assembly {
273 			let ptr := mload(0x40)
274 			calldatacopy(ptr, 0, calldatasize)
275 			let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
276 			let size := returndatasize
277 			returndatacopy(ptr, 0, size)
278 			switch result
279 			case 0 { revert(ptr, size) }
280 			default { return(ptr, size) }
281 		}
282 	}
283 }