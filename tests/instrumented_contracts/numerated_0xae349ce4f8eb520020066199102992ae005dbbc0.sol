1 pragma solidity ^0.4.25;
2 
3 // File: contracts/locker/Ownerable.sol
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
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 contract SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 
52   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
53     return a >= b ? a : b;
54   }
55 
56   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
57     return a < b ? a : b;
58   }
59 
60   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
61     return a >= b ? a : b;
62   }
63 
64   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
65     return a < b ? a : b;
66   }
67 }
68 
69 // File: contracts/token/ERC20Basic.sol
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) public view returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 // File: contracts/token/ERC20.sol
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 // File: contracts/token/SafeERC20.sol
97 
98 /**
99  * @title SafeERC20
100  * @dev Wrappers around ERC20 operations that throw on failure.
101  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
102  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
103  */
104 library SafeERC20 {
105   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
106     assert(token.transfer(to, value));
107   }
108 
109   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
110     assert(token.transferFrom(from, to, value));
111   }
112 
113   function safeApprove(ERC20 token, address spender, uint256 value) internal {
114     assert(token.approve(spender, value));
115   }
116 }
117 
118 // File: contracts/locker/TeamLocker.sol
119 
120 contract TeamLocker is Ownerable, SafeMath {
121   using SafeERC20 for ERC20Basic;
122 
123   ERC20Basic public token;
124   address[] public beneficiaries;
125   uint256 public baiastm;
126   uint256 public releasedAmt;
127 
128   constructor (address _token, address[] _beneficiaries, uint256 _baias) public {
129     require(_token != 0x00);
130     require(_baias != 0x00);
131 
132     for (uint i = 0; i < _beneficiaries.length; i++) {
133       require(_beneficiaries[i] != 0x00);
134     }
135 
136     token = ERC20Basic(_token);
137     beneficiaries = _beneficiaries;
138     baiastm = _baias;
139   }
140 
141   function release() public {
142     require(beneficiaries.length != 0x0);
143 
144     uint256 balance = token.balanceOf(address(this));
145     uint256 total = add(balance, releasedAmt);
146 
147     uint256 lockTime1 = add(baiastm, 183 days); // 6 months
148     uint256 lockTime2 = add(baiastm, 365 days); // 1 year
149 
150     uint256 currentRatio = 0;
151     if (now >= lockTime1) {
152       currentRatio = 50;
153     }
154     if (now >= lockTime2) {
155       currentRatio = 100;  //+50
156     }
157     require(currentRatio > 0);
158 
159     uint256 totalReleaseAmt = div(mul(total, currentRatio), 100);
160     uint256 grantAmt = sub(totalReleaseAmt, releasedAmt);
161     require(grantAmt > 0);
162     releasedAmt = add(releasedAmt, grantAmt);
163 
164     uint256 grantAmountForEach = div(grantAmt, beneficiaries.length);
165     for (uint i = 0; i < beneficiaries.length; i++) {
166         token.safeTransfer(beneficiaries[i], grantAmountForEach);
167     }
168   }
169 
170   function setBaias(uint256 _baias) public onlyOwner {
171     require(_baias != 0x00);
172     baiastm = _baias;
173   }
174 
175   function setToken(address newToken) public onlyOwner {
176     require(newToken != 0x00);
177     token = ERC20Basic(newToken);
178   }
179 
180   function getBeneficiaryCount() public view returns(uint256) {
181     return beneficiaries.length;
182   }
183 
184   function setBeneficiary(uint256 _i, address _addr) public onlyOwner {
185     require(_i < beneficiaries.length);
186     beneficiaries[_i] = _addr;
187   }
188 
189   function claimTokens(address _token) public onlyOwner {
190       if (_token == 0x0) {
191           owner.transfer( address(this).balance);
192           return;
193       }
194 
195       ERC20Basic __token = ERC20Basic(_token);
196       uint balance = __token.balanceOf(address(this));
197       __token.transfer(owner, balance);
198   }
199 
200   function destruct(address to) public onlyOwner returns(bool) {
201       selfdestruct(to);
202       return true;
203   }
204 }