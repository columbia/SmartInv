1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4     // Get the total token supply
5     function totalSupply() constant returns (uint256 totalSupply);
6     
7     // Get the account balance of another account with address _owner
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) returns (bool success);
12     
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15     
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) returns (bool success);
20     
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23     
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 contract xToken is ERC20 {
32     string public symbol = "TKN";
33     string public name = "xToken";
34     uint8 public decimals = 18;
35     uint256 _totalSupply = 0;
36     
37     // Owner of this contract
38     address public owner;
39     
40     // Balances for each account
41     mapping(address => uint256) balances;
42     
43     // Owner of account approves the transfer of an amount to another account
44     mapping(address => mapping (address => uint256)) allowed;
45     
46     // Functions with this modifier can only be executed by the owner
47     modifier onlyOwner() {
48         if (msg.sender != owner) {
49           throw;
50         }
51         _;
52     }
53     
54     // Constructor   
55     function xToken(address _owner, string _symbol, string _name, uint8 _decimals, uint256 __totalSupply) {
56         symbol = _symbol;
57         name = _name;
58         decimals = _decimals;
59         _totalSupply = __totalSupply;
60 
61         owner = _owner;
62         balances[_owner] = _totalSupply;
63     }
64     
65     function totalSupply() constant returns (uint256 totalSupply) {
66         return _totalSupply;
67     }
68     
69     // What is the balance of a particular account?
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73     
74     // Transfer the balance from owner's account to another account
75     function transfer(address _to, uint256 _amount) returns (bool success) {
76         if (balances[msg.sender] >= _amount 
77             && _amount > 0
78             && balances[_to] + _amount > balances[_to]) 
79         {
80             balances[msg.sender] -= _amount;
81             balances[_to] += _amount;
82             Transfer(msg.sender, _to, _amount);
83             
84             return true;
85         } else {
86             return false;
87         }
88     }
89     
90     // Send _value amount of tokens from address _from to address _to
91     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
92     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
93     // fees in sub-currencies; the command should fail unless the _from account has
94     // deliberately authorized the sender of the message via some mechanism; we propose
95     // these standardized APIs for approval:
96     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
97         if (balances[_from] >= _amount
98             && allowed[_from][msg.sender] >= _amount
99             && _amount > 0
100             && balances[_to] + _amount > balances[_to]) 
101         {
102             balances[_from] -= _amount;
103             allowed[_from][msg.sender] -= _amount;
104             balances[_to] += _amount;
105             Transfer(_from, _to, _amount);
106             
107             return true;
108         } else {
109             return false;
110         }
111     }
112     
113     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
114     // If this function is called again it overwrites the current allowance with _value.
115     function approve(address _spender, uint256 _amount) returns (bool success) {
116         allowed[msg.sender][_spender] = _amount;
117         Approval(msg.sender, _spender, _amount);
118         return true;
119     }
120     
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122         return allowed[_owner][_spender];
123     }
124     
125 }