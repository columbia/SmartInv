1 // Proxy mint for Culture Cubs allowing to mint at presale price, following decision to lower public mint price.
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.4;
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
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _transferOwnership(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Internal function without access restriction.
89      */
90     function _transferOwnership(address newOwner) internal virtual {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 interface IERC721Pledge {
98     function pledgeMint(address to, uint8 quantity)
99         external
100         payable;
101     function numberMinted(address owner)
102         external
103         view
104         returns (uint256);
105 }
106 
107 contract CCubsProxyMint is Ownable {
108     uint256 public constant PRESALE_PRICE = 0.13 ether;
109     IERC721Pledge public ccubsContract;
110     uint public maxPerWallet = 10;
111 
112     constructor(IERC721Pledge ccubsContract_) {
113         ccubsContract = ccubsContract_;
114     }
115 
116     modifier callerIsUser() {
117         require(tx.origin == msg.sender, "The caller is another contract");
118         _;
119     }
120 
121     function publicMint(uint8 quantity) external payable callerIsUser {
122         require(ccubsContract.numberMinted(msg.sender) + quantity <= maxPerWallet, "cannot mint this quantity");
123         ccubsContract.pledgeMint{ value: PRESALE_PRICE * quantity }(msg.sender, quantity);
124         refundIfOver(PRESALE_PRICE * quantity);
125     }
126 
127     function refundIfOver(uint256 price) private {
128         require(msg.value >= price, "Need to send more ETH.");
129         if (msg.value > price) {
130             payable(msg.sender).transfer(msg.value - price);
131         }
132     }
133 
134     function setCcubsContract(IERC721Pledge ccubsContract_) external onlyOwner {
135         ccubsContract = ccubsContract_;
136     }
137 
138     function setMaxPerWallet(uint maxPerWallet_) external onlyOwner {
139         maxPerWallet = maxPerWallet_;
140     }
141 
142     function numberMinted(address minter)
143         external
144         view
145         returns (uint256) {
146         return ccubsContract.numberMinted(minter);
147     }
148 }