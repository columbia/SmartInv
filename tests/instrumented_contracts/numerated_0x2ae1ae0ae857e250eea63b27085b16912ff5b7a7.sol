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
35 contract OOOOOO {
36     address public owner;
37 	
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42 	modifier restricted {
43         require(msg.sender == owner);
44         _;
45     }
46 	
47 }
48 
49 contract Ldohtoken is ERC20Interface, OOOOOO {
50 	
51     string 	public symbol;
52     string 	public name;
53     uint8 	public decimals;
54     uint256 public _totalSupply;
55 
56     mapping(address => uint256) balances;
57     mapping(address => mapping(address => uint)) allowed;
58 	
59 	/*==============================
60     =          CONSTRUCTOR         =
61     ==============================*/  
62 	
63     constructor() public {
64         symbol = "HLD";
65         name = "LDOH TOKEN";
66         decimals = 18;
67         _totalSupply = 20000000000000000000000000000;
68 		
69         balances[msg.sender] = _totalSupply;
70         emit Transfer(address(0), msg.sender, _totalSupply);
71     }
72 
73     function transfer(address to, uint256 _value) public returns (bool success) {
74 		if (to == 0x0) revert();                               
75 		if (_value <= 0) revert(); 
76         if (balances[msg.sender] < _value) revert();           		
77         if (balances[to] + _value < balances[to]) revert(); 		
78 		
79         balances[msg.sender] 		= sub(balances[msg.sender], _value);
80         balances[to] 				= add(balances[to], _value);
81         emit Transfer(msg.sender, to, _value);
82         return true;
83     }
84 	
85     function approve(address spender, uint256 _value) public returns (bool success) {
86 		if (_value <= 0) revert(); 
87         allowed[msg.sender][spender] = _value;
88         emit Approval(msg.sender, spender, _value);
89         return true;
90     }
91 
92     function transferFrom(address from, address to, uint256 _value) public returns (bool success) {
93 		if (to == 0x0) revert();                                						
94 		if (_value <= 0) revert(); 
95         if (balances[from] < _value) revert();                 					
96         if (balances[to]  + _value < balances[to]) revert();  					
97         if (_value > allowed[from][msg.sender]) revert();     						
98 		
99         balances[from] 				= sub(balances[from], _value);
100         allowed[from][msg.sender] 	= sub(allowed[from][msg.sender], _value);
101         balances[to] 				= add(balances[to], _value);
102         emit Transfer(from, to, _value);
103         return true;
104     }
105 	
106 	function burn(uint256 _value) public returns (bool success) {
107         if (balances[msg.sender] < _value) revert();            						
108 		if (_value <= 0) revert(); 
109         balances[msg.sender] 	= sub(balances[msg.sender], _value);                     
110         _totalSupply 			= sub(_totalSupply, _value);
111 		
112         emit Transfer(msg.sender, address(0), _value);		
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 
117 
118     function allowance(address TokenAddress, address spender) public constant returns (uint remaining) {
119         return allowed[TokenAddress][spender];
120     }
121 	
122 	function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126     function balanceOf(address TokenAddress) public constant returns (uint balance) {
127         return balances[TokenAddress];
128 		
129     }
130 	
131 	
132 	/*==============================
133     =           ADDITIONAL         =
134     ==============================*/ 
135 	
136 
137     function () public payable {
138     }
139 	
140     function WithdrawEth() restricted public {
141         require(address(this).balance > 0); 
142 		uint256 amount = address(this).balance;
143         
144         msg.sender.transfer(amount);
145     }
146 
147     function TransferERC20Token(address tokenAddress, uint256 _value) public restricted returns (bool success) {
148         return ERC20Interface(tokenAddress).transfer(owner, _value);
149     }
150 	
151 	
152 	/*==============================
153     =      SAFE MATH FUNCTIONS     =
154     ==============================*/  	
155 	
156 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157 		if (a == 0) {
158 			return 0;
159 		}
160 
161 		uint256 c = a * b; 
162 		require(c / a == b);
163 		return c;
164 	}
165 	
166 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
167 		require(b > 0); 
168 		uint256 c = a / b;
169 		return c;
170 	}
171 	
172 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173 		require(b <= a);
174 		uint256 c = a - b;
175 		return c;
176 	}
177 	
178 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
179 		uint256 c = a + b;
180 		require(c >= a);
181 		return c;
182 	}
183 	
184 }