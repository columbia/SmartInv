1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4      // Get the total token supply
5      function totalSupply() constant public returns (uint256 totalSupplyToken);
6      // Get the account balance of another account with address _owner
7      function balanceOf(address _owner) public constant returns (uint256 balance);
8 
9      // Send _value amount of tokens to address _to
10      function transfer(address _to, uint256 _value) public returns (bool success);
11 
12      // Send _value amount of tokens from address _from to address _to
13      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14 
15      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
16      // If this function is called again it overwrites the current allowance with _value.
17      // this function is required for some DEX functionality
18      function approve(address _spender, uint256 _value) public returns (bool success);
19 
20      // Returns the amount which _spender is still allowed to withdraw from _owner
21      function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
22 
23      // Triggered when tokens are transferred.
24      event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26      // Triggered whenever approve(address _spender, uint256 _value) is called.
27      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28  }
29 
30  contract FreelancerCoin is ERC20Interface {
31      string public constant symbol = "LAN";
32      string public constant name = "FreelancerCoin";
33      uint8 public constant decimals = 18;
34      uint256 _totalSupply = 80000000000000000000000000;
35 
36      // Owner of this contract
37      address public owner;
38 
39      // Balances for each account
40      mapping(address => uint256) balances;
41 
42      // Owner of account approves the transfer of an amount to another account
43      mapping(address => mapping (address => uint256)) allowed;
44 
45      // Functions with this modifier can only be executed by the owner
46      modifier onlyOwner() {
47          require(msg.sender != owner); {
48 
49           }
50           _;
51       }
52 
53       // Constructor
54       function FreelancerCoin() public {
55           owner = msg.sender;
56           balances[owner] = _totalSupply;
57       }
58      function totalSupply() constant public returns (uint256 totalSupplyToken) {
59          totalSupplyToken = _totalSupply;
60      }
61       // What is the balance of a particular account?
62       function balanceOf(address _owner) public constant returns (uint256 balance) {
63          return balances[_owner];
64       }
65 
66       // Transfer the balance from owner's account to another account
67       function transfer(address _to, uint256 _amount) public returns (bool success) {
68          if (balances[msg.sender] >= _amount
69               && _amount > 0
70               && balances[_to] + _amount > balances[_to]) {
71               balances[msg.sender] -= _amount;
72               balances[_to] += _amount;
73               Transfer(msg.sender, _to, _amount);
74               return true;
75           } else {
76               return false;
77          }
78       }
79 
80       // Send _value amount of tokens from address _from to address _to
81       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
82       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
83       // fees in sub-currencies; the command should fail unless the _from account has
84       // deliberately authorized the sender of the message via some mechanism; we propose
85       // these standardized APIs for approval:
86       function transferFrom (
87           address _from,
88           address _to,
89          uint256 _amount
90     ) public returns (bool success) {
91        if (balances[_from] >= _amount
92             && allowed[_from][msg.sender] >= _amount
93            && _amount > 0
94             && balances[_to] + _amount > balances[_to]) {
95            balances[_from] -= _amount;
96            allowed[_from][msg.sender] -= _amount;
97             balances[_to] += _amount;
98              Transfer(_from, _to, _amount);
99              return true;
100         } else {
101             return false;
102          }
103      }
104 
105     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
106      // If this function is called again it overwrites the current allowance with _value.
107      function approve(address _spender, uint256 _amount) public returns (bool success) {
108          allowed[msg.sender][_spender] = _amount;
109          Approval(msg.sender, _spender, _amount);
110          return true;
111      }
112 
113      function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
114          return allowed[_owner][_spender];
115      }
116 }