1 pragma solidity ^0.4.16;
2  
3 contract ERC20Interface {
4      // Get the total token supply
5      function totalSupply() constant returns (uint256 totalSupply);
6   
7      // Get the account balance of another account with address _owner
8      function balanceOf(address _owner) constant returns (uint256 balance);
9   
10      // Send _value amount of tokens to address _to
11      function transfer(address _to, uint256 _value) returns (bool success);
12   
13      // Send _value amount of tokens from address _from to address _to
14      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15   
16      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17      // If this function is called again it overwrites the current allowance with _value.
18      // this function is required for some DEX functionality
19      function approve(address _spender, uint256 _value) returns (bool success);
20   
21      // Returns the amount which _spender is still allowed to withdraw from _owner
22      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23   
24      // Triggered when tokens are transferred.
25      event Transfer(address indexed _from, address indexed _to, uint256 _value);
26   
27      // Triggered whenever approve(address _spender, uint256 _value) is called.
28      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29  }
30   
31  contract DToken is ERC20Interface {
32      string public constant symbol = "ZKJR";
33      string public constant name = "D-Token";
34      uint8 public constant decimals = 3;
35      uint256 _totalSupply = 1000000;
36      
37      // Owner of this contract
38      address public owner;
39   
40      // Balances for each account
41      mapping(address => uint256) public balances;
42   
43      // Owner of account approves the transfer of an amount to another account
44      mapping(address => mapping (address => uint256)) allowed;
45   
46      // Functions with this modifier can only be executed by the owner
47      modifier onlyOwner() {
48          if (msg.sender != owner) {
49              throw;
50          }
51          _;
52      }
53   
54      // Constructor
55      function DToken() {
56          owner = msg.sender;
57          balances[owner] = _totalSupply;
58      }
59   
60      function totalSupply() constant returns (uint256 totalSupply) {
61          totalSupply = _totalSupply;
62      }
63   
64      // What is the balance of a particular account?
65      function balanceOf(address _owner) constant returns (uint256 balance) {
66          return balances[_owner];
67      }
68   
69      // Transfer the balance from owner's account to another account
70      function transfer(address _to, uint256 _amount) returns (bool success) {
71          if (balances[msg.sender] >= _amount 
72              && _amount > 0
73              && balances[_to] + _amount > balances[_to]) {
74              balances[msg.sender] -= _amount;
75              balances[_to] += _amount;
76              Transfer(msg.sender, _to, _amount);
77              return true;
78          } else {
79              return false;
80          }
81      }
82   
83      // Send _value amount of tokens from address _from to address _to
84      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
85      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
86      // fees in sub-currencies; the command should fail unless the _from account has
87      // deliberately authorized the sender of the message via some mechanism; we propose
88      // these standardized APIs for approval:
89      function transferFrom(
90          address _from,
91          address _to,
92          uint256 _amount
93      ) returns (bool success) {
94          if (balances[_from] >= _amount
95              && allowed[_from][msg.sender] >= _amount
96              && _amount > 0
97              && balances[_to] + _amount > balances[_to]) {
98              balances[_from] -= _amount;
99              allowed[_from][msg.sender] -= _amount;
100              balances[_to] += _amount;
101              Transfer(_from, _to, _amount);
102              return true;
103          } else {
104              return false;
105          }
106      }
107   
108      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
109      // If this function is called again it overwrites the current allowance with _value.
110      function approve(address _spender, uint256 _amount) returns (bool success) {
111          allowed[msg.sender][_spender] = _amount;
112          Approval(msg.sender, _spender, _amount);
113          return true;
114      }
115   
116      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117          return allowed[_owner][_spender];
118      }
119  }