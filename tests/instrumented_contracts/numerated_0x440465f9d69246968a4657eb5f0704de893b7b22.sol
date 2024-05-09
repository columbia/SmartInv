1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/issues/20
10 contract ERC20Interface {
11     // Get the total token supply
12     function totalSupply() constant returns (uint256 totalSupplyReturn);
13 
14     // Get the account balance of another account with address _owner
15     function balanceOf(address _owner) constant returns (uint256 balance);
16 
17     // Send _value amount of tokens to address _to
18     function transfer(address _to, uint256 _value) returns (bool success);
19 
20     // Send _value amount of tokens from address _from to address _to
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22 
23     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
24     // If this function is called again it overwrites the current allowance with _value.
25     // this function is required for some DEX functionality
26     function approve(address _spender, uint256 _value) returns (bool success);
27 
28     // Returns the amount which _spender is still allowed to withdraw from _owner
29     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30 
31     // Triggered when tokens are transferred.
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 
34     // Triggered whenever approve(address _spender, uint256 _value) is called.
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract FixedSupplyToken is ERC20Interface {
39     string public constant symbol = "RAM";
40     string public constant name = "RAMCoin";
41     uint8 public constant decimals = 18;
42     uint256 _totalSupply = 88888888;
43 
44     // Owner of this contract
45     address public owner;
46 
47     // Balances for each account
48     mapping(address => uint256) balances;
49 
50     // Owner of account approves the transfer of an amount to another account
51     mapping(address => mapping (address => uint256)) allowed;
52 
53     // Functions with this modifier can only be executed by the owner
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     // Constructor
60     function FixedSupplyToken() {
61         owner = msg.sender;
62         balances[owner] = _totalSupply;
63     }
64 
65     function totalSupply() constant returns (uint256 totalSupplyReturn) {
66         totalSupplyReturn = _totalSupply;
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
78             && balances[_to] + _amount > balances[_to]) {
79             balances[msg.sender] -= _amount;
80             balances[_to] += _amount;
81             Transfer(msg.sender, _to, _amount);
82             return true;
83         } else {
84             return false;
85         }
86     }
87 
88     // Send _value amount of tokens from address _from to address _to
89     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
90     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
91     // fees in sub-currencies; the command should fail unless the _from account has
92     // deliberately authorized the sender of the message via some mechanism; we propose
93     // these standardized APIs for approval:
94     function transferFrom(
95         address _from,
96         address _to,
97         uint256 _amount
98     ) returns (bool success) {
99         if (balances[_from] >= _amount
100             && allowed[_from][msg.sender] >= _amount
101             && _amount > 0
102             && balances[_to] + _amount > balances[_to]) {
103             balances[_from] -= _amount;
104             allowed[_from][msg.sender] -= _amount;
105             balances[_to] += _amount;
106             Transfer(_from, _to, _amount);
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
124 }