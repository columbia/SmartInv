1 pragma solidity ^0.4.19;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function add(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 
23 
24 // We need this interface to interact with out ERC20 - tokencontract
25 contract ERC20Interface {
26          // function totalSupply() public constant returns (uint256);
27       function balanceOf(address tokenOwner) public constant returns (uint256 balance);
28          // function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
29       function transfer(address to, uint256 tokens) public returns (bool success);
30          // function approve(address spender, uint256 tokens) public returns (bool success);
31          // function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
32          // event Transfer(address indexed from, address indexed to, uint256 tokens);
33          // event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
34  } 
35 
36 
37 // ---
38 // Main tokensale class
39 //
40 contract Tokensale
41 {
42 using SafeMath for uint256;
43 
44 address public owner;                  // Owner of this contract, may withdraw ETH and kill this contract
45 address public thisAddress;            // Address of this contract
46 string  public lastaction;             // 
47 uint256 public constant RATE = 1000; // 1 ETH = 1000 RCO-Tokens
48 uint256 public raisedAmount     = 0;   // Raised amount in ETH
49 uint256 public available_tokens = 0;   // Last number of available_tokens BEFORE last payment
50 
51 uint256 public lasttokencount;         // Last ordered token
52 bool    public last_transfer_state;    // Last state (bool) of token transfer
53 
54 
55 
56 // ---
57 // Construktor
58 // 
59 function Tokensale () public
60 {
61 owner       = msg.sender;
62 thisAddress = address(this);
63 } // Construktor
64 
65 
66  
67  
68 
69 
70 
71 // ---
72 // Pay ether to this contract and receive your tokens
73 //
74 function () payable public
75 {
76 address tokenAddress = 0x80248B05a810F685B12C78e51984f808293e57D3;
77 ERC20Interface loveContract = ERC20Interface(tokenAddress); // RTO is 0x80248B05a810F685B12C78e51984f808293e57D3
78 
79 
80 //
81 // Minimum = 0.00125 ETH
82 //
83 if ( msg.value >= 1250000000000000 )
84    {
85    // Calculate tokens to sell
86    uint256 weiAmount = msg.value;
87    uint256 tokens = weiAmount.mul(RATE);
88     
89    // Our current token balance
90    available_tokens = loveContract.balanceOf(thisAddress);    
91     
92    
93    if (available_tokens >= tokens)
94       {      
95       
96       	  lasttokencount = tokens;   
97       	  raisedAmount   = raisedAmount.add(msg.value);
98    
99           // Send tokens to buyer
100           last_transfer_state = loveContract.transfer(msg.sender,  tokens);
101           
102           
103       } // if (available_tokens >= tokens)
104       else
105           {
106           revert();
107           }
108    
109    
110    
111    } // if ( msg.value >= 1250000000000000 )
112    else
113        {
114        revert();
115        }
116 
117 
118 
119 
120 
121 } // ()
122  
123 
124 
125 
126 //
127 // owner_withdraw - Ether withdraw (owner only)
128 //
129 function owner_withdraw () public
130 {
131 if (msg.sender != owner) return;
132 
133 owner.transfer( this.balance );
134 lastaction = "Withdraw";  
135 } // owner_withdraw
136 
137 
138 
139 //
140 // Kill (owner only)
141 //
142 function kill () public
143 {
144 if (msg.sender != owner) return;
145 
146 
147 // Transfer tokens back to owner
148 address tokenAddress = 0x80248B05a810F685B12C78e51984f808293e57D3;
149 ERC20Interface loveContract = ERC20Interface(tokenAddress); // RTO is 0x80248B05a810F685B12C78e51984f808293e57D3
150 
151 uint256 balance = loveContract.balanceOf(this);
152 assert(balance > 0);
153 loveContract.transfer(owner, balance);
154 
155 
156 owner.transfer( this.balance );
157 selfdestruct(owner);
158 } // kill
159 
160 
161 } /* contract Tokensale */