1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4 
5     function assert(bool assertion) internal {
6         if (!assertion) {
7             throw;
8         }
9     }
10 
11     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
12         uint256 z = x + y;
13         assert((z >= x) && (z >= y));
14         return z;
15     }
16 
17     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
18         assert(x >= y);
19         uint256 z = x - y;
20         return z;
21     }
22 
23     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
24         uint256 z = x * y;
25         assert((x == 0)||(z/x == y));
26         return z;
27     }
28 
29 }
30 
31 contract Token {
32     uint256 public totalSupply;
33     function balanceOf(address _owner) constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36     function approve(address _spender, uint256 _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 /*  ERC 20 token */
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46       if (balances[msg.sender] >= _value && _value > 0) {
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         Transfer(msg.sender, _to, _value);
50         return true;
51       } else {
52         return false;
53       }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 
87 /*  ERC 20 token */
88 contract LeeroyPremiumToken is StandardToken, SafeMath {
89     address public owner;
90 
91     string public constant name = "Leeroy Premium Token";
92     string public constant symbol = "LPT";
93     uint256 public constant decimals = 18;
94     string public version = "1.0";
95 
96     bool public isFinalized;
97     uint256 public fundingStartBlock = 3965525;
98     uint256 public fundingEndBlock = 4115525;
99     uint256 public constant reservedLPT = 375 * (10**6) * 10**decimals;
100     uint256 public constant tokenExchangeRate = 32000;
101     uint256 public constant tokenCreationCap =  2000 * (10**6) * 10**decimals;
102     uint256 public constant tokenCreationMin =  775 * (10**6) * 10**decimals;
103 
104     // events
105     event LogRefund(address indexed _to, uint256 _value);
106     event CreateLPT(address indexed _to, uint256 _value);
107 
108     function LeeroyPremiumToken() {
109         owner = msg.sender;
110         totalSupply = reservedLPT;
111         balances[owner] = reservedLPT;
112         CreateLPT(owner, reservedLPT);
113     }
114 
115     function () payable {
116         createTokens();
117     }
118 
119     function createTokens() payable {
120       if (isFinalized) throw;
121       if (block.number < fundingStartBlock) throw;
122       if (block.number > fundingEndBlock) throw;
123       if (msg.value == 0) throw;
124 
125       uint256 tokens = safeMult(msg.value, tokenExchangeRate);
126       uint256 checkedSupply = safeAdd(totalSupply, tokens);
127 
128       if (tokenCreationCap < checkedSupply) throw;
129 
130       totalSupply = checkedSupply;
131       balances[msg.sender] += tokens;
132       CreateLPT(msg.sender, tokens);
133     }
134 
135     function finalize() external {
136       if (isFinalized) throw;
137       if(totalSupply < tokenCreationMin) throw;
138       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
139       isFinalized = true;
140       if(!owner.send(this.balance)) throw;
141     }
142 
143     function refund() external {
144       if(isFinalized) throw;
145       if (block.number <= fundingEndBlock) throw;
146       if(totalSupply >= tokenCreationMin) throw;
147       uint256 LPTVal = balances[msg.sender];
148       if (LPTVal == 0) throw;
149       balances[msg.sender] = 0;
150       totalSupply = safeSubtract(totalSupply, LPTVal);
151       uint256 ethVal = LPTVal / tokenExchangeRate;
152       LogRefund(msg.sender, ethVal);
153       if (!msg.sender.send(ethVal)) throw;
154     }
155 }