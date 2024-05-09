1 pragma solidity ^0.4.24;
2 interface IERC20 {
3   function totalSupply() external view returns (uint256);
4 
5   function balanceOf(address who) external view returns (uint256);
6 
7   function allowance(address owner, address spender)
8     external view returns (uint256);
9 
10   function transfer(address to, uint256 value) external returns (bool);
11 
12   function approve(address spender, uint256 value)
13     external returns (bool);
14 
15   function transferFrom(address from, address to, uint256 value)
16     external returns (bool);
17 
18   event Transfer(
19     address indexed from,
20     address indexed to,
21     uint256 value
22   );
23 
24   event Approval(
25     address indexed owner,
26     address indexed spender,
27     uint256 value
28   );
29 }
30 
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 
93 contract AzurCoin is IERC20 {
94     using SafeMath for uint256;
95 
96     mapping (address => uint256) private _balances;
97 
98     mapping (address => mapping (address => uint256)) private _allowed;
99 
100     uint256 private _totalSupply;
101 
102     string private _name = "AzurCoin";
103     string private _symbol = "AZU";
104     uint8  private _decimals = 18;
105     uint   private SUPPLY = 1000000000000000000000000000;
106     
107     constructor() public {
108         _totalSupply = SUPPLY;
109         _balances[msg.sender] = SUPPLY;
110     }
111 
112     function name() public view returns(string) {
113         return _name;
114     }
115 
116     function symbol() public view returns(string) {
117         return _symbol;
118     }
119 
120     function decimals() public view returns(uint8) {
121         return _decimals;
122     }
123 
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     function allowance(
133         address owner,
134         address spender
135     )
136         public
137         view
138         returns (uint256)
139     {
140         return _allowed[owner][spender];
141     }
142 
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     function approve(address spender, uint256 value) public returns (bool) {
149         require(spender != address(0));
150 
151         _allowed[msg.sender][spender] = value;
152         emit Approval(msg.sender, spender, value);
153         return true;
154     }
155 
156     function transferFrom(
157         address from,
158         address to,
159         uint256 value
160     )
161         public
162         returns (bool)
163     {
164         require(value <= _allowed[from][msg.sender]);
165 
166         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167         _transfer(from, to, value);
168         return true;
169     }
170 
171     function increaseAllowance(
172         address spender,
173         uint256 addedValue
174     )
175         public
176         returns (bool)
177     {
178         require(spender != address(0));
179 
180         _allowed[msg.sender][spender] = (
181         _allowed[msg.sender][spender].add(addedValue));
182         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
183         return true;
184     }
185 
186 
187     function decreaseAllowance(
188         address spender,
189         uint256 subtractedValue
190     )
191         public
192         returns (bool)
193     {
194         require(spender != address(0));
195 
196         _allowed[msg.sender][spender] = (
197         _allowed[msg.sender][spender].sub(subtractedValue));
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     function _transfer(address from, address to, uint256 value) internal {
203         require(value <= _balances[from]);
204         require(to != address(0));
205 
206         _balances[from] = _balances[from].sub(value);
207         _balances[to] = _balances[to].add(value);
208         emit Transfer(from, to, value);
209     }
210 }