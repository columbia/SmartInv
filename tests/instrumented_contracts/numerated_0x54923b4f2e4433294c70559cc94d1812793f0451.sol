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
13     address public archon; 
14     
15     mapping (address => mapping(address => uint256)) public _token;
16     
17     constructor() public
18     {
19          archon = msg.sender;                                                            
20     }
21     
22     
23     function safeAdd(uint crtbal, uint depbal) public pure returns (uint) 
24     {
25         uint totalbal = crtbal + depbal;
26         return totalbal;
27     }
28     
29     function safeSub(uint crtbal, uint depbal) public pure returns (uint) 
30     {
31         uint totalbal = crtbal - depbal;
32         return totalbal;
33     }
34     
35     /// @notice View balance
36     /// @param token Token contract
37     /// @param user  owner address
38     function balanceOf(address token,address user) public view returns(uint256)            
39     {
40         return Token(token).balanceOf(user);
41     }
42 
43     
44     /// @notice Token transfer
45     /// @param  token Token contract
46     /// @param  tokens value
47     function tokenTransfer(address token, uint256 tokens)public payable                          
48     {
49 
50         _token[msg.sender][token] = safeAdd(_token[msg.sender][token], tokens);
51         Token(token).transferFrom(msg.sender,address(this), tokens);
52 
53     }
54     
55     /// @notice Token withdraw
56     /// @param  token Token contract
57     /// @param  to Receiver address
58     /// @param  tokens value
59     function tokenWithdraw(address token, address to, uint256 tokens)public payable      
60     {
61         if(archon==msg.sender)
62         {                                                                                                        
63             if(Token(token).balanceOf(address(this))>=tokens) 
64             {
65                 _token[msg.sender][token] = safeSub(_token[msg.sender][token] , tokens) ;   
66                 Token(token).transfer(to, tokens);
67             }
68         }
69     }
70     
71     ///@notice Token balance
72     ///@param token Token contract
73     function contract_bal(address token) public view returns(uint256)                       
74     {
75         return Token(token).balanceOf(address(this));
76     }
77     
78     ///@notice Deposit ETH
79     function depositETH() payable external                                                      
80     { 
81         
82     }
83     
84     ///@notice Withdraw ETH
85     ///@param  to Receiver address
86     ///@param  value ethervalue
87     function withdrawETH(address  to, uint256 value) public payable returns (bool)        
88     {
89         
90         if(archon==msg.sender)
91         {                                                                                           
92                  to.transfer(value);
93                  return true;
94     
95          }
96     }
97 }