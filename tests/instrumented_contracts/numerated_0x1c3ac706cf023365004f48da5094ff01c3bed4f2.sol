1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
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
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
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
41         require(b <= a);
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
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract Nutopia is IERC20 {
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     using SafeMath for uint256;
94 
95     mapping (address => uint256) private _balance;
96 
97     mapping (address => mapping (address => uint256)) private _allowed;
98 
99     uint256 private _totalSupply = 10_000_000_000E18;
100 
101     string private _name = "Nutopia Coin";
102     string private _symbol = "NUCO";
103     uint8 private _decimals = 18;
104 
105     address public owner;
106 
107     bool public frozen;
108 
109     modifier onlyOwner {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     modifier checkFrozen {
115         assert(!frozen);
116         _;
117     }
118 
119     constructor() public {
120         owner = msg.sender;
121         frozen = false;
122 
123         // Initial balance
124         _balance[owner] = _totalSupply;
125     }
126 
127     function name() public view returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view returns (uint8) {
136         return _decimals;
137     }
138 
139     function approve(address _spender, uint256 _value) checkFrozen public returns (bool) {
140         require(_spender != address(0));
141 
142         _allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     function transfer(address _to, uint256 _value) checkFrozen public returns (bool) {
148         _transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     function transferFrom(address _from, address _to, uint256 _value) checkFrozen public returns (bool) {
153         _transfer(_from, _to, _value);
154         _allowed[_from][_to] = _allowed[_from][_to].sub(_value);
155         return true;
156     }
157 
158     function _transfer(address from, address to, uint256 value) internal {
159         require(value <= balanceOf(from));
160         require(to != address(0));
161 
162         _balance[from] = _balance[from].sub(value);
163         _balance[to] = _balance[to].add(value);
164         emit Transfer(from, to, value);
165     }
166 
167     function totalSupply() public view returns (uint256) {
168         return _totalSupply;
169     }
170 
171     function allowance(address _owner, address _spender) public view returns (uint256) {
172         return _allowed[_owner][_spender];
173     }
174 
175     function balanceOf(address _owner) public view returns (uint256) {
176         return _balance[_owner];
177     }
178 
179     // Contract owner transfer
180     function ownerTransfer(address newOwner) public onlyOwner {
181         require(newOwner != address(0));
182         emit OwnershipTransferred(owner, newOwner);
183         owner = newOwner;
184     }
185 
186     function freeze() public onlyOwner {
187         frozen = true;
188     }
189 
190     function unfreeze() public onlyOwner {
191         frozen = false;
192     }
193 }