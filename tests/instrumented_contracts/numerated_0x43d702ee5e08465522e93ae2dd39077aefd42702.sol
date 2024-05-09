1 pragma solidity ^0.4.13;
2   
3  // ----------------------------------------------------------------------------------------------
4  // Special coin of Midnighters Club Facebook community
5  // https://facebook.com/theMidnightersClub/
6  // ----------------------------------------------------------------------------------------------
7   
8  // ERC Token Standard #20 Interface
9  // https://github.com/ethereum/EIPs/issues/20
10  contract ERC20 {
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
38  contract Owned {
39     address public owner;
40 
41     function Owned() {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner {
51         owner = newOwner;
52     }
53 }
54   
55  contract MidnightCoin is ERC20, Owned {
56      string public constant symbol = "MNC";
57      string public constant name = "Midnight Coin";
58      uint8 public constant decimals = 18;
59      uint256 _totalSupply = 100000000000000000000;
60      uint public constant FREEZE_PERIOD = 1 years;
61      uint public crowdSaleStartTimestamp;
62      string public lastLoveLetter = "";
63      
64      // Balances for each account
65      mapping(address => uint256) balances;
66   
67      // Owner of account approves the transfer of an amount to another account
68      mapping(address => mapping (address => uint256)) allowed;
69      
70 
71      // Constructor
72      function MidnightCoin() {
73          owner = msg.sender;
74          balances[owner] = 1000000000000000000;
75          crowdSaleStartTimestamp = now + 7 days;
76      }
77   
78      function totalSupply() constant returns (uint256 totalSupply) {
79          totalSupply = _totalSupply;
80      }
81   
82      // What is the balance of a particular account?
83      function balanceOf(address _owner) constant returns (uint256 balance) {
84          return balances[_owner];
85      }
86   
87      // Transfer the balance from owner's account to another account
88      function transfer(address _to, uint256 _amount) returns (bool success) {
89          if (balances[msg.sender] >= _amount 
90              && _amount > 0
91              && balances[_to] + _amount > balances[_to]) {
92              balances[msg.sender] -= _amount;
93              balances[_to] += _amount;
94              Transfer(msg.sender, _to, _amount);
95              return true;
96          } else {
97              return false;
98          }
99      }
100   
101      // Send _value amount of tokens from address _from to address _to
102      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
103      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
104      // fees in sub-currencies; the command should fail unless the _from account has
105      // deliberately authorized the sender of the message via some mechanism; we propose
106      // these standardized APIs for approval:
107      function transferFrom(
108      address _from,
109          address _to,
110          uint256 _amount
111      ) returns (bool success) {
112          if (balances[_from] >= _amount
113              && allowed[_from][msg.sender] >= _amount
114              && _amount > 0
115              && balances[_to] + _amount > balances[_to]) {
116              balances[_from] -= _amount;
117              allowed[_from][msg.sender] -= _amount;
118              balances[_to] += _amount;
119              Transfer(_from, _to, _amount);
120              return true;
121          } else {
122              return false;
123          }
124      }
125   
126      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
127      // If this function is called again it overwrites the current allowance with _value.
128      function approve(address _spender, uint256 _amount) returns (bool success) {
129          allowed[msg.sender][_spender] = _amount;
130          Approval(msg.sender, _spender, _amount);
131          return true;
132      }
133   
134      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135          return allowed[_owner][_spender];
136      }
137      
138      // features
139      
140      function kill() onlyOwner {
141         selfdestruct(owner);
142      }
143 
144      function withdraw() public onlyOwner {
145         require( _totalSupply == 0 );
146         owner.transfer(this.balance);
147      }
148   
149      function buyMNC(string _loveletter) payable{
150         require (now > crowdSaleStartTimestamp);
151         require( _totalSupply >= msg.value);
152         balances[msg.sender] += msg.value;
153         _totalSupply -= msg.value;
154         lastLoveLetter = _loveletter;
155      }
156      
157      function sellMNC(uint256 _amount) {
158         require (now > crowdSaleStartTimestamp + FREEZE_PERIOD);
159         require( balances[msg.sender] >= _amount);
160         balances[msg.sender] -= _amount;
161         _totalSupply += _amount;
162         msg.sender.transfer(_amount);
163      }
164      
165      function() payable{
166         buyMNC("Hi! I am anonymous holder");
167      }
168      
169  }