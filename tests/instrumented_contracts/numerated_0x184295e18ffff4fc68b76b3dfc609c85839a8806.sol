1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     int256 constant private INT256_MIN = -2**255;
5 
6     /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Multiplies two signed integers, reverts on overflow.
25     */
26     function mul(int256 a, int256 b) internal pure returns (int256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
35 
36         int256 c = a * b;
37         require(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
44     */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
56     */
57     function div(int256 a, int256 b) internal pure returns (int256) {
58         require(b != 0); // Solidity only automatically asserts when dividing by 0
59         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
60 
61         int256 c = a / b;
62 
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Subtracts two signed integers, reverts on overflow.
78     */
79     function sub(int256 a, int256 b) internal pure returns (int256) {
80         int256 c = a - b;
81         require((b >= 0 && c <= a) || (b < 0 && c > a));
82 
83         return c;
84     }
85 
86     /**
87     * @dev Adds two unsigned integers, reverts on overflow.
88     */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a);
92 
93         return c;
94     }
95 
96     /**
97     * @dev Adds two signed integers, reverts on overflow.
98     */
99     function add(int256 a, int256 b) internal pure returns (int256) {
100         int256 c = a + b;
101         require((b >= 0 && c >= a) || (b < 0 && c < a));
102 
103         return c;
104     }
105 
106     /**
107     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
108     * reverts when dividing by zero.
109     */
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b != 0);
112         return a % b;
113     }
114 }
115 contract owned {
116     address public owner;
117     constructor() public {
118         owner = msg.sender;
119     }
120     modifier onlyOwner {
121         require(msg.sender == owner);
122         _;
123     }
124     function transferOwnership(address newOwner) public onlyOwner {
125         owner = newOwner;
126     }
127 }
128 contract SavitarToken is owned {
129     using SafeMath for uint256;
130     mapping (address => uint256) public balanceOf;
131     mapping(address => mapping(address => uint256)) public allowance;
132     
133     // Token parameters
134     string public name                  = "Savitar Token";
135     string public symbol                = "SVT";
136     uint8 public decimals               = 8;
137     uint256 public totalSupply          = 50000000 * (uint256(10) ** decimals);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140     event Approval(address indexed owner, address indexed spender, uint256 value);
141     constructor() public {
142       // Initially assign all tokens to the contract's creator.
143         balanceOf[msg.sender] = totalSupply;
144         emit Transfer(address(0), msg.sender, totalSupply);
145     }
146     function transfer(address to, uint256 value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= value);
148         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
149         balanceOf[to] = balanceOf[to].add(value);
150         emit Transfer(msg.sender, to, value);
151         return true;
152     }
153     function approve(address spender, uint256 value) public returns (bool success) {
154         allowance[msg.sender][spender] = value;
155         emit Approval(msg.sender, spender, value);
156         return true;
157     }
158     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
159         require(value <= balanceOf[from]);
160         require(value <= allowance[from][msg.sender]);
161         balanceOf[from] = balanceOf[from].sub(value);
162         balanceOf[to] = balanceOf[to].add(value);
163         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
164         emit Transfer(from, to, value);
165         return true;
166     }
167 }