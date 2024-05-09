1 pragma solidity ^0.4.8;
2   
3  // ----------------------------------------------------------------------------------------------
4  // ERC20 token contract
5  // BlockchainMX / NewCryptoOrder 2018.
6  // ----------------------------------------------------------------------------------------------
7   
8  // ERC Token Standard #20 Interface
9  // https://github.com/ethereum/EIPs/issues/20
10  contract ERC20Interface {
11      // Get the total token supply
12      function totalSupply() constant returns (uint256 totalSupply);
13   
14      // Get the account balance of another account with address _owner
15      function balanceOf(address _owner) constant returns (uint256 balance);
16   
17      // Send _value amount of tokens to address _to
18      function transfer(address _to, uint256 _value) returns (bool success);
19   
20      // Send _value amount of tokens from address _from to address _to
21      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22   
23      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
24      // If this function is called again it overwrites the current allowance with _value.
25      // this function is required for some DEX functionality
26      function approve(address _spender, uint256 _value) returns (bool success);
27   
28      // Returns the amount which _spender is still allowed to withdraw from _owner
29      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30   
31      // Triggered when tokens are transferred.
32      event Transfer(address indexed _from, address indexed _to, uint256 _value);
33   
34      // Triggered whenever approve(address _spender, uint256 _value) is called.
35      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36  }
37   
38  contract PryvCn is ERC20Interface {
39      string public constant symbol = "PRYV";
40      string public constant name = "pryvateCoin";
41      uint8 public constant decimals = 18;
42      uint256 _totalSupply = 200000000000000000000000000;
43     //price code here
44     uint256 public constant unitsOneEthCanBuy = 833333; 
45     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
46     //address public fundsWallet; 
47     //price code here
48 
49      // Owner of this contract
50      address public owner;
51   
52      // Balances for each account
53      mapping(address => uint256) balances;
54   
55      // Owner of account approves the transfer of an amount to another account
56      mapping(address => mapping (address => uint256)) allowed;
57   
58 
59      // Functions with this modifier can only be executed by the owner
60      modifier onlyOwner() {
61          if (msg.sender != owner) {
62              throw;
63          }
64          _;
65      }
66   
67      // Constructor
68      function PryvCn() {
69          owner = msg.sender;
70          balances[owner] = _totalSupply;
71      }
72   
73      function totalSupply() constant returns (uint256 totalSupply) {
74          totalSupply = _totalSupply;
75      }
76   
77      // What is the balance of a particular account?
78      function balanceOf(address _owner) constant returns (uint256 balance) {
79          return balances[_owner];
80      }
81 
82 
83 
84     //payment code here
85     function() payable{
86         totalEthInWei = totalEthInWei + msg.value;
87         uint256 amount = msg.value * unitsOneEthCanBuy;
88         if (balances[owner] < amount) {
89             return;
90         }
91 
92         balances[owner] = balances[owner] - amount;
93         balances[msg.sender] = balances[msg.sender] + amount;
94 
95         Transfer(owner, msg.sender, amount); // Broadcast a message to the blockchain
96 
97         //Transfer ether to fundsWallet (owner)
98         owner.transfer(msg.value);                               
99     }
100     //payment code here
101 
102 
103 
104 
105      // Transfer the balance from owner's account to another account
106      function transfer(address _to, uint256 _amount) returns (bool success) {
107          if (balances[msg.sender] >= _amount 
108              && _amount > 0
109              && balances[_to] + _amount > balances[_to]) {
110              balances[msg.sender] -= _amount;
111              balances[_to] += _amount;
112              Transfer(msg.sender, _to, _amount);
113              return true;
114          } else {
115              return false;
116          }
117      }
118   
119      // Send _value amount of tokens from address _from to address _to
120      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
121      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
122      // fees in sub-currencies; the command should fail unless the _from account has
123      // deliberately authorized the sender of the message via some mechanism; we propose
124      // these standardized APIs for approval:
125      function transferFrom(
126          address _from,
127          address _to,
128          uint256 _amount
129      ) returns (bool success) {
130          if (balances[_from] >= _amount
131              && allowed[_from][msg.sender] >= _amount
132              && _amount > 0
133              && balances[_to] + _amount > balances[_to]) {
134              balances[_from] -= _amount;
135              allowed[_from][msg.sender] -= _amount;
136              balances[_to] += _amount;
137              Transfer(_from, _to, _amount);
138              return true;
139          } else {
140              return false;
141          }
142      }
143   
144      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
145      // If this function is called again it overwrites the current allowance with _value.
146      function approve(address _spender, uint256 _amount) returns (bool success) {
147          allowed[msg.sender][_spender] = _amount;
148          Approval(msg.sender, _spender, _amount);
149          return true;
150      }
151   
152      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153          return allowed[_owner][_spender];
154      }
155  }