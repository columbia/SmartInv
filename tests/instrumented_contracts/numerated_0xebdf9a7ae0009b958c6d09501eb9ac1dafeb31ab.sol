1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     /**
23      * @dev Multiplies two unsigned integers, reverts on overflow.
24      */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41      */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Adds two unsigned integers, reverts on overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73      * reverts when dividing by zero.
74      */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 
82 contract REDiToken is IERC20 {
83 
84     using SafeMath for uint256;
85 
86     mapping (address => uint256) private _balances;
87     mapping (address => mapping (address => uint256)) private _allowed;
88 
89     string public name = "REDiToken";
90     string public symbol = "REDi";
91     uint8 public decimals = 18;
92     uint256 private _totalSupply = 10000000000 * 10 ** uint256(decimals);
93 
94     constructor() public {
95       _balances[msg.sender] = _totalSupply;
96     }
97 
98     function totalSupply() public view returns (uint256) {
99       return _totalSupply;
100     }
101 
102     function balanceOf(address owner) public view returns (uint256) {
103       return _balances[owner];
104     }
105 
106     function allowance(address owner, address spender) public view returns (uint256) {
107       return _allowed[owner][spender];
108     }
109 
110     function transfer(address to, uint256 value) public returns (bool) {
111       _transfer(msg.sender, to, value);
112       return true;
113     }
114 
115     function approve(address spender, uint256 value) public returns (bool) {
116       _approve(msg.sender, spender, value);
117       return true;
118     }
119 
120     function transferFrom(address from, address to, uint256 value) public returns (bool) {
121       _transfer(from, to, value);
122       _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
123       return true;
124     }
125 
126     function burn(uint256 value) public {
127       _burn(msg.sender, value);
128     }
129 
130     function burnFrom(address from, uint256 value) public {
131       _burnFrom(from, value);
132     }
133 
134     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
135       _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
136       return true;
137     }
138 
139     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
140       _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
141       return true;
142     }
143 
144     function _transfer(address from, address to, uint256 value) internal {
145       require(to != address(0));
146 
147       _balances[from] = _balances[from].sub(value);
148       _balances[to] = _balances[to].add(value);
149       emit Transfer(from, to, value);
150     }
151 
152     function _burn(address account, uint256 value) internal {
153       require(account != address(0));
154 
155       _totalSupply = _totalSupply.sub(value);
156       _balances[account] = _balances[account].sub(value);
157       emit Transfer(account, address(0), value);
158     }
159 
160     function _approve(address owner, address spender, uint256 value) internal {
161       require(spender != address(0));
162       require(owner != address(0));
163 
164       _allowed[owner][spender] = value;
165       emit Approval(owner, spender, value);
166     }
167 
168     function _burnFrom(address account, uint256 value) internal {
169       _burn(account, value);
170       _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
171     }
172 }