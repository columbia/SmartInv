1 // Proxy mint for InPeak allowing to claim NFTs for users having pledged so far.
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
101 }
102 
103 contract InPeakProxyMint is Ownable {
104     IERC721Pledge public inPeakContract;
105     uint256 public price = 0.08 ether;
106     uint256 public fee = 250;
107     mapping(address => bool) public allowed;
108     mapping(address => bool) public claimed;
109 
110     constructor(IERC721Pledge inPeakContract_) {
111         inPeakContract = inPeakContract_;
112     }
113 
114     modifier callerIsUser() {
115         require(tx.origin == msg.sender, "The caller is another contract");
116         _;
117     }
118 
119     function mint() external payable callerIsUser {
120         require(allowed[msg.sender] && !claimed[msg.sender], "You are not allowed to mint or have already minted");
121         require(msg.value == price, "Wrong amount");
122         claimed[msg.sender] = true;
123 
124         uint256 pmRevenue = (price * fee) / 10000;
125         inPeakContract.pledgeMint{ value: price - pmRevenue }(msg.sender, 1);
126     }
127 
128     function mintFor(address recipient) external payable onlyOwner {
129         inPeakContract.pledgeMint(recipient, 1);
130     }
131 
132     function setInPeakContract(IERC721Pledge inPeakContract_) external onlyOwner {
133         inPeakContract = inPeakContract_;
134     }
135 
136     function setPrice(uint256 price_) external onlyOwner {
137         price = price_;
138     }
139 
140     function setFee(uint256 fee_) external onlyOwner {
141         fee = fee_;
142     }
143 
144     function allowAddresses(address[] calldata allowlist_)
145         external
146         onlyOwner
147     {
148         for (uint256 i; i < allowlist_.length; ) {
149             allowed[allowlist_[i]] = true;
150 
151             unchecked {
152                 ++i;
153             }
154         }
155     }
156 
157     function setAllowed(address wallet, bool isAllowed) 
158         external
159         onlyOwner
160     {
161         allowed[wallet] = isAllowed;
162     }
163 
164     function setClaimed(address wallet, bool isClaimed) 
165         external
166         onlyOwner
167     {
168         claimed[wallet] = isClaimed;
169     }
170 
171     // in case some funds end up stuck in the contract
172     function withdrawBalance() 
173         external
174         onlyOwner
175     {
176         (bool success, ) = msg.sender.call{value: address(this).balance}("");
177         require(success, "Transfer failed.");
178     }
179 
180     receive() external payable {}
181 }