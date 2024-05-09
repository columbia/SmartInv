1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.2;
3 
4 interface IArtBlocksFactory {
5 	function tokenIdToProjectId(uint256 _tokenId) external view returns (uint256 projectId);
6 	function safeTransferFrom(address from, address to, uint256 tokenId) external;
7 }
8 
9 contract ArtBlocksBroker {
10 	IArtBlocksFactory public constant ARTBLOCKS_FACTORY = IArtBlocksFactory(0xa7d8d9ef8D8Ce8992Df33D8b8CF4Aebabd5bD270);
11 
12 	struct Order {
13 		uint128 priceInWeiEach;
14 		uint128 quantity;
15 	}
16 
17 	// user => projectID => Order
18 	mapping(address => mapping(uint256 => Order)) public orders;
19 	mapping(address => uint256) public balances; // for bots
20 
21 	address public coordinator;
22 	address public profitReceiver;
23 	uint256 public artBlocksBrokerFeeBips; // paid by bots, not users
24 
25 	modifier onlyCoordinator() {
26 		require(msg.sender == coordinator, 'not Coordinator');
27 		_;
28 	}
29 
30 	event Action(address indexed _user, uint256 indexed _artBlocksProjectId, uint256 _priceInWeiEach, uint256 _quantity, string _action, uint256 _optionalTokenId);
31 
32 	constructor(address _profitReceiver , uint256 _artBlocksBrokerFeeBips) {
33 		coordinator = msg.sender;
34 		profitReceiver = _profitReceiver;
35 		require(_artBlocksBrokerFeeBips < 10_000, 'fee too high');
36 		artBlocksBrokerFeeBips = _artBlocksBrokerFeeBips;
37 	}
38 
39 	// **************
40 	// USER FUNCTIONS
41 	// **************
42 
43 	function placeOrder(uint256 _artBlocksProjectId, uint128 _quantity) external payable {
44 		// CHECKS
45 		require(_artBlocksProjectId != 0, 'invalid AB id');
46 		require(msg.sender == tx.origin, 'we only mint to EOAs'); // removes user foot-guns and garuantees user can receive NFTs
47 		Order memory order = orders[msg.sender][_artBlocksProjectId];
48 		require(order.priceInWeiEach * order.quantity == 0, 'You already have an order for this ArtBlocks project. Please cancel the existing order before making a new one.');
49 		uint128 priceInWeiEach = uint128(msg.value) / _quantity;
50 		require(priceInWeiEach > 0, 'Zero wei offers not accepted.');
51 
52 		// EFFECTS
53 		orders[msg.sender][_artBlocksProjectId].priceInWeiEach = priceInWeiEach;
54 		orders[msg.sender][_artBlocksProjectId].quantity = _quantity;
55 
56 		emit Action(msg.sender, _artBlocksProjectId, priceInWeiEach, _quantity, 'order placed', 0);
57 	}
58 
59 	function cancelOrder(uint256 _artBlocksProjectId) external {
60 		// CHECKS
61 		Order memory order = orders[msg.sender][_artBlocksProjectId];
62 		uint256 amountToSendBack = order.priceInWeiEach * order.quantity;
63 		require(amountToSendBack != 0, 'You do not have an existing order for this ArtBlocks project.');
64 
65 		// EFFECTS
66 		delete orders[msg.sender][_artBlocksProjectId];
67 
68 		// INTERACTIONS
69 		sendValue(payable(msg.sender), amountToSendBack);
70 
71 		emit Action(msg.sender, _artBlocksProjectId, 0, 0, 'order cancelled', 0);
72 	}
73 
74 	// *************
75 	// BOT FUNCTIONS
76 	// *************
77 
78 	function fulfillOrder(address _user, uint256 _artBlocksProjectId, uint256 _tokenId, uint256 _expectedPriceInWeiEach, address _profitTo, bool _sendNow) public returns (uint256) {
79 		// CHECKS
80 		Order memory order = orders[_user][_artBlocksProjectId];
81 		require(order.quantity > 0, 'user order DNE');
82 		require(order.priceInWeiEach >= _expectedPriceInWeiEach, 'user offer insufficient'); // protects bots from users frontrunning them
83 		require(ARTBLOCKS_FACTORY.tokenIdToProjectId(_tokenId) == _artBlocksProjectId, 'user did not request this NFT');
84 
85 		// EFFECTS
86 		Order memory newOrder;
87 		if (order.quantity > 1) {
88 			newOrder.priceInWeiEach = order.priceInWeiEach;
89 			newOrder.quantity = order.quantity - 1;
90 		}
91 		orders[_user][_artBlocksProjectId] = newOrder;
92 
93 		uint256 artBlocksBrokerFee = order.priceInWeiEach * artBlocksBrokerFeeBips / 10_000;
94 		balances[profitReceiver] += artBlocksBrokerFee;
95 
96 		// INTERACTIONS
97 		// transfer NFT to user
98 		ARTBLOCKS_FACTORY.safeTransferFrom(msg.sender, _user, _tokenId); // reverts on failure
99 
100 		// pay the fullfiller
101 		if (_sendNow) {
102 			sendValue(payable(_profitTo), order.priceInWeiEach - artBlocksBrokerFee);
103 		} else {
104 			balances[_profitTo] += order.priceInWeiEach - artBlocksBrokerFee;
105 		}
106 
107 		emit Action(_user, _artBlocksProjectId, newOrder.priceInWeiEach, newOrder.quantity, 'order fulfilled', _tokenId);
108 
109 		return order.priceInWeiEach - artBlocksBrokerFee; // proceeds to order fullfiller
110 	}
111 
112 	function fulfillMultipleOrders(address[] memory _user, uint256[] memory _artBlocksProjectId, uint256[] memory _tokenId, uint256[] memory _expectedPriceInWeiEach, address[] memory _profitTo, bool[] memory _sendNow) external returns (uint256[] memory) {
113 		uint256[] memory output = new uint256[](_user.length);
114 		for (uint256 i = 0; i < _user.length; i++) {
115 			output[i] = fulfillOrder(_user[i], _artBlocksProjectId[i], _tokenId[i], _expectedPriceInWeiEach[i], _profitTo[i], _sendNow[i]);
116 		}
117 		return output;
118 	}
119 
120 	// *********************
121 	// COORDINATOR FUNCTIONS
122 	// *********************
123 
124 	function changeCoordinator(address _newCoordinator) external onlyCoordinator {
125 		coordinator = _newCoordinator;
126 	}
127 
128 	function changeProfitReceiver(address _newProfitReceiver) external onlyCoordinator {
129 		profitReceiver = _newProfitReceiver;
130 	}
131 
132 	function changeArtBlocksBrokerFeeBips(uint256 _newArtBlocksBrokerFeeBips) external onlyCoordinator {
133 		require(_newArtBlocksBrokerFeeBips < artBlocksBrokerFeeBips, 'fee can only ever be reduced');
134 		artBlocksBrokerFeeBips = _newArtBlocksBrokerFeeBips;
135 	}
136 
137 	// ******************
138 	// WITHDRAW FUNCTIONS
139 	// ******************
140 
141 	// for profitReceiver and bots
142 	function withdraw() external {
143 		uint256 amount = balances[msg.sender];
144 		delete balances[msg.sender];
145 		sendValue(payable(msg.sender), amount);
146 	}
147 
148 	// ****************
149 	// HELPER FUNCTIONS
150 	// ****************
151 
152 	// OpenZeppelin's sendValue function, used for transfering ETH out of this contract
153 	function sendValue(address payable recipient, uint256 amount) internal {
154 		require(address(this).balance >= amount, "Address: insufficient balance");
155 		// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
156 		(bool success, ) = recipient.call{ value: amount }("");
157 		require(success, "Address: unable to send value, recipient may have reverted");
158 	}
159 
160 	function viewOrder(address _user, uint256 _artBlocksProjectId) external view returns (Order memory) {
161 		return orders[_user][_artBlocksProjectId];
162 	}
163 
164 	function viewOrders(address[] memory _users, uint256[] memory _artBlocksProjectIds) external view returns (Order[] memory) {
165 		Order[] memory output = new Order[](_users.length);
166 		for (uint256 i = 0; i < _users.length; i++) output[i] = orders[_users[i]][_artBlocksProjectIds[i]];
167 		return output;
168 	}
169 }