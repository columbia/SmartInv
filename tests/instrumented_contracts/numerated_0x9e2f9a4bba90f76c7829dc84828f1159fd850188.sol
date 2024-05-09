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
47     }
48     
49     function transferOwnership(address newOwner) onlyOwner public {
50         if (newOwner != address(0)) {
51             owner = newOwner;
52         }
53     }
54 
55     function totalSupply() constant public returns (uint256 supply) {
56         return _totalSupply;
57     }
58 
59     // What's my balance?
60     function balance() constant public returns (uint256) {
61             return balances[msg.sender];
62     }
63 
64     // What is the balance of a particular account?
65     function balanceOf(address _address) constant public returns (uint256) {
66         return balances[_address];
67     }
68 
69     // Transfer the balance from owner's account to another account
70     function transfer(address _to, uint256 _amount) public returns (bool success) {
71  
72         if (balances[msg.sender] >= _amount
73             && _amount > 0) {
74              if (balances[_to] + _amount > balances[_to]) {
75                 balances[msg.sender] -= _amount;
76                 balances[_to] += _amount;
77                 Transfer(msg.sender, _to, _amount);
78                 return true;
79             } else {
80                 return false;
81             }
82         } else {
83             return false;
84         }
85     }
86 
87     // Send _value amount of tokens from address _from to address _to
88     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
89     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
90     // fees in sub-currencies; the command should fail unless the _from account has
91     // deliberately authorized the sender of the message via some mechanism; we propose
92     // these standardized APIs for approval:
93     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
94         if (balances[_from] >= _amount
95             && allowed[_from][msg.sender] >= _amount
96             && _amount > 0) {
97             if (balances[_to] + _amount > balances[_to]) {
98                 balances[_from] -= _amount;
99                 allowed[_from][msg.sender] -= _amount;
100                 balances[_to] += _amount;
101                 Transfer(_from, _to, _amount);
102                 return true;
103             } else {
104                 return false;
105             }
106         } else {
107             return false;
108         }
109     }
110 
111     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
112     // If this function is called again it overwrites the current allowance with _value.
113     function approve(address _spender, uint256 _amount) public returns (bool success) {
114         allowed[msg.sender][_spender] = _amount;
115         Approval(msg.sender, _spender, _amount);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123     // claim DRAM function
124     function claimdram() public returns (bool success) {
125         if (_totalSupply < _maxSupply && !claimeddram[msg.sender]) {
126             claimeddram[msg.sender] = true;
127             balances[msg.sender] += _airdropAmount;
128             _totalSupply += _airdropAmount;
129             return true;
130         } else {
131             return false;
132             }
133     }
134 
135 }