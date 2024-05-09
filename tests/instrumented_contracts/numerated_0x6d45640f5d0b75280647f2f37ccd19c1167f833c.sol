1 pragma solidity ^0.5.11;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Developer Nechesov Andrey
5    // Facebook.com/Nechesov 
6    // Copyright (c) 2019. 
7    // ----------------------------------------------------------------------------------------------    
8    
9   contract ERC20Interface {
10       // Get the total token supply
11       function totalSupply() external view returns (uint256);
12    
13       // Get the account balance of another account with address _owner
14       function balanceOf(address _owner) external view returns (uint256);
15    
16       // Send _value amount of tokens to address _to
17       function transfer(address _to, uint256 _value) external returns (bool);
18    
19       // Send _value amount of tokens from address _from to address _to
20       function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
21    
22       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
23       // If this function is called again it overwrites the current allowance with _value.
24       // this function is required for some DEX functionality
25       function approve(address _spender, uint256 _value) external returns (bool);
26    
27       // Returns the amount which _spender is still allowed to withdraw from _owner
28       function allowance(address _owner, address _spender) external view returns (uint256);
29    
30       // Triggered when tokens are transferred.
31       event Transfer(address indexed _from, address indexed _to, uint256 _value);
32    
33       // Triggered whenever approve(address _spender, uint256 _value) is called.
34       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35   }
36      
37   contract FLExToken is ERC20Interface {
38 
39       string public constant symbol = "FLEx";
40       string public constant name = "FLEx token";
41       uint8 public constant decimals = 4;            
42       
43       uint256 private _totalSupply = 10*10**9*10**4;               
44 
45       using SafeMath for uint;
46       
47       // Owner of this contract
48       address public owner;
49    
50       // Balances for each account
51       mapping(address => uint256) balances;
52    
53       // Owner of account approves the transfer of an amount to another account
54       mapping(address => mapping (address => uint256)) allowed;
55    
56       // Functions with this modifier can only be executed by the owner
57       modifier onlyOwner() {
58           if (msg.sender != owner) {
59               revert();
60           }
61           _;
62       } 
63       
64       constructor() public {        
65         //owner = msg.sender;
66         owner = 0x14387E6A7E79d28340fd78Ea3ac2243F4f511CAD;
67         balances[owner] = _totalSupply;
68       } 
69    
70       function totalSupply() public view returns (uint256) {
71         return _totalSupply;
72       }
73    
74       // What is the balance of a particular account?
75       function balanceOf(address _owner) view public returns (uint256 balance) {
76           return balances[_owner];
77       }
78    
79       // Transfer the balance from owner's account to another account
80       function transfer(address _to, uint256 _amount) public returns (bool success) {          
81         
82           if (balances[msg.sender] >= _amount 
83               && _amount > 0
84               && balances[_to] + _amount > balances[_to]) {
85               balances[msg.sender] -= _amount;
86               balances[_to] += _amount;
87               emit Transfer(msg.sender, _to, _amount);
88               return true;
89           } else {
90               return false;
91           }
92       }
93    
94       // Send _value amount of tokens from address _from to address _to
95       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
96       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
97       // fees in sub-currencies; the command should fail unless the _from account has
98       // deliberately authorized the sender of the message via some mechanism; we propose
99       // these standardized APIs for approval:
100       function transferFrom(
101           address _from,
102           address _to,
103           uint256 _amount
104       ) public returns (bool success) {         
105 
106          if (balances[_from] >= _amount
107              && allowed[_from][msg.sender] >= _amount
108              && _amount > 0
109              && balances[_to] + _amount > balances[_to]) {
110              balances[_from] -= _amount;
111              allowed[_from][msg.sender] -= _amount;
112              balances[_to] += _amount;
113              emit Transfer(_from, _to, _amount);
114              return true;
115          } else {
116              return false;
117          }
118      }
119   
120      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121      // If this function is called again it overwrites the current allowance with _value.
122      function approve(address _spender, uint256 _amount) public returns (bool success) {
123          allowed[msg.sender][_spender] = _amount;
124          emit Approval(msg.sender, _spender, _amount);
125          return true;
126      }
127   
128      function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
129          return allowed[_owner][_spender];
130      }
131 
132      function TransferOwnership(address newOwner) onlyOwner public
133     {
134       owner = newOwner;
135     }
136 
137  }
138 
139   /**
140    * Math operations with safety checks
141    */
142   library SafeMath {
143     function mul(uint a, uint b) internal pure returns (uint) {
144       uint c = a * b;
145       assert(a == 0 || c / a == b);
146       return c;
147     }
148 
149     function div(uint a, uint b) internal pure returns (uint) {
150       
151       uint c = a / b;      
152       return c;
153     }
154 
155     function sub(uint a, uint b) internal pure returns (uint) {
156       assert(b <= a);
157       return a - b;
158     }
159 
160     function add(uint a, uint b) internal pure returns (uint) {
161       uint c = a + b;
162       require(c >= a);
163       return c;
164     }
165     
166   }