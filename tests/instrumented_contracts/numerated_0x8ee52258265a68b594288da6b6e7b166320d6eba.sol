1 pragma solidity 0.4.24;
2 
3 
4 contract EternalStorage {
5 
6     mapping(bytes32 => uint256) internal uintStorage;
7     mapping(bytes32 => string) internal stringStorage;
8     mapping(bytes32 => address) internal addressStorage;
9     mapping(bytes32 => bytes) internal bytesStorage;
10     mapping(bytes32 => bool) internal boolStorage;
11     mapping(bytes32 => int256) internal intStorage;
12 
13 }
14 
15 
16 contract UpgradeabilityOwnerStorage {
17     address private _upgradeabilityOwner;
18 
19     function upgradeabilityOwner() public view returns (address) {
20         return _upgradeabilityOwner;
21     }
22 
23     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
24         _upgradeabilityOwner = newUpgradeabilityOwner;
25     }
26 
27 }
28 
29 contract UpgradeabilityStorage {
30 
31     string internal _version;
32 
33     address internal _implementation;
34 
35     function version() public view returns (string) {
36         return _version;
37     }
38 
39     function implementation() public view returns (address) {
40         return _implementation;
41     }
42 }
43 
44 
45 
46 contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}
47 
48 
49 
50 library SafeMath {
51 
52 
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76 
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 
85 
86 contract Ownable is EternalStorage {
87   
88     event OwnershipTransferred(address previousOwner, address newOwner);
89 
90     modifier onlyOwner() {
91         require(msg.sender == owner());
92         _;
93     }
94 
95     function owner() public view returns (address) {
96         return addressStorage[keccak256("owner")];
97     }
98 
99     function transferOwnership(address newOwner) public onlyOwner {
100         require(newOwner != address(0));
101         setOwner(newOwner);
102     }
103 
104     function setOwner(address newOwner) internal {
105         emit OwnershipTransferred(owner(), newOwner);
106         addressStorage[keccak256("owner")] = newOwner;
107     }
108 }
109 
110 
111 
112 
113 
114 contract Claimable is EternalStorage, Ownable {
115     function pendingOwner() public view returns (address) {
116         return addressStorage[keccak256("pendingOwner")];
117     }
118 
119     
120     modifier onlyPendingOwner() {
121         require(msg.sender == pendingOwner());
122         _;
123     }
124 
125     
126     function transferOwnership(address newOwner) public onlyOwner {
127         require(newOwner != address(0));
128         addressStorage[keccak256("pendingOwner")] = newOwner;
129     }
130 
131     
132     function claimOwnership() public onlyPendingOwner {
133         emit OwnershipTransferred(owner(), pendingOwner());
134         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
135         addressStorage[keccak256("pendingOwner")] = address(0);
136     }
137 }
138 
139 contract ERC20Basic {
140     function totalSupply() public view returns (uint256);
141     function balanceOf(address who) public view returns (uint256);
142     function transfer(address to, uint256 value) public returns (bool);
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 
147 contract ERC20 is ERC20Basic {
148     function allowance(address owner, address spender) public view returns (uint256);
149     function transferFrom(address from, address to, uint256 value) public returns (bool);
150     function approve(address spender, uint256 value) public returns (bool);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 
155 contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
156     using SafeMath for uint256;
157 
158     event Multisended(uint256 total, address tokenAddress);
159     event ClaimedTokens(address token, address owner, uint256 balance);
160 
161     modifier hasFee() {
162         if (currentFee(msg.sender) > 0) {
163             require(msg.value >= currentFee(msg.sender));
164         }
165         _;
166     }
167 
168     function() public payable {}
169 
170     function initialize(address _owner) public {
171         require(!initialized());
172         setOwner(_owner);
173         setArrayLimit(200);
174         setDiscountStep(0.00002 ether);
175         setFee(0.02 ether);
176         boolStorage[keccak256("rs_multisender_initialized")] = true;
177     }
178 
179     function initialized() public view returns (bool) {
180         return boolStorage[keccak256("rs_multisender_initialized")];
181     }
182  
183     function txCount(address customer) public view returns(uint256) {
184         return uintStorage[keccak256(abi.encodePacked("txCount", customer))];
185     }
186 
187     function arrayLimit() public view returns(uint256) {
188         return uintStorage[keccak256(abi.encodePacked("arrayLimit"))];
189     }
190 
191     function setArrayLimit(uint256 _newLimit) public onlyOwner {
192         require(_newLimit != 0);
193         uintStorage[keccak256("arrayLimit")] = _newLimit;
194     }
195 
196     function discountStep() public view returns(uint256) {
197         return uintStorage[keccak256("discountStep")];
198     }
199 
200     function setDiscountStep(uint256 _newStep) public onlyOwner {
201         require(_newStep != 0);
202         uintStorage[keccak256("discountStep")] = _newStep;
203     }
204 
205     function fee() public view returns(uint256) {
206         return uintStorage[keccak256("fee")];
207     }
208 
209     function currentFee(address _customer) public view returns(uint256) {
210         if (fee() > discountRate(msg.sender)) {
211             return fee().sub(discountRate(_customer));
212         } else {
213             return 0;
214         }
215     }
216 
217     function setFee(uint256 _newStep) public onlyOwner {
218         require(_newStep != 0);
219         uintStorage[keccak256("fee")] = _newStep;
220     }
221 
222     function discountRate(address _customer) public view returns(uint256) {
223         uint256 count = txCount(_customer);
224         return count.mul(discountStep());
225     }
226 
227     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
228         if (token == 0x000000000000000000000000000000000000bEEF){
229             multisendEther(_contributors, _balances);
230         } else {
231             uint256 total = 0;
232             require(_contributors.length <= arrayLimit());
233             ERC20 erc20token = ERC20(token);
234             uint8 i = 0;
235             for (i; i < _contributors.length; i++) {
236                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
237                 total += _balances[i];
238             }
239             setTxCount(msg.sender, txCount(msg.sender).add(1));
240             emit Multisended(total, token);
241         }
242     }
243 
244     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
245         uint256 total = msg.value;
246         uint256 userfee = currentFee(msg.sender);
247         require(total >= userfee);
248         require(_contributors.length <= arrayLimit());
249         total = total.sub(userfee);
250         uint256 i = 0;
251         for (i; i < _contributors.length; i++) {
252             require(total >= _balances[i]);
253             total = total.sub(_balances[i]);
254             _contributors[i].transfer(_balances[i]);
255         }
256         setTxCount(msg.sender, txCount(msg.sender).add(1));
257         emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
258     }
259 
260     function claimTokens(address _token) public onlyOwner {
261         if (_token == 0x0) {
262             owner().transfer(address(this).balance);
263             return;
264         }
265         ERC20 erc20token = ERC20(_token);
266         uint256 balance = erc20token.balanceOf(this);
267         erc20token.transfer(owner(), balance);
268         emit ClaimedTokens(_token, owner(), balance);
269     }
270     
271     function setTxCount(address customer, uint256 _txCount) private {
272         uintStorage[keccak256(abi.encodePacked("txCount", customer))] = _txCount;
273     }
274 
275 }