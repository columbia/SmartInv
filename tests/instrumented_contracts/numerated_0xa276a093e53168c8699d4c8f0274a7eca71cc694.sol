1 /**
2  *Submitted for verification at Etherscan.io on 2020-02-11
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 
8 
9 contract IStdToken {
10     function balanceOf(address _owner) public view returns (uint256);
11     function transfer(address _to, uint256 _value) public returns (bool);
12     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
13     function allowance(address _owner, address _spender) public view returns (uint256);
14 }
15 
16 
17 
18 contract SwapCommon {
19 
20     mapping(address => bool) private _admins;
21     mapping(address => bool) private _services;
22 
23     modifier onlyAdmin() {
24         require(_admins[msg.sender], "not admin");
25         _;
26     }
27 
28     modifier onlyAdminOrService() {
29         require(_admins[msg.sender] || _services[msg.sender], "not admin/service");
30         _;
31     }
32 
33     constructor() public {
34         _admins[msg.sender] = true;
35     }
36 
37     function addAdmin(address addr) public onlyAdmin {
38         _admins[addr] = true;
39     }
40 
41     function removeAdmin(address addr) public onlyAdmin {
42         _admins[addr] = false;
43     }
44 
45     function isAdmin(address addr) public view returns (bool) {
46         return _admins[addr];
47     }
48 
49     function addService(address addr) public onlyAdmin {
50         _services[addr] = true;
51     }
52 
53     function removeService(address addr) public onlyAdmin {
54         _services[addr] = false;
55     }
56 
57     function isService(address addr) public view returns (bool) {
58         return _services[addr];
59     }
60 }
61 
62 
63 
64 contract SwapCore is SwapCommon {
65 
66     address public controllerAddress = address(0x0);
67 
68     IStdToken public mntpToken;
69 
70     modifier onlyController() {
71         require(controllerAddress == msg.sender, "not controller");
72         _;
73     }
74 
75     constructor(address mntpTokenAddr) SwapCommon() public {
76         controllerAddress = msg.sender;
77         mntpToken = IStdToken(mntpTokenAddr);
78     }
79 
80     function setNewControllerAddress(address newAddress) public onlyController {
81         controllerAddress = newAddress;
82     }
83 }
84 
85 
86 
87 contract Swap {
88 
89     SwapCore public core;
90 
91     IStdToken public mntpToken;
92 
93     bool public isActual = true;
94     bool public isActive = true;
95 
96     event onSwapMntp(address indexed from, uint256 amount, bytes32 to);
97     event onSentMntp(address indexed to, uint256 amount, bytes32 from);
98 
99     modifier onlyAdmin() {
100         require(core.isAdmin(msg.sender), "not admin");
101         _;
102     }
103 
104     modifier onlyAdminOrService() {
105         require(core.isAdmin(msg.sender) || core.isService(msg.sender), "not admin/service");
106         _;
107     }
108 
109     modifier onlyValidAddress(address addr) {
110         require(addr != address(0x0), "nil address");
111         _;
112     }
113 
114     modifier onlyActiveContract() {
115         require(isActive, "inactive contract");
116         _;
117     }
118 
119     modifier onlyInactiveContract() {
120         require(!isActive, "active contract");
121         _;
122     }
123 
124     modifier onlyActualContract() {
125         require(isActual, "outdated contract");
126         _;
127     }
128 
129     constructor(address coreAddr) public onlyValidAddress(coreAddr) {
130         core = SwapCore(coreAddr);
131         mntpToken = core.mntpToken();
132     }
133 
134     function toggleActivity() public onlyActualContract onlyAdmin {
135         isActive = !isActive;
136     }
137 
138     function migrateContract(address newControllerAddr) public onlyValidAddress(newControllerAddr) onlyActualContract onlyAdmin {
139         core.setNewControllerAddress(newControllerAddr);
140         uint256 mntpTokenAmount = getMntpBalance();
141         if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount);
142         isActive = false;
143         isActual = false;
144     }
145 
146     function getMntpBalance() public view returns(uint256) {
147         return mntpToken.balanceOf(address(this));
148     }
149 
150     function drainMntp(address addr) public onlyValidAddress(addr) onlyAdmin onlyInactiveContract {
151         uint256 amount = getMntpBalance();
152         if (amount > 0) mntpToken.transfer(addr, amount);
153     }
154 
155     // ---
156 
157     function swapMntp(uint256 amount, bytes32 mintAddress) public onlyActualContract onlyActiveContract {
158         require(amount > 0, "zero amount");
159         require(mntpToken.balanceOf(msg.sender) >= amount, "not enough mntp");
160         require(mntpToken.allowance(msg.sender, address(this)) >= amount, "invalid allowance");
161 
162         require(mntpToken.transferFrom(msg.sender, address(this), amount), "transfer failure");
163         emit onSwapMntp(msg.sender, amount, mintAddress);
164     }
165 
166     function sendMntp(uint256 amount, address addr, bytes32 sourceMintAddress) public onlyActualContract onlyActiveContract onlyAdminOrService {
167         require(amount > 0, "zero amount");
168         require(mntpToken.balanceOf(address(this)) >= amount, "not enough mntp");
169 
170         require(mntpToken.transfer(addr, amount), "transfer failure");
171         emit onSentMntp(msg.sender, amount, sourceMintAddress);
172     }
173 }
174 
175 
176 library SafeMath {
177 
178     // Multiplies two numbers, throws on overflow.
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         if (a == 0) {
181             return 0;
182         }
183         uint256 c = a * b;
184         assert(c / a == b);
185         return c;
186     }
187 
188     // Integer division of two numbers, truncating the quotient.
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         // assert(b > 0); // Solidity automatically throws when dividing by 0
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193         return c;
194     }
195 
196     // Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         assert(b <= a);
199         return a - b;
200     }
201 
202     // Adds two numbers, throws on overflow.
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         assert(c >= a);
206         return c;
207     }
208 
209     // Min from a/b
210     function min(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a < b ? a : b;
212     }
213 
214     // Max from a/b
215     function max(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a < b ? b : a;
217     }
218 }