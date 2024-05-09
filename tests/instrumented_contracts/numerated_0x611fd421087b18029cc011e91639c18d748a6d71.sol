1 pragma solidity ^0.4.13;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Sample fixed supply token contract
5    // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6    // ----------------------------------------------------------------------------------------------
7     
8    // ERC Token Standard #20 Interface
9    // https://github.com/ethereum/EIPs/issues/20
10 
11    // --------------- Added --------------
12    // 1. SafeMath + mintToken
13    // 2. transfer ownership
14    //
15    library SafeMath {
16 	  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17 	    uint256 c = a * b;
18 	    assert(a == 0 || c / a == b);
19 	    return c;
20 	  }
21 
22 	  function div(uint256 a, uint256 b) internal constant returns (uint256) {
23 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
24 	    uint256 c = a / b;
25 	    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26 	    return c;
27 	  }
28 
29 	  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30 	    assert(b <= a);
31 	    return a - b;
32 	  }
33 
34 	  function add(uint256 a, uint256 b) internal constant returns (uint256) {
35 	    uint256 c = a + b;
36 	    assert(c >= a);
37 	    return c;
38 	  }
39 	}
40 
41   contract ERC20Interface {
42       // Get the total token supply
43       function totalSupply() constant returns (uint256 totalSupply);
44    
45       // Get the account balance of another account with address _owner
46       function balanceOf(address _owner) constant returns (uint256 balance);
47    
48       // Send _value amount of tokens to address _to
49       function transfer(address _to, uint256 _value) returns (bool success);
50    
51       // Send _value amount of tokens from address _from to address _to
52       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
53    
54       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
55       // If this function is called again it overwrites the current allowance with _value.
56       // this function is required for some DEX functionality
57       function approve(address _spender, uint256 _value) returns (bool success);
58    
59       // Returns the amount which _spender is still allowed to withdraw from _owner
60       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
61    
62       // Triggered when tokens are transferred.
63       event Transfer(address indexed _from, address indexed _to, uint256 _value);
64    
65       // Triggered whenever approve(address _spender, uint256 _value) is called.
66       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67   }
68    
69   contract KeyToken is ERC20Interface {
70       string public constant symbol = "KeY";
71       string public constant name = "KeYToken";
72       uint8 public constant decimals = 0;
73       uint256 _totalSupply = 11111111111;
74       
75       // Owner of this contract
76       address public owner;
77    
78       // Balances for each account
79       mapping(address => uint256) balances;
80    
81       // Owner of account approves the transfer of an amount to another account
82       mapping(address => mapping (address => uint256)) allowed;
83    
84       // Functions with this modifier can only be executed by the owner
85       modifier onlyOwner() {
86           require (msg.sender == owner);
87           _;
88       }
89 
90       // Add: transfer ownership
91       function transferOwnership(address newOwner) onlyOwner{
92       	  owner = newOwner;
93       }
94    
95       // Constructor
96       function KeyToken() {
97           owner = msg.sender;
98           balances[owner] = _totalSupply;
99       }
100    
101       function totalSupply() constant returns (uint256 totalSupply) {
102           totalSupply = _totalSupply;
103       }
104    
105       // What is the balance of a particular account?
106       function balanceOf(address _owner) constant returns (uint256 balance) {
107           return balances[_owner];
108       }
109    
110       // Transfer the balance from owner's account to another account
111       function transfer(address _to, uint256 _amount) returns (bool success) {
112           if (balances[msg.sender] >= _amount 
113               && _amount > 0
114               && balances[_to] + _amount > balances[_to]) {
115               balances[msg.sender] -= _amount;
116               balances[_to] += _amount;
117               Transfer(msg.sender, _to, _amount);
118               return true;
119           } else {
120               return false;
121           }
122       }
123    
124       // Send _value amount of tokens from address _from to address _to
125       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
126       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
127       // fees in sub-currencies; the command should fail unless the _from account has
128       // deliberately authorized the sender of the message via some mechanism; we propose
129       // these standardized APIs for approval:
130       function transferFrom(
131           address _from,
132           address _to,
133           uint256 _amount
134      ) returns (bool success) {
135          if (balances[_from] >= _amount
136              && allowed[_from][msg.sender] >= _amount
137              && _amount > 0
138              && balances[_to] + _amount > balances[_to]) {
139              balances[_from] -= _amount;
140              allowed[_from][msg.sender] -= _amount;
141              balances[_to] += _amount;
142              Transfer(_from, _to, _amount);
143              return true;
144          } else {
145              return false;
146          }
147      }
148   
149      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
150      // If this function is called again it overwrites the current allowance with _value.
151      function approve(address _spender, uint256 _amount) returns (bool success) {
152          allowed[msg.sender][_spender] = _amount;
153          Approval(msg.sender, _spender, _amount);
154          return true;
155      }
156   
157      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158          return allowed[_owner][_spender];
159      }
160 
161      // Add: Mint Token
162      function mintToken(address target, uint256 mintedAmount) onlyOwner{
163      	balances[target] = SafeMath.add(balances[target], mintedAmount);
164      	_totalSupply = SafeMath.add(_totalSupply, mintedAmount);
165      	Transfer(0, this, mintedAmount);
166      	Transfer(this, target, mintedAmount);
167      }
168 
169 
170  }