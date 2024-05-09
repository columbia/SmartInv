1 pragma solidity ^0.4.25;
2 
3 
4 contract ldoh  {
5 
6 	
7     function Holdplatform2(address tokenAddress, uint256 amount) public {
8 
9 		uint256 Finalamount 			= div(mul(amount, 98), 100);	
10 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
11         require(token.transferFrom(msg.sender, address(this), Finalamount));	
12 		}	
13 		
14 	
15 		
16 		function Holdplatform5(address tokenAddress, uint256 amount) public {
17 
18 
19 		uint256 Finalamount 			= div(mul(amount, 98), 100);	
20 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
21         require(token.transferFrom(msg.sender, address(this), Finalamount));
22         
23 		Holdplatform5A(tokenAddress, amount);	
24 	}
25 	
26 	function Holdplatform5A(address tokenAddress, uint256 amount) public {
27 
28 
29 		uint256 Burn 					= div(mul(amount, 2), 100);	
30 		ERC20Interface token 			= ERC20Interface(tokenAddress);       
31 
32         token.transfer(address(0), Burn);	
33 	}
34 	
35 	
36 	
37 	
38 
39 	/*==============================
40     =      SAFE MATH FUNCTIONS     =
41     ==============================*/  	
42 	
43 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44 		if (a == 0) {
45 			return 0;
46 		}
47 		uint256 c = a * b; 
48 		require(c / a == b);
49 		return c;
50 	}
51 	
52 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
53 		require(b > 0); 
54 		uint256 c = a / b;
55 		return c;
56 	}
57 	
58 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59 		require(b <= a);
60 		uint256 c = a - b;
61 		return c;
62 	}
63 	
64 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
65 		uint256 c = a + b;
66 		require(c >= a);
67 		return c;
68 	}
69     
70 }
71 
72 
73 	/*==============================
74     =        ERC20 Interface       =
75     ==============================*/ 
76 
77 contract ERC20Interface {
78 
79     uint256 public totalSupply;
80     uint256 public decimals;
81     
82     function symbol() public view returns (string);
83     function balanceOf(address _owner) public view returns (uint256 balance);
84     function transfer(address _to, uint256 _value) public returns (bool success);
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
86     function approve(address _spender, uint256 _value) public returns (bool success);
87     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
88 
89     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
90     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
91 }