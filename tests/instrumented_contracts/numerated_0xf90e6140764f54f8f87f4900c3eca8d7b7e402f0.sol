1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.7.4;
3 pragma experimental ABIEncoderV2;
4 
5 library Roles {
6     struct Role {
7         mapping (address => bool) bearer;
8     }
9 
10     function add(Role storage role, address account) internal {
11         require(!has(role, account), "role already has the account");
12         role.bearer[account] = true;
13     }
14 
15     function remove(Role storage role, address account) internal {
16         require(has(role, account), "role dosen't have the account");
17         role.bearer[account] = false;
18     }
19 
20     function has(Role storage role, address account) internal view returns (bool) {
21         return role.bearer[account];
22     }
23 }
24 
25 library Uint96 {
26 
27     function cast(uint256 a) public pure returns (uint96) {
28         require(a < 2**96);
29         return uint96(a);
30     }
31 
32     function add(uint96 a, uint96 b) internal pure returns (uint96) {
33         uint96 c = a + b;
34         require(c >= a, "addition overflow");
35         return c;
36     }
37 
38     function sub(uint96 a, uint96 b) internal pure returns (uint96) {
39         require(a >= b, "subtraction overflow");
40         return a - b;
41     }
42 
43     function mul(uint96 a, uint96 b) internal pure returns (uint96) {
44         if (a == 0) {
45             return 0;
46         }
47         uint96 c = a * b;
48         require(c / a == b, "multiplication overflow");
49         return c;
50     }
51 
52     function div(uint96 a, uint96 b) internal pure returns (uint96) {
53         require(b != 0, "division by 0");
54         return a / b;
55     }
56 
57     function mod(uint96 a, uint96 b) internal pure returns (uint96) {
58         require(b != 0, "modulo by 0");
59         return a % b;
60     }
61 
62     function toString(uint96 a) internal pure returns (string memory) {
63         bytes32 retBytes32;
64         uint96 len = 0;
65         if (a == 0) {
66             retBytes32 = "0";
67             len++;
68         } else {
69             uint96 value = a;
70             while (value > 0) {
71                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
72                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
73                 value /= 10;
74                 len++;
75             }
76         }
77 
78         bytes memory ret = new bytes(len);
79         uint96 i;
80 
81         for (i = 0; i < len; i++) {
82             ret[i] = retBytes32[i];
83         }
84         return string(ret);
85     }
86 }
87 
88 interface IERC20 {
89     function totalSupply() external view returns (uint256);
90     function balanceOf(address account) external view returns (uint256);
91     function transfer(address recipient, uint256 amount) external returns (bool);
92     function allowance(address owner, address spender) external view returns (uint256);
93     function approve(address spender, uint256 amount) external returns (bool);
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Optionals {
100     function name() external view returns (string memory);
101     function symbol() external view returns (string memory);
102     function decimals() external view returns (uint8);
103 }
104 contract Operatable {
105     using Roles for Roles.Role;
106 
107     event OperatorAdded(address indexed account);
108     event OperatorRemoved(address indexed account);
109 
110     event Paused(address account);
111     event Unpaused(address account);
112 
113     bool private _paused;
114     Roles.Role private operators;
115 
116     constructor() {
117         operators.add(msg.sender);
118         _paused = false;
119     }
120 
121     modifier onlyOperator() {
122         require(isOperator(msg.sender), "Must be operator");
123         _;
124     }
125 
126     modifier whenNotPaused() {
127         require(!_paused, "Pausable: paused");
128         _;
129     }
130 
131     modifier whenPaused() {
132         require(_paused, "Pausable: not paused");
133         _;
134     }
135 
136     function isOperator(address account) public view returns (bool) {
137         return operators.has(account);
138     }
139 
140     function addOperator(address account) public onlyOperator() {
141         operators.add(account);
142         emit OperatorAdded(account);
143     }
144 
145     function removeOperator(address account) public onlyOperator() {
146         operators.remove(account);
147         emit OperatorRemoved(account);
148     }
149 
150     function paused() public view returns (bool) {
151         return _paused;
152     }
153 
154     function pause() public onlyOperator() whenNotPaused() {
155         _paused = true;
156         emit Paused(msg.sender);
157     }
158 
159     function unpause() public onlyOperator() whenPaused() {
160         _paused = false;
161         emit Unpaused(msg.sender);
162     }
163 
164     function withdrawEther() public onlyOperator() {
165         msg.sender.transfer(address(this).balance);
166     }
167 
168 }
169 
170 contract MCHCMine is Operatable {
171     using Uint96 for uint96;
172 
173     event Claim(address indexed owner, uint96 value);
174     event Value(address indexed owner, uint96 value);
175 
176     struct Balance {
177         address recipient;
178         uint96 value;
179     }
180 
181     IERC20 public token;
182     address public validator;
183     mapping(address => uint96) public claimed;
184 
185     constructor(IERC20 _token, address _validator) {
186         token = _token;
187         validator = _validator;
188     }
189 
190     function claim(Balance memory _balance, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
191         require(ecrecover(toEthSignedMessageHash(prepareMessage(_balance)), v, r, s) == validator, "Mine: invalid claim signature");
192         require(_balance.recipient == msg.sender, "Mine: receipient must be sender");
193         
194         address recipient = _balance.recipient;
195         uint96 toClaim = _balance.value.sub(claimed[recipient]);
196         require(toClaim > 0, "Mine: nothing to claim");
197         claimed[recipient] = _balance.value;
198         require(token.transfer(msg.sender, toClaim), "Mine: mint is not successful");
199         emit Claim(recipient, toClaim);
200         emit Value(recipient, claimed[recipient]);
201     }
202 
203     function doOverride(Balance[] memory _balances) external onlyOperator {
204         for (uint i = 0; i < _balances.length; i++) {
205             claimed[_balances[i].recipient] = _balances[i].value;
206             emit Value(_balances[i].recipient, _balances[i].value);
207         }
208     }
209 
210     function prepareMessage(Balance memory _balance) internal pure returns (bytes32) {
211         return keccak256(abi.encode(_balance));
212     }
213     
214     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
215         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
216     }
217 
218     function withdraw() external onlyOperator {
219         token.transfer(msg.sender, token.balanceOf(address(this)));
220     }
221 }