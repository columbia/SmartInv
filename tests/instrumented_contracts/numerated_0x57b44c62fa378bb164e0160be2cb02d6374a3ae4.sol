1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         _checkOwner();
64         _;
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if the sender is not the owner.
76      */
77     function _checkOwner() internal view virtual {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 pragma solidity >=0.8.9;
113 
114 
115 interface IMoney {
116 
117     event depostied (
118         address indexed depositor,
119         uint256 indexed timeDeposited,
120         uint256 amountDeposited
121     );
122 
123     event withdrew (
124         address indexed withdrewAddress,
125         uint256 indexed timeWithdrew,
126         uint256 amountWithdrawn
127     );
128 
129     function deposit() external payable;
130 
131     function withdraw() external payable;
132 }
133 
134 contract Competition is IMoney, Ownable {
135     function deposit() external payable {
136         require(msg.value > 0, "insufficient deposit amount");
137 
138         emit depostied(msg.sender, block.timestamp, msg.value);
139     }
140 
141     function withdraw() external payable onlyOwner {
142         uint256 amount = address(this).balance;
143 
144         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
145         require(os);
146 
147         emit withdrew(msg.sender, block.timestamp, amount);
148 
149     }
150 }