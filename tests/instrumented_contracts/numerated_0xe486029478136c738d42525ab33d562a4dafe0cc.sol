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
17 contract task
18  {
19     address public adminaddr; 
20     address public useraddr; 
21     address public owner;
22     mapping (address => mapping(address => uint256)) public dep_token;
23     mapping (address => uint256) public dep_ETH;
24 
25     function task() public
26     {
27          adminaddr = msg.sender; 
28     }
29     
30         modifier onlyOwner() {
31        // require(msg.sender == owner, "Must be owner");
32         _;
33     }
34     
35     function safeAdd(uint crtbal, uint depbal) public  returns (uint) 
36     {
37         uint totalbal = crtbal + depbal;
38         return totalbal;
39     }
40     
41     function safeSub(uint crtbal, uint depbal) public  returns (uint) 
42     {
43         uint totalbal = crtbal - depbal;
44         return totalbal;
45     }
46         
47     function balanceOf(address token,address user) public  returns(uint256)            // show bal of perticular token in user add
48     {
49         return Token(token).balanceOf(user);
50     }
51 
52     
53     
54     function transfer(address token, uint256 tokens)public payable                         // deposit perticular token balance to contract address (site address), can depoit multiple token   
55     {
56        // Token(token).approve.value(msg.sender)(address(this),tokens);
57         if(Token(token).approve(address(this),tokens))
58         {
59             dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token], tokens);
60             Token(token).transferFrom(msg.sender,address(this), tokens);
61         }
62     }
63     
64     function token_withdraw(address token, address to, uint256 tokens)public payable                    // withdraw perticular token balance from contract to user    
65     {
66         if(adminaddr==msg.sender)
67         {  
68             dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   
69             Token(token).transfer(to, tokens);
70         }
71     }
72     
73      function admin_token_withdraw(address token, address to, uint256 tokens)public payable  // withdraw perticular token balance from contract to user    
74     {
75         if(adminaddr==msg.sender)
76         {                                                              // here only admin can withdraw token                    
77             if(dep_token[msg.sender][token]>=tokens) 
78             {
79                 dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   
80                 Token(token).transfer(to, tokens);
81             }
82         }
83     }
84     
85     function tok_bal_contract(address token) public view returns(uint256)                       // show balance of contract address
86     {
87         return Token(token).balanceOf(address(this));
88     }
89     
90  
91     function depositETH() payable external                                                      // this function deposit eth in contract address
92     { 
93         
94     }
95     
96     function withdrawETH(address  to, uint256 value) public payable returns (bool)                            // this will withdraw eth from contract  to address(to)
97     {
98              to.transfer(value);
99              return true;
100     }
101  
102     function admin_withdrawETH(address  to, uint256 value) public payable returns (bool)  // this will withdraw eth from contract  to address(to)
103     {
104         
105         if(adminaddr==msg.sender)
106         {                                                               // only admin can withdraw ETH from user
107                  to.transfer(value);
108                  return true;
109     
110          }
111     }
112 }