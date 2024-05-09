1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() {
24         _setOwner(_msgSender());
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         _setOwner(address(0));
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "Ownable: new owner is the zero address");
42         _setOwner(newOwner);
43     }
44 
45     function _setOwner(address newOwner) private {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 library Address {
53 
54     function isContract(address account) internal view returns (bool) {
55 
56         uint256 size;
57         assembly {
58             size := extcodesize(account)
59         }
60         return size > 0;
61     }
62 
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
71         return functionCall(target, data, "Address: low-level call failed");
72     }
73 
74     function functionCall(
75         address target,
76         bytes memory data,
77         string memory errorMessage
78     ) internal returns (bytes memory) {
79         return functionCallWithValue(target, data, 0, errorMessage);
80     }
81 
82     function functionCallWithValue(
83         address target,
84         bytes memory data,
85         uint256 value
86     ) internal returns (bytes memory) {
87         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
88     }
89 
90     function functionCallWithValue(
91         address target,
92         bytes memory data,
93         uint256 value,
94         string memory errorMessage
95     ) internal returns (bytes memory) {
96         require(address(this).balance >= value, "Address: insufficient balance for call");
97         require(isContract(target), "Address: call to non-contract");
98 
99         (bool success, bytes memory returndata) = target.call{value: value}(data);
100         return verifyCallResult(success, returndata, errorMessage);
101     }
102 
103     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
104         return functionStaticCall(target, data, "Address: low-level static call failed");
105     }
106 
107     function functionStaticCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal view returns (bytes memory) {
112         require(isContract(target), "Address: static call to non-contract");
113 
114         (bool success, bytes memory returndata) = target.staticcall(data);
115         return verifyCallResult(success, returndata, errorMessage);
116     }
117 
118     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
119         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
120     }
121 
122     function functionDelegateCall(
123         address target,
124         bytes memory data,
125         string memory errorMessage
126     ) internal returns (bytes memory) {
127         require(isContract(target), "Address: delegate call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.delegatecall(data);
130         return verifyCallResult(success, returndata, errorMessage);
131     }
132 
133     function verifyCallResult(
134         bool success,
135         bytes memory returndata,
136         string memory errorMessage
137     ) internal pure returns (bytes memory) {
138         if (success) {
139             return returndata;
140         } else {
141             if (returndata.length > 0) {
142 
143                 assembly {
144                     let returndata_size := mload(returndata)
145                     revert(add(32, returndata), returndata_size)
146                 }
147             } else {
148                 revert(errorMessage);
149             }
150         }
151     }
152 }
153 
154 interface IERC165 {
155 
156     function supportsInterface(bytes4 interfaceId) external view returns (bool);
157 }
158 
159 abstract contract ERC165 is IERC165 {
160     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
161         return interfaceId == type(IERC165).interfaceId;
162     }
163 }
164 
165 interface IERC1155Receiver is IERC165 {
166 
167     function onERC1155Received(
168         address operator,
169         address from,
170         uint256 id,
171         uint256 value,
172         bytes calldata data
173     ) external returns (bytes4);
174 
175     function onERC1155BatchReceived(
176         address operator,
177         address from,
178         uint256[] calldata ids,
179         uint256[] calldata values,
180         bytes calldata data
181     ) external returns (bytes4);
182 }
183 
184 interface IERC1155 is IERC165 {
185 
186     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
187 
188     event TransferBatch(
189         address indexed operator,
190         address indexed from,
191         address indexed to,
192         uint256[] ids,
193         uint256[] values
194     );
195 
196     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
197 
198     event URI(string value, uint256 indexed id);
199 
200     function balanceOf(address account, uint256 id) external view returns (uint256);
201 
202     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
203         external
204         view
205         returns (uint256[] memory);
206 
207     function setApprovalForAll(address operator, bool approved) external;
208 
209     function isApprovedForAll(address account, address operator) external view returns (bool);
210 
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 id,
215         uint256 amount,
216         bytes calldata data
217     ) external;
218 
219     function safeBatchTransferFrom(
220         address from,
221         address to,
222         uint256[] calldata ids,
223         uint256[] calldata amounts,
224         bytes calldata data
225     ) external;
226 }
227 
228 interface IERC1155MetadataURI is IERC1155 {
229 
230     function uri(uint256 id) external view returns (string memory);
231 }
232 
233 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
234     using Address for address;
235 
236     mapping(uint256 => mapping(address => uint256)) private _balances;
237 
238     mapping(address => mapping(address => bool)) private _operatorApprovals;
239 
240     string private _uri;
241 
242     constructor(string memory uri_) {
243         _setURI(uri_);
244     }
245 
246     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
247         return
248             interfaceId == type(IERC1155).interfaceId ||
249             interfaceId == type(IERC1155MetadataURI).interfaceId ||
250             super.supportsInterface(interfaceId);
251     }
252 
253     function uri(uint256) public view virtual override returns (string memory) {
254         return _uri;
255     }
256 
257     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
258         require(account != address(0), "ERC1155: balance query for the zero address");
259         return _balances[id][account];
260     }
261 
262     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
263         public
264         view
265         virtual
266         override
267         returns (uint256[] memory)
268     {
269         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
270 
271         uint256[] memory batchBalances = new uint256[](accounts.length);
272 
273         for (uint256 i = 0; i < accounts.length; ++i) {
274             batchBalances[i] = balanceOf(accounts[i], ids[i]);
275         }
276 
277         return batchBalances;
278     }
279 
280     function setApprovalForAll(address operator, bool approved) public virtual override {
281         _setApprovalForAll(_msgSender(), operator, approved);
282     }
283 
284     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
285         return _operatorApprovals[account][operator];
286     }
287 
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 id,
292         uint256 amount,
293         bytes memory data
294     ) public virtual override {
295         require(
296             from == _msgSender() || isApprovedForAll(from, _msgSender()),
297             "ERC1155: caller is not an owner nor approved"
298         );
299         _safeTransferFrom(from, to, id, amount, data);
300     }
301 
302     function safeBatchTransferFrom(
303         address from,
304         address to,
305         uint256[] memory ids,
306         uint256[] memory amounts,
307         bytes memory data
308     ) public virtual override {
309         require(
310             from == _msgSender() || isApprovedForAll(from, _msgSender()),
311             "ERC1155: transfer caller is not an owner nor approved"
312         );
313         _safeBatchTransferFrom(from, to, ids, amounts, data);
314     }
315 
316     function _safeTransferFrom(
317         address from,
318         address to,
319         uint256 id,
320         uint256 amount,
321         bytes memory data
322     ) internal virtual {
323         require(to != address(0), "ERC1155: transfer to the zero address");
324 
325         address operator = _msgSender();
326 
327         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
328 
329         uint256 fromBalance = _balances[id][from];
330         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
331         unchecked {
332             _balances[id][from] = fromBalance - amount;
333         }
334         _balances[id][to] += amount;
335 
336         emit TransferSingle(operator, from, to, id, amount);
337 
338         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
339     }
340 
341     function _safeBatchTransferFrom(
342         address from,
343         address to,
344         uint256[] memory ids,
345         uint256[] memory amounts,
346         bytes memory data
347     ) internal virtual {
348         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
349         require(to != address(0), "ERC1155: transfer to the zero address");
350 
351         address operator = _msgSender();
352 
353         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
354 
355         for (uint256 i = 0; i < ids.length; ++i) {
356             uint256 id = ids[i];
357             uint256 amount = amounts[i];
358 
359             uint256 fromBalance = _balances[id][from];
360             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
361             unchecked {
362                 _balances[id][from] = fromBalance - amount;
363             }
364             _balances[id][to] += amount;
365         }
366 
367         emit TransferBatch(operator, from, to, ids, amounts);
368 
369         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
370     }
371 
372     function _setURI(string memory newuri) internal virtual {
373         _uri = newuri;
374     }
375 
376     function _mint(
377         address to,
378         uint256 id,
379         uint256 amount,
380         bytes memory data
381     ) internal virtual {
382         require(to != address(0), "ERC1155: mint to the zero address");
383 
384         address operator = _msgSender();
385 
386         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
387 
388         _balances[id][to] += amount;
389         emit TransferSingle(operator, address(0), to, id, amount);
390 
391         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
392     }
393 
394     function _mintBatch(
395         address to,
396         uint256[] memory ids,
397         uint256[] memory amounts,
398         bytes memory data
399     ) internal virtual {
400         require(to != address(0), "ERC1155: mint to the zero address");
401         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
402 
403         address operator = _msgSender();
404 
405         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
406 
407         for (uint256 i = 0; i < ids.length; i++) {
408             _balances[ids[i]][to] += amounts[i];
409         }
410 
411         emit TransferBatch(operator, address(0), to, ids, amounts);
412 
413         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
414     }
415 
416     function _burn(
417         address from,
418         uint256 id,
419         uint256 amount
420     ) internal virtual {
421         require(from != address(0), "ERC1155: burn from the zero address");
422 
423         address operator = _msgSender();
424 
425         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
426 
427         uint256 fromBalance = _balances[id][from];
428         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
429         unchecked {
430             _balances[id][from] = fromBalance - amount;
431         }
432 
433         emit TransferSingle(operator, from, address(0), id, amount);
434     }
435 
436     function _burnBatch(
437         address from,
438         uint256[] memory ids,
439         uint256[] memory amounts
440     ) internal virtual {
441         require(from != address(0), "ERC1155: burn from the zero address");
442         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
443 
444         address operator = _msgSender();
445 
446         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
447 
448         for (uint256 i = 0; i < ids.length; i++) {
449             uint256 id = ids[i];
450             uint256 amount = amounts[i];
451 
452             uint256 fromBalance = _balances[id][from];
453             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
454             unchecked {
455                 _balances[id][from] = fromBalance - amount;
456             }
457         }
458 
459         emit TransferBatch(operator, from, address(0), ids, amounts);
460     }
461 
462     function _setApprovalForAll(
463         address owner,
464         address operator,
465         bool approved
466     ) internal virtual {
467         require(owner != operator, "ERC1155: setting approval status for self");
468         _operatorApprovals[owner][operator] = approved;
469         emit ApprovalForAll(owner, operator, approved);
470     }
471 
472     function _beforeTokenTransfer(
473         address operator,
474         address from,
475         address to,
476         uint256[] memory ids,
477         uint256[] memory amounts,
478         bytes memory data
479     ) internal virtual {}
480 
481     function _doSafeTransferAcceptanceCheck(
482         address operator,
483         address from,
484         address to,
485         uint256 id,
486         uint256 amount,
487         bytes memory data
488     ) private {
489         if (to.isContract()) {
490             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
491                 if (response != IERC1155Receiver.onERC1155Received.selector) {
492                     revert("ERC1155: ERC1155Receiver rejected tokens");
493                 }
494             } catch Error(string memory reason) {
495                 revert(reason);
496             } catch {
497                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
498             }
499         }
500     }
501 
502     function _doSafeBatchTransferAcceptanceCheck(
503         address operator,
504         address from,
505         address to,
506         uint256[] memory ids,
507         uint256[] memory amounts,
508         bytes memory data
509     ) private {
510         if (to.isContract()) {
511             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
512                 bytes4 response
513             ) {
514                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
515                     revert("ERC1155: ERC1155Receiver rejected tokens");
516                 }
517             } catch Error(string memory reason) {
518                 revert(reason);
519             } catch {
520                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
521             }
522         }
523     }
524 
525     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
526         uint256[] memory array = new uint256[](1);
527         array[0] = element;
528 
529         return array;
530     }
531 }
532 
533 contract WTPUniques is ERC1155, Ownable {
534 
535     uint constant MAX_WTPUniques = 100;
536     struct WTPUnique{
537         uint common_price;
538         uint holders_price;
539         uint max_supply;
540         uint total_supply;
541         string uri;
542         bool active;
543     }
544     mapping (uint => WTPUnique) private wtpuniques;
545 
546     WTP public constant WTPCONTRACT = WTP(0x901C0be93A24a3c5e2A6C8b542Cc196B468A7669);
547 
548     constructor() ERC1155("") {
549         
550     }
551 
552     function addWTPUnique(uint _id, uint _common_price, uint _holders_price, uint _max_supply, string memory _uri) public onlyOwner {
553         require(_id < MAX_WTPUniques, "Quantity limit reached");
554         require(getMaxSupply(_id) == 0, "Token is already exist");
555         wtpuniques[_id].common_price = _common_price;
556         wtpuniques[_id].holders_price = _holders_price;
557         wtpuniques[_id].max_supply = _max_supply;
558         wtpuniques[_id].uri = _uri;
559     }
560 
561     function active(uint _id, bool _active) public onlyOwner {
562         require(getMaxSupply(_id) != 0, "Token does not exist");
563         wtpuniques[_id].active = _active;
564     }
565 
566     function getPrice(uint _id, address _to) public view returns(uint256){
567         require(getMaxSupply(_id) != 0, "Token does not exist");
568         uint256 _price;
569         if (WTPCONTRACT.balanceOf(_to) != 0){
570             _price = wtpuniques[_id].holders_price;
571         } else {
572             _price = wtpuniques[_id].common_price;
573         }
574         return _price;
575     }
576 
577     function getMaxSupply(uint _id) public view returns(uint256){
578         return wtpuniques[_id].max_supply;
579     }
580 
581     function getTotalSupply(uint _id) public view returns(uint256){
582         require(getMaxSupply(_id) != 0, "Token does not exist");
583         return wtpuniques[_id].total_supply;
584     }
585 
586     function isActive(uint _id) public view returns(bool){
587         require(getMaxSupply(_id) != 0, "Token does not exist");
588         return wtpuniques[_id].active;
589     }
590 
591     function mint(address _to, uint _count, uint _id) public payable {
592         require(getTotalSupply(_id) + _count <= getMaxSupply(_id), "Total supply limit reached or token does not exist");
593         if (msg.sender != owner()){
594             require(isActive(_id), "Sale has not started");
595             require(balanceOf(_to, _id) == 0, "Address already hold this token");
596             require(_count == 1, "Max 1 token");
597             require(msg.value == getPrice(_id, _to) * _count, "the Value is lower then the Price");
598         }
599         _mint(_to, _id, _count, "");
600         wtpuniques[_id].total_supply += _count;
601     }
602 
603     function uri(uint256 _id) public view virtual override returns (string memory) {
604         return wtpuniques[_id].uri;
605     }
606 
607     function withdrawAll() public payable onlyOwner {
608         require(payable(msg.sender).send(address(this).balance));
609     }
610 
611 }
612 
613 interface WTP{
614     function balanceOf(address owner) external view returns (uint256 balance);
615 }