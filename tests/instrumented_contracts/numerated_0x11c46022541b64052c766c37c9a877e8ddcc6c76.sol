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
530 
531 // import './IkuraTokenEvent.sol';
532 /**
533  * Tokenでの処理に関するイベント定義
534  *
535  * - ERC20に準拠したイベント（Transfer / Approval）
536  * - IkuraTokenの独自イベント（TransferToken / TransferFee）
537  */
538 contract IkuraTokenEvent {
539   /** オーナーがdJPYを鋳造した際に発火するイベント */
540   event IkuraMint(address indexed owner, uint);
541 
542   /** オーナーがdJPYを消却した際に発火するイベント */
543   event IkuraBurn(address indexed owner, uint);
544 
545   /** トークンの移動時に発火するイベント */
546   event IkuraTransferToken(address indexed from, address indexed to, uint value);
547 
548   /** 手数料が発生したときに発火するイベント */
549   event IkuraTransferFee(address indexed from, address indexed to, address indexed owner, uint value);
550 
551   /**
552    * テスト時にこのイベントも流れてくるはずなので追加で定義
553    * controllerでもイベントを発火させているが、ゆくゆくはここでIkuraTokenのバージョンとか追加の情報を投げる可能性もあるので残留。
554    */
555   event IkuraTransfer(address indexed from, address indexed to, uint value);
556 
557   /** 送金許可イベント */
558   event IkuraApproval(address indexed owner, address indexed spender, uint value);
559 }
560 
561 
562 // import './IkuraToken.sol';
563 /**
564  *
565  * トークンロジック
566  *
567  */
568 contract IkuraToken is IkuraTokenEvent, DSMath, DSAuth {
569   //
570   // constants
571   //
572 
573   // 手数料率
574   // 0.01pips = 1
575   // 例). 手数料を 0.05% とする場合は 500
576   uint _transferFeeRate = 0;
577 
578   // 最低手数料額
579   // 1 = 1dJPY
580   // amount * 手数料率で算出した金額がここで設定した最低手数料を下回る場合は、最低手数料額を手数料とする
581   uint8 _transferMinimumFee = 0;
582 
583   // ロジックバージョン
584   uint _logicVersion = 2;
585 
586   //
587   // libraries
588   //
589 
590   /*using ProposalLibrary for ProposalLibrary.Entity;
591   ProposalLibrary.Entity proposalEntity;*/
592 
593   //
594   // private
595   //
596 
597   // データの永続化ストレージ
598   IkuraStorage _storage;
599   IkuraAssociation _association;
600 
601   constructor() DSAuth() public {
602     // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
603     //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
604     // 勿論テストは通らなくなるので、テストが通ったら試してね
605     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
606     owner = controllerAddress;
607     LogSetOwner(controllerAddress);*/
608   }
609 
610   // ----------------------------------------------------------------------------------------------------
611   // 以降はERC20に準拠した関数
612   // ----------------------------------------------------------------------------------------------------
613 
614   /**
615    * ERC20 Token Standardに準拠した関数
616    *
617    * dJPYの発行高を返す
618    *
619    * @return 発行高
620    */
621   function totalSupply(address sender) public view returns (uint) {
622     sender; // #HACK
623 
624     return _storage.totalSupply();
625   }
626 
627   /**
628    * ERC20 Token Standardに準拠した関数
629    *
630    * 特定のアドレスのdJPY残高を返す
631    *
632    * @param sender 実行アドレス
633    * @param addr アドレス
634    *
635    * @return 指定したアドレスのdJPY残高
636    */
637   function balanceOf(address sender, address addr) public view returns (uint) {
638     sender; // #HACK
639 
640     return _storage.coinBalance(addr);
641   }
642 
643   /**
644    * ERC20 Token Standardに準拠した関数
645    *
646    * 指定したアドレスに対してdJPYを送金する
647    * 以下の条件を満たす必要がある
648    *
649    * - メッセージの送信者の残高 >= 送金額
650    * - 送金額 > 0
651    * - 送金先のアドレスの残高 + 送金額 > 送金元のアドレスの残高（overflowのチェックらしい）
652    *
653    * @param sender 送金元アドレス
654    * @param to 送金対象アドレス
655    * @param amount 送金額
656    *
657    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
658    */
659   function transfer(address sender, address to, uint amount) public auth returns (bool success) {
660     uint fee = transferFee(sender, sender, to, amount);
661     uint totalAmount = add(amount, fee);
662 
663     require(_storage.coinBalance(sender) >= totalAmount);
664     require(amount > 0);
665 
666     // 実行者の口座からamount + feeの金額が控除される
667     _storage.subCoinBalance(sender, totalAmount);
668 
669     // toの口座にamountが振り込まれる
670     _storage.addCoinBalance(to, amount);
671 
672     if (fee > 0) {
673       // 手数料を受け取るオーナーのアドレスを選定
674       address owner = selectOwnerAddressForTransactionFee(sender);
675 
676       // オーナーの口座にfeeが振り込まれる
677       _storage.addCoinBalance(owner, fee);
678     }
679 
680     return true;
681   }
682 
683   /**
684    * ERC20 Token Standardに準拠した関数
685    *
686    * from（送信元のアドレス）からto（送信先のアドレス）へamount分だけ送金する。
687    * 主に口座からの引き出しに利用され、契約によってサブ通貨の送金手数料を徴収することができるようになる。
688    * この操作はfrom（送信元のアドレス）が何らかの方法で意図的に送信者を許可する場合を除いて失敗すべき。
689    * この許可する処理はapproveコマンドで実装しましょう。
690    *
691    * 以下の条件を満たす場合だけ送金を認める
692    *
693    * - 送信元の残高 >= 金額
694    * - 送金する金額 > 0
695    * - 送信者に対して送信元が許可している金額 >= 送金する金額
696    * - 送信先の残高 + 金額 > 送信元の残高（overflowのチェックらしい）
697    # - 送金処理を行うユーザーの口座残高 >= 送金処理の手数料
698    *
699    * @param sender 実行アドレス
700    * @param from 送金元アドレス
701    * @param to 送金先アドレス
702    * @param amount 送金額
703    *
704    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
705    */
706   function transferFrom(address sender, address from, address to, uint amount) public auth returns (bool success) {
707     uint fee = transferFee(sender, from, to, amount);
708 
709     require(_storage.coinBalance(from) >= amount);
710     require(_storage.coinAllowance(from, sender) >= amount);
711     require(amount > 0);
712     require(add(_storage.coinBalance(to), amount) > _storage.coinBalance(to));
713 
714     if (fee > 0) {
715       require(_storage.coinBalance(sender) >= fee);
716 
717       // 手数料を受け取るオーナーのアドレスを選定
718       address owner = selectOwnerAddressForTransactionFee(sender);
719 
720       // 手数料はこの関数を実行したユーザー（主に取引所とか）から徴収する
721       _storage.subCoinBalance(sender, fee);
722 
723       _storage.addCoinBalance(owner, fee);
724     }
725 
726     // 送金元から送金額を引く
727     _storage.subCoinBalance(from, amount);
728 
729     // 送金許可している金額を減らす
730     _storage.subCoinAllowance(from, sender, amount);
731 
732     // 送金口座に送金額を足す
733     _storage.addCoinBalance(to, amount);
734 
735     return true;
736   }
737 
738   /**
739    * ERC20 Token Standardに準拠した関数
740    *
741    * spender（支払い元のアドレス）にsender（送信者）がamount分だけ支払うのを許可する
742    * この関数が呼ばれる度に送金可能な金額を更新する。
743    *
744    * @param sender 実行アドレス
745    * @param spender 送金元アドレス
746    * @param amount 送金額
747    *
748    * @return 基本的にtrueを返す
749    */
750   function approve(address sender, address spender, uint amount) public auth returns (bool success) {
751     _storage.setCoinAllowance(sender, spender, amount);
752 
753     return true;
754   }
755 
756   /**
757    * ERC20 Token Standardに準拠した関数
758    *
759    * 受取側に対して支払い側がどれだけ送金可能かを返す
760    *
761    * @param sender 実行アドレス
762    * @param owner 受け取り側のアドレス
763    * @param spender 支払い元のアドレス
764    *
765    * @return 許可されている送金料
766    */
767   function allowance(address sender, address owner, address spender) public view returns (uint remaining) {
768     sender; // #HACK
769 
770     return _storage.coinAllowance(owner, spender);
771   }
772 
773   // ----------------------------------------------------------------------------------------------------
774   // 以降はERC20以外の独自実装
775   // ----------------------------------------------------------------------------------------------------
776 
777   /**
778    * 特定のアドレスのSHINJI残高を返す
779    *
780    * @param sender 実行アドレス
781    * @param owner アドレス
782    *
783    * @return 指定したアドレスのSHINJIトークン量
784    */
785   function tokenBalanceOf(address sender, address owner) public view returns (uint balance) {
786     sender; // #HACK
787 
788     return _storage.tokenBalance(owner);
789   }
790 
791   /**
792    * 指定したアドレスに対してSHINJIトークンを送金する
793    *
794    * - 送信元の残トークン量 >= トークン量
795    * - 送信するトークン量 > 0
796    * - 送信先の残高 + 金額 > 送信元の残高（overflowのチェック）
797    *
798    * @param sender 実行アドレス
799    * @param to 送金対象アドレス
800    * @param amount 送金額
801    *
802    * @return 条件を満たして処理に成功した場合はtrue、失敗した場合はfalse
803    */
804   function transferToken(address sender, address to, uint amount) public auth returns (bool success) {
805     require(_storage.tokenBalance(sender) >= amount);
806     require(amount > 0);
807     require(add(_storage.tokenBalance(to), amount) > _storage.tokenBalance(to));
808 
809     _storage.subTokenBalance(sender, amount);
810     _storage.addTokenBalance(to, amount);
811 
812     emit IkuraTransferToken(sender, to, amount);
813 
814     return true;
815   }
816 
817   /**
818    * 送金元、送金先、送金金額によって対象のトランザクションの手数料を決定する
819    * 送金金額に対して手数料率をかけたものを計算し、最低手数料金額とのmax値を取る。
820    *
821    * @param sender 実行アドレス
822    * @param from 送金元
823    * @param to 送金先
824    * @param amount 送金金額
825    *
826    * @return 手数料金額
827    */
828   function transferFee(address sender, address from, address to, uint amount) public view returns (uint) {
829     sender; from; to; // #avoid warning
830     if (_transferFeeRate > 0) {
831       uint denominator = 1000000; // 0.01 pips だから 100 * 100 * 100 で 100万
832       uint numerator = mul(amount, _transferFeeRate);
833 
834       uint fee = numerator / denominator;
835       uint remainder = sub(numerator, mul(denominator, fee));
836 
837       // 余りがある場合はfeeに1を足す
838       if (remainder > 0) {
839         fee++;
840       }
841 
842       if (fee < _transferMinimumFee) {
843         fee = _transferMinimumFee;
844       }
845 
846       return fee;
847     } else {
848       return 0;
849     }
850   }
851 
852   /**
853    * 手数料率を返す
854    *
855    * @param sender 実行アドレス
856    *
857    * @return 手数料率
858    */
859   function transferFeeRate(address sender) public view returns (uint) {
860     sender; // #HACK
861 
862     return _transferFeeRate;
863   }
864 
865   /**
866    * 最低手数料額を返す
867    *
868    * @param sender 実行アドレス
869    *
870    * @return 最低手数料額
871    */
872   function transferMinimumFee(address sender) public view returns (uint8) {
873     sender; // #HACK
874 
875     return _transferMinimumFee;
876   }
877 
878   /**
879    * 手数料を振り込む口座を選択する
880    * #TODO とりあえず一個目のオーナーに固定。後で選定ロジックを変える
881    *
882    * @param sender 実行アドレス
883    * @return 特定のオーナー口座
884    */
885   function selectOwnerAddressForTransactionFee(address sender) public view returns (address) {
886     sender; // #HACK
887 
888     return _storage.primaryOwner();
889   }
890 
891   /**
892    * dJPYを鋳造する
893    *
894    * - コマンドを実行したユーザがオーナーである
895    * - 鋳造する量が0より大きい
896    *
897    * 場合は成功する
898    *
899    * @param sender 実行アドレス
900    * @param amount 鋳造する金額
901    */
902   function mint(address sender, uint amount) public auth returns (bool) {
903     require(amount > 0);
904 
905     _association.newProposal(keccak256('mint'), sender, amount, '');
906 
907     return true;
908     /*return proposalEntity.mint(sender, amount);*/
909   }
910 
911   /**
912    * dJPYを消却する
913    *
914    * - コマンドを実行したユーザがオーナーである
915    * - 鋳造する量が0より大きい
916    * - dJPYの残高がamountよりも大きい
917    * - SHINJIをamountよりも大きい
918    *
919    * 場合は成功する
920    *
921    * @param sender 実行アドレス
922    * @param amount 消却する金額
923    */
924   function burn(address sender, uint amount) public auth returns (bool) {
925     require(amount > 0);
926     require(_storage.coinBalance(sender) >= amount);
927     require(_storage.tokenBalance(sender) >= amount);
928 
929     _association.newProposal(keccak256('burn'), sender, amount, '');
930 
931     return true;
932     /*return proposalEntity.burn(sender, amount);*/
933   }
934 
935   /**
936    * 提案を承認する。
937    * #TODO proposalIdは分からないので、別のものからproposalを特定しないといかんよ
938    */
939   function confirmProposal(address sender, bytes32 type_, uint proposalId) public auth {
940     _association.confirmProposal(type_, sender, proposalId);
941     /*proposalEntity.confirmProposal(sender, type_, proposalId);*/
942   }
943 
944   /**
945    * 指定した種類の提案数を取得する
946    *
947    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
948    *
949    * @return 提案数（承認されていないものも含む）
950    */
951   function numberOfProposals(bytes32 type_) public view returns (uint) {
952     return _association.numberOfProposals(type_);
953     /*return proposalEntity.numberOfProposals(type_);*/
954   }
955 
956   /**
957    * 関連づける承認プロセスを変更する
958    *
959    * @param association_ 新しい承認プロセス
960    */
961   function changeAssociation(address association_) public auth returns (bool) {
962     _association = IkuraAssociation(association_);
963     return true;
964   }
965 
966   /**
967    * 永続化ストレージを設定する
968    *
969    * @param storage_ 永続化ストレージのインスタンス（アドレス）
970    */
971   function changeStorage(address storage_) public auth returns (bool) {
972     _storage = IkuraStorage(storage_);
973     return true;
974   }
975 
976   /**
977    * ロジックのバージョンを返す
978    *
979    * @param sender 実行ユーザーのアドレス
980    *
981    * @return バージョン情報
982    */
983   function logicVersion(address sender) public view returns (uint) {
984     sender; // #HACK
985 
986     return _logicVersion;
987   }
988 }
989 
990 /**
991  * 経過時間とSHINJI Tokenの所有比率によって特定のアクションの承認を行うクラス
992  */
993 contract IkuraAssociation is DSMath, DSAuth {
994   //
995   // public
996   //
997 
998   // 提案が承認されるために必要な賛成票の割合
999   uint public confirmTotalTokenThreshold = 50;
1000 
1001   //
1002   // private
1003   //
1004 
1005   // データの永続化ストレージ
1006   IkuraStorage _storage;
1007   IkuraToken _token;
1008 
1009   // 提案一覧
1010   Proposal[] mintProposals;
1011   Proposal[] burnProposals;
1012 
1013   mapping (bytes32 => Proposal[]) proposals;
1014 
1015   struct Proposal {
1016     address proposer;                     // 提案者
1017     bytes32 digest;                       // チェックサム
1018     bool executed;                        // 実行の有無
1019     uint createdAt;                       // 提案作成日時
1020     uint expireAt;                        // 提案の締め切り
1021     address[] confirmers;                 // 承認者
1022     uint amount;                          // 鋳造量
1023   }
1024 
1025   //
1026   // Events
1027   //
1028 
1029   event MintProposalAdded(uint proposalId, address proposer, uint amount);
1030   event MintConfirmed(uint proposalId, address confirmer, uint amount);
1031   event MintExecuted(uint proposalId, address proposer, uint amount);
1032 
1033   event BurnProposalAdded(uint proposalId, address proposer, uint amount);
1034   event BurnConfirmed(uint proposalId, address confirmer, uint amount);
1035   event BurnExecuted(uint proposalId, address proposer, uint amount);
1036 
1037   constructor() public {
1038     proposals[keccak256('mint')] = mintProposals;
1039     proposals[keccak256('burn')] = burnProposals;
1040 
1041     // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
1042     //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
1043     // 勿論テストは通らなくなるので、テストが通ったら試してね
1044     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
1045     owner = controllerAddress;
1046     LogSetOwner(controllerAddress);*/
1047   }
1048 
1049   /**
1050    * 永続化ストレージを設定する
1051    *
1052    * @param newStorage 永続化ストレージのインスタンス（アドレス）
1053    */
1054   function changeStorage(IkuraStorage newStorage) public auth returns (bool) {
1055     _storage = newStorage;
1056     return true;
1057   }
1058 
1059   function changeToken(IkuraToken token_) public auth returns (bool) {
1060     _token = token_;
1061     return true;
1062   }
1063 
1064   /**
1065    * 提案を作成する
1066    *
1067    * @param proposer 提案者のアドレス
1068    * @param amount 鋳造量
1069    */
1070   function newProposal(bytes32 type_, address proposer, uint amount, bytes transationBytecode) public returns (uint) {
1071     uint proposalId = proposals[type_].length++;
1072     Proposal storage proposal = proposals[type_][proposalId];
1073     proposal.proposer = proposer;
1074     proposal.amount = amount;
1075     proposal.digest = keccak256(proposer, amount, transationBytecode);
1076     proposal.executed = false;
1077     proposal.createdAt = now;
1078     proposal.expireAt = proposal.createdAt + 86400;
1079 
1080     // 提案の種類毎に実行すべき内容を実行する
1081     // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
1082     if (type_ == keccak256('mint')) emit MintProposalAdded(proposalId, proposer, amount);
1083     if (type_ == keccak256('burn')) emit BurnProposalAdded(proposalId, proposer, amount);
1084 
1085     // 本人は当然承認
1086     confirmProposal(type_, proposer, proposalId);
1087 
1088     return proposalId;
1089   }
1090 
1091   /**
1092    * トークン所有者が提案に対して賛成する
1093    *
1094    * @param type_ 提案の種類
1095    * @param confirmer 承認者のアドレス
1096    * @param proposalId 提案ID
1097    */
1098   function confirmProposal(bytes32 type_, address confirmer, uint proposalId) public {
1099     Proposal storage proposal = proposals[type_][proposalId];
1100 
1101     // 既に承認済みの場合はエラーを返す
1102     require(!hasConfirmed(type_, confirmer, proposalId));
1103 
1104     // 承認行為を行ったフラグを立てる
1105     proposal.confirmers.push(confirmer);
1106 
1107     // 提案の種類毎に実行すべき内容を実行する
1108     // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
1109     if (type_ == keccak256('mint')) emit MintConfirmed(proposalId, confirmer, proposal.amount);
1110     if (type_ == keccak256('burn')) emit BurnConfirmed(proposalId, confirmer, proposal.amount);
1111 
1112     if (isProposalExecutable(type_, proposalId, proposal.proposer, '')) {
1113       proposal.executed = true;
1114 
1115       // 提案の種類毎に実行すべき内容を実行する
1116       // @NOTE literal_stringとbytesは単純に比較できないのでkeccak256のハッシュ値で比較している
1117       if (type_ == keccak256('mint')) executeMintProposal(proposalId);
1118       if (type_ == keccak256('burn')) executeBurnProposal(proposalId);
1119     }
1120   }
1121 
1122   /**
1123    * 既に承認済みの提案かどうかを返す
1124    *
1125    * @param type_ 提案の種類
1126    * @param addr 承認者のアドレス
1127    * @param proposalId 提案ID
1128    *
1129    * @return 承認済みであればtrue、そうでなければfalse
1130    */
1131   function hasConfirmed(bytes32 type_, address addr, uint proposalId) internal view returns (bool) {
1132     Proposal storage proposal = proposals[type_][proposalId];
1133     uint length = proposal.confirmers.length;
1134 
1135     for (uint i = 0; i < length; i++) {
1136       if (proposal.confirmers[i] == addr) return true;
1137     }
1138 
1139     return false;
1140   }
1141 
1142   /**
1143    * 指定した提案を承認したトークンの総量を返す
1144    *
1145    * @param type_ 提案の種類
1146    * @param proposalId 提案ID
1147    *
1148    * @return 承認に投票されたトークン数
1149    */
1150   function confirmedTotalToken(bytes32 type_, uint proposalId) internal view returns (uint) {
1151     Proposal storage proposal = proposals[type_][proposalId];
1152     uint length = proposal.confirmers.length;
1153     uint total = 0;
1154 
1155     for (uint i = 0; i < length; i++) {
1156       total = add(total, _storage.tokenBalance(proposal.confirmers[i]));
1157     }
1158 
1159     return total;
1160   }
1161 
1162   /**
1163    * 指定した提案の締め切りを返す
1164    *
1165    * @param type_ 提案の種類
1166    * @param proposalId 提案ID
1167    *
1168    * @return 提案の締め切り
1169    */
1170   function proposalExpireAt(bytes32 type_, uint proposalId) public view returns (uint) {
1171     Proposal storage proposal = proposals[type_][proposalId];
1172     return proposal.expireAt;
1173   }
1174 
1175   /**
1176    * 提案が実行条件を満たしているかを返す
1177    *
1178    * 【承認条件】
1179    * - まだ実行していない
1180    * - 提案の有効期限内である
1181    * - 指定した割合以上の賛成トークンを得ている
1182    *
1183    * @param proposalId 提案ID
1184    *
1185    * @return 実行条件を満たしている場合はtrue、そうでない場合はfalse
1186    */
1187   function isProposalExecutable(bytes32 type_, uint proposalId, address proposer, bytes transactionBytecode) internal view returns (bool) {
1188     Proposal storage proposal = proposals[type_][proposalId];
1189 
1190     // オーナーがcontrollerを登録したユーザーしか存在しない場合は
1191     if (_storage.numOwnerAddress() < 2) {
1192       return true;
1193     }
1194 
1195     return  proposal.digest == keccak256(proposer, proposal.amount, transactionBytecode) &&
1196             isProposalNotExpired(type_, proposalId) &&
1197             mul(100, confirmedTotalToken(type_, proposalId)) / _storage.totalSupply() > confirmTotalTokenThreshold;
1198   }
1199 
1200   /**
1201    * 指定した種類の提案数を取得する
1202    *
1203    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
1204    *
1205    * @return 提案数（承認されていないものも含む）
1206    */
1207   function numberOfProposals(bytes32 type_) public constant returns (uint) {
1208     return proposals[type_].length;
1209   }
1210 
1211   /**
1212    * 未承認で有効期限の切れていない提案の数を返す
1213    *
1214    * @param type_ 提案の種類（'mint' | 'burn' | 'transferMinimumFee' | 'transferFeeRate'）
1215    *
1216    * @return 提案数
1217    */
1218   function numberOfActiveProposals(bytes32 type_) public view returns (uint) {
1219     uint numActiveProposal = 0;
1220 
1221     for(uint i = 0; i < proposals[type_].length; i++) {
1222       if (isProposalNotExpired(type_, i)) {
1223         numActiveProposal++;
1224       }
1225     }
1226 
1227     return numActiveProposal;
1228   }
1229 
1230   /**
1231    * 提案の有効期限が切れていないかチェックする
1232    *
1233    * - 実行されていない
1234    * - 有効期限が切れていない
1235    *
1236    * 場合のみtrueを返す
1237    */
1238   function isProposalNotExpired(bytes32 type_, uint proposalId) internal view returns (bool) {
1239     Proposal storage proposal = proposals[type_][proposalId];
1240 
1241     return  !proposal.executed &&
1242             now < proposal.expireAt;
1243   }
1244 
1245   /**
1246    * dJPYを鋳造する
1247    *
1248    * - 鋳造する量が0より大きい
1249    *
1250    * 場合は成功する
1251    *
1252    * @param proposalId 提案ID
1253    */
1254   function executeMintProposal(uint proposalId) internal returns (bool) {
1255     Proposal storage proposal = proposals[keccak256('mint')][proposalId];
1256 
1257     // ここでも念のためチェックを入れる
1258     require(proposal.amount > 0);
1259 
1260     emit MintExecuted(proposalId, proposal.proposer, proposal.amount);
1261 
1262     // 総供給量 / 実行者のdJPY / 実行者のSHINJI tokenを増やす
1263     _storage.addTotalSupply(proposal.amount);
1264     _storage.addCoinBalance(proposal.proposer, proposal.amount);
1265     _storage.addTokenBalance(proposal.proposer, proposal.amount);
1266 
1267     return true;
1268   }
1269 
1270   /**
1271    * dJPYを消却する
1272    *
1273    * - 消却する量が0より大きい
1274    * - 提案者の所有するdJPYの残高がamount以上
1275    * - 提案者の所有するSHINJIがamountよりも大きい
1276    *
1277    * 場合は成功する
1278    *
1279    * @param proposalId 提案ID
1280    */
1281   function executeBurnProposal(uint proposalId) internal returns (bool) {
1282     Proposal storage proposal = proposals[keccak256('burn')][proposalId];
1283 
1284     // ここでも念のためチェックを入れる
1285     require(proposal.amount > 0);
1286     require(_storage.coinBalance(proposal.proposer) >= proposal.amount);
1287     require(_storage.tokenBalance(proposal.proposer) >= proposal.amount);
1288 
1289     emit BurnExecuted(proposalId, proposal.proposer, proposal.amount);
1290 
1291     // 総供給量 / 実行者のdJPY / 実行者のSHINJI tokenを減らす
1292     _storage.subTotalSupply(proposal.amount);
1293     _storage.subCoinBalance(proposal.proposer, proposal.amount);
1294     _storage.subTokenBalance(proposal.proposer, proposal.amount);
1295 
1296     return true;
1297   }
1298 
1299   function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
1300     sig; // #HACK
1301 
1302     return  src == address(this) ||
1303             src == owner ||
1304             src == address(_token);
1305   }
1306 }