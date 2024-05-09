1 pragma solidity ^0.4.22;
2 
3 /// @title ERC-721に準拠した契約のインタフェース
4 contract ERC721 {
5     // イベント
6     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
7     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
8 
9     // 必要なメソッド
10     function balanceOf(address _owner) public view returns (uint256 _balance);
11     function ownerOf(uint256 _tokenId) external view returns (address _owner);
12     function approve(address _to, uint256 _tokenId) external;
13     function transfer(address _to, uint256 _tokenId) public;
14     function transferFrom(address _from, address _to, uint256 _tokenId) public;
15     function totalSupply() public view returns (uint);
16 
17     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
18     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
19 }
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33     * account.
34     */
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39 
40     /**
41     * @dev Throws if called by any account other than the owner.
42     */
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48 
49     /**
50     * @dev Allows the current owner to transfer control of the contract to a newOwner.
51     * @param newOwner The address to transfer ownership to.
52     */
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 
59 }
60 
61 /**
62  * @title Pausable
63  * @dev Base contract which allows children to implement an emergency stop mechanism.
64  */
65 contract Pausable is Ownable {
66     event Pause();
67     event Unpause();
68 
69     bool public paused = false;
70 
71 
72     /**
73     * @dev Modifier to make a function callable only when the contract is not paused.
74     *               契約が一時停止されている場合にのみアクションを許可する
75     */
76     modifier whenNotPaused() {
77         require(!paused);
78         _;
79     }
80 
81     /**
82     * @dev Modifier to make a function callable only when the contract is paused.
83     *               契約が一時停止されていない場合にのみアクションを許可する
84     */
85     modifier whenPaused() {
86         require(paused);
87         _;
88     }
89 
90     /**
91     * @dev called by the owner to pause, triggers stopped state
92     *             一時停止するために所有者によって呼び出され、停止状態をトリガする
93     */
94     function pause() onlyOwner whenNotPaused public {
95         paused = true;
96         emit Pause();
97     }
98 
99     /**
100     * @dev called by the owner to unpause, returns to normal state
101     *             ポーズをとるためにオーナーが呼び出し、通常の状態に戻ります
102     */
103     function unpause() onlyOwner whenPaused public {
104         paused = false;
105         emit Unpause();
106     }
107 }
108 
109 contract RocsCoreRe {
110 
111     function getRoc(uint _tokenId) public returns (
112         uint rocId,
113         string dna,
114         uint marketsFlg);
115 
116     function getRocIdToTokenId(uint _rocId) public view returns (uint);
117     function getRocIndexToOwner(uint _rocId) public view returns (address);
118 }
119 
120 contract ItemsBase is Pausable {
121     // ハント代
122     uint public huntingPrice = 5 finney;
123     function setHuntingPrice(uint256 price) public onlyOwner {
124         huntingPrice = price;
125     }
126 
127     // ERC721
128     event Transfer(address from, address to, uint tokenId);
129     event ItemTransfer(address from, address to, uint tokenId);
130 
131     // Itemの作成
132     event ItemCreated(address owner, uint tokenId, uint ticketId);
133 
134     event HuntingCreated(uint huntingId, uint rocId);
135 
136     /// @dev Itemの構造体
137     struct Item {
138         uint itemId;
139         uint8 marketsFlg;
140         uint rocId;
141         uint8 equipmentFlg;
142     }
143     Item[] public items;
144 
145     // itemIdとtokenIdのマッピング
146     mapping(uint => uint) public itemIndex;
147     // itemIdからtokenIdを取得
148     function getItemIdToTokenId(uint _itemId) public view returns (uint) {
149         return itemIndex[_itemId];
150     }
151 
152     /// @dev itemの所有するアドレスへのマッピング
153     mapping (uint => address) public itemIndexToOwner;
154     // @dev itemの所有者アドレスから所有するトークン数へのマッピング
155     mapping (address => uint) public itemOwnershipTokenCount;
156     /// @dev itemの呼び出しが承認されたアドレスへのマッピング
157     mapping (uint => address) public itemIndexToApproved;
158 
159     /// @dev 特定のitem所有権をアドレスに割り当てます。
160     function _transfer(address _from, address _to, uint256 _tokenId) internal {
161         itemOwnershipTokenCount[_to]++;
162         itemOwnershipTokenCount[_from]--;
163         itemIndexToOwner[_tokenId] = _to;
164         // イベント開始
165         emit ItemTransfer(_from, _to, _tokenId);
166     }
167 
168     address public rocCoreAddress;
169     RocsCoreRe rocCore;
170 
171     function setRocCoreAddress(address _rocCoreAddress) public onlyOwner {
172         rocCoreAddress = _rocCoreAddress;
173         rocCore = RocsCoreRe(rocCoreAddress);
174     }
175     function getRocCoreAddress() 
176         external
177         view
178         onlyOwner
179         returns (
180         address
181     ) {
182         return rocCore;
183     }
184 
185     /// @dev Huntingの構造体
186     struct Hunting {
187         uint huntingId;
188     }
189     // Huntingのmapping rocHuntingIndex[rocId][tokenId] = Hunting
190     mapping(uint => mapping (uint => Hunting)) public rocHuntingIndex;
191 
192     /// @notice Huntingを作成して保存する内部メソッド。 
193     /// @param _rocId 
194     /// @param _huntingId 
195     function _createRocHunting(
196         uint _rocId,
197         uint _huntingId
198     )
199         internal
200         returns (bool)
201     {
202         Hunting memory _hunting = Hunting({
203             huntingId: _huntingId
204         });
205 
206         rocHuntingIndex[_rocId][_huntingId] = _hunting;
207         // HuntingCreatedイベント
208         emit HuntingCreated(_huntingId, _rocId);
209 
210         return true;
211     }
212 }
213 
214 /// @title Item所有権を管理するコントラクト
215 /// @dev OpenZeppelinのERC721ドラフト実装に準拠
216 contract ItemsOwnership is ItemsBase, ERC721 {
217 
218     /// @notice ERC721で定義されている、置き換え不可能なトークンの名前と記号。
219     string public constant name = "CryptoFeatherItems";
220     string public constant symbol = "CCHI";
221 
222     bytes4 constant InterfaceSignature_ERC165 = 
223     bytes4(keccak256('supportsInterface(bytes4)'));
224 
225     bytes4 constant InterfaceSignature_ERC721 =
226     bytes4(keccak256('name()')) ^
227     bytes4(keccak256('symbol()')) ^
228     bytes4(keccak256('balanceOf(address)')) ^
229     bytes4(keccak256('ownerOf(uint256)')) ^
230     bytes4(keccak256('approve(address,uint256)')) ^
231     bytes4(keccak256('transfer(address,uint256)')) ^
232     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
233     bytes4(keccak256('totalSupply()'));
234 
235     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
236     ///  この契約によって実装された標準化されたインタフェースでtrueを返します。
237     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
238     {
239         // DEBUG ONLY
240         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
241         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
242     }
243 
244     /// @dev 特定のアドレスに指定されたitemの現在の所有者であるかどうかをチェックします。
245     /// @param _claimant 
246     /// @param _tokenId 
247     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
248         return itemIndexToOwner[_tokenId] == _claimant;
249     }
250 
251     /// @dev 特定のアドレスに指定されたitemが存在するかどうかをチェックします。
252     /// @param _claimant the address we are confirming kitten is approved for.
253     /// @param _tokenId kitten id, only valid when > 0
254     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
255         return itemIndexToApproved[_tokenId] == _claimant;
256     }
257 
258     /// @dev 以前の承認を上書きして、transferFrom（）に対して承認されたアドレスをマークします。
259     function _approve(uint256 _tokenId, address _approved) internal {
260         itemIndexToApproved[_tokenId] = _approved;
261     }
262 
263     // 指定されたアドレスのitem数を取得します。
264     function balanceOf(address _owner) public view returns (uint256 count) {
265         return itemOwnershipTokenCount[_owner];
266     }
267 
268     /// @notice itemの所有者を変更します。
269     /// @dev ERC-721への準拠に必要
270     function transfer(address _to, uint256 _tokenId) public whenNotPaused {
271         // 安全チェック
272         require(_to != address(0));
273         // 自分のitemしか送ることはできません。
274         require(_owns(msg.sender, _tokenId));
275         // 所有権の再割り当て、保留中の承認のクリア、転送イベントの送信
276         _transfer(msg.sender, _to, _tokenId);
277     }
278 
279     /// @notice transferFrom（）を介して別のアドレスに特定のitemを転送する権利を与えます。
280     /// @dev ERC-721への準拠に必要
281     function approve(address _to, uint256 _tokenId) external whenNotPaused {
282         // 所有者のみが譲渡承認を認めることができます。
283         require(_owns(msg.sender, _tokenId));
284         // 承認を登録します（以前の承認を置き換えます）。
285         _approve(_tokenId, _to);
286         // 承認イベントを発行する。
287         emit Approval(msg.sender, _to, _tokenId);
288     }
289 
290     /// @notice item所有者の変更を行います。を転送します。そのアドレスには、以前の所有者から転送承認が与えられています。
291     /// @dev ERC-721への準拠に必要
292     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
293         // 安全チェック。
294         require(_to != address(0));
295         // 承認と有効な所有権の確認
296         require(_approvedFor(msg.sender, _tokenId));
297         require(_owns(_from, _tokenId));
298         // 所有権を再割り当てします（保留中の承認をクリアし、転送イベントを発行します）。
299         _transfer(_from, _to, _tokenId);
300     }
301 
302     /// @notice 現在存在するitemの総数を返します。
303     /// @dev ERC-721への準拠に必要です。
304     function totalSupply() public view returns (uint) {
305         return items.length - 1;
306     }
307 
308     /// @notice 指定されたitemの現在所有権が割り当てられているアドレスを返します。
309     /// @dev ERC-721への準拠に必要です。
310     function ownerOf(uint256 _tokenId) external view returns (address owner) {
311         owner = itemIndexToOwner[_tokenId];
312         require(owner != address(0));
313     }
314 
315     /// @dev この契約に所有権を割り当て、NFTを強制終了します。
316     /// @param _owner 
317     /// @param _tokenId 
318     function _escrow(address _owner, uint256 _tokenId) internal {
319         // it will throw if transfer fails
320         transferFrom(_owner, this, _tokenId);
321     }
322 
323 }
324 
325 /// @title Itemに関する管理を行うコントラクト
326 contract ItemsBreeding is ItemsOwnership {
327 
328     /// @notice Itemを作成して保存。 
329     /// @param _itemId 
330     /// @param _marketsFlg 
331     /// @param _rocId 
332     /// @param _equipmentFlg 
333     /// @param _owner 
334     function _createItem(
335         uint _itemId,
336         uint _marketsFlg,
337         uint _rocId,
338         uint _equipmentFlg,
339         address _owner
340     )
341         internal
342         returns (uint)
343     {
344         Item memory _item = Item({
345             itemId: _itemId,
346             marketsFlg: uint8(_marketsFlg),
347             rocId: _rocId,
348             equipmentFlg: uint8(_equipmentFlg)
349         });
350 
351         uint newItemId = items.push(_item) - 1;
352         // 同一のトークンIDが発生した場合は実行を停止します
353         require(newItemId == uint(newItemId));
354         // RocCreatedイベント
355         emit ItemCreated(_owner, newItemId, _itemId);
356 
357         // これにより所有権が割り当てられ、ERC721ドラフトごとに転送イベントが発行されます
358         itemIndex[_itemId] = newItemId;
359         _transfer(0, _owner, newItemId);
360 
361         return newItemId;
362     }
363 
364     /// @notice アイテムの装備状態を更新します。 
365     /// @param _reItems 
366     /// @param _inItems 
367     /// @param _rocId 
368     function equipmentItem(
369         uint[] _reItems,
370         uint[] _inItems,
371         uint _rocId
372     )
373         external
374         whenNotPaused
375         returns(bool)
376     {
377         uint checkTokenId = rocCore.getRocIdToTokenId(_rocId);
378         uint i;
379         uint itemTokenId;
380         Item memory item;
381         // 解除
382         for (i = 0; i < _reItems.length; i++) {
383             itemTokenId = getItemIdToTokenId(_reItems[i]);
384             // itemのパラメータチェック
385             item = items[itemTokenId];
386             // マーケットへの出品中か確認してください。
387             require(uint(item.marketsFlg) == 0);
388             // アイテム装着中か確認してください。
389             require(uint(item.equipmentFlg) == 1);
390             // 装着チックが同一か確認してください。
391             require(uint(item.rocId) == _rocId);
392             // 装備解除
393             items[itemTokenId].rocId = 0;
394             items[itemTokenId].equipmentFlg = 0;
395             // アイテムのオーナーが違えばチックのオーナーをセットしなおします。
396             address itemOwner = itemIndexToOwner[itemTokenId];
397             address checkOwner = rocCore.getRocIndexToOwner(checkTokenId);
398             if (itemOwner != checkOwner) {
399                 itemIndexToOwner[itemTokenId] = checkOwner;
400             }
401         }
402         // 装着
403         for (i = 0; i < _inItems.length; i++) {
404             itemTokenId = getItemIdToTokenId(_inItems[i]);
405             // itemのパラメータチェック
406             item = items[itemTokenId];
407             // itemのオーナーである事
408             require(_owns(msg.sender, itemTokenId));
409             // マーケットへの出品中か確認してください。
410             require(uint(item.marketsFlg) == 0);
411             // アイテム未装備か確認してください。
412             require(uint(item.equipmentFlg) == 0);
413             // 装備処理
414             items[itemTokenId].rocId = _rocId;
415             items[itemTokenId].equipmentFlg = 1;
416         }
417         return true;
418     }
419 
420     /// @notice 消費した事で削除の処理を行います。
421     /// @param _itemId 
422     function usedItem(
423         uint _itemId
424     )
425         external
426         whenNotPaused
427         returns(bool)
428     {
429         uint itemTokenId = getItemIdToTokenId(_itemId);
430         Item memory item = items[itemTokenId];
431         // itemのオーナーである事
432         require(_owns(msg.sender, itemTokenId));
433         // マーケットへの出品中か確認してください。
434         require(uint(item.marketsFlg) == 0);
435         // アイテム未装備か確認してください。
436         require(uint(item.equipmentFlg) == 0);
437         delete itemIndex[_itemId];
438         delete items[itemTokenId];
439         delete itemIndexToOwner[itemTokenId];
440         return true;
441     }
442 
443     /// @notice Huntingの処理を行います。
444     /// @param _rocId 
445     /// @param _huntingId 
446     /// @param _items 
447     function processHunting(
448         uint _rocId,
449         uint _huntingId,
450         uint[] _items
451     )
452         external
453         payable
454         whenNotPaused
455         returns(bool)
456     {
457         require(msg.value >= huntingPrice);
458 
459         uint checkTokenId = rocCore.getRocIdToTokenId(_rocId);
460         uint marketsFlg;
461         ( , , marketsFlg) = rocCore.getRoc(checkTokenId);
462 
463         // markets中か確認してください。
464         require(marketsFlg == 0);
465         bool createHunting = false;
466         // Hunting処理
467         require(_huntingId > 0);
468         createHunting = _createRocHunting(
469             _rocId,
470             _huntingId
471         );
472 
473         uint i;
474         for (i = 0; i < _items.length; i++) {
475             _createItem(
476                 _items[i],
477                 0,
478                 0,
479                 0,
480                 msg.sender
481             );
482         }
483 
484         // 超過分を買い手に返す
485         uint256 bidExcess = msg.value - huntingPrice;
486         msg.sender.transfer(bidExcess);
487 
488         return createHunting;
489     }
490 
491     /// @notice Itemを作成します。イベント用
492     /// @param _items 
493     /// @param _owners 
494     function createItems(
495         uint[] _items,
496         address[] _owners
497     )
498         external onlyOwner
499         returns (uint)
500     {
501         uint i;
502         uint createItemId;
503         for (i = 0; i < _items.length; i++) {
504             createItemId = _createItem(
505                 _items[i],
506                 0,
507                 0,
508                 0,
509                 _owners[i]
510             );
511         }
512         return createItemId;
513     }
514 
515 }
516 
517 /// @title ItemのMarketに関する処理
518 contract ItemsMarkets is ItemsBreeding {
519 
520     event ItemMarketsCreated(uint256 tokenId, uint128 marketsPrice);
521     event ItemMarketsSuccessful(uint256 tokenId, uint128 marketsPriceice, address buyer);
522     event ItemMarketsCancelled(uint256 tokenId);
523 
524     // ERC721
525     event Transfer(address from, address to, uint tokenId);
526 
527     // NFT上のMarket
528     struct ItemMarkets {
529         // 登録時のNFT売手
530         address seller;
531         // Marketの価格
532         uint128 marketsPrice;
533     }
534 
535     // トークンIDから対応するマーケットへの出品にマップします。
536     mapping (uint256 => ItemMarkets) tokenIdToItemMarkets;
537 
538     // マーケットへの出品の手数料を設定
539     uint256 public ownerCut = 0;
540     function setOwnerCut(uint256 _cut) public onlyOwner {
541         require(_cut <= 10000);
542         ownerCut = _cut;
543     }
544 
545     /// @notice Itemマーケットへの出品を作成し、開始します。
546     /// @param _itemId 
547     /// @param _marketsPrice 
548     function createItemSaleMarkets(
549         uint256 _itemId,
550         uint256 _marketsPrice
551     )
552         external
553         whenNotPaused
554     {
555         require(_marketsPrice == uint256(uint128(_marketsPrice)));
556 
557         // チェック用のtokenIdをセット
558         uint itemTokenId = getItemIdToTokenId(_itemId);
559         // itemのオーナーである事
560         require(_owns(msg.sender, itemTokenId));
561         // itemのパラメータチェック
562         Item memory item = items[itemTokenId];
563         // マーケットへの出品中か確認してください。
564         require(uint(item.marketsFlg) == 0);
565         // 装備中か確認してください。
566         require(uint(item.rocId) == 0);
567         require(uint(item.equipmentFlg) == 0);
568         // 承認
569         _approve(itemTokenId, msg.sender);
570         // マーケットへの出品セット
571         _escrow(msg.sender, itemTokenId);
572         ItemMarkets memory itemMarkets = ItemMarkets(
573             msg.sender,
574             uint128(_marketsPrice)
575         );
576 
577         // マーケットへの出品FLGをセット
578         items[itemTokenId].marketsFlg = 1;
579 
580         _itemAddMarkets(itemTokenId, itemMarkets);
581     }
582 
583     /// @dev マーケットへの出品を公開マーケットへの出品のリストに追加します。 
584     ///  また、ItemMarketsCreatedイベントを発生させます。
585     /// @param _tokenId The ID of the token to be put on markets.
586     /// @param _markets Markets to add.
587     function _itemAddMarkets(uint256 _tokenId, ItemMarkets _markets) internal {
588         tokenIdToItemMarkets[_tokenId] = _markets;
589         emit ItemMarketsCreated(
590             uint256(_tokenId),
591             uint128(_markets.marketsPrice)
592         );
593     }
594 
595     /// @dev マーケットへの出品を公開マーケットへの出品のリストから削除します。
596     /// @param _tokenId 
597     function _itemRemoveMarkets(uint256 _tokenId) internal {
598         delete tokenIdToItemMarkets[_tokenId];
599     }
600 
601     /// @dev 無条件にマーケットへの出品を取り消します。
602     /// @param _tokenId 
603     function _itemCancelMarkets(uint256 _tokenId) internal {
604         _itemRemoveMarkets(_tokenId);
605         emit ItemMarketsCancelled(_tokenId);
606     }
607 
608     /// @dev まだ獲得されていないマーケットへの出品をキャンセルします。
609     ///  元の所有者にNFTを返します。
610     /// @notice これは、契約が一時停止している間に呼び出すことができる状態変更関数です。
611     /// @param _itemId 
612     function itemCancelMarkets(uint _itemId) external {
613         uint itemTokenId = getItemIdToTokenId(_itemId);
614         ItemMarkets storage markets = tokenIdToItemMarkets[itemTokenId];
615         address seller = markets.seller;
616         require(msg.sender == seller);
617         _itemCancelMarkets(itemTokenId);
618         itemIndexToOwner[itemTokenId] = seller;
619         items[itemTokenId].marketsFlg = 0;
620     }
621 
622     /// @dev 契約が一時停止されたときにマーケットへの出品をキャンセルします。
623     ///  所有者だけがこれを行うことができ、NFTは売り手に返されます。 
624     ///  緊急時にのみ使用してください。
625     /// @param _itemId 
626     function itemCancelMarketsWhenPaused(uint _itemId) whenPaused onlyOwner external {
627         uint itemTokenId = getItemIdToTokenId(_itemId);
628         ItemMarkets storage markets = tokenIdToItemMarkets[itemTokenId];
629         address seller = markets.seller;
630         _itemCancelMarkets(itemTokenId);
631         itemIndexToOwner[itemTokenId] = seller;
632         items[itemTokenId].marketsFlg = 0;
633     }
634 
635     /// @dev マーケットへの出品入札
636     ///  十分な量のEtherが供給されればNFTの所有権を移転する。
637     /// @param _itemId 
638     function itemBid(uint _itemId) external payable whenNotPaused {
639         uint itemTokenId = getItemIdToTokenId(_itemId);
640         // マーケットへの出品構造体への参照を取得する
641         ItemMarkets storage markets = tokenIdToItemMarkets[itemTokenId];
642 
643         uint128 sellingPrice = uint128(markets.marketsPrice);
644         // 入札額が価格以上である事を確認する。
645         // msg.valueはweiの数
646         require(msg.value >= sellingPrice);
647         // マーケットへの出品構造体が削除される前に、販売者への参照を取得します。
648         address seller = markets.seller;
649 
650         // マーケットへの出品を削除します。
651         _itemRemoveMarkets(itemTokenId);
652 
653         if (sellingPrice > 0) {
654             // 競売人のカットを計算します。
655             uint128 marketseerCut = uint128(_computeCut(sellingPrice));
656             uint128 sellerProceeds = sellingPrice - marketseerCut;
657 
658             // 売り手に送金する
659             seller.transfer(sellerProceeds);
660         }
661 
662         // 超過分を買い手に返す
663         msg.sender.transfer(msg.value - sellingPrice);
664         // イベント
665         emit ItemMarketsSuccessful(itemTokenId, sellingPrice, msg.sender);
666 
667         _transfer(seller, msg.sender, itemTokenId);
668         // マーケットへの出品FLGをセット
669         items[itemTokenId].marketsFlg = 0;
670     }
671 
672     /// @dev 手数料計算
673     /// @param _price 
674     function _computeCut(uint128 _price) internal view returns (uint) {
675         return _price * ownerCut / 10000;
676     }
677 
678 }
679 
680 /// @title CryptoFeather
681 contract ItemsCore is ItemsMarkets {
682 
683     // コア契約が壊れてアップグレードが必要な場合に設定します
684     address public newContractAddress;
685 
686     /// @dev 一時停止を無効にすると、契約を一時停止する前にすべての外部契約アドレスを設定する必要があります。
687     function unpause() public onlyOwner whenPaused {
688         require(newContractAddress == address(0));
689         // 実際に契約を一時停止しないでください。
690         super.unpause();
691     }
692 
693     // @dev 利用可能な残高を取得できるようにします。
694     function withdrawBalance(uint _subtractFees) external onlyOwner {
695         uint256 balance = address(this).balance;
696         if (balance > _subtractFees) {
697             owner.transfer(balance - _subtractFees);
698         }
699     }
700 
701     /// @notice tokenIdからItemに関するすべての関連情報を返します。
702     /// @param _tokenId 
703     function getItem(uint _tokenId)
704         external
705         view
706         returns (
707         uint itemId,
708         uint marketsFlg,
709         uint rocId,
710         uint equipmentFlg
711     ) {
712         Item memory item = items[_tokenId];
713         itemId = uint(item.itemId);
714         marketsFlg = uint(item.marketsFlg);
715         rocId = uint(item.rocId);
716         equipmentFlg = uint(item.equipmentFlg);
717     }
718 
719     /// @notice itemIdからItemに関するすべての関連情報を返します。
720     /// @param _itemId 
721     function getItemItemId(uint _itemId)
722         external
723         view
724         returns (
725         uint itemId,
726         uint marketsFlg,
727         uint rocId,
728         uint equipmentFlg
729     ) {
730         Item memory item = items[getItemIdToTokenId(_itemId)];
731         itemId = uint(item.itemId);
732         marketsFlg = uint(item.marketsFlg);
733         rocId = uint(item.rocId);
734         equipmentFlg = uint(item.equipmentFlg);
735     }
736 
737     /// @notice itemIdからMarkets情報を返します。
738     /// @param _itemId 
739     function getMarketsItemId(uint _itemId)
740         external
741         view
742         returns (
743         address seller,
744         uint marketsPrice
745     ) {
746         uint itemTokenId = getItemIdToTokenId(_itemId);
747         ItemMarkets storage markets = tokenIdToItemMarkets[itemTokenId];
748         seller = markets.seller;
749         marketsPrice = uint(markets.marketsPrice);
750     }
751 
752     /// @notice itemIdからオーナー情報を返します。
753     /// @param _itemId 
754     function getItemIndexToOwner(uint _itemId)
755         external
756         view
757         returns (
758         address owner
759     ) {
760         uint itemTokenId = getItemIdToTokenId(_itemId);
761         owner = itemIndexToOwner[itemTokenId];
762     }
763 
764     /// @notice rocIdとhuntingIdからhuntingの存在チェック
765     /// @param _rocId 
766     /// @param _huntingId 
767     function getHunting(uint _rocId, uint _huntingId)
768         public
769         view
770         returns (
771         uint huntingId
772     ) {
773         Hunting memory hunting = rocHuntingIndex[_rocId][_huntingId];
774         huntingId = uint(hunting.huntingId);
775     }
776 
777     /// @notice _rocIdからオーナー情報を返します。
778     /// @param _rocId 
779     function getRocOwnerItem(uint _rocId)
780         external
781         view
782         returns (
783         address owner
784     ) {
785         uint checkTokenId = rocCore.getRocIdToTokenId(_rocId);
786         owner = rocCore.getRocIndexToOwner(checkTokenId);
787     }
788 
789 }