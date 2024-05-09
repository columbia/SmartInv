1 pragma solidity ^0.4.23;
2 
3 
4 // ----------------------------------------------------------------------------
5 // ICEDIUM ERC20 Token
6 //
7 // Genesis Wallet : 0xDECcDEC1C4fD0B2Ae4207cEb09076C591528373b
8 // Symbol         : ICD
9 // Name           : ICEDIUM
10 // Total supply   : 300 000 000 000
11 // Decimals       : 18
12 //
13 // (c) by ICEDIUM GROUP 2019
14 // ----------------------------------------------------------------------------
15 
16 contract ERC20Interface {
17     function totalSupply() public view returns (uint);
18     function balanceOf(address tokenOwner) public view returns (uint balance);
19     function transfer(address to, uint tokens) public returns (bool success);
20     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26     // ------------------------------------------------------------------------
27     // ERC20 Token, with the addition of symbol, name and decimals supply and founder
28     // ------------------------------------------------------------------------
29 contract ICEDIUM is ERC20Interface{
30     string public name = "ICEDIUM";
31     string public symbol = "ICD";
32     uint8 public decimals = 18;
33     // (300 mln with 18 decimals) 
34     uint public supply; 
35     address public founder;
36     mapping(address => uint) public balances;
37     mapping(address => mapping(address => uint)) allowed;
38     //allowed[0x111...owner][0x2222...spender] = 100;
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41     // ------------------------------------------------------------------------
42     // Constructor With 300 000 000 supply, All deployed tokens sent to Genesis wallet
43     // ------------------------------------------------------------------------
44     constructor() public{
45         supply = 300000000000000000000000000;
46         founder = msg.sender;
47         balances[founder] = supply;
48     }
49     // ------------------------------------------------------------------------
50     // Returns the amount of tokens approved by the owner that can be
51     // transferred to the spender's account
52     // ------------------------------------------------------------------------
53     function allowance(address tokenOwner, address spender) public view returns(uint){
54         return allowed[tokenOwner][spender];
55     }
56     // ------------------------------------------------------------------------
57     // Token owner can approve for spender to transferFrom(...) tokens
58     // from the token owner's account
59     // ------------------------------------------------------------------------
60     function approve(address spender, uint tokens) public returns(bool){
61         allowed[msg.sender][spender] = tokens;
62         emit Approval(msg.sender, spender, tokens);
63         return true;
64     }
65     // ------------------------------------------------------------------------
66     //  Transfer tokens from the 'from' account to the 'to' account
67     // ------------------------------------------------------------------------
68     function transferFrom(address from, address to, uint tokens) public returns(bool){
69         require(allowed[from][msg.sender] >= tokens);
70         require(balances[from] >= tokens);
71 
72         balances[from] -= tokens;
73         balances[to] += tokens;
74         allowed[from][msg.sender] -= tokens;
75 
76         emit Transfer(from, to, tokens);
77 
78         return true;
79     }
80     // ------------------------------------------------------------------------
81     // Public function to return supply
82     // ------------------------------------------------------------------------
83     function totalSupply() public view returns (uint){
84         return supply;
85     }
86     // ------------------------------------------------------------------------
87     // Public function to return balance of tokenOwner
88     // ------------------------------------------------------------------------
89     function balanceOf(address tokenOwner) public view returns (uint balance){
90         return balances[tokenOwner];
91     }
92     // ------------------------------------------------------------------------
93     // Public Function to transfer tokens
94     // ------------------------------------------------------------------------
95     function transfer(address to, uint tokens) public returns (bool success){
96         require(balances[msg.sender] >= tokens && tokens > 0);
97         balances[to] += tokens;
98         balances[msg.sender] -= tokens;
99         emit Transfer(msg.sender, to, tokens);
100         return true;
101     } 
102     // ------------------------------------------------------------------------
103     // Revert function to NOT accept ETH
104     // ------------------------------------------------------------------------
105     function () public payable {
106         revert();
107     }
108 }