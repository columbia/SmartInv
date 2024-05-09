1 pragma solidity ^0.4.15;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 // ERC Token Standard #20 Interface
9  // https://github.com/ethereum/EIPs/issues/20
10  contract ERC20Interface {
11  // Get the total token supply
12       function totalSupply() constant returns (uint256);
13    
14       // Get the account balance of another account with address _owner
15       function balanceOf(address _owner) constant returns (uint256 balance);
16    
17       // Send _value amount of tokens to address _to
18       function transfer(address _to, uint256 _value) returns (bool success);
19    
20       // Send _value amount of tokens from address _from to address _to
21       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22   
23       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
24       // If this function is called again it overwrites the current allowance with _value.
25       // this function is required for some DEX functionality
26       function approve(address _spender, uint256 _value) returns (bool success);
27    
28       // Returns the amount which _spender is still allowed to withdraw from _owner
29       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30    
31       // Triggered when tokens are transferred.
32       event Transfer(address indexed _from, address indexed _to, uint256 _value);
33    
34       // Triggered whenever approve(address _spender, uint256 _value) is called.
35       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36   }
37    
38  contract PotaToken is ERC20Interface {
39       string public constant symbol = "POTATO";
40       string public constant name = "PotaToken";
41       uint8 public constant decimals = 6;
42       uint256 _totalSupply = 1;
43 	  uint256 deadline;
44       
45       // Owner of this contract
46       address public owner;
47    
48       // Balances for each account
49       mapping(address => uint256) balances;
50    
51       // Owner of account approves the transfer of an amount to another account
52       mapping(address => mapping (address => uint256)) allowed;
53    
54       // Functions with this modifier can only be executed by the owner
55       modifier onlyOwner() {
56           if (msg.sender != owner) {
57               revert();
58           }
59           _;
60       }
61    
62       // Constructor
63       function PotaToken() {
64           owner = msg.sender;
65           balances[owner] = _totalSupply;
66 		  deadline = now + 14 * 1 days;
67       }
68    
69       function totalSupply() constant returns (uint256) {
70           return _totalSupply;
71       }
72    
73       // What is the balance of a particular account?
74       function balanceOf(address _owner) constant returns (uint256 balance) {
75           return balances[_owner];
76       }
77    
78       // Transfer the balance from owner's account to another account
79       function transfer(address _to, uint256 _amount) returns (bool success) {
80           if (balances[msg.sender] >= _amount 
81               && _amount > 0
82               && balances[_to] + _amount > balances[_to]) {
83              balances[msg.sender] -= _amount;
84              balances[_to] += _amount;
85              Transfer(msg.sender, _to, _amount);
86              return true;
87          } else {
88              return false;
89          }
90       }
91   
92      // Send _value amount of tokens from address _from to address _to
93      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
94      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
95      // fees in sub-currencies; the command should fail unless the _from account has
96      // deliberately authorized the sender of the message via some mechanism; we propose
97      // these standardized APIs for approval:
98      function transferFrom(
99          address _from,
100          address _to,
101          uint256 _amount
102      ) returns (bool success) {
103          if (balances[_from] >= _amount
104              && allowed[_from][msg.sender] >= _amount
105              && _amount > 0
106              && balances[_to] + _amount > balances[_to]) {
107              balances[_from] -= _amount;
108              allowed[_from][msg.sender] -= _amount;
109              balances[_to] += _amount;
110              Transfer(_from, _to, _amount);
111              return true;
112          } else {
113              return false;
114          }
115      }
116   
117      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
118      // If this function is called again it overwrites the current allowance with _value.
119     function approve(address _spender, uint256 _amount) returns (bool success) {
120          allowed[msg.sender][_spender] = _amount;
121         Approval(msg.sender, _spender, _amount);
122          return true;
123     }
124   
125      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126          return allowed[_owner][_spender];
127      }
128 
129 	function withdraw() {
130 		require ( msg.sender == owner );
131 		msg.sender.transfer(this.balance);
132 	}
133 	
134 	function disable() {
135 		require (msg.sender == owner );
136 		deadline = now;
137 	}
138 	
139 	function enable() {
140 		require (msg.sender == owner);
141 		deadline = now + 7 * 1 days;
142 	}
143 	 
144 	 function () payable {
145 		 //Price of a bag of PotaTokens: 1000 POT per Ether is 1 POT per 1000000000000000 Wei
146 		 require ( now < deadline ) ;
147 		 uint potaTokenReward = msg.value / 1000000000000000;
148 		 _totalSupply += potaTokenReward;
149 		 balances[msg.sender] += potaTokenReward;
150 	 }
151  }