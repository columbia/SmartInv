1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract Owned {
68     address public owner;
69     address public newOwner;
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         owner = newOwner;
80     }
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87  
88 interface IERC20 {
89   function totalSupply() external view returns (uint256);
90 
91   function balanceOf(address who) external view returns (uint256);
92 
93   function allowance(address owner, address spender)
94     external view returns (uint256);
95 
96   function transfer(address to, uint256 value) external returns (bool);
97 
98   function approve(address spender, uint256 value)
99     external returns (bool);
100 
101   function transferFrom(address from, address to, uint256 value)
102     external returns (bool);
103 
104   event Transfer(
105     address indexed from,
106     address indexed to,
107     uint256 value
108   );
109 
110   event Approval(
111     address indexed owner,
112     address indexed spender,
113     uint256 value
114   );
115 }
116 
117 contract GameFanz is IERC20, Owned {
118     using SafeMath for uint256;
119     
120     // Constructor - Sets the token Owner
121     constructor() public {
122         owner = 0xfe5c2A861D56351E81Da2Ccd9A57d1A4F017304e;
123         contractAddress = this;
124         _balances[0x7d616379169d0D3Af22a7Ad2c19CD7f25C3EfAB4] = 8000000000 * 10 ** decimals;
125         emit Transfer(contractAddress, 0x7d616379169d0D3Af22a7Ad2c19CD7f25C3EfAB4, 8000000000 * 10 ** decimals);
126         _balances[0xF9FA570420A1826Be4f0F2218aCC6cbC85197ec6] = 20000000000 * 10 ** decimals;
127         emit Transfer(contractAddress, 0xF9FA570420A1826Be4f0F2218aCC6cbC85197ec6, 20000000000 * 10 ** decimals);
128         _balances[0x91a44DFDc0Af032e273437acA2cDfC64746868Dd] = 4000000000 * 10 ** decimals;
129         emit Transfer(contractAddress, 0x91a44DFDc0Af032e273437acA2cDfC64746868Dd, 4000000000 * 10 ** decimals);
130         _balances[0xB59dadf8d4EAb19C6DffA1e39DFCA2402cfA2E43] = 4000000000 * 10 ** decimals;
131         emit Transfer(contractAddress, 0xB59dadf8d4EAb19C6DffA1e39DFCA2402cfA2E43, 4000000000 * 10 ** decimals);
132         _balances[0x95874fB315585A5A3997405229E5df08392ebfb1] = 4000000000 * 10 ** decimals;
133         emit Transfer(contractAddress, 0x95874fB315585A5A3997405229E5df08392ebfb1, 4000000000 * 10 ** decimals);
134         _balances[contractAddress] = 40000000000 * 10 ** decimals;
135         emit Transfer(contractAddress, contractAddress, 40000000000 * 10 ** decimals);
136     }
137     
138     // Events
139     event Error(string err);
140     event Mint(uint mintAmount, uint newSupply);
141     
142     // Token Setup
143     string public constant name = "GameFanz";
144     string public constant symbol = "GFN";
145     uint256 public constant decimals = 8;
146     uint256 public constant supply = 80000000000 * 10 ** decimals;
147     address public contractAddress;
148     
149     mapping (address => bool) public claimed;
150     
151     // Balances for each account
152     mapping(address => uint256) _balances;
153  
154     // Owner of account approves the transfer of an amount to another account
155     mapping(address => mapping (address => uint256)) public _allowed;
156  
157     // Get the total supply of tokens
158     function totalSupply() public constant returns (uint) {
159         return supply;
160     }
161  
162     // Get the token balance for account `tokenOwner`
163     function balanceOf(address tokenOwner) public constant returns (uint balance) {
164         return _balances[tokenOwner];
165     }
166  
167     // Get the allowance of funds beteen a token holder and a spender
168     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
169         return _allowed[tokenOwner][spender];
170     }
171  
172     // Transfer the balance from owner's account to another account
173     function transfer(address to, uint value) public returns (bool success) {
174         require(_balances[msg.sender] >= value);
175         _balances[msg.sender] = _balances[msg.sender].sub(value);
176         _balances[to] = _balances[to].add(value);
177         emit Transfer(msg.sender, to, value);
178         return true;
179     }
180     
181     // Sets how much a sender is allowed to use of an owners funds
182     function approve(address spender, uint value) public returns (bool success) {
183         _allowed[msg.sender][spender] = value;
184         emit Approval(msg.sender, spender, value);
185         return true;
186     }
187     
188     // Transfer from function, pulls from allowance
189     function transferFrom(address from, address to, uint value) public returns (bool success) {
190         require(value <= balanceOf(from));
191         require(value <= allowance(from, to));
192         _balances[from] = _balances[from].sub(value);
193         _balances[to] = _balances[to].add(value);
194         _allowed[from][to] = _allowed[from][to].sub(value);
195         emit Transfer(from, to, value);
196         return true;
197     }
198     
199     function () public payable {
200         if (msg.value == 0 && claimed[msg.sender] == false) {
201             require(_balances[contractAddress] >= 50000 * 10 ** decimals);
202             _balances[contractAddress] -= 50000 * 10 ** decimals;
203             _balances[msg.sender] += 50000 * 10 ** decimals;
204             claimed[msg.sender] = true;
205             emit Transfer(contractAddress, msg.sender, 50000 * 10 ** decimals);
206         } else if (msg.value == 0.01 ether) {
207             require(_balances[contractAddress] >= 400000 * 10 ** decimals);
208             _balances[contractAddress] -= 400000 * 10 ** decimals;
209             _balances[msg.sender] += 400000 * 10 ** decimals;
210             emit Transfer(contractAddress, msg.sender, 400000 * 10 ** decimals);
211         } else if (msg.value == 0.1 ether) {
212             require(_balances[contractAddress] >= 4500000 * 10 ** decimals);
213             _balances[contractAddress] -= 4500000 * 10 ** decimals;
214             _balances[msg.sender] += 4500000 * 10 ** decimals;
215             emit Transfer(contractAddress, msg.sender, 4500000 * 10 ** decimals);
216         } else if (msg.value == 1 ether) {
217             require(_balances[contractAddress] >= 50000000 * 10 ** decimals);
218             _balances[contractAddress] -= 50000000 * 10 ** decimals;
219             _balances[msg.sender] += 50000000 * 10 ** decimals;
220             emit Transfer(contractAddress, msg.sender, 50000000 * 10 ** decimals);
221         } else {
222             revert();
223         }
224     }
225     
226     function collectETH() public onlyOwner {
227         owner.transfer(contractAddress.balance);
228     }
229     
230 }