1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10  
11  interface ERC20 {
12     function totalSupply() external constant returns (uint);
13     function balanceOf(address tokenOwner) external constant returns (uint balance);
14     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
15     function transfer(address to, uint tokens) external returns (bool success);
16     function approve(address spender, uint tokens) external returns (bool success);
17     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
18     function transferFrom(address from, address to, uint tokens) external returns (bool success);
19 
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22 }
23 
24 interface ApproveAndCallFallBack {
25     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
26 }
27 
28 contract ClothMaterial is ERC20 {
29     using SafeMath for uint;
30 
31     string public constant name  = "Goo Material - Cloth";
32     string public constant symbol = "CLOTH";
33     uint8 public constant decimals = 0;
34 
35     uint256 public totalSupply;
36     address owner; // Minor management
37 
38     mapping(address => uint256) balances;
39     mapping(address => mapping(address => uint256)) allowed;
40     mapping(address => bool) operator;
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     function setOperator(address gameContract, bool isOperator) external {
47         require(msg.sender == owner);
48         operator[gameContract] = isOperator;
49     }
50 
51     function totalSupply() external view returns (uint) {
52         return totalSupply.sub(balances[address(0)]);
53     }
54 
55     function balanceOf(address tokenOwner) external view returns (uint256) {
56         return balances[tokenOwner];
57     }
58 
59     function transfer(address to, uint tokens) external returns (bool) {
60         balances[msg.sender] = balances[msg.sender].sub(tokens);
61         balances[to] = balances[to].add(tokens);
62         emit Transfer(msg.sender, to, tokens);
63         return true;
64     }
65 
66     function transferFrom(address from, address to, uint tokens) external returns (bool) {
67         balances[from] = balances[from].sub(tokens);
68         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
69         balances[to] = balances[to].add(tokens);
70         emit Transfer(from, to, tokens);
71         return true;
72     }
73 
74     function approve(address spender, uint tokens) external returns (bool) {
75         allowed[msg.sender][spender] = tokens;
76         emit Approval(msg.sender, spender, tokens);
77         return true;
78     }
79 
80     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool) {
81         allowed[msg.sender][spender] = tokens;
82         emit Approval(msg.sender, spender, tokens);
83         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
84         return true;
85     }
86 
87     function allowance(address tokenOwner, address spender) external view returns (uint256) {
88         return allowed[tokenOwner][spender];
89     }
90 
91     function recoverAccidentalTokens(address tokenAddress, uint tokens) external {
92         require(msg.sender == owner);
93         require(tokenAddress != address(this));
94         ERC20(tokenAddress).transfer(owner, tokens);
95     }
96 
97     function mintCloth(uint256 amount, address player) external {
98         require(operator[msg.sender]);
99         balances[player] += amount;
100         totalSupply += amount;
101         emit Transfer(address(0), player, amount);
102     }
103 
104     function burn(uint256 amount, address player) public {
105         require(operator[msg.sender]);
106         balances[player] = balances[player].sub(amount);
107         totalSupply = totalSupply.sub(amount);
108         emit Transfer(player, address(0), amount);
109     }
110 }
111 
112 library SafeMath {
113 
114   /**
115   * @dev Multiplies two numbers, throws on overflow.
116   */
117   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118     if (a == 0) {
119       return 0;
120     }
121     uint256 c = a * b;
122     assert(c / a == b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return c;
134   }
135 
136   /**
137   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     assert(c >= a);
150     return c;
151   }
152 }