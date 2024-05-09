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