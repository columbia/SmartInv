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
14 // import 'ds-auth/auth.sol';
15 pragma solidity ^0.4.23;
16 
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
71 /// math.sol -- mixin for inline numerical wizardry
72 
73 // This program is free software: you can redistribute it and/or modify
74 // it under the terms of the GNU General Public License as published by
75 // the Free Software Foundation, either version 3 of the License, or
76 // (at your option) any later version.
77 
78 // This program is distributed in the hope that it will be useful,
79 // but WITHOUT ANY WARRANTY; without even the implied warranty of
80 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
81 // GNU General Public License for more details.
82 
83 // You should have received a copy of the GNU General Public License
84 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
85 
86 pragma solidity ^0.4.13;
87 
88 contract DSMath {
89     function add(uint x, uint y) internal pure returns (uint z) {
90         require((z = x + y) >= x);
91     }
92     function sub(uint x, uint y) internal pure returns (uint z) {
93         require((z = x - y) <= x);
94     }
95     function mul(uint x, uint y) internal pure returns (uint z) {
96         require(y == 0 || (z = x * y) / y == x);
97     }
98 
99     function min(uint x, uint y) internal pure returns (uint z) {
100         return x <= y ? x : y;
101     }
102     function max(uint x, uint y) internal pure returns (uint z) {
103         return x >= y ? x : y;
104     }
105     function imin(int x, int y) internal pure returns (int z) {
106         return x <= y ? x : y;
107     }
108     function imax(int x, int y) internal pure returns (int z) {
109         return x >= y ? x : y;
110     }
111 
112     uint constant WAD = 10 ** 18;
113     uint constant RAY = 10 ** 27;
114 
115     function wmul(uint x, uint y) internal pure returns (uint z) {
116         z = add(mul(x, y), WAD / 2) / WAD;
117     }
118     function rmul(uint x, uint y) internal pure returns (uint z) {
119         z = add(mul(x, y), RAY / 2) / RAY;
120     }
121     function wdiv(uint x, uint y) internal pure returns (uint z) {
122         z = add(mul(x, WAD), y / 2) / y;
123     }
124     function rdiv(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, RAY), y / 2) / y;
126     }
127 
128     // This famous algorithm is called "exponentiation by squaring"
129     // and calculates x^n with x as fixed-point and n as regular unsigned.
130     //
131     // It's O(log n), instead of O(n) for naive repeated multiplication.
132     //
133     // These facts are why it works:
134     //
135     //  If n is even, then x^n = (x^2)^(n/2).
136     //  If n is odd,  then x^n = x * x^(n-1),
137     //   and applying the equation for even x gives
138     //    x^n = x * (x^2)^((n-1) / 2).
139     //
140     //  Also, EVM division is flooring and
141     //    floor[(n-1) / 2] = floor[n / 2].
142     //
143     function rpow(uint x, uint n) internal pure returns (uint z) {
144         z = n % 2 != 0 ? x : RAY;
145 
146         for (n /= 2; n != 0; n /= 2) {
147             x = rmul(x, x);
148 
149             if (n % 2 != 0) {
150                 z = rmul(z, x);
151             }
152         }
153     }
154 }
155 
156 
157 // import './IkuraStorage.sol';
158 
159 /**
160  *
161  * ロジックの更新に影響されない永続化データを保持するクラス
162  *
163  */
164 contract IkuraStorage is DSMath, DSAuth {
165   // オーナー（中央銀行）のアドレス
166   address[] ownerAddresses;
167 
168   // 各アドレスのdJPYの口座残高
169   mapping(address => uint) coinBalances;
170 
171   // 各アドレスのSHINJI tokenの口座残高
172   mapping(address => uint) tokenBalances;
173 
174   // 各アドレスが指定したアドレスに対して許可する最大送金額
175   mapping(address => mapping (address => uint)) coinAllowances;
176 
177   // dJPYの発行高
178   uint _totalSupply = 0;
179 
180   // 手数料率
181   // 0.01pips = 1
182   // 例). 手数料を 0.05% とする場合は 500
183   uint _transferFeeRate = 500;
184 
185   // 最低手数料額
186   // 1 = 1dJPY
187   // amount * 手数料率で算出した金額がここで設定した最低手数料を下回る場合は、最低手数料額を手数料とする
188   uint8 _transferMinimumFee = 5;
189 
190   address tokenAddress;
191   address multiSigAddress;
192   address authorityAddress;
193 
194   // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
195   //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
196   // 勿論テストは通らなくなるので、テストが通ったら試してね
197   constructor() public DSAuth() {
198     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
199     owner = controllerAddress;
200     LogSetOwner(controllerAddress);*/
201   }
202 
203   function changeToken(address tokenAddress_) public auth {
204     tokenAddress = tokenAddress_;
205   }
206 
207   function changeAssociation(address multiSigAddress_) public auth {
208     multiSigAddress = multiSigAddress_;
209   }
210 
211   function changeAuthority(address authorityAddress_) public auth {
212     authorityAddress = authorityAddress_;
213   }
214 
215   // --------------------------------------------------
216   // functions for _totalSupply
217   // --------------------------------------------------
218 
219   /**
220    * 総発行額を返す
221    *
222    * @return 総発行額
223    */
224   function totalSupply() public view auth returns (uint) {
225     return _totalSupply;
226   }
227 
228   /**
229    * 総発行数を増やす（mintと並行して呼ばれることを想定）
230    *
231    * @param amount 鋳造数
232    */
233   function addTotalSupply(uint amount) public auth {
234     _totalSupply = add(_totalSupply, amount);
235   }
236 
237   /**
238    * 総発行数を減らす（burnと並行して呼ばれることを想定）
239    *
240    * @param amount 鋳造数
241    */
242   function subTotalSupply(uint amount) public auth {
243     _totalSupply = sub(_totalSupply, amount);
244   }
245 
246   // --------------------------------------------------
247   // functions for _transferFeeRate
248   // --------------------------------------------------
249 
250   /**
251    * 手数料率を返す
252    *
253    * @return 現在の手数料率
254    */
255   function transferFeeRate() public view auth returns (uint) {
256     return _transferFeeRate;
257   }
258 
259   /**
260    * 手数料率を変更する
261    *
262    * @param newTransferFeeRate 新しい手数料率
263    *
264    * @return 更新に成功したらtrue、失敗したらfalse（今のところ失敗するケースはない）
265    */
266   function setTransferFeeRate(uint newTransferFeeRate) public auth returns (bool) {
267     _transferFeeRate = newTransferFeeRate;
268 
269     return true;
270   }
271 
272   // --------------------------------------------------
273   // functions for _transferMinimumFee
274   // --------------------------------------------------
275 
276   /**
277    * 最低手数料返す
278    *
279    * @return 現在の最低手数料
280    */
281   function transferMinimumFee() public view auth returns (uint8) {
282     return _transferMinimumFee;
283   }
284 
285   /**
286    * 最低手数料を変更する
287    *
288    * @param newTransferMinimumFee 新しい最低手数料
289    *
290    * @return 更新に成功したらtrue、失敗したらfalse（今のところ失敗するケースはない）
291    */
292   function setTransferMinimumFee(uint8 newTransferMinimumFee) public auth {
293     _transferMinimumFee = newTransferMinimumFee;
294   }
295 
296   // --------------------------------------------------
297   // functions for ownerAddresses
298   // --------------------------------------------------
299 
300   /**
301    * 指定したユーザーアドレスをオーナーの一覧に追加する
302    *
303    * トークンの移動時に内部的にオーナーのアドレスを管理するための関数。
304    * トークンの所有者 = オーナーという扱いになったので、この配列に含まれるアドレスの一覧は
305    * 手数料からの収益の分配をする時に利用するだけで、オーナーかどうかの判定には利用しない
306    *
307    * @param addr ユーザーのアドレス
308    *
309    * @return 処理に成功したらtrue、失敗したらfalse
310    */
311   function addOwnerAddress(address addr) internal returns (bool) {
312     ownerAddresses.push(addr);
313 
314     return true;
315   }
316 
317   /**
318    * 指定したユーザーアドレスをオーナーの一覧から削除する
319    *
320    * トークンの移動時に内部的にオーナーのアドレスを管理するための関数。
321    *
322    * @param addr オーナーに属するユーザーのアドレス
323    *
324    * @return 処理に成功したらtrue、失敗したらfalse
325    */
326   function removeOwnerAddress(address addr) internal returns (bool) {
327     uint i = 0;
328 
329     while (ownerAddresses[i] != addr) { i++; }
330 
331     while (i < ownerAddresses.length - 1) {
332       ownerAddresses[i] = ownerAddresses[i + 1];
333       i++;
334     }
335 
336     ownerAddresses.length--;
337 
338     return true;
339   }
340 
341   /**
342    * 最初のオーナー（contractをdeployしたユーザー）のアドレスを返す
343    *
344    * @return 最初のオーナーのアドレス
345    */
346   function primaryOwner() public view auth returns (address) {
347     return ownerAddresses[0];
348   }
349 
350   /**
351    * 指定したアドレスがオーナーアドレスに登録されているか返す
352    *
353    * @param addr ユーザーのアドレス
354    *
355    * @return オーナーに含まれている場合はtrue、含まれていない場合はfalse
356    */
357   function isOwnerAddress(address addr) public view auth returns (bool) {
358     for (uint i = 0; i < ownerAddresses.length; i++) {
359       if (ownerAddresses[i] == addr) return true;
360     }
361 
362     return false;
363   }
364 
365   /**
366    * オーナー数を返す
367    *
368    * @return オーナー数
369    */
370   function numOwnerAddress() public view auth returns (uint) {
371     return ownerAddresses.length;
372   }
373 
374   // --------------------------------------------------
375   // functions for coinBalances
376   // --------------------------------------------------
377 
378   /**
379    * 指定したユーザーのdJPY残高を返す
380    *
381    * @param addr ユーザーのアドレス
382    *
383    * @return dJPY残高
384    */
385   function coinBalance(address addr) public view auth returns (uint) {
386     return coinBalances[addr];
387   }
388 
389   /**
390    * 指定したユーザーのdJPYの残高を増やす
391    *
392    * @param addr ユーザーのアドレス
393    * @param amount 差分
394    *
395    * @return 処理に成功したらtrue、失敗したらfalse
396    */
397   function addCoinBalance(address addr, uint amount) public auth returns (bool) {
398     coinBalances[addr] = add(coinBalances[addr], amount);
399 
400     return true;
401   }
402 
403   /**
404    * 指定したユーザーのdJPYの残高を減らす
405    *
406    * @param addr ユーザーのアドレス
407    * @param amount 差分
408    *
409    * @return 処理に成功したらtrue、失敗したらfalse
410    */
411   function subCoinBalance(address addr, uint amount) public auth returns (bool) {
412     coinBalances[addr] = sub(coinBalances[addr], amount);
413 
414     return true;
415   }
416 
417   // --------------------------------------------------
418   // functions for tokenBalances
419   // --------------------------------------------------
420 
421   /**
422    * 指定したユーザーのSHINJIトークンの残高を返す
423    *
424    * @param addr ユーザーのアドレス
425    *
426    * @return SHINJIトークン残高
427    */
428   function tokenBalance(address addr) public view auth returns (uint) {
429     return tokenBalances[addr];
430   }
431 
432   /**
433    * 指定したユーザーのSHINJIトークンの残高を増やす
434    *
435    * @param addr ユーザーのアドレス
436    * @param amount 差分
437    *
438    * @return 処理に成功したらtrue、失敗したらfalse
439    */
440   function addTokenBalance(address addr, uint amount) public auth returns (bool) {
441     tokenBalances[addr] = add(tokenBalances[addr], amount);
442 
443     if (tokenBalances[addr] > 0 && !isOwnerAddress(addr)) {
444       addOwnerAddress(addr);
445     }
446 
447     return true;
448   }
449 
450   /**
451    * 指定したユーザーのSHINJIトークンの残高を減らす
452    *
453    * @param addr ユーザーのアドレス
454    * @param amount 差分
455    *
456    * @return 処理に成功したらtrue、失敗したらfalse
457    */
458   function subTokenBalance(address addr, uint amount) public auth returns (bool) {
459     tokenBalances[addr] = sub(tokenBalances[addr], amount);
460 
461     if (tokenBalances[addr] <= 0) {
462       removeOwnerAddress(addr);
463     }
464 
465     return true;
466   }
467 
468   // --------------------------------------------------
469   // functions for coinAllowances
470   // --------------------------------------------------
471 
472   /**
473    * 送金許可金額を返す
474    *
475    * @param owner_ 送金者
476    * @param spender 送金代行者
477    *
478    * @return 送金許可金額
479    */
480   function coinAllowance(address owner_, address spender) public view auth returns (uint) {
481     return coinAllowances[owner_][spender];
482   }
483 
484   /**
485    * 送金許可金額を指定した金額だけ増やす
486    *
487    * @param owner_ 送金者
488    * @param spender 送金代行者
489    * @param amount 金額
490    *
491    * @return 更新に成功したらtrue、失敗したらfalse
492    */
493   function addCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
494     coinAllowances[owner_][spender] = add(coinAllowances[owner_][spender], amount);
495 
496     return true;
497   }
498 
499   /**
500    * 送金許可金額を指定した金額だけ減らす
501    *
502    * @param owner_ 送金者
503    * @param spender 送金代行者
504    * @param amount 金額
505    *
506    * @return 更新に成功したらtrue、失敗したらfalse
507    */
508   function subCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
509     coinAllowances[owner_][spender] = sub(coinAllowances[owner_][spender], amount);
510 
511     return true;
512   }
513 
514   /**
515    * 送金許可金額を指定した値に更新する
516    *
517    * @param owner_ 送金者
518    * @param spender 送金代行者
519    * @param amount 送金許可金額
520    *
521    * @return 指定に成功したらtrue、失敗したらfalse
522    */
523   function setCoinAllowance(address owner_, address spender, uint amount) public auth returns (bool) {
524     coinAllowances[owner_][spender] = amount;
525 
526     return true;
527   }
528 
529   /**
530    * 権限チェック用関数のoverride
531    *
532    * @param src 実行者アドレス
533    * @param sig 実行関数の識別子
534    *
535    * @return 実行が許可されていればtrue、そうでなければfalse
536    */
537   function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
538     sig; // #HACK
539 
540     return  src == address(this) ||
541             src == owner ||
542             src == tokenAddress ||
543             src == authorityAddress ||
544             src == multiSigAddress;
545   }
546 }
547 
548 /**
549  *
550  * アクセス権限を制御するクラス
551  *
552  */
553 contract IkuraAuthority is DSAuthority, DSAuth {
554   // データの永続化ストレージ
555   IkuraStorage tokenStorage;
556 
557   // 対称アクションが投票を必要としている場かどうかのマッピング
558   // #TODO 後から投票アクションを増減させたいのであれば、これもstorageクラスに持っていったほうがよい？
559   mapping(bytes4 => bool) actionsWithToken;
560 
561   // 誰からも呼び出すことができないアクション
562   mapping(bytes4 => bool) actionsForbidden;
563 
564   // @NOTE リリース時にcontractのdeploy -> watch contract -> setOwnerの流れを
565   //省略したい場合は、ここで直接controllerのアドレスを指定するとショートカットできます
566   // 勿論テストは通らなくなるので、テストが通ったら試してね
567   constructor() public DSAuth() {
568     /*address controllerAddress = 0x34c5605A4Ef1C98575DB6542179E55eE1f77A188;
569     owner = controllerAddress;
570     LogSetOwner(controllerAddress);*/
571   }
572 
573   /**
574    * ストレージを更新する
575    *
576    * @param storage_ 新しいストレージのアドレス
577    */
578   function changeStorage(address storage_) public auth {
579     tokenStorage = IkuraStorage(storage_);
580 
581     // トークンの保有率による承認プロセスが必要なアクションを追加
582     actionsWithToken[stringToSig('mint(uint256)')] = true;
583     actionsWithToken[stringToSig('burn(uint256)')] = true;
584     actionsWithToken[stringToSig('confirmProposal(string, uint256)')] = true;
585     actionsWithToken[stringToSig('numberOfProposals(string)')] = true;
586 
587     // 誰からも呼び出すことができないアクションを追加
588     actionsForbidden[stringToSig('forbiddenAction()')] = true;
589   }
590 
591   /**
592    * 権限チェックのoverride
593    * オーナーのみ許可する
594    *
595    * @param src 実行者アドレス
596    * @param dst 実行contract
597    * @param sig 実行関数の識別子
598    *
599    * @return 呼び出し権限を持つ場合はtrue、そうでない場合はfalse
600    */
601   function canCall(address src, address dst, bytes4 sig) public constant returns (bool) {
602     // 投票が必要なアクションの場合には別ロジックでチェックを行う
603     if (actionsWithToken[sig]) return canCallWithAssociation(src, dst);
604 
605     // 誰からも呼ぶことができないアクション
606     if (actionsForbidden[sig]) return canCallWithNoOne();
607 
608     // デフォルトの権限チェック
609     return canCallDefault(src);
610   }
611 
612   /**
613    * デフォルトではオーナーメンバー　かどうかをチェックする
614    *
615    * @return オーナーメンバーである場合はtrue、そうでない場合はfalse
616    */
617   function canCallDefault(address src) internal view returns (bool) {
618     return tokenStorage.isOwnerAddress(src);
619   }
620 
621   /**
622    * トークン保有者による投票が必要なアクション
623    *
624    * @param src 実行者アドレス
625    * @param dst 実行contract
626    *
627    * @return アクションを許可する場合はtrue、却下された場合はfalse
628    */
629   function canCallWithAssociation(address src, address dst) internal view returns (bool) {
630     // warning抑制
631     dst;
632 
633     return tokenStorage.isOwnerAddress(src) &&
634            (tokenStorage.numOwnerAddress() == 1 || tokenStorage.tokenBalance(src) > 0);
635   }
636 
637   /**
638    * 誰からも呼ぶことのできないアクション
639    * テスト用の関数です
640    *
641    * @return 常にfalseを返す
642    */
643   function canCallWithNoOne() internal pure returns (bool) {
644     return false;
645   }
646 
647   /**
648    * 関数定義からfunction identifierへ変換する
649    *
650    * #see http://solidity.readthedocs.io/en/develop/units-and-global-variables.html#block-and-transaction-properties
651    *
652    * @param str 関数定義
653    *
654    * @return ハッシュ化されたキーの4バイト
655    */
656   function stringToSig(string str) internal pure returns (bytes4) {
657     return bytes4(keccak256(str));
658   }
659 }