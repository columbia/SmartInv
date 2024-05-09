1 pragma solidity ^0.4.11;
2 
3  // ERC Token Standard #20 Interface
4  // https://github.com/ethereum/EIPs/issues/20
5 
6  contract ERC20Interface {
7      // Get the total token supply
8      function totalSupply() constant returns (uint256 totalSupply);
9   
10      // Get the account balance of another account with address _owner
11      function balanceOf(address _owner) constant returns (uint256 balance);
12   
13      // Send _value amount of tokens to address _to
14      function transfer(address _to, uint256 _value) returns (bool success);
15   
16      // Send _value amount of tokens from address _from to address _to
17      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
18   
19      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
20      // If this function is called again it overwrites the current allowance with _value.
21      // this function is required for some DEX functionality
22      function approve(address _spender, uint256 _value) returns (bool success);
23   
24      // Returns the amount which _spender is still allowed to withdraw from _owner
25      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
26   
27      // Triggered when tokens are transferred.
28      event Transfer(address indexed _from, address indexed _to, uint256 _value);
29   
30      // Triggered whenever approve(address _spender, uint256 _value) is called.
31      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32  }
33 
34 
35  //TravelCoin Contract
36   
37  contract TravelCoin is ERC20Interface {
38      string public constant symbol = "TLC";
39      string public constant name = "TravelCoin";
40      uint8 public constant decimals = 8;
41      uint256 _totalSupply = 2100000000000000000;
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
54          if (msg.sender != owner) {
55              revert();
56          }
57          _;
58      }
59   
60      // Constructor
61      function TravelCoin() {
62          owner = msg.sender;
63          balances[owner] = _totalSupply;
64      }
65   
66      function totalSupply() constant returns (uint256 totalSupply) {
67          totalSupply = _totalSupply;
68      }
69   
70      // What is the balance of a particular account?
71      function balanceOf(address _owner) constant returns (uint256 balance) {
72          return balances[_owner];
73      }
74   
75      // Transfer the balance from owner's account to another account
76      function transfer(address _to, uint256 _amount) returns (bool success) {
77          if (balances[msg.sender] >= _amount 
78              && _amount > 0
79              && balances[_to] + _amount > balances[_to]) {
80              balances[msg.sender] -= _amount;
81              balances[_to] += _amount;
82              Transfer(msg.sender, _to, _amount);
83              return true;
84          } else {
85              return false;
86          }
87      }
88   
89      // Send _value amount of tokens from address _from to address _to
90      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
91      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
92      // fees in sub-currencies; the command should fail unless the _from account has
93      // deliberately authorized the sender of the message via some mechanism; we propose
94      // these standardized APIs for approval:
95      function transferFrom(
96          address _from,
97          address _to,
98          uint256 _amount
99      ) returns (bool success) {
100          if (balances[_from] >= _amount
101              && allowed[_from][msg.sender] >= _amount
102              && _amount > 0
103              && balances[_to] + _amount > balances[_to]) {
104              balances[_from] -= _amount;
105              allowed[_from][msg.sender] -= _amount;
106              balances[_to] += _amount;
107              Transfer(_from, _to, _amount);
108              return true;
109          } else {
110              return false;
111          }
112      }
113   
114      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
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
125  }