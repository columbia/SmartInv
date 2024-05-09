1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @title ERC721 token receiver interface
7  * @dev Interface for any contract that wants to support safeTransfers
8  * from ERC721 asset contracts.
9  */
10 interface IERC721Receiver {
11     /**
12      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
13      * by `operator` from `from`, this function is called.
14      *
15      * It must return its Solidity selector to confirm the token transfer.
16      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
17      *
18      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
19      */
20     function onERC721Received(
21         address operator,
22         address from,
23         uint256 tokenId,
24         bytes calldata data
25     ) external returns (bytes4);
26 }
27 
28 
29 /**
30  * @dev Implementation of the {IERC721Receiver} interface.
31  *
32  * Accepts all token transfers.
33  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
34  */
35 contract ERC721Holder is IERC721Receiver {
36     /**
37      * @dev See {IERC721Receiver-onERC721Received}.
38      *
39      * Always returns `IERC721Receiver.onERC721Received.selector`.
40      */
41     function onERC721Received(
42         address,
43         address,
44         uint256,
45         bytes memory
46     ) public virtual override returns (bytes4) {
47         return this.onERC721Received.selector;
48     }
49 }
50 
51 
52 /**
53  * @dev Provides information about the current execution context, including the
54  * sender of the transaction and its data. While these are generally available
55  * via msg.sender and msg.data, they should not be accessed in such a direct
56  * manner, since when dealing with meta-transactions the account sending and
57  * paying for execution may not be the actual sender (as far as an application
58  * is concerned).
59  *
60  * This contract is only required for intermediate, library-like contracts.
61  */
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address) {
64         return msg.sender;
65     }
66 
67     function _msgData() internal view virtual returns (bytes calldata) {
68         return msg.data;
69     }
70 }
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _setOwner(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _setOwner(newOwner);
130     }
131 
132     function _setOwner(address newOwner) private {
133         address oldOwner = _owner;
134         _owner = newOwner;
135         emit OwnershipTransferred(oldOwner, newOwner);
136     }
137 }
138 
139 
140 abstract contract OGB {
141     function ownerOf(uint256 tokenId) public virtual view returns (address);
142     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual;
143 }
144 
145 abstract contract EVB {
146     function ownerOf(uint256 tokenId) public virtual view returns (address);
147     function getTimeVaulted(uint256 tokenId) external virtual view returns(uint256);
148 }
149 
150 contract OG_Vault is ERC721Holder, Ownable {
151     OGB private ogb;
152     EVB private evb;
153     uint256 public releaseDay = 1665874800; // 15 October 2022 7PM EST
154     bool public releaseIsActive = false;
155 
156     event ClaimedMultiple(address _from, uint256[] _tokenIds);
157     event Claimed(address _from, uint256 _tokenId);
158 
159     constructor() {
160         ogb = OGB(0x3a8778A58993bA4B941f85684D74750043A4bB5f);
161         evb = EVB(0x6069a6C32cf691F5982FEbAe4fAf8a6f3AB2F0F6);
162     }
163 
164     function flipReleaseState() public onlyOwner {
165         releaseIsActive = !releaseIsActive;
166     }
167 
168     function claimBull(uint256 tokenId) public {
169         require(releaseIsActive, "OG Bulls will be available to be claimed on 15 Oct. 2022 7PM EST");
170         require(evb.ownerOf(tokenId) == msg.sender, "You must own the Evolved Bull of the Bull you're trying to claim");
171 
172         ogb.safeTransferFrom(address(this), msg.sender, tokenId);
173         emit Claimed(msg.sender, tokenId);
174     }
175 
176     function claimNBulls(uint256[] memory tokenIds) public {
177         require(releaseIsActive, "OG Bulls will be available to be claimed on 15 Oct. 2022 7PM EST");
178         require(tokenIds.length < 21, "Can't claim more than 20 bulls at once.");
179 
180         for (uint i = 0; i < tokenIds.length; i++) {
181             require(evb.ownerOf(tokenIds[i]) == msg.sender, "You must own the Evolved Bull of the Bull you're trying to claim");
182 
183             ogb.safeTransferFrom(address(this), msg.sender, tokenIds[i]);
184         }
185         emit ClaimedMultiple(msg.sender, tokenIds);
186     }
187 
188     function setEvolvedBullContract(address _address) external onlyOwner{
189         evb = EVB(_address);
190     }
191 }