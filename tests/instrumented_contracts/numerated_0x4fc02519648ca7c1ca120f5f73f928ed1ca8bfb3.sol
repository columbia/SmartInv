1 //Compatible Solidity Compiler Version
2 
3 pragma solidity ^0.4.15;
4 
5 
6 
7 /*
8 This TMX Global Token contract is based on the ERC20 token contract standard. Additional
9 functionality has been integrated:
10 
11 */
12 
13 
14 contract TMXGlobalToken  {
15     //TMX Global Official Token Name
16     string public name;
17     
18     //TMX Global Token Official Symbol
19 	string public symbol;
20 	
21 	//TMX Global Token Decimals
22 	uint8 public decimals; 
23   
24   //database to match user Accounts and their respective balances
25   mapping(address => uint) _balances;
26   mapping(address => mapping( address => uint )) _approvals;
27   
28   //TMX Global Token Hard cap 
29   uint public cap_tmx;
30   
31   //Number of TMX Global Tokens in existence
32   uint public _supply;
33   
34 
35   event TokenMint(address newTokenHolder, uint amountOfTokens);
36   event TokenSwapOver();
37   
38   event Transfer(address indexed from, address indexed to, uint value );
39   event Approval(address indexed owner, address indexed spender, uint value );
40   event mintting(address indexed to, uint value );
41   event minterTransfered(address indexed prevCommand, address indexed nextCommand);
42  
43  //Ethereum address of Authorized Nuru Token Minter
44 address public dev;
45 
46 //check if hard cap reached before mintting new Tokens
47 modifier cap_reached(uint amount) {
48     
49     if((_supply + amount) > cap_tmx) revert();
50     _;
51 }
52 
53 //check if Account is the Authorized Minter
54 modifier onlyMinter {
55     
56       if (msg.sender != dev) revert();
57       _;
58   }
59   
60   //initialize Nuru Token
61   //pass TMX Global Token Configurations to the Constructor
62  function TMXGlobalToken(uint cap_token, uint initial_balance, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
63     
64     cap_tmx = cap_token;
65     _supply += initial_balance;
66     _balances[msg.sender] = initial_balance;
67     
68     decimals = decimalUnits;
69 	symbol = tokenSymbol;
70 	name = tokenName;
71     dev = msg.sender;
72     
73   }
74 
75 //retrieve number of all TMX Global Tokens in existence
76 function totalSupply() public constant returns (uint supply) {
77     return _supply;
78   }
79 
80 //check TMX Global Tokens balance of an Ethereum account
81 function balanceOf(address who) public constant returns (uint value) {
82     return _balances[who];
83   }
84 
85 //check how many TMX Global Tokens a spender is allowed to spend from an owner
86 function allowance(address _owner, address spender) public constant returns (uint _allowance) {
87     return _approvals[_owner][spender];
88   }
89 
90   // A helper to notify if overflow occurs
91 function safeToAdd(uint a, uint b) internal returns (bool) {
92     return (a + b >= a && a + b >= b);
93   }
94 
95 //transfer an amount of TMX Global Tokens to an Ethereum address
96 function transfer(address to, uint value) public returns (bool ok) {
97 
98     if(_balances[msg.sender] < value) revert();
99     
100     if(!safeToAdd(_balances[to], value)) revert();
101     
102 
103     _balances[msg.sender] -= value;
104     _balances[to] += value;
105     Transfer(msg.sender, to, value);
106     return true;
107   }
108 
109 //spend TMX Global Tokens from another Ethereum account that approves you as spender
110 function transferFrom(address from, address to, uint value) public returns (bool ok) {
111     // if you don't have enough balance, throw
112     if(_balances[from] < value) revert();
113 
114     // if you don't have approval, throw
115     if(_approvals[from][msg.sender] < value) revert();
116     
117     if(!safeToAdd(_balances[to], value)) revert();
118     
119     // transfer and return true
120     _approvals[from][msg.sender] -= value;
121     _balances[from] -= value;
122     _balances[to] += value;
123     Transfer(from, to, value);
124     return true;
125   }
126   
127   
128 //allow another Ethereum account to spend TMX Global Tokens from your Account
129 function approve(address spender, uint value)
130     public
131     returns (bool ok) {
132     _approvals[msg.sender][spender] = value;
133     Approval(msg.sender, spender, value);
134     return true;
135   }
136 
137 //mechanism for TMX Global Tokens Creation
138 //only minter can create new TMX Global Tokens
139 //check if TMX Global Token Hard Cap is reached before proceedig - revert if true
140 function mint(address recipient, uint amount) onlyMinter cap_reached(amount) public
141   {
142         
143    _balances[recipient] += amount;  
144    _supply += amount;
145     
146    
147     mintting(recipient, amount);
148   }
149   
150  //transfer the priviledge of creating new TMX Global Tokens to anothe Ethereum account
151 function transferMintership(address newMinter) public onlyMinter returns(bool)
152   {
153     dev = newMinter;
154     
155     minterTransfered(dev, newMinter);
156   }
157   
158 }