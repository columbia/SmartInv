1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX0xooooooolooooooook0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk:,,,,,,,,,,,,,,,,,,,,ckNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk:,,,,,,,,,,,,,,,,,,,,,,,c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0l::::::::;;;;;;;;,,,,,,,,,dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO:,,,,,;::c::cc::::::::::::dXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;,,,,;::;;;;;::;;;;;;;;,;,oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk'.',,;,,,,,,,;;;,,,,,,,'':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx..',,,,,,,,,,,,,,,,,,;:,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx..::,,,,,,,,,,,,,,,;clo:.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx..cl:,,,,,,,,,,,,;:looc',OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc.,llc;,,,,,;;:clloool;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,.coolllllllloc:lol:'. .oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN00xc:::;.'cooooooooooo;'::'.''. .cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo:;;:oddddddoooooooooooooc:,'',;'..lONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo;cOKXNWMMMMWX0OOOOOOOOOOKNNXXXXXX0dc'.;xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXd;ckNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKo'.lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO,,kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl.;0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXd::kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl.lWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.lXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,.dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0;,kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk',0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.dNWMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMNO0NMMMMMMMXc'dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.cxO0KKKxOWMMMMMMMMMMMMMMMMMMMMMMMMMWd'cXMWWWWNKOo..kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk,.:oooodo:xWMMMMMMMMMMMMMMMMMMMMMMMMW0:..lOOkkkxool,.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc.:ooooooc;xWMMMMMMMMMMMMMMMMMMMMMMMMXc.;,.,coooooool'.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc.:ooooooc;xWMMMMMMMMMMMMMMMMMMMMMMMMXc'kK;.:oooooool'.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNc.,loooooc;xWMMMMMMMMMMMMMMMMMMMMMMMMXc'kWl.:oooooool'.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO,.,looooc;xWMMMMMMMMMMMMMMMMMMMMMMMMXc'k0,.:oooooool'.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk'..;clol;xWMMMMMMMMMMMMMMMMMMMMMMMMXc.;;.':oooooool,.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXd::c;,,'dWMMMMMMMMMMMMMMMMMMMMMMMMXc..';:looooool:';OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWKdc'lXMMMMMMMMMMMMMMMMMMMMMMMMXc.;clooooool:,:xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd.lXMMMMMMMMMMMMMMMMMMMMMMMXc;looooolc:,;kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNd,lXMMMMMMMMMMMMMMMMMMMMMMXc;oolc:,;ccxXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXc'lXMMMMMMMMMMMMMMMMMMMWXO:';,;:ox0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK;'dOOOOOOOOOOOOOOOOOOOkdl'.:d0NWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.cdddddddddddddddddddddo:',kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.cddddddxxxdxxdxxdddooool,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.:oooooodddxxxdddoooooool,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.:l::looooddxxddoooolccll:.'kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.:oc:;:lllooddoollc;;;:lol,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
44 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.:oool:;;;;;;,',;;::cloool,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
45 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:.:ooooollll;'..':llooooool;.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
46 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO,.cooooooool,..c:.:ooooooool;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
47 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,.:loooooool,..cXo.;ooooooooo;.cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
48 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO'.cooooooool'..dM0;.:ooooooooc,.dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
49 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk,.;loooooool;'cdKMMo.;loooooooo:.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
50 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,looooooooc.,0MMMMo.;loooooooo:.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
51 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo.,looooooooc.,0MMMMK:.;looooooo:.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
52 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk..:loooooooc,,dNMMMMMd.'looooooo:.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
53 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loooooooc,,xWMMMMMMd.'looooool;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
54 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,looooooo;.oMMMMMMMMXl.,looooo:.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
55 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loooooo:.,OMMMMMMMMMx.'cooooo;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
56 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loooooo;.oMMMMMMMMMMx.'cooooo;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
57 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loooolc''OMMMMMMMMMMx.'cooool;.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
58 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,looool'.oMMMMMMMMMMMx.'coool:.;KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
59 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loool;''xWWMMMMMMMMMx.'coool,.oMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
60 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,loooc,l0XXNWMMMMMMMMx.'cool:',kNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
61 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo.,looolldKXNNWMMMMMMMMx.'cool,:OXXXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
62 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx';loolcccxXNWMMMMMMMMMx.'coolcok0XXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
63 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xl:::lokKWMMMMMMMMMMMk',cllllclkXWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
64 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNNKOOOXNWWMMMMMMMMMMMMN0xolllld0NWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
65 */
66 
67 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Contract module that helps prevent reentrant calls to a function.
73  *
74  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
75  * available, which can be applied to functions to make sure there are no nested
76  * (reentrant) calls to them.
77  *
78  * Note that because there is a single `nonReentrant` guard, functions marked as
79  * `nonReentrant` may not call one another. This can be worked around by making
80  * those functions `private`, and then adding `external` `nonReentrant` entry
81  * points to them.
82  *
83  * TIP: If you would like to learn more about reentrancy and alternative ways
84  * to protect against it, check out our blog post
85  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
86  */
87 abstract contract ReentrancyGuard {
88     // Booleans are more expensive than uint256 or any type that takes up a full
89     // word because each write operation emits an extra SLOAD to first read the
90     // slot's contents, replace the bits taken up by the boolean, and then write
91     // back. This is the compiler's defense against contract upgrades and
92     // pointer aliasing, and it cannot be disabled.
93 
94     // The values being non-zero value makes deployment a bit more expensive,
95     // but in exchange the refund on every call to nonReentrant will be lower in
96     // amount. Since refunds are capped to a percentage of the total
97     // transaction's gas, it is best to keep them low in cases like this one, to
98     // increase the likelihood of the full refund coming into effect.
99     uint256 private constant _NOT_ENTERED = 1;
100     uint256 private constant _ENTERED = 2;
101 
102     uint256 private _status;
103 
104     constructor() {
105         _status = _NOT_ENTERED;
106     }
107 
108     /**
109      * @dev Prevents a contract from calling itself, directly or indirectly.
110      * Calling a `nonReentrant` function from another `nonReentrant`
111      * function is not supported. It is possible to prevent this from happening
112      * by making the `nonReentrant` function external, and making it call a
113      * `private` function that does the actual work.
114      */
115     modifier nonReentrant() {
116         // On the first call to nonReentrant, _notEntered will be true
117         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
118 
119         // Any calls to nonReentrant after this point will fail
120         _status = _ENTERED;
121 
122         _;
123 
124         // By storing the original value once again, a refund is triggered (see
125         // https://eips.ethereum.org/EIPS/eip-2200)
126         _status = _NOT_ENTERED;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Context.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes calldata) {
153         return msg.data;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/access/Ownable.sol
158 
159 
160 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 /**
166  * @dev Contract module which provides a basic access control mechanism, where
167  * there is an account (an owner) that can be granted exclusive access to
168  * specific functions.
169  *
170  * By default, the owner account will be the one that deploys the contract. This
171  * can later be changed with {transferOwnership}.
172  *
173  * This module is used through inheritance. It will make available the modifier
174  * `onlyOwner`, which can be applied to your functions to restrict their use to
175  * the owner.
176  */
177 abstract contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     /**
183      * @dev Initializes the contract setting the deployer as the initial owner.
184      */
185     constructor() {
186         _transferOwnership(_msgSender());
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         _checkOwner();
194         _;
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if the sender is not the owner.
206      */
207     function _checkOwner() internal view virtual {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: erc721a/contracts/IERC721A.sol
243 
244 
245 // ERC721A Contracts v4.1.0
246 // Creator: Chiru Labs
247 
248 pragma solidity ^0.8.4;
249 
250 /**
251  * @dev Interface of an ERC721A compliant contract.
252  */
253 interface IERC721A {
254     /**
255      * The caller must own the token or be an approved operator.
256      */
257     error ApprovalCallerNotOwnerNorApproved();
258 
259     /**
260      * The token does not exist.
261      */
262     error ApprovalQueryForNonexistentToken();
263 
264     /**
265      * The caller cannot approve to their own address.
266      */
267     error ApproveToCaller();
268 
269     /**
270      * Cannot query the balance for the zero address.
271      */
272     error BalanceQueryForZeroAddress();
273 
274     /**
275      * Cannot mint to the zero address.
276      */
277     error MintToZeroAddress();
278 
279     /**
280      * The quantity of tokens minted must be more than zero.
281      */
282     error MintZeroQuantity();
283 
284     /**
285      * The token does not exist.
286      */
287     error OwnerQueryForNonexistentToken();
288 
289     /**
290      * The caller must own the token or be an approved operator.
291      */
292     error TransferCallerNotOwnerNorApproved();
293 
294     /**
295      * The token must be owned by `from`.
296      */
297     error TransferFromIncorrectOwner();
298 
299     /**
300      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
301      */
302     error TransferToNonERC721ReceiverImplementer();
303 
304     /**
305      * Cannot transfer to the zero address.
306      */
307     error TransferToZeroAddress();
308 
309     /**
310      * The token does not exist.
311      */
312     error URIQueryForNonexistentToken();
313 
314     /**
315      * The `quantity` minted with ERC2309 exceeds the safety limit.
316      */
317     error MintERC2309QuantityExceedsLimit();
318 
319     /**
320      * The `extraData` cannot be set on an unintialized ownership slot.
321      */
322     error OwnershipNotInitializedForExtraData();
323 
324     struct TokenOwnership {
325         // The address of the owner.
326         address addr;
327         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
328         uint64 startTimestamp;
329         // Whether the token has been burned.
330         bool burned;
331         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
332         uint24 extraData;
333     }
334 
335     /**
336      * @dev Returns the total amount of tokens stored by the contract.
337      *
338      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
339      */
340     function totalSupply() external view returns (uint256);
341 
342     // ==============================
343     //            IERC165
344     // ==============================
345 
346     /**
347      * @dev Returns true if this contract implements the interface defined by
348      * `interfaceId`. See the corresponding
349      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
350      * to learn more about how these ids are created.
351      *
352      * This function call must use less than 30 000 gas.
353      */
354     function supportsInterface(bytes4 interfaceId) external view returns (bool);
355 
356     // ==============================
357     //            IERC721
358     // ==============================
359 
360     /**
361      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
367      */
368     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
369 
370     /**
371      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
372      */
373     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
374 
375     /**
376      * @dev Returns the number of tokens in ``owner``'s account.
377      */
378     function balanceOf(address owner) external view returns (uint256 balance);
379 
380     /**
381      * @dev Returns the owner of the `tokenId` token.
382      *
383      * Requirements:
384      *
385      * - `tokenId` must exist.
386      */
387     function ownerOf(uint256 tokenId) external view returns (address owner);
388 
389     /**
390      * @dev Safely transfers `tokenId` token from `from` to `to`.
391      *
392      * Requirements:
393      *
394      * - `from` cannot be the zero address.
395      * - `to` cannot be the zero address.
396      * - `tokenId` token must exist and be owned by `from`.
397      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
398      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
399      *
400      * Emits a {Transfer} event.
401      */
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId,
406         bytes calldata data
407     ) external;
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
411      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
412      *
413      * Requirements:
414      *
415      * - `from` cannot be the zero address.
416      * - `to` cannot be the zero address.
417      * - `tokenId` token must exist and be owned by `from`.
418      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
419      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
420      *
421      * Emits a {Transfer} event.
422      */
423     function safeTransferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429     /**
430      * @dev Transfers `tokenId` token from `from` to `to`.
431      *
432      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must be owned by `from`.
439      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
440      *
441      * Emits a {Transfer} event.
442      */
443     function transferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
451      * The approval is cleared when the token is transferred.
452      *
453      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
454      *
455      * Requirements:
456      *
457      * - The caller must own the token or be an approved operator.
458      * - `tokenId` must exist.
459      *
460      * Emits an {Approval} event.
461      */
462     function approve(address to, uint256 tokenId) external;
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
487      *
488      * See {setApprovalForAll}
489      */
490     function isApprovedForAll(address owner, address operator) external view returns (bool);
491 
492     // ==============================
493     //        IERC721Metadata
494     // ==============================
495 
496     /**
497      * @dev Returns the token collection name.
498      */
499     function name() external view returns (string memory);
500 
501     /**
502      * @dev Returns the token collection symbol.
503      */
504     function symbol() external view returns (string memory);
505 
506     /**
507      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
508      */
509     function tokenURI(uint256 tokenId) external view returns (string memory);
510 
511     // ==============================
512     //            IERC2309
513     // ==============================
514 
515     /**
516      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
517      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
518      */
519     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
520 }
521 
522 // File: erc721a/contracts/ERC721A.sol
523 
524 
525 // ERC721A Contracts v4.1.0
526 // Creator: Chiru Labs
527 
528 pragma solidity ^0.8.4;
529 
530 
531 /**
532  * @dev ERC721 token receiver interface.
533  */
534 interface ERC721A__IERC721Receiver {
535     function onERC721Received(
536         address operator,
537         address from,
538         uint256 tokenId,
539         bytes calldata data
540     ) external returns (bytes4);
541 }
542 
543 /**
544  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
545  * including the Metadata extension. Built to optimize for lower gas during batch mints.
546  *
547  * Assumes serials are sequentially minted starting at `_startTokenId()`
548  * (defaults to 0, e.g. 0, 1, 2, 3..).
549  *
550  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
551  *
552  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
553  */
554 contract ERC721A is IERC721A {
555     // Mask of an entry in packed address data.
556     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
557 
558     // The bit position of `numberMinted` in packed address data.
559     uint256 private constant BITPOS_NUMBER_MINTED = 64;
560 
561     // The bit position of `numberBurned` in packed address data.
562     uint256 private constant BITPOS_NUMBER_BURNED = 128;
563 
564     // The bit position of `aux` in packed address data.
565     uint256 private constant BITPOS_AUX = 192;
566 
567     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
568     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
569 
570     // The bit position of `startTimestamp` in packed ownership.
571     uint256 private constant BITPOS_START_TIMESTAMP = 160;
572 
573     // The bit mask of the `burned` bit in packed ownership.
574     uint256 private constant BITMASK_BURNED = 1 << 224;
575 
576     // The bit position of the `nextInitialized` bit in packed ownership.
577     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
578 
579     // The bit mask of the `nextInitialized` bit in packed ownership.
580     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
581 
582     // The bit position of `extraData` in packed ownership.
583     uint256 private constant BITPOS_EXTRA_DATA = 232;
584 
585     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
586     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
587 
588     // The mask of the lower 160 bits for addresses.
589     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
590 
591     // The maximum `quantity` that can be minted with `_mintERC2309`.
592     // This limit is to prevent overflows on the address data entries.
593     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
594     // is required to cause an overflow, which is unrealistic.
595     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
596 
597     // The tokenId of the next token to be minted.
598     uint256 private _currentIndex;
599 
600     // The number of tokens burned.
601     uint256 private _burnCounter;
602 
603     // Token name
604     string private _name;
605 
606     // Token symbol
607     string private _symbol;
608 
609     // Mapping from token ID to ownership details
610     // An empty struct value does not necessarily mean the token is unowned.
611     // See `_packedOwnershipOf` implementation for details.
612     //
613     // Bits Layout:
614     // - [0..159]   `addr`
615     // - [160..223] `startTimestamp`
616     // - [224]      `burned`
617     // - [225]      `nextInitialized`
618     // - [232..255] `extraData`
619     mapping(uint256 => uint256) private _packedOwnerships;
620 
621     // Mapping owner address to address data.
622     //
623     // Bits Layout:
624     // - [0..63]    `balance`
625     // - [64..127]  `numberMinted`
626     // - [128..191] `numberBurned`
627     // - [192..255] `aux`
628     mapping(address => uint256) private _packedAddressData;
629 
630     // Mapping from token ID to approved address.
631     mapping(uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping(address => mapping(address => bool)) private _operatorApprovals;
635 
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639         _currentIndex = _startTokenId();
640     }
641 
642     /**
643      * @dev Returns the starting token ID.
644      * To change the starting token ID, please override this function.
645      */
646     function _startTokenId() internal view virtual returns (uint256) {
647         return 0;
648     }
649 
650     /**
651      * @dev Returns the next token ID to be minted.
652      */
653     function _nextTokenId() internal view returns (uint256) {
654         return _currentIndex;
655     }
656 
657     /**
658      * @dev Returns the total number of tokens in existence.
659      * Burned tokens will reduce the count.
660      * To get the total number of tokens minted, please see `_totalMinted`.
661      */
662     function totalSupply() public view override returns (uint256) {
663         // Counter underflow is impossible as _burnCounter cannot be incremented
664         // more than `_currentIndex - _startTokenId()` times.
665         unchecked {
666             return _currentIndex - _burnCounter - _startTokenId();
667         }
668     }
669 
670     /**
671      * @dev Returns the total amount of tokens minted in the contract.
672      */
673     function _totalMinted() internal view returns (uint256) {
674         // Counter underflow is impossible as _currentIndex does not decrement,
675         // and it is initialized to `_startTokenId()`
676         unchecked {
677             return _currentIndex - _startTokenId();
678         }
679     }
680 
681     /**
682      * @dev Returns the total number of tokens burned.
683      */
684     function _totalBurned() internal view returns (uint256) {
685         return _burnCounter;
686     }
687 
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692         // The interface IDs are constants representing the first 4 bytes of the XOR of
693         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
694         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
695         return
696             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
697             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
698             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
699     }
700 
701     /**
702      * @dev See {IERC721-balanceOf}.
703      */
704     function balanceOf(address owner) public view override returns (uint256) {
705         if (owner == address(0)) revert BalanceQueryForZeroAddress();
706         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
707     }
708 
709     /**
710      * Returns the number of tokens minted by `owner`.
711      */
712     function _numberMinted(address owner) internal view returns (uint256) {
713         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
714     }
715 
716     /**
717      * Returns the number of tokens burned by or on behalf of `owner`.
718      */
719     function _numberBurned(address owner) internal view returns (uint256) {
720         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
721     }
722 
723     /**
724      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
725      */
726     function _getAux(address owner) internal view returns (uint64) {
727         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
728     }
729 
730     /**
731      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
732      * If there are multiple variables, please pack them into a uint64.
733      */
734     function _setAux(address owner, uint64 aux) internal {
735         uint256 packed = _packedAddressData[owner];
736         uint256 auxCasted;
737         // Cast `aux` with assembly to avoid redundant masking.
738         assembly {
739             auxCasted := aux
740         }
741         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
742         _packedAddressData[owner] = packed;
743     }
744 
745     /**
746      * Returns the packed ownership data of `tokenId`.
747      */
748     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
749         uint256 curr = tokenId;
750 
751         unchecked {
752             if (_startTokenId() <= curr)
753                 if (curr < _currentIndex) {
754                     uint256 packed = _packedOwnerships[curr];
755                     // If not burned.
756                     if (packed & BITMASK_BURNED == 0) {
757                         // Invariant:
758                         // There will always be an ownership that has an address and is not burned
759                         // before an ownership that does not have an address and is not burned.
760                         // Hence, curr will not underflow.
761                         //
762                         // We can directly compare the packed value.
763                         // If the address is zero, packed is zero.
764                         while (packed == 0) {
765                             packed = _packedOwnerships[--curr];
766                         }
767                         return packed;
768                     }
769                 }
770         }
771         revert OwnerQueryForNonexistentToken();
772     }
773 
774     /**
775      * Returns the unpacked `TokenOwnership` struct from `packed`.
776      */
777     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
778         ownership.addr = address(uint160(packed));
779         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
780         ownership.burned = packed & BITMASK_BURNED != 0;
781         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
782     }
783 
784     /**
785      * Returns the unpacked `TokenOwnership` struct at `index`.
786      */
787     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
788         return _unpackedOwnership(_packedOwnerships[index]);
789     }
790 
791     /**
792      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
793      */
794     function _initializeOwnershipAt(uint256 index) internal {
795         if (_packedOwnerships[index] == 0) {
796             _packedOwnerships[index] = _packedOwnershipOf(index);
797         }
798     }
799 
800     /**
801      * Gas spent here starts off proportional to the maximum mint batch size.
802      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
803      */
804     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
805         return _unpackedOwnership(_packedOwnershipOf(tokenId));
806     }
807 
808     /**
809      * @dev Packs ownership data into a single uint256.
810      */
811     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
812         assembly {
813             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
814             owner := and(owner, BITMASK_ADDRESS)
815             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
816             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
817         }
818     }
819 
820     /**
821      * @dev See {IERC721-ownerOf}.
822      */
823     function ownerOf(uint256 tokenId) public view override returns (address) {
824         return address(uint160(_packedOwnershipOf(tokenId)));
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
845         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
846 
847         string memory baseURI = _baseURI();
848         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, it can be overridden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return '';
858     }
859 
860     /**
861      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
862      */
863     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
864         // For branchless setting of the `nextInitialized` flag.
865         assembly {
866             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
867             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
868         }
869     }
870 
871     /**
872      * @dev See {IERC721-approve}.
873      */
874     function approve(address to, uint256 tokenId) public override {
875         address owner = ownerOf(tokenId);
876 
877         if (_msgSenderERC721A() != owner)
878             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
879                 revert ApprovalCallerNotOwnerNorApproved();
880             }
881 
882         _tokenApprovals[tokenId] = to;
883         emit Approval(owner, to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view override returns (address) {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
900 
901         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
902         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         transferFrom(from, to, tokenId);
933         if (to.code.length != 0)
934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
935                 revert TransferToNonERC721ReceiverImplementer();
936             }
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      */
946     function _exists(uint256 tokenId) internal view returns (bool) {
947         return
948             _startTokenId() <= tokenId &&
949             tokenId < _currentIndex && // If within bounds,
950             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
951     }
952 
953     /**
954      * @dev Equivalent to `_safeMint(to, quantity, '')`.
955      */
956     function _safeMint(address to, uint256 quantity) internal {
957         _safeMint(to, quantity, '');
958     }
959 
960     /**
961      * @dev Safely mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - If `to` refers to a smart contract, it must implement
966      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
967      * - `quantity` must be greater than 0.
968      *
969      * See {_mint}.
970      *
971      * Emits a {Transfer} event for each mint.
972      */
973     function _safeMint(
974         address to,
975         uint256 quantity,
976         bytes memory _data
977     ) internal {
978         _mint(to, quantity);
979 
980         unchecked {
981             if (to.code.length != 0) {
982                 uint256 end = _currentIndex;
983                 uint256 index = end - quantity;
984                 do {
985                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
986                         revert TransferToNonERC721ReceiverImplementer();
987                     }
988                 } while (index < end);
989                 // Reentrancy protection.
990                 if (_currentIndex != end) revert();
991             }
992         }
993     }
994 
995     /**
996      * @dev Mints `quantity` tokens and transfers them to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `quantity` must be greater than 0.
1002      *
1003      * Emits a {Transfer} event for each mint.
1004      */
1005     function _mint(address to, uint256 quantity) internal {
1006         uint256 startTokenId = _currentIndex;
1007         if (to == address(0)) revert MintToZeroAddress();
1008         if (quantity == 0) revert MintZeroQuantity();
1009 
1010         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1011 
1012         // Overflows are incredibly unrealistic.
1013         // `balance` and `numberMinted` have a maximum limit of 2**64.
1014         // `tokenId` has a maximum limit of 2**256.
1015         unchecked {
1016             // Updates:
1017             // - `balance += quantity`.
1018             // - `numberMinted += quantity`.
1019             //
1020             // We can directly add to the `balance` and `numberMinted`.
1021             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1022 
1023             // Updates:
1024             // - `address` to the owner.
1025             // - `startTimestamp` to the timestamp of minting.
1026             // - `burned` to `false`.
1027             // - `nextInitialized` to `quantity == 1`.
1028             _packedOwnerships[startTokenId] = _packOwnershipData(
1029                 to,
1030                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1031             );
1032 
1033             uint256 tokenId = startTokenId;
1034             uint256 end = startTokenId + quantity;
1035             do {
1036                 emit Transfer(address(0), to, tokenId++);
1037             } while (tokenId < end);
1038 
1039             _currentIndex = end;
1040         }
1041         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1042     }
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * This function is intended for efficient minting only during contract creation.
1048      *
1049      * It emits only one {ConsecutiveTransfer} as defined in
1050      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1051      * instead of a sequence of {Transfer} event(s).
1052      *
1053      * Calling this function outside of contract creation WILL make your contract
1054      * non-compliant with the ERC721 standard.
1055      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1056      * {ConsecutiveTransfer} event is only permissible during contract creation.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `quantity` must be greater than 0.
1062      *
1063      * Emits a {ConsecutiveTransfer} event.
1064      */
1065     function _mintERC2309(address to, uint256 quantity) internal {
1066         uint256 startTokenId = _currentIndex;
1067         if (to == address(0)) revert MintToZeroAddress();
1068         if (quantity == 0) revert MintZeroQuantity();
1069         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1070 
1071         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1072 
1073         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1074         unchecked {
1075             // Updates:
1076             // - `balance += quantity`.
1077             // - `numberMinted += quantity`.
1078             //
1079             // We can directly add to the `balance` and `numberMinted`.
1080             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1081 
1082             // Updates:
1083             // - `address` to the owner.
1084             // - `startTimestamp` to the timestamp of minting.
1085             // - `burned` to `false`.
1086             // - `nextInitialized` to `quantity == 1`.
1087             _packedOwnerships[startTokenId] = _packOwnershipData(
1088                 to,
1089                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1090             );
1091 
1092             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1093 
1094             _currentIndex = startTokenId + quantity;
1095         }
1096         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1097     }
1098 
1099     /**
1100      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1101      */
1102     function _getApprovedAddress(uint256 tokenId)
1103         private
1104         view
1105         returns (uint256 approvedAddressSlot, address approvedAddress)
1106     {
1107         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1108         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1109         assembly {
1110             // Compute the slot.
1111             mstore(0x00, tokenId)
1112             mstore(0x20, tokenApprovalsPtr.slot)
1113             approvedAddressSlot := keccak256(0x00, 0x40)
1114             // Load the slot's value from storage.
1115             approvedAddress := sload(approvedAddressSlot)
1116         }
1117     }
1118 
1119     /**
1120      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1121      */
1122     function _isOwnerOrApproved(
1123         address approvedAddress,
1124         address from,
1125         address msgSender
1126     ) private pure returns (bool result) {
1127         assembly {
1128             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1129             from := and(from, BITMASK_ADDRESS)
1130             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1131             msgSender := and(msgSender, BITMASK_ADDRESS)
1132             // `msgSender == from || msgSender == approvedAddress`.
1133             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1134         }
1135     }
1136 
1137     /**
1138      * @dev Transfers `tokenId` from `from` to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function transferFrom(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) public virtual override {
1152         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1153 
1154         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1155 
1156         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1157 
1158         // The nested ifs save around 20+ gas over a compound boolean condition.
1159         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1160             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1161 
1162         if (to == address(0)) revert TransferToZeroAddress();
1163 
1164         _beforeTokenTransfers(from, to, tokenId, 1);
1165 
1166         // Clear approvals from the previous owner.
1167         assembly {
1168             if approvedAddress {
1169                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1170                 sstore(approvedAddressSlot, 0)
1171             }
1172         }
1173 
1174         // Underflow of the sender's balance is impossible because we check for
1175         // ownership above and the recipient's balance can't realistically overflow.
1176         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1177         unchecked {
1178             // We can directly increment and decrement the balances.
1179             --_packedAddressData[from]; // Updates: `balance -= 1`.
1180             ++_packedAddressData[to]; // Updates: `balance += 1`.
1181 
1182             // Updates:
1183             // - `address` to the next owner.
1184             // - `startTimestamp` to the timestamp of transfering.
1185             // - `burned` to `false`.
1186             // - `nextInitialized` to `true`.
1187             _packedOwnerships[tokenId] = _packOwnershipData(
1188                 to,
1189                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1190             );
1191 
1192             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1193             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1194                 uint256 nextTokenId = tokenId + 1;
1195                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1196                 if (_packedOwnerships[nextTokenId] == 0) {
1197                     // If the next slot is within bounds.
1198                     if (nextTokenId != _currentIndex) {
1199                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1200                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1201                     }
1202                 }
1203             }
1204         }
1205 
1206         emit Transfer(from, to, tokenId);
1207         _afterTokenTransfers(from, to, tokenId, 1);
1208     }
1209 
1210     /**
1211      * @dev Equivalent to `_burn(tokenId, false)`.
1212      */
1213     function _burn(uint256 tokenId) internal virtual {
1214         _burn(tokenId, false);
1215     }
1216 
1217     /**
1218      * @dev Destroys `tokenId`.
1219      * The approval is cleared when the token is burned.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1228         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1229 
1230         address from = address(uint160(prevOwnershipPacked));
1231 
1232         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1233 
1234         if (approvalCheck) {
1235             // The nested ifs save around 20+ gas over a compound boolean condition.
1236             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1237                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1238         }
1239 
1240         _beforeTokenTransfers(from, address(0), tokenId, 1);
1241 
1242         // Clear approvals from the previous owner.
1243         assembly {
1244             if approvedAddress {
1245                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1246                 sstore(approvedAddressSlot, 0)
1247             }
1248         }
1249 
1250         // Underflow of the sender's balance is impossible because we check for
1251         // ownership above and the recipient's balance can't realistically overflow.
1252         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1253         unchecked {
1254             // Updates:
1255             // - `balance -= 1`.
1256             // - `numberBurned += 1`.
1257             //
1258             // We can directly decrement the balance, and increment the number burned.
1259             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1260             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1261 
1262             // Updates:
1263             // - `address` to the last owner.
1264             // - `startTimestamp` to the timestamp of burning.
1265             // - `burned` to `true`.
1266             // - `nextInitialized` to `true`.
1267             _packedOwnerships[tokenId] = _packOwnershipData(
1268                 from,
1269                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1270             );
1271 
1272             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1273             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1274                 uint256 nextTokenId = tokenId + 1;
1275                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1276                 if (_packedOwnerships[nextTokenId] == 0) {
1277                     // If the next slot is within bounds.
1278                     if (nextTokenId != _currentIndex) {
1279                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1280                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1281                     }
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(from, address(0), tokenId);
1287         _afterTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1290         unchecked {
1291             _burnCounter++;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1297      *
1298      * @param from address representing the previous owner of the given token ID
1299      * @param to target address that will receive the tokens
1300      * @param tokenId uint256 ID of the token to be transferred
1301      * @param _data bytes optional data to send along with the call
1302      * @return bool whether the call correctly returned the expected magic value
1303      */
1304     function _checkContractOnERC721Received(
1305         address from,
1306         address to,
1307         uint256 tokenId,
1308         bytes memory _data
1309     ) private returns (bool) {
1310         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1311             bytes4 retval
1312         ) {
1313             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1314         } catch (bytes memory reason) {
1315             if (reason.length == 0) {
1316                 revert TransferToNonERC721ReceiverImplementer();
1317             } else {
1318                 assembly {
1319                     revert(add(32, reason), mload(reason))
1320                 }
1321             }
1322         }
1323     }
1324 
1325     /**
1326      * @dev Directly sets the extra data for the ownership data `index`.
1327      */
1328     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1329         uint256 packed = _packedOwnerships[index];
1330         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1331         uint256 extraDataCasted;
1332         // Cast `extraData` with assembly to avoid redundant masking.
1333         assembly {
1334             extraDataCasted := extraData
1335         }
1336         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1337         _packedOwnerships[index] = packed;
1338     }
1339 
1340     /**
1341      * @dev Returns the next extra data for the packed ownership data.
1342      * The returned result is shifted into position.
1343      */
1344     function _nextExtraData(
1345         address from,
1346         address to,
1347         uint256 prevOwnershipPacked
1348     ) private view returns (uint256) {
1349         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1350         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1351     }
1352 
1353     /**
1354      * @dev Called during each token transfer to set the 24bit `extraData` field.
1355      * Intended to be overridden by the cosumer contract.
1356      *
1357      * `previousExtraData` - the value of `extraData` before transfer.
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _extraData(
1368         address from,
1369         address to,
1370         uint24 previousExtraData
1371     ) internal view virtual returns (uint24) {}
1372 
1373     /**
1374      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1375      * This includes minting.
1376      * And also called before burning one token.
1377      *
1378      * startTokenId - the first token id to be transferred
1379      * quantity - the amount to be transferred
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` will be minted for `to`.
1386      * - When `to` is zero, `tokenId` will be burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _beforeTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 
1396     /**
1397      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1398      * This includes minting.
1399      * And also called after one token has been burned.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` has been minted for `to`.
1409      * - When `to` is zero, `tokenId` has been burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _afterTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Returns the message sender (defaults to `msg.sender`).
1421      *
1422      * If you are writing GSN compatible contracts, you need to override this function.
1423      */
1424     function _msgSenderERC721A() internal view virtual returns (address) {
1425         return msg.sender;
1426     }
1427 
1428     /**
1429      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1430      */
1431     function _toString(uint256 value) internal pure returns (string memory ptr) {
1432         assembly {
1433             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1434             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1435             // We will need 1 32-byte word to store the length,
1436             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1437             ptr := add(mload(0x40), 128)
1438             // Update the free memory pointer to allocate.
1439             mstore(0x40, ptr)
1440 
1441             // Cache the end of the memory to calculate the length later.
1442             let end := ptr
1443 
1444             // We write the string from the rightmost digit to the leftmost digit.
1445             // The following is essentially a do-while loop that also handles the zero case.
1446             // Costs a bit more than early returning for the zero case,
1447             // but cheaper in terms of deployment and overall runtime costs.
1448             for {
1449                 // Initialize and perform the first pass without check.
1450                 let temp := value
1451                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1452                 ptr := sub(ptr, 1)
1453                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1454                 mstore8(ptr, add(48, mod(temp, 10)))
1455                 temp := div(temp, 10)
1456             } temp {
1457                 // Keep dividing `temp` until zero.
1458                 temp := div(temp, 10)
1459             } {
1460                 // Body of the for loop.
1461                 ptr := sub(ptr, 1)
1462                 mstore8(ptr, add(48, mod(temp, 10)))
1463             }
1464 
1465             let length := sub(end, ptr)
1466             // Move the pointer 32 bytes leftwards to make room for the length.
1467             ptr := sub(ptr, 32)
1468             // Store the length.
1469             mstore(ptr, length)
1470         }
1471     }
1472 }
1473 
1474 // File: contracts/INWILL.sol
1475 
1476 //Credit to CopeBears for awareness of ERC5050 to make the minting spicy 
1477 pragma solidity ^0.8.0;
1478 
1479 
1480 
1481 
1482 contract ERC5050 is ERC721A, Ownable, ReentrancyGuard {
1483 
1484     uint256 public maxPerTransaction = 10;
1485     uint256 public maxPerWallet = 40;
1486     uint256 public maxTotalSupply = 3000;
1487     uint256 public chanceFreeMintsAvailable = 1500;
1488     uint256 public freeMintsAvailable = 200;
1489     bool public isPublicLive = false;
1490     uint256 public mintPrice = 0.0069 ether;
1491     string public baseURI;
1492     mapping(address => uint256) public mintsPerWallet;
1493     address private withdrawAddress = address(0);
1494 
1495     constructor() ERC721A("Its Not What It Looks Like", "INWILL") {
1496         _safeMint(_msgSender(), 9); // Mints for team, setup OS and giveaways
1497         baseURI = "ipfs://QmPvkAsNpgc7V4hMZU6vG7DN5rEcdfuLEsUFHHGJBREdRV/";
1498     }
1499 
1500     function mint(uint256 _amount) external payable nonReentrant {
1501         require(isPublicLive, "Sale not live");
1502         require(_amount > 0, "You must mint at least one");
1503         require(totalSupply() + _amount <= maxTotalSupply, "Exceeds total supply");
1504         require(_amount <= maxPerTransaction, "Exceeds max per transaction");
1505         require(mintsPerWallet[_msgSender()] + _amount <= maxPerWallet, "Exceeds max per wallet");
1506 
1507         // 1 guaranteed free per wallet
1508         uint256 pricedAmount = freeMintsAvailable > 0 && mintsPerWallet[_msgSender()] == 0
1509             ? _amount - 1
1510             : _amount;
1511 
1512         if (pricedAmount < _amount) {
1513             freeMintsAvailable = freeMintsAvailable - 1;
1514         }
1515 
1516         require(mintPrice * pricedAmount <= msg.value, "Not enough ETH sent for selected amount");
1517 
1518         uint256 refund = chanceFreeMintsAvailable > 0 && pricedAmount > 0 && isFreeMint()
1519             ? pricedAmount * mintPrice
1520             : 0;
1521 
1522         if (refund > 0) {
1523             chanceFreeMintsAvailable = chanceFreeMintsAvailable - pricedAmount;
1524         }
1525 
1526         // sends needed ETH back to minter
1527         payable(_msgSender()).transfer(refund);
1528 
1529         mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _amount;
1530 
1531         _safeMint(_msgSender(), _amount);
1532     }
1533 
1534     function flipPublicSaleState() external onlyOwner {
1535         isPublicLive = !isPublicLive;
1536     }
1537 
1538     function _baseURI() internal view virtual override returns (string memory) {
1539         return baseURI;
1540     }
1541 
1542     function isFreeMint() internal view returns (bool) {
1543         return (uint256(keccak256(abi.encodePacked(
1544             tx.origin,
1545             blockhash(block.number - 1),
1546             block.timestamp,
1547             _msgSender()
1548         ))) & 0xFFFF) % 2 == 0;
1549     }
1550 
1551     function tokenURI(uint256 tokenId)
1552         public
1553         view
1554         virtual
1555         override
1556         returns (string memory)
1557     {
1558         require(
1559             _exists(tokenId),
1560             "ERC721Metadata: URI query for nonexistent token"
1561         );
1562         string memory _tokenURI = super.tokenURI(tokenId);
1563         return
1564             bytes(_tokenURI).length > 0
1565                 ? string(abi.encodePacked(_tokenURI, ".json"))
1566                 : "";
1567     }
1568 
1569     function withdraw() external onlyOwner {
1570         require(withdrawAddress != address(0), "No withdraw address");
1571         payable(withdrawAddress).transfer(address(this).balance);
1572     }
1573 
1574     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1575         mintPrice = _mintPrice;
1576     }
1577 
1578     function setFreeMintsAvailable(uint256 _freeMintsAvailable) external onlyOwner {
1579         freeMintsAvailable = _freeMintsAvailable;
1580     }
1581 
1582     function setChanceFreeMintsAvailable(uint256 _chanceFreeMintsAvailable) external onlyOwner {
1583         chanceFreeMintsAvailable = _chanceFreeMintsAvailable;
1584     }
1585 
1586     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1587         baseURI = _newBaseURI;
1588     }
1589 
1590     function setWithdrawAddress(address _withdrawAddress) external onlyOwner {
1591         withdrawAddress = _withdrawAddress;
1592     }
1593 }