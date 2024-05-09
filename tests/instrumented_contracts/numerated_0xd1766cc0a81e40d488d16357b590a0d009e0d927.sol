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
108 contract Boxroi is IERC20, Owned {
109     using SafeMath for uint256;
110     
111     // Constructor - Sets the token Owner
112     constructor() public {
113         owner = 0xaDdFB942659bDD72b389b50A8BEb3Dbb75C43780;
114         _balances[owner] = 89000000 * 10 ** decimals;
115         emit Transfer(address(0), owner, 89000000 * 10 ** decimals);
116     }
117     
118     // Token Setup
119     string public constant name = "Boxroi";
120     string public constant symbol = "BXI";
121     uint256 public constant decimals = 18;
122     uint256 public supply = 89000000 * 10 ** decimals;
123     uint256 private nonce;
124     address public BXIT;
125     
126     // Balances for each account
127     mapping(address => uint256) _balances;
128  
129     // Owner of account approves the transfer of an amount to another account
130     mapping(address => mapping (address => uint256)) public _allowed;
131  
132     // Get the total supply of tokens
133     function totalSupply() public view returns (uint) {
134         return supply;
135     }
136  
137     // Get the token balance for account `tokenOwner`
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return _balances[tokenOwner];
140     }
141  
142     // Get the allowance of funds beteen a token holder and a spender
143     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
144         return _allowed[tokenOwner][spender];
145     }
146  
147     // Transfer the balance from owner's account to another account
148     function transfer(address to, uint value) public returns (bool success) {
149         require(_balances[msg.sender] >= value);
150         if (to == BXIT || to == address(this)) {
151             _balances[msg.sender] = _balances[msg.sender].sub(value);
152             supply = supply.sub(value);
153             emit Transfer(msg.sender, address(0), value);
154             burn(msg.sender, value);
155             return true;
156         } else {
157             _balances[msg.sender] = _balances[msg.sender].sub(value);
158             _balances[to] = _balances[to].add(value);
159             emit Transfer(msg.sender, to, value);
160             return true;
161         }
162     }
163     
164     // Sets how much a sender is allowed to use of an owners funds
165     function approve(address spender, uint value) public returns (bool success) {
166         _allowed[msg.sender][spender] = value;
167         emit Approval(msg.sender, spender, value);
168         return true;
169     }
170     
171     // Transfer from function, pulls from allowance
172     function transferFrom(address from, address to, uint value) public returns (bool success) {
173         require(value <= balanceOf(from));
174         require(value <= allowance(from, to));
175         if (to == BXIT || to == address(this)) {
176             _balances[from] = _balances[from].sub(value);
177             supply = supply.sub(value);
178             emit Transfer(from, address(0), value);
179             burn(from, value);
180             return true;
181         } else {
182             _balances[from] = _balances[from].sub(value);
183             _balances[to] = _balances[to].add(value);
184             _allowed[from][to] = _allowed[from][to].sub(value);
185             emit Transfer(from, to, value);
186             return true;
187         }
188     }
189     
190     // Revert when sent Ether
191     function () external payable {
192         revert();
193     }
194     
195     // Owner can mint new tokens, but supply cannot exceed 89 Million
196     function mint(uint256 amount) public onlyOwner {
197         require(amount <= (89000000 * 10 ** decimals) - supply);
198         _balances[msg.sender] = _balances[msg.sender].add(amount);
199         supply = supply.add(amount);
200         emit Transfer(address(0), msg.sender, amount);
201     }
202     
203     // Called by sending tokens to the contract address
204     // Anyone can burn their tokens and could be sent BXIT if they are lucky
205     function burn(address burner, uint256 amount) internal {
206         uint256 random = uint(keccak256(abi.encodePacked(block.difficulty,now,block.number, nonce))) % 999;
207         nonce++;
208         if (random > 983) {
209             uint256 _amount = amount / 100;
210             IERC20(BXIT).transfer(burner, _amount);
211         }
212     }
213     
214     // Owner should initially set the BXIT contract address
215     function setBXITAddress(address _address) public onlyOwner {
216         BXIT = _address;
217     }
218 }