1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 
8 
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     /**
29      * @dev Multiplies two unsigned integers, reverts on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b);
41 
42         return c;
43     }
44 
45     /**
46      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
47      */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0);
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 
57     /**
58      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Adds two unsigned integers, reverts on overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a);
73 
74         return c;
75     }
76 
77     /**
78      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79      * reverts when dividing by zero.
80      */
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0);
83         return a % b;
84     }
85 }
86 
87 contract kangwon is IERC20 {
88 
89     using SafeMath for uint256;
90 
91     mapping (address => uint256) private _balances;
92     mapping (address => mapping (address => uint256)) private _allowed;
93 
94     string public name = "kangwon";
95     string public symbol = "kwkw";
96     uint8 public decimals = 18;
97     uint256 private _totalSupply = 10000000000 * 10 ** uint256(decimals);
98 
99     constructor() public {
100       _balances[msg.sender] = _totalSupply;
101     }
102 
103     function totalSupply() public view returns (uint256) {
104       return _totalSupply;
105     }
106 
107     function balanceOf(address owner) public view returns (uint256) {
108       return _balances[owner];
109     }
110 
111     function allowance(address owner, address spender) public view returns (uint256) {
112       return _allowed[owner][spender];
113     }
114 
115     function transfer(address to, uint256 value) public returns (bool) {
116       _transfer(msg.sender, to, value);
117       return true;
118     }
119 
120     function approve(address spender, uint256 value) public returns (bool) {
121       _approve(msg.sender, spender, value);
122       return true;
123     }
124 
125     function transferFrom(address from, address to, uint256 value) public returns (bool) {
126       _transfer(from, to, value);
127       _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
128       return true;
129     }
130 
131     function burn(uint256 value) public {
132       _burn(msg.sender, value);
133     }
134 
135     function burnFrom(address from, uint256 value) public {
136       _burnFrom(from, value);
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
140       _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
141       return true;
142     }
143 
144     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
145       _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
146       return true;
147     }
148 
149     function _transfer(address from, address to, uint256 value) internal {
150       require(to != address(0));
151 
152       _balances[from] = _balances[from].sub(value);
153       _balances[to] = _balances[to].add(value);
154       emit Transfer(from, to, value);
155     }
156 
157     function _burn(address account, uint256 value) internal {
158       require(account != address(0));
159 
160       _totalSupply = _totalSupply.sub(value);
161       _balances[account] = _balances[account].sub(value);
162       emit Transfer(account, address(0), value);
163     }
164 
165     function _approve(address owner, address spender, uint256 value) internal {
166       require(spender != address(0));
167       require(owner != address(0));
168 
169       _allowed[owner][spender] = value;
170       emit Approval(owner, spender, value);
171     }
172 
173     function _burnFrom(address account, uint256 value) internal {
174       _burn(account, value);
175       _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
176     }
177 }