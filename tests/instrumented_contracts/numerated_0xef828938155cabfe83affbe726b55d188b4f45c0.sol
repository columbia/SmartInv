1 pragma solidity ^0.4.15;
2 
3 contract SafeMath {
4 
5 
6     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
7       uint256 z = x + y;
8       assert((z >= x) && (z >= y));
9       return z;
10     }
11 
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13       assert(x >= y);
14       uint256 z = x - y;
15       return z;
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19       uint256 z = x * y;
20       assert((x == 0)||(z/x == y));
21       return z;
22     }
23 
24 }
25 
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 /*  ERC 20 token */
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42       if (balances[msg.sender] >= _value && _value > 0) {
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46         return true;
47       } else {
48         return false;
49       }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54         balances[_to] += _value;
55         balances[_from] -= _value;
56         allowed[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59       } else {
60         return false;
61       }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract APPToken is StandardToken, SafeMath {
83 
84     string public constant name = "APPIAN";
85     string public constant symbol = "APP";
86     uint256 public constant decimals = 18;
87     string public version = "1.0";
88 
89     address public ethFundDeposit;
90     address public appFundDeposit;
91 
92     bool public isFinalized;
93     uint256 public fundingStartBlock;
94     uint256 public fundingEndBlock;
95     uint256 public constant appFund = 3000 * (10**3) * 10**decimals;
96 
97     function tokenRate() constant returns(uint) {
98         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+23333) return 360;
99         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+23333) return 300;
100         return 250;
101     }
102 
103     uint256 public constant tokenCreationCap =  7.5 * (10**6) * 10**decimals; /// 4.5 Million Tokens Max
104 
105 
106     // events
107     event CreateAPP(address indexed _to, uint256 _value);
108 
109     // constructor
110     function APPToken(
111         address _ethFundDeposit,
112         address _appFundDeposit,
113         uint256 _fundingStartBlock,
114         uint256 _fundingEndBlock)
115     {
116       isFinalized = false;
117       ethFundDeposit = _ethFundDeposit;
118       appFundDeposit = _appFundDeposit;
119       fundingStartBlock = _fundingStartBlock;
120       fundingEndBlock = _fundingEndBlock;
121       totalSupply = appFund;
122       balances[appFundDeposit] = appFund;
123       CreateAPP(appFundDeposit, appFund);
124     }
125 
126 
127     function makeTokens() payable  {
128       if (isFinalized) throw;
129       if (block.number < fundingStartBlock) throw;
130       if (block.number > fundingEndBlock) throw;
131       if (msg.value == 0) throw;
132 
133       uint256 tokens = safeMult(msg.value, tokenRate());
134 
135       uint256 checkedSupply = safeAdd(totalSupply, tokens);
136 
137       if (tokenCreationCap < checkedSupply) throw;
138 
139       totalSupply = checkedSupply;
140       balances[msg.sender] += tokens;
141       CreateAPP(msg.sender, tokens);
142     }
143 
144     function() payable {
145         makeTokens();
146     }
147 
148     function finalize() external {
149       if (isFinalized) throw;
150       if (msg.sender != ethFundDeposit) throw;
151 
152       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
153 
154       isFinalized = true;
155       if(!ethFundDeposit.send(this.balance)) throw;
156     }
157 
158 
159 
160 }