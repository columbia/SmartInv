1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract Token {
21 
22     function totalSupply() public pure {}
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     
27 }
28 
29 contract SafeMath {
30   function safeMul(uint256 a, uint256 b)pure internal returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function safeDiv(uint256 a, uint256 b)pure internal returns (uint256) {
37     assert(b > 0);
38     uint256 c = a / b;
39     assert(a == b * c + a % b);
40     return c;
41   }
42 
43   function safeSub(uint256 a, uint256 b)pure internal returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function safeAdd(uint256 a, uint256 b)pure internal returns (uint256) {
49     uint256 c = a + b;
50     assert(c>=a && c>=b);
51     return c;
52   }
53 }
54 
55 contract StandardToken is Token,SafeMath {
56 
57     function approve(address _spender, uint256 _value)public returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59        emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69    }
70 
71 contract HECFinalToken is StandardToken,owned {
72 
73  string public name;
74     string public symbol;
75     uint8 public decimals;
76     uint256 public totalSupply;
77     uint256 public initialSupply;
78     
79  uint256 public deploymentTime = now;
80  uint256 public burnTime = now + 2 minutes;
81  
82       uint256 public sellPrice;
83     uint256 public buyPrice;
84 
85     /* This generates a public event on the blockchain that will notify clients */
86     event FrozenFunds(address target, bool frozen);
87     event Burn(address indexed from, uint256 value);
88     
89     mapping (address => bool) public frozenAccount;
90     mapping (address => uint256) public balanceOf;
91     mapping (address => mapping (address => uint256)) public allowance;
92     
93 constructor(
94         )public {
95        
96         initialSupply =10000000000*100000000; 
97         balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens
98         totalSupply = initialSupply;                         // Update total supply
99         name = "Haeinenergy coin";                                   // Set the name for display purposes
100         symbol = "HEC";                               // Set the symbol for display purposes
101         decimals = 8;                            // Amount of decimals for display purposes
102 		owner = msg.sender;
103         }
104         
105     function transfer(address _to, uint256 _value)public returns (bool success) {
106         if (balanceOf[msg.sender] >= _value && _value > 0) {
107             balanceOf[msg.sender] -= _value;
108             balanceOf[_to] += _value;
109           emit Transfer(msg.sender, _to, _value);
110             return true;
111         } else { return false; }
112     }
113 
114     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
115         if (balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
116             balanceOf[_to] += _value;
117             balanceOf[_from] -= _value;
118             allowed[_from][msg.sender] -= _value;
119         emit Transfer(_from, _to, _value);
120             return true;
121         } else { return false; }
122     }
123 
124       function burn(uint256 _value) public returns (bool success) {
125       if (burnTime <= now)
126       {
127         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
128         balanceOf[msg.sender] -= _value;            // Subtract from the sender
129         totalSupply -= _value;                      // Updates totalSupply
130         emit Burn(msg.sender, _value);
131         return true;
132       }
133     }
134 
135     function burnFrom(address _from, uint256 _value) public returns (bool success) {
136         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
137         require(_value <= allowance[_from][msg.sender]);    // Check allowance
138         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
139         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
140         totalSupply -= _value;                              // Update totalSupply
141         emit Burn(_from, _value);
142         return true;
143     }
144 
145     function freezeAccount(address target, bool freeze) onlyOwner public {
146         frozenAccount[target] = freeze;
147         emit FrozenFunds(target, freeze);
148     }
149 
150     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
151         sellPrice = newSellPrice;
152         buyPrice = newBuyPrice;
153     }
154   /* Internal transfer, only can be called by this contract */
155     function _transfer(address _from, address _to, uint _value) internal {
156         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
157         require (balanceOf[_from] >= _value);               // Check if the sender has enough
158         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
159         require(!frozenAccount[_from]);                     // Check if sender is frozen
160         require(!frozenAccount[_to]);                       // Check if recipient is frozen
161         balanceOf[_from] -= _value;                         // Subtract from the sender
162         balanceOf[_to] += _value;                           // Add the same to the recipient
163         emit Transfer(_from, _to, _value);
164     }
165     /// @notice Buy tokens from contract by sending ether
166     function buy() payable public {
167         uint amount = msg.value / buyPrice;               // calculates the amount
168         _transfer(this, msg.sender, amount);              // makes the transfers
169     }
170     
171     function sell(uint256 amount) public {
172         address myAddress = this;
173         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
174         _transfer(msg.sender, this, amount);              // makes the transfers
175         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
176     }
177     
178     }