1 //Compiled with Solidity v. 0.3.6-3fc68da5/Release-Emscripten/clang
2 // Contract Address: 0x4b19f307dda1be6bc17c999bc29e24633155c990
3 
4 contract SocialNetwork{
5 	
6 
7 	mapping (address => string) public users;
8 	mapping (address => bytes32) public userSecurity;
9 	mapping (address => uint256) public balances;
10 	mapping (address => bool) public loginState;
11 	mapping (address => string) public latestPost;
12 
13     function SocialNetwork(){
14         
15         users[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = "ada turing";
16         balances[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = 4 ether;
17         userSecurity[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = 0x66a7a97dcf29df28f2615d63cd9e9f60ee8ca864642be1628bc1b1aa55bf8526;
18         loginState[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = true;
19         latestPost[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = "money is the root of all devcons";
20         
21     }
22 
23 	function register(string name, string password){
24 		
25 		bytes32 hashedPword = sha256(password);
26 		users[msg.sender] = name;
27 		userSecurity[msg.sender] = hashedPword;
28 
29 	}
30 
31 	function login(string password) returns (bool){
32 
33 		if(userSecurity[msg.sender] == sha256(password)){
34 			loginState[msg.sender] = true;
35 			return true;
36 
37 		}
38 		else{
39 			return false;
40 		}
41 
42 	}
43 
44 	function logout(string password) returns (bool){
45 
46 	if(userSecurity[msg.sender] == sha256(password)){
47 			loginState[msg.sender] = false;
48 			return true;
49 
50 		}
51 		else{
52 			return false;
53 		}
54 	}
55 
56 	function post(string post, address userAddress, string password) returns (string status){
57 		if(loginState[userAddress] == true && userSecurity[userAddress] == sha256(password) ){
58 
59 		latestPost[userAddress] = post;
60 		status = "Post submitted";
61 		return status;
62 		}
63 		else{
64 		status = "You are not logged in";
65 		return status;
66 		}
67 	}
68 
69 	function deposit(address userAddress, string password) returns (string status){
70 		if(loginState[userAddress] == true && userSecurity[userAddress] == sha256(password) ){
71 
72 			balances[userAddress] += msg.value;
73 			status = "Deposit received";
74 			return status;
75 		}
76 		else{
77 			status = "You are not logged in";
78 			return status;
79 		}
80 	}
81 
82 	function withdraw(uint256 amount, address userAddress, string password) returns (string status){
83 		if(loginState[userAddress] == true && userSecurity[userAddress] == sha256(password) ){
84 
85 			if(balances[userAddress] < amount){
86 				status= "You do not have that much.";
87 				return status;
88 			}
89 
90             if(	msg.sender.send(amount)){
91                 balances[userAddress] -= amount;
92             }
93 			
94 			status = "Withdrawal successful";
95 			return status;
96 		}
97 		else{
98 			status = "You are not logged in";
99 			return status;
100 		}
101 	}
102 
103 
104 
105 	
106 	}