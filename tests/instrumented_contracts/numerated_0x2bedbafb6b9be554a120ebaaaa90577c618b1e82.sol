1 pragma solidity ^0.4.8;
2 
3 
4  // ERC Token Standard #20 Interface
5  // https://github.com/ethereum/EIPs/issues/20
6 
7  contract ERC20Interface {
8      // Get the total token supply
9      function totalSupply() constant returns (uint256 totalSupply);
10   
11      // Get the account balance of another account with address _owner
12      function balanceOf(address _owner) constant returns (uint256 balance);
13   
14      // Send _value amount of tokens to address _to
15      function transfer(address _to, uint256 _value) returns (bool success);
16   
17      // Send _value amount of tokens from address _from to address _to
18      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
19   
20      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
21      // If this function is called again it overwrites the current allowance with _value.
22      // this function is required for some DEX functionality
23      function approve(address _spender, uint256 _value) returns (bool success);
24   
25      // Returns the amount which _spender is still allowed to withdraw from _owner
26      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27   
28      // Triggered when tokens are transferred.
29      event Transfer(address indexed _from, address indexed _to, uint256 _value);
30   
31      // Triggered whenever approve(address _spender, uint256 _value) is called.
32      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33  }
34 
35 
36  //USDMTB Contract
37   
38  contract USDMTB is ERC20Interface {
39      string public constant symbol = "USDMTB";
40      string public constant name = "USDMTB";
41      uint8 public constant decimals = 2;
42      uint256 _totalSupply = 100000000;
43      
44      // Owner of this contract
45      address public owner;
46   
47      // Balances for each account
48      mapping(address => uint256) balances;
49   
50      // Owner of account approves the transfer of an amount to another account
51      mapping(address => mapping (address => uint256)) allowed;
52   
53      // Functions with this modifier can only be executed by the owner
54      modifier onlyOwner() {
55          if (msg.sender != owner) {
56              revert();
57          }
58          _;
59      }
60   
61      // Constructor
62      function USDMTB() {
63          owner = msg.sender;
64          balances[owner] = _totalSupply;
65      }
66   
67      function totalSupply() constant returns (uint256 totalSupply) {
68          totalSupply = _totalSupply;
69      }
70   
71      // What is the balance of a particular account?
72      function balanceOf(address _owner) constant returns (uint256 balance) {
73          return balances[_owner];
74      }
75   
76      // Transfer the balance from owner's account to another account
77      function transfer(address _to, uint256 _amount) returns (bool success) {
78          if (balances[msg.sender] >= _amount 
79              && _amount > 0
80              && balances[_to] + _amount > balances[_to]) {
81              balances[msg.sender] -= _amount;
82              balances[_to] += _amount;
83              Transfer(msg.sender, _to, _amount);
84              return true;
85          } else {
86              return false;
87          }
88      }
89   
90      // Send _value amount of tokens from address _from to address _to
91      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
92      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
93      // fees in sub-currencies; the command should fail unless the _from account has
94      // deliberately authorized the sender of the message via some mechanism; we propose
95      // these standardized APIs for approval:
96      function transferFrom(
97          address _from,
98          address _to,
99          uint256 _amount
100      ) returns (bool success) {
101          if (balances[_from] >= _amount
102              && allowed[_from][msg.sender] >= _amount
103              && _amount > 0
104              && balances[_to] + _amount > balances[_to]) {
105              balances[_from] -= _amount;
106              allowed[_from][msg.sender] -= _amount;
107              balances[_to] += _amount;
108              Transfer(_from, _to, _amount);
109              return true;
110          } else {
111              return false;
112          }
113      }
114   
115      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
116      // If this function is called again it overwrites the current allowance with _value.
117      function approve(address _spender, uint256 _amount) returns (bool success) {
118          allowed[msg.sender][_spender] = _amount;
119          Approval(msg.sender, _spender, _amount);
120          return true;
121      }
122   
123      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124          return allowed[_owner][_spender];
125      }
126  }