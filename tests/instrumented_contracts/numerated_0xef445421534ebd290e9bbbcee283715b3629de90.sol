1 pragma solidity ^0.4.11;
2 
3 // ----Statereu------------------------------------------------------------------------------------------
4 // Token contract
5 // Statereum.
6 // ----------------------------------------------------------------------------------------------
7 
8 
9 // ERC Token Standard #20 Interface
10 
11 contract ERC20Interface {
12     // Get the total token supply
13     function totalSupply() constant returns (uint256 totalSupplys);
14 
15     // Get the account balance of another account with address _owner
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     // Send _value amount of tokens to address _to
19     function transfer(address _to, uint256 _value) returns (bool success);
20 
21     // Send _value amount of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
25     // If this function is called again it overwrites the current allowance with _value.
26     // this function is required for some DEX functionality
27     function approve(address _spender, uint256 _value) returns (bool success);
28 
29     // Returns the amount which _spender is still allowed to withdraw from _owner
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32     // Triggered when tokens are transferred.
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35     // Triggered whenever approve(address _spender, uint256 _value) is called.
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 
40 contract StatereumCoin is ERC20Interface {
41     string public constant symbol = "STR";
42     string public constant name = "Statereum Coin";
43     uint8 public constant decimals = 0;
44     uint256 _totalSupply = 30000000;
45 
46     // Owner of this contract
47     address public owner;
48 
49     // Balances for each account
50     mapping (address => uint256) balances;
51 
52     // Owner of account approves the transfer of an amount to another account
53     mapping (address => mapping (address => uint256)) allowed;
54 
55     // Functions with this modifier can only be executed by the owner
56     modifier onlyOwner() {
57         if (msg.sender != owner) {
58             _;
59         }
60         _;
61     }
62 
63     // Constructor
64     function StatereumCoin() {
65         owner = msg.sender;
66         balances[owner] = _totalSupply;
67     }
68 
69     function totalSupply() constant returns (uint256 totalSupplys) {
70         totalSupplys = _totalSupply;
71     }
72 
73     // What is the balance of a particular account?
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     // Transfer the balance from owner's account to another account
79     function transfer(address _to, uint256 _amount) returns (bool success) {
80         if (balances[msg.sender] >= _amount
81         && _amount > 0
82         && balances[_to] + _amount > balances[_to]) {
83             balances[msg.sender] -= _amount;
84             balances[_to] += _amount;
85             Transfer(msg.sender, _to, _amount);
86             return true;
87         }
88         else {
89             return false;
90         }
91     }
92 
93     // Send _value amount of tokens from address _from to address _to
94     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
95     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
96     // fees in sub-currencies; the command should fail unless the _from account has
97     // deliberately authorized the sender of the message via some mechanism; we propose
98     // these standardized APIs for approval:
99     function transferFrom(
100     address _from,
101     address _to,
102     uint256 _amount
103     ) returns (bool success) {
104         if (balances[_from] >= _amount
105         && allowed[_from][msg.sender] >= _amount
106         && _amount > 0
107         && balances[_to] + _amount > balances[_to]) {
108             balances[_from] -= _amount;
109             allowed[_from][msg.sender] -= _amount;
110             balances[_to] += _amount;
111             Transfer(_from, _to, _amount);
112             return true;
113         }
114         else {
115             return false;
116         }
117     }
118 
119 
120     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
121     // If this function is called again it overwrites the current allowance with _value.
122     function approve(address _spender, uint256 _amount) returns (bool success) {
123         allowed[msg.sender][_spender] = _amount;
124         Approval(msg.sender, _spender, _amount);
125         return true;
126     }
127 
128     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
129         return allowed[_owner][_spender];
130     }
131 
132 }