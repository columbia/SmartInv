1 // SPDX-License-Identifier: MIT
2 
3 /*
4                 8888888888 888                   d8b
5                 888        888                   Y8P
6                 888        888
7                 8888888    888 888  888 .d8888b  888 888  888 88888b.d88b.
8                 888        888 888  888 88K      888 888  888 888 "888 "88b
9                 888        888 888  888 "Y8888b. 888 888  888 888  888  888
10                 888        888 Y88b 888      X88 888 Y88b 888 888  888  888
11                 8888888888 888  "Y88888  88888P' 888  "Y88888 888  888  888
12                                     888
13                                Y8b d88P
14                                 "Y88P"
15                 888b     d888          888              .d8888b.                888
16                 8888b   d8888          888             d88P  Y88b               888
17                 88888b.d88888          888             888    888               888
18                 888Y88888P888  .d88b.  888888  8888b.  888         .d88b.   .d88888 .d8888b
19                 888 Y888P 888 d8P  Y8b 888        "88b 888  88888 d88""88b d88" 888 88K
20                 888  Y8P  888 88888888 888    .d888888 888    888 888  888 888  888 "Y8888b.
21                 888   "   888 Y8b.     Y88b.  888  888 Y88b  d88P Y88..88P Y88b 888      X88
22                 888       888  "Y8888   "Y888 "Y888888  "Y8888P88  "Y88P"   "Y88888  88888P'
23 */
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _setOwner(_msgSender());
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _setOwner(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _setOwner(newOwner);
106     }
107 
108     function _setOwner(address newOwner) private {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Contract module which allows children to implement an emergency stop
119  * mechanism that can be triggered by an authorized account.
120  *
121  * This module is used through inheritance. It will make available the
122  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
123  * the functions of your contract. Note that they will not be pausable by
124  * simply including this module, only once the modifiers are put in place.
125  */
126 abstract contract Pausable is Context {
127     /**
128      * @dev Emitted when the pause is triggered by `account`.
129      */
130     event Paused(address account);
131 
132     /**
133      * @dev Emitted when the pause is lifted by `account`.
134      */
135     event Unpaused(address account);
136 
137     bool private _paused;
138 
139     /**
140      * @dev Initializes the contract in unpaused state.
141      */
142     constructor() {
143         _paused = false;
144     }
145 
146     /**
147      * @dev Returns true if the contract is paused, and false otherwise.
148      */
149     function paused() public view virtual returns (bool) {
150         return _paused;
151     }
152 
153     /**
154      * @dev Modifier to make a function callable only when the contract is not paused.
155      *
156      * Requirements:
157      *
158      * - The contract must not be paused.
159      */
160     modifier whenNotPaused() {
161         require(!paused(), "Pausable: paused");
162         _;
163     }
164 
165     /**
166      * @dev Modifier to make a function callable only when the contract is paused.
167      *
168      * Requirements:
169      *
170      * - The contract must be paused.
171      */
172     modifier whenPaused() {
173         require(paused(), "Pausable: not paused");
174         _;
175     }
176 
177     /**
178      * @dev Triggers stopped state.
179      *
180      * Requirements:
181      *
182      * - The contract must not be paused.
183      */
184     function _pause() internal virtual whenNotPaused {
185         _paused = true;
186         emit Paused(_msgSender());
187     }
188 
189     /**
190      * @dev Returns to normal state.
191      *
192      * Requirements:
193      *
194      * - The contract must be paused.
195      */
196     function _unpause() internal virtual whenPaused {
197         _paused = false;
198         emit Unpaused(_msgSender());
199     }
200 }
201 
202 pragma solidity ^0.8.0;
203 
204 interface IMintPass {
205     function balanceOf(address account, uint256 id) external view returns (uint256);
206 
207     function safeTransferFrom(
208         address from,
209         address to,
210         uint256 id,
211         uint256 amount,
212         bytes memory data
213     ) external;
214 }
215 
216 interface IToken {
217     function add(address wallet, uint256 amount) external;
218 }
219 
220 contract MetaGodsMintPassStaking is Ownable, Pausable {
221 
222     mapping(address => uint256) public numberOfStakedPassesByWallet;
223     mapping(address => uint256) public lastClaimDateByWallet;
224 
225     address public mintPassContractAddress;
226     address public godTokenContractAddress;
227 
228     uint256 public mintPassYield;
229 
230     function stakePasses(uint256 amount_) external whenNotPaused {
231 
232         require(IMintPass(mintPassContractAddress).balanceOf(msg.sender, 0) >= amount_, "TOO MANY");
233 
234         if (numberOfStakedPassesByWallet[msg.sender] != 0) {
235             IToken(godTokenContractAddress).add(msg.sender, calculateMetaPassesYield(msg.sender));
236         }
237 
238         lastClaimDateByWallet[msg.sender] = block.timestamp;
239 
240         numberOfStakedPassesByWallet[msg.sender] += amount_;
241 
242         IMintPass(mintPassContractAddress).safeTransferFrom(msg.sender, address(this), 0, amount_, "");
243     }
244 
245     function unStakePasses(uint256 amount_) external whenNotPaused {
246 
247         require(amount_ <= numberOfStakedPassesByWallet[msg.sender], "TOO MANY");
248 
249         IToken(godTokenContractAddress).add(msg.sender, calculateMetaPassesYield(msg.sender));
250 
251         lastClaimDateByWallet[msg.sender] = block.timestamp;
252 
253         numberOfStakedPassesByWallet[msg.sender] -= amount_;
254 
255         IMintPass(mintPassContractAddress).safeTransferFrom(address(this), msg.sender, 0, amount_, "");
256     }
257 
258     function claimPassesYield(address wallet_) external whenNotPaused {
259 
260         IToken(godTokenContractAddress).add(wallet_, calculateMetaPassesYield(msg.sender));
261 
262         lastClaimDateByWallet[msg.sender] = block.timestamp;
263     }
264 
265     function calculateMetaPassesYield(address wallet_) public view returns (uint256) {
266         return (block.timestamp - lastClaimDateByWallet[wallet_]) *
267         numberOfStakedPassesByWallet[wallet_] *
268         mintPassYield / 1 days;
269     }
270 
271     function setMintPassContract(address contractAddress_) external onlyOwner {
272         mintPassContractAddress = contractAddress_;
273     }
274 
275     function setGodTokenContract(address contractAddress_) external onlyOwner {
276         godTokenContractAddress = contractAddress_;
277     }
278 
279     function setMintPassYield(uint256 newMintPassYield_) external onlyOwner {
280         mintPassYield = newMintPassYield_;
281     }
282 
283     function pause() external onlyOwner {
284         _pause();
285     }
286 
287     function unpause() external onlyOwner {
288         _unpause();
289     }
290 
291     function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4) {
292         return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
293     }
294 
295 }