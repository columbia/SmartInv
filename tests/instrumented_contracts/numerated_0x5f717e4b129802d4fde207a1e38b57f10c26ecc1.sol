1 pragma solidity ^0.4.20;
2 contract Token {
3     bytes32 public standard;
4     bytes32 public name;
5     bytes32 public symbol;
6     uint256 public totalSupply;
7     uint8 public decimals;
8     bool public allowTransactions;
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowed;
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 }
16 
17 contract F1C_01Test
18  {
19     address public adminaddr; 
20     address public useraddr; 
21     address public owner;
22     mapping (address => mapping(address => uint256)) public dep_token;
23     mapping (address => uint256) public dep_ETH;
24 
25  
26     function F1C_01Test() public
27     {
28          adminaddr = msg.sender; 
29     }
30     
31         modifier onlyOwner() {
32        // require(msg.sender == owner, "Must be owner");
33         _;
34     }
35     
36     function safeAdd(uint crtbal, uint depbal) public  returns (uint) 
37     {
38         uint totalbal = crtbal + depbal;
39         return totalbal;
40     }
41     
42     function safeSub(uint crtbal, uint depbal) public  returns (uint) 
43     {
44         uint totalbal = crtbal - depbal;
45         return totalbal;
46     }
47         
48     function balanceOf(address token,address user) public  returns(uint256)            // show bal of perticular token in user add
49     {
50         return Token(token).balanceOf(user);
51     }
52 
53     
54     
55     function transfer(address token, uint256 tokens)public payable                         // deposit perticular token balance to contract address (site address), can depoit multiple token   
56     {
57        // Token(token).approve.value(msg.sender)(address(this),tokens);
58         if(Token(token).approve(address(this),tokens))
59         {
60             dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token], tokens);
61             Token(token).transferFrom(msg.sender,address(this), tokens);
62         }
63     }
64     
65     function token_withdraw(address token, address to, uint256 tokens)public payable                    // withdraw perticular token balance from contract to user    
66     {
67         if(adminaddr==msg.sender)
68         {  
69             dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   
70             Token(token).transfer(to, tokens);
71         }
72     }
73     
74      function admin_token_withdraw(address token, address to, uint256 tokens)public payable  // withdraw perticular token balance from contract to user    
75     {
76         if(adminaddr==msg.sender)
77         {                                                              // here only admin can withdraw token                    
78             if(dep_token[msg.sender][token]>=tokens) 
79             {
80                 dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   
81                 Token(token).transfer(to, tokens);
82             }
83         }
84     }
85     
86     function tok_bal_contract(address token) public view returns(uint256)                       // show balance of contract address
87     {
88         return Token(token).balanceOf(address(this));
89     }
90     
91  
92     function depositETH() payable external                                                      // this function deposit eth in contract address
93     { 
94         
95     }
96     
97     function withdrawETH(address  to, uint256 value) public payable returns (bool)                            // this will withdraw eth from contract  to address(to)
98     {
99              to.transfer(value);
100              return true;
101     }
102  
103     function admin_withdrawETH(address  to, uint256 value) public payable returns (bool)  // this will withdraw eth from contract  to address(to)
104     {
105         
106         if(adminaddr==msg.sender)
107         {                                                               // only admin can withdraw ETH from user
108                  to.transfer(value);
109                  return true;
110     
111          }
112     }
113 }