1 pragma solidity ^0.4.8;
2 
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20Interface {
6     // Get the total token supply
7     function totalSupply() constant returns (uint256 totalSupply);
8 
9     // Get the account balance of another account with address _owner
10     function balanceOf(address _owner) constant returns (uint256 balance);
11 
12     // Send _value amount of tokens to address _to
13     function transfer(address _to, uint256 _value) returns (bool success);
14 
15     // Send _value amount of tokens from address _from to address _to
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17 
18     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
19     // If this function is called again it overwrites the current allowance with _value.
20     // this function is required for some DEX functionality
21     function approve(address _spender, uint256 _value) returns (bool success);
22 
23     // Returns the amount which _spender is still allowed to withdraw from _owner
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
25 
26     // Triggered when tokens are transferred.
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28 
29     // Triggered whenever approve(address _spender, uint256 _value) is called.
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 }
32 
33 contract FixedSupplyToken is ERC20Interface {
34     string public constant symbol = "MIZU";
35     string public constant name = "Mizuchi";
36     uint8 public constant decimals = 0;
37     uint256 _totalSupply = 10;
38 
39     // Owner of this contract
40     address public owner;
41 
42     // Balances for each account
43     mapping(address => uint256) balances;
44 
45     // Owner of account approves the transfer of an amount to another account
46     mapping(address => mapping (address => uint256)) allowed;
47 
48     // Functions with this modifier can only be executed by the owner
49     modifier onlyOwner() {
50         if (msg.sender != owner) {
51             throw;
52         }
53         _;
54     }
55 
56     // Constructor
57     function FixedSupplyToken() {
58         owner = msg.sender;
59         balances[owner] = _totalSupply;
60     }
61 
62     function totalSupply() constant returns (uint256 totalSupply) {
63         totalSupply = _totalSupply;
64     }
65 
66     // What is the balance of a particular account?
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     // Transfer the balance from owner's account to another account
72     function transfer(address _to, uint256 _amount) returns (bool success) {
73         if (balances[msg.sender] >= _amount
74             && _amount > 0
75             && balances[_to] + _amount > balances[_to]) {
76             balances[msg.sender] -= _amount;
77             balances[_to] += _amount;
78             Transfer(msg.sender, _to, _amount);
79             return true;
80         } else {
81             return false;
82         }
83     }
84 
85     // Send _value amount of tokens from address _from to address _to
86     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
87     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
88     // fees in sub-currencies; the command should fail unless the _from account has
89     // deliberately authorized the sender of the message via some mechanism; we propose
90     // these standardized APIs for approval:
91     function transferFrom(
92         address _from,
93         address _to,
94         uint256 _amount
95     ) returns (bool success) {
96         if (balances[_from] >= _amount
97             && allowed[_from][msg.sender] >= _amount
98             && _amount > 0
99             && balances[_to] + _amount > balances[_to]) {
100             balances[_from] -= _amount;
101             allowed[_from][msg.sender] -= _amount;
102             balances[_to] += _amount;
103             Transfer(_from, _to, _amount);
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
111     // If this function is called again it overwrites the current allowance with _value.
112     function approve(address _spender, uint256 _amount) returns (bool success) {
113         allowed[msg.sender][_spender] = _amount;
114         Approval(msg.sender, _spender, _amount);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 }