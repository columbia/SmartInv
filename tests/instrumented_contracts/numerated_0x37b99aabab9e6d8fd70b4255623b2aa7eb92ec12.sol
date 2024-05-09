1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21 
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48     event Pause();
49     event Unpause();
50 
51     bool public paused = false;
52 
53 
54     /**
55     * @dev Modifier to make a function callable only when the contract is not paused.
56     *               契約が一時停止されている場合にのみアクションを許可する
57     */
58     modifier whenNotPaused() {
59         require(!paused);
60         _;
61     }
62 
63     /**
64     * @dev Modifier to make a function callable only when the contract is paused.
65     *               契約が一時停止されていない場合にのみアクションを許可する
66     */
67     modifier whenPaused() {
68         require(paused);
69         _;
70     }
71 
72     /**
73     * @dev called by the owner to pause, triggers stopped state
74     *             一時停止するために所有者によって呼び出され、停止状態をトリガする
75     */
76     function pause() onlyOwner whenNotPaused public {
77         paused = true;
78         emit Pause();
79     }
80 
81     /**
82     * @dev called by the owner to unpause, returns to normal state
83     *             ポーズをとるためにオーナーが呼び出し、通常の状態に戻ります
84     */
85     function unpause() onlyOwner whenPaused public {
86         paused = false;
87         emit Unpause();
88     }
89 }
90 
91 contract RocsBase is Pausable {
92 
93     // 生誕代
94     uint128 public eggPrice = 50 finney;
95     function setEggPrice(uint128 _price) public onlyOwner {
96         eggPrice = _price;
97     }
98     // 進化代
99     uint128 public evolvePrice = 5 finney;
100     function setEvolvePrice(uint128 _price) public onlyOwner {
101         evolvePrice = _price;
102     }
103 
104     // 生誕
105     event RocCreated(address owner, uint tokenId, uint rocId);
106     // ERC721
107     event Transfer(address from, address to, uint tokenId);
108     event ItemTransfer(address from, address to, uint tokenId);
109 
110     /// @dev Rocの構造体
111     struct Roc {
112         // ID
113         uint rocId;
114         // DNA
115         string dna;
116         // 出品中フラグ 1は出品中
117         uint8 marketsFlg;
118     }
119 
120     /// @dev Rocsの配列
121     Roc[] public rocs;
122 
123     // rocIdとtokenIdのマッピング
124     mapping(uint => uint) public rocIndex;
125     // rocIdからtokenIdを取得
126     function getRocIdToTokenId(uint _rocId) public view returns (uint) {
127         return rocIndex[_rocId];
128     }
129 
130     /// @dev 所有するアドレスへのマッピング
131     mapping (uint => address) public rocIndexToOwner;
132     // @dev 所有者アドレスから所有するトークン数へのマッピング
133     mapping (address => uint) public ownershipTokenCount;
134     /// @dev 呼び出しが承認されたアドレスへのマッピング
135     mapping (uint => address) public rocIndexToApproved;
136 
137     /// @dev 特定のRocの所有権をアドレスに割り当てます。
138     function _transfer(address _from, address _to, uint256 _tokenId) internal {
139         ownershipTokenCount[_to]++;
140         ownershipTokenCount[_from]--;
141         rocIndexToOwner[_tokenId] = _to;
142         // イベント開始
143         emit Transfer(_from, _to, _tokenId);
144     }
145 
146 }
147 
148 /// @title ERC-721に準拠した契約のインタフェース：置き換え不可能なトークン
149 contract ERC721 {
150     // イベント
151     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
152     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
153 
154     // 必要なメソッド
155     function balanceOf(address _owner) public view returns (uint256 _balance);
156     function ownerOf(uint256 _tokenId) external view returns (address _owner);
157     function approve(address _to, uint256 _tokenId) external;
158     function transfer(address _to, uint256 _tokenId) public;
159     function transferFrom(address _from, address _to, uint256 _tokenId) public;
160     function totalSupply() public view returns (uint);
161 
162     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
163     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
164 }
165 
166 /// @title Roc所有権を管理するコントラクト
167 /// @dev OpenZeppelinのERC721ドラフト実装に準拠
168 contract RocsOwnership is RocsBase, ERC721 {
169 
170     /// @notice ERC721で定義されている、置き換え不可能なトークンの名前と記号。
171     string public constant name = "CryptoFeather";
172     string public constant symbol = "CFE";
173 
174     bytes4 constant InterfaceSignature_ERC165 = 
175     bytes4(keccak256('supportsInterface(bytes4)'));
176 
177     bytes4 constant InterfaceSignature_ERC721 =
178     bytes4(keccak256('name()')) ^
179     bytes4(keccak256('symbol()')) ^
180     bytes4(keccak256('balanceOf(address)')) ^
181     bytes4(keccak256('ownerOf(uint256)')) ^
182     bytes4(keccak256('approve(address,uint256)')) ^
183     bytes4(keccak256('transfer(address,uint256)')) ^
184     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
185     bytes4(keccak256('totalSupply()'));
186 
187     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
188     ///  この契約によって実装された標準化されたインタフェースでtrueを返します。
189     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
190     {
191         // DEBUG ONLY
192         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
193         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
194     }
195 
196     /// @dev 特定のアドレスに指定されたrocの現在の所有者であるかどうかをチェックします。
197     /// @param _claimant 
198     /// @param _tokenId 
199     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
200         return rocIndexToOwner[_tokenId] == _claimant;
201     }
202 
203     /// @dev 特定のアドレスに指定されたrocが存在するかどうかをチェックします。
204     /// @param _claimant the address we are confirming kitten is approved for.
205     /// @param _tokenId kitten id, only valid when > 0
206     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
207         return rocIndexToApproved[_tokenId] == _claimant;
208     }
209 
210     /// @dev 以前の承認を上書きして、transferFrom（）に対して承認されたアドレスをマークします。
211     function _approve(uint256 _tokenId, address _approved) internal {
212         rocIndexToApproved[_tokenId] = _approved;
213     }
214 
215     // 指定されたアドレスのroc数を取得します。
216     function balanceOf(address _owner) public view returns (uint256 count) {
217         return ownershipTokenCount[_owner];
218     }
219 
220     /// @notice rocの所有者を変更します。
221     /// @dev ERC-721への準拠に必要
222     function transfer(address _to, uint256 _tokenId) public whenNotPaused {
223         // 安全チェック
224         require(_to != address(0));
225         // 自分のrocしか送ることはできません。
226         require(_owns(msg.sender, _tokenId));
227         // 所有権の再割り当て、保留中の承認のクリア、転送イベントの送信
228         _transfer(msg.sender, _to, _tokenId);
229     }
230 
231     /// @notice transferFrom（）を介して別のアドレスに特定のrocを転送する権利を与えます。
232     /// @dev ERC-721への準拠に必要
233     function approve(address _to, uint256 _tokenId) external whenNotPaused {
234         // 所有者のみが譲渡承認を認めることができます。
235         require(_owns(msg.sender, _tokenId));
236         // 承認を登録します（以前の承認を置き換えます）。
237         _approve(_tokenId, _to);
238         // 承認イベントを発行する。
239         emit Approval(msg.sender, _to, _tokenId);
240     }
241 
242     /// @notice roc所有者の変更を行います。を転送します。そのアドレスには、以前の所有者から転送承認が与えられています。
243     /// @dev ERC-721への準拠に必要
244     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
245         // 安全チェック。
246         require(_to != address(0));
247         // 承認と有効な所有権の確認
248         require(_approvedFor(msg.sender, _tokenId));
249         require(_owns(_from, _tokenId));
250         // 所有権を再割り当てします（保留中の承認をクリアし、転送イベントを発行します）。
251         _transfer(_from, _to, _tokenId);
252     }
253 
254     /// @notice 現在存在するrocの総数を返します。
255     /// @dev ERC-721への準拠に必要です。
256     function totalSupply() public view returns (uint) {
257         return rocs.length - 1;
258     }
259 
260     /// @notice 指定されたrocの現在所有権が割り当てられているアドレスを返します。
261     /// @dev ERC-721への準拠に必要です。
262     function ownerOf(uint256 _tokenId) external view returns (address owner) {
263         owner = rocIndexToOwner[_tokenId];
264         require(owner != address(0));
265     }
266 
267     /// @dev この契約に所有権を割り当て、NFTを強制終了します。
268     /// @param _owner 
269     /// @param _tokenId 
270     function _escrow(address _owner, uint256 _tokenId) internal {
271         // it will throw if transfer fails
272         transferFrom(_owner, this, _tokenId);
273     }
274 
275 }
276 
277 /// @title Rocの飼育に関する管理を行うコントラクト
278 contract RocsBreeding is RocsOwnership {
279 
280     /// @notice 新しいRocを作成して保存。 
281     /// @param _rocId 
282     /// @param _dna 
283     /// @param _marketsFlg 
284     /// @param _owner 
285     /// @dev RocCreatedイベントとTransferイベントの両方を生成します。 
286     function _createRoc(
287         uint _rocId,
288         string _dna,
289         uint _marketsFlg,
290         address _owner
291     )
292         internal
293         returns (uint)
294     {
295         Roc memory _roc = Roc({
296             rocId: _rocId,
297             dna: _dna,
298             marketsFlg: uint8(_marketsFlg)
299         });
300 
301         uint newRocId = rocs.push(_roc) - 1;
302         // 同一のトークンIDが発生した場合は実行を停止します
303         require(newRocId == uint(newRocId));
304         // RocCreatedイベント
305         emit RocCreated(_owner, newRocId, _rocId);
306 
307         // これにより所有権が割り当てられ、ERC721ドラフトごとに転送イベントが発行されます
308         rocIndex[_rocId] = newRocId;
309         _transfer(0, _owner, newRocId);
310 
311         return newRocId;
312     }
313 
314     /// @notice 新たに生み出します 
315     /// @param _rocId 
316     /// @param _dna 
317     function giveProduce(uint _rocId, string _dna)
318         external
319         payable
320         whenNotPaused
321         returns(uint)
322     {
323         // 支払いを確認します。
324         require(msg.value >= eggPrice);
325         uint createRocId = _createRoc(
326             _rocId,
327             _dna, 
328             0, 
329             msg.sender
330         );
331         // 超過分を買い手に返す
332         uint256 bidExcess = msg.value - eggPrice;
333         msg.sender.transfer(bidExcess);
334 
335         return createRocId;
336     }
337 
338     /// @notice 初めてのRoc 
339     /// @param _rocId 
340     /// @param _dna 
341     function freeGiveProduce(uint _rocId, string _dna)
342         external
343         payable
344         whenNotPaused
345         returns(uint)
346     {
347         // 初めてのRocか確認します。
348         require(balanceOf(msg.sender) == 0);
349         uint createRocId = _createRoc(
350             _rocId,
351             _dna, 
352             0, 
353             msg.sender
354         );
355         // 超過分を買い手に返す
356         uint256 bidExcess = msg.value;
357         msg.sender.transfer(bidExcess);
358 
359         return createRocId;
360     }
361 
362 }
363 
364 /// @title Rocの売買のためのMarkets処理
365 contract RocsMarkets is RocsBreeding {
366 
367     event MarketsCreated(uint256 tokenId, uint128 marketsPrice);
368     event MarketsSuccessful(uint256 tokenId, uint128 marketsPriceice, address buyer);
369     event MarketsCancelled(uint256 tokenId);
370 
371     // NFT上のマーケットへの出品
372     struct Markets {
373         // 登録時のNFT売手
374         address seller;
375         // 価格
376         uint128 marketsPrice;
377     }
378 
379     // トークンIDから対応するマーケットへの出品にマップします。
380     mapping (uint256 => Markets) tokenIdToMarkets;
381 
382     // マーケットへの出品の手数料を設定
383     uint256 public ownerCut = 0;
384     function setOwnerCut(uint256 _cut) public onlyOwner {
385         require(_cut <= 10000);
386         ownerCut = _cut;
387     }
388 
389     /// @notice Rocマーケットへの出品を作成し、開始します。
390     /// @param _rocId 
391     /// @param _marketsPrice 
392     function createRocSaleMarkets(
393         uint256 _rocId,
394         uint256 _marketsPrice
395     )
396         external
397         whenNotPaused
398     {
399         require(_marketsPrice == uint256(uint128(_marketsPrice)));
400 
401         // チェック用のtokenIdをセット
402         uint checkTokenId = getRocIdToTokenId(_rocId);
403 
404         // checkのオーナーである事
405         require(_owns(msg.sender, checkTokenId));
406         // checkのパラメータチェック
407         Roc memory roc = rocs[checkTokenId];
408         // マーケットへの出品中か確認してください。
409         require(uint8(roc.marketsFlg) == 0);
410         // 承認
411         _approve(checkTokenId, msg.sender);
412         // マーケットへの出品セット
413         _escrow(msg.sender, checkTokenId);
414         Markets memory markets = Markets(
415             msg.sender,
416             uint128(_marketsPrice)
417         );
418 
419         // マーケットへの出品FLGをセット
420         rocs[checkTokenId].marketsFlg = 1;
421         _addMarkets(checkTokenId, markets);
422     }
423 
424     /// @dev マーケットへの出品を公開マーケットへの出品のリストに追加します。 
425     ///  また、MarketsCreatedイベントを発生させます。
426     /// @param _tokenId The ID of the token to be put on markets.
427     /// @param _markets Markets to add.
428     function _addMarkets(uint256 _tokenId, Markets _markets) internal {
429         tokenIdToMarkets[_tokenId] = _markets;
430         emit MarketsCreated(
431             uint256(_tokenId),
432             uint128(_markets.marketsPrice)
433         );
434     }
435 
436     /// @dev マーケットへの出品を公開マーケットへの出品のリストから削除します。
437     /// @param _tokenId 
438     function _removeMarkets(uint256 _tokenId) internal {
439         delete tokenIdToMarkets[_tokenId];
440     }
441 
442     /// @dev 無条件にマーケットへの出品を取り消します。
443     /// @param _tokenId 
444     function _cancelMarkets(uint256 _tokenId) internal {
445         _removeMarkets(_tokenId);
446         emit MarketsCancelled(_tokenId);
447     }
448 
449     /// @dev まだ獲得されていないMarketsをキャンセルします。
450     ///  元の所有者にNFTを返します。
451     /// @notice これは、契約が一時停止している間に呼び出すことができる状態変更関数です。
452     /// @param _rocId 
453     function cancelMarkets(uint _rocId) external {
454         uint checkTokenId = getRocIdToTokenId(_rocId);
455         Markets storage markets = tokenIdToMarkets[checkTokenId];
456         address seller = markets.seller;
457         require(msg.sender == seller);
458         _cancelMarkets(checkTokenId);
459         rocIndexToOwner[checkTokenId] = seller;
460         rocs[checkTokenId].marketsFlg = 0;
461     }
462 
463     /// @dev 契約が一時停止されたときにMarketsをキャンセルします。
464     ///  所有者だけがこれを行うことができ、NFTは売り手に返されます。 
465     ///  緊急時にのみ使用してください。
466     /// @param _rocId 
467     function cancelMarketsWhenPaused(uint _rocId) whenPaused onlyOwner external {
468         uint checkTokenId = getRocIdToTokenId(_rocId);
469         Markets storage markets = tokenIdToMarkets[checkTokenId];
470         address seller = markets.seller;
471         _cancelMarkets(checkTokenId);
472         rocIndexToOwner[checkTokenId] = seller;
473         rocs[checkTokenId].marketsFlg = 0;
474     }
475 
476     /// @dev Markets入札
477     ///  十分な量のEtherが供給されればNFTの所有権を移転する。
478     /// @param _rocId 
479     function bid(uint _rocId) external payable whenNotPaused {
480         uint checkTokenId = getRocIdToTokenId(_rocId);
481         // マーケットへの出品構造体への参照を取得する
482         Markets storage markets = tokenIdToMarkets[checkTokenId];
483 
484         uint128 sellingPrice = uint128(markets.marketsPrice);
485         // 入札額が価格以上である事を確認する。
486         // msg.valueはweiの数
487         require(msg.value >= sellingPrice);
488         // マーケットへの出品構造体が削除される前に、販売者への参照を取得します。
489         address seller = markets.seller;
490 
491         // マーケットへの出品を削除します。
492         _removeMarkets(checkTokenId);
493 
494         if (sellingPrice > 0) {
495             // 競売人のカットを計算します。
496             uint128 marketseerCut = uint128(_computeCut(sellingPrice));
497             uint128 sellerProceeds = sellingPrice - marketseerCut;
498 
499             // 売り手に送金する
500             seller.transfer(sellerProceeds);
501         }
502 
503         // 超過分を買い手に返す
504         msg.sender.transfer(msg.value - sellingPrice);
505         // イベント
506         emit MarketsSuccessful(checkTokenId, sellingPrice, msg.sender);
507 
508         _transfer(seller, msg.sender, checkTokenId);
509         // マーケットへの出品FLGをセット
510         rocs[checkTokenId].marketsFlg = 0;
511     }
512 
513     /// @dev 手数料計算
514     /// @param _price 
515     function _computeCut(uint128 _price) internal view returns (uint) {
516         return _price * ownerCut / 10000;
517     }
518 
519 }
520 
521 /// @title CryptoRocs
522 contract RocsCore is RocsMarkets {
523 
524     // コア契約が壊れてアップグレードが必要な場合に設定します
525     address public newContractAddress;
526 
527     /// @dev 一時停止を無効にすると、契約を一時停止する前にすべての外部契約アドレスを設定する必要があります。
528     function unpause() public onlyOwner whenPaused {
529         require(newContractAddress == address(0));
530         // 実際に契約を一時停止しないでください。
531         super.unpause();
532     }
533 
534     // @dev 利用可能な残高を取得できるようにします。
535     function withdrawBalance(uint _subtractFees) external onlyOwner {
536         uint256 balance = address(this).balance;
537         if (balance > _subtractFees) {
538             owner.transfer(balance - _subtractFees);
539         }
540     }
541 
542     /// @notice tokenIdからRocに関するすべての関連情報を返します。
543     /// @param _tokenId トークンID
544     function getRoc(uint _tokenId)
545         external
546         view
547         returns (
548         uint rocId,
549         string dna,
550         uint marketsFlg
551     ) {
552         Roc memory roc = rocs[_tokenId];
553         rocId = uint(roc.rocId);
554         dna = string(roc.dna);
555         marketsFlg = uint(roc.marketsFlg);
556     }
557 
558     /// @notice rocIdからRocに関するすべての関連情報を返します。
559     /// @param _rocId rocId
560     function getRocrocId(uint _rocId)
561         external
562         view
563         returns (
564         uint rocId,
565         string dna,
566         uint marketsFlg
567     ) {
568         Roc memory roc = rocs[getRocIdToTokenId(_rocId)];
569         rocId = uint(roc.rocId);
570         dna = string(roc.dna);
571         marketsFlg = uint(roc.marketsFlg);
572     }
573 
574     /// @notice rocIdからMarkets情報を返します。
575     /// @param _rocId rocId
576     function getMarketsRocId(uint _rocId)
577         external
578         view
579         returns (
580         address seller,
581         uint marketsPrice
582     ) {
583         uint checkTokenId = getRocIdToTokenId(_rocId);
584         Markets memory markets = tokenIdToMarkets[checkTokenId];
585         seller = markets.seller;
586         marketsPrice = uint(markets.marketsPrice);
587     }
588 
589     /// @notice rocIdからオーナー情報を返します。
590     /// @param _rocId rocId
591     function getRocIndexToOwner(uint _rocId)
592         external
593         view
594         returns (
595         address owner
596     ) {
597         uint checkTokenId = getRocIdToTokenId(_rocId);
598         owner = rocIndexToOwner[checkTokenId];
599     }
600 
601 }