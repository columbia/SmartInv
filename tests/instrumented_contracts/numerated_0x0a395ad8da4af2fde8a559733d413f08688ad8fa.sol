1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         _checkOwner();
32         _;
33     }
34 
35     /**
36      * @dev Returns the address of the current owner.
37      */
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     /**
43      * @dev Throws if the sender is not the owner.
44      */
45     function _checkOwner() internal view virtual {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Internal function without access restriction.
72      */
73     function _transferOwnership(address newOwner) internal virtual {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 interface IERC165 {
81     /**
82      * @dev Returns true if this contract implements the interface defined by
83      * `interfaceId`. See the corresponding
84      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
85      * to learn more about how these ids are created.
86      *
87      * This function call must use less than 30 000 gas.
88      */
89     function supportsInterface(bytes4 interfaceId) external view returns (bool);
90 }
91 
92 interface IERC1155 is IERC165 {
93     /**
94      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
95      */
96     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
97 
98     /**
99      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
100      * transfers.
101      */
102     event TransferBatch(
103         address indexed operator,
104         address indexed from,
105         address indexed to,
106         uint256[] ids,
107         uint256[] values
108     );
109 
110     /**
111      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
112      * `approved`.
113      */
114     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
115 
116     /**
117      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
118      *
119      * If an {URI} event was emitted for `id`, the standard
120      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
121      * returned by {IERC1155MetadataURI-uri}.
122      */
123     event URI(string value, uint256 indexed id);
124 
125     /**
126      * @dev Returns the amount of tokens of token type `id` owned by `account`.
127      *
128      * Requirements:
129      *
130      * - `account` cannot be the zero address.
131      */
132     function balanceOf(address account, uint256 id) external view returns (uint256);
133 
134     /**
135      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
136      *
137      * Requirements:
138      *
139      * - `accounts` and `ids` must have the same length.
140      */
141     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
142         external
143         view
144         returns (uint256[] memory);
145 
146     /**
147      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
148      *
149      * Emits an {ApprovalForAll} event.
150      *
151      * Requirements:
152      *
153      * - `operator` cannot be the caller.
154      */
155     function setApprovalForAll(address operator, bool approved) external;
156 
157     /**
158      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
159      *
160      * See {setApprovalForAll}.
161      */
162     function isApprovedForAll(address account, address operator) external view returns (bool);
163 
164     /**
165      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
166      *
167      * Emits a {TransferSingle} event.
168      *
169      * Requirements:
170      *
171      * - `to` cannot be the zero address.
172      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
173      * - `from` must have a balance of tokens of type `id` of at least `amount`.
174      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
175      * acceptance magic value.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 id,
181         uint256 amount,
182         bytes calldata data
183     ) external;
184 
185     /**
186      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
187      *
188      * Emits a {TransferBatch} event.
189      *
190      * Requirements:
191      *
192      * - `ids` and `amounts` must have the same length.
193      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
194      * acceptance magic value.
195      */
196     function safeBatchTransferFrom(
197         address from,
198         address to,
199         uint256[] calldata ids,
200         uint256[] calldata amounts,
201         bytes calldata data
202     ) external;
203 }
204 
205 
206 interface IERC20 {
207     /**
208      * @dev Emitted when `value` tokens are moved from one account (`from`) to
209      * another (`to`).
210      *
211      * Note that `value` may be zero.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /**
216      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
217      * a call to {approve}. `value` is the new allowance.
218      */
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `to`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address to, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Returns the remaining number of tokens that `spender` will be
242      * allowed to spend on behalf of `owner` through {transferFrom}. This is
243      * zero by default.
244      *
245      * This value changes when {approve} or {transferFrom} are called.
246      */
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     /**
250      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * IMPORTANT: Beware that changing an allowance with this method brings the risk
255      * that someone may use both the old and the new allowance by unfortunate
256      * transaction ordering. One possible solution to mitigate this race
257      * condition is to first reduce the spender's allowance to 0 and set the
258      * desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address spender, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Moves `amount` tokens from `from` to `to` using the
267      * allowance mechanism. `amount` is then deducted from the caller's
268      * allowance.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 amount
278     ) external returns (bool);
279 }
280 
281 interface ICheck {
282     function checkTorch(address _address, uint256 _amount, string memory signedMessage) external view returns (bool);
283 
284     function checkGetProp(address _address,uint256[] memory _tokenId,uint256[] memory _amounts,string memory signedMessage) external view returns (bool);
285 }
286 
287 interface IMonsterWallet {
288     function transferFrozenToken() external;
289 }
290 
291 contract MonsterBattleTorch is Ownable{
292     IMonsterWallet public MonsterWallet;
293     IERC20 public Torch;
294     IERC1155 public Storage;
295     ICheck private Check;
296 
297 
298     bool public _isActiveRecharge = true;
299     bool public _isActiveWithdrawal = true;
300     bool public _isActiveReceive = true; 
301 
302     address token = 0xd33B79F237508251e5740c5229f2c8Ea47Ee30C8;
303     address walletAddress = 0xd1c2809f12D74E691769A6C865E6f0d531a8a36f;
304     address public receiver = 0xDAC226421Fe37a1B00A469Cf03Ba5629ef5a3db6;
305     address public HoleAddress = 0xB63B32CaD8510572210987f489eD6F7547c0b0b1;
306 
307 
308     uint256 maxWithdrawTorch = 300000000 ether;
309     uint256 withdrawTimes = 3600;
310     uint256 frozenBalance = 1000000000 ether;
311     
312     
313     mapping(address => uint256) private Signature;
314 
315     event rechargeTorchEvent(address indexed from,uint256 indexed _amount,uint256 indexed _timestamp); 
316     event withdrawTorchEvent(address indexed to,uint256 indexed _amount,uint256 indexed _timestamp); 
317     event Synthesis(address indexed to,uint256 indexed _tokenId, uint256 indexed  _amount);
318    
319 
320     constructor(address _check) {
321         Torch = IERC20(token);
322         Check = ICheck(_check);
323         MonsterWallet = IMonsterWallet(walletAddress);
324     }
325 
326     function rechargeTorch(uint256 _amount) public {
327         require(
328             _isActiveRecharge,
329             "Recharge must be active"
330         );
331 
332         require(
333             _amount > 0,
334             "Recharge torch must be greater than 0"
335         );
336 
337         Torch.transferFrom(msg.sender, address(this), _amount);
338 
339         emit rechargeTorchEvent(msg.sender, _amount, block.timestamp);
340     }
341     
342 
343     function withdrawTorch(uint256 _amount, string memory _signature) public {
344         require(
345             _isActiveWithdrawal,
346             "Withdraw must be active"
347         );
348 
349         require(
350             _amount > 0,
351             "Withdraw torch must be greater than 0"
352         );
353 
354         require(
355             _amount <= maxWithdrawTorch,
356             "Withdraw torch must  be less than max withdraw torch at 1 time"
357         );
358 
359         require(
360             Signature[msg.sender] + withdrawTimes <= block.timestamp,
361             "Can only withdraw 1 times at 1 hour"
362         );
363 
364         require(
365             Check.checkTorch(msg.sender, _amount, _signature) == true,
366             "Audit error"
367         );
368 
369         if(Torch.balanceOf(address(this)) <= frozenBalance){
370             MonsterWallet.transferFrozenToken();
371         }
372 
373         require(
374             Torch.balanceOf(address(this)) >= _amount,
375             "Torch credit is running low"
376         );
377 
378         Signature[msg.sender] = block.timestamp;
379 
380         Torch.transfer( msg.sender, _amount);
381 
382         emit withdrawTorchEvent(msg.sender, _amount, block.timestamp);
383     }
384 
385 
386     function receiveStorage(uint256[] memory _tokenIds,uint256[] memory _amounts,string memory _signature) public{
387         require(_isActiveReceive, "Receive storage must be active");
388 
389         require(
390             Check.checkGetProp(msg.sender, _tokenIds, _amounts, _signature) == true,
391             "Audit error"
392         );   
393 
394         Storage.safeBatchTransferFrom(HoleAddress, msg.sender, _tokenIds, _amounts, "0x00");
395 
396         uint256  tokenIdLength  = _tokenIds.length;
397 
398         for(uint i = 0;i < tokenIdLength;i++){
399             emit Synthesis(msg.sender, _tokenIds[i], _amounts[i]);
400         }
401 
402     }
403 
404     function withdrawToken() public onlyOwner{
405         uint256 amount = Torch.balanceOf(address(this));
406         Torch.transfer(receiver, amount);
407     }
408 
409     function setActiveRecharge() public onlyOwner {
410         _isActiveRecharge = !_isActiveRecharge;
411     }
412 
413     function setActiveWithdrawal() public onlyOwner {
414         _isActiveWithdrawal = !_isActiveWithdrawal;
415     }  
416 
417     function setActiveReceive() public onlyOwner {
418         _isActiveReceive = !_isActiveReceive;
419     }
420     
421     function setReceiver(address _addr) public onlyOwner{
422         receiver = _addr;
423     }
424 
425     function setHoleAddress(address _addr) public onlyOwner{
426         HoleAddress = _addr;
427     }
428 
429 
430     function setTorchContract(address _addr) public onlyOwner{  
431         Torch = IERC20(_addr);
432     }
433 
434     function setCheckContract(address _addr) public onlyOwner{
435         Check = ICheck(_addr);
436     }
437 
438     function setStorageContract(address _addr) public onlyOwner{
439         Storage = IERC1155(_addr);
440     }
441 
442     function setWalletContract(address _addr) public onlyOwner{
443         MonsterWallet = IMonsterWallet(_addr);
444     }
445 
446     function setMaxWithdrawTorch(uint256 _amount) public onlyOwner{
447         maxWithdrawTorch = _amount;
448     }
449 
450     function setFrozenBalance(uint256 _amount) public onlyOwner{
451         frozenBalance = _amount;
452     }
453 
454     function setWithdrawTimes(uint256 _timestamp) public onlyOwner{
455         withdrawTimes = _timestamp;
456     }
457 
458 
459 }