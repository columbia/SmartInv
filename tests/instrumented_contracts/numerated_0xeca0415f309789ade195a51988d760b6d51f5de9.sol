1 pragma solidity ^0.4.11;
2 
3 //----------------------------------------------------------------------------------------------
4 // GreenMed token contract
5 // The MIT Licence.
6 //----------------------------------------------------------------------------------------------
7    
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/issues/20
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
38  contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
39   
40  contract GreenMed is ERC20Interface {
41      string public constant symbol = "GRMD";
42      string public constant name = "GreenMed";
43      uint8 public constant decimals = 18;
44      uint256 _totalSupply = 100000000000000000000000000;
45      
46      // Owner of this contract
47      address public owner;
48 
49     uint256 public sellPrice;
50     uint256 public buyPrice;
51 
52     mapping (address => bool) public frozenAccount;
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event FrozenFunds(address target, bool frozen);
56   
57      // Balances for each account
58      mapping(address => uint256) balances;
59   
60      // Owner of account approves the transfer of an amount to another account
61      mapping(address => mapping (address => uint256)) allowed;
62   
63      // Functions with this modifier can only be executed by the owner
64      modifier onlyOwner() {
65          if (msg.sender != owner) {
66              throw;
67          }
68          _;
69      }
70   
71      // Constructor
72      function GreenMed() {
73          owner = msg.sender;
74          balances[owner] = _totalSupply;
75      }
76   
77      function totalSupply() constant returns (uint256 totalSupply) {
78          totalSupply = _totalSupply;
79      }
80   
81      // What is the balance of a particular account?
82      function balanceOf(address _owner) constant returns (uint256 balance) {
83          return balances[_owner];
84      }
85   
86      // Transfer the balance from owner's account to another account
87      function transfer(address _to, uint256 _amount) returns (bool success) {
88          if (balances[msg.sender] >= _amount 
89              && _amount > 0
90              && balances[_to] + _amount > balances[_to]) {
91              balances[msg.sender] -= _amount;
92              balances[_to] += _amount;
93              Transfer(msg.sender, _to, _amount);
94              return true;
95          } else {
96              return false;
97          }
98      }
99   
100      // Send _value amount of tokens from address _from to address _to
101      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
102      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
103      // fees in sub-currencies; the command should fail unless the _from account has
104      // deliberately authorized the sender of the message via some mechanism; we propose
105      // these standardized APIs for approval:
106      function transferFrom(
107          address _from,
108          address _to,
109          uint256 _amount
110      ) returns (bool success) {
111          if (balances[_from] >= _amount
112              && allowed[_from][msg.sender] >= _amount
113              && _amount > 0
114              && balances[_to] + _amount > balances[_to]) {
115              balances[_from] -= _amount;
116              allowed[_from][msg.sender] -= _amount;
117              balances[_to] += _amount;
118              Transfer(_from, _to, _amount);
119              return true;
120          } else {
121              return false;
122          }
123      }
124   
125      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
126      // If this function is called again it overwrites the current allowance with _value.
127      function approve(address _spender, uint256 _amount) returns (bool success) {
128          allowed[msg.sender][_spender] = _amount;
129          Approval(msg.sender, _spender, _amount);
130          return true;
131      }
132 
133      /* Approve and then communicate the approved contract in a single tx */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135         returns (bool success) {    
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143   
144      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145          return allowed[_owner][_spender];
146      }
147      function freezeAccount(address target, bool freeze) onlyOwner {
148         frozenAccount[target] = freeze;
149         FrozenFunds(target, freeze);
150     }
151 
152     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
153         sellPrice = newSellPrice;
154         buyPrice = newBuyPrice;
155     }
156 
157     function buy() payable {
158         uint amount = msg.value / buyPrice;                // calculates the amount
159         if (balances[this] < amount) throw;               // checks if it has enough to sell
160         balances[msg.sender] += amount;                   // adds the amount to buyer's balance
161         balances[this] -= amount;                         // subtracts amount from seller's balance
162         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
163     }
164 
165     function sell(uint256 amount) {
166         if (balances[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
167         balances[this] += amount;                         // adds the amount to owner's balance
168         balances[msg.sender] -= amount;                   // subtracts the amount from seller's balance
169         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
170             throw;                                         // to do this last to avoid recursion attacks
171         } else {
172             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
173         }               
174     }
175  }