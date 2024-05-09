1 // File: interfaces/IS7NSBox.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface IS7NSBox {
7 
8 	/**
9        	@notice Mint Boxes to `_beneficiary`
10        	@dev  Caller must have MINTER_ROLE
11 		@param	_beneficiary			Address of Beneficiary
12 		@param	_fromID					Start of TokenID
13 		@param	_amount					Amount of Boxes to be minted
14     */
15 	function produce(address _beneficiary, uint256 _fromID, uint256 _amount) external;
16 
17 	/**
18        	@notice Burn Boxes from `msg.sender`
19        	@dev  Caller can be ANY
20 		@param	_ids				A list of `tokenIds` to be burned
21 		
22 		Note: MINTER_ROLE is granted a privilege to burn Boxes
23     */
24 	function destroy(uint256[] calldata _ids) external;
25 }
26 
27 // File: interfaces/IS7NSManagement.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33    @title IS7NSManagement contract
34    @dev Provide interfaces that allow interaction to S7NSManagement contract
35 */
36 interface IS7NSManagement {
37     function treasury() external view returns (address);
38     function hasRole(bytes32 role, address account) external view returns (bool);
39     function paymentTokens(address _token) external view returns (bool);
40     function halted() external view returns (bool);
41 }
42 
43 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Interface of the ERC165 standard, as defined in the
52  * https://eips.ethereum.org/EIPS/eip-165[EIP].
53  *
54  * Implementers can declare support of contract interfaces, which can then be
55  * queried by others ({ERC165Checker}).
56  *
57  * For an implementation, see {ERC165}.
58  */
59 interface IERC165 {
60     /**
61      * @dev Returns true if this contract implements the interface defined by
62      * `interfaceId`. See the corresponding
63      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
64      * to learn more about how these ids are created.
65      *
66      * This function call must use less than 30 000 gas.
67      */
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Required interface of an ERC721 compliant contract.
81  */
82 interface IERC721 is IERC165 {
83     /**
84      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
87 
88     /**
89      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
90      */
91     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
92 
93     /**
94      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
95      */
96     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
97 
98     /**
99      * @dev Returns the number of tokens in ``owner``'s account.
100      */
101     function balanceOf(address owner) external view returns (uint256 balance);
102 
103     /**
104      * @dev Returns the owner of the `tokenId` token.
105      *
106      * Requirements:
107      *
108      * - `tokenId` must exist.
109      */
110     function ownerOf(uint256 tokenId) external view returns (address owner);
111 
112     /**
113      * @dev Safely transfers `tokenId` token from `from` to `to`.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must exist and be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
122      *
123      * Emits a {Transfer} event.
124      */
125     function safeTransferFrom(
126         address from,
127         address to,
128         uint256 tokenId,
129         bytes calldata data
130     ) external;
131 
132     /**
133      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
134      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId
150     ) external;
151 
152     /**
153      * @dev Transfers `tokenId` token from `from` to `to`.
154      *
155      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
156      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
157      * understand this adds an external call which potentially creates a reentrancy vulnerability.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address from,
170         address to,
171         uint256 tokenId
172     ) external;
173 
174     /**
175      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
176      * The approval is cleared when the token is transferred.
177      *
178      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
179      *
180      * Requirements:
181      *
182      * - The caller must own the token or be an approved operator.
183      * - `tokenId` must exist.
184      *
185      * Emits an {Approval} event.
186      */
187     function approve(address to, uint256 tokenId) external;
188 
189     /**
190      * @dev Approve or remove `operator` as an operator for the caller.
191      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
192      *
193      * Requirements:
194      *
195      * - The `operator` cannot be the caller.
196      *
197      * Emits an {ApprovalForAll} event.
198      */
199     function setApprovalForAll(address operator, bool _approved) external;
200 
201     /**
202      * @dev Returns the account approved for `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function getApproved(uint256 tokenId) external view returns (address operator);
209 
210     /**
211      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
212      *
213      * See {setApprovalForAll}
214      */
215     function isApprovedForAll(address owner, address operator) external view returns (bool);
216 }
217 
218 // File: SpecialEvent.sol
219 
220 
221 pragma solidity ^0.8.0;
222 
223 
224 
225 
226 contract SpecialEvent {
227 
228 	uint256 private constant START_TIME = 1668528000;		//	Nov 15th, 2022 16:00 PM (UTC)
229 	bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
230 	
231 	IS7NSManagement public immutable management;
232     address public immutable gAvatar;
233     address public immutable box;
234     uint256 public endTime;
235     uint256 public counter;
236 
237     //  A list of `gAvatarId` has been claimed
238     mapping(uint256 => bool) public claimed;
239 
240 	modifier onlyManager() {
241 		require(
242 			management.hasRole(MANAGER_ROLE, msg.sender), "OnlyManager"
243 		);
244         _;
245     }
246 
247     event Claimed(address indexed caller, uint256[] avatarIds);
248 
249 	constructor(
250 		IS7NSManagement _management,
251         address _gAvatar,
252 		address _box,
253         uint256 _endTime
254 	) {
255 		management = _management;
256         gAvatar = _gAvatar;
257 		box = _box;
258         endTime = _endTime;
259 	}
260 
261     /**
262        	@notice Update `endTime` of special event
263        	@dev  Caller must have MANAGER_ROLE
264 		@param	_endTime			New ending time
265     */
266     function updateTime(uint256 _endTime) external onlyManager {
267         endTime = _endTime;
268     }
269 
270     /**
271        	@notice Update new value of `counter`
272        	@dev  Caller must have MANAGER_ROLE
273 		@param	_counter			New value of `counter`
274     */
275     function setCounter(uint256 _counter) external onlyManager {
276         counter = _counter;
277     }
278 
279     /**
280        	@notice Claim Box
281        	@dev  Caller must own Genesis Avatar
282         - 1 Genesis Avatar = 1 Box
283 		@param	_gAvatarIds			A list of the Genesis Avatar ID
284     */
285     function claim(uint256[] calldata _gAvatarIds) external {
286         //  If a claim is requested before or after a schedule event -> revert
287         uint256 _currentTime = block.timestamp;
288         require(
289             START_TIME <= _currentTime && _currentTime <= endTime, "NotAvailable"
290         );
291 
292         //  1 `gAvatarId` = 1 Box. Thus, check ownership of `_gAvatarIds`
293         //  and also check whether they have been used to claim before
294         uint256 _amount = _gAvatarIds.length;
295         address _caller = msg.sender;
296         IERC721 _gAvatar = IERC721(gAvatar);
297         uint256 _id;
298         for (uint256 i; i < _amount; i++) {
299             _id = _gAvatarIds[i];
300             require(
301                 _gAvatar.ownerOf(_id) == _caller && !claimed[_id],
302                 "InvalidRequest"
303             );
304             claimed[_id] = true;
305         }
306 
307         //  Mint Boxes to `_caller`
308         IS7NSBox(box).produce(_caller, counter, _amount);
309         counter += _amount;
310 
311         emit Claimed(_caller, _gAvatarIds);
312     }
313 }