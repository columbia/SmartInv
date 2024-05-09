1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 
5     mapping (address => uint256) public balanceOf;
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9 }
10 
11 contract Future1Exchange
12  {
13     /// Address of the owner (who can withdraw collected fees) 
14     address public adminaddr; 
15     
16     ///************ Mapping ***********///
17     
18     mapping (address => mapping(address => uint256)) public dep_token;
19     
20     mapping (address => uint256) public dep_ETH;
21 
22     ///*********** Constructor *********///
23     constructor() public
24     {
25          adminaddr = msg.sender;                                                            
26     }
27     
28     
29     function safeAdd(uint crtbal, uint depbal) public pure returns (uint) 
30     {
31         uint totalbal = crtbal + depbal;
32         return totalbal;
33     }
34     
35     function safeSub(uint crtbal, uint depbal) public pure returns (uint) 
36     {
37         uint totalbal = crtbal - depbal;
38         return totalbal;
39     }
40     
41     /// @notice This function allows to view the balance of token in given user
42     /// @param token Token contract
43     /// @param user  owner address
44     function balanceOf(address token,address user) public view returns(uint256)            
45     {
46         return Token(token).balanceOf(user);
47     }
48 
49     
50     /// @notice This function allows to transfer ERC20 tokens.
51     /// @param  token Token contract
52     /// @param  tokens value
53     function token_transfer(address token, uint256 tokens)public payable                          
54     {
55        // Token(token).approve.value(msg.sender)(address(this),tokens);
56         if(Token(token).approve(address(this),tokens))
57         {
58             dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token], tokens);
59             Token(token).transferFrom(msg.sender,address(this), tokens);
60         }
61     }
62     
63     
64     /// @notice  This function allows the owner to withdraw ERC20 tokens.
65     /// @param  token Token contract
66     /// @param  to Receiver address
67     /// @param  tokens value
68     function admin_token_withdraw(address token, address to, uint256 tokens)public payable      
69     {
70         if(adminaddr==msg.sender)
71         {                                                                                                        
72             if(dep_token[msg.sender][token]>=tokens) 
73             {
74                 dep_token[msg.sender][token] = safeSub(dep_token[msg.sender][token] , tokens) ;   
75                 Token(token).transfer(to, tokens);
76             }
77         }
78     }
79     
80     ///@notice This function allows to check the token balance in contract address
81     ///@param token Token contract
82     function contract_bal(address token) public view returns(uint256)                       
83     {
84         return Token(token).balanceOf(address(this));
85     }
86     
87     ///@notice This function allows to deposit ether in contract address
88     function depositETH() payable external                                                      
89     { 
90         
91     }
92     
93     
94     ///@notice This function allows admin to withdraw ether
95     ///@param  to Receiver address
96     ///@param  value ethervalue
97     function admin_withdrawETH(address  to, uint256 value) public payable returns (bool)        
98     {
99         
100         if(adminaddr==msg.sender)
101         {                                                                                           
102                  to.transfer(value);
103                  return true;
104     
105          }
106     }
107 }