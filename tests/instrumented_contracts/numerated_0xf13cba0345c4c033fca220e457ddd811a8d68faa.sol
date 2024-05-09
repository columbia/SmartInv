1 pragma solidity ^0.5.1;
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
108 contract TBDToken is IERC20, Owned {
109     using SafeMath for uint256;
110     
111     // Constructor - Sets the token Owner
112     constructor() public {
113         owner = 0x21553F98Ce782Da4AE52e868B2c0bAC5964DEe29;
114         contractAddress = address(this);
115         _balances[owner] = supply;
116         emit Transfer(address(0), owner, supply);
117     }
118     
119     // Events
120     event Error(string err);
121     event Mint(uint mintAmount, address to);
122     event Burn(uint burnAmount, address from);
123     
124     // Token Setup
125     string public constant name = "Tiffany Brown Designs Token";
126     string public constant symbol = "TBD";
127     uint256 public constant decimals = 18;
128     uint256 public supply = 1000000000 * 10 ** decimals; // 1 Billion Tokens
129     
130     address private contractAddress;
131     uint256 public ICOPrice;
132     
133     // Balances for each account
134     mapping(address => uint256) _balances;
135  
136     // Owner of account approves the transfer of an amount to another account
137     mapping(address => mapping (address => uint256)) public _allowed;
138  
139     // Get the total supply of tokens
140     function totalSupply() public view returns (uint) {
141         return supply;
142     }
143  
144     // Get the token balance for account `tokenOwner`
145     function balanceOf(address tokenOwner) public view returns (uint balance) {
146         return _balances[tokenOwner];
147     }
148  
149     // Get the allowance of funds beteen a token holder and a spender
150     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
151         return _allowed[tokenOwner][spender];
152     }
153  
154     // Transfer the balance from owner's account to another account
155     function transfer(address to, uint value) public returns (bool success) {
156         require(_balances[msg.sender] >= value);
157         require(to != contractAddress);
158         _balances[msg.sender] = _balances[msg.sender].sub(value);
159         _balances[to] = _balances[to].add(value);
160         emit Transfer(msg.sender, to, value);
161         return true;
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
175         _balances[from] = _balances[from].sub(value);
176         _balances[to] = _balances[to].add(value);
177         _allowed[from][to] = _allowed[from][to].sub(value);
178         emit Transfer(from, to, value);
179         return true;
180     }
181     
182     // Users Cannot acidentaly send ETH to the contract
183     function () external payable {
184         revert();
185     }
186     
187     // Owner Can mint new tokens
188     function mint(uint256 amount, address to) public onlyOwner {
189         _balances[to] = _balances[to].add(amount);
190         supply = supply.add(amount);
191         emit Mint(amount, to);
192     }
193     
194     // Owner can burn existing tokens
195     function burn(uint256 amount, address from) public onlyOwner {
196         require(_balances[from] >= amount);
197         _balances[from] = _balances[from].sub(amount);
198         supply = supply.sub(amount);
199         emit Burn(amount, from);
200     }
201     
202     // Change ICO Price
203     function setICOPrice(uint256 _newPrice) public onlyOwner {
204         ICOPrice = _newPrice;
205     }
206     
207     // See how many tokens are available to be purcahsed.
208     function getRemainingICOBalance() public view returns (uint256) {
209         return _balances[contractAddress];
210     }
211     
212     // Top up ICO balance
213     function topUpICO(uint256 _amount) public onlyOwner {
214         require(_balances[owner] >= _amount);
215         _balances[owner] = _balances[owner].sub(_amount);
216         _balances[contractAddress] = _balances[contractAddress].add(_amount);
217         emit Transfer(msg.sender, contractAddress, _amount);
218     }
219     
220     
221     // Buy tokens
222     function buyTokens() public payable {
223         require(ICOPrice > 0);
224         require(msg.value >= ICOPrice);
225         uint256 affordAmount = msg.value / ICOPrice;
226         require(_balances[contractAddress] >= affordAmount * 10 ** decimals);
227         _balances[contractAddress] = _balances[contractAddress].sub(affordAmount * 10 ** decimals);
228         _balances[msg.sender] = _balances[msg.sender].add(affordAmount * 10 ** decimals);
229         emit Transfer(contractAddress, msg.sender, affordAmount * 10 ** decimals);
230     }
231     
232     // Withdraw ETH
233     function withdrawContractBalance() public onlyOwner {
234         msg.sender.transfer(contractAddress.balance);
235     }
236     
237     // Cancel and withdraw ICO tokens
238     function withdrawContractTokens(uint256 _amount) public onlyOwner {
239         require(_balances[contractAddress] >= _amount);
240         _balances[contractAddress] = _balances[contractAddress].sub(_amount);
241         _balances[owner] = _balances[owner].add(_amount);
242         emit Transfer(contractAddress, owner, _amount);
243     }
244 }