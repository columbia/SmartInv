1 pragma solidity  0.4 .21;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/issues/20
10 contract Token {
11     // Get the total
12      //token supply
13     function totalSupply() constant returns(uint256 initialSupply);
14 
15     // Get the account balance of another account with address _owner
16     function balanceOf(address _owner) constant returns(uint256 balance);
17 
18     // Send _value amount of tokens to address _to
19     function transfer(address _to, uint256 _value) returns(bool success);
20 
21     // Send _value amount of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
23 
24     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
25     // If this function is called again it overwrites the current allowance with _value.
26     // this function is required for some DEX functionality
27     function approve(address _spender, uint256 _value) returns(bool success);
28 
29     // Returns the amount which _spender is still allowed to withdraw from _owner
30     function allowance(address _owner, address _spender) constant returns(uint256 remaining);
31 
32    
33 
34     //Trigger when Tokens Burned
35         event Burn(address indexed from, uint256 value);
36 
37 
38     // Triggered when tokens are transferred.
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40 
41     // Triggered whenever approve(address _spender, uint256 _value) is called.
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 contract AssetToken is Token {
46     string public  symbol;
47     string public  name;
48     uint8 public  decimals;
49     uint256 _totalSupply;
50     address public centralAdmin;
51         uint256 public soldToken;
52 
53 
54 
55     // Owner of this contract
56     address public owner;
57 
58     // Balances for each account
59     mapping(address => uint256) balances;
60 
61     // Owner of account approves the transfer of an amount to another account
62     mapping(address => mapping(address => uint256)) allowed;
63 
64     // Functions with this modifier can only be executed by the owner
65    modifier onlyOwner(){
66         require(msg.sender == owner);
67         _;
68     }
69 
70 
71     // Constructor
72     function AssetToken(uint256 totalSupply,string tokenName,uint8 decimalUnits,string tokenSymbol,address centralAdmin) {
73            soldToken = 0;
74 
75         if(centralAdmin != 0)
76             owner = centralAdmin;
77         else
78         owner = msg.sender;
79         balances[owner] = totalSupply;
80         symbol = tokenSymbol;
81         name = tokenName;
82         decimals = decimalUnits;
83         _totalSupply = totalSupply ;
84     }
85   function transferAdminship(address newAdmin) onlyOwner {
86         owner = newAdmin;
87     }
88     function totalSupply() constant returns(uint256 initialSupply) {
89         initialSupply = _totalSupply;
90     }
91 
92     // What is the balance of a particular account?
93     function balanceOf(address _owner) constant returns(uint256 balance) {
94         return balances[_owner];
95     }
96 
97      //Mint the Token 
98     function mintToken(address target, uint256 mintedAmount) onlyOwner{
99         balances[target] += mintedAmount;
100         _totalSupply += mintedAmount;
101         Transfer(0, this, mintedAmount);
102         Transfer(this, target, mintedAmount);
103     }
104 
105     // Transfer the balance from owner's account to another account
106     function transfer(address _to, uint256 _amount) returns(bool success) {
107         if (balances[msg.sender] >= _amount &&
108             _amount > 0 &&
109             balances[_to] + _amount > balances[_to]) {
110             balances[msg.sender] -= _amount;
111             balances[_to] += _amount;
112             Transfer(msg.sender, _to, _amount);
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     // Send _value amount of tokens from address _from to address _to
120     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
121     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
122     // fees in sub-currencies; the command should fail unless the _from account has
123     // deliberately authorized the sender of the message via some mechanism; we propose
124     // these standardized APIs for approval:
125     function transferFrom(
126         address _from,
127         address _to,
128         uint256 _amount
129     ) returns(bool success) {
130         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 &&
131             balances[_to] + _amount > balances[_to]) {
132             balances[_from] -= _amount;
133             allowed[_from][msg.sender] -= _amount;
134             balances[_to] += _amount;
135             Transfer(_from, _to, _amount);
136             return true;
137         } else {
138             return false;
139         }
140     }
141     //Allow the owner to burn the token from their accounts
142 function burn(uint256 _value) public returns (bool success) {
143         require(balances[msg.sender] >= _value);   
144         balances[msg.sender] -= _value;            
145         _totalSupply -= _value;                      
146         Burn(msg.sender, _value);
147         return true;
148     }
149 //For calculating the sold tokens
150    function transferCrowdsale(address _to, uint256 _value){
151         require(balances[msg.sender] > 0);
152         require(balances[msg.sender] >= _value);
153         require(balances[_to] + _value >= balances[_to]);
154         //if(admin)
155         balances[msg.sender] -= _value;
156         balances[_to] += _value;
157          soldToken +=  _value;
158         Transfer(msg.sender, _to, _value);
159     }
160 
161 
162     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
163     // If this function is called again it overwrites the current allowance with _value.
164     function approve(address _spender, uint256 _amount) returns(bool success) {
165         allowed[msg.sender][_spender] = _amount;
166         Approval(msg.sender, _spender, _amount);
167         return true;
168     }
169 
170     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
171         return allowed[_owner][_spender];
172     }
173  
174 
175 }