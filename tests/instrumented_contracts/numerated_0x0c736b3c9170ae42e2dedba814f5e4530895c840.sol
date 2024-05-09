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
37 	address public Defaultaddress;
38 	address public Contractaddress;
39 	
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44 	modifier restricted {
45         require(msg.sender == owner);
46         _;
47     }
48 	
49 	function UpdateContractaddress(address NewAddress) public restricted {
50         Contractaddress = NewAddress;
51     }
52 
53 }
54 
55 contract Ldohtoken is ERC20Interface, OOOOOO {
56 	
57     string 	public symbol;
58     string 	public name;
59     uint8 	public decimals;
60     uint256 public _totalSupply;
61 
62     mapping(address => uint256) balances;
63     mapping(address => mapping(address => uint)) allowed;
64 	
65 	/*==============================
66     =          CONSTRUCTOR         =
67     ==============================*/  
68 	
69     constructor() public {
70         symbol = "HLD";
71         name = "LDOH TOKEN";
72         decimals = 18;
73         _totalSupply = 20000000000000000000000000000;
74 		
75         balances[msg.sender] = _totalSupply;
76         emit Transfer(address(0), msg.sender, _totalSupply);
77     }
78 
79     function transfer(address to, uint256 _value) public returns (bool success) {
80 		if (to == 0x0) revert();                               
81 		if (_value <= 0) revert(); 
82         if (balances[msg.sender] < _value) revert();           		
83         if (balances[to] + _value < balances[to]) revert(); 		
84 		
85         balances[msg.sender] 		= sub(balances[msg.sender], _value);
86         balances[to] 				= add(balances[to], _value);
87         emit Transfer(msg.sender, to, _value);
88         return true;
89     }
90 	
91     function approve(address spender, uint256 _value) public returns (bool success) {
92 		if (_value <= 0) revert(); 
93         allowed[msg.sender][spender] = _value;
94         emit Approval(msg.sender, spender, _value);
95         return true;
96     }
97 
98     function transferFrom(address from, address to, uint256 _value) public returns (bool success) {
99 		if (to == 0x0) revert();                                						
100 		if (_value <= 0) revert(); 
101         if (balances[from] < _value) revert();                 					
102         if (balances[to]  + _value < balances[to]) revert();  					
103         if (_value > allowed[from][msg.sender]) revert();     						
104 		
105         balances[from] 				= sub(balances[from], _value);
106         allowed[from][msg.sender] 	= sub(allowed[from][msg.sender], _value);
107         balances[to] 				= add(balances[to], _value);
108         emit Transfer(from, to, _value);
109         return true;
110     }
111 	
112 	function burn(uint256 _value) public returns (bool success) {
113         if (balances[msg.sender] < _value) revert();            						
114 		if (_value <= 0) revert(); 
115         balances[msg.sender] 	= sub(balances[msg.sender], _value);                     
116         _totalSupply 			= sub(_totalSupply, _value);
117 		
118 		
119 		ERC20Interface token = ERC20Interface(Contractaddress);        
120         token.transfer(Defaultaddress, _value);
121 		
122         emit Burn(msg.sender, _value);
123         return true;
124     }
125 
126 
127     function allowance(address TokenAddress, address spender) public constant returns (uint remaining) {
128         return allowed[TokenAddress][spender];
129     }
130 	
131 	function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135     function balanceOf(address TokenAddress) public constant returns (uint balance) {
136         return balances[TokenAddress];
137 		
138     }
139 	
140 	
141 	/*==============================
142     =           ADDITIONAL         =
143     ==============================*/ 
144 	
145 
146     function () public payable {
147     }
148 	
149     function WithdrawEth() restricted public {
150         require(address(this).balance > 0); 
151 		uint256 amount = address(this).balance;
152         
153         msg.sender.transfer(amount);
154     }
155 
156     function TransferERC20Token(address tokenAddress, uint256 _value) public restricted returns (bool success) {
157         return ERC20Interface(tokenAddress).transfer(owner, _value);
158     }
159 	
160 	
161 	/*==============================
162     =      SAFE MATH FUNCTIONS     =
163     ==============================*/  	
164 	
165 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166 		if (a == 0) {
167 			return 0;
168 		}
169 
170 		uint256 c = a * b; 
171 		require(c / a == b);
172 		return c;
173 	}
174 	
175 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
176 		require(b > 0); 
177 		uint256 c = a / b;
178 		return c;
179 	}
180 	
181 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182 		require(b <= a);
183 		uint256 c = a - b;
184 		return c;
185 	}
186 	
187 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
188 		uint256 c = a + b;
189 		require(c >= a);
190 		return c;
191 	}
192 	
193 }