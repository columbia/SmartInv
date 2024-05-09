1 pragma solidity ^0.4.18;
2 
3 contract Blockeds {
4   mapping (address => bool) blocked;
5 
6   event Blocked(address _addr);
7   event Unblocked(address _addr);
8 
9   function blockAddress(address _addr) public {
10     require(!blocked[_addr]);
11     blocked[_addr] = true;
12 
13     Blocked(_addr);
14   }
15 
16   function unblockAddress(address _addr) public {
17     require(blocked[_addr]);
18     blocked[_addr] = false;
19 
20     Unblocked(_addr);
21   }
22 }
23 
24 /*
25     저작권 2016, Jordi Baylina
26 
27     이 프로그램은 무료 소프트웨어입니다.
28     이 프로그램은 Free Soft ware Foundation에서
29     게시하는 GNU General Public License의
30     조건에 따라 라이센스의 버전 3또는(선택 사항으로)
31     이후 버전으로 재배포 및 또는 수정할 수 있습니다.
32 
33     이 프로그램은 유용할 것을 기대하여 배포되지만,
34     상품성이나 특정 목적에 대한 적합성의 묵시적
35     보증도 없이 모든 보증 없이 제공됩니다.
36     자세한 내용은 GNU General Public License를 참조하십시오.
37 
38     이 프로그램과 함께 GNU General Public License 사본을 받아야합니다.
39     그렇지 않으면, 참조 : <http://www.gnu.org/licenses/>
40  */
41 
42 /*
43  * @title MiniMeToken
44  * @author Jordi Baylina
45  * @dev 이 토큰 계약의 목표는 이 토큰을 손쉽게 복제하는 것입니다.
46  *      토큰을 사용하면 지정된 블록에서 DAO 및 DApps가 원래 토큰에 영향을 주지 않고 기능을 분산된 방식으로 업그레이드할 수 있습니다.
47  * @dev ERC20과 호환되지만 추가 테스트를 진행해야합니다.
48 */
49 contract Controlled {
50     // 컨트롤러의 주소는 이 수정 프로그램으로 함수를 호출할 수 있는 유일한 주소입니다.
51     modifier onlyController { require(msg.sender == controller); _; }
52 
53     address public controller;
54 
55     function Controlled() public { controller = msg.sender;}
56 
57     //                계약 당사자
58     // _newController 새로운 계약자
59     function changeController(address _newController) public onlyController {
60         controller = _newController;
61     }
62 }
63 
64 
65 
66 // 토큰 컨트롤러 계약에서 이러한 기능을 구현해야 합니다.
67 contract TokenController {
68     // @notice `_owner`가 이더리움을 MiniMeToken 계약에 보낼 때 호출됩니다.
69     // @param   _owner 토큰을 생성하기 위해 이더리움을 보낸 주소
70     // @return         이더리움이 정상 전송되는 경우는 true, 아닌 경우는 false
71     function proxyPayment(address _owner) public payable returns(bool);
72 
73     // @notice         컨트롤러에 토큰 전송에 대해 알립니다.
74     //                 원하는 경우 반응하는 컨트롤러
75     // @param _from    전송의 출처
76     // @param _to      전송 목적지
77     // @param _amount  전송 금액
78     // @return         컨트롤러가 전송을 승인하지 않는 경우 거짓
79     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
80 
81     // @notice                     컨트롤러에 승인 사실을 알리고, 필요한 경우 컨트롤러가 대응하도록 합니다.
82     // @param _owner `approve ()`  를 호출하는 주소.
83     // @param _spender `approve()` 호출하는 전송자
84     // @param _amount `approve ()` 호출의 양
85     // @return                     컨트롤러가 승인을 허가하지 않는 경우 거짓
86     function onApprove(address _owner, address _spender, uint _amount) public
87         returns(bool);
88 }
89 
90 contract ApproveAndCallFallBack {
91     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
92 }
93 
94 // 실제 토큰 계약인 기본 컨트롤러는 계약서를 배포하는 msg.sender이므로
95 // 이 토큰은 대개 토큰 컨트롤러 계약에 의해 배포되며,
96 // Giveth는 "Campaign"을 호출합니다.
97 contract MiniMeToken is Controlled {
98     string public name;                // 토큰 이름 : EX DigixDAO token
99     uint8 public decimals;             // 최소 단위의 소수 자릿수
100     string public symbol;              // 식별자 EX : e.g. REP
101     string public version = 'MMT_0.2'; // 버전 관리 방식
102 
103 
104     // @dev `Checkpoint` 블록 번호를 지정된 값에 연결하는 구조이며,
105     //                    첨부된 블록 번호는 마지막으로 값을 변경한 번호입니다.
106     struct  Checkpoint {
107 
108         // `fromBlock` 값이 생성된 블록 번호입니다.
109         uint128 fromBlock;
110 
111         // `value` 특정 블록 번호의 토큰 양입니다.
112         uint128 value;
113     }
114 
115     // `parentToken` 이 토큰을 생성하기 위해 복제 된 토큰 주소입니다.
116     //               복제되지 않은 토큰의 경우 0x0이 됩니다.
117     MiniMeToken public parentToken;
118 
119     // `parentSnapShotBlock` 상위 토큰의 블록 번호로,
120     //                       복제 토큰의 초기 배포를 결정하는 데 사용됨
121     uint public parentSnapShotBlock;
122 
123     // `creationBlock` 복제 토큰이 생성된 블록 번호입니다.
124     uint public creationBlock;
125 
126     // `balances` 이 계약에서 잔액이 변경될 때 변경 사항이 발생한
127     //            블록 번호도 맵에 포함되어 있으며 각 주소의 잔액을 추적하는 맵입니다.
128     mapping (address => Checkpoint[]) balances;
129 
130     // `allowed` 모든 ERC20 토큰에서와 같이 추가 전송 권한을 추적합니다.
131     mapping (address => mapping (address => uint256)) allowed;
132 
133     // 토큰의 `totalSupply` 기록을 추적합니다.
134     Checkpoint[] totalSupplyHistory;
135 
136     // 토큰이 전송 가능한지 여부를 결정하는 플래그 입니다.
137     bool public transfersEnabled;
138 
139     // 새 복제 토큰을 만드는 데 사용 된 팩토리
140     MiniMeTokenFactory public tokenFactory;
141 
142     /*
143      * 건설자
144      */
145     // @notice MiniMeToken을 생성하는 생성자
146     // @param _tokenFactory MiniMeTokenFactory 계약의 주소
147     //                               복제 토큰 계약을 생성하는 MiniMeTokenFactory 계약의 주소,
148     //                               먼저 토큰 팩토리를 배포해야합니다.
149     // @param _parentToken           상위 토큰의 ParentTokerut 주소 (새 토큰인 경우 0x0으로 설정됨)
150     // @param _parentSnapShotBlock   복제 토큰의 초기 배포를 결정할 상위 토큰의 블록(새 토큰인 경우 0으로 설정됨)
151     // @param _tokenName             새 토큰의 이름
152     // @param _decimalUnits          새 토큰의 소수 자릿수
153     // @param _tokenSymbol           새 토큰에 대한 토큰 기호
154     // @param _transfersEnabled true 이면 토큰을 전송할 수 있습니다.
155     function MiniMeToken(
156         address _tokenFactory,
157         address _parentToken,
158         uint _parentSnapShotBlock,
159         string _tokenName,
160         uint8 _decimalUnits,
161         string _tokenSymbol,
162         bool _transfersEnabled
163     ) public {
164         tokenFactory = MiniMeTokenFactory(_tokenFactory);
165         name = _tokenName;                                 // 이름 설정
166         decimals = _decimalUnits;                          // 십진수 설정
167         symbol = _tokenSymbol;                             // 기호 설정 (심볼)
168         parentToken = MiniMeToken(_parentToken);
169         parentSnapShotBlock = _parentSnapShotBlock;
170         transfersEnabled = _transfersEnabled;
171         creationBlock = block.number;
172     }
173 
174     function transfer(address _to, uint256 _amount) public returns (bool success) {
175         require(transfersEnabled);
176         doTransfer(msg.sender, _to, _amount);
177         return true;
178     }
179 
180     function transferFrom(address _from, address _to, uint256 _amount
181     ) public returns (bool success) {
182         if (msg.sender != controller) {
183             require(transfersEnabled);
184 
185             require(allowed[_from][msg.sender] >= _amount);
186             allowed[_from][msg.sender] -= _amount;
187         }
188         doTransfer(_from, _to, _amount);
189         return true;
190     }
191 
192     function doTransfer(address _from, address _to, uint _amount
193     ) internal {
194 
195            if (_amount == 0) {
196                Transfer(_from, _to, _amount);
197                return;
198            }
199 
200            require(parentSnapShotBlock < block.number);
201 
202            require((_to != 0) && (_to != address(this)));
203 
204            var previousBalanceFrom = balanceOfAt(_from, block.number);
205 
206            require(previousBalanceFrom >= _amount);
207 
208            if (isContract(controller)) {
209                require(TokenController(controller).onTransfer(_from, _to, _amount));
210            }
211 
212            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
213 
214            var previousBalanceTo = balanceOfAt(_to, block.number);
215            require(previousBalanceTo + _amount >= previousBalanceTo);
216            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
217 
218            Transfer(_from, _to, _amount);
219 
220     }
221 
222     function balanceOf(address _owner) public constant returns (uint256 balance) {
223         return balanceOfAt(_owner, block.number);
224     }
225 
226     function approve(address _spender, uint256 _amount) public returns (bool success) {
227         require(transfersEnabled);
228 
229         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
230 
231         // 승인 기능 호출의 토큰 컨트롤러에 알림
232         if (isContract(controller)) {
233             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
234         }
235 
236         allowed[msg.sender][_spender] = _amount;
237         Approval(msg.sender, _spender, _amount);
238         return true;
239     }
240 
241     function allowance(address _owner, address _spender
242     ) public constant returns (uint256 remaining) {
243         return allowed[_owner][_spender];
244     }
245 
246     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
247     ) public returns (bool success) {
248         require(approve(_spender, _amount));
249 
250         ApproveAndCallFallBack(_spender).receiveApproval(
251             msg.sender,
252             _amount,
253             this,
254             _extraData
255         );
256 
257         return true;
258     }
259 
260     function totalSupply() public constant returns (uint) {
261         return totalSupplyAt(block.number);
262     }
263 
264     /*
265      * 히스토리 내 쿼리 균형 및 총 공급
266      */
267     function balanceOfAt(address _owner, uint _blockNumber) public constant
268         returns (uint) {
269 
270         if ((balances[_owner].length == 0)
271             || (balances[_owner][0].fromBlock > _blockNumber)) {
272             if (address(parentToken) != 0) {
273                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
274             } else {
275                 // 상위토큰이 없다.
276                 return 0;
277             }
278         } else {
279             return getValueAt(balances[_owner], _blockNumber);
280         }
281     }
282 
283     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
284         if ((totalSupplyHistory.length == 0)
285             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
286             if (address(parentToken) != 0) {
287                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
288             } else {
289                 return 0;
290             }
291         } else {
292             return getValueAt(totalSupplyHistory, _blockNumber);
293         }
294     }
295 
296     /*
297      * 토큰 복제 방법
298      */
299     function createCloneToken(
300         string _cloneTokenName,
301         uint8 _cloneDecimalUnits,
302         string _cloneTokenSymbol,
303         uint _snapshotBlock,
304         bool _transfersEnabled
305         ) public returns(address) {
306         if (_snapshotBlock == 0) _snapshotBlock = block.number;
307         MiniMeToken cloneToken = tokenFactory.createCloneToken(
308             this,
309             _snapshotBlock,
310             _cloneTokenName,
311             _cloneDecimalUnits,
312             _cloneTokenSymbol,
313             _transfersEnabled
314             );
315 
316         cloneToken.changeController(msg.sender);
317 
318         NewCloneToken(address(cloneToken), _snapshotBlock);
319         return address(cloneToken);
320     }
321 
322     /*
323      * 토큰 생성 및 소각
324      */
325     function generateTokens(address _owner, uint _amount
326     ) public onlyController returns (bool) {
327         uint curTotalSupply = totalSupply();
328         require(curTotalSupply + _amount >= curTotalSupply);
329         uint previousBalanceTo = balanceOf(_owner);
330         require(previousBalanceTo + _amount >= previousBalanceTo);
331         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
332         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
333         Transfer(0, _owner, _amount);
334         return true;
335     }
336 
337     function destroyTokens(address _owner, uint _amount
338     ) onlyController public returns (bool) {
339         uint curTotalSupply = totalSupply();
340         require(curTotalSupply >= _amount);
341         uint previousBalanceFrom = balanceOf(_owner);
342         require(previousBalanceFrom >= _amount);
343         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
344         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
345         Transfer(_owner, 0, _amount);
346         return true;
347     }
348 
349     /*
350      * 토큰 전송 사용
351      */
352     function enableTransfers(bool _transfersEnabled) public onlyController {
353         transfersEnabled = _transfersEnabled;
354     }
355 
356     /*
357      * 스냅 샷 배열에서 값을 쿼리하고 설정하는 내부 도우미 함수
358      */
359     function getValueAt(Checkpoint[] storage checkpoints, uint _block
360     ) constant internal returns (uint) {
361         if (checkpoints.length == 0) return 0;
362 
363         // 실제 값 바로 가기
364         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
365             return checkpoints[checkpoints.length-1].value;
366         if (_block < checkpoints[0].fromBlock) return 0;
367 
368         // 배열의 값을 2진 검색
369         uint min = 0;
370         uint max = checkpoints.length-1;
371         while (max > min) {
372             uint mid = (max + min + 1)/ 2;
373             if (checkpoints[mid].fromBlock<=_block) {
374                 min = mid;
375             } else {
376                 max = mid-1;
377             }
378         }
379         return checkpoints[min].value;
380     }
381 
382     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
383     ) internal  {
384         if ((checkpoints.length == 0)
385         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
386                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
387                newCheckPoint.fromBlock =  uint128(block.number);
388                newCheckPoint.value = uint128(_value);
389            } else {
390                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
391                oldCheckPoint.value = uint128(_value);
392            }
393     }
394 
395     function isContract(address _addr) constant internal returns(bool) {
396         uint size;
397         if (_addr == 0) return false;
398         assembly {
399             size := extcodesize(_addr)
400         }
401         return size>0;
402     }
403 
404     function min(uint a, uint b) pure internal returns (uint) {
405         return a < b ? a : b;
406     }
407 
408     function () public payable {
409         require(isContract(controller));
410         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
411     }
412 
413     /*
414      * 안전 방법
415      */
416     function claimTokens(address _token) public onlyController {
417         if (_token == 0x0) {
418             controller.transfer(this.balance);
419             return;
420         }
421 
422         MiniMeToken token = MiniMeToken(_token);
423         uint balance = token.balanceOf(this);
424         token.transfer(controller, balance);
425         ClaimedTokens(_token, controller, balance);
426     }
427 
428     /*
429      * 이벤트
430      */
431     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
432     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
433     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
434     event Approval(
435         address indexed _owner,
436         address indexed _spender,
437         uint256 _amount
438         );
439 }
440 
441 /*
442  * MiniMeTokenFactory
443  */
444 // 이 계약은 계약에서 복제 계약을 생성하는 데 사용됩니다.
445 contract MiniMeTokenFactory {
446     //                      새로운 기능으로 새로운 토큰을 만들어 DApp를 업데이트하십시오.
447     //  msg.sender          는 이 복제 토큰의 컨트롤러가됩니다.
448     // _parentToken         복제 될 토큰의 주소
449     // _snapshotBlock       상위 토큰 블록
450     //                      복제 토큰의 초기 배포 결정
451     // _tokenName           새 토큰의 이름
452     // @param _decimalUnits 새 토큰의 소수 자릿수
453     // @param _tokenSymbol  새 토큰에 대한 토큰 기호
454     // @param _transfersEnabled true 이면 토큰을 전송할 수 있습니다.
455     // @return              새 토큰 계약의 주소
456     function createCloneToken(
457         address _parentToken,
458         uint _snapshotBlock,
459         string _tokenName,
460         uint8 _decimalUnits,
461         string _tokenSymbol,
462         bool _transfersEnabled
463     ) public returns (MiniMeToken) {
464         MiniMeToken newToken = new MiniMeToken(
465             this,
466             _parentToken,
467             _snapshotBlock,
468             _tokenName,
469             _decimalUnits,
470             _tokenSymbol,
471             _transfersEnabled
472             );
473 
474         newToken.changeController(msg.sender);
475         return newToken;
476     }
477 }
478 
479 /**
480  * @title LEN
481  * @dev LEN는 MiniMeToken을 상속받은 ERC20 토큰 계약입니다.
482  */
483 contract LEN is MiniMeToken, Blockeds {
484   bool public StorageEnabled = true;
485 
486   modifier onlyStorageEnabled() {
487     require(StorageEnabled);
488     _;
489   }
490 
491   modifier onlyNotBlocked(address _addr) {
492     require(!blocked[_addr]);
493     _;
494   }
495 
496   event StorageEnabled(bool _StorageEnabled);
497 
498   function LEN(address _tokenFactory) MiniMeToken(
499     _tokenFactory,
500     0x0,                  // 부모 토큰 없음
501     0,                    // 상위의 스냅 샷 블록 번호 없음
502     "Lending Token",      // 토큰 이름
503     18,                   // 십진법
504     "LEN",                // 상징(심볼)
505     false                 // 전송 사용
506   ) public {}
507 
508   function transfer(address _to, uint256 _amount) public onlyNotBlocked(msg.sender) returns (bool success) {
509     return super.transfer(_to, _amount);
510   }
511 
512   function transferFrom(address _from, address _to, uint256 _amount) public onlyNotBlocked(_from) returns (bool success) {
513     return super.transferFrom(_from, _to, _amount);
514   }
515 
516   // 아래의 4개 기능은 'Storagersabled(하위 설정됨)'로만 활성화됩니다.
517   // ALL : 3 개의 Storage 레벨
518   function generateTokens(address _owner, uint _amount) public onlyController onlyStorageEnabled returns (bool) {
519     return super.generateTokens(_owner, _amount);
520   }
521 
522   function destroyTokens(address _owner, uint _amount) public onlyController onlyStorageEnabled returns (bool) {
523     return super.destroyTokens(_owner, _amount);
524   }
525 
526   function blockAddress(address _addr) public onlyController onlyStorageEnabled {
527     super.blockAddress(_addr);
528   }
529 
530   function unblockAddress(address _addr) public onlyController onlyStorageEnabled {
531     super.unblockAddress(_addr);
532   }
533 
534   function enableStorage(bool _StorageEnabled) public onlyController {
535     StorageEnabled = _StorageEnabled;
536     StorageEnabled(_StorageEnabled);
537   }
538 
539   // byList 함수
540   function generateTokensByList(address[] _owners, uint[] _amounts) public onlyController onlyStorageEnabled returns (bool) {
541     require(_owners.length == _amounts.length);
542 
543     for(uint i = 0; i < _owners.length; i++) {
544       generateTokens(_owners[i], _amounts[i]);
545     }
546 
547     return true;
548   }
549 }