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
103     // @dev `Checkpoint` 블록 번호를 지정된 값에 연결하는 구조이며,
104     //                    첨부된 블록 번호는 마지막으로 값을 변경한 번호입니다.
105     struct  Checkpoint {
106 
107         // `fromBlock` 값이 생성된 블록 번호입니다.
108         uint128 fromBlock;
109 
110         // `value` 특정 블록 번호의 토큰 양입니다.
111         uint128 value;
112     }
113 
114     // `parentToken` 이 토큰을 생성하기 위해 복제 된 토큰 주소입니다.
115     //               복제되지 않은 토큰의 경우 0x0이 됩니다.
116     MiniMeToken public parentToken;
117 
118     // `parentSnapShotBlock` 상위 토큰의 블록 번호로,
119     //                       복제 토큰의 초기 배포를 결정하는 데 사용됨
120     uint public parentSnapShotBlock;
121 
122     // `creationBlock` 복제 토큰이 생성된 블록 번호입니다.
123     uint public creationBlock;
124 
125     // `balances` 이 계약에서 잔액이 변경될 때 변경 사항이 발생한
126     //            블록 번호도 맵에 포함되어 있으며 각 주소의 잔액을 추적하는 맵입니다.
127     mapping (address => Checkpoint[]) balances;
128 
129     // `allowed` 모든 ERC20 토큰에서와 같이 추가 전송 권한을 추적합니다.
130     mapping (address => mapping (address => uint256)) allowed;
131 
132     // 토큰의 `totalSupply` 기록을 추적합니다.
133     Checkpoint[] totalSupplyHistory;
134 
135     // 토큰이 전송 가능한지 여부를 결정하는 플래그 입니다.
136     bool public transfersEnabled;
137 
138     // 새 복제 토큰을 만드는 데 사용 된 팩토리
139     MiniMeTokenFactory public tokenFactory;
140 
141     /*
142      * 건설자
143      */
144     // @notice MiniMeToken을 생성하는 생성자
145     // @param _tokenFactory MiniMeTokenFactory 계약의 주소
146     //                               복제 토큰 계약을 생성하는 MiniMeTokenFactory 계약의 주소,
147     //                               먼저 토큰 팩토리를 배포해야합니다.
148     // @param _parentToken           상위 토큰의 ParentTokerut 주소 (새 토큰인 경우 0x0으로 설정됨)
149     // @param _parentSnapShotBlock   복제 토큰의 초기 배포를 결정할 상위 토큰의 블록(새 토큰인 경우 0으로 설정됨)
150     // @param _tokenName             새 토큰의 이름
151     // @param _decimalUnits          새 토큰의 소수 자릿수
152     // @param _tokenSymbol           새 토큰에 대한 토큰 기호
153     // @param _transfersEnabled true 이면 토큰을 전송할 수 있습니다.
154     function MiniMeToken(
155         address _tokenFactory,
156         address _parentToken,
157         uint _parentSnapShotBlock,
158         string _tokenName,
159         uint8 _decimalUnits,
160         string _tokenSymbol,
161         bool _transfersEnabled
162     ) public {
163         tokenFactory = MiniMeTokenFactory(_tokenFactory);
164         name = _tokenName;                                 // 이름 설정
165         decimals = _decimalUnits;                          // 십진수 설정
166         symbol = _tokenSymbol;                             // 기호 설정 (심볼)
167         parentToken = MiniMeToken(_parentToken);
168         parentSnapShotBlock = _parentSnapShotBlock;
169         transfersEnabled = _transfersEnabled;
170         creationBlock = block.number;
171     }
172 
173     function transfer(address _to, uint256 _amount) public returns (bool success) {
174         require(transfersEnabled);
175         doTransfer(msg.sender, _to, _amount);
176         return true;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _amount
180     ) public returns (bool success) {
181         if (msg.sender != controller) {
182             require(transfersEnabled);
183 
184             require(allowed[_from][msg.sender] >= _amount);
185             allowed[_from][msg.sender] -= _amount;
186         }
187         doTransfer(_from, _to, _amount);
188         return true;
189     }
190 
191     function doTransfer(address _from, address _to, uint _amount
192     ) internal {
193 
194            if (_amount == 0) {
195                Transfer(_from, _to, _amount);
196                return;
197            }
198 
199            require(parentSnapShotBlock < block.number);
200 
201            require((_to != 0) && (_to != address(this)));
202 
203            var previousBalanceFrom = balanceOfAt(_from, block.number);
204 
205            require(previousBalanceFrom >= _amount);
206 
207            if (isContract(controller)) {
208                require(TokenController(controller).onTransfer(_from, _to, _amount));
209            }
210 
211            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
212 
213            var previousBalanceTo = balanceOfAt(_to, block.number);
214            require(previousBalanceTo + _amount >= previousBalanceTo);
215            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
216 
217            Transfer(_from, _to, _amount);
218 
219     }
220 
221     function balanceOf(address _owner) public constant returns (uint256 balance) {
222         return balanceOfAt(_owner, block.number);
223     }
224 
225     function approve(address _spender, uint256 _amount) public returns (bool success) {
226         require(transfersEnabled);
227 
228         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
229 
230         // 승인 기능 호출의 토큰 컨트롤러에 알림
231         if (isContract(controller)) {
232             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
233         }
234 
235         allowed[msg.sender][_spender] = _amount;
236         Approval(msg.sender, _spender, _amount);
237         return true;
238     }
239 
240     function allowance(address _owner, address _spender
241     ) public constant returns (uint256 remaining) {
242         return allowed[_owner][_spender];
243     }
244 
245     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
246     ) public returns (bool success) {
247         require(approve(_spender, _amount));
248 
249         ApproveAndCallFallBack(_spender).receiveApproval(
250             msg.sender,
251             _amount,
252             this,
253             _extraData
254         );
255 
256         return true;
257     }
258 
259     function totalSupply() public constant returns (uint) {
260         return totalSupplyAt(block.number);
261     }
262 
263     /*
264      * 히스토리 내 쿼리 균형 및 총 공급
265      */
266     function balanceOfAt(address _owner, uint _blockNumber) public constant
267         returns (uint) {
268 
269         if ((balances[_owner].length == 0)
270             || (balances[_owner][0].fromBlock > _blockNumber)) {
271             if (address(parentToken) != 0) {
272                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
273             } else {
274                 // 상위토큰이 없다.
275                 return 0;
276             }
277         } else {
278             return getValueAt(balances[_owner], _blockNumber);
279         }
280     }
281 
282     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
283         if ((totalSupplyHistory.length == 0)
284             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
285             if (address(parentToken) != 0) {
286                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
287             } else {
288                 return 0;
289             }
290         } else {
291             return getValueAt(totalSupplyHistory, _blockNumber);
292         }
293     }
294 
295     /*
296      * 토큰 복제 방법
297      */
298     function createCloneToken(
299         string _cloneTokenName,
300         uint8 _cloneDecimalUnits,
301         string _cloneTokenSymbol,
302         uint _snapshotBlock,
303         bool _transfersEnabled
304         ) public returns(address) {
305         if (_snapshotBlock == 0) _snapshotBlock = block.number;
306         MiniMeToken cloneToken = tokenFactory.createCloneToken(
307             this,
308             _snapshotBlock,
309             _cloneTokenName,
310             _cloneDecimalUnits,
311             _cloneTokenSymbol,
312             _transfersEnabled
313             );
314 
315         cloneToken.changeController(msg.sender);
316 
317         NewCloneToken(address(cloneToken), _snapshotBlock);
318         return address(cloneToken);
319     }
320 
321     /*
322      * 토큰 생성 및 소각
323      */
324     function generateTokens(address _owner, uint _amount
325     ) public onlyController returns (bool) {
326         uint curTotalSupply = totalSupply();
327         require(curTotalSupply + _amount >= curTotalSupply);
328         uint previousBalanceTo = balanceOf(_owner);
329         require(previousBalanceTo + _amount >= previousBalanceTo);
330         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
331         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
332         Transfer(0, _owner, _amount);
333         return true;
334     }
335 
336     function destroyTokens(address _owner, uint _amount
337     ) onlyController public returns (bool) {
338         uint curTotalSupply = totalSupply();
339         require(curTotalSupply >= _amount);
340         uint previousBalanceFrom = balanceOf(_owner);
341         require(previousBalanceFrom >= _amount);
342         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
343         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
344         Transfer(_owner, 0, _amount);
345         return true;
346     }
347 
348     /*
349      * 토큰 전송 사용
350      */
351     function enableTransfers(bool _transfersEnabled) public onlyController {
352         transfersEnabled = _transfersEnabled;
353     }
354 
355     /*
356      * 스냅 샷 배열에서 값을 쿼리하고 설정하는 내부 도우미 함수
357      */
358     function getValueAt(Checkpoint[] storage checkpoints, uint _block
359     ) constant internal returns (uint) {
360         if (checkpoints.length == 0) return 0;
361 
362         // 실제 값 바로 가기
363         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
364             return checkpoints[checkpoints.length-1].value;
365         if (_block < checkpoints[0].fromBlock) return 0;
366 
367         // 배열의 값을 2진 검색
368         uint min = 0;
369         uint max = checkpoints.length-1;
370         while (max > min) {
371             uint mid = (max + min + 1)/ 2;
372             if (checkpoints[mid].fromBlock<=_block) {
373                 min = mid;
374             } else {
375                 max = mid-1;
376             }
377         }
378         return checkpoints[min].value;
379     }
380 
381     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
382     ) internal  {
383         if ((checkpoints.length == 0)
384         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
385                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
386                newCheckPoint.fromBlock =  uint128(block.number);
387                newCheckPoint.value = uint128(_value);
388            } else {
389                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
390                oldCheckPoint.value = uint128(_value);
391            }
392     }
393 
394     function isContract(address _addr) constant internal returns(bool) {
395         uint size;
396         if (_addr == 0) return false;
397         assembly {
398             size := extcodesize(_addr)
399         }
400         return size>0;
401     }
402 
403     function min(uint a, uint b) pure internal returns (uint) {
404         return a < b ? a : b;
405     }
406 
407     function () public payable {
408         require(isContract(controller));
409         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
410     }
411 
412     /*
413      * 안전 방법
414      */
415     function claimTokens(address _token) public onlyController {
416         if (_token == 0x0) {
417             controller.transfer(this.balance);
418             return;
419         }
420 
421         MiniMeToken token = MiniMeToken(_token);
422         uint balance = token.balanceOf(this);
423         token.transfer(controller, balance);
424         ClaimedTokens(_token, controller, balance);
425     }
426 
427     /*
428      * 이벤트
429      */
430     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
431     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
432     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
433     event Approval(
434         address indexed _owner,
435         address indexed _spender,
436         uint256 _amount
437         );
438 }
439 
440 /*
441  * MiniMeTokenFactory
442  */
443 // 이 계약은 계약에서 복제 계약을 생성하는 데 사용됩니다.
444 contract MiniMeTokenFactory {
445     //                      새로운 기능으로 새로운 토큰을 만들어 DApp를 업데이트하십시오.
446     //  msg.sender          는 이 복제 토큰의 컨트롤러가됩니다.
447     // _parentToken         복제 될 토큰의 주소
448     // _snapshotBlock       상위 토큰 블록
449     //                      복제 토큰의 초기 배포 결정
450     // _tokenName           새 토큰의 이름
451     // @param _decimalUnits 새 토큰의 소수 자릿수
452     // @param _tokenSymbol  새 토큰에 대한 토큰 기호
453     // @param _transfersEnabled true 이면 토큰을 전송할 수 있습니다.
454     // @return              새 토큰 계약의 주소
455     function createCloneToken(
456         address _parentToken,
457         uint _snapshotBlock,
458         string _tokenName,
459         uint8 _decimalUnits,
460         string _tokenSymbol,
461         bool _transfersEnabled
462     ) public returns (MiniMeToken) {
463         MiniMeToken newToken = new MiniMeToken(
464             this,
465             _parentToken,
466             _snapshotBlock,
467             _tokenName,
468             _decimalUnits,
469             _tokenSymbol,
470             _transfersEnabled
471             );
472 
473         newToken.changeController(msg.sender);
474         return newToken;
475     }
476 }
477 
478 /**
479  * @title RET
480  * @dev RET는 MiniMeToken을 상속받은 ERC20 토큰 계약입니다.
481  */
482 contract RET is MiniMeToken, Blockeds {
483   bool public sudoEnabled = true;
484 
485   modifier onlySudoEnabled() {
486     require(sudoEnabled);
487     _;
488   }
489 
490   modifier onlyNotBlocked(address _addr) {
491     require(!blocked[_addr]);
492     _;
493   }
494 
495   event SudoEnabled(bool _sudoEnabled);
496 
497   function RET(address _tokenFactory) MiniMeToken(
498     _tokenFactory,
499     0x0,                  // 부모 토큰 없음
500     0,                    // 상위의 스냅 샷 블록 번호 없음
501     "Rapide Token",      // 토큰 이름
502     18,                   // 십진법
503     "RAP",                // 상징(심볼)
504     false                 // 전송 사용
505   ) public {}
506 
507   function transfer(address _to, uint256 _amount) public onlyNotBlocked(msg.sender) returns (bool success) {
508     return super.transfer(_to, _amount);
509   }
510 
511   function transferFrom(address _from, address _to, uint256 _amount) public onlyNotBlocked(_from) returns (bool success) {
512     return super.transferFrom(_from, _to, _amount);
513   }
514 
515   // 아래의 4개 기능은 'sudorsabled(하위 설정됨)'로만 활성화됩니다.
516   // ALL : 3 개의 sudo 레벨
517   function generateTokens(address _owner, uint _amount) public onlyController onlySudoEnabled returns (bool) {
518     return super.generateTokens(_owner, _amount);
519   }
520 
521   function destroyTokens(address _owner, uint _amount) public onlyController onlySudoEnabled returns (bool) {
522     return super.destroyTokens(_owner, _amount);
523   }
524 
525   function blockAddress(address _addr) public onlyController onlySudoEnabled {
526     super.blockAddress(_addr);
527   }
528 
529   function unblockAddress(address _addr) public onlyController onlySudoEnabled {
530     super.unblockAddress(_addr);
531   }
532 
533   function enableSudo(bool _sudoEnabled) public onlyController {
534     sudoEnabled = _sudoEnabled;
535     SudoEnabled(_sudoEnabled);
536   }
537 
538   // byList 함수
539   function generateTokensByList(address[] _owners, uint[] _amounts) public onlyController onlySudoEnabled returns (bool) {
540     require(_owners.length == _amounts.length);
541 
542     for(uint i = 0; i < _owners.length; i++) {
543       generateTokens(_owners[i], _amounts[i]);
544     }
545 
546     return true;
547   }
548 }