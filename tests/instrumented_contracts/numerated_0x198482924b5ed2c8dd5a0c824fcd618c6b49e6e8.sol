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
108 contract RICHToken is IERC20, Owned {
109     using SafeMath for uint256;
110     
111     // Constructor - Sets the token Owner
112     constructor() public {
113         owner = 0x23a79F63133D315e7C16E3AF68701a7cD92217F9;
114         contractAddress = address(this);
115         _balances[owner] = 4950000000 * 10 ** 18;
116         _balances[contractAddress] = 50000000 * 10 ** 18;
117         emit Transfer(address(0), owner, 4950000000 * 10 ** 18);
118         emit Transfer(address(0), contractAddress, 50000000 * 10 ** 18);
119     }
120     
121     // Events
122     event Error(string err);
123     event Mint(uint mintAmount, address to);
124     event Burn(uint burnAmount, address from);
125     
126     // Token Setup
127     string public constant name = "Ultra Rich Group";
128     string public constant symbol = "RICH";
129     uint256 public constant decimals = 18;
130     uint256 public supply = 5000000000 * 10 ** decimals;
131     
132     address private contractAddress;
133     uint256 public ICOPrice;
134     
135     // Balances for each account
136     mapping(address => uint256) _balances;
137  
138     // Owner of account approves the transfer of an amount to another account
139     mapping(address => mapping (address => uint256)) public _allowed;
140  
141     // Get the total supply of tokens
142     function totalSupply() public view returns (uint) {
143         return supply;
144     }
145  
146     // Get the token balance for account `tokenOwner`
147     function balanceOf(address tokenOwner) public view returns (uint balance) {
148         return _balances[tokenOwner];
149     }
150  
151     // Get the allowance of funds beteen a token holder and a spender
152     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
153         return _allowed[tokenOwner][spender];
154     }
155  
156     // Transfer the balance from owner's account to another account
157     function transfer(address to, uint value) public returns (bool success) {
158         require(_balances[msg.sender] >= value);
159         require(to != contractAddress);
160         _balances[msg.sender] = _balances[msg.sender].sub(value);
161         _balances[to] = _balances[to].add(value);
162         emit Transfer(msg.sender, to, value);
163         return true;
164     }
165     
166     // Sets how much a sender is allowed to use of an owners funds
167     function approve(address spender, uint value) public returns (bool success) {
168         _allowed[msg.sender][spender] = value;
169         emit Approval(msg.sender, spender, value);
170         return true;
171     }
172     
173     // Transfer from function, pulls from allowance
174     function transferFrom(address from, address to, uint value) public returns (bool success) {
175         require(value <= balanceOf(from));
176         require(value <= allowance(from, to));
177         _balances[from] = _balances[from].sub(value);
178         _balances[to] = _balances[to].add(value);
179         _allowed[from][to] = _allowed[from][to].sub(value);
180         emit Transfer(from, to, value);
181         return true;
182     }
183     
184     // Users Cannot acidentaly send ETH to the contract
185     function () external payable {
186         revert();
187     }
188     
189     // Owner Can mint new tokens
190     function mint(uint256 amount, address to) public onlyOwner {
191         _balances[to] = _balances[to].add(amount);
192         supply = supply.add(amount);
193         emit Mint(amount, to);
194     }
195     
196     // Owner can burn existing tokens
197     function burn(uint256 amount, address from) public onlyOwner {
198         require(_balances[from] >= amount);
199         _balances[from] = _balances[from].sub(amount);
200         supply = supply.sub(amount);
201         emit Burn(amount, from);
202     }
203     
204     // Change ICO Price
205     function setICOPrice(uint256 _newPrice) public onlyOwner {
206         ICOPrice = _newPrice;
207     }
208     
209     // See how many tokens are available to be purcahsed.
210     function getRemainingICOBalance() public view returns (uint256) {
211         return _balances[contractAddress];
212     }
213     
214     // Top up ICO balance
215     function topUpICO(uint256 _amount) public onlyOwner {
216         require(_balances[owner] >= _amount);
217         _balances[owner] = _balances[owner].sub(_amount);
218         _balances[contractAddress] = _balances[contractAddress].add(_amount);
219         emit Transfer(msg.sender, contractAddress, _amount);
220     }
221     
222     
223     // Buy tokens
224     function buyTokens() public payable {
225         require(ICOPrice > 0);
226         require(msg.value >= ICOPrice);
227         uint256 affordAmount = msg.value / ICOPrice;
228         require(_balances[contractAddress] >= affordAmount * 10 ** decimals);
229         _balances[contractAddress] = _balances[contractAddress].sub(affordAmount * 10 ** decimals);
230         _balances[msg.sender] = _balances[msg.sender].add(affordAmount * 10 ** decimals);
231         emit Transfer(contractAddress, msg.sender, affordAmount * 10 ** decimals);
232     }
233     
234     // Withdraw ETH
235     function withdrawContractBalance() public onlyOwner {
236         msg.sender.transfer(contractAddress.balance);
237     }
238     
239     // Cancel and withdraw ICO tokens
240     function withdrawContractTokens(uint256 _amount) public onlyOwner {
241         require(_balances[contractAddress] >= _amount);
242         _balances[contractAddress] = _balances[contractAddress].sub(_amount);
243         _balances[owner] = _balances[owner].add(_amount);
244         emit Transfer(contractAddress, owner, _amount);
245     }
246 }