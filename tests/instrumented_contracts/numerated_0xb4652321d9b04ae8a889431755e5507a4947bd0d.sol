1 pragma solidity 0.4.21;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /// @title Kakushin Solidity Token
35 /// @author PriusLabs
36 contract KakushinToken {
37    
38    using SafeMath for uint256 ;
39    
40     string public name ;
41     string public symbol ;
42     uint8 public decimals = 18;
43    
44    
45     uint256 public totalSupply = 2400000000;
46     
47     address public constant companyWallet = 0xd9240Ac690F7764fC53e151863b5f79105c50E3d ;
48     
49     address public constant founder1Wallet = 0xcE13BC6f7168B309584b70Ae996ec6168c296427 ;    
50     
51     address public constant founder2Wallet = 0xa520044662761ad83b8cfA8Cd63c156F64104B9E ;    
52     
53     address public constant founder3Wallet = 0xF9e2d35b4C23446929330EA327895D754E17784D ;    
54     
55     address public constant founder4Wallet = 0xcc3870Ec7Cc86Cd3f267f17c5d78467d49B9FA2b ;   
56     
57     address public constant owner1 = 0x9c27c3465a7dE3E653417234A60a51C51C9E978e;
58 	
59 	address public constant owner2 = 0x36F7f9cD70b52f4b2b8Ca861fAa4A44D8C1E4Be3;   //Address of Admin Wallet---- //
60     
61     uint startDate;
62     
63     uint endDate = 1530403199 ;
64     
65     
66 
67   
68   
69     mapping (address => uint256) public balances;
70 
71    
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /// @notice Function that implements SafeMath for exponent operations
75     /// @param a Value to be raised to the power of @param b
76     /// @return uint256 result of the operation
77     function safeExp(uint256 a, uint256 b) private pure returns(uint256){
78         if(a == 0) { return 0; }
79         uint256 c = a;
80         uint i;
81         if(b == 0) {
82             c = 1;
83         }
84         else if(b < 0) {
85             for(i = 0; i >= b; i--) {
86                 c = c.div(a);
87             }
88         }
89         else {
90             for(i = 1; i < b; i++) {
91                 c = c.mul(a);
92             }
93         }
94         return c;
95     }
96     
97    /// @dev constructor function for contract, initializes the totalSupply for the owners, sets name and symbol for smart contract token
98     function KakushinToken() public {
99         totalSupply = totalSupply.mul(safeExp(10, uint256(decimals)));  // Update total supply with the decimal amount
100                       // Give the creator all initial tokens
101         name = "KAKUSHIN";                                   // Set the name for display purposes
102         symbol = "KKN";                               // Set the symbol for display purposes
103         balances[owner1] = uint256(59).mul(totalSupply.div(100));
104         balances[companyWallet] = uint256(28).mul(totalSupply.div(100));  
105         balances[founder1Wallet] = uint256(62400000).mul(safeExp(10, uint256(decimals)));
106         balances[founder2Wallet] = uint256(62400000).mul(safeExp(10, uint256(decimals)));
107         balances[founder3Wallet] = uint256(124800000).mul(safeExp(10, uint256(decimals)));
108         balances[founder4Wallet] = uint256(62400000).mul(safeExp(10, uint256(decimals)));
109         startDate = now;
110         
111     }
112     
113     /// @notice send `value` token to `_to` from `msg.sender`
114     /// @param _to The address of the recipient
115     /// @param value The amount of token to be transferred
116     /// @return Whether the transfer was successful or not
117     function transfer(address _to , uint value) public returns (bool success){
118         
119         require(_to != 0x0);
120         
121         require(balances[msg.sender] >= value);
122         
123         startDate = now ;
124         
125        
126         if(msg.sender == owner1 || msg.sender == owner2){
127             
128             balances[_to] = balances[_to].add(value); 
129             balances[msg.sender] = balances[msg.sender].sub(value);
130             
131         }else if(startDate > endDate){
132                   
133             balances[_to] = balances[_to].add(value) ; 
134             balances[msg.sender] = balances[msg.sender].sub(value) ; 
135                   
136         }
137               
138         emit Transfer(msg.sender, _to, value);
139               
140         return true ;
141         
142     }
143     
144     /// @param _owner The address from which the balance will be retrieved
145     /// @return The balance
146     function balanceOf(address _owner) public view returns (uint256) {
147         return balances[_owner];
148     }
149     
150     /// @notice Checks sale is greater than end date
151     /// @return Boolean result of the checking
152     function checkSale() public view returns(bool success) {
153         
154         
155         if(startDate > endDate){
156             return true ;
157         } else {
158             return false;
159         }
160         
161     }
162 
163   
164     
165 }