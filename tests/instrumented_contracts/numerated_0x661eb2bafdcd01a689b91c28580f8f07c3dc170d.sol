1 pragma solidity ^0.4.8;
2 
3 
4 // ERC Token Standard #20 Interface 
5 contract ERC20 {
6     // Get the total token supply
7     uint public totalSupply;
8     // Get the account balance of another account with address _owner
9     function balanceOf(address who) constant returns(uint256);
10     // Send _value amount of tokens to address _to
11     function transfer(address to, uint value) returns(bool ok);
12     // Send _value amount of tokens from address _from to address _to
13     function transferFrom(address from, address to, uint value) returns(bool ok);
14     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
15     // If this function is called again it overwrites the current allowance with _value.
16     // this function is required for some DEX functionality
17     function approve(address spender, uint value) returns(bool ok);
18     // Returns the amount which _spender is still allowed to withdraw from _owner
19     function allowance(address owner, address spender) constant returns(uint);
20     // Triggered when tokens are transferred.
21     event Transfer(address indexed from, address indexed to, uint value);
22     // Triggered whenever approve(address _spender, uint256 _value) is called.
23     event Approval(address indexed owner, address indexed spender, uint value);
24 
25 }
26 
27 
28 contract FuBi is ERC20 {
29 
30     // each address in this contract may have tokens, to define balances and store balance of each address we use mapping.
31     mapping (address => uint256) balances;   
32     // frozen account mapping to store account which are freeze to do anything
33     mapping (address => bool) public frozenAccount; //
34 
35     //address internal owner = 0x4Bce8E9850254A86a1988E2dA79e41Bc6793640d;  
36 
37     // Owner of this contract will be the creater of the contract
38     address public owner;
39     // name of this contract and investment fund
40     string public name = "FuBi";  
41     // token symbol
42     string public symbol = "Fu";  
43     // decimals (for humans)
44     uint8 public decimals = 6;    
45     // total supply of tokens it includes 6 zeros extra to handle decimal of 6 places.
46     uint256 public totalSupply = 20000000000000000;  
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     // events that will notifies clints about the freezing accounts and status
50     event FrozenFu(address target, bool frozen);
51 
52     mapping(address => mapping(address => uint256)) public allowance;
53     
54     bool flag = false;
55 
56     // modifier to authorize owner
57     modifier onlyOwner()
58     {
59         if (msg.sender != owner) revert();
60         _;
61     }
62 
63     // constructor called during creation of contract
64     function FuBi() { 
65         owner = msg.sender;       // person who deploy the contract will be the owner of the contract
66         balances[owner] = totalSupply; // balance of owner will be equal to 20000 million
67         }    
68 
69     // implemented function balanceOf of erc20 to know the balnce of any account
70     function balanceOf(address _owner) constant returns (uint256 balance)
71     {
72         return balances[_owner];
73     }
74     // transfer tokens from one address to another
75     function transfer(address _to, uint _value) returns (bool success)
76     {
77          // Check send token value > 0;
78         if(_value <= 0) throw;                                     
79         // Check if the sender has enough
80         if (balances[msg.sender] < _value) throw;                   
81         // Check for overflows
82         if (balances[_to] + _value < balances[_to]) throw; 
83         // Subtract from the sender
84         balances[msg.sender] -= _value;                             
85         // Add the same to the recipient, if it's the contact itself then it signals a sell order of those tokens
86         balances[_to] += _value;                                    
87         // Notify anyone listening that this transfer took place               
88         Transfer(msg.sender, _to, _value);                          
89         return true;      
90     }
91     
92     /* Allow another contract to spend some tokens in your behalf */
93     function approve(address _spender, uint256 _value)
94     returns(bool success) {
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98     // Returns the amount which _spender is still allowed to withdraw from _owner
99     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
100         return allowance[_owner][_spender];
101     }
102 
103     /* A contract attempts to get the coins */
104     function transferFrom(address _from, address _to, uint _value) returns(bool success) {
105         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
106         if (balances[_from] < _value) throw; // Check if the sender has enough
107         if (balances[_to] + _value < balances[_to]) throw; // Check for overflows
108         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
109 
110         balances[_from] -= _value; // Subtract from the sender
111         balances[_to] += _value; // Add the same to the recipient
112         allowance[_from][msg.sender] -= _value;
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     // create new tokens, called only by owner, new token value supplied will be added to _to address with total supply
118     function mint(address _to, uint256 _value) onlyOwner
119     {
120         if(!flag)
121         {
122         balances[_to] += _value;
123     	totalSupply += _value;
124         }
125         else
126         revert();
127     }
128 
129    //owner can call this freeze function to freeze some accounts from doing certain functions
130     function freeze(address target, bool freeze) onlyOwner
131     {
132         if(!flag)
133         {
134         frozenAccount[target] = freeze;
135         FrozenFu(target,freeze);  
136         }
137         else
138         revert();
139     }
140    // transfer the ownership to new address, called only by owner
141    function transferOwnership(address to) public onlyOwner {
142          owner = to;
143          balances[owner]=balances[msg.sender];
144          balances[msg.sender]=0;
145     }
146     // flag function called by ony owner, stopping some function to work for
147     function turn_flag_ON() onlyOwner
148     {
149         flag = true;
150     }
151     // flag function called by owner, releasing some function to work for
152     function turn_flag_OFF() onlyOwner
153     {
154         flag = false;
155     }
156     //Drain Any Ether in contract to owner
157     function drain() public onlyOwner {
158         if (!owner.send(this.balance)) throw;
159     }
160 }