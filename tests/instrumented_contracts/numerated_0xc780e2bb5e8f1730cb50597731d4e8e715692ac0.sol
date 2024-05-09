1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         //        require(b <= a, "SafeMath: subtraction overflow");
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         //        require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 contract ERC20Interface {
68 
69     // Getters
70     function totalSupply() public view returns (uint);
71 
72     function balanceOf(address tokenOwner) public view returns (uint balance);
73 
74     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
75 
76     // Write the State
77     function transfer(address to, uint tokens) public returns (bool success);
78 
79     function approve(address spender, uint tokens) public returns (bool success);
80 
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83     // Events
84     event Transfer(address indexed from, address indexed to, uint tokens);
85     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86 
87 }
88 
89 contract ERC20 is ERC20Interface {
90 
91     // Link the SafeMath library
92     using SafeMath for uint;
93 
94     // declare the storage
95     mapping(address => mapping(address => uint)) private _allowance;
96     mapping(address => uint) internal _balanceOf;
97 
98     uint internal _totalSupply;
99 
100     uint8 public constant decimals = 18;
101 
102     function _transfer(address from, address to, uint tokens) private returns (bool success) {
103         _balanceOf[from] = _balanceOf[from].sub(tokens);
104         _balanceOf[to] = _balanceOf[to].add(tokens);
105 
106         success = true;
107 
108         emit Transfer(from, to, tokens);
109     }
110 
111     // Getters
112     function totalSupply() public view returns (uint) {
113         return _totalSupply;
114     }
115 
116     function balanceOf(address tokenOwner) public view returns (uint balance) {
117         balance = _balanceOf[tokenOwner];
118     }
119 
120     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
121         remaining = _allowance[tokenOwner][spender];
122         return remaining;
123     }
124 
125     // Write the State
126     function transfer(address to, uint tokens) public returns (bool success) {
127         success = _transfer(msg.sender, to, tokens);
128     }
129 
130     function approve(address spender, uint tokens) public returns (bool success) {
131         _allowance[msg.sender][spender] = tokens;
132 
133         success = true;
134 
135         emit Approval(msg.sender, spender, tokens);
136     }
137 
138     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
139         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(tokens);
140 
141         success = _transfer(from, to, tokens);
142     }
143 
144 }
145 
146 contract Ownerable {
147     address public owner;
148 
149     constructor () public {
150         owner = msg.sender;
151     }
152 
153     function setOwner(address newOwner) onlyOwner public {
154         owner = newOwner;
155     }
156 
157     modifier onlyOwner {
158         require(msg.sender == owner, "Only owner can perform this tx.");
159         _;
160     }
161 }
162 
163 contract CryptoDa is ERC20, Ownerable {
164     string public constant name = "CryptoDa";
165     string public constant symbol = "CDA";
166 
167     address public issuer = address(0);
168 
169     constructor (address _issuer) public {
170         _totalSupply = 5000000 ether;
171         issuer = _issuer;
172         _balanceOf[issuer] = _totalSupply;
173     }
174 
175     function setIssuer(address newIssuer) public onlyOwner returns (bool success){
176         require(newIssuer != address(0), "Cannot set 0x0 as a new issuer address.");
177 
178         if (issuer != address(0)) {
179             _balanceOf[newIssuer] = _balanceOf[issuer];
180             _balanceOf[issuer] = 0;
181         }
182 
183         issuer = newIssuer;
184 
185         success = true;
186     }
187 }