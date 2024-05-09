1 pragma solidity ^0.4.11;
2   
3  // ERC Token Standard #20 Interface
4  contract ERC20Interface {
5      // Get the total token supply
6      function totalSupply() constant returns (uint256 totalSupply);
7   
8      // Get the account balance of another account with address _owner
9      function balanceOf(address _owner) constant returns (uint256 balance);
10   
11      // Send _value amount of tokens to address _to
12      function transfer(address _to, uint256 _value) returns (bool success);
13   
14      // Send _value amount of tokens from address _from to address _to
15      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16   
17      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
18      // If this function is called again it overwrites the current allowance with _value.
19      // this function is required for some DEX functionality
20      function approve(address _spender, uint256 _value) returns (bool success);
21   
22      // Returns the amount which _spender is still allowed to withdraw from _owner
23      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
24   
25      // Triggered when tokens are transferred.
26      event Transfer(address indexed _from, address indexed _to, uint256 _value);
27   
28      // Triggered whenever approve(address _spender, uint256 _value) is called.
29      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30  }
31 
32  contract BP is ERC20Interface {
33      string public constant symbol = "BP";
34      string public constant name = "BP token";
35      uint8 public constant decimals = 18;
36      uint256 _totalSupply = 10 ** 26 * 20;
37      
38      // Owner of this contract
39      address public owner;
40   
41      // Balances for each account
42      mapping(address => uint256) balances;
43   
44      // Owner of account approves the transfer of an amount to another account
45      mapping(address => mapping (address => uint256)) allowed;
46   
47      // Functions with this modifier can only be executed by the owner
48      modifier onlyOwner() {
49          if (msg.sender != owner) {
50               throw;
51           }
52           _;
53       }
54    
55       // Constructor
56       function BP() {
57           owner = msg.sender;
58           balances[owner] = _totalSupply;
59       }
60   
61       function totalSupply() constant returns (uint256 totalSupply) {
62          totalSupply = _totalSupply;
63       }
64   
65       // What is the balance of a particular account?
66       function balanceOf(address _owner) constant returns (uint256 balance) {
67          return balances[_owner];
68       }
69    
70       // Transfer the balance from owner's account to another account
71       function transfer(address _to, uint256 _amount) returns (bool success) {
72          if (balances[msg.sender] >= _amount 
73               && _amount > 0
74               && balances[_to] + _amount > balances[_to]) {
75               balances[msg.sender] -= _amount;
76               balances[_to] += _amount;
77               Transfer(msg.sender, _to, _amount);
78               return true;
79           } else {
80               return false;
81          }
82       }
83    
84       // Send _value amount of tokens from address _from to address _to
85       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
86       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
87       // fees in sub-currencies; the command should fail unless the _from account has
88       // deliberately authorized the sender of the message via some mechanism; we propose
89       // these standardized APIs for approval:
90       function transferFrom(
91           address _from,
92           address _to,
93          uint256 _amount
94     ) returns (bool success) {
95        if (balances[_from] >= _amount
96             && allowed[_from][msg.sender] >= _amount
97            && _amount > 0
98             && balances[_to] + _amount > balances[_to]) {
99            balances[_from] -= _amount;
100            allowed[_from][msg.sender] -= _amount;
101             balances[_to] += _amount;
102              Transfer(_from, _to, _amount);
103              return true;
104         } else {
105             return false;
106          }
107      }
108   
109     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
110      // If this function is called again it overwrites the current allowance with _value.
111      function approve(address _spender, uint256 _amount) returns (bool success) {
112          allowed[msg.sender][_spender] = _amount;
113          Approval(msg.sender, _spender, _amount);
114          return true;
115      }
116   
117      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118          return allowed[_owner][_spender];
119      }
120 
121     // transfer the ownership to new owner 
122     function transferOwnership(address newOwner) onlyOwner {   
123         uint256 amount = balances[owner];    
124         balances[newOwner] +=  amount;
125         balances[owner] -= amount;
126         Transfer(owner, newOwner, amount);
127 
128         owner = newOwner;
129     }
130 }