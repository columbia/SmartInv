1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // ##########   #            #            #        #        #
6 // #            #            #            #        #        #
7 // #            #            #            #        #        #
8 // ##########   #            #            #        #        #
9 // #            #            #            #        #        #
10 // #            #            #            #        #        #
11 // ##########   ##########   ##########   ##########        #
12 //
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // @Name SafeMath
17 // @Desc Math operations with safety checks that throw on error
18 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
19 // ----------------------------------------------------------------------------
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 // ----------------------------------------------------------------------------
65 // ERC Token Standard #20 Interface
66 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67 // ----------------------------------------------------------------------------
68 contract ERC20Interface {
69     function totalSupply() public constant returns (uint);
70     function balanceOf(address tokenOwner) public constant returns (uint balance);
71     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
72     function transfer(address to, uint tokens) public returns (bool success);
73     function approve(address spender, uint tokens) public returns (bool success);
74     function transferFrom(address from, address to, uint tokens) public returns (bool success);
75 
76     event Transfer(address indexed from, address indexed to, uint tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 // ----------------------------------------------------------------------------
81 // @Name ElluiBase
82 // @Desc ERC20-based token
83 // ----------------------------------------------------------------------------
84 contract ElluiBase is ERC20Interface {
85     using SafeMath for uint;
86 
87     uint                                                _totalSupply;
88     mapping(address => uint256)                         _balances;
89     mapping(address => mapping(address => uint256))     _allowance;
90 
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply;
93     }
94 
95     function balanceOf(address tokenOwner) public constant returns (uint balance) {
96         return _balances[tokenOwner];
97     }
98 
99     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
100         return _allowance[tokenOwner][spender];
101     }
102 
103     function transfer(address to, uint value) public returns (bool success) {
104         require( _balances[msg.sender] >= value);
105 
106         _balances[msg.sender] = _balances[msg.sender].sub(value);
107         _balances[to] = _balances[to].add(value);
108 
109         emit Transfer(msg.sender, to, value);
110         return true;
111     }
112 
113     function transferFrom(address from, address to, uint value) public returns (bool success) {
114         require(value <= _balances[from]);
115         require(value <= _allowance[from][msg.sender]);
116         
117         _balances[from] = _balances[from].sub(value);
118         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);
119         _balances[to] = _balances[to].add(value);
120 
121         emit Transfer(from, to, value);
122         return true;
123     }
124 
125     function approve(address spender, uint value) public returns (bool success) {
126         //require user to set to zero before resetting to nonzero
127         if ((value != 0) && (_allowance[msg.sender][spender] != 0)) {
128             return false;
129         }
130         
131         _allowance[msg.sender][spender] = value;
132 
133         emit Approval(msg.sender, spender, value);
134         return true;
135     }
136     
137     function increaseApproval (address spender, uint addedValue) public returns (bool success) {
138         uint oldValue = _allowance[msg.sender][spender];
139         _allowance[msg.sender][spender] = oldValue.add(addedValue);
140         return true;
141     }
142     
143     function decreaseApproval (address spender, uint subtractedValue) public returns (bool success) {
144         uint oldValue = _allowance[msg.sender][spender];
145         if (subtractedValue > oldValue) {
146             _allowance[msg.sender][spender] = 0;
147         } else {
148             _allowance[msg.sender][spender] = oldValue.sub(subtractedValue);
149         }
150         return true;
151     }
152 
153 }
154 
155 // ----------------------------------------------------------------------------
156 // @Name Ellui
157 // @Desc ERC20 token
158 // ----------------------------------------------------------------------------
159 contract Ellui is ElluiBase {
160     string public name;
161     uint8 public decimals;
162     string public symbol;
163 
164     // Admin Ellui Address
165     address public owner;
166 
167     modifier isOwner {
168         require(owner == msg.sender);
169         _;
170     }
171     
172     event EventBurnCoin(address a_burnAddress, uint a_amount);
173     event EventAddCoin(uint a_amount, uint a_totalSupply);
174 
175     constructor(uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {
176         owner = msg.sender;
177         
178         _totalSupply = a_totalSupply;
179         _balances[msg.sender] = a_totalSupply;
180 
181         name = a_tokenName;
182         symbol = a_tokenSymbol;
183         decimals = a_decimals;
184     }
185 
186     function burnCoin(uint value) external isOwner
187     {
188         require(_balances[msg.sender] >= value);
189 
190         _balances[msg.sender] = _balances[msg.sender].sub(value);
191         _totalSupply = _totalSupply.sub(value);
192 
193         emit EventBurnCoin(msg.sender, value);
194     }
195 
196     function addCoin(uint value) external isOwner
197     {
198         _balances[msg.sender] = _balances[msg.sender].add(value);
199         _totalSupply = _totalSupply.add(value);
200 
201         emit EventAddCoin(value, _totalSupply);
202     }
203 }