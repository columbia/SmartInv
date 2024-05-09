1 pragma solidity ^0.4.8;
2 
3 /* Getseeds Token (GSD) source code. */
4   
5  contract GSDToken {
6      
7     // Get the total token supply
8   
9     // Triggered when tokens are transferred.
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11   
12     // Triggered whenever approve(address _spender, uint256 _value) is called.
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15     /* This notifies clients about the XBL amount burned */
16     event Burn(address indexed from, uint256 value);
17     
18     // And we begin:
19     string public constant symbol = "GSD";
20     string public constant name = "Getseeds Token";
21     uint8 public constant decimals = 18;
22     uint256 _totalSupply = 100000000000000000000000000000;    // 100,000,000,000 tokens with 18 decimal places.
23     uint256 _totalBurned = 0;                            // Total burned initially starts at 0.
24      
25     /* The owner of this contract (initial address) */
26     address public owner;
27   
28     /* Dictionary containing balances for each account */
29     mapping(address => uint256) balances;
30   
31     /* Owner of account can approve (allow) the transfer of an amount to another account */
32     mapping(address => mapping (address => uint256)) allowed;
33   
34      // Functions with this modifier can only be executed by the owner
35     modifier onlyOwner() 
36      {
37          if (msg.sender != owner) 
38          {
39              throw;
40          }
41          _;
42      }
43   
44      // Constructor:
45      function GSDToken() 
46      {
47         owner = msg.sender;
48         balances[owner] = _totalSupply;
49      }
50   
51      function totalSupply() constant returns (uint256 l_totalSupply) 
52      {
53         l_totalSupply = _totalSupply;
54      }
55 
56      function totalBurned() constant returns (uint256 l_totalBurned)
57      {
58         l_totalBurned = _totalBurned;
59      }
60   
61      /* What is the balance of a particular account? */
62      function balanceOf(address _owner) constant returns (uint256 balance) 
63      {
64         return balances[_owner];
65      }
66   
67      /* Transfer the balance from owner's account to another account. */
68      function transfer(address _to, uint256 _amount) returns (bool success) 
69      {
70         if (_to == 0x0) throw;      /* Prevents transferring to 0x0 addresses. Use burn() instead. */
71 
72         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
73         {
74             balances[msg.sender] -= _amount;
75             balances[_to] += _amount;
76             Transfer(msg.sender, _to, _amount);
77             return true;
78          } 
79          else 
80          {
81             return false;
82          }
83      }
84   
85      // Send _value amount of tokens from address _from to address _to
86      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
87      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
88      // fees in sub-currencies; the command should fail unless the _from account has
89      // deliberately authorized the sender of the message via some mechanism; we propose
90      // these standardized APIs for approval:
91      function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) 
92      {
93         if (_to == 0x0) throw;      /* Prevents transferring to 0x0 addresses. Use burn() instead. */
94 
95         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
96         {
97             balances[_from] -= _amount;
98             allowed[_from][msg.sender] -= _amount;
99             balances[_to] += _amount;
100             Transfer(_from, _to, _amount);
101             return true;
102          } 
103          else 
104          {
105             return false;
106          }
107      }
108   
109      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
110      // If this function is called again it overwrites the current allowance with _value.
111      function approve(address _spender, uint256 _amount) returns (bool success) 
112      {
113         allowed[msg.sender][_spender] = _amount;
114         Approval(msg.sender, _spender, _amount);
115         return true;
116      }
117   
118      /* Is the _spender allowed to spend on the behalf of the _owner? */ 
119      function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
120      {
121         return allowed[_owner][_spender];
122      }
123 
124     function burn(uint256 _value) returns (bool success) 
125     {
126         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough
127         balances[msg.sender] -= _value;                      // Subtract from the sender
128         /* Updating indicator variables */
129         _totalSupply -= _value;          
130         _totalBurned += _value;                             
131         /* Send the event notification */
132         Burn(msg.sender, _value);
133         return true;
134     }
135 
136     function burnFrom(address _from, uint256 _value) returns (bool success) 
137     {
138         if (balances[_from] < _value) throw;                // Check if the sender has enough
139         if (_value > allowed[_from][msg.sender]) throw;     // Check allowance
140         balances[_from] -= _value;                          // Subtract from the sender
141         /* Updating indicator variables */
142         _totalSupply -= _value;                           
143         _totalBurned += _value;
144         /* Send the event notification */
145         Burn(_from, _value);
146         return true;
147     }
148  }