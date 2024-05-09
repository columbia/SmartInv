1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeMath {
33 
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     uint256 c = a * b;
43     require(c / a == b);
44 
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b > 0); // Solidity only automatically asserts when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b <= a);
58     uint256 c = a - b;
59 
60     return c;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     require(c >= a);
66 
67     return c;
68   }
69 
70   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b != 0);
72     return a % b;
73   }
74 }
75 
76 contract YDUP is IERC20 {
77   using SafeMath for uint256;
78 
79   mapping (address => uint256) private _balances;
80 
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   uint256 private _totalSupply;
84 
85   string private _name;
86   string private _symbol;
87   uint8 private _decimals;
88 
89   constructor() public {
90   
91     _name = "YDUP";
92     _symbol = "YDUP";
93     _decimals = 18;
94 	
95 	_totalSupply = 1024 * 10 ** 18;
96 	_balances[msg.sender] = _totalSupply;
97 	
98 	emit Transfer(address(0), msg.sender, _totalSupply);
99   }
100 
101   /**
102    * @return the name of the token.
103    */
104   function name() public view returns(string) {
105     return _name;
106   }
107 
108   /**
109    * @return the symbol of the token.
110    */
111   function symbol() public view returns(string) {
112     return _symbol;
113   }
114 
115   /**
116    * @return the number of decimals of the token.
117    */
118   function decimals() public view returns(uint8) {
119     return _decimals;
120   }
121   
122   
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   function balanceOf(address owner) public view returns (uint256) {
128     return _balances[owner];
129   }
130 
131   function allowance(
132     address owner,
133     address spender
134    )
135     public
136     view
137     returns (uint256)
138   {
139     return _allowed[owner][spender];
140   }
141 
142   function transfer(address to, uint256 value) public returns (bool) {
143     require(value <= _balances[msg.sender]);
144     require(to != address(0));
145 
146     _balances[msg.sender] = _balances[msg.sender].sub(value);
147     _balances[to] = _balances[to].add(value);
148     emit Transfer(msg.sender, to, value);
149     return true;
150   }
151 
152   function approve(address spender, uint256 value) public returns (bool) {
153     require(spender != address(0));
154 
155     _allowed[msg.sender][spender] = value;
156     emit Approval(msg.sender, spender, value);
157     return true;
158   }
159 
160   function transferFrom(
161     address from,
162     address to,
163     uint256 value
164   )
165     public
166     returns (bool)
167   {
168     require(value <= _balances[from]);
169     require(value <= _allowed[from][msg.sender]);
170     require(to != address(0));
171 
172     _balances[from] = _balances[from].sub(value);
173     _balances[to] = _balances[to].add(value);
174     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
175     emit Transfer(from, to, value);
176     return true;
177   }
178 }