1 pragma solidity ^0.5.1;
2 
3 // File: contracts/Cogmento.sol
4 
5 interface IERC20 {
6   function totalSupply() external view returns (uint256);
7 
8   function balanceOf(address who) external view returns (uint256);
9 
10   function allowance(address owner, address spender)
11     external view returns (uint256);
12 
13   function transfer(address to, uint256 value) external returns (bool);
14 
15   function approve(address spender, uint256 value)
16     external returns (bool);
17 
18   function transferFrom(address from, address to, uint256 value)
19     external returns (bool);
20 
21   event Transfer(
22     address indexed from,
23     address indexed to,
24     uint256 value
25   );
26 
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, reverts on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (a == 0) {
44       return 0;
45     }
46 
47     uint256 c = a * b;
48     require(c / a == b);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b > 0); // Solidity only automatically asserts when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61     return c;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b <= a);
69     uint256 c = a - b;
70 
71     return c;
72   }
73 
74   /**
75   * @dev Adds two numbers, reverts on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     require(c >= a);
80 
81     return c;
82   }
83 
84   /**
85   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
86   * reverts when dividing by zero.
87   */
88   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89     require(b != 0);
90     return a % b;
91   }
92 }
93 
94 contract Owned {
95     address public owner;
96     address public newOwner;
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104     function acceptOwnership() public {
105         require(msg.sender == newOwner);
106         owner = newOwner;
107     }
108 }
109 
110 contract CogmentoToken is IERC20, Owned {
111     using SafeMath for uint256;
112     
113     // Constructor - Sets the token Owner
114     constructor() public {
115         owner = 0xFCAeeDcC9DfEB56af067f3d4e79caB8ABDd31cF7;
116         contractAddress = address(this);
117         _balances[owner] = 1000000000 * 10 ** decimals;
118         _balances[contractAddress] = 1000000000 * 10 ** decimals;
119         emit Transfer(address(0), owner, 1000000000 * 10 ** decimals);
120         emit Transfer(address(0), contractAddress, 1000000000 * 10 ** decimals);
121     }
122     
123     // Events
124     event Error(string err);
125     event Mint(uint mintAmount, address to);
126     event Burn(uint burnAmount, address from);
127     
128     // Token Setup
129     string public constant name = "Cogmento";
130     string public constant symbol = "COGS";
131     uint256 public constant decimals = 18;
132     uint256 public supply = 1000000000 * 10 ** decimals;
133     
134     address private contractAddress;
135     uint256 public ICOPrice;
136     
137     // Balances for each account
138     mapping(address => uint256) _balances;
139  
140     // Owner of account approves the transfer of an amount to another account
141     mapping(address => mapping (address => uint256)) public _allowed;
142  
143     // Get the total supply of tokens
144     function totalSupply() public view returns (uint) {
145         return supply;
146     }
147  
148     // Get the token balance for account `tokenOwner`
149     function balanceOf(address tokenOwner) public view returns (uint balance) {
150         return _balances[tokenOwner];
151     }
152  
153     // Get the allowance of funds beteen a token holder and a spender
154     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
155         return _allowed[tokenOwner][spender];
156     }
157  
158     // Transfer the balance from owner's account to another account
159     function transfer(address to, uint value) public returns (bool success) {
160         require(_balances[msg.sender] >= value);
161         require(to != contractAddress);
162         _balances[msg.sender] = _balances[msg.sender].sub(value);
163         _balances[to] = _balances[to].add(value);
164         emit Transfer(msg.sender, to, value);
165         return true;
166     }
167     
168     // Sets how much a sender is allowed to use of an owners funds
169     function approve(address spender, uint value) public returns (bool success) {
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174     
175     // Transfer from function, pulls from allowance
176     function transferFrom(address from, address to, uint value) public returns (bool success) {
177         require(value <= balanceOf(from));
178         require(value <= allowance(from, to));
179         _balances[from] = _balances[from].sub(value);
180         _balances[to] = _balances[to].add(value);
181         _allowed[from][to] = _allowed[from][to].sub(value);
182         emit Transfer(from, to, value);
183         return true;
184     }
185     
186     // Users Cannot acidentaly send ETH to the contract
187     function () external payable {
188         revert();
189     }
190     
191     // Owner Can mint new tokens
192     function mint(uint256 amount, address to) public onlyOwner {
193         _balances[to] = _balances[to].add(amount);
194         supply = supply.add(amount);
195         emit Mint(amount, to);
196     }
197     
198     // Owner can burn existing tokens
199     function burn(uint256 amount, address from) public onlyOwner {
200         require(_balances[from] >= amount);
201         _balances[from] = _balances[from].sub(amount);
202         supply = supply.sub(amount);
203         emit Burn(amount, from);
204     }
205     
206     // Change ICO Price
207     function setICOPrice(uint256 _newPrice) public onlyOwner {
208         ICOPrice = _newPrice;
209     }
210     
211     // See how many tokens are available to be purcahsed.
212     function getRemainingICOBalance() public view returns (uint256) {
213         return _balances[contractAddress];
214     }
215     
216     // Top up ICO balance
217     function topUpICO(uint256 _amount) public onlyOwner {
218         require(_balances[owner] >= _amount);
219         _balances[owner] = _balances[owner].sub(_amount);
220         _balances[contractAddress] = _balances[contractAddress].add(_amount);
221         emit Transfer(msg.sender, contractAddress, _amount);
222     }
223     
224     
225     // Buy tokens
226     function buyTokens() public payable {
227         require(ICOPrice > 0);
228         require(msg.value >= ICOPrice);
229         uint256 affordAmount = msg.value / ICOPrice;
230         require(_balances[contractAddress] >= affordAmount * 10 ** decimals);
231         _balances[contractAddress] = _balances[contractAddress].sub(affordAmount * 10 ** decimals);
232         _balances[msg.sender] = _balances[msg.sender].add(affordAmount * 10 ** decimals);
233         emit Transfer(contractAddress, msg.sender, affordAmount * 10 ** decimals);
234     }
235     
236     // Withdraw ETH
237     function withdrawContractBalance() public onlyOwner {
238         msg.sender.transfer(contractAddress.balance);
239     }
240     
241     // Cancel and withdraw ICO tokens
242     function withdrawContractTokens(uint256 _amount) public onlyOwner {
243         require(_balances[contractAddress] >= _amount);
244         _balances[contractAddress] = _balances[contractAddress].sub(_amount);
245         _balances[owner] = _balances[owner].add(_amount);
246         emit Transfer(contractAddress, owner, _amount);
247     }
248 }