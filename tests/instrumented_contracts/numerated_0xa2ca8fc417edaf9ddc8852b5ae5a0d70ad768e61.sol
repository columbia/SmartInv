1 pragma solidity ^0.4.17;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf( address who ) public view returns (uint value);
6     function allowance( address owner, address spender ) public view returns (uint _allowance);
7 
8     function transfer( address to, uint value) public returns (bool ok);
9     function transferFrom( address from, address to, uint value) public returns (bool ok);
10     function approve( address spender, uint value ) public returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSAuthority {
17     function canCall(
18         address src, address dst, bytes4 sig
19     ) public view returns (bool);
20 }
21 
22 contract DSAuthEvents {
23     event LogSetAuthority (address indexed authority);
24     event LogSetOwner     (address indexed owner);
25 }
26 
27 contract DSAuth is DSAuthEvents {
28     DSAuthority  public  authority;
29     address      public  owner;
30 
31     function DSAuth() public {
32         owner = msg.sender;
33         LogSetOwner(msg.sender);
34     }
35 
36     function setOwner(address owner_)
37         public
38         auth
39     {
40         owner = owner_;
41         LogSetOwner(owner);
42     }
43 
44     function setAuthority(DSAuthority authority_)
45         public
46         auth
47     {
48         authority = authority_;
49         LogSetAuthority(authority);
50     }
51 
52     modifier auth {
53         require(isAuthorized(msg.sender, msg.sig));
54         _;
55     }
56 
57     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
58         if (src == address(this)) {
59             return true;
60         } else if (src == owner) {
61             return true;
62         } else if (authority == DSAuthority(0)) {
63             return false;
64         } else {
65             return authority.canCall(src, this, sig);
66         }
67     }
68 }
69 
70 contract APMath {
71     function safeAdd(uint x, uint y) internal pure returns (uint z) {
72         require((z = x + y) >= x);
73     }
74     function safeSub(uint x, uint y) internal pure returns (uint z) {
75         require((z = x - y) <= x);
76     }
77     function safeMul(uint x, uint y) internal pure returns (uint z) {
78         require(y == 0 || (z = x * y) / y == x);
79     }
80 
81     function safeMin(uint x, uint y) internal pure returns (uint z) {
82         return x <= y ? x : y;
83     }
84     function safeMax(uint x, uint y) internal pure returns (uint z) {
85         return x >= y ? x : y;
86     }
87     function safeMin(int x, int y) internal pure returns (int z) {
88         return x <= y ? x : y;
89     }
90     function safeMax(int x, int y) internal pure returns (int z) {
91         return x >= y ? x : y;
92     }
93 
94     uint constant WAD = 10 ** 18;
95     uint constant RAY = 10 ** 27;
96 
97     function safeWmul(uint x, uint y) internal pure returns (uint z) {
98         z = safeAdd(safeMul(x, y), WAD / 2) / WAD;
99     }
100     function safeRmul(uint x, uint y) internal pure returns (uint z) {
101         z = safeAdd(safeMul(x, y), RAY / 2) / RAY;
102     }
103     function safeWdiv(uint x, uint y) internal pure returns (uint z) {
104         z = safeAdd(safeMul(x, WAD), y / 2) / y;
105     }
106     function safeRdiv(uint x, uint y) internal pure returns (uint z) {
107         z = safeAdd(safeMul(x, RAY), y / 2) / y;
108     }
109 
110     // This famous algorithm is called "exponentiation by squaring"
111     // and calculates x^n with x as fixed-point and n as regular unsigned.
112     //
113     // It's O(log n), instead of O(n) for naive repeated multiplication.
114     //
115     // These facts are why it works:
116     //
117     //  If n is even, then x^n = (x^2)^(n/2).
118     //  If n is odd,  then x^n = x * x^(n-1),
119     //   and applying the equation for even x gives
120     //    x^n = x * (x^2)^((n-1) / 2).
121     //
122     //  Also, EVM division is flooring and
123     //    floor[(n-1) / 2] = floor[n / 2].
124     //
125     function rpow(uint x, uint n) internal pure returns (uint z) {
126         z = n % 2 != 0 ? x : RAY;
127 
128         for (n /= 2; n != 0; n /= 2) {
129             x = safeRmul(x, x);
130 
131             if (n % 2 != 0) {
132                 z = safeRmul(z, x);
133             }
134         }
135     }
136 }
137 
138 contract DrivezyPrivateCoinSharedStorage is DSAuth {
139     uint _totalSupply = 0;
140 
141     // オーナー登録されているアドレス
142     mapping(address => bool) ownerAddresses;
143 
144     // オーナーアドレスの LUT
145     address[] public ownerAddressLUT;
146 
147     // 信頼できるコントラクトに登録されているアドレス
148     mapping(address => bool) trustedContractAddresses;
149 
150     // 信頼できるコントラクトの LUT
151     address[] public trustedAddressLUT;
152 
153     // ホワイトリスト (KYC確認済み) のアドレス
154     mapping(address => bool) approvedAddresses;
155 
156     // ホワイトリストの LUT
157     address[] public approvedAddressLUT;
158 
159     // 常に許可されている関数
160     mapping(bytes4 => bool) actionsAlwaysPermitted;
161 
162     /**
163      * custom events
164      */
165 
166     /* addOwnerAddress したときに発生するイベント
167      * {address} senderAddress - 実行者のアドレス
168      * {address} userAddress - 許可されたユーザのアドレス
169      */
170     event AddOwnerAddress(address indexed senderAddress, address indexed userAddress);
171 
172     /* removeOwnerAddress したときに発生するイベント
173      * {address} senderAddress - 実行者のアドレス
174      * {address} userAddress - 許可を取り消されたユーザのアドレス
175      */
176     event RemoveOwnerAddress(address indexed senderAddress, address indexed userAddress);
177 
178     /* addTrustedContractAddress したときに発生するイベント
179      * {address} senderAddress - 実行者のアドレス
180      * {address} userAddress - 許可されたユーザのアドレス
181      */
182     event AddTrustedContractAddress(address indexed senderAddress, address indexed userAddress);
183 
184     /* removeTrustedContractAddress したときに発生するイベント
185      * {address} senderAddress - 実行者のアドレス
186      * {address} userAddress - 許可を取り消されたユーザのアドレス
187      */
188     event RemoveTrustedContractAddress(address indexed senderAddress, address indexed userAddress);
189 
190 
191     /**
192      * 指定したアドレスをオーナー一覧に追加する
193      * @param addr (address) - オーナーに追加したいアドレス
194      * @return {bool} 追加に成功した場合は true を返す
195      */
196     function addOwnerAddress(address addr) auth public returns (bool) {
197         ownerAddresses[addr] = true;
198         ownerAddressLUT.push(addr);
199         AddOwnerAddress(msg.sender, addr);
200         return true;
201     }
202 
203     /**
204      * 指定したアドレスを信頼できるコントラクト一覧に追加する
205      * ここに追加されたコントラクトは、mint や burn などの管理者コマンドを実行できる (いわゆる sudo)
206      * @param addr (address) - 信頼できるコントラクト一覧に追加したいアドレス
207      * @return {bool} 追加に成功した場合は true を返す
208      */
209     function addTrustedContractAddress(address addr) auth public returns (bool) {
210         trustedContractAddresses[addr] = true;
211         trustedAddressLUT.push(addr);
212         AddTrustedContractAddress(msg.sender, addr);
213         return true;
214     }
215 
216     /**
217      * 指定したアドレスをKYC承認済みアドレス一覧に追加する
218      * ここに追加されたアドレスはトークンの購入ができる
219      * @param addr (address) - KYC承認済みアドレス一覧に追加したいアドレス
220      * @return {bool} 追加に成功した場合は true を返す
221      */
222     function addApprovedAddress(address addr) auth public returns (bool) {
223         approvedAddresses[addr] = true;
224         approvedAddressLUT.push(addr);
225         return true;
226     }
227 
228     /**
229      * 指定したアドレスをオーナー一覧から削除する
230      * @param addr (address) - オーナーから外したいアドレス
231      * @return {bool} 削除に成功した場合は true を返す
232      */
233     function removeOwnerAddress(address addr) auth public returns (bool) {
234         ownerAddresses[addr] = false;
235         RemoveOwnerAddress(msg.sender, addr);
236         return true;
237     }
238 
239     /**
240      * 指定したアドレスを信頼できるコントラクト一覧から削除する
241      * @param addr (address) - 信頼できるコントラクト一覧から外したいアドレス
242      * @return {bool} 削除に成功した場合は true を返す
243      */
244     function removeTrustedContractAddress(address addr) auth public returns (bool) {
245         trustedContractAddresses[addr] = false;
246         RemoveTrustedContractAddress(msg.sender, addr);
247         return true;
248     }
249 
250     /**
251      * 指定したアドレスをKYC承認済みアドレス一覧から削除する
252      * @param addr (address) - KYC承認済みアドレス一覧から外したいアドレス
253      * @return {bool} 削除に成功した場合は true を返す
254      */
255     function removeApprovedAddress(address addr) auth public returns (bool) {
256         approvedAddresses[addr] = false;
257         return true;
258     }
259 
260     /**
261      * 指定したアドレスがオーナーであるかを調べる
262      * @param addr (address) - オーナーであるか調べたいアドレス
263      * @return {bool} オーナーであった場合は true を返す
264      */
265     function isOwnerAddress(address addr) public constant returns (bool) {
266         return ownerAddresses[addr];
267     }
268 
269     /**
270      * 指定したアドレスがKYC承認済みであるかを調べる
271      * @param addr (address) - KYC承認済みであるか調べたいアドレス
272      * @return {bool} KYC承認済みであった場合は true を返す
273      */
274     function isApprovedAddress(address addr) public constant returns (bool) {
275         return approvedAddresses[addr];
276     }
277 
278     /**
279      * 指定したアドレスが信頼できるコントラクトであるかを調べる
280      * @param addr (address) - 信頼できるコントラクトであるか調べたいアドレス
281      * @return {bool} 信頼できるコントラクトであった場合は true を返す
282      */
283     function isTrustedContractAddress(address addr) public constant returns (bool) {
284         return trustedContractAddresses[addr];
285     }
286 
287     /**
288      * オーナーのアドレス一覧に登録しているアドレス数を調べる
289      * 同一アドレスについて、リストの追加と削除を繰り返した場合は重複してカウントされる 
290      * @return {uint} 登録されているアドレスの数
291      */
292     function ownerAddressSize() public constant returns (uint) {
293         return ownerAddressLUT.length;
294     }
295 
296     /**
297      * n 番目に登録されたオーナーのアドレスを取得する (Look up table)
298      * @param index (uint) - n 番目を指定する
299      * @return {address} 登録されているアドレス
300      */
301     function ownerAddressInLUT(uint index) public constant returns (address) {
302         return ownerAddressLUT[index];
303     }
304 
305     /**
306      * 信頼できるコントラクト一覧に登録しているアドレス数を調べる
307      * 同一アドレスについて、リストの追加と削除を繰り返した場合は重複してカウントされる 
308      * @return {uint} 登録されているアドレスの数
309      */
310     function trustedAddressSize() public constant returns (uint) {
311         return trustedAddressLUT.length;
312     }
313 
314     /**
315      * n 番目に登録された信頼できるコントラクトを取得する (Look up table)
316      * @param index (uint) - n 番目を指定する
317      * @return {address} 登録されているコントラクトのアドレス
318      */
319     function trustedAddressInLUT(uint index) public constant returns (address) {
320         return trustedAddressLUT[index];
321     }
322 
323     /**
324      * KYC承認済みアドレスの一覧に登録しているアドレス数を調べる
325      * 同一アドレスについて、リストの追加と削除を繰り返した場合は重複してカウントされる 
326      * @return {uint} 登録されているアドレスの数
327      */
328     function approvedAddressSize() public constant returns (uint) {
329         return approvedAddressLUT.length;
330     }
331 
332     /**
333      * n 番目に登録されたKYC承認済みアドレスを取得する (Look up table)
334      * @param index (uint) - n 番目を指定する
335      * @return {address} 登録されているアドレス
336      */
337     function approvedAddressInLUT(uint index) public constant returns (address) {
338         return approvedAddressLUT[index];
339     }
340 
341 
342     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
343         return src == address(this) || src == owner || isOwnerAddress(src) || isTrustedContractAddress(src) || actionsAlwaysPermitted[sig];
344     }
345 }
346 
347 contract DrivezyPrivateCoinStorage is DSAuth {
348     uint _totalSupply = 0;
349 
350     // 残高一覧
351     mapping(address => uint) coinBalances;
352 
353     // 送金許可額の一覧
354     mapping(address => mapping (address => uint)) coinAllowances;
355 
356     // 共通ストレージ
357     DrivezyPrivateCoinSharedStorage public sharedStorage;
358 
359     // 常に許可されている関数
360     mapping(bytes4 => bool) actionsAlwaysPermitted;
361 
362     // ユーザ間での送金ができるかどうか
363     bool public transferBetweenUsers;
364 
365     function totalSupply() external constant returns (uint) {
366         return _totalSupply;
367     }
368 
369     function setTotalSupply(uint amount) auth external returns (bool) {
370         _totalSupply = amount;
371         return true;
372     }
373 
374     function coinBalanceOf(address addr) external constant returns (uint) {
375         return coinBalances[addr];
376     }
377 
378     function coinAllowanceOf(address _owner, address spender) external constant returns (uint) {
379         return coinAllowances[_owner][spender];
380     }
381 
382     function setCoinBalance(address addr, uint amount) auth external returns (bool) {
383         coinBalances[addr] = amount;
384         return true;
385     }
386 
387     function setCoinAllowance(address _owner, address spender, uint value) auth external returns (bool) {
388         coinAllowances[_owner][spender] = value;
389         return true;
390     }
391 
392     function setSharedStorage(address addr) auth public returns (bool) {
393         sharedStorage = DrivezyPrivateCoinSharedStorage(addr);
394         return true;
395     }
396 
397     function allowTransferBetweenUsers() auth public returns (bool) {
398         transferBetweenUsers = true;
399         return true;
400     }
401 
402     function disallowTransferBetweenUsers() auth public returns (bool) {
403         transferBetweenUsers = false;
404         return true;
405     }
406 
407     function canTransferBetweenUsers() public view returns (bool) {
408         return transferBetweenUsers;
409     }
410 
411     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
412         return actionsAlwaysPermitted[sig] || src == address(this) || src == owner || sharedStorage.isOwnerAddress(src) || sharedStorage.isTrustedContractAddress(src);
413     }
414 }
415 
416 contract DrivezyPrivateCoinAcceptableContract {
417     function receiveToken(address addr, uint amount) public returns (bool);
418 
419     function isDrivezyPrivateTokenAcceptable() public pure returns (bool);
420 }
421 
422 contract DrivezyPrivateCoinImplementation is DSAuth, APMath {
423     DrivezyPrivateCoinStorage public coinStorage;
424     DrivezyPrivateCoinSharedStorage public sharedStorage;
425     DrivezyPrivateCoin public coin;
426 
427 
428     /**
429      * custom events
430      */
431 
432     /* storage を設定したときに発生するイベント
433      * {address} senderAddress - 実行者のアドレス
434      * {address} contractAddress - 設定した storage のコントラクトアドレス
435      */
436     event SetStorage(address indexed senderAddress, address indexed contractAddress);
437 
438     /* shared storage を設定したときに発生するイベント
439      * {address} senderAddress - 実行者のアドレス
440      * {address} contractAddress - 設定した shared storage のコントラクトアドレス
441      */
442     event SetSharedStorage(address indexed senderAddress, address indexed contractAddress);
443 
444     /* coin を設定したときに発生するイベント
445      * {address} senderAddress - 実行者のアドレス
446      * {address} contractAddress - 設定した coin のコントラクトアドレス
447      */
448     event SetCoin(address indexed senderAddress, address indexed contractAddress);
449 
450     /* mint したときに発生するイベント
451      * {address} senderAddress - 実行者のアドレス
452      * {address} receiverAddress - コインを受け取るユーザのアドレス
453      * {uint} amount - 発行高
454      */
455     event Mint(address indexed senderAddress, address indexed receiverAddress, uint amount);
456 
457     /* burn したときに発生するイベント
458      * {address} senderAddress - 実行者のアドレス
459      * {address} receiverAddress - コインを消却するユーザのアドレス
460      * {uint} amount - 消却高
461      */
462     event Burn(address indexed senderAddress, address indexed receiverAddress, uint amount);
463 
464     /* addApprovedAddress したときに発生するイベント
465      * {address} senderAddress - 実行者のアドレス
466      * {address} userAddress - 許可されたユーザのアドレス
467      */
468     event AddApprovedAddress(address indexed senderAddress, address indexed userAddress);
469 
470     /* removeApprovedAddress したときに発生するイベント
471      * {address} senderAddress - 実行者のアドレス
472      * {address} userAddress - 許可が取り消されたユーザのアドレス
473      */
474     event RemoveApprovedAddress(address indexed senderAddress, address indexed userAddress);
475 
476     /**
477      * 総発行高を返す
478      * @return {uint} コインの総発行高
479      */
480     function totalSupply() auth public view returns (uint) {
481         return coinStorage.totalSupply();
482     }
483 
484     /**
485      * 指定したアドレスが保有するコインの残高を返す
486      * @param addr {address} - コインの残高を調べたいアドレス
487      * @return {uint} コインの残高
488      */
489     function balanceOf(address addr) auth public view returns (uint) {
490         return coinStorage.coinBalanceOf(addr);
491     }
492 
493     /**
494      * ERC20 Token Standardに準拠した関数
495      *
496      * あるユーザが保有するコインを指定したアドレスに送金する
497      * @param sender {address} - 送信元 (資金源) のアドレス
498      * @param to {address} - 宛先のアドレス
499      * @param amount {uint} - 送付するコインの分量
500      * @return {bool} コインの残高
501      */
502     function transfer(address sender, address to, uint amount) auth public returns (bool) {
503         // 残高を超えて送金してないか確認
504         require(coinStorage.coinBalanceOf(sender) >= amount);
505 
506         // 1円以上送ろうとしているか確認
507         require(amount > 0);
508 
509         // 受取者がオーナーまたは許可された (KYC 通過済み) アドレスかを確認
510         require(canTransfer(sender, to));
511 
512         // 送金元の残高を減らし、送金先の残高を増やす
513         coinStorage.setCoinBalance(sender, safeSub(coinStorage.coinBalanceOf(sender), amount));
514         coinStorage.setCoinBalance(to, safeAdd(coinStorage.coinBalanceOf(to), amount));
515 
516         // 送金先がコントラクトで、isDrivezyPrivateTokenAcceptable が true を返すコントラクトでは
517         // receiveToken() 関数をコールする
518         if (isContract(to)) {
519             DrivezyPrivateCoinAcceptableContract receiver = DrivezyPrivateCoinAcceptableContract(to);
520             if (receiver.isDrivezyPrivateTokenAcceptable()) {
521                 require(receiver.receiveToken(sender, amount));
522             }
523         }
524         return true;
525     }
526 
527     /**
528      * ERC20 Token Standardに準拠した関数
529      *
530      * 指定したユーザが保有するコインを指定したアドレスに送金する
531      * @param sender {address} - 送付操作を実行するユーザのアドレス
532      * @param from {address} - 資金源となるユーザのアドレス
533      * @param to {address} - 宛先のアドレス
534      * @param amount {uint} - 送付するコインの分量
535      * @return {bool} 送付に成功した場合は true を返す
536      */
537     function transferFrom(address sender, address from, address to, uint amount) auth public returns (bool) {
538         // アローアンスを超えて送金してないか確認
539         require(coinStorage.coinAllowanceOf(sender, from) >= amount);
540 
541         // transfer 処理に引き継ぐ
542         transfer(from, to, amount);
543 
544         // アローアンスを減らす
545         coinStorage.setCoinAllowance(from, sender, safeSub(coinStorage.coinAllowanceOf(sender, from), amount));
546 
547         return true;
548     }
549 
550     /**
551      * ERC20 Token Standardに準拠した関数
552      *
553      * spender（支払い元のアドレス）にsender（送信者）がamount分だけ支払うのを許可する
554      * この関数が呼ばれる度に送金可能な金額を更新する。
555      *
556      * @param sender {address} - 許可操作を実行するユーザのアドレス
557      * @param spender (address} - 送付操作を許可する対象ユーザのアドレス
558      * @param amount {uint} - 送付を許可するコインの分量
559      * @return {bool} 許可に成功した場合は true を返す
560      */
561     function approve(address sender, address spender, uint amount) auth public returns (bool) {
562         coinStorage.setCoinAllowance(sender, spender, amount);
563         return true;
564     }
565 
566     /**
567      * ERC20 Token Standardに準拠した関数
568      *
569      * 指定したユーザに対し、送付操作が許可されているトークンの分量を返す
570      *
571      * @param owner {address} - 資金源となるユーザのアドレス
572      * @param spender {address} - 送付操作を許可しているユーザのアドレス
573      * @return {uint} 許可されているトークンの分量を返す
574      */
575     function allowance(address owner, address spender) auth public constant returns (uint) {
576         return coinStorage.coinAllowanceOf(owner, spender);
577     }
578 
579     /**
580      * トークンストレージ (このトークンに限り有効なストレージ) を設定する <Ownerのみ実行可能>
581      * @param addr {address} - DrivezyPrivateCoinStorage のアドレス
582      * @return {bool} Storage の設定に成功したら true を返す
583      */
584     function setStorage(address addr) auth public returns (bool) {
585         coinStorage = DrivezyPrivateCoinStorage(addr);
586         SetStorage(msg.sender, addr);
587         return true;
588     }
589 
590     /**
591      * 共有ストレージ (一連の発行において共通利用するストレージ) を設定する <Ownerのみ実行可能>
592      * @param addr {address} - DrivezyPrivateCoinSharedStorage のアドレス
593      * @return {bool} Storage の設定に成功したら true を返す
594      */
595     function setSharedStorage(address addr) auth public returns (bool) {
596         sharedStorage = DrivezyPrivateCoinSharedStorage(addr);
597         SetSharedStorage(msg.sender, addr);
598         return true;
599     }
600 
601     /**
602      * Coin (ERC20 準拠の公開するコントラクト) を設定する <Ownerのみ実行可能>
603      * @param addr {address} - DrivezyPrivateCoin のアドレス
604      * @return {bool} Coin の設定に成功したら true を返す
605      */
606     function setCoin(address addr) auth public returns (bool) {
607         coin = DrivezyPrivateCoin(addr);
608         SetCoin(msg.sender, addr);
609         return true;
610     }
611 
612     /**
613      * 指定したアドレスにコインを発行する <Ownerのみ実行可能>
614      * @param receiver {address} - 発行したコインの受取アカウント
615      * @param amount {uint} - 発行量
616      * @return {bool} 発行に成功したら true を返す
617      */
618     function mint(address receiver, uint amount) auth public returns (bool) {
619         // 1円以上発行しようとしているか確認
620         require(amount > 0);
621 
622         // 発行残高を増やす
623         coinStorage.setTotalSupply(safeAdd(coinStorage.totalSupply(), amount));
624 
625         // 自分自身に発行する
626         // 発行に先立ち、自分がトークンを持てるようにする
627         addApprovedAddress(address(this));
628         coinStorage.setCoinBalance(address(this), safeAdd(coinStorage.coinBalanceOf(address(this)), amount));
629 
630         // 自分自身から相手に送付する
631         require(coin.transfer(receiver, amount));
632 
633         // ログに保存
634         Mint(msg.sender, receiver, amount);
635 
636         return true;
637     }
638 
639     /**
640      * 指定したアドレスからコインを回収する <Ownerのみ実行可能>
641      * @param receiver {address} - 回収先のアカウント
642      * @param amount {uint} - 回収量
643      * @return {bool} 回収に成功したら true を返す
644      */
645     function burn(address receiver, uint amount) auth public returns (bool) {
646         // 1円以上回収しようとしているか確認
647         require(amount > 0);
648 
649         // 回収先のアカウントの所持金額以下を回収しようとしているか確認
650         require(coinStorage.coinBalanceOf(receiver) >= amount);
651 
652         // 回収する残量の approve を強制的に設定する
653         // 回収に先立ち、自分がトークンを持てるようにする
654         approve(address(this), receiver, amount);
655         addApprovedAddress(address(this));
656 
657         // 自分自身のコントラクトに回収する
658         require(coin.transferFrom(receiver, address(this), amount));
659 
660         // 回収後、コインを溶かす
661         coinStorage.setTotalSupply(safeSub(coinStorage.totalSupply(), amount));
662         coinStorage.setCoinBalance(address(this), safeSub(coinStorage.coinBalanceOf(address(this)), amount));
663 
664         // ログに保存
665         Burn(msg.sender, receiver, amount);
666 
667         return true;
668     }
669 
670     /**
671      * 指定したアドレスをホワイトリストに追加 <Ownerのみ実行可能>
672      * @param addr {address} - 追加するアカウント
673      * @return {bool} 追加に成功したら true を返す
674      */
675     function addApprovedAddress(address addr) auth public returns (bool) {
676         sharedStorage.addApprovedAddress(addr);
677         AddApprovedAddress(msg.sender, addr);
678         return true;
679     }
680 
681     /**
682      * 指定したアドレスをホワイトリストから削除 <Ownerのみ実行可能>
683      * @param addr {address} - 削除するアカウント
684      * @return {bool} 削除に成功したら true を返す
685      */
686     function removeApprovedAddress(address addr) auth public returns (bool) {
687         sharedStorage.removeApprovedAddress(addr);
688         RemoveApprovedAddress(msg.sender, addr);
689         return true;
690     }
691 
692     /**
693      * ユーザ間の送金を許可する <Ownerのみ実行可能>
694      * @return {bool} 許可に成功したら true を返す
695      */
696     function allowTransferBetweenUsers() auth public returns (bool) {
697         coinStorage.allowTransferBetweenUsers();
698         return true;
699     }
700 
701     /**
702      * ユーザ間の送金を禁止する <Ownerのみ実行可能>
703      * @return {bool} 禁止に成功したら true を返す
704      */
705     function disallowTransferBetweenUsers() auth public returns (bool) {
706         coinStorage.disallowTransferBetweenUsers();
707         return true;
708     }
709 
710     /**
711      * DSAuth の canCall(src, dst, sig) の override
712      * シグネチャと実行者レベルで関数の実行可否を返す
713      #
714      * @param src {address} - 呼び出し元ユーザのアドレス
715      * @param dst {address} - 実行先コントラクトのアドレス
716      * @param sig {bytes4} - 関数のシグネチャ (SHA3)
717      * @return {bool} 関数が実行可能であれば true を返す
718      */
719     function canCall(address src, address dst, bytes4 sig) public constant returns (bool) {
720         dst; // HACK - 引数を使わないとコンパイラが警告を出す
721         sig; // HACK - こちらも同様
722 
723         // オーナーによる実行、「信用するコントラクト」からの呼び出し、コインからの呼び出しは許可
724         return src == owner || sharedStorage.isOwnerAddress(src) || sharedStorage.isTrustedContractAddress(src) || src == address(coin);
725     }
726 
727     /**
728      * 指定したユーザ間での転送が承認されるかどうか
729      * - 受取者が approvedAddress か ownerAddress に属する
730      * - coinStorage.canTransferBetweenUsers = false の場合、受取者か送信者のいずれかが ownerAddress または trustedContractAddress に属する
731      * @param from {address} - 送付者のアドレス
732      * @param to {address} - 受取者のアドレス
733      * @return {bool} 転送できる場合は true を返す
734      */
735     function canTransfer(address from, address to) internal constant returns (bool) {
736         // 受取者がオーナーまたは許可された (KYC 通過済み) アドレスかを確認
737         require(sharedStorage.isOwnerAddress(to) || sharedStorage.isApprovedAddress(to));
738 
739         // ユーザ間の送金が許可されているか、そうでない場合は送り手または受け手が「オーナー」あるいは「信頼できるコントラクト」に入っているか。
740         require(coinStorage.canTransferBetweenUsers() || sharedStorage.isOwnerAddress(from) || sharedStorage.isTrustedContractAddress(from) || sharedStorage.isOwnerAddress(to) || sharedStorage.isTrustedContractAddress(to));
741 
742         return true;
743     }
744 
745     /**
746      * DSAuth の isAuthorized(src, sig) の override
747      * @param src {address} - コントラクトの実行者
748      * @param sig {bytes4} - コントラクトのシグネチャの SHA3 値
749      * @return {bool} 呼び出し可能な関数の場合は true を返す
750      */
751     function isAuthorized(address src, bytes4 sig) internal constant returns (bool) {
752         return canCall(src, address(this), sig);
753     }
754 
755     /**
756      * 指定されたアドレスがコントラクトであるか判定する
757      * @param addr {address} - 判定対象のコントラクト
758      * @return {bool} コントラクトであれば true
759      */
760     function isContract(address addr) public view returns (bool result) {
761         uint length;
762         assembly {
763             // アドレスが持つマシン語のサイズを取得する
764             length := extcodesize(addr)
765         }
766 
767         // 当該アドレスがマシン語を持てばコントラクトと見做せる
768         return (length > 0);
769     }
770 
771     /**
772      * DrivezyPrivateCoinAcceptableContract#isDrivezyPrivateTokenAcceptable の override
773      * このコントラクトは Private Token を受け取らない
774      * @return {bool} 常に false を返す
775      */
776     function isDrivezyPrivateTokenAcceptable() public pure returns (bool result) {
777         return false;
778     }
779 }
780 
781 
782 /**
783  * ERC20 に準拠したコインの公開インタフェース
784  */
785 contract DrivezyPrivateCoin is ERC20, DSAuth {
786     /**
787      * public variables - Etherscan などに表示される
788      */
789     
790     /* コインの名前 */
791     string public name = "Uni 0.1.0";
792 
793     /* コインのシンボル */
794     string public symbol = "ORI";
795 
796     /* 通貨の最小単位の桁数。 6 の場合は小数第6位が最小単位となる (0.000001 ORI) */
797     uint8 public decimals = 6;
798 
799     /**
800      * custom events
801      */
802 
803     /* Implementation を設定したときに発生するイベント
804      * {address} senderAddress - 実行者のアドレス
805      * {address} contractAddress - 設定した implementation のコントラクトアドレス
806      */
807     event SetImplementation(address indexed senderAddress, address indexed contractAddress);
808 
809     /**
810      * private variables
811      */
812 
813     // トークンのロジック実装インスタンス
814     DrivezyPrivateCoinImplementation public implementation;
815 
816     // ----------------------------------------------------------------------------------------------------
817     // ERC20 Token Standard functions
818     // ----------------------------------------------------------------------------------------------------
819 
820     /**
821      * 総発行高を返す
822      * @return {uint} コインの総発行高
823      */
824     function totalSupply() public constant returns (uint) {
825         return implementation.totalSupply();
826     }
827 
828     /**
829      * 指定したアドレスが保有するコインの残高を返す
830      * @param addr {address} - コインの残高を調べたいアドレス
831      * @return {uint} コインの残高
832      */
833     function balanceOf(address addr) public constant returns (uint) {
834         return implementation.balanceOf(addr);
835     }
836 
837     /**
838      * 自分が保有するコインを指定したアドレスに送金する
839      * @param to {address} - 宛先のアドレス
840      * @param amount {uint} - 送付するコインの分量
841      * @return {bool} 送付に成功した場合は true を返す
842      */
843     function transfer(address to, uint amount) public returns (bool) {
844         if (implementation.transfer(msg.sender, to, amount)) {
845             Transfer(msg.sender, to, amount);
846             return true;
847         } else {
848             return false;
849         }
850     }
851 
852     /**
853      * 指定したユーザが保有するコインを指定したアドレスに送金する
854      * @param from {address} - 資金源となるユーザのアドレス
855      * @param to {address} - 宛先のアドレス
856      * @param amount {uint} - 送付するコインの分量
857      * @return {bool} 送付に成功した場合は true を返す
858      */
859     function transferFrom(address from, address to, uint amount) public returns (bool) {
860         if (implementation.transferFrom(msg.sender, from, to, amount)) {
861             Transfer(from, to, amount);
862             return true;
863         } else {
864             return false;
865         }
866     }
867 
868     /**
869      * 指定したユーザに対し、(トークン所有者に代わって)指定した分量のトークンの送付を許可する
870      * @param spender {address} - 送付操作を許可する対象ユーザのアドレス
871      * @param amount {uint} - 送付を許可するコインの分量
872      * @return {bool} 許可に成功した場合は true を返す
873      */
874     function approve(address spender, uint amount) public returns (bool) {
875         if (implementation.approve(msg.sender, spender, amount)) {
876             Approval(msg.sender, spender, amount);
877             return true;
878         } else {
879             return false;
880         }
881     }
882 
883     /**
884      * 指定したユーザに対し、送付操作が許可されているトークンの分量を返す
885      * @param addr {address} - 資金源となるユーザのアドレス
886      * @param spender {uint} - 送付操作を許可しているユーザのアドレス
887      * @return {uint} 許可されているトークンの分量を返す
888      */
889     function allowance(address addr, address spender) public constant returns (uint) {
890         return implementation.allowance(addr, spender);
891     }
892 
893     /**
894      * implementation (実装) が定義されたコントラクトを設定する <Ownerのみ実行可能>
895      * @param addr {address} - コントラクトのアドレス
896      * @return {bool} 設定変更に成功した場合は true を返す
897      */
898     function setImplementation(address addr) auth public returns (bool) {
899         implementation = DrivezyPrivateCoinImplementation(addr);
900         SetImplementation(msg.sender, addr);
901         return true;
902     }
903 
904     /**
905      * DSAuth の isAuthorized(src, sig) の override
906      * @param src {address} - コントラクトの実行者
907      * @param sig {bytes4} - コントラクトのシグネチャの SHA3 値
908      * @return {bool} 呼び出し可能な関数の場合は true を返す
909      */
910     function isAuthorized(address src, bytes4 sig) internal constant returns (bool) {
911         return src == address(this) ||  // コントラクト自身による呼び出す
912             src == owner ||             // コントラクトのデプロイ者
913                                         // implementation が定義済みである場合は、Implementation#canCall に呼び出し可否チェックを委譲
914             (implementation != DrivezyPrivateCoinImplementation(0) && implementation.canCall(src, address(this), sig));
915     }
916 }
917 
918 
919 /**
920  * ERC20 に準拠したコインの公開インタフェース
921  */
922 contract DrivezyPrivateDecemberCoin is DrivezyPrivateCoin {
923     /**
924      * public variables - Etherscan などに表示される
925      */
926     
927     /* コインの名前 */
928     string public name = "Rental Coins 1.0 1st private offering";
929 
930     /* コインのシンボル */
931     string public symbol = "RC1";
932 
933     /* 通貨の最小単位の桁数。 6 の場合は小数第6位が最小単位となる (0.000001 RC1) */
934     uint8 public decimals = 6;
935 
936 }