1 // Sources flattened with hardhat v2.17.1 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
6 
7 // Original license: SPDX_License_Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
34 
35 // Original license: SPDX_License_Identifier: MIT
36 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby disabling any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File contracts/EspressoRevenueShare.sol
119 
120 // Original license: SPDX_License_Identifier: MIT
121 pragma solidity ^0.8.9;
122 
123 contract EspressoRevenueShare is Ownable {
124     bool public redeemEnabled = false;
125     mapping(address => uint256) public holding;
126     mapping(address => bool) public allowing;
127 
128     event RedeemEvent(address indexed user, uint256 amount);
129 
130     constructor(address[] memory _addresses, uint256[] memory _holding, bool[] memory _allowing) {
131         updateState(_addresses, _holding, _allowing);
132     }
133 
134     receive() external payable {}
135 
136     function updateState(address[] memory _addresses, uint256[] memory _holding, bool[] memory _allowing) public onlyOwner {
137         require(_addresses.length == _holding.length,"Input arrays must have the same length");
138         require(_holding.length == _allowing.length,"Input arrays must have the same length");
139         for (uint256 i = 0; i < _addresses.length; i++) {
140             holding[_addresses[i]] = _holding[i];
141             allowing[_addresses[i]] = _allowing[i];
142         }
143     }
144 
145     function updateHolding(address[] memory _addresses, uint256[] memory _holding) public onlyOwner {
146         require(_addresses.length == _holding.length, "Input arrays must have the same length");
147         for (uint256 i = 0; i < _addresses.length; i++) {
148             holding[_addresses[i]] = _holding[i];
149         }
150     }
151 
152     function updateAllowing(address[] memory _addresses, bool[] memory _allowing) public onlyOwner {
153         require(_addresses.length == _allowing.length,"Input arrays must have the same length");
154         for (uint256 i = 0; i < _addresses.length; i++) {
155             allowing[_addresses[i]] = _allowing[i];
156         }
157     }
158 
159     function updateRedeemStatus(bool enabled) public onlyOwner {
160         redeemEnabled = enabled;
161     }
162 
163     function redeem() public {
164         require(redeemEnabled, "Redeem not enabled");
165         require(allowing[msg.sender], "Address not allowed");
166         uint256 amount = holding[msg.sender];
167         require(amount > 0, "Amount insufficient");
168         holding[msg.sender] = 0;
169         (bool sent, ) = payable(msg.sender).call{value: amount}("");
170         require(sent, "Failed to send amount");
171         emit RedeemEvent(msg.sender, amount);
172     }
173 
174     function withdraw(uint256 amount) public onlyOwner {
175         require(amount <= address(this).balance, "Insufficient contract balance");
176         (bool sent, ) = payable(msg.sender).call{value: amount}("");
177         require(sent, "Failed to send amount");
178     }
179 }