1 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title ERC721 token receiver interface
9  * @dev Interface for any contract that wants to support safeTransfers
10  * from ERC721 asset contracts.
11  */
12 interface IERC721Receiver {
13     /**
14      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
15      * by `operator` from `from`, this function is called.
16      *
17      * It must return its Solidity selector to confirm the token transfer.
18      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
19      *
20      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
21      */
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 // File: @openzeppelin/contracts/utils/Context.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         return msg.data;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/access/Ownable.sol
57 
58 
59 
60 pragma solidity ^0.8.0;
61 
62 
63 /**
64  * @dev Contract module which provides a basic access control mechanism, where
65  * there is an account (an owner) that can be granted exclusive access to
66  * specific functions.
67  *
68  * By default, the owner account will be the one that deploys the contract. This
69  * can later be changed with {transferOwnership}.
70  *
71  * This module is used through inheritance. It will make available the modifier
72  * `onlyOwner`, which can be applied to your functions to restrict their use to
73  * the owner.
74  */
75 abstract contract Ownable is Context {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev Initializes the contract setting the deployer as the initial owner.
82      */
83     constructor() {
84         _setOwner(_msgSender());
85     }
86 
87     /**
88      * @dev Returns the address of the current owner.
89      */
90     function owner() public view virtual returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(owner() == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     /**
103      * @dev Leaves the contract without owner. It will not be possible to call
104      * `onlyOwner` functions anymore. Can only be called by the current owner.
105      *
106      * NOTE: Renouncing ownership will leave the contract without an owner,
107      * thereby removing any functionality that is only available to the owner.
108      */
109     function renounceOwnership() public virtual onlyOwner {
110         _setOwner(address(0));
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         _setOwner(newOwner);
120     }
121 
122     function _setOwner(address newOwner) private {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Contract module that helps prevent reentrant calls to a function.
137  *
138  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
139  * available, which can be applied to functions to make sure there are no nested
140  * (reentrant) calls to them.
141  *
142  * Note that because there is a single `nonReentrant` guard, functions marked as
143  * `nonReentrant` may not call one another. This can be worked around by making
144  * those functions `private`, and then adding `external` `nonReentrant` entry
145  * points to them.
146  *
147  * TIP: If you would like to learn more about reentrancy and alternative ways
148  * to protect against it, check out our blog post
149  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
150  */
151 abstract contract ReentrancyGuard {
152     // Booleans are more expensive than uint256 or any type that takes up a full
153     // word because each write operation emits an extra SLOAD to first read the
154     // slot's contents, replace the bits taken up by the boolean, and then write
155     // back. This is the compiler's defense against contract upgrades and
156     // pointer aliasing, and it cannot be disabled.
157 
158     // The values being non-zero value makes deployment a bit more expensive,
159     // but in exchange the refund on every call to nonReentrant will be lower in
160     // amount. Since refunds are capped to a percentage of the total
161     // transaction's gas, it is best to keep them low in cases like this one, to
162     // increase the likelihood of the full refund coming into effect.
163     uint256 private constant _NOT_ENTERED = 1;
164     uint256 private constant _ENTERED = 2;
165 
166     uint256 private _status;
167 
168     constructor() {
169         _status = _NOT_ENTERED;
170     }
171 
172     /**
173      * @dev Prevents a contract from calling itself, directly or indirectly.
174      * Calling a `nonReentrant` function from another `nonReentrant`
175      * function is not supported. It is possible to prevent this from happening
176      * by making the `nonReentrant` function external, and make it call a
177      * `private` function that does the actual work.
178      */
179     modifier nonReentrant() {
180         // On the first call to nonReentrant, _notEntered will be true
181         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
182 
183         // Any calls to nonReentrant after this point will fail
184         _status = _ENTERED;
185 
186         _;
187 
188         // By storing the original value once again, a refund is triggered (see
189         // https://eips.ethereum.org/EIPS/eip-2200)
190         _status = _NOT_ENTERED;
191     }
192 }
193 
194 // File: rebelsnew.sol
195 
196 
197 pragma solidity ^0.8.7;
198 
199 
200 
201 
202 interface RebelsInDisguiseGenesis {
203     function transferOwnership(address newOwner) external;
204     function ownerMint(uint256 quantity) external;
205     function totalSupply() external view returns (uint256);
206     function owner() external view returns (address);
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 }
213 
214 contract RebelsMinter is Ownable, ReentrancyGuard, IERC721Receiver {
215     RebelsInDisguiseGenesis public rebelsGenesis;
216 
217     // cooldowns for free mints
218     mapping(address => uint256) public timeAllowedToMint; // cooldown map of user => timestamp#
219     uint256 public mintCooldownInSeconds = 60; // 1 minute
220 
221     uint256 public maxMintPerTx = 3;
222 
223     event FreeMint(address _addr, uint256 _nextTimeAllowed);
224 
225     error IllegalMintAmount();
226     error NotCurrentlyOwner();
227     error OnCooldown(uint256 timeAllowed);
228 
229     modifier whilstOwnedByMinter() {
230         if (rebelsGenesis.owner() != address(this)) revert NotCurrentlyOwner();
231         _;
232     }
233 
234     constructor(address _rebelsNft) {
235         rebelsGenesis = RebelsInDisguiseGenesis(_rebelsNft);
236     }
237 
238     function canMint(address _addr) public view returns (bool, uint256) {
239         return (
240             block.timestamp < timeAllowedToMint[_addr],
241             timeAllowedToMint[_addr]
242         );
243     }
244 
245     function freeMint(uint256 _amount) public whilstOwnedByMinter nonReentrant {
246         if (_amount == 0 || _amount > maxMintPerTx) revert IllegalMintAmount();
247 
248         (bool _onCd, uint256 _time) = canMint(msg.sender);
249         if (_onCd) revert OnCooldown(_time); // revert and give the time allowed to mint in error message
250         timeAllowedToMint[msg.sender] = block.timestamp + mintCooldownInSeconds; // set cooldown
251 
252         for (uint256 i = 0; i < _amount; i++) {
253             rebelsGenesis.ownerMint(1); // allow 1 only
254             uint256 _expectedId = rebelsGenesis.totalSupply();
255             rebelsGenesis.transferFrom(address(this), msg.sender, _expectedId);
256 
257             emit FreeMint(msg.sender, timeAllowedToMint[msg.sender]);
258         }
259     }
260 
261     function reclaimOwnership() external whilstOwnedByMinter onlyOwner {
262         rebelsGenesis.transferOwnership(msg.sender);
263     }
264 
265     function setMaxMintPerTx(uint256 _amount) external onlyOwner {
266         maxMintPerTx = _amount; 
267     }
268 
269     function setCooldownSeconds(uint256 _seconds) external onlyOwner {
270         mintCooldownInSeconds = _seconds;
271     }
272 
273     // required as we receive the item as a contract
274     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
275         return this.onERC721Received.selector;
276     }
277 }