1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title SafeERC20
69  * @dev Wrappers around ERC20 operations that throw on failure.
70  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
71  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
72  */
73 library SafeERC20 {
74   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
75     assert(token.transfer(to, value));
76   }
77 
78   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
79     assert(token.transferFrom(from, to, value));
80   }
81 
82   function safeApprove(ERC20 token, address spender, uint256 value) internal {
83     assert(token.approve(spender, value));
84   }
85 }
86 
87 /**
88  * @title ParetoTreasuryLockup
89  * @dev ParetoTreasuryLockup is a token holder contract that will allow a
90  * beneficiary to extract the tokens after a given release time
91  */
92 contract ParetoTreasuryLockup {
93   using SafeERC20 for ERC20Basic;
94   using SafeMath for uint256;
95 
96   // ERC20 basic token contract being held
97   ERC20Basic public token;
98 
99   // beneficiary of tokens after they are released
100   address public beneficiary;
101 
102   // timestamp when token release is enabled
103   uint256 public releaseTime;
104   
105   uint256 public month = 30 days;
106 
107   uint256 public maxThreshold = 0;
108 
109   function ParetoTreasuryLockup()public {
110     token = ERC20Basic(0xea5f88E54d982Cbb0c441cde4E79bC305e5b43Bc);
111     beneficiary = 0x005d85FE4fcf44C95190Cad3c1bbDA242A62EEB2;
112     releaseTime = now + month;
113   }
114 
115   /**
116    * @notice Transfers tokens held by timelock to beneficiary.
117    */
118   function release() public {
119     require(now >= releaseTime);
120     
121     uint diff = now - releaseTime;
122     if (diff > month){
123         releaseTime = now;
124     }else{
125         releaseTime = now.add(month.sub(diff));
126     }
127     
128     if(maxThreshold == 0){
129         
130         uint256 amount = token.balanceOf(this);
131         require(amount > 0);
132         
133         // calculate 5% of existing amount
134         maxThreshold = (amount.mul(5)).div(100);
135     }
136 
137     token.safeTransfer(beneficiary, maxThreshold);
138     
139   }
140 }