1 // File: contracts/interfaces/ERC20.sol
2 
3 pragma solidity ^0.5.9;
4 
5 
6 interface ERC20 {
7     function transfer(address _to, uint _value) external returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
10     function approve(address _spender, uint256 _value) external returns (bool success);
11     function increaseApproval (address _spender, uint _addedValue) external returns (bool success);
12     function balanceOf(address _owner) external view returns (uint256 balance);
13 }
14 
15 // File: contracts/interfaces/NanoLoanEngine.sol
16 
17 pragma solidity ^0.5.9;
18 
19 
20 interface NanoLoanEngine {
21     enum Status { initial, lent, paid, destroyed }
22     function rcn() external returns (ERC20);
23     function getTotalLoans() external view returns (uint256);
24     function pay(uint index, uint256 _amount, address _from, bytes calldata oracleData) external returns (bool);
25     function cosign(uint index, uint256 cost) external returns (bool);
26     function getCreator(uint index) external view returns (address);
27     function getDueTime(uint index) external view returns (uint256);
28     function getDuesIn(uint index) external view returns (uint256);
29     function getPendingAmount(uint index) external returns (uint256);
30     function getStatus(uint index) external view returns (Status);
31 }
32 
33 // File: contracts/commons/Ownable.sol
34 
35 pragma solidity ^0.5.9;
36 
37 
38 contract Ownable {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() internal {
47         _owner = msg.sender;
48         emit OwnershipTransferred(address(0), _owner);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == _owner, "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) external onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/commons/Wallet.sol
78 
79 pragma solidity ^0.5.9;
80 
81 
82 
83 contract Wallet is Ownable {
84     function execute(
85         address payable _to,
86         uint256 _value,
87         bytes calldata _data
88     ) external onlyOwner returns (bool, bytes memory) {
89         return _to.call.value(_value)(_data);
90     }
91 }
92 
93 // File: contracts/commons/Pausable.sol
94 
95 pragma solidity ^0.5.9;
96 
97 
98 
99 contract Pausable is Ownable {
100     bool public paused;
101 
102     event SetPaused(bool _paused);
103 
104     constructor() public {
105         emit SetPaused(false);
106     }
107 
108     modifier notPaused() {
109         require(!paused, "Contract is paused");
110         _;
111     }
112 
113     function setPaused(bool _paused) external onlyOwner {
114         paused = _paused;
115         emit SetPaused(_paused);
116     }
117 }
118 
119 // File: contracts/interfaces/Cosigner.sol
120 
121 pragma solidity ^0.5.9;
122 
123 
124 
125 contract Cosigner {
126     uint256 public constant VERSION = 2;
127 
128     /**
129         @return the url of the endpoint that exposes the insurance offers.
130     */
131     function url() external view returns (string memory);
132 
133     /**
134         @dev Retrieves the cost of a given insurance, this amount should be exact.
135 
136         @return the cost of the cosign, in RCN wei
137     */
138     function cost(address engine, uint256 index, bytes calldata data, bytes calldata oracleData) external view returns (uint256);
139 
140     /**
141         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
142         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
143         does not return true to this method, the operation fails.
144 
145         @return true if the cosigner accepts the liability
146     */
147     function requestCosign(NanoLoanEngine engine, uint256 index, bytes calldata data, bytes calldata oracleData) external returns (bool);
148 
149     /**
150         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
151         current lender of the loan.
152 
153         @return true if the claim was done correctly.
154     */
155     function claim(NanoLoanEngine engine, uint256 index, bytes calldata oracleData) external returns (bool);
156 }
157 
158 // File: contracts/RPCosigner.sol
159 
160 pragma solidity ^0.5.9;
161 
162 
163 
164 
165 
166 
167 
168 
169 contract RPCosigner is Cosigner, Ownable, Wallet, Pausable {
170     uint256 public deltaPayment = 15 days;
171     NanoLoanEngine public engine;
172     uint256 public legacyLimit;
173     ERC20 public token;
174 
175     mapping(address => bool) public originators;
176     mapping(uint256 => bool) public liability;
177 
178     event SetOriginator(address _originator, bool _enabled);
179     event SetDeltaPayment(uint256 _prev, uint256 _val);
180     event SetLegacyLimit(uint256 _prev, uint256 _val);
181     event Cosigned(uint256 _id);
182     event Paid(uint256 _id, uint256 _amount, uint256 _tokens);
183 
184     constructor(
185         NanoLoanEngine _engine
186     ) public {
187         // Approve token spending
188         ERC20 _token = _engine.rcn();
189         _token.approve(address(_engine), uint(-1));
190         // Save to storage
191         token = _token;
192         engine = _engine;
193         // Emit initial events
194         emit SetDeltaPayment(0, deltaPayment);
195         emit SetLegacyLimit(0, legacyLimit);
196     }
197 
198     function setOriginator(address _originator, bool _enabled) external onlyOwner {
199         emit SetOriginator(_originator, _enabled);
200         originators[_originator] = _enabled;
201     }
202 
203     function setDeltaPayment(uint256 _delta) external onlyOwner {
204         emit SetDeltaPayment(deltaPayment, _delta);
205         deltaPayment = _delta;
206     }
207 
208     function setLegacyLimit(uint256 _time) external onlyOwner {
209         emit SetLegacyLimit(legacyLimit, _time);
210         legacyLimit = _time;
211     }
212 
213     function url() external view returns (string memory) {
214         return "";
215     }
216 
217     function cost(
218         address,
219         uint256,
220         bytes calldata,
221         bytes calldata
222     ) external view returns (uint256) {
223         return 0;
224     }
225 
226     function requestCosign(
227         NanoLoanEngine _engine,
228         uint256 _index,
229         bytes calldata,
230         bytes calldata
231     ) external notPaused returns (bool) {
232         require(_engine == engine, "Invalid loan engine");
233         require(originators[_engine.getCreator(_index)], "Invalid originator");
234         require(!liability[_index], "Liability already exists");
235         liability[_index] = true;
236         require(_engine.cosign(_index, 0), "Cosign failed");
237         emit Cosigned(_index);
238         return true;
239     }
240 
241     function claim(
242         NanoLoanEngine _engine,
243         uint256 _index,
244         bytes calldata _oracleData
245     ) external returns (bool) {
246         require(_engine == engine, "Invalid loan engine");
247         require(_engine.getStatus(_index) == NanoLoanEngine.Status.lent, "Invalid status");
248 
249         uint256 dueTime = _engine.getDueTime(_index);
250         require(dueTime + deltaPayment < block.timestamp, "Loan is ongoing");
251 
252         if (!liability[_index]) {
253             require(originators[_engine.getCreator(_index)], "Invalid originator");
254             uint256 _legacyLimit = legacyLimit;
255             require(_legacyLimit == 0 || (dueTime - _engine.getDuesIn(_index)) < _legacyLimit, "Loan outside legacy limits");
256         }
257 
258         ERC20 _token = token;
259         uint256 toPay = _engine.getPendingAmount(_index);
260         uint256 prevBalance = _token.balanceOf(address(this));
261         require(_engine.pay(_index, toPay, address(this), _oracleData), "Error paying loan");
262         emit Paid(_index, toPay, prevBalance - _token.balanceOf(address(this)));
263         return true;
264     }
265 }