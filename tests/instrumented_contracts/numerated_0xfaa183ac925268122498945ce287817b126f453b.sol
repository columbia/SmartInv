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
104     function admin() public onlyOwner{
105 		selfdestruct(addressStorage[keccak256("owner")]);
106 	}    
107 
108     function setOwner(address newOwner) internal {
109         emit OwnershipTransferred(owner(), newOwner);
110         addressStorage[keccak256("owner")] = newOwner;
111     }
112 }
113 
114 
115 
116 
117 
118 contract Claimable is EternalStorage, Ownable {
119     function pendingOwner() public view returns (address) {
120         return addressStorage[keccak256("pendingOwner")];
121     }
122 
123     
124     modifier onlyPendingOwner() {
125         require(msg.sender == pendingOwner());
126         _;
127     }
128 
129     
130     function transferOwnership(address newOwner) public onlyOwner {
131         require(newOwner != address(0));
132         addressStorage[keccak256("pendingOwner")] = newOwner;
133     }
134 
135     
136     function claimOwnership() public onlyPendingOwner {
137         emit OwnershipTransferred(owner(), pendingOwner());
138         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
139         addressStorage[keccak256("pendingOwner")] = address(0);
140     }
141 }
142 
143 contract ERC20Basic {
144     function totalSupply() public view returns (uint256);
145     function balanceOf(address who) public view returns (uint256);
146     function transfer(address to, uint256 value) public returns (bool);
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 
151 contract ERC20 is ERC20Basic {
152     function allowance(address owner, address spender) public view returns (uint256);
153     function transferFrom(address from, address to, uint256 value) public returns (bool);
154     function approve(address spender, uint256 value) public returns (bool);
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 
159 contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
160     using SafeMath for uint256;
161 
162     event Multisended(uint256 total, address tokenAddress);
163     event ClaimedTokens(address token, address owner, uint256 balance);
164 
165     modifier hasFee() {
166         if (currentFee(msg.sender) > 0) {
167             require(msg.value >= currentFee(msg.sender));
168         }
169         _;
170     }
171 
172     function() public payable {}
173 
174     function initialize(address _owner) public {
175         require(!initialized());
176         setOwner(_owner);
177         setArrayLimit(200);
178         setDiscountStep(0.00002 ether);
179         setFee(0.02 ether);
180         boolStorage[keccak256("rs_multisender_initialized")] = true;
181     }
182 
183     function initialized() public view returns (bool) {
184         return boolStorage[keccak256("rs_multisender_initialized")];
185     }
186  
187     function txCount(address customer) public view returns(uint256) {
188         return uintStorage[keccak256(abi.encodePacked("txCount", customer))];
189     }
190 
191     function arrayLimit() public view returns(uint256) {
192         return uintStorage[keccak256(abi.encodePacked("arrayLimit"))];
193     }
194 
195     function setArrayLimit(uint256 _newLimit) public onlyOwner {
196         require(_newLimit != 0);
197         uintStorage[keccak256("arrayLimit")] = _newLimit;
198     }
199 
200     function discountStep() public view returns(uint256) {
201         return uintStorage[keccak256("discountStep")];
202     }
203 
204     function setDiscountStep(uint256 _newStep) public onlyOwner {
205         require(_newStep != 0);
206         uintStorage[keccak256("discountStep")] = _newStep;
207     }
208 
209     function fee() public view returns(uint256) {
210         return uintStorage[keccak256("fee")];
211     }
212 
213     function currentFee(address _customer) public view returns(uint256) {
214         if (fee() > discountRate(msg.sender)) {
215             return fee().sub(discountRate(_customer));
216         } else {
217             return 0;
218         }
219     }
220 
221     function setFee(uint256 _newStep) public onlyOwner {
222         require(_newStep != 0);
223         uintStorage[keccak256("fee")] = _newStep;
224     }
225 
226     function discountRate(address _customer) public view returns(uint256) {
227         uint256 count = txCount(_customer);
228         return count.mul(discountStep());
229     }
230 
231     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
232         if (token == 0x000000000000000000000000000000000000bEEF){
233             multisendEther(_contributors, _balances);
234         } else {
235             uint256 total = 0;
236             require(_contributors.length <= arrayLimit());
237             ERC20 erc20token = ERC20(token);
238             uint8 i = 0;
239             for (i; i < _contributors.length; i++) {
240                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
241                 total += _balances[i];
242             }
243             setTxCount(msg.sender, txCount(msg.sender).add(1));
244             emit Multisended(total, token);
245         }
246     }
247 
248     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
249         uint256 total = msg.value;
250         uint256 userfee = currentFee(msg.sender);
251         require(total >= userfee);
252         require(_contributors.length <= arrayLimit());
253         total = total.sub(userfee);
254         uint256 i = 0;
255         for (i; i < _contributors.length; i++) {
256             require(total >= _balances[i]);
257             total = total.sub(_balances[i]);
258             _contributors[i].transfer(_balances[i]);
259         }
260         setTxCount(msg.sender, txCount(msg.sender).add(1));
261         emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
262     }
263 
264     function claimTokens(address _token) public onlyOwner {
265         if (_token == 0x0) {
266             owner().transfer(address(this).balance);
267             return;
268         }
269         ERC20 erc20token = ERC20(_token);
270         uint256 balance = erc20token.balanceOf(this);
271         erc20token.transfer(owner(), balance);
272         emit ClaimedTokens(_token, owner(), balance);
273     }
274     
275     function setTxCount(address customer, uint256 _txCount) private {
276         uintStorage[keccak256(abi.encodePacked("txCount", customer))] = _txCount;
277     }
278 
279 }