1 //--------------------------------------------------------------------------------
2      // OTOCASH fixed supply token contract
3      // OTOCASH @ 2018 OTOCASH.IO. OTOCASH.TO OTOCASH.CO.
4      // = One Hundred Million Tokens Only =
5      //--------------------------------------------------------------------------------
6      
7      pragma solidity ^0.4.13;
8      
9     contract Token {
10      // Get the total token supply
11      function totalSupply() constant returns (uint256 totalSupply);
12   
13      // Get the account balance of another account with address _owner
14      function balanceOf(address _owner) constant returns (uint256 balance);
15   
16      // Send _value amount of tokens to address _to
17      function transfer(address _to, uint256 _value) returns (bool success);
18   
19      // Send _value amount of tokens from address _from to address _to
20      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21   
22      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
23      // If this function is called again it overwrites the current allowance with _value.
24      // this function is required for some DEX functionality
25      function approve(address _spender, uint256 _value) returns (bool success);
26   
27      // Returns the amount which _spender is still allowed to withdraw from _owner
28      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
29   
30      // Triggered when tokens are transferred.
31      event Transfer(address indexed _from, address indexed _to, uint256 _value);
32   
33      // Triggered whenever approve(address _spender, uint256 _value) is called.
34      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35  }
36   
37  contract OTOCASH is Token {
38      string public constant symbol = "OTO";
39      string public constant name = "OTOCASH";
40      uint8 public constant decimals = 18;
41      uint256 _totalSupply = 100000000000000000000000000;
42      
43      // Owner of this contract
44      address public owner;
45   
46      // Balances for each account
47      mapping(address => uint256) balances;
48   
49      // Owner of account approves the transfer of an amount to another account
50      mapping(address => mapping (address => uint256)) allowed;
51   
52      // Functions with this modifier can only be executed by the owner
53      modifier onlyOwner() {
54          require(msg.sender != owner); {
55              
56           }
57           _;
58       }
59    
60       // Constructor
61       function OTOCASH() {
62           owner = msg.sender;
63           balances[owner] = _totalSupply;
64       }
65   
66       function totalSupply() constant returns (uint256 totalSupply) {
67          totalSupply = _totalSupply;
68       }
69   
70       // What is the balance of a particular account?
71       function balanceOf(address _owner) constant returns (uint256 balance) {
72          return balances[_owner];
73       }
74    
75       // Transfer the balance from owner's account to another account
76       function transfer(address _to, uint256 _amount) returns (bool success) {
77          if (balances[msg.sender] >= _amount 
78               && _amount > 0
79               && balances[_to] + _amount > balances[_to]) {
80               balances[msg.sender] -= _amount;
81               balances[_to] += _amount;
82               Transfer(msg.sender, _to, _amount);
83               return true;
84           } else {
85               return false;
86          }
87       }
88    
89       // Send _value amount of tokens from address _from to address _to
90       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
91       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
92       // fees in sub-currencies; the command should fail unless the _from account has
93       // deliberately authorized the sender of the message via some mechanism; we propose
94       // these standardized APIs for approval:
95       function transferFrom(
96           address _from,
97           address _to,
98          uint256 _amount
99     ) returns (bool success) {
100        if (balances[_from] >= _amount
101             && allowed[_from][msg.sender] >= _amount
102            && _amount > 0
103             && balances[_to] + _amount > balances[_to]) {
104            balances[_from] -= _amount;
105            allowed[_from][msg.sender] -= _amount;
106             balances[_to] += _amount;
107              Transfer(_from, _to, _amount);
108              return true;
109         } else {
110             return false;
111          }
112      }
113   
114     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
115      // If this function is called again it overwrites the current allowance with _value.
116      function approve(address _spender, uint256 _amount) returns (bool success) {
117          allowed[msg.sender][_spender] = _amount;
118          Approval(msg.sender, _spender, _amount);
119          return true;
120      }
121   
122      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123          return allowed[_owner][_spender];
124      }
125 }