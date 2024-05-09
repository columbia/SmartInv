1 pragma solidity ^0.4.10;
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
82 contract SPINToken is StandardToken, SafeMath {
83 
84     string public constant name = "ETHERSPIN";
85     string public constant symbol = "SPIN";
86     uint256 public constant decimals = 18;
87     string public version = "2.0";
88 
89     address public ethFundDeposit;
90     address public SPINFundDeposit;
91 
92     bool public isFinalized;
93     uint256 public fundingStartBlock;
94     uint256 public fundingEndBlock;
95     uint256 public constant SPINFund = 2000 * (10**3) * 10**decimals;
96 
97     function tokenRate() constant returns(uint) {
98         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+250) return 1300;
99         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+33600) return 1000;
100         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+67200) return 750;
101         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+100800) return 600;
102         return 500;
103     }
104 
105     // Total Cap is 10M
106     uint256 public constant tokenCreationCap =  10 * (10**6) * 10**decimals;
107 
108 
109     // events
110     event CreateSPIN(address indexed _to, uint256 _value);
111 
112     // constructor
113     function SPINToken(
114         address _ethFundDeposit,
115         address _SPINFundDeposit,
116         uint256 _fundingStartBlock,
117         uint256 _fundingEndBlock)
118     {
119       isFinalized = false;
120       ethFundDeposit = _ethFundDeposit;
121       SPINFundDeposit = _SPINFundDeposit;
122       fundingStartBlock = _fundingStartBlock;
123       fundingEndBlock = _fundingEndBlock;
124       totalSupply = SPINFund;
125       balances[SPINFundDeposit] = SPINFund;
126       CreateSPIN(SPINFundDeposit, SPINFund);
127     }
128 
129 
130     function makeTokens() payable  {
131       if (isFinalized) throw;
132       if (block.number < fundingStartBlock) throw;
133       if (block.number > fundingEndBlock) throw;
134       if (msg.value == 0) throw;
135 
136       uint256 tokens = safeMult(msg.value, tokenRate());
137 
138       uint256 checkedSupply = safeAdd(totalSupply, tokens);
139 
140       if (tokenCreationCap < checkedSupply) throw;
141 
142       totalSupply = checkedSupply;
143       balances[msg.sender] += tokens;
144       CreateSPIN(msg.sender, tokens);
145     }
146 
147     function() payable {
148         makeTokens();
149     }
150 
151     function finalize() external {
152       if (isFinalized) throw;
153       if (msg.sender != ethFundDeposit) throw;
154 
155       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
156 
157       isFinalized = true;
158       if(!ethFundDeposit.send(this.balance)) throw;
159     }
160 
161 
162 
163 }