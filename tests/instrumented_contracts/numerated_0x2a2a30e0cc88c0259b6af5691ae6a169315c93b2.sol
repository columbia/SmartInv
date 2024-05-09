1 pragma solidity ^0.4.25;
2 
3 /**
4 
5 
6 					.----------------.  .----------------.  .----------------.  .----------------. 
7 					| .--------------. || .--------------. || .--------------. || .--------------. |
8 					| |  ____  ____  | || |     ____     | || |   _____      | || |  ________    | |
9 					| | |_   ||   _| | || |   .'    `.   | || |  |_   _|     | || | |_   ___ `.  | |
10 					| |   | |__| |   | || |  /  .--.  \  | || |    | |       | || |   | |   `. \ | |
11 					| |   |  __  |   | || |  | |    | |  | || |    | |   _   | || |   | |    | | | |
12 					| |  _| |  | |_  | || |  \  `--'  /  | || |   _| |__/ |  | || |  _| |___.' / | |
13 					| | |____||____| | || |   `.____.'   | || |  |________|  | || | |________.'  | |
14 					| |              | || |              | || |              | || |              | |
15 					| '--------------' || '--------------' || '--------------' || '--------------' |
16 					'----------------'  '----------------'  '----------------'  '----------------' 
17 
18  
19 */
20 
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 	event Burn(address indexed _from, uint256 _value); 
33 }
34 
35 contract ooooooooo {
36     address public owner;
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41 	modifier restricted {
42         require(msg.sender == owner);
43         _;
44     }
45 
46 }
47 
48 contract Ldohtoken is ERC20Interface, ooooooooo {
49 	
50     string 	public symbol;
51     string 	public name;
52     uint8 	public decimals;
53     uint256 public _totalSupply;
54 
55     mapping(address => uint256) balances;
56     mapping(address => mapping(address => uint)) allowed;
57 	
58 	/*==============================
59     =          CONSTRUCTOR         =
60     ==============================*/  
61 	
62     constructor() public {
63         symbol = "HLD";
64         name = "LDOH TOKEN";
65         decimals = 18;
66         _totalSupply = 20000000000000000000000000000;
67 		
68         balances[msg.sender] = _totalSupply;
69         emit Transfer(address(0), msg.sender, _totalSupply);
70     }
71 
72     function transfer(address to, uint256 _value) public returns (bool success) {
73 		if (to == 0x0) revert();                               
74 		if (_value <= 0) revert(); 
75         if (balances[msg.sender] < _value) revert();           		
76         if (balances[to] + _value < balances[to]) revert(); 		
77 		
78         balances[msg.sender] 		= sub(balances[msg.sender], _value);
79         balances[to] 				= add(balances[to], _value);
80         emit Transfer(msg.sender, to, _value);
81         return true;
82     }
83 	
84     function approve(address spender, uint256 _value) public returns (bool success) {
85 		if (_value <= 0) revert(); 
86         allowed[msg.sender][spender] = _value;
87         emit Approval(msg.sender, spender, _value);
88         return true;
89     }
90 
91     function transferFrom(address from, address to, uint256 _value) public returns (bool success) {
92 		if (to == 0x0) revert();                                						
93 		if (_value <= 0) revert(); 
94         if (balances[from] < _value) revert();                 					
95         if (balances[to]  + _value < balances[to]) revert();  					
96         if (_value > allowed[from][msg.sender]) revert();     						
97 		
98         balances[from] 				= sub(balances[from], _value);
99         allowed[from][msg.sender] 	= sub(allowed[from][msg.sender], _value);
100         balances[to] 				= add(balances[to], _value);
101         emit Transfer(from, to, _value);
102         return true;
103     }
104 	
105 	function burn(uint256 _value) public returns (bool success) {
106         if (balances[msg.sender] < _value) revert();            						
107 		if (_value <= 0) revert(); 
108         balances[msg.sender] 	= sub(balances[msg.sender], _value);                     
109         _totalSupply 			= sub(_totalSupply, _value);
110         emit Burn(msg.sender, _value);
111         return true;
112     }
113 
114 
115     function allowance(address TokenAddress, address spender) public constant returns (uint remaining) {
116         return allowed[TokenAddress][spender];
117     }
118 	
119 	function totalSupply() public constant returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123     function balanceOf(address TokenAddress) public constant returns (uint balance) {
124         return balances[TokenAddress];
125 		
126     }
127 	
128 	
129 	/*==============================
130     =           ADDITIONAL         =
131     ==============================*/ 
132 	
133 
134     function () public payable {
135     }
136 	
137     function WithdrawEth() restricted public {
138         require(address(this).balance > 0); 
139 		uint256 amount = address(this).balance;
140         
141         msg.sender.transfer(amount);
142     }
143 
144     function TransferERC20Token(address tokenAddress, uint tokens) public restricted returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 	
148 	
149 	/*==============================
150     =      SAFE MATH FUNCTIONS     =
151     ==============================*/  	
152 	
153 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154 		if (a == 0) {
155 			return 0;
156 		}
157 
158 		uint256 c = a * b; 
159 		require(c / a == b);
160 		return c;
161 	}
162 	
163 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
164 		require(b > 0); 
165 		uint256 c = a / b;
166 		return c;
167 	}
168 	
169 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170 		require(b <= a);
171 		uint256 c = a - b;
172 		return c;
173 	}
174 	
175 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
176 		uint256 c = a + b;
177 		require(c >= a);
178 		return c;
179 	}
180 	
181 }