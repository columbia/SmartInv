1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 contract GasToken is ERC20Interface {
20     // Public variables of the token
21     string public constant name = "Gas";
22     string public constant symbol = "GAS";
23     uint8 public constant decimals = 18;
24     
25     uint256 public _totalSupply;
26 
27     mapping (address => uint256) balances;
28     
29     // Owner of account approves the transfer of an amount to another account
30     mapping(address => mapping (address => uint256)) allowed;
31 
32     constructor() public {
33         _totalSupply = 0;
34     }
35     
36     // ------------------------------------------------------------------------
37     // Total supply
38     // ------------------------------------------------------------------------
39     function totalSupply() public view returns (uint) {
40         return _totalSupply;
41     }
42 
43     // ------------------------------------------------------------------------
44     // Get the token balance for account `tokenOwner`
45     // ------------------------------------------------------------------------
46     function balanceOf(address tokenOwner) public view returns (uint balance) {
47         return balances[tokenOwner];
48     }
49     
50     // ------------------------------------------------------------------------
51     // Returns the amount of tokens approved by the owner that can be
52     // transferred to the spender's account
53     // ------------------------------------------------------------------------
54     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
55         return allowed[tokenOwner][spender];
56     }
57 
58     // ------------------------------------------------------------------------
59     // Buy gas at the transaction's gas gasprice.
60     // ------------------------------------------------------------------------
61     function buy() public payable returns (uint tokens) {
62         tokens = msg.value / tx.gasprice;
63         balances[msg.sender] += tokens;
64         _totalSupply += tokens;
65         return tokens;
66     }
67     
68     // ------------------------------------------------------------------------
69     // Sell gas at the transaction's gas gasprice.
70     // ------------------------------------------------------------------------    
71     function sell(uint tokens) public returns (uint revenue) {
72         require(balances[msg.sender] >= tokens);           // Check if the sender has enough
73         balances[msg.sender] -= tokens;        
74         _totalSupply -= tokens;
75         revenue = tokens * tx.gasprice;
76         msg.sender.transfer(revenue);
77         return revenue;
78     }
79 
80     // ------------------------------------------------------------------------
81     // Transfer the balance from token owner's account to `to` account
82     // - Owner's account must have sufficient balance to transfer
83     // - 0 value transfers are allowed
84     // ------------------------------------------------------------------------
85     function transfer(address to, uint tokens) public returns (bool success) {
86         require(balances[msg.sender] >= tokens);           // Check if the sender has enough
87         require(balances[to] + tokens >= balances[to]);  // Check for overflows
88         balances[msg.sender] -= tokens;                    // Subtract from the sender
89         balances[to] += tokens;                           // Add the same to the recipient
90         emit Transfer(msg.sender, to, tokens);
91         return true;
92     }
93 
94     // Send `tokens` amount of tokens from address `from` to address `to`
95     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
96     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
97     // fees in sub-currencies; the command should fail unless the _from account has
98     // deliberately authorized the sender of the message via some mechanism; we propose
99     // these standardized APIs for approval:
100     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
101         require(balances[msg.sender] >= tokens);
102         require(allowed[from][msg.sender] >= tokens);
103         balances[from] -= tokens;
104         allowed[from][msg.sender] -= tokens;
105         balances[to] += tokens;
106         emit Transfer(from, to, tokens);
107         return true;
108     }
109  
110     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
111     // If this function is called again it overwrites the current allowance with _value.
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         emit Approval(msg.sender, spender, tokens);
115         return true;
116     }
117     
118     // ------------------------------------------------------------------------
119     // Don't accept ETH
120     // ------------------------------------------------------------------------
121     function () external payable {
122         revert();
123     }
124 }