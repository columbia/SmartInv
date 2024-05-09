1 pragma solidity 0.4.24;
2 contract Owned {
3     /* Variables */
4     address public owner = msg.sender;
5     /* Constructor */
6     constructor(address _owner) public {
7         if ( _owner == 0x00 ) {
8             _owner = msg.sender;
9         }
10         owner = _owner;
11     }
12     /* Externals */
13     function replaceOwner(address _owner) external returns(bool) {
14         require( isOwner() );
15         owner = _owner;
16         return true;
17     }
18     /* Internals */
19     function isOwner() internal view returns(bool) {
20         return owner == msg.sender;
21     }
22     /* Modifiers */
23     modifier forOwner {
24         require( isOwner() );
25         _;
26     }
27 }
28 library SafeMath {
29     /* Internals */
30     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
31         c = a + b;
32         assert( c >= a );
33         return c;
34     }
35     function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {
36         c = a - b;
37         assert( c <= a );
38         return c;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
41         c = a * b;
42         assert( c == 0 || c / a == b );
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns(uint256) {
46         return a / b;
47     }
48     function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {
49         c = a ** b;
50         assert( c % a == 0 );
51         return a ** b;
52     }
53 }
54 contract TokenDB is Owned {
55     /* Externals */
56     function transfer(address _from, address _to, uint256 _amount) external returns(bool _success) {}
57     function bulkTransfer(address _from, address[] _to, uint256[] _amount) external returns(bool _success) {}
58     function setAllowance(address _owner, address _spender, uint256 _amount) external returns(bool _success) {}
59     /* Constants */
60     function getAllowance(address _owner, address _spender) public view returns(bool _success, uint256 _remaining) {}
61     function balanceOf(address _owner) public view returns(bool _success, uint256 _balance) {}
62 }
63 contract Token is Owned {
64     /* Declarations */
65     using SafeMath for uint256;
66     /* Variables */
67     string  public name = "Inlock token";
68     string  public symbol = "ILK";
69     uint8   public decimals = 8;
70     uint256 public totalSupply = 44e16;
71     address public libAddress;
72     TokenDB public db;
73     Ico public ico;
74     /* Fallback */
75     function () public { revert(); }
76     /* Externals */
77     function changeLibAddress(address _libAddress) external forOwner {}
78     function changeDBAddress(address _dbAddress) external forOwner {}
79     function changeIcoAddress(address _icoAddress) external forOwner {}
80     function approve(address _spender, uint256 _value) external returns (bool _success) {}
81     function transfer(address _to, uint256 _amount) external returns (bool _success) {}
82     function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {}
83     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool _success) {}
84     /* Constants */
85     function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {}
86     function balanceOf(address _owner) public view returns (uint256 _balance) {}
87     /* Events */
88     event AllowanceUsed(address indexed _spender, address indexed _owner, uint256 indexed _value);
89     event Mint(address indexed _addr, uint256 indexed _value);
90     event Approval(address indexed _owner, address indexed _spender, uint _value);
91     event Transfer(address indexed _from, address indexed _to, uint _value);
92 }
93 contract Ico is Owned {
94     /* Declarations */
95     using SafeMath for uint256;
96     /* Enumerations */
97     enum phaseType {
98         pause,
99         privateSale1,
100         privateSale2,
101         sales1,
102         sales2,
103         sales3,
104         sales4,
105         preFinish,
106         finish
107     }
108     struct vesting_s {
109         uint256 amount;
110         uint256 startBlock;
111         uint256 endBlock;
112         uint256 claimedAmount;
113     }
114     /* Variables */
115     mapping(address => bool) public KYC;
116     mapping(address => bool) public transferRight;
117     mapping(address => vesting_s) public vesting;
118     phaseType public currentPhase;
119     uint256   public currentRate;
120     uint256   public currentRateM = 1e3;
121     uint256   public privateSale1Hardcap = 4e16;
122     uint256   public privateSale2Hardcap = 64e15;
123     uint256   public thisBalance = 44e16;
124     address   public offchainUploaderAddress;
125     address   public setKYCAddress;
126     address   public setRateAddress;
127     address   public libAddress;
128     Token     public token;
129     /* Constructor */
130     constructor(address _owner, address _libAddress, address _tokenAddress, address _offchainUploaderAddress,
131         address _setKYCAddress, address _setRateAddress) Owned(_owner) public {
132         currentPhase = phaseType.pause;
133         libAddress = _libAddress;
134         token = Token(_tokenAddress);
135         offchainUploaderAddress = _offchainUploaderAddress;
136         setKYCAddress = _setKYCAddress;
137         setRateAddress = _setRateAddress;
138     }
139     /* Fallback */
140     function () public payable {
141         buy();
142     }
143     /* Externals */
144     function changeLibAddress(address _libAddress) external forOwner {
145         libAddress = _libAddress;
146     }
147     function changeOffchainUploaderAddress(address _offchainUploaderAddress) external forOwner {
148         offchainUploaderAddress = _offchainUploaderAddress;
149     }
150     function changeKYCAddress(address _setKYCAddress) external forOwner {
151         setKYCAddress = _setKYCAddress;
152     }
153     function changeSetRateAddress(address _setRateAddress) external forOwner {
154         setRateAddress = _setRateAddress;
155     }
156     function setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock) external {
157         address _trg = libAddress;
158         assembly {
159             let m := mload(0x40)
160             calldatacopy(m, 0, calldatasize)
161             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
162             switch success case 0 {
163                 revert(0, 0)
164             } default {
165                 return(m, 0)
166             }
167         }
168     }
169     function claimVesting() external {
170         address _trg = libAddress;
171         assembly {
172             let m := mload(0x40)
173             calldatacopy(m, 0, calldatasize)
174             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
175             switch success case 0 {
176                 revert(0, 0)
177             } default {
178                 return(m, 0)
179             }
180         }
181     }
182     function setKYC(address[] _on, address[] _off) external {
183         address _trg = libAddress;
184         assembly {
185             let m := mload(0x40)
186             calldatacopy(m, 0, calldatasize)
187             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
188             switch success case 0 {
189                 revert(0, 0)
190             } default {
191                 return(m, 0)
192             }
193         }
194     }
195     function setTransferRight(address[] _allow, address[] _disallow) external {
196         address _trg = libAddress;
197         assembly {
198             let m := mload(0x40)
199             calldatacopy(m, 0, calldatasize)
200             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
201             switch success case 0 {
202                 revert(0, 0)
203             } default {
204                 return(m, 0)
205             }
206         }
207     }
208     function setCurrentRate(uint256 _currentRate) external {
209         address _trg = libAddress;
210         assembly {
211             let m := mload(0x40)
212             calldatacopy(m, 0, calldatasize)
213             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
214             switch success case 0 {
215                 revert(0, 0)
216             } default {
217                 return(m, 0)
218             }
219         }
220     }
221     function setCurrentPhase(phaseType _phase) external {
222         address _trg = libAddress;
223         assembly {
224             let m := mload(0x40)
225             calldatacopy(m, 0, calldatasize)
226             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
227             switch success case 0 {
228                 revert(0, 0)
229             } default {
230                 return(m, 0)
231             }
232         }
233     }
234     function offchainUpload(address[] _beneficiaries, uint256[] _rewards) external {
235         address _trg = libAddress;
236         assembly {
237             let m := mload(0x40)
238             calldatacopy(m, 0, calldatasize)
239             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
240             switch success case 0 {
241                 revert(0, 0)
242             } default {
243                 return(m, 0)
244             }
245         }
246     }
247     function buy() public payable {
248         address _trg = libAddress;
249         assembly {
250             let m := mload(0x40)
251             calldatacopy(m, 0, calldatasize)
252             let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
253             switch success case 0 {
254                 revert(0, 0)
255             } default {
256                 return(m, 0)
257             }
258         }
259     }
260     /* Constants */
261     function allowTransfer(address _owner) public view returns (bool _success, bool _allow) {
262         address _trg = libAddress;
263         assembly {
264             let m := mload(0x40)
265             calldatacopy(m, 0, calldatasize)
266             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
267             switch success case 0 {
268                 revert(0, 0)
269             } default {
270                 return(m, 0x40)
271             }
272         }
273     }
274     function calculateReward(uint256 _input) public view returns (bool _success, uint256 _reward) {
275         address _trg = libAddress;
276         assembly {
277             let m := mload(0x40)
278             calldatacopy(m, 0, calldatasize)
279             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
280             switch success case 0 {
281                 revert(0, 0)
282             } default {
283                 return(m, 0x40)
284             }
285         }
286     }
287     function calcVesting(address _owner) public view returns(bool _success, uint256 _reward) {
288         address _trg = libAddress;
289         assembly {
290             let m := mload(0x40)
291             calldatacopy(m, 0, calldatasize)
292             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
293             switch success case 0 {
294                 revert(0, 0)
295             } default {
296                 return(m, 0x40)
297             }
298         }
299     }
300     /* Events */
301     event Brought(address _owner, address _beneficiary, uint256 _input, uint256 _output);
302     event VestingDefined(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock);
303     event VestingClaimed(address _beneficiary, uint256 _amount);
304 }
305 contract IcoLib is Ico {
306     /* Constructor */
307     constructor(address _owner, address _tokenAddress, address _offchainUploaderAddress, address _setKYCAddress, address _setRateAddress)
308         Ico(_owner, 0x00, _tokenAddress, _offchainUploaderAddress, _setKYCAddress, _setRateAddress) public {}
309     /* Externals */
310     function setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock) external forOwner {
311         require( _beneficiary != 0x00 );
312         thisBalance = thisBalance.add( vesting[_beneficiary].amount.sub(vesting[_beneficiary].claimedAmount) );
313         if ( _amount == 0 ) {
314             delete vesting[_beneficiary];
315             emit VestingDefined(_beneficiary, 0, 0, 0);
316         } else {
317             require( _endBlock > _startBlock );
318             vesting[_beneficiary] = vesting_s(
319                 _amount,
320                 _startBlock,
321                 _endBlock,
322                 0
323             );
324             thisBalance = thisBalance.sub( _amount );
325             emit VestingDefined(_beneficiary, _amount, _startBlock, _endBlock);
326         }
327     }
328     function claimVesting() external {
329         uint256 _reward;
330         bool    _subResult;
331         ( _subResult, _reward ) = calcVesting(msg.sender);
332         require( _subResult && _reward > 0 );
333         vesting[msg.sender].claimedAmount = vesting[msg.sender].claimedAmount.add(_reward);
334         require( token.transfer(msg.sender, _reward) );
335     }
336     function setKYC(address[] _on, address[] _off) external {
337         uint256 i;
338         require( msg.sender == setKYCAddress );
339         for ( i=0 ; i<_on.length ; i++ ) {
340             KYC[_on[i]] = true;
341         }
342         for ( i=0 ; i<_off.length ; i++ ) {
343             delete KYC[_off[i]];
344         }
345     }
346     function setTransferRight(address[] _allow, address[] _disallow) external forOwner {
347         uint256 i;
348         for ( i=0 ; i<_allow.length ; i++ ) {
349             transferRight[_allow[i]] = true;
350         }
351         for ( i=0 ; i<_disallow.length ; i++ ) {
352             delete transferRight[_disallow[i]];
353         }
354     }
355     function setCurrentRate(uint256 _currentRate) external {
356         require( msg.sender == setRateAddress );
357         require( _currentRate >= currentRateM );
358         currentRate = _currentRate;
359     }
360     function setCurrentPhase(phaseType _phase) external forOwner {
361         currentPhase = _phase;
362     }
363     function offchainUpload(address[] _beneficiaries, uint256[] _rewards) external {
364         uint256 i;
365         uint256 _totalReward;
366         require( msg.sender == offchainUploaderAddress );
367         require( currentPhase != phaseType.pause && currentPhase != phaseType.finish );
368         require( _beneficiaries.length ==  _rewards.length );
369         for ( i=0 ; i<_rewards.length ; i++ ) {
370             _totalReward = _totalReward.add(_rewards[i]);
371             emit Brought(msg.sender, _beneficiaries[i], 0, _rewards[i]);
372         }
373         thisBalance = thisBalance.sub(_totalReward);
374         if ( currentPhase == phaseType.privateSale1 ) {
375             privateSale1Hardcap = privateSale1Hardcap.sub(_totalReward);
376         } else if ( currentPhase == phaseType.privateSale2 ) {
377             privateSale2Hardcap = privateSale2Hardcap.sub(_totalReward);
378         }
379         token.bulkTransfer(_beneficiaries, _rewards);
380     }
381     function buy() public payable {
382         uint256 _reward;
383         bool    _subResult;
384         require( currentPhase == phaseType.privateSale2 || 
385             currentPhase == phaseType.sales1 || 
386             currentPhase == phaseType.sales2 || 
387             currentPhase == phaseType.sales3 || 
388             currentPhase == phaseType.sales4 || 
389             currentPhase == phaseType.preFinish
390         );
391         require( KYC[msg.sender] );
392         ( _subResult, _reward ) = calculateReward(msg.value);
393         require( _reward > 0 && _subResult );
394         thisBalance = thisBalance.sub(_reward);
395         require( owner.send(msg.value) );
396         if ( currentPhase == phaseType.privateSale1 ) {
397             privateSale1Hardcap = privateSale1Hardcap.sub(_reward);
398         } else if ( currentPhase == phaseType.privateSale2 ) {
399             privateSale2Hardcap = privateSale2Hardcap.sub(_reward);
400         }
401         require( token.transfer(msg.sender, _reward) );
402         emit Brought(msg.sender, msg.sender, msg.value, _reward);
403     }
404     /* Constants */
405     function allowTransfer(address _owner) public view returns (bool _success, bool _allow) {
406         return ( true, _owner == address(this) || transferRight[_owner] || currentPhase == phaseType.preFinish  || currentPhase == phaseType.finish );
407     }
408     function calculateReward(uint256 _input) public view returns (bool _success, uint256 _reward) {
409         uint256 _amount;
410         _success = true;
411         if ( currentRate == 0 || _input == 0 ) {
412             return;
413         }
414         _amount = _input.mul(1e8).mul(100).mul(currentRate).div(1e18).div(currentRateM); // 1 token eq 0.01 USD
415         if ( _amount == 0 ) {
416             return;
417         }
418         if ( currentPhase == phaseType.privateSale1 ) {
419             if        ( _amount >=  25e13 ) {
420                 _reward = _amount.mul(142).div(100);
421             } else if ( _amount >=  10e13 ) {
422                 _reward = _amount.mul(137).div(100);
423             } else if ( _amount >=   2e13 ) {
424                 _reward = _amount.mul(133).div(100);
425             }
426             if ( _reward > 0 && privateSale1Hardcap < _reward ) {
427                 _reward = 0;
428             }
429         } else if ( currentPhase == phaseType.privateSale2 ) {
430             if        ( _amount >= 125e13 ) {
431                 _reward = _amount.mul(129).div(100);
432             } else if ( _amount >= 100e13 ) {
433                 _reward = _amount.mul(124).div(100);
434             } else if ( _amount >=  10e13 ) {
435                 _reward = _amount.mul(121).div(100);
436             }
437             if ( _reward > 0 && privateSale2Hardcap < _reward ) {
438                 _reward = 0;
439             }
440         } else if ( currentPhase == phaseType.sales1 ) {
441             if        ( _amount >=   1e12 ) {
442                 _reward = _amount.mul(117).div(100);
443             }
444         } else if ( currentPhase == phaseType.sales2 ) {
445             if        ( _amount >=   1e12 ) {
446                 _reward = _amount.mul(112).div(100);
447             }
448         } else if ( currentPhase == phaseType.sales3 ) {
449             if        ( _amount >=   1e12 ) {
450                 _reward = _amount.mul(109).div(100);
451             }
452         } else if ( currentPhase == phaseType.sales4 ) {
453             if        ( _amount >=   1e12 ) {
454                 _reward = _amount.mul(102).div(100);
455             }
456         } else if ( currentPhase == phaseType.preFinish ) {
457             _reward = _amount;
458         }
459         if ( thisBalance < _reward ) {
460             _reward = 0;
461         }
462     }
463     function calcVesting(address _owner) public view returns(bool _success, uint256 _reward) {
464         vesting_s memory _vesting = vesting[_owner];
465         if ( _vesting.amount == 0 || block.number < _vesting.startBlock ) {
466             return ( true, 0 );
467         }
468         _reward = _vesting.amount.mul( block.number.sub(_vesting.startBlock) ).div( _vesting.endBlock.sub(_vesting.startBlock) );
469         if ( _reward > _vesting.amount ) {
470             _reward = _vesting.amount;
471         }
472         if ( _reward <= _vesting.claimedAmount ) {
473             return ( true, 0 );
474         }
475         return ( true, _reward.sub(_vesting.claimedAmount) );
476     }
477 }