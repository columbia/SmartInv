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
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _setOwner(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _setOwner(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _setOwner(newOwner);
39     }
40 
41     function _setOwner(address newOwner) private {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 library Address {
49 
50     function isContract(address account) internal view returns (bool) {
51 
52         uint256 size;
53         assembly {
54             size := extcodesize(account)
55         }
56         return size > 0;
57     }
58 
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
67         return functionCall(target, data, "Address: low-level call failed");
68     }
69 
70     function functionCall(
71         address target,
72         bytes memory data,
73         string memory errorMessage
74     ) internal returns (bytes memory) {
75         return functionCallWithValue(target, data, 0, errorMessage);
76     }
77 
78     function functionCallWithValue(
79         address target,
80         bytes memory data,
81         uint256 value
82     ) internal returns (bytes memory) {
83         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
84     }
85 
86     function functionCallWithValue(
87         address target,
88         bytes memory data,
89         uint256 value,
90         string memory errorMessage
91     ) internal returns (bytes memory) {
92         require(address(this).balance >= value, "Address: insufficient balance for call");
93         require(isContract(target), "Address: call to non-contract");
94 
95         (bool success, bytes memory returndata) = target.call{value: value}(data);
96         return verifyCallResult(success, returndata, errorMessage);
97     }
98 
99     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
100         return functionStaticCall(target, data, "Address: low-level static call failed");
101     }
102 
103     function functionStaticCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal view returns (bytes memory) {
108         require(isContract(target), "Address: static call to non-contract");
109 
110         (bool success, bytes memory returndata) = target.staticcall(data);
111         return verifyCallResult(success, returndata, errorMessage);
112     }
113 
114     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
116     }
117 
118     function functionDelegateCall(
119         address target,
120         bytes memory data,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         require(isContract(target), "Address: delegate call to non-contract");
124 
125         (bool success, bytes memory returndata) = target.delegatecall(data);
126         return verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     function verifyCallResult(
130         bool success,
131         bytes memory returndata,
132         string memory errorMessage
133     ) internal pure returns (bytes memory) {
134         if (success) {
135             return returndata;
136         } else {
137             if (returndata.length > 0) {
138 
139                 assembly {
140                     let returndata_size := mload(returndata)
141                     revert(add(32, returndata), returndata_size)
142                 }
143             } else {
144                 revert(errorMessage);
145             }
146         }
147     }
148 }
149 
150 interface IERC165 {
151 
152     function supportsInterface(bytes4 interfaceId) external view returns (bool);
153 }
154 
155 abstract contract ERC165 is IERC165 {
156     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
157         return interfaceId == type(IERC165).interfaceId;
158     }
159 }
160 
161 interface IERC1155Receiver is IERC165 {
162 
163     function onERC1155Received(
164         address operator,
165         address from,
166         uint256 id,
167         uint256 value,
168         bytes calldata data
169     ) external returns (bytes4);
170 
171     function onERC1155BatchReceived(
172         address operator,
173         address from,
174         uint256[] calldata ids,
175         uint256[] calldata values,
176         bytes calldata data
177     ) external returns (bytes4);
178 }
179 
180 interface IERC1155 is IERC165 {
181 
182     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
183 
184     event TransferBatch(
185         address indexed operator,
186         address indexed from,
187         address indexed to,
188         uint256[] ids,
189         uint256[] values
190     );
191 
192     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
193 
194     event URI(string value, uint256 indexed id);
195 
196     function balanceOf(address account, uint256 id) external view returns (uint256);
197 
198     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
199         external
200         view
201         returns (uint256[] memory);
202 
203     function setApprovalForAll(address operator, bool approved) external;
204 
205     function isApprovedForAll(address account, address operator) external view returns (bool);
206 
207     function safeTransferFrom(
208         address from,
209         address to,
210         uint256 id,
211         uint256 amount,
212         bytes calldata data
213     ) external;
214 
215     function safeBatchTransferFrom(
216         address from,
217         address to,
218         uint256[] calldata ids,
219         uint256[] calldata amounts,
220         bytes calldata data
221     ) external;
222 }
223 
224 interface IERC1155MetadataURI is IERC1155 {
225 
226     function uri(uint256 id) external view returns (string memory);
227 }
228 
229 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
230     using Address for address;
231 
232     mapping(uint256 => mapping(address => uint256)) private _balances;
233 
234     mapping(address => mapping(address => bool)) private _operatorApprovals;
235 
236     string private _uri;
237 
238     constructor(string memory uri_) {
239         _setURI(uri_);
240     }
241 
242     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
243         return
244             interfaceId == type(IERC1155).interfaceId ||
245             interfaceId == type(IERC1155MetadataURI).interfaceId ||
246             super.supportsInterface(interfaceId);
247     }
248 
249     function uri(uint256) public view virtual override returns (string memory) {
250         return _uri;
251     }
252 
253     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
254         require(account != address(0), "ERC1155: balance query for the zero address");
255         return _balances[id][account];
256     }
257 
258     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
259         public
260         view
261         virtual
262         override
263         returns (uint256[] memory)
264     {
265         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
266 
267         uint256[] memory batchBalances = new uint256[](accounts.length);
268 
269         for (uint256 i = 0; i < accounts.length; ++i) {
270             batchBalances[i] = balanceOf(accounts[i], ids[i]);
271         }
272 
273         return batchBalances;
274     }
275 
276     function setApprovalForAll(address operator, bool approved) public virtual override {
277         _setApprovalForAll(_msgSender(), operator, approved);
278     }
279 
280     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
281         return _operatorApprovals[account][operator];
282     }
283 
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 id,
288         uint256 amount,
289         bytes memory data
290     ) public virtual override {
291         require(
292             from == _msgSender() || isApprovedForAll(from, _msgSender()),
293             "ERC1155: caller is not an owner nor approved"
294         );
295         _safeTransferFrom(from, to, id, amount, data);
296     }
297 
298     function safeBatchTransferFrom(
299         address from,
300         address to,
301         uint256[] memory ids,
302         uint256[] memory amounts,
303         bytes memory data
304     ) public virtual override {
305         require(
306             from == _msgSender() || isApprovedForAll(from, _msgSender()),
307             "ERC1155: transfer caller is not an owner nor approved"
308         );
309         _safeBatchTransferFrom(from, to, ids, amounts, data);
310     }
311 
312     function _safeTransferFrom(
313         address from,
314         address to,
315         uint256 id,
316         uint256 amount,
317         bytes memory data
318     ) internal virtual {
319         require(to != address(0), "ERC1155: transfer to the zero address");
320 
321         address operator = _msgSender();
322 
323         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
324 
325         uint256 fromBalance = _balances[id][from];
326         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
327         unchecked {
328             _balances[id][from] = fromBalance - amount;
329         }
330         _balances[id][to] += amount;
331 
332         emit TransferSingle(operator, from, to, id, amount);
333 
334         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
335     }
336 
337     function _safeBatchTransferFrom(
338         address from,
339         address to,
340         uint256[] memory ids,
341         uint256[] memory amounts,
342         bytes memory data
343     ) internal virtual {
344         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
345         require(to != address(0), "ERC1155: transfer to the zero address");
346 
347         address operator = _msgSender();
348 
349         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
350 
351         for (uint256 i = 0; i < ids.length; ++i) {
352             uint256 id = ids[i];
353             uint256 amount = amounts[i];
354 
355             uint256 fromBalance = _balances[id][from];
356             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
357             unchecked {
358                 _balances[id][from] = fromBalance - amount;
359             }
360             _balances[id][to] += amount;
361         }
362 
363         emit TransferBatch(operator, from, to, ids, amounts);
364 
365         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
366     }
367 
368     function _setURI(string memory newuri) internal virtual {
369         _uri = newuri;
370     }
371 
372     function _mint(
373         address to,
374         uint256 id,
375         uint256 amount,
376         bytes memory data
377     ) internal virtual {
378         require(to != address(0), "ERC1155: mint to the zero address");
379 
380         address operator = _msgSender();
381 
382         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
383 
384         _balances[id][to] += amount;
385         emit TransferSingle(operator, address(0), to, id, amount);
386 
387         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
388     }
389 
390     function _mintBatch(
391         address to,
392         uint256[] memory ids,
393         uint256[] memory amounts,
394         bytes memory data
395     ) internal virtual {
396         require(to != address(0), "ERC1155: mint to the zero address");
397         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
398 
399         address operator = _msgSender();
400 
401         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
402 
403         for (uint256 i = 0; i < ids.length; i++) {
404             _balances[ids[i]][to] += amounts[i];
405         }
406 
407         emit TransferBatch(operator, address(0), to, ids, amounts);
408 
409         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
410     }
411 
412     function _burn(
413         address from,
414         uint256 id,
415         uint256 amount
416     ) internal virtual {
417         require(from != address(0), "ERC1155: burn from the zero address");
418 
419         address operator = _msgSender();
420 
421         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
422 
423         uint256 fromBalance = _balances[id][from];
424         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
425         unchecked {
426             _balances[id][from] = fromBalance - amount;
427         }
428 
429         emit TransferSingle(operator, from, address(0), id, amount);
430     }
431 
432     function _burnBatch(
433         address from,
434         uint256[] memory ids,
435         uint256[] memory amounts
436     ) internal virtual {
437         require(from != address(0), "ERC1155: burn from the zero address");
438         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
439 
440         address operator = _msgSender();
441 
442         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
443 
444         for (uint256 i = 0; i < ids.length; i++) {
445             uint256 id = ids[i];
446             uint256 amount = amounts[i];
447 
448             uint256 fromBalance = _balances[id][from];
449             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
450             unchecked {
451                 _balances[id][from] = fromBalance - amount;
452             }
453         }
454 
455         emit TransferBatch(operator, from, address(0), ids, amounts);
456     }
457 
458     function _setApprovalForAll(
459         address owner,
460         address operator,
461         bool approved
462     ) internal virtual {
463         require(owner != operator, "ERC1155: setting approval status for self");
464         _operatorApprovals[owner][operator] = approved;
465         emit ApprovalForAll(owner, operator, approved);
466     }
467 
468     function _beforeTokenTransfer(
469         address operator,
470         address from,
471         address to,
472         uint256[] memory ids,
473         uint256[] memory amounts,
474         bytes memory data
475     ) internal virtual {}
476 
477     function _doSafeTransferAcceptanceCheck(
478         address operator,
479         address from,
480         address to,
481         uint256 id,
482         uint256 amount,
483         bytes memory data
484     ) private {
485         if (to.isContract()) {
486             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
487                 if (response != IERC1155Receiver.onERC1155Received.selector) {
488                     revert("ERC1155: ERC1155Receiver rejected tokens");
489                 }
490             } catch Error(string memory reason) {
491                 revert(reason);
492             } catch {
493                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
494             }
495         }
496     }
497 
498     function _doSafeBatchTransferAcceptanceCheck(
499         address operator,
500         address from,
501         address to,
502         uint256[] memory ids,
503         uint256[] memory amounts,
504         bytes memory data
505     ) private {
506         if (to.isContract()) {
507             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
508                 bytes4 response
509             ) {
510                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
511                     revert("ERC1155: ERC1155Receiver rejected tokens");
512                 }
513             } catch Error(string memory reason) {
514                 revert(reason);
515             } catch {
516                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
517             }
518         }
519     }
520 
521     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
522         uint256[] memory array = new uint256[](1);
523         array[0] = element;
524 
525         return array;
526     }
527 }
528 
529 contract M101Allstars is ERC1155, Ownable {
530 
531     uint constant MAX_ALLSTARS = 50;
532     struct Allstar{
533         uint common_price;
534         uint holders_price;
535         uint max_supply;
536         uint total_supply;
537         string uri;
538         bool active;
539     }
540     mapping (uint => Allstar) private allstars;
541 
542     M101 public constant M101CONTRACT = M101(0x10A0cF0Fd3B9b2d575D78130B29d61252313423E);
543 
544     constructor() public ERC1155("") {
545         
546     }
547 
548     function addAllstar(uint _id, uint _common_price, uint _holders_price, uint _max_supply, string memory _uri) public onlyOwner {
549         require(_id < MAX_ALLSTARS, "Quantity limit reached");
550         require(getMaxSupply(_id) == 0, "Token is already exist");
551         allstars[_id].common_price = _common_price;
552         allstars[_id].holders_price = _holders_price;
553         allstars[_id].max_supply = _max_supply;
554         allstars[_id].uri = _uri;
555     }
556 
557     function active(uint _id, bool _active) public onlyOwner {
558         require(getMaxSupply(_id) != 0, "Token does not exist");
559         allstars[_id].active = _active;
560     }
561 
562     function getPrice(uint _id, address _to) public view returns(uint256){
563         require(getMaxSupply(_id) != 0, "Token does not exist");
564         uint256 _price;
565         if (M101CONTRACT.balanceOf(_to) != 0){
566             _price = allstars[_id].holders_price;
567         } else {
568             _price = allstars[_id].common_price;
569         }
570         return _price;
571     }
572 
573     function getMaxSupply(uint _id) public view returns(uint256){
574         return allstars[_id].max_supply;
575     }
576 
577     function getTotalSupply(uint _id) public view returns(uint256){
578         require(getMaxSupply(_id) != 0, "Token does not exist");
579         return allstars[_id].total_supply;
580     }
581 
582     function isActive(uint _id) public view returns(bool){
583         require(getMaxSupply(_id) != 0, "Token does not exist");
584         return allstars[_id].active;
585     }
586 
587     function mint(address _to, uint _count, uint _id) public payable {
588         require(getTotalSupply(_id) + _count <= getMaxSupply(_id), "Total supply limit reached or token does not exist");
589         if (msg.sender != owner()){
590             require(isActive(_id), "Sale has not started");
591             require(balanceOf(_to, _id) == 0, "Address already hold this token");
592             require(_count == 1, "Max 1 token");
593             require(msg.value == getPrice(_id, _to) * _count, "the Value is lower then the Price");
594         }
595         _mint(_to, _id, _count, "");
596         allstars[_id].total_supply += _count;
597     }
598 
599     function uri(uint256 _id) public view virtual override returns (string memory) {
600         return allstars[_id].uri;
601     }
602 
603     function withdrawAll() public payable onlyOwner {
604         require(payable(msg.sender).send(address(this).balance));
605     }
606 
607 }
608 
609 interface M101{
610     function balanceOf(address owner) external view returns (uint256 balance);
611 }