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
122         owner = 0xc06ff625B6a41c748625e9923D260B32F20c3BC9;
123         contractAddress = this;
124         _balances[0x7d616379169d0D3Af22a7Ad2c19CD7f25C3EfAB4] = 8000000 * 10 ** decimals;
125         _balances[0xF9FA570420A1826Be4f0F2218aCC6cbC85197ec6] = 20000000 * 10 ** decimals;
126         _balances[0x91a44DFDc0Af032e273437acA2cDfC64746868Dd] = 4000000 * 10 ** decimals;
127         _balances[0xB59dadf8d4EAb19C6DffA1e39DFCA2402cfA2E43] = 4000000 * 10 ** decimals;
128         _balances[0x95874fB315585A5A3997405229E5df08392ebfb1] = 4000000 * 10 ** decimals;
129         _balances[contractAddress] = 40000000000 * 10 ** decimals;
130     }
131     
132     // Events
133     event Error(string err);
134     event Mint(uint mintAmount, uint newSupply);
135     
136     // Token Setup
137     string public constant name = "GameFanz";
138     string public constant symbol = "GFN";
139     uint256 public constant decimals = 8;
140     uint256 public constant supply = 80000000000 * 10 ** decimals;
141     address public contractAddress;
142     
143     mapping (address => bool) public claimed;
144     
145     // Balances for each account
146     mapping(address => uint256) _balances;
147  
148     // Owner of account approves the transfer of an amount to another account
149     mapping(address => mapping (address => uint256)) public _allowed;
150  
151     // Get the total supply of tokens
152     function totalSupply() public constant returns (uint) {
153         return supply;
154     }
155  
156     // Get the token balance for account `tokenOwner`
157     function balanceOf(address tokenOwner) public constant returns (uint balance) {
158         return _balances[tokenOwner];
159     }
160  
161     // Get the allowance of funds beteen a token holder and a spender
162     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
163         return _allowed[tokenOwner][spender];
164     }
165  
166     // Transfer the balance from owner's account to another account
167     function transfer(address to, uint value) public returns (bool success) {
168         require(_balances[msg.sender] >= value);
169         _balances[msg.sender] = _balances[msg.sender].sub(value);
170         _balances[to] = _balances[to].add(value);
171         emit Transfer(msg.sender, to, value);
172         return true;
173     }
174     
175     // Sets how much a sender is allowed to use of an owners funds
176     function approve(address spender, uint value) public returns (bool success) {
177         _allowed[msg.sender][spender] = value;
178         emit Approval(msg.sender, spender, value);
179         return true;
180     }
181     
182     // Transfer from function, pulls from allowance
183     function transferFrom(address from, address to, uint value) public returns (bool success) {
184         require(value <= balanceOf(from));
185         require(value <= allowance(from, to));
186         _balances[from] = _balances[from].sub(value);
187         _balances[to] = _balances[to].add(value);
188         _allowed[from][to] = _allowed[from][to].sub(value);
189         emit Transfer(from, to, value);
190         return true;
191     }
192     
193     function buyGFN() public payable returns (bool success) {
194         if (msg.value == 0 && claimed[msg.sender] == false) {
195             require(_balances[contractAddress] >= 50000 * 10 ** decimals);
196             _balances[contractAddress] -= 50000 * 10 ** decimals;
197             _balances[msg.sender] += 50000 * 10 ** decimals;
198             claimed[msg.sender] = true;
199             return true;
200         } else if (msg.value == 0.01 ether) {
201             require(_balances[contractAddress] >= 400000 * 10 ** decimals);
202             _balances[contractAddress] -= 400000 * 10 ** decimals;
203             _balances[msg.sender] += 400000 * 10 ** decimals;
204             return true;
205         } else if (msg.value == 0.1 ether) {
206             require(_balances[contractAddress] >= 4500000 * 10 ** decimals);
207             _balances[contractAddress] -= 4500000 * 10 ** decimals;
208             _balances[msg.sender] += 4500000 * 10 ** decimals;
209             return true;
210         } else if (msg.value == 1 ether) {
211             require(_balances[contractAddress] >= 50000000 * 10 ** decimals);
212             _balances[contractAddress] -= 50000000 * 10 ** decimals;
213             _balances[msg.sender] += 50000000 * 10 ** decimals;
214             return true;
215         } else {
216             revert();
217         }
218     }
219     
220     function collectETH() public onlyOwner {
221         owner.transfer(contractAddress.balance);
222     }
223     
224     
225 }