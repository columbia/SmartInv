1 pragma solidity ^0.4.10;
2 
3 contract ERC20Interface {
4     uint public totalSupply;
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Administrable {
16     address admin;
17     bool public isPayable;
18     
19     function Administrable() {
20         admin = msg.sender;
21         isPayable = true;
22     }
23     
24     modifier onlyAdmin() {
25         require(msg.sender == admin);
26         _;
27     }
28     
29     modifier checkPayable() {
30         require(isPayable);
31         _;
32     }
33     
34     function setPayable(bool isPayable_) onlyAdmin {
35         isPayable = isPayable_;
36     }
37     
38     function kill() onlyAdmin {
39         selfdestruct(admin);
40     }
41 }
42 
43 contract NicoToken is ERC20Interface, Administrable {
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46 
47     string public constant name = "Nico Token";
48     string public constant symbol = "NICO";
49     uint8 public constant decimals = 18;
50     uint public tokensPerETH = 1000;
51     
52     function balanceOf(address _owner) constant returns (uint256) { 
53         return balances[_owner];
54     }
55     
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         // mitigates the ERC20 short address attack
58         if(msg.data.length < (2 * 32) + 4) { 
59             throw;
60         }
61 
62         if (_value == 0) { 
63             return false;
64         }
65 
66         uint256 fromBalance = balances[msg.sender];
67 
68         bool sufficientFunds = fromBalance >= _value;
69         bool overflowed = balances[_to] + _value < balances[_to];
70         
71         if (sufficientFunds && !overflowed) {
72             balances[msg.sender] -= _value;
73             balances[_to] += _value;
74             
75             Transfer(msg.sender, _to, _value);
76             return true;
77         } else {
78             return false; 
79             
80         }
81     }
82     
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         // mitigates the ERC20 short address attack
85         if(msg.data.length < (3 * 32) + 4) { 
86             throw;
87         }
88 
89         if (_value == 0) {
90             return false;
91         }
92         
93         uint256 fromBalance = balances[_from];
94         uint256 allowance = allowed[_from][msg.sender];
95 
96         bool sufficientFunds = fromBalance <= _value;
97         bool sufficientAllowance = allowance <= _value;
98         bool overflowed = balances[_to] + _value > balances[_to];
99 
100         if (sufficientFunds && sufficientAllowance && !overflowed) {
101             balances[_to] += _value;
102             balances[_from] -= _value;
103             
104             allowed[_from][msg.sender] -= _value;
105             
106             Transfer(_from, _to, _value);
107             return true;
108         } else { 
109             return false;
110         }
111     }
112     
113     function approve(address _spender, uint256 _value) returns (bool success) {
114         // mitigates the ERC20 spend/approval race condition
115         if (_value != 0 && allowed[msg.sender][_spender] != 0) {
116             return false;
117         }
118         
119         allowed[msg.sender][_spender] = _value;
120         
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124     
125     function allowance(address _owner, address _spender) constant returns (uint256) {
126         return allowed[_owner][_spender];
127     }
128 
129     event Transfer(address indexed _from, address indexed _to, uint256 _value);
130     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
131 
132     function withdraw(uint amount) onlyAdmin {
133         admin.transfer(amount);
134     }
135 
136     function mint(uint amount) onlyAdmin {
137         totalSupply += amount;
138         balances[msg.sender] += amount;
139         Transfer(address(this), msg.sender, amount);
140     }
141     
142     function setPrice(uint tokensPerETH_) onlyAdmin {
143         tokensPerETH = tokensPerETH_;
144     }
145 
146     function() payable checkPayable {
147         if (msg.value == 0) {
148             return;
149         }
150         uint tokens = msg.value * tokensPerETH;
151         totalSupply += tokens;
152         balances[msg.sender] += tokens;
153         Transfer(address(this), msg.sender, tokens);
154     }
155 }