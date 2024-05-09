1 pragma solidity ^0.4.24;
2 
3 contract ERC20Token {
4 
5       string public name = "DemoICO";
6       string public symbol = "DICO";
7       uint8 public decimals = 0;
8       uint public INITIAL_SUPPLY = 10000 * (uint256(10) ** decimals);
9 
10       constructor() public {
11           _mint(msg.sender, INITIAL_SUPPLY);
12       }
13 
14       event Transfer(
15         address indexed from,
16         address indexed to,
17         uint256 value
18       );
19 
20       event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 value
24       );
25 
26       using SafeMath for uint256;
27       mapping (address => uint256) private _balances;
28       mapping (address => mapping (address => uint256)) private _allowed;
29       uint256 private _totalSupply;
30 
31       function totalSupply() public view returns (uint256) {
32         return _totalSupply;
33       }
34 
35       function balanceOf(address owner) public view returns (uint256) {
36         return _balances[owner];
37       }
38 
39       function allowance(
40         address owner,
41         address spender
42        )
43         public
44         view
45         returns (uint256)
46       {
47         return _allowed[owner][spender];
48       }
49 
50       function transfer(address to, uint256 value) public returns (bool) {
51         _transfer(msg.sender, to, value);
52         return true;
53       }
54 
55       function approve(address spender, uint256 value) public returns (bool) {
56         require(spender != address(0));
57         _allowed[msg.sender][spender] = value;
58         emit Approval(msg.sender, spender, value);
59         return true;
60       }
61 
62       function transferFrom(
63         address from,
64         address to,
65         uint256 value
66       )
67         public
68         returns (bool)
69       {
70         require(value <= _allowed[from][msg.sender]);
71 
72         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
73         _transfer(from, to, value);
74         return true;
75       }
76 
77       function increaseAllowance(
78         address spender,
79         uint256 addedValue
80       )
81         public
82         returns (bool)
83       {
84         require(spender != address(0));
85         _allowed[msg.sender][spender] = (
86           _allowed[msg.sender][spender].add(addedValue));
87         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
88         return true;
89       }
90 
91       function decreaseAllowance(
92         address spender,
93         uint256 subtractedValue
94       )
95         public
96         returns (bool)
97       {
98         require(spender != address(0));
99 
100         _allowed[msg.sender][spender] = (
101           _allowed[msg.sender][spender].sub(subtractedValue));
102         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
103         return true;
104       }
105 
106       function _transfer(address from, address to, uint256 value) internal {
107         require(value <= _balances[from]);
108         require(to != address(0));
109 
110         _balances[from] = _balances[from].sub(value);
111         _balances[to] = _balances[to].add(value);
112         emit Transfer(from, to, value);
113       }
114 
115       function _mint(address account, uint256 value) internal {
116         require(account != 0);
117         _totalSupply = _totalSupply.add(value);
118         _balances[account] = _balances[account].add(value);
119         emit Transfer(address(0), account, value);
120       }
121 
122       function _burn(address account, uint256 value) internal {
123         require(account != 0);
124         require(value <= _balances[account]);
125 
126         _totalSupply = _totalSupply.sub(value);
127         _balances[account] = _balances[account].sub(value);
128         emit Transfer(account, address(0), value);
129       }
130 
131       function _burnFrom(address account, uint256 value) internal {
132         require(value <= _allowed[account][msg.sender]);
133         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
134           value);
135         _burn(account, value);
136       }
137 
138 }
139 
140 library SafeMath {
141       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         if (a == 0) {
143           return 0;
144         }
145         uint256 c = a * b;
146         require(c / a == b);
147         return c;
148       }
149       function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         require(b > 0);
151         uint256 c = a / b;
152         return c;
153       }
154       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b <= a);
156         uint256 c = a - b;
157         return c;
158       }
159       function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a);
162         return c;
163       }
164       function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b != 0);
166         return a % b;
167       }
168 }