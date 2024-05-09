1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity ^0.4.23;
15 
16 // import 'ds-auth/auth.sol';
17 contract DSAuthority {
18     function canCall(
19         address src, address dst, bytes4 sig
20     ) public view returns (bool);
21 }
22 
23 contract DSAuthEvents {
24     event LogSetAuthority (address indexed authority);
25     event LogSetOwner     (address indexed owner);
26 }
27 
28 contract DSAuth is DSAuthEvents {
29     DSAuthority  public  authority;
30     address      public  owner;
31 
32     constructor() public {
33         owner = msg.sender;
34         emit LogSetOwner(msg.sender);
35     }
36 
37     function setOwner(address owner_)
38         public
39         auth
40     {
41         owner = owner_;
42         emit LogSetOwner(owner);
43     }
44 
45     function setAuthority(DSAuthority authority_)
46         public
47         auth
48     {
49         authority = authority_;
50         emit LogSetAuthority(authority);
51     }
52 
53     modifier auth {
54         require(isAuthorized(msg.sender, msg.sig));
55         _;
56     }
57 
58     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
59         if (src == address(this)) {
60             return true;
61         } else if (src == owner) {
62             return true;
63         } else if (authority == DSAuthority(0)) {
64             return false;
65         } else {
66             return authority.canCall(src, this, sig);
67         }
68     }
69 }
70 
71 // import 'ds-math/math.sol';
72 contract DSMath {
73     function add(uint x, uint y) internal pure returns (uint z) {
74         require((z = x + y) >= x);
75     }
76     function sub(uint x, uint y) internal pure returns (uint z) {
77         require((z = x - y) <= x);
78     }
79     function mul(uint x, uint y) internal pure returns (uint z) {
80         require(y == 0 || (z = x * y) / y == x);
81     }
82 
83     function min(uint x, uint y) internal pure returns (uint z) {
84         return x <= y ? x : y;
85     }
86     function max(uint x, uint y) internal pure returns (uint z) {
87         return x >= y ? x : y;
88     }
89     function imin(int x, int y) internal pure returns (int z) {
90         return x <= y ? x : y;
91     }
92     function imax(int x, int y) internal pure returns (int z) {
93         return x >= y ? x : y;
94     }
95 
96     uint constant WAD = 10 ** 18;
97     uint constant RAY = 10 ** 27;
98 
99     function wmul(uint x, uint y) internal pure returns (uint z) {
100         z = add(mul(x, y), WAD / 2) / WAD;
101     }
102     function rmul(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, y), RAY / 2) / RAY;
104     }
105     function wdiv(uint x, uint y) internal pure returns (uint z) {
106         z = add(mul(x, WAD), y / 2) / y;
107     }
108     function rdiv(uint x, uint y) internal pure returns (uint z) {
109         z = add(mul(x, RAY), y / 2) / y;
110     }
111 
112     // This famous algorithm is called "exponentiation by squaring"
113     // and calculates x^n with x as fixed-point and n as regular unsigned.
114     //
115     // It's O(log n), instead of O(n) for naive repeated multiplication.
116     //
117     // These facts are why it works:
118     //
119     //  If n is even, then x^n = (x^2)^(n/2).
120     //  If n is odd,  then x^n = x * x^(n-1),
121     //   and applying the equation for even x gives
122     //    x^n = x * (x^2)^((n-1) / 2).
123     //
124     //  Also, EVM division is flooring and
125     //    floor[(n-1) / 2] = floor[n / 2].
126     //
127     function rpow(uint x, uint n) internal pure returns (uint z) {
128         z = n % 2 != 0 ? x : RAY;
129 
130         for (n /= 2; n != 0; n /= 2) {
131             x = rmul(x, x);
132 
133             if (n % 2 != 0) {
134                 z = rmul(z, x);
135             }
136         }
137     }
138 }
139 
140 // import './IkuraStorage.sol';
141 /**
142  *
143  * ロジックの更新に影響されない永続化データを保持するクラス
144  *
145  */
146 contract IkuraStorage is DSMath, DSAuth {
147   // オーナー（中央銀行）のアドレス
148   address[] ownerAddresses;
149 
150   // 各アドレスのdJPYの口座残高
151   mapping(address => uint) coinBalances;
152 
153   // 各アドレスのSHINJI tokenの口座残高
154   mapping(address => uint) tokenBalances;
155 
156   // 各アドレスが指定したアドレスに対して許可する最大送金額
157   mapping(address => mapping (address => uint)) coinAllowances;
158 
159   // dJPYの発行高
160   uint _totalSupply = 0;
161 
162   // 手数料率
163   // 0.01pips = 1
164   // 例). 手数料を 0.05% とする場合は 500
165   uint _transferFeeRate = 500;
166 
167   // 最低手数料額
168   // 1 = 1dJPY
169   // amount * 手数料率で算出した金額がここで設定した最低手数料を下回る場合は、最低手数料額を手数料とする
170   uint8 _transferMinimumFee = 5;
171 
172   address tokenAddress;
173   address multiSigAddress;
174   address authorityAddress;
175 
176   // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
177   //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
178   // 勿論テストは通らなくなるので、テストが通ったら試してね
179   constructor() public DSAuth() {
180     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
181     owner = controllerAddress;
182     LogSetOwner(controllerAddress);*/
183   }
184 
185   function changeToken(address tokenAddress_) public auth {
186     tokenAddress = tokenAddress_;
187   }
188 
189   function changeAssociation(address multiSigAddress_) public auth {
190     multiSigAddress = multiSigAddress_;
191   }
192 
193   function changeAuthority(address authorityAddress_) public auth {
194     authorityAddress = authorityAddress_;
195   }
196 
197   // --------------------------------------------------
198   // functions for _totalSupply
199   // --------------------------------------------------
200 
201   /**
202    * 総発行額を返す
203    *
204    * @return 総発行額
205    */
206   function totalSupply() public view auth returns (uint) {
207     return _totalSupply;
208   }
209 
210   /**
211    * 総発行数を増やす（mintと並行して呼ばれることを想定）
212    *
213    * @param amount 鋳造数
214    */
215   function addTotalSupply(uint amount) public auth {
216     _totalSupply = add(_totalSupply, amount);
217   }
218 
219   /**
220    * 総発行数を減らす（burnと並行して呼ばれることを想定）
221    *
222    * @param amount 鋳造数
223    */
224   function subTotalSupply(uint amount) public auth {
225     _totalSupply = sub(_totalSupply, amount);
226   }
227 
228   // --------------------------------------------------
229   // functions for _transferFeeRate
230   // --------------------------------------------------
231 
232   /**
233    * 手数料率を返す
234    *
235    * @return 現在の手数料率
236    */
237   function transferFeeRate() public view auth returns (uint) {
238     return _transferFeeRate;
239   }
240 
241   /**
242    * 手数料率を変更する
243    *
244    * @param newTransferFeeRate 新しい手数料率
245    *
246    * @return 更新に成功したらtrue、失敗したらfalse（今のところ失敗するケースはない）
247    */
248   function setTransferFeeRate(uint newTransferFeeRate) public auth returns (bool) {
249     _transferFeeRate = newTransferFeeRate;
250 
251     return true;
252   }
253 
254   // --------------------------------------------------
255   // functions for _transferMinimumFee
256   // --------------------------------------------------
257 
258   /**
259    * 最低手数料返す
260    *
261    * @return 現在の最低手数料
262    */
263   function transferMinimumFee() public view auth returns (uint8) {
264     return _transferMinimumFee;
265   }
266 
267   /**
268    * 最低手数料を変更する
269    *
270    * @param newTransferMinimumFee 新しい最低手数料
271    *
272    * @return 更新に成功したらtrue、失敗したらfalse（今のところ失敗するケースはない）
273    */
274   function setTransferMinimumFee(uint8 newTransferMinimumFee) public auth {
275     _transferMinimumFee = newTransferMinimumFee;
276   }
277 
278   // --------------------------------------------------
279   // functions for ownerAddresses
280   // --------------------------------------------------
281 
282   /**
283    * 指定したユーザーアドレスをオーナーの一覧に追加する
284    *
285    * トークンの移動時に内部的にオーナーのアドレスを管理するための関数。
286    * トークンの所有者 = オーナーという扱いになったので、この配列に含まれるアドレスの一覧は
287    * 手数料からの収益の分配をする時に利用するだけで、オーナーかどうかの判定には利用しない
288    *
289    * @param addr ユーザーのアドレス
290    *
291    * @return 処理に成功したらtrue、失敗したらfalse
292    */
293   function addOwnerAddress(address addr) internal returns (bool) {
294     ownerAddresses.push(addr);
295 
296     return true;
297   }
298 
299   /**
300    * 指定したユーザーアドレスをオーナーの一覧から削除する
301    *
302    * トークンの移動時に内部的にオーナーのアドレスを管理するための関数。
303    *
304    * @param addr オーナーに属するユーザーのアドレス
305    *
306    * @return 処理に成功したらtrue、失敗したらfalse
307    */
308   function removeOwnerAddress(address addr) internal returns (bool) {
309     uint i = 0;
310 
311     while (ownerAddresses[i] != addr) { i++; }
312 
313     while (i < ownerAddresses.length - 1) {
314       ownerAddresses[i] = ownerAddresses[i + 1];
315       i++;
316     }
317 
318     ownerAddresses.length--;
319 
320     return true;
321   }
322 
323   /**
324    * 最初のオーナー（contractをdeployしたユーザー）のアドレスを返す
325    *
326    * @return 最初のオーナーのアドレス
327    */
328   function primaryOwner() public view auth returns (address) {
329     return ownerAddresses[0];
330   }
331 
332   /**
333    * 指定したアドレスがオーナーアドレスに登録されているか返す
334    *
335    * @param addr ユーザーのアドレス
336    *
337    * @return オーナーに含まれている場合はtrue、含まれていない場合はfalse
338    */
339   function isOwnerAddress(address addr) public view auth returns (bool) {
340     for (uint i = 0; i < ownerAddresses.length; i++) {
341       if (ownerAddresses[i] == addr) return true;
342     }
343 
344     return false;
345   }
346 
347   /**
348    * オーナー数を返す
349    *
350    * @return オーナー数
351    */
352   function numOwnerAddress() public view auth returns (uint) {
353     return ownerAddresses.length;
354   }
355 
356   // --------------------------------------------------
357   // functions for coinBalances
358   // --------------------------------------------------
359 
360   /**
361    * 指定したユーザーのdJPY残高を返す
362    *
363    * @param addr ユーザーのアドレス
364    *
365    * @return dJPY残高
366    */
367   function coinBalance(address addr) public view auth returns (uint) {
368     return coinBalances[addr];
369   }
370 
371   /**
372    * 指定したユーザーのdJPYの残高を増やす
373    *
374    * @param addr ユーザーのアドレス
375    * @param amount 差分
376    *
377    * @return 処理に成功したらtrue、失敗したらfalse
378    */
379   function addCoinBalance(address addr, uint amount) public auth returns (bool) {
380     coinBalances[addr] = add(coinBalances[addr], amount);
381 
382     return true;
383   }
384 
385   /**
386    * 指定したユーザーのdJPYの残高を減らす
387    *
388    * @param addr ユーザーのアドレス
389    * @param amount 差分
390    *
391    * @return 処理に成功したらtrue、失敗したらfalse
392    */
393   function subCoinBalance(address addr, uint amount) public auth returns (bool) {
394     coinBalances[addr] = sub(coinBalances[addr], amount);
395 
396     return true;
397   }
398 
399   // --------------------------------------------------
400   // functions for tokenBalances
401   // --------------------------------------------------
402 
403   /**
404    * 指定したユーザーのSHINJIトークンの残高を返す
405    *
406    * @param addr ユーザーのアドレス
407    *
408    * @return SHINJIトークン残高
409    */
410   function tokenBalance(address addr) public view auth returns (uint) {
411     return tokenBalances[addr];
412   }
413 
414   /**
415    * 指定したユーザーのSHINJIトークンの残高を増やす
416    *
417    * @param addr ユーザーのアドレス
418    * @param amount 差分
419    *
420    * @return 処理に成功したらtrue、失敗したらfalse
421    */
422   function addTokenBalance(address addr, uint amount) public auth returns (bool) {
423     tokenBalances[addr] = add(tokenBalances[addr], amount);
424 
425     if (tokenBalances[addr] > 0 && !isOwnerAddress(addr)) {
426       addOwnerAddress(addr);
427     }
428 
429     return true;
430   }
431 
432   /**
433    * 指定したユーザーのSHINJIトークンの残高を減らす
434    *
435    * @param addr ユーザーのアドレス
436    * @param amount 差分
437    *
438    * @return 処理に成功したらtrue、失敗したらfalse
439    */
440   function subTokenBalance(address addr, uint amount) public auth returns (bool) {
441     tokenBalances[addr] = sub(tokenBalances[addr], amount);
442 
443     if (tokenBalances[addr] <= 0) {
444       removeOwnerAddress(addr);
445     }
446 
447     return true;
448   }
449 
450   // --------------------------------------------------
451   // functions for coinAllowances
452   // --------------------------------------------------
453 
454   /**
455    * 送金許可金額を返す
456    *
457    * @param owner_ 送金者
458    * @param spender 送金代行者
459    *
460    * @return 送金許可金額
461    */
462   function coinAllowance(address owner_, address spender) public view auth returns (uint) {
463     return coinAllowances[owner_][spender];
464   }
465 
466   /**
467    * 送金許可金額を指定した金額だけ増やす
468    *
469    * @param owner_ 送金者
470    * @param spender 送金代行者
471    * @param amount 金額
472    *
473    * @return 更新に成功したらtrue、失敗したらfalse
474    */
475   function addCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
476     coinAllowances[owner_][spender] = add(coinAllowances[owner_][spender], amount);
477 
478     return true;
479   }
480 
481   /**
482    * 送金許可金額を指定した金額だけ減らす
483    *
484    * @param owner_ 送金者
485    * @param spender 送金代行者
486    * @param amount 金額
487    *
488    * @return 更新に成功したらtrue、失敗したらfalse
489    */
490   function subCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
491     coinAllowances[owner_][spender] = sub(coinAllowances[owner_][spender], amount);
492 
493     return true;
494   }
495 
496   /**
497    * 送金許可金額を指定した値に更新する
498    *
499    * @param owner_ 送金者
500    * @param spender 送金代行者
501    * @param amount 送金許可金額
502    *
503    * @return 指定に成功したらtrue、失敗したらfalse
504    */
505   function setCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
506     coinAllowances[owner_][spender] = amount;
507 
508     return true;
509   }
510 
511   /**
512    * 権限チェック用関数のoverride
513    *
514    * @param src 実行者アドレス
515    * @param sig 実行関数の識別子
516    *
517    * @return 実行が許可されていればtrue、そうでなければfalse
518    */
519   function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
520     sig; // #HACK
521 
522     return  src == address(this) ||
523             src == owner ||
524             src == tokenAddress ||
525             src == authorityAddress ||
526             src == multiSigAddress;
527   }
528 }
529 
530 // import './IkuraTokenEvent.sol';
531 /**
532  * Tokenでの処理に関するイベント定義
533  *
534  * - ERC20に準拠したイベント（Transfer / Approval）
535  * - IkuraTokenの独自イベント（TransferToken / TransferFee）
536  */
537 contract IkuraTokenEvent {
538   /** オーナーがdJPYを鋳造した際に発火するイベント */
539   event IkuraMint(address indexed owner, uint);
540 
541   /** オーナーがdJPYを消却した際に発火するイベント */
542   event IkuraBurn(address indexed owner, uint);
543 
544   /** トークンの移動時に発火するイベント */
545   event IkuraTransferToken(address indexed from, address indexed to, uint value);
546 
547   /** 手数料が発生したときに発火するイベント */
548   event IkuraTransferFee(address indexed from, address indexed to, address indexed owner, uint value);
549 
550   /**
551    * テスト時にこのイベントも流れてくるはずなので追加で定義
552    * controllerでもイベントを発火させているが、ゆくゆくはここでIkuraTokenのバージョンとか追加の情報を投げる可能性もあるので残留。
553    */
554   event IkuraTransfer(address indexed from, address indexed to, uint value);
555 
556   /** 送金許可イベント */
557   event IkuraApproval(address indexed owner, address indexed spender, uint value);
558 }
559 
560 // import './IkuraAssociation.sol';
561 /**
562  * 経過時間とSHINJI Tokenの所有比率によって特定のアクションの承認を行うクラス
563  */
564 contract IkuraAssociation is DSMath, DSAuth {
565   //
566   // public
567   //
568 
569   // 提案が承認されるために必要な賛成票の割合
570   uint public confirmTotalTokenThreshold = 50;
571 
572   //
573   // private
574   //
575 
576   // データの永続化ストレージ
577   IkuraStorage _storage;
578   IkuraToken _token;
579 
580   // 提案一覧
581   Proposal[] mintProposals;
582   Proposal[] burnProposals;
583 
584   mapping (bytes32 => Proposal[]) proposals;
585 
586   struct Proposal {
587     address proposer;                     // 提案者
588     bytes32 digest;                       // チェックサム
589     bool executed;                        // 実行の有無
590     uint createdAt;                       // 提案作成日時
591     uint expireAt;                        // 提案の締め切り
592     address[] confirmers;                 // 承認者
593     uint amount;                          // 鋳造量
594   }
595 
596   //
597   // Events
598   //
599 
600   event MintProposalAdded(uint proposalId, address proposer, uint amount);
601   event MintConfirmed(uint proposalId, address confirmer, uint amount);
602   event MintExecuted(uint proposalId, address proposer, uint amount);
603 
604   event BurnProposalAdded(uint proposalId, address proposer, uint amount);
605   event BurnConfirmed(uint proposalId, address confirmer, uint amount);
606   event BurnExecuted(uint proposalId, address proposer, uint amount);
607 
608   constructor() public {
609     proposals[keccak256('mint')] = mintProposals;
610     proposals[keccak256('burn')] = burnProposals;
611 
612     // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
613     //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
614     // 勿論テストは通らなくなるので、テストが通ったら試してね
615     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
616     owner = controllerAddress;
617     LogSetOwner(controllerAddress);*/
618   }
619 
620   /**
621    * 永続化ストレージを設定する
622    *
623    * @param newStorage 永続化ストレージのインスタンス（アドレス）
624    */
625   function changeStorage(IkuraStorage newStorage) public auth returns (bool) {
626     _storage = newStorage;
627     return true;
628   }
629 
630   function changeToken(IkuraToken token_) public auth returns (bool) {
631     _token = token_;
632     return true;
633   }
634 
635   /**
636    * 提案を作成する
637    *
638    * @param proposer 提案者のアドレス
639    * @param amount 鋳造量
640    */
641   function newProposal(bytes32 type_, address proposer, uint amount, bytes transationBytecode) public returns (uint) {
642     uint proposalId = proposals[type_].length++;
643     Proposal storage proposal = proposals[type_][proposalId];
644     proposal.proposer = proposer;
645     proposal.amount = amount;
646     proposal.digest = keccak256(proposer, amount, transationBytecode);
647     proposal.executed = false;
648     proposal.createdAt = now;
649     proposal.expireAt = proposal.createdAt + 86400;
650 
651     // 提案の種類毎に実行すべき内容を実行する
652     // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
653     if (type_ == keccak256('mint')) emit MintProposalAdded(proposalId, proposer, amount);
654     if (type_ == keccak256('burn')) emit BurnProposalAdded(proposalId, proposer, amount);
655 
656     // 本人は当然承認
657     confirmProposal(type_, proposer, proposalId);
658 
659     return proposalId;
660   }
661 
662   /**
663    * トークン所有者が提案に対して賛成する
664    *
665    * @param type_ 提案の種類
666    * @param confirmer 承認者のアドレス
667    * @param proposalId 提案ID
668    */
669   function confirmProposal(bytes32 type_, address confirmer, uint proposalId) public {
670     Proposal storage proposal = proposals[type_][proposalId];
671 
672     // 既に承認済みの場合はエラーを返す
673     require(!hasConfirmed(type_, confirmer, proposalId));
674 
675     // 承認行為を行ったフラグを立てる
676     proposal.confirmers.push(confirmer);
677 
678     // 提案の種類毎に実行すべき内容を実行する
679     // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
680     if (type_ == keccak256('mint')) emit MintConfirmed(proposalId, confirmer, proposal.amount);
681     if (type_ == keccak256('burn')) emit BurnConfirmed(proposalId, confirmer, proposal.amount);
682 
683     if (isProposalExecutable(type_, proposalId, proposal.proposer, '')) {
684       proposal.executed = true;
685 
686       // 提案の種類毎に実行すべき内容を実行する
687       // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
688       if (type_ == keccak256('mint')) executeMintProposal(proposalId);
689       if (type_ == keccak256('burn')) executeBurnProposal(proposalId);
690     }
691   }
692 
693   /**
694    * 既に承認済みの提案かどうかを返す
695    *
696    * @param type_ 提案の種類
697    * @param addr 承認者のアドレス
698    * @param proposalId 提案ID
699    *
700    * @return 承認済みであればtrue、そうでなければfalse
701    */
702   function hasConfirmed(bytes32 type_, address addr, uint proposalId) internal view returns (bool) {
703     Proposal storage proposal = proposals[type_][proposalId];
704     uint length = proposal.confirmers.length;
705 
706     for (uint i = 0; i < length; i++) {
707       if (proposal.confirmers[i] == addr) return true;
708     }
709 
710     return false;
711   }
712 
713   /**
714    * 指定した提案を承認したトークンの総量を返す
715    *
716    * @param type_ 提案の種類
717    * @param proposalId 提案ID
718    *
719    * @return 承認に投票されたトークン数
720    */
721   function confirmedTotalToken(bytes32 type_, uint proposalId) internal view returns (uint) {
722     Proposal storage proposal = proposals[type_][proposalId];
723     uint length = proposal.confirmers.length;
724     uint total = 0;
725 
726     for (uint i = 0; i < length; i++) {
727       total = add(total, _storage.tokenBalance(proposal.confirmers[i]));
728     }
729 
730     return total;
731   }
732 
733   /**
734    * 指定した提案の締め切りを返す
735    *
736    * @param type_ 提案の種類
737    * @param proposalId 提案ID
738    *
739    * @return 提案の締め切り
740    */
741   function proposalExpireAt(bytes32 type_, uint proposalId) public view returns (uint) {
742     Proposal storage proposal = proposals[type_][proposalId];
743     return proposal.expireAt;
744   }
745 
746   /**
747    * 提案が実行条件を満たしているかを返す
748    *
749    * 【承認条件】
750    * - まだ実行していない
751    * - 提案の有効期限内である
752    * - 指定した割合以上の賛成トークンを得ている
753    *
754    * @param proposalId 提案ID
755    *
756    * @return 実行条件を満たしている場合はtrue、そうでない場合はfalse
757    */
758   function isProposalExecutable(bytes32 type_, uint proposalId, address proposer, bytes transactionBytecode) internal view returns (bool) {
759     Proposal storage proposal = proposals[type_][proposalId];
760 
761     // オーナーがcontrollerを登録したユーザーしか存在しない場合は
762     if (_storage.numOwnerAddress() < 2) {
763       return true;
764     }
765 
766     return  proposal.digest == keccak256(proposer, proposal.amount, transactionBytecode) &&
767             isProposalNotExpired(type_, proposalId) &&
768             mul(100, confirmedTotalToken(type_, proposalId)) / _storage.totalSupply() > confirmTotalTokenThreshold;
769   }
770 
771   /**
772    * 指定した種類の提案数を取得する
773    *
774    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
775    *
776    * @return 提案数（承認されていないものも含む）
777    */
778   function numberOfProposals(bytes32 type_) public constant returns (uint) {
779     return proposals[type_].length;
780   }
781 
782   /**
783    * 未承認で有効期限の切れていない提案の数を返す
784    *
785    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
786    *
787    * @return 提案数
788    */
789   function numberOfActiveProposals(bytes32 type_) public view returns (uint) {
790     uint numActiveProposal = 0;
791 
792     for(uint i = 0; i < proposals[type_].length; i++) {
793       if (isProposalNotExpired(type_, i)) {
794         numActiveProposal++;
795       }
796     }
797 
798     return numActiveProposal;
799   }
800 
801   /**
802    * 提案の有効期限が切れていないかチェックする
803    *
804    * - 実行されていない
805    * - 有効期限が切れていない
806    *
807    * 場合のみtrueを返す
808    */
809   function isProposalNotExpired(bytes32 type_, uint proposalId) internal view returns (bool) {
810     Proposal storage proposal = proposals[type_][proposalId];
811 
812     return  !proposal.executed &&
813             now < proposal.expireAt;
814   }
815 
816   /**
817    * dJPYを鋳造する
818    *
819    * - 鋳造する量が0より大きい
820    *
821    * 場合は成功する
822    *
823    * @param proposalId 提案ID
824    */
825   function executeMintProposal(uint proposalId) internal returns (bool) {
826     Proposal storage proposal = proposals[keccak256('mint')][proposalId];
827 
828     // ここでも念のためチェックを入れる
829     require(proposal.amount > 0);
830 
831     emit MintExecuted(proposalId, proposal.proposer, proposal.amount);
832 
833     // 総供給量 / 実行者のdJPY / 実行者のSHINJI tokenを増やす
834     _storage.addTotalSupply(proposal.amount);
835     _storage.addCoinBalance(proposal.proposer, proposal.amount);
836     _storage.addTokenBalance(proposal.proposer, proposal.amount);
837 
838     return true;
839   }
840 
841   /**
842    * dJPYを消却する
843    *
844    * - 消却する量が0より大きい
845    * - 提案者の所有するdJPYの残高がamount以上
846    * - 提案者の所有するSHINJIがamountよりも大きい
847    *
848    * 場合は成功する
849    *
850    * @param proposalId 提案ID
851    */
852   function executeBurnProposal(uint proposalId) internal returns (bool) {
853     Proposal storage proposal = proposals[keccak256('burn')][proposalId];
854 
855     // ここでも念のためチェックを入れる
856     require(proposal.amount > 0);
857     require(_storage.coinBalance(proposal.proposer) >= proposal.amount);
858     require(_storage.tokenBalance(proposal.proposer) >= proposal.amount);
859 
860     emit BurnExecuted(proposalId, proposal.proposer, proposal.amount);
861 
862     // 総供給量 / 実行者のdJPY / 実行者のSHINJI tokenを減らす
863     _storage.subTotalSupply(proposal.amount);
864     _storage.subCoinBalance(proposal.proposer, proposal.amount);
865     _storage.subTokenBalance(proposal.proposer, proposal.amount);
866 
867     return true;
868   }
869 
870   function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
871     sig; // #HACK
872 
873     return  src == address(this) ||
874             src == owner ||
875             src == address(_token);
876   }
877 }
878 
879 // import './lib/ProposalLibrary.sol';
880 /**
881  *
882  * 承認プロセスの実装ライブラリ
883  * IkuraTokenに実装するとサイズ超過してしまうため、ライブラリとして切り出している
884  *
885  * 今のところギリギリおさまっているので使ってはいない
886  */
887 library ProposalLibrary {
888   //
889   // structs
890   //
891 
892   // tokenのstorage/associationを参照するための構造体
893   struct Entity {
894     IkuraStorage _storage;
895     IkuraAssociation _association;
896   }
897 
898   /**
899    * 永続化ストレージを設定する
900    *
901    * @param self 実行Entity
902    * @param storage_ 永続化ストレージのインスタンス（アドレス）
903    */
904   function changeStorage(Entity storage self, address storage_) internal {
905     self._storage = IkuraStorage(storage_);
906   }
907 
908   /**
909    * 関連づける承認プロセスを変更する
910    *
911    * @param self 実行Entity
912    * @param association_ 新しい承認プロセス
913    */
914   function changeAssociation(Entity storage self, address association_) internal {
915     self._association = IkuraAssociation(association_);
916   }
917 
918   /**
919    * dJPYを鋳造する
920    *
921    * - コマンドを実行したユーザがオーナーである
922    * - 鋳造する量が0より大きい
923    *
924    * 場合は成功する
925    *
926    * @param self 実行Entity
927    * @param sender 実行アドレス
928    * @param amount 鋳造する金額
929    */
930   function mint(Entity storage self, address sender, uint amount) public returns (bool) {
931     require(amount > 0);
932 
933     self._association.newProposal(keccak256('mint'), sender, amount, '');
934 
935     return true;
936   }
937 
938   /**
939    * dJPYを消却する
940    *
941    * - コマンドを実行したユーザがオーナーである
942    * - 鋳造する量が0より大きい
943    * - dJPYの残高がamountよりも大きい
944    * - SHINJIをamountよりも大きい
945    *
946    * 場合は成功する
947    *
948    * @param self 実行Entity
949    * @param sender 実行アドレス
950    * @param amount 消却する金額
951    */
952   function burn(Entity storage self, address sender, uint amount) public returns (bool) {
953     require(amount > 0);
954     require(self._storage.coinBalance(sender) >= amount);
955     require(self._storage.tokenBalance(sender) >= amount);
956 
957     self._association.newProposal(keccak256('burn'), sender, amount, '');
958 
959     return true;
960   }
961 
962   /**
963    * 提案を承認する。
964    * #TODO proposalIdは分からないので、別のものからproposalを特定しないといかんよ
965    *
966    * @param self 実行Entity
967    * @param sender 実行アドレス
968    * @param type_ 承認する提案の種類
969    * @param proposalId 提案ID
970    */
971   function confirmProposal(Entity storage self, address sender, bytes32 type_, uint proposalId) public {
972     self._association.confirmProposal(type_, sender, proposalId);
973   }
974 
975   /**
976    * 指定した種類の提案数を取得する
977    *
978    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
979    *
980    * @return 提案数（承認されていないものも含む）
981    */
982   function numberOfProposals(Entity storage self, bytes32 type_) public view returns (uint) {
983     return self._association.numberOfProposals(type_);
984   }
985 }
986 
987 
988 /**
989  *
990  * トークンロジック
991  *
992  */
993 contract IkuraToken is IkuraTokenEvent, DSMath, DSAuth {
994   //
995   // constants
996   //
997 
998   // 手数料率
999   // 0.01pips = 1
1000   // 例). 手数料を 0.05% とする場合は 500
1001   uint _transferFeeRate = 0;
1002 
1003   // 最低手数料額
1004   // 1 = 1dJPY
1005   // amount * 手数料率で算出した金額がここで設定した最低手数料を下回る場合は、最低手数料額を手数料とする
1006   uint8 _transferMinimumFee = 0;
1007 
1008   // ロジックバージョン
1009   uint _logicVersion = 2;
1010 
1011   //
1012   // libraries
1013   //
1014 
1015   /*using ProposalLibrary for ProposalLibrary.Entity;
1016   ProposalLibrary.Entity proposalEntity;*/
1017 
1018   //
1019   // private
1020   //
1021 
1022   // データの永続化ストレージ
1023   IkuraStorage _storage;
1024   IkuraAssociation _association;
1025 
1026   constructor() DSAuth() public {
1027     // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
1028     //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
1029     // 勿論テストは通らなくなるので、テストが通ったら試してね
1030     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
1031     owner = controllerAddress;
1032     LogSetOwner(controllerAddress);*/
1033   }
1034 
1035   // ----------------------------------------------------------------------------------------------------
1036   // 以降はERC20に準拠した関数
1037   // ----------------------------------------------------------------------------------------------------
1038 
1039   /**
1040    * ERC20 Token Standardに準拠した関数
1041    *
1042    * dJPYの発行高を返す
1043    *
1044    * @return 発行高
1045    */
1046   function totalSupply(address sender) public view returns (uint) {
1047     sender; // #HACK
1048 
1049     return _storage.totalSupply();
1050   }
1051 
1052   /**
1053    * ERC20 Token Standardに準拠した関数
1054    *
1055    * 特定のアドレスのdJPY残高を返す
1056    *
1057    * @param sender 実行アドレス
1058    * @param addr アドレス
1059    *
1060    * @return 指定したアドレスのdJPY残高
1061    */
1062   function balanceOf(address sender, address addr) public view returns (uint) {
1063     sender; // #HACK
1064 
1065     return _storage.coinBalance(addr);
1066   }
1067 
1068   /**
1069    * ERC20 Token Standardに準拠した関数
1070    *
1071    * 指定したアドレスに対してdJPYを送金する
1072    * 以下の条件を満たす必要がある
1073    *
1074    * - メッセージの送信者の残高 >= 送金額
1075    * - 送金額 > 0
1076    * - 送金先のアドレスの残高 + 送金額 > 送金元のアドレスの残高（overflowのチェックらしい）
1077    *
1078    * @param sender 送金元アドレス
1079    * @param to 送金対象アドレス
1080    * @param amount 送金額
1081    *
1082    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
1083    */
1084   function transfer(address sender, address to, uint amount) public auth returns (bool success) {
1085     uint fee = transferFee(sender, sender, to, amount);
1086     uint totalAmount = add(amount, fee);
1087 
1088     require(_storage.coinBalance(sender) >= totalAmount);
1089     require(amount > 0);
1090 
1091     // 実行者の口座からamount + feeの金額が控除される
1092     _storage.subCoinBalance(sender, totalAmount);
1093 
1094     // toの口座にamountが振り込まれる
1095     _storage.addCoinBalance(to, amount);
1096 
1097     if (fee > 0) {
1098       // 手数料を受け取るオーナーのアドレスを選定
1099       address owner = selectOwnerAddressForTransactionFee(sender);
1100 
1101       // オーナーの口座にfeeが振り込まれる
1102       _storage.addCoinBalance(owner, fee);
1103     }
1104 
1105     return true;
1106   }
1107 
1108   /**
1109    * ERC20 Token Standardに準拠した関数
1110    *
1111    * from（送信元のアドレス）からto（送信先のアドレス）へamount分だけ送金する。
1112    * 主に口座からの引き出しに利用され、契約によってサブ通貨の送金手数料を徴収することができるようになる。
1113    * この操作はfrom（送信元のアドレス）が何らかの方法で意図的に送信者を許可する場合を除いて失敗すべき。
1114    * この許可する処理はapproveコマンドで実装しましょう。
1115    *
1116    * 以下の条件を満たす場合だけ送金を認める
1117    *
1118    * - 送信元の残高 >= 金額
1119    * - 送金する金額 > 0
1120    * - 送信者に対して送信元が許可している金額 >= 送金する金額
1121    * - 送信先の残高 + 金額 > 送信元の残高（overflowのチェックらしい）
1122    # - 送金処理を行うユーザーの口座残高 >= 送金処理の手数料
1123    *
1124    * @param sender 実行アドレス
1125    * @param from 送金元アドレス
1126    * @param to 送金先アドレス
1127    * @param amount 送金額
1128    *
1129    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
1130    */
1131   function transferFrom(address sender, address from, address to, uint amount) public auth returns (bool success) {
1132     uint fee = transferFee(sender, from, to, amount);
1133 
1134     require(_storage.coinBalance(from) >= amount);
1135     require(_storage.coinAllowance(from, sender) >= amount);
1136     require(amount > 0);
1137     require(add(_storage.coinBalance(to), amount) > _storage.coinBalance(to));
1138 
1139     if (fee > 0) {
1140       require(_storage.coinBalance(sender) >= fee);
1141 
1142       // 手数料を受け取るオーナーのアドレスを選定
1143       address owner = selectOwnerAddressForTransactionFee(sender);
1144 
1145       // 手数料はこの関数を実行したユーザー（主に取引所とか）から徴収する
1146       _storage.subCoinBalance(sender, fee);
1147 
1148       _storage.addCoinBalance(owner, fee);
1149     }
1150 
1151     // 送金元から送金額を引く
1152     _storage.subCoinBalance(from, amount);
1153 
1154     // 送金許可している金額を減らす
1155     _storage.subCoinAllowance(from, sender, amount);
1156 
1157     // 送金口座に送金額を足す
1158     _storage.addCoinBalance(to, amount);
1159 
1160     return true;
1161   }
1162 
1163   /**
1164    * ERC20 Token Standardに準拠した関数
1165    *
1166    * spender（支払い元のアドレス）にsender（送信者）がamount分だけ支払うのを許可する
1167    * この関数が呼ばれる度に送金可能な金額を更新する。
1168    *
1169    * @param sender 実行アドレス
1170    * @param spender 送金元アドレス
1171    * @param amount 送金額
1172    *
1173    * @return 基本的にtrueを返す
1174    */
1175   function approve(address sender, address spender, uint amount) public auth returns (bool success) {
1176     _storage.setCoinAllowance(sender, spender, amount);
1177 
1178     return true;
1179   }
1180 
1181   /**
1182    * ERC20 Token Standardに準拠した関数
1183    *
1184    * 受取側に対して支払い側がどれだけ送金可能かを返す
1185    *
1186    * @param sender 実行アドレス
1187    * @param owner 受け取り側のアドレス
1188    * @param spender 支払い元のアドレス
1189    *
1190    * @return 許可されている送金料
1191    */
1192   function allowance(address sender, address owner, address spender) public view returns (uint remaining) {
1193     sender; // #HACK
1194 
1195     return _storage.coinAllowance(owner, spender);
1196   }
1197 
1198   // ----------------------------------------------------------------------------------------------------
1199   // 以降はERC20以外の独自実装
1200   // ----------------------------------------------------------------------------------------------------
1201 
1202   /**
1203    * 特定のアドレスのSHINJI残高を返す
1204    *
1205    * @param sender 実行アドレス
1206    * @param owner アドレス
1207    *
1208    * @return 指定したアドレスのSHINJIトークン量
1209    */
1210   function tokenBalanceOf(address sender, address owner) public view returns (uint balance) {
1211     sender; // #HACK
1212 
1213     return _storage.tokenBalance(owner);
1214   }
1215 
1216   /**
1217    * 指定したアドレスに対してSHINJIトークンを送金する
1218    *
1219    * - 送信元の残トークン量 >= トークン量
1220    * - 送信するトークン量 > 0
1221    * - 送信先の残高 + 金額 > 送信元の残高（overflowのチェック）
1222    *
1223    * @param sender 実行アドレス
1224    * @param to 送金対象アドレス
1225    * @param amount 送金額
1226    *
1227    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
1228    */
1229   function transferToken(address sender, address to, uint amount) public auth returns (bool success) {
1230     require(_storage.tokenBalance(sender) >= amount);
1231     require(amount > 0);
1232     require(add(_storage.tokenBalance(to), amount) > _storage.tokenBalance(to));
1233 
1234     _storage.subTokenBalance(sender, amount);
1235     _storage.addTokenBalance(to, amount);
1236 
1237     emit IkuraTransferToken(sender, to, amount);
1238 
1239     return true;
1240   }
1241 
1242   /**
1243    * 送金元、送金先、送金金額によって対象のトランザクションの手数料を決定する
1244    * 送金金額に対して手数料率をかけたものを計算し、最低手数料金額とのmax値を取る。
1245    *
1246    * @param sender 実行アドレス
1247    * @param from 送金元
1248    * @param to 送金先
1249    * @param amount 送金金額
1250    *
1251    * @return 手数料金額
1252    */
1253   function transferFee(address sender, address from, address to, uint amount) public view returns (uint) {
1254     sender; from; to; // #avoid warning
1255     if (_transferFeeRate > 0) {
1256       uint denominator = 1000000; // 0.01 pips だから 100 * 100 * 100 で 100万
1257       uint numerator = mul(amount, _transferFeeRate);
1258 
1259       uint fee = numerator / denominator;
1260       uint remainder = sub(numerator, mul(denominator, fee));
1261 
1262       // 余りがある場合はfeeに1を足す
1263       if (remainder > 0) {
1264         fee++;
1265       }
1266 
1267       if (fee < _transferMinimumFee) {
1268         fee = _transferMinimumFee;
1269       }
1270 
1271       return fee;
1272     } else {
1273       return 0;
1274     }
1275   }
1276 
1277   /**
1278    * 手数料率を返す
1279    *
1280    * @param sender 実行アドレス
1281    *
1282    * @return 手数料率
1283    */
1284   function transferFeeRate(address sender) public view returns (uint) {
1285     sender; // #HACK
1286 
1287     return _transferFeeRate;
1288   }
1289 
1290   /**
1291    * 最低手数料額を返す
1292    *
1293    * @param sender 実行アドレス
1294    *
1295    * @return 最低手数料額
1296    */
1297   function transferMinimumFee(address sender) public view returns (uint8) {
1298     sender; // #HACK
1299 
1300     return _transferMinimumFee;
1301   }
1302 
1303   /**
1304    * 手数料を振り込む口座を選択する
1305    * #TODO とりあえず一個目のオーナーに固定。後で選定ロジックを変える
1306    *
1307    * @param sender 実行アドレス
1308    * @return 特定のオーナー口座
1309    */
1310   function selectOwnerAddressForTransactionFee(address sender) public view returns (address) {
1311     sender; // #HACK
1312 
1313     return _storage.primaryOwner();
1314   }
1315 
1316   /**
1317    * dJPYを鋳造する
1318    *
1319    * - コマンドを実行したユーザがオーナーである
1320    * - 鋳造する量が0より大きい
1321    *
1322    * 場合は成功する
1323    *
1324    * @param sender 実行アドレス
1325    * @param amount 鋳造する金額
1326    */
1327   function mint(address sender, uint amount) public auth returns (bool) {
1328     require(amount > 0);
1329 
1330     _association.newProposal(keccak256('mint'), sender, amount, '');
1331 
1332     return true;
1333     /*return proposalEntity.mint(sender, amount);*/
1334   }
1335 
1336   /**
1337    * dJPYを消却する
1338    *
1339    * - コマンドを実行したユーザがオーナーである
1340    * - 鋳造する量が0より大きい
1341    * - dJPYの残高がamountよりも大きい
1342    * - SHINJIをamountよりも大きい
1343    *
1344    * 場合は成功する
1345    *
1346    * @param sender 実行アドレス
1347    * @param amount 消却する金額
1348    */
1349   function burn(address sender, uint amount) public auth returns (bool) {
1350     require(amount > 0);
1351     require(_storage.coinBalance(sender) >= amount);
1352     require(_storage.tokenBalance(sender) >= amount);
1353 
1354     _association.newProposal(keccak256('burn'), sender, amount, '');
1355 
1356     return true;
1357     /*return proposalEntity.burn(sender, amount);*/
1358   }
1359 
1360   /**
1361    * 提案を承認する。
1362    * #TODO proposalIdは分からないので、別のものからproposalを特定しないといかんよ
1363    */
1364   function confirmProposal(address sender, bytes32 type_, uint proposalId) public auth {
1365     _association.confirmProposal(type_, sender, proposalId);
1366     /*proposalEntity.confirmProposal(sender, type_, proposalId);*/
1367   }
1368 
1369   /**
1370    * 指定した種類の提案数を取得する
1371    *
1372    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
1373    *
1374    * @return 提案数（承認されていないものも含む）
1375    */
1376   function numberOfProposals(bytes32 type_) public view returns (uint) {
1377     return _association.numberOfProposals(type_);
1378     /*return proposalEntity.numberOfProposals(type_);*/
1379   }
1380 
1381   /**
1382    * 関連づける承認プロセスを変更する
1383    *
1384    * @param association_ 新しい承認プロセス
1385    */
1386   function changeAssociation(address association_) public auth returns (bool) {
1387     _association = IkuraAssociation(association_);
1388     return true;
1389   }
1390 
1391   /**
1392    * 永続化ストレージを設定する
1393    *
1394    * @param storage_ 永続化ストレージのインスタンス（アドレス）
1395    */
1396   function changeStorage(address storage_) public auth returns (bool) {
1397     _storage = IkuraStorage(storage_);
1398     return true;
1399   }
1400 
1401   /**
1402    * ロジックのバージョンを返す
1403    *
1404    * @param sender 実行ユーザーのアドレス
1405    *
1406    * @return バージョン情報
1407    */
1408   function logicVersion(address sender) public view returns (uint) {
1409     sender; // #HACK
1410 
1411     return _logicVersion;
1412   }
1413 }