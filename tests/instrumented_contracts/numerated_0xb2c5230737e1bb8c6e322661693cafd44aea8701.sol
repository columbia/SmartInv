1 // File: contracts/Ownerable.sol
2 
3 pragma solidity ^0.4.23;
4 
5 contract Ownerable {
6     /// @notice The address of the owner is the only address that can call
7     ///  a function with this modifier
8     modifier onlyOwner { require(msg.sender == owner); _; }
9 
10     address public owner;
11 
12     constructor() public { owner = msg.sender;}
13 
14     /// @notice Changes the owner of the contract
15     /// @param _newOwner The new owner of the contract
16     function setOwner(address _newOwner) public onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 // File: contracts/math/SafeMath.sol
22 
23 pragma solidity ^0.4.23;
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 contract SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 
55   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
68     return a < b ? a : b;
69   }
70 }
71 
72 // File: contracts/token/ERC20Basic.sol
73 
74 pragma solidity ^0.4.18;
75 
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 // File: contracts/token/ERC20.sol
90 
91 pragma solidity ^0.4.18;
92 
93 
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public view returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: contracts/token/SafeERC20.sol
107 
108 pragma solidity ^0.4.18;
109 
110 
111 
112 /**
113  * @title SafeERC20
114  * @dev Wrappers around ERC20 operations that throw on failure.
115  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
116  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
117  */
118 library SafeERC20 {
119   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
120     assert(token.transfer(to, value));
121   }
122 
123   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
124     assert(token.transferFrom(from, to, value));
125   }
126 
127   function safeApprove(ERC20 token, address spender, uint256 value) internal {
128     assert(token.approve(spender, value));
129   }
130 }
131 
132 // File: contracts/locker/TeamLocker.sol
133 
134 pragma solidity ^0.4.23;
135 
136 
137 
138 
139 
140 contract TeamLocker is Ownerable, SafeMath {
141   using SafeERC20 for ERC20Basic;
142 
143   ERC20Basic public token;
144   address[] public beneficiaries;
145   uint256 public baiastm;
146   uint256 public releasedAmt;
147 
148   constructor (address _token, address[] _beneficiaries, uint256 _baias) {
149     require(_token != 0x00);
150     require(_baias != 0x00);
151 
152     for (uint i = 0; i < _beneficiaries.length; i++) {
153       require(_beneficiaries[i] != 0x00);
154     }
155 
156     token = ERC20Basic(_token);
157     beneficiaries = _beneficiaries;
158     baiastm = _baias;
159   }
160 
161   function release() public {
162     require(beneficiaries.length != 0x0);
163 
164     uint256 balance = token.balanceOf(address(this));
165     uint256 total = add(balance, releasedAmt);
166 
167     uint256 lockTime1 = add(baiastm, 183 days); // 6 months
168     uint256 lockTime2 = add(baiastm, 365 days); // 1 year
169     uint256 lockTime3 = add(baiastm, 548 days); // 18 months
170 
171     uint256 currentRatio = 0;
172     if (now >= lockTime1) {
173       currentRatio = 20;
174     }
175     if (now >= lockTime2) {
176       currentRatio = 50;  //+30
177     }
178     if (now >= lockTime3) {
179       currentRatio = 100; //+50
180     }
181     require(currentRatio > 0);
182 
183     uint256 totalReleaseAmt = div(mul(total, currentRatio), 100);
184     uint256 grantAmt = sub(totalReleaseAmt, releasedAmt);
185     require(grantAmt > 0);
186     releasedAmt = add(releasedAmt, grantAmt);
187 
188     uint256 grantAmountForEach = div(grantAmt, beneficiaries.length);
189     for (uint i = 0; i < beneficiaries.length; i++) {
190         token.safeTransfer(beneficiaries[i], grantAmountForEach);
191     }
192   }
193 
194   function setBaias(uint256 _baias) public onlyOwner {
195     require(_baias != 0x00);
196     baiastm = _baias;
197   }
198 
199   function setToken(address newToken) public onlyOwner {
200     require(newToken != 0x00);
201     token = ERC20Basic(newToken);
202   }
203 
204   function getBeneficiaryCount() public view returns(uint256) {
205     return beneficiaries.length;
206   }
207 
208   function setBeneficiary(uint256 _i, address _addr) public onlyOwner {
209     require(_i < beneficiaries.length);
210     beneficiaries[_i] = _addr;
211   }
212 }