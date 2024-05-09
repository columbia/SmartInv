1 pragma solidity ^0.5.2;
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
92 contract Owned {
93     address public owner;
94     address public newOwner;
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         owner = newOwner;
105     }
106 }
107 
108 
109 contract BITFRIENDZ is IERC20, Owned {
110     using SafeMath for uint256;
111     
112     // Constructor - Sets the token Owner
113     constructor() public {
114         owner = msg.sender;
115         _balances[0x14fBA4aa05AEeC42336CB75bc30bF78dbC6b3f9F] = 2000000000 * 10 ** decimals;
116         emit Transfer(address(0), 0x14fBA4aa05AEeC42336CB75bc30bF78dbC6b3f9F, 2000000000 * 10 ** decimals);
117         _balances[0xdA78d97Fb07d945691916798CFF57324770a6C34] = 2000000000 * 10 ** decimals;
118         emit Transfer(address(0), 0xdA78d97Fb07d945691916798CFF57324770a6C34, 2000000000 * 10 ** decimals);
119         _balances[0xF07e6A0EAbF18A3D8bB10e6E63c2E9e2d101C160] = 1000000000 * 10 ** decimals;
120         emit Transfer(address(0), 0xF07e6A0EAbF18A3D8bB10e6E63c2E9e2d101C160, 1000000000 * 10 ** decimals);
121         _balances[address(this)] = 15000000000 * 10 ** decimals;
122         emit Transfer(address(0), address(this), 15000000000 * 10 ** decimals);
123     }
124     
125     // Events
126     event Error(string err);
127     
128     // Token Setup
129     string public constant name = "BITFRIENDZ";
130     string public constant symbol = "BFRN";
131     uint256 public constant decimals = 18;
132     uint256 public supply = 20000000000 * 10 ** decimals;
133     
134     uint256 public tokenPrice = 50000000000;
135     
136     // Balances for each account
137     mapping(address => uint256) _balances;
138  
139     // Owner of account approves the transfer of an amount to another account
140     mapping(address => mapping (address => uint256)) public _allowed;
141  
142     // Get the total supply of tokens
143     function totalSupply() public view returns (uint) {
144         return supply;
145     }
146  
147     // Get the token balance for account `tokenOwner`
148     function balanceOf(address tokenOwner) public view returns (uint balance) {
149         return _balances[tokenOwner];
150     }
151  
152     // Get the allowance of funds beteen a token holder and a spender
153     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
154         return _allowed[tokenOwner][spender];
155     }
156  
157     // Transfer the balance from owner's account to another account
158     function transfer(address to, uint value) public returns (bool success) {
159         require(_balances[msg.sender] >= value);
160         if (to == address(this) || to == address(0)) {
161             burn(value);
162             return true;
163         } else {
164             _balances[msg.sender] = _balances[msg.sender].sub(value);
165             _balances[to] = _balances[to].add(value);
166             emit Transfer(msg.sender, to, value);
167             return true;
168         }
169     }
170     
171     // Sets how much a sender is allowed to use of an owners funds
172     function approve(address spender, uint value) public returns (bool success) {
173         _allowed[msg.sender][spender] = value;
174         emit Approval(msg.sender, spender, value);
175         return true;
176     }
177     
178     // Transfer from function, pulls from allowance
179     function transferFrom(address from, address to, uint value) public returns (bool success) {
180         require(value <= balanceOf(from));
181         require(value <= allowance(from, to));
182         _balances[from] = _balances[from].sub(value);
183         _balances[to] = _balances[to].add(value);
184         _allowed[from][to] = _allowed[from][to].sub(value);
185         emit Transfer(from, to, value);
186         return true;
187     }
188     
189     function () external payable {
190         require(msg.value >= tokenPrice);
191         uint256 amount = (msg.value * 10 ** decimals) / tokenPrice;
192         uint256 bonus = 0;
193         if (msg.value >= 1 ether && msg.value < 2 ether) {
194             bonus = (((amount * 100) + (amount * 25)) / 100);
195         } else if (msg.value >= 2 ether && msg.value < 4 ether) {
196             bonus = (((amount * 100) + (amount * 50)) / 100);
197         } else if (msg.value >= 4 ether && msg.value < 5 ether) {
198             bonus = (((amount * 10000) + (amount * 5625)) / 10000);
199         } else if (msg.value >= 5 ether) {
200             bonus = (((amount * 100) + (amount * 75)) / 100);
201         }
202         if (_balances[address(this)] < amount + bonus) {
203             revert();
204         }
205         _balances[address(this)] = _balances[address(this)].sub(amount + bonus);
206         _balances[msg.sender] = _balances[msg.sender].add(amount + bonus);
207         emit Transfer(address(this), msg.sender, amount + bonus);
208     }
209     
210     function BuyTokens() public payable {
211         require(msg.value >= tokenPrice);
212         uint256 amount = (msg.value * 10 ** decimals) / tokenPrice;
213         uint256 bonus = 0;
214         if (msg.value >= 1 ether && msg.value < 2 ether) {
215             bonus = (((amount * 100) + (amount * 25)) / 100);
216         } else if (msg.value >= 2 ether && msg.value < 4 ether) {
217             bonus = (((amount * 100) + (amount * 50)) / 100);
218         } else if (msg.value >= 4 ether && msg.value < 5 ether) {
219             bonus = (((amount * 10000) + (amount * 5625)) / 10000);
220         } else if (msg.value >= 5 ether) {
221             bonus = (((amount * 100) + (amount * 75)) / 100);
222         }
223         if (_balances[address(this)] < amount + bonus) {
224             revert();
225         }
226         _balances[address(this)] = _balances[address(this)].sub(amount + bonus);
227         _balances[msg.sender] = _balances[msg.sender].add(amount + bonus);
228         emit Transfer(address(this), msg.sender, amount + bonus);
229     }
230     
231     function endICO() public onlyOwner {
232         _balances[msg.sender] = _balances[msg.sender].sub(_balances[address(this)]);
233         msg.sender.transfer(address(this).balance);
234     }
235     
236     function burn(uint256 amount) public {
237         require(_balances[msg.sender] >= amount);
238         _balances[msg.sender] = _balances[msg.sender].sub(amount);
239         supply = supply.sub(amount);
240         emit Transfer(msg.sender, address(0), amount);
241     }
242 }