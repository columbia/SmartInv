1 pragma solidity ^0.4.8;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Cryptonetix fixed supply token contract
5    // Patrick Shearon 2017. 
6    // ----------------------------------------------------------------------------------------------
7     
8    // ERC Token Standard #20 Interface
9    // https://github.com/ethereum/EIPs/issues/20
10   contract ERC20Interface {
11       // Get the total token supply
12       function totalSupply() constant returns (uint256 totalSupply);
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
38     contract Ownable {
39         
40         address public owner;
41      
42       function Ownable() {
43         owner = msg.sender;
44       }
45     
46       modifier onlyOwner() {
47         if (msg.sender != owner)
48         throw;
49         else _;
50       }
51     
52       function transferOwnership(address newOwner) onlyOwner {
53         if(newOwner != address(0))      
54         owner = newOwner;
55       }
56      
57     }
58    
59   contract FixedSupplyToken is ERC20Interface, Ownable {
60       string public constant symbol = "CIX";
61       string public constant name = "Cryptonetix";
62       uint8 public constant decimals = 18;
63       uint256 _totalSupply = 100000000000000000000000000;
64       
65       // Owner of this contract
66       //address public owner;
67    
68       // Balances for each account
69       mapping(address => uint256) balances;
70    
71       // Owner of account approves the transfer of an amount to another account
72       mapping(address => mapping (address => uint256)) allowed;
73    
74     //   // Functions with this modifier can only be executed by the owner
75     //   modifier onlyOwner() {
76     //       if (msg.sender != owner) {
77     //           throw;
78     //       }
79     //       _;
80     //   }
81    
82       // Constructor
83       function FixedSupplyToken() {
84           owner = msg.sender;
85           balances[owner] = _totalSupply;
86       }
87    
88       function totalSupply() constant returns (uint256 totalSupply) {
89           totalSupply = _totalSupply;
90       }
91    
92       // What is the balance of a particular account?
93       function balanceOf(address _owner) constant returns (uint256 balance) {
94           return balances[_owner];
95       }
96    
97       // Transfer the balance from owner's account to another account
98       function transfer(address _to, uint256 _amount) returns (bool success) {
99           if (balances[msg.sender] >= _amount 
100               && _amount > 0
101               && balances[_to] + _amount > balances[_to]) {
102               balances[msg.sender] -= _amount;
103               balances[_to] += _amount;
104               Transfer(msg.sender, _to, _amount);
105               return true;
106           } else {
107               return false;
108           }
109       }
110    
111       // Send _value amount of tokens from address _from to address _to
112       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
113       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
114       // fees in sub-currencies; the command should fail unless the _from account has
115       // deliberately authorized the sender of the message via some mechanism; we propose
116       // these standardized APIs for approval:
117       function transferFrom(
118           address _from,
119           address _to,
120           uint256 _amount
121      ) returns (bool success) {
122          if (balances[_from] >= _amount
123              && allowed[_from][msg.sender] >= _amount
124              && _amount > 0
125              && balances[_to] + _amount > balances[_to]) {
126              balances[_from] -= _amount;
127              allowed[_from][msg.sender] -= _amount;
128              balances[_to] += _amount;
129              Transfer(_from, _to, _amount);
130              return true;
131          } else {
132              return false;
133          }
134      }
135   
136      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
137      // If this function is called again it overwrites the current allowance with _value.
138      function approve(address _spender, uint256 _amount) returns (bool success) {
139          allowed[msg.sender][_spender] = _amount;
140          Approval(msg.sender, _spender, _amount);
141          return true;
142      }
143   
144      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145          return allowed[_owner][_spender];
146      }
147  }