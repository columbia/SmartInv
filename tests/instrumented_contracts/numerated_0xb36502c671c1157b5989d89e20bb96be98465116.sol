1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (_a == 0) {
15       return 0;
16     }
17 
18     c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     // assert(_b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = _a / _b;
29     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30     return _a / _b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     assert(_b <= _a);
38     return _a - _b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
45     c = _a + _b;
46     assert(c >= _a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52 	event NewOwner(address indexed old, address indexed current);
53 
54 	address public owner = msg.sender;
55 
56 	modifier onlyOwner {
57 		require(msg.sender == owner);
58 		_;
59 	}
60 
61   constructor () internal {
62     owner = msg.sender;
63   }
64 
65 	function setOwner(address _new)
66 		external
67 		onlyOwner
68 	{
69 		emit NewOwner(owner, _new);
70 		owner = _new;
71 	}
72 }
73 
74 /**
75  * @title ERC20
76  * @dev ERC20 token interface
77  */
78  contract ERC20 {
79     string public name;
80     string public symbol;
81     uint8 public decimals;
82     function totalSupply() public view returns (uint);
83     function balanceOf(address tokenOwner) public view returns (uint balance);
84     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
85     function transfer(address to, uint tokens) public returns (bool success);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91  }
92 
93 
94 contract Faucet is Ownable {
95     using SafeMath for uint256;
96 
97     /* --- EVENTS --- */
98 
99     event TokenExchanged(address receiver, uint etherReceived, uint tokenSent);
100 
101     /* --- FIELDS / CONSTANTS --- */
102 
103     address public tokenAddress;
104     uint16 public exchangeRate; // ETH -> token exchange rate
105     uint public exchangeLimit; // Max amount of ether allowed to exchange
106 
107     /* --- PUBLIC/EXTERNAL FUNCTIONS --- */
108 
109     constructor(address _tokenAddress, uint16 _exchangeRate, uint _exchangeLimit) public {
110         tokenAddress = _tokenAddress;
111         exchangeRate = _exchangeRate;
112         exchangeLimit = _exchangeLimit;
113     }
114 
115     function() public payable {
116         require(msg.value <= exchangeLimit);
117 
118         uint transferAmount = msg.value.mul(exchangeRate);
119         require(ERC20(tokenAddress).transfer(msg.sender, transferAmount), "insufficient erc20 token balance");
120 
121         emit TokenExchanged(msg.sender, msg.value, transferAmount);
122     }
123 
124     function withdrawEther(uint amount) onlyOwner public {
125         owner.transfer(amount);
126     }
127 
128     function withdrawToken(uint amount) onlyOwner public {
129         ERC20(tokenAddress).transfer(owner, amount);
130     }
131 
132     function getTokenBalance() public view returns (uint) {
133         return ERC20(tokenAddress).balanceOf(this);
134     }
135 
136     function getEtherBalance() public view returns (uint) {
137         return address(this).balance;
138     }
139 
140     function updateExchangeRate(uint16 newExchangeRate) onlyOwner public {
141         exchangeRate = newExchangeRate;
142     }
143 
144     function updateExchangeLimit(uint newExchangeLimit) onlyOwner public {
145         exchangeLimit = newExchangeLimit;
146     }
147 }