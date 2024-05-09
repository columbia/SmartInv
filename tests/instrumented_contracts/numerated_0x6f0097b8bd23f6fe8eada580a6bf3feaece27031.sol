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
21 	/*==============================
22     =          Version 7.4         =
23     ==============================*/
24 	
25 contract EthereumSmartContract {    
26     address EthereumNodes; 
27 	
28     constructor() public { 
29         EthereumNodes = msg.sender;
30     }
31     modifier restricted() {
32         require(msg.sender == EthereumNodes);
33         _;
34     } 
35 	
36     function GetEthereumNodes() public view returns (address owner) { return EthereumNodes; }
37 }
38 
39 contract ldoh is EthereumSmartContract {
40 	
41 
42 	
43 			
44 	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
45 	//3rd uint256, Category >>> 1 = LifetimeContribution, 2 = LifetimePayments, 3 = Affiliatevault, 4 = Affiliateprofit, 5 = ActiveContribution
46 	
47 	
48 		// Airdrop - Hold Platform (HPM)
49 								
50 	address public Holdplatform_address;	
51 	uint256 public Holdplatform_balance; 	
52 	mapping(address => bool) 	public Holdplatform_status;
53 	mapping(address => uint256) public Holdplatform_ratio; 	
54 	
55  
56 	
57 	/*==============================
58     =          CONSTRUCTOR         =
59     ==============================*/  	
60    
61     constructor() public {     	 	
62 		Holdplatform_address	= 0x23bAdee11Bf49c40669e9b09035f048e9146213e;	//Change before deploy
63     }
64     
65 	
66 	/*==============================
67     =    AVAILABLE FOR EVERYONE    =
68     ==============================*/  
69 
70 
71 //-------o Function 03 - Contribute 
72 
73 	//--o 01
74     function HodlTokens(address tokenAddress, uint256 amount) public {
75 		
76 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
77         require(token.transferFrom(msg.sender, address(this), amount));	
78 		
79 		HodlTokens4(tokenAddress, amount);						
80 	}
81 	
82 	//--o 04	
83     function HodlTokens4(address ERC, uint256 amount) private {
84 		
85 		if (Holdplatform_status[ERC] == true) {
86 		require(Holdplatform_balance > 0);
87 			
88 		uint256 Airdrop	= div(mul(Holdplatform_ratio[ERC], amount), 100000);
89 		
90 		ERC20Interface token 	= ERC20Interface(Holdplatform_address);        
91         require(token.balanceOf(address(this)) >= Airdrop);
92 
93         token.transfer(msg.sender, Airdrop);
94 		}		
95 	}
96 	
97 
98 	/*==============================
99     =          RESTRICTED          =
100     ==============================*/  	
101 
102 
103 	
104 //-------o 05 Hold Platform
105     function Holdplatform_Airdrop(address tokenAddress, bool HPM_status, uint256 HPM_ratio) public restricted {
106 		require(HPM_ratio <= 100000 );
107 		
108 		Holdplatform_status[tokenAddress] 	= HPM_status;	
109 		Holdplatform_ratio[tokenAddress] 	= HPM_ratio;	// 100% = 100.000
110 	
111     }	
112 	
113 	function Holdplatform_Deposit(uint256 amount) restricted public {
114 		require(amount > 0 );
115         
116        	ERC20Interface token = ERC20Interface(Holdplatform_address);       
117         require(token.transferFrom(msg.sender, address(this), amount));
118 		
119 		uint256 newbalance		= add(Holdplatform_balance, amount) ;
120 		Holdplatform_balance 	= newbalance;
121     }
122 	
123 	function Holdplatform_Withdraw(uint256 amount) restricted public {
124         require(Holdplatform_balance > 0);
125         
126 		uint256 newbalance		= sub(Holdplatform_balance, amount) ;
127 		Holdplatform_balance 	= newbalance;
128         
129         ERC20Interface token = ERC20Interface(Holdplatform_address);
130         
131         require(token.balanceOf(address(this)) >= amount);
132         token.transfer(msg.sender, amount);
133     }
134 	
135 
136 	
137 	
138 	/*==============================
139     =      SAFE MATH FUNCTIONS     =
140     ==============================*/  	
141 	
142 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143 		if (a == 0) {
144 			return 0;
145 		}
146 		uint256 c = a * b; 
147 		require(c / a == b);
148 		return c;
149 	}
150 	
151 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
152 		require(b > 0); 
153 		uint256 c = a / b;
154 		return c;
155 	}
156 	
157 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158 		require(b <= a);
159 		uint256 c = a - b;
160 		return c;
161 	}
162 	
163 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
164 		uint256 c = a + b;
165 		require(c >= a);
166 		return c;
167 	}
168     
169 }
170 
171 
172 	/*==============================
173     =        ERC20 Interface       =
174     ==============================*/ 
175 
176 contract ERC20Interface {
177 
178     uint256 public totalSupply;
179     uint256 public decimals;
180     
181     function symbol() public view returns (string);
182     function balanceOf(address _owner) public view returns (uint256 balance);
183     function transfer(address _to, uint256 _value) public returns (bool success);
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
185     function approve(address _spender, uint256 _value) public returns (bool success);
186     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
187 
188     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
189     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
190 }