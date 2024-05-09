1 pragma solidity ^0.5.0;
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
108 contract easyExchangeCoins is IERC20, Owned {
109     using SafeMath for uint256;
110     
111     // Constructor
112     constructor() public {
113         owner = 0x3CC2Ef418b7c2e36110f4521e982576AF9f5c8fA;
114         contractAddress = address(this);
115         _balances[contractAddress] = 20000000 * 10 ** decimals;
116         _balances[owner] = 80000000 * 10 ** decimals;
117         emit Transfer(address(0), contractAddress, 20000000 * 10 ** decimals);
118         emit Transfer(address(0), owner, 80000000 * 10 ** decimals);
119         ICOActive = true;
120     }
121     
122     // ICO Feature
123     function ICOBalance() public view returns (uint) {
124         return _balances[contractAddress];
125     }
126     bool public ICOActive;
127     uint256 public ICOPrice = 10000000;
128     
129     function () external payable {
130         if (ICOActive == false) {
131             revert();
132         } else if (ICOBalance() == 0) {
133             ICOActive = false;
134             revert();
135         } else {
136             uint256 affordAmount = msg.value / ICOPrice;
137             if (affordAmount <= _balances[contractAddress]) {
138                 _balances[contractAddress] = _balances[contractAddress].sub(affordAmount);
139                 _balances[msg.sender] = _balances[msg.sender].add(affordAmount);
140                 emit Transfer(contractAddress, msg.sender, affordAmount);
141             } else {
142                 uint256 buyAmount = _balances[contractAddress];
143                 uint256 cost = buyAmount * ICOPrice;
144                 _balances[contractAddress] = _balances[contractAddress].sub(buyAmount);
145                 _balances[msg.sender] = _balances[msg.sender].add(buyAmount);
146                 emit Transfer(contractAddress, msg.sender, buyAmount);
147                 msg.sender.transfer(msg.value - cost);
148                 ICOActive = false;
149             }
150         }
151     }
152     
153     // Change ICO Price IN WEI
154     function changeICOPrice(uint256 newPrice) public onlyOwner {
155         uint256 _newPrice = newPrice * 10 ** decimals;
156         ICOPrice = _newPrice;
157     }
158     
159     
160     // Token owner can claim ETH from ICO sales
161     function withdrawETH() public onlyOwner {
162         msg.sender.transfer(contractAddress.balance);
163     }
164     
165     function endICO() public onlyOwner {
166         msg.sender.transfer(contractAddress.balance);
167         ICOActive = false;
168         uint256 _amount = _balances[contractAddress];
169         _balances[owner] = _balances[owner].add(_amount);
170         _balances[contractAddress] = 0;
171         emit Transfer(contractAddress, owner, _amount);
172     }
173     
174     // Token Setup
175     string public constant name = "Easy Exchange Coins";
176     string public constant symbol = "EEC";
177     uint256 public constant decimals = 8;
178     uint256 public constant supply = 100000000 * 10 ** decimals;
179     address private contractAddress;
180     
181     // Balances for each account
182     mapping(address => uint256) _balances;
183     
184     // Owner of account approves the transfer of an amount to another account
185     mapping(address => mapping (address => uint256)) public _allowed;
186  
187     // Get the total supply of tokens
188     function totalSupply() public view returns (uint) {
189         return supply;
190     }
191     
192     // Get the token balance for account `tokenOwner`
193     function balanceOf(address tokenOwner) public view returns (uint balance) {
194         return _balances[tokenOwner];
195     }
196  
197     // Get the allowance of funds beteen a token holder and a spender
198     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
199         return _allowed[tokenOwner][spender];
200     }
201     
202     // Transfer the balance from owner's account to another account
203     function transfer(address to, uint value) public returns (bool success) {
204         require(_balances[msg.sender] >= value);
205         _balances[msg.sender] = _balances[msg.sender].sub(value);
206         _balances[to] = _balances[to].add(value);
207         emit Transfer(msg.sender, to, value);
208         return true;
209     }
210     
211     // Sets how much a sender is allowed to use of an owners funds
212     function approve(address spender, uint value) public returns (bool success) {
213         _allowed[msg.sender][spender] = value;
214         emit Approval(msg.sender, spender, value);
215         return true;
216     }
217     
218     // Transfer from function, pulls from allowance
219     function transferFrom(address from, address to, uint value) public returns (bool success) {
220         require(value <= balanceOf(from));
221         require(value <= allowance(from, to));
222         _balances[from] = _balances[from].sub(value);
223         _balances[to] = _balances[to].add(value);
224         _allowed[from][to] = _allowed[from][to].sub(value);
225         emit Transfer(from, to, value);
226         return true;
227     }
228 }