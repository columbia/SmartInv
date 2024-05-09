1 pragma solidity ^0.4.19;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11     function claimdram() public returns (bool success);
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 contract EOSDRAM is ERC20Interface {
18     string public constant symbol = "DRAM";
19     string public constant name = "EOS DRAM";
20     uint8 public constant decimals = 4;
21 
22     uint256 _totalSupply = 0;
23     // airdrop 200Kb to each account. 1 Kb = 1 DRAM
24     uint256 _airdropAmount = 200 * 10000;
25     // max supply of 64GB is 64 * 1024 * 1024 Kb
26     uint256 _maxSupply = 67108864 * 10000;
27 
28     mapping(address => uint256) balances;
29     mapping(address => bool) claimeddram;
30 
31     // Owner of account approves the transfer of an amount to another account
32     mapping(address => mapping (address => uint256)) allowed;
33 
34     address public owner;
35     
36     modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39     }
40     
41     function EOSDRAM() public {
42         owner = msg.sender;
43         claimeddram[msg.sender] = true;
44         //reserved for dev and exchanges
45         balances[msg.sender] = 7108864 * 10000;
46         _totalSupply = balances[msg.sender];
47         Transfer(0, owner, 71088640000);
48     }
49     
50     function transferOwnership(address newOwner) onlyOwner public {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 
56     function totalSupply() constant public returns (uint256 supply) {
57         return _totalSupply;
58     }
59 
60     // What's my balance?
61     function balance() constant public returns (uint256) {
62             return balances[msg.sender];
63     }
64 
65     // What is the balance of a particular account?
66     function balanceOf(address _address) constant public returns (uint256) {
67         return balances[_address];
68     }
69 
70     // Transfer the balance from owner's account to another account
71     function transfer(address _to, uint256 _amount) public returns (bool success) {
72  
73         if (balances[msg.sender] >= _amount
74             && _amount > 0) {
75              if (balances[_to] + _amount > balances[_to]) {
76                 balances[msg.sender] -= _amount;
77                 balances[_to] += _amount;
78                 Transfer(msg.sender, _to, _amount);
79                 return true;
80             } else {
81                 return false;
82             }
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
94     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
95         if (balances[_from] >= _amount
96             && allowed[_from][msg.sender] >= _amount
97             && _amount > 0) {
98             if (balances[_to] + _amount > balances[_to]) {
99                 balances[_from] -= _amount;
100                 allowed[_from][msg.sender] -= _amount;
101                 balances[_to] += _amount;
102                 Transfer(_from, _to, _amount);
103                 return true;
104             } else {
105                 return false;
106             }
107         } else {
108             return false;
109         }
110     }
111 
112     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
113     // If this function is called again it overwrites the current allowance with _value.
114     function approve(address _spender, uint256 _amount) public returns (bool success) {
115         allowed[msg.sender][_spender] = _amount;
116         Approval(msg.sender, _spender, _amount);
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
121         return allowed[_owner][_spender];
122     }
123 
124     // claim DRAM function
125     function claimdram() public returns (bool success) {
126         if (_totalSupply < _maxSupply && !claimeddram[msg.sender]) {
127             claimeddram[msg.sender] = true;
128             balances[msg.sender] += _airdropAmount;
129             _totalSupply += _airdropAmount;
130             Transfer(0, msg.sender, _airdropAmount);
131             return true;
132         } else {
133             return false;
134             }
135     }
136 
137 }