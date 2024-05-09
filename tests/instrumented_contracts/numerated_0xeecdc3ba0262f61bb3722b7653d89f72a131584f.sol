1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 /**
23  * @dev Contract module which provides a basic access control mechanism, where
24  * there is an account (an owner) that can be granted exclusive access to
25  * specific functions.
26  *
27  * By default, the owner account will be the one that deploys the contract. This
28  * can later be changed with {transferOwnership}.
29  *
30  * This module is used through inheritance. It will make available the modifier
31  * `onlyOwner`, which can be applied to your functions to restrict their use to
32  * the owner.
33  */
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor() {
43         _setOwner(_msgSender());
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view virtual returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         _setOwner(address(0));
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Can only be called by the current owner.
75      */
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         _setOwner(newOwner);
79     }
80 
81     function _setOwner(address newOwner) private {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 library SafeMath {
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97 
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102 
103     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106 
107         return c;
108     }
109 
110 
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125 
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130 
131     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139 
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144 
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 }
150 interface nft{
151   function ownerOf(uint256 tokenId) external view returns (address owner);
152   function isApprovedForAll(address owner, address operator) external view returns (bool);
153   function safeTransferFrom(address from, address to, uint256 tokenId) external;
154 }
155 
156 interface IERC20 {
157 
158     function transfer(address recipient, uint256 amount) external returns (bool);
159     
160 }
161 
162 interface IERC721Receiver {
163     /**
164      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
165      * by `operator` from `from`, this function is called.
166      *
167      * It must return its Solidity selector to confirm the token transfer.
168      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
169      *
170      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
171      */
172     function onERC721Received(
173         address operator,
174         address from,
175         uint256 tokenId,
176         bytes calldata data
177     ) external returns (bytes4);
178 }
179 
180 contract exchange is IERC721Receiver,Ownable{
181     using SafeMath for uint256;
182     
183     event Change(uint256[] tokenIds,address user,uint256 amount);
184     
185     address public nftAddress;
186     address public tokenAddress;
187     uint256 public quantity = 59488e18;
188     bool public state = false;
189     uint256 public lockTime;
190     constructor(address nft_address,address token_address) Ownable(){
191         nftAddress = nft_address;
192         tokenAddress = token_address;
193         lockTime = 3600*24*365 + block.timestamp;
194     }
195     
196     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
197         return this.onERC721Received.selector;
198     }
199 
200     function change(uint256[] memory tokenIds) public{
201         require(state == true, "not yet open");
202         require(nft(nftAddress).isApprovedForAll(msg.sender, address(this)) == true, "transfer caller is not approved");
203         for(uint256 i = 0; i < tokenIds.length;i++){
204             require(nft(nftAddress).ownerOf(tokenIds[i]) == msg.sender, "transfer caller is not owner");
205             nft(nftAddress).safeTransferFrom(msg.sender,0x000000000000000000000000000000000000dEaD,tokenIds[i]);
206         }
207         uint256 amount = quantity.mul(tokenIds.length);
208         IERC20(tokenAddress).transfer(msg.sender,amount);
209         emit Change(tokenIds,msg.sender,amount);
210     }
211 
212     function setQuantity(uint256 amount) public onlyOwner{
213         quantity = amount;
214     }
215     function setState(bool _state) public onlyOwner{
216         state = _state;
217     }
218 
219     function withdraw(uint256 amount) public onlyOwner{
220         IERC20(tokenAddress).transfer(msg.sender,amount);
221     }
222 
223     function putNTF(address NFTAddress,uint256 tokenId) public onlyOwner{
224         nft(NFTAddress).safeTransferFrom(msg.sender,address(this),tokenId);
225     }
226     
227     function takeNFT(address NFTAddress,uint256 tokenId) public onlyOwner{
228         require(block.timestamp > lockTime, "lock time");
229         nft(NFTAddress).safeTransferFrom(address(this),msg.sender,tokenId);
230     }
231 
232 }