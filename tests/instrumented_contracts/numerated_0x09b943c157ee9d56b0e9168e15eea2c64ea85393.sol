1 /*
2 //    Copyright Countryside Company Limited
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 // File: contracts/Ownable.sol
8 
9 contract Ownable {
10 
11 	address public owner;
12 	address public pendingOwner;
13 	address public operator;
14 
15 	event OwnershipTransferred(
16 		address indexed previousOwner,
17 		address indexed newOwner
18 	);
19 
20 	/**
21 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22 	 * account.
23 	 */
24 	constructor() public {
25 		owner = msg.sender;
26 	}
27 
28 	/**
29 	 * @dev Throws if called by any account other than the owner.
30 	 */
31 	modifier onlyOwner() {
32 		require(msg.sender == owner);
33 		_;
34 	}
35 
36 	/**
37 	 * @dev Modifier throws if called by any account other than the pendingOwner.
38 	 */
39 	modifier onlyPendingOwner() {
40 		require(msg.sender == pendingOwner);
41 		_;
42 	}
43 
44 	modifier ownerOrOperator {
45 		require(msg.sender == owner || msg.sender == operator);
46 		_;
47 	}
48 
49 	/**
50 	 * @dev Allows the current owner to set the pendingOwner address.
51 	 * @param newOwner The address to transfer ownership to.
52 	 */
53 	function transferOwnership(address newOwner) onlyOwner public {
54 		pendingOwner = newOwner;
55 	}
56 
57 	/**
58 	 * @dev Allows the pendingOwner address to finalize the transfer.
59 	 */
60 	function claimOwnership() onlyPendingOwner public {
61 		emit OwnershipTransferred(owner, pendingOwner);
62 		owner = pendingOwner;
63 		pendingOwner = address(0);
64 	}
65 
66 	function setOperator(address _operator) onlyOwner public {
67 		operator = _operator;
68 	}
69 
70 }
71 
72 // File: contracts/LikeCoinInterface.sol
73 
74 contract LikeCoinInterface {
75 	function balanceOf(address _owner) public constant returns (uint256 balance);
76 	function transfer(address _to, uint256 _value) public returns (bool success);
77 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78 	function approve(address _spender, uint256 _value) public returns (bool success);
79 }
80 
81 // File: contracts/ArtMuseumBase.sol
82 
83 contract ArtMuseumBase is Ownable {
84 
85 	struct Artwork {
86 		uint8 artworkType;
87 		uint32 sequenceNumber;
88 		uint128 value;
89 		address player;
90 	}
91 	LikeCoinInterface public like;
92 
93 	/** array holding ids mapping of the curret artworks*/
94 	uint32[] public ids;
95 	/** the last sequence id to be given to the link artwork **/
96 	uint32 public lastId;
97 	/** the id of the oldest artwork */
98 	uint32 public oldest;
99 	/** the artwork belonging to a given id */
100 	mapping(uint32 => Artwork) artworks;
101 	/** the user purchase sequence number per each artwork type */
102 	mapping(address=>mapping(uint8 => uint32)) userArtworkSequenceNumber;
103 	/** the cost of each artwork type */
104 	uint128[] public costs;
105 	/** the value of each artwork type (cost - fee), so it's not necessary to compute it each time*/
106 	uint128[] public values;
107 	/** the fee to be paid each time an artwork is bought in percent*/
108 	uint8 public fee;
109 
110 	/** total number of artworks in the game (uint32 because of multiplication issues) */
111 	uint32 public numArtworks;
112 	/** The maximum of artworks allowed in the game */
113 	uint16 public maxArtworks;
114 	/** number of artworks per type */
115 	uint32[] numArtworksXType;
116 
117 	/** initializes the contract parameters */
118 	function init(address _likeAddr) public onlyOwner {
119 		require(like==address(0));
120 		like = LikeCoinInterface(_likeAddr);
121 		costs = [800 ether, 2000 ether, 5000 ether, 12000 ether, 25000 ether];
122 		setFee(5);
123 		maxArtworks = 1000;
124 		lastId = 1;
125 		oldest = 0;
126 	}
127 
128 	function deposit() payable public {
129 
130 	}
131 
132 	function withdrawBalance() public onlyOwner returns(bool res) {
133 		owner.transfer(address(this).balance);
134 		return true;
135 	}
136 
137 	/**
138 	 * allows the owner to collect the accumulated fees
139 	 * sends the given amount to the owner's address if the amount does not exceed the
140 	 * fees (cannot touch the players' balances)
141 	 * */
142 	function collectFees(uint128 amount) public onlyOwner {
143 		uint collectedFees = getFees();
144 		if (amount <= collectedFees) {
145 			like.transfer(owner,amount);
146 		}
147 	}
148 
149 	function getArtwork(uint32 artworkId) public constant returns(uint8 artworkType, uint32 sequenceNumber, uint128 value, address player) {
150 		return (artworks[artworkId].artworkType, artworks[artworkId].sequenceNumber, artworks[artworkId].value, artworks[artworkId].player);
151 	}
152 
153 	function getAllArtworks() public constant returns(uint32[] artworkIds,uint8[] types,uint32[] sequenceNumbers, uint128[] artworkValues) {
154 		uint32 id;
155 		artworkIds = new uint32[](numArtworks);
156 		types = new uint8[](numArtworks);
157 		sequenceNumbers = new uint32[](numArtworks);
158 		artworkValues = new uint128[](numArtworks);
159 		for (uint16 i = 0; i < numArtworks; i++) {
160 			id = ids[i];
161 			artworkIds[i] = id;
162 			types[i] = artworks[id].artworkType;
163 			sequenceNumbers[i] = artworks[id].sequenceNumber;
164 			artworkValues[i] = artworks[id].value;
165 		}
166 	}
167 
168 	function getAllArtworksByOwner() public constant returns(uint32[] artworkIds,uint8[] types,uint32[] sequenceNumbers, uint128[] artworkValues) {
169 		uint32 id;
170 		uint16 j = 0;
171 		uint16 howmany = 0;
172 		address player = address(msg.sender);
173 		for (uint16 k = 0; k < numArtworks; k++) {
174 			if (artworks[ids[k]].player == player)
175 				howmany++;
176 		}
177 		artworkIds = new uint32[](howmany);
178 		types = new uint8[](howmany);
179 		sequenceNumbers = new uint32[](howmany);
180 		artworkValues = new uint128[](howmany);
181 		for (uint16 i = 0; i < numArtworks; i++) {
182 			if (artworks[ids[i]].player == player) {
183 				id = ids[i];
184 				artworkIds[j] = id;
185 				types[j] = artworks[id].artworkType;
186 				sequenceNumbers[j] = artworks[id].sequenceNumber;
187 				artworkValues[j] = artworks[id].value;
188 				j++;
189 			}
190 		}
191 	}
192 
193 	function setCosts(uint128[] _costs) public onlyOwner {
194 		require(_costs.length >= costs.length);
195 		costs = _costs;
196 		setFee(fee);
197 	}
198 	
199 	function setFee(uint8 _fee) public onlyOwner {
200 		fee = _fee;
201 		for (uint8 i = 0; i < costs.length; i++) {
202 			if (i < values.length)
203 				values[i] = costs[i] - costs[i] / 100 * fee;
204 			else {
205 				values.push(costs[i] - costs[i] / 100 * fee);
206 				numArtworksXType.push(0);
207 			}
208 		}
209 	}
210 
211 	function getFees() public constant returns(uint) {
212 		uint reserved = 0;
213 		for (uint16 j = 0; j < numArtworks; j++)
214 			reserved += artworks[ids[j]].value;
215 		return like.balanceOf(this) - reserved;
216 	}
217 
218 	function getNumArtworksXType() public constant returns(uint32[] _numArtworksXType) {
219 		_numArtworksXType = numArtworksXType;
220 	}
221 
222 
223 }
224 
225 // File: contracts/ArtMuseum.sol
226 
227 contract ArtMuseum is ArtMuseumBase {
228 
229 	address private _currentImplementation;
230 
231 	function updateImplementation(address _newImplementation) onlyOwner public {
232 		require(_newImplementation != address(0));
233 		_currentImplementation = _newImplementation;
234 	}
235 
236 	function implementation() public view returns (address) {
237 		return _currentImplementation;
238 	}
239 
240 	function () payable public {
241 		address _impl = implementation();
242 		require(_impl != address(0));
243 		assembly {
244 			let ptr := mload(0x40)
245 			calldatacopy(ptr, 0, calldatasize)
246 			let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
247 			let size := returndatasize
248 			returndatacopy(ptr, 0, size)
249 			switch result
250 			case 0 { revert(ptr, size) }
251 			default { return(ptr, size) }
252 		}
253 	}
254 }