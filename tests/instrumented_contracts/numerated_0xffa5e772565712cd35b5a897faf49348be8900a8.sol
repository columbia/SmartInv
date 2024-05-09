1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // @Project YouRyuCoin (YRC)
5 // @Creator RyuChain
6 // ----------------------------------------------------------------------------
7 
8 // ----------------------------------------------------------------------------
9 // @Name SafeMath
10 // @Desc Math operations with safety checks that throw on error
11 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
12 // ----------------------------------------------------------------------------
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 // ----------------------------------------------------------------------------
58 // ERC Token Standard #20 Interface
59 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function totalSupply() public constant returns (uint);
63     function balanceOf(address tokenOwner) public constant returns (uint balance);
64     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 // ----------------------------------------------------------------------------
73 // @Name YouRyuCoinBase
74 // @Desc ERC20-based token
75 // ----------------------------------------------------------------------------
76 contract YouRyuCoinBase is ERC20Interface {
77     using SafeMath for uint;
78 
79     uint                                                _totalSupply;
80     mapping(address => uint256)                         _balances;
81     mapping(address => mapping(address => uint256))     _allowed;
82 
83     function totalSupply() public constant returns (uint) {
84         return _totalSupply;
85     }
86 
87     function balanceOf(address tokenOwner) public constant returns (uint balance) {
88         return _balances[tokenOwner];
89     }
90 
91     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
92         return _allowed[tokenOwner][spender];
93     }
94 
95     function transfer(address to, uint tokens) public returns (bool success) {
96         require( _balances[msg.sender] >= tokens);
97 
98         _balances[msg.sender] = _balances[msg.sender].sub(tokens);
99         _balances[to] = _balances[to].add(tokens);
100 
101         emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105     function approve(address spender, uint tokens) public returns (bool success) {
106         _allowed[msg.sender][spender] = tokens;
107 
108         emit Approval(msg.sender, spender, tokens);
109         return true;
110     }
111 
112     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
113         require(tokens <= _balances[from]);
114         require(tokens <= _allowed[from][msg.sender]);
115         
116         _balances[from] = _balances[from].sub(tokens);
117         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
118         _balances[to] = _balances[to].add(tokens);
119 
120         emit Transfer(from, to, tokens);
121         return true;
122     }
123 }
124 // ----------------------------------------------------------------------------
125 // @Name YouRyuCoin (YRC)
126 // @Desc Cutie Ryu
127 // ----------------------------------------------------------------------------
128 contract YouRyuCoin is YouRyuCoinBase {
129     string public name;
130     uint8 public decimals;
131     string public symbol;
132 
133     // Admin Ryu Address
134     address public owner;
135 
136     modifier isOwner {
137         require(owner == msg.sender);
138         _;
139     }
140     
141     event EventBurnCoin(address a_burnAddress, uint a_amount);
142     event EventAddCoin(uint a_amount, uint a_totalSupply);
143 
144      function YouRyuCoin(uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {
145         owner = msg.sender;
146         
147         _totalSupply = a_totalSupply;
148         _balances[msg.sender] = a_totalSupply;
149 
150         name = a_tokenName;
151         symbol = a_tokenSymbol;
152         decimals = a_decimals;
153     }
154 
155     function burnCoin(uint a_coinAmount) external isOwner
156     {
157         require(_balances[msg.sender] >= a_coinAmount);
158 
159         _balances[msg.sender] = _balances[msg.sender].sub(a_coinAmount);
160         _totalSupply = _totalSupply.sub(a_coinAmount);
161 
162         emit EventBurnCoin(msg.sender, a_coinAmount);
163     }
164 
165     function addCoin(uint a_coinAmount) external isOwner
166     {
167         _balances[msg.sender] = _balances[msg.sender].add(a_coinAmount);
168         _totalSupply = _totalSupply.add(a_coinAmount);
169 
170         emit EventAddCoin(a_coinAmount, _totalSupply);
171     }
172 }