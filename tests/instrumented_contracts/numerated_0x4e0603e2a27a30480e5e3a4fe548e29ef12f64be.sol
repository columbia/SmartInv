1 pragma solidity ^0.4.8;
2 
3 // The implementation for the Credo smart contract was inspired by
4 // the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.
5 
6 ///////////////
7 // SAFE MATH //
8 ///////////////
9 
10 contract SafeMath {
11 
12     function assert(bool assertion) internal {
13         if (!assertion) {
14             throw;
15         }
16     }      // assert no longer needed once solidity is on 0.4.10
17 
18     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
19       uint256 z = x + y;
20       assert((z >= x) && (z >= y));
21       return z;
22     }
23 
24     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
25       assert(x >= y);
26       uint256 z = x - y;
27       return z;
28     }
29 
30     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
31       uint256 z = x * y;
32       assert((x == 0)||(z/x == y));
33       return z;
34     }
35 
36 }
37 
38 ////////////////////
39 // STANDARD TOKEN //
40 ////////////////////
41 
42 contract Token {
43     uint256 public totalSupply;
44     function balanceOf(address _owner) constant returns (uint256 balance);
45     function transfer(address _to, uint256 _value) returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
47     function approve(address _spender, uint256 _value) returns (bool success);
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /*  ERC 20 token */
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58       if (balances[msg.sender] >= _value && _value > 0) {
59         balances[msg.sender] -= _value;
60         balances[_to] += _value;
61         Transfer(msg.sender, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70         balances[_to] += _value;
71         balances[_from] -= _value;
72         allowed[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75       } else {
76         return false;
77       }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }
97 
98 /////////////////
99 // CREDO TOKEN //
100 /////////////////
101 
102 contract Credo is StandardToken, SafeMath {
103     // Descriptive properties
104     string public constant name = "Credo Token";
105     string public constant symbol = "CREDO";
106     uint256 public constant decimals = 18;
107     string public version = "1.0";
108 
109     // Account for ether proceed.
110     address public etherProceedsAccount;
111 
112     // Reserve account for the remaining 90% of credos.
113     address public credosReserveAccount;
114     uint256 public constant credosReserveAllocation = 1350 * (10**6) * 10**decimals;
115 
116     // These params specify the start, end, min, and max of the sale.
117     bool public isFinalized;
118     uint256 public fundingStartBlock;
119     uint256 public fundingEndBlock;
120     uint256 public constant tokenCreationCap =  1500 * (10**6) * 10**decimals;
121     uint256 public constant tokenCreationMin =  1355 * (10**6) * 10**decimals;
122 
123     // Setting the exchange rate for the first part of the ICO.
124     uint256 public constant credoEthExchangeRate = 100000;
125 
126     // Events for logging refunds and token creation.
127     event LogRefund(address indexed _to, uint256 _value);
128     event CreateCredo(address indexed _to, uint256 _value);
129 
130     // constructor
131     function Credo(address _etherProceedsAccount, address _credosReserveAccount, uint256 _fundingStartBlock, uint256 _fundingEndBlock)
132     {
133       isFinalized                    = false;
134       etherProceedsAccount           = _etherProceedsAccount;
135       credosReserveAccount           = _credosReserveAccount;
136       fundingStartBlock              = _fundingStartBlock;
137       fundingEndBlock                = _fundingEndBlock;
138       totalSupply                    = credosReserveAllocation;
139       balances[credosReserveAccount] = credosReserveAllocation;
140       CreateCredo(credosReserveAccount, credosReserveAllocation);
141     }
142 
143     function createTokens() payable external {
144       if (isFinalized) throw;
145       if (block.number < fundingStartBlock) throw;
146       if (block.number > fundingEndBlock) throw;
147       if (msg.value == 0) throw;
148 
149       uint256 tokens = safeMult(msg.value, credoEthExchangeRate);
150       uint256 checkedSupply = safeAdd(totalSupply, tokens);
151 
152       if (tokenCreationCap < checkedSupply) throw;
153 
154       totalSupply = checkedSupply;
155       balances[msg.sender] += tokens;
156       CreateCredo(msg.sender, tokens);
157     }
158 
159     function finalize() external {
160       if (isFinalized) throw;
161       if (msg.sender != etherProceedsAccount) throw;
162       if (totalSupply < tokenCreationMin) throw;
163       if (block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
164 
165       isFinalized = true;
166 
167       if (!etherProceedsAccount.send(this.balance)) throw;
168     }
169 
170     function refund() external {
171       if (isFinalized) throw;
172       if (block.number <= fundingEndBlock) throw;
173       if (totalSupply >= tokenCreationMin) throw;
174       if (msg.sender == credosReserveAccount) throw;
175       uint256 credoVal = balances[msg.sender];
176       if (credoVal == 0) throw;
177       balances[msg.sender] = 0;
178       totalSupply = safeSubtract(totalSupply, credoVal);
179       uint256 ethVal = credoVal / credoEthExchangeRate;
180       LogRefund(msg.sender, ethVal);
181       if (!msg.sender.send(ethVal)) throw;
182     }
183 
184 }