1 pragma solidity ^0.4.8;
2 
3 // The implementation for the Credo ICO smart contract was inspired by
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
53 /*  ERC 20 token */
54 contract StandardToken is Token {
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {
57       if (balances[msg.sender] >= _value && _value > 0) {
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         return true;
62       } else {
63         return false;
64       }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69         balances[_to] += _value;
70         balances[_from] -= _value;
71         allowed[_from][msg.sender] -= _value;
72         Transfer(_from, _to, _value);
73         return true;
74       } else {
75         return false;
76       }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95 }
96 
97 /////////////////////
98 // CREDO ICO TOKEN //
99 /////////////////////
100 
101 contract CredoIco is StandardToken, SafeMath {
102     // Descriptive properties
103     string public constant name = "Credo ICO Token";
104     string public constant symbol = "CREDOICO";
105     uint256 public constant decimals = 18;
106     string public version = "1.0";
107 
108     // Account for ether proceed.
109     address public etherProceedsAccount;
110 
111     // These params specify the start, end, min, and max of the sale.
112     bool public isFinalized;
113     uint256 public fundingStartBlock;
114     uint256 public fundingEndBlock;
115 
116     uint256 public constant tokenCreationCap =  375200000 * 10**decimals;
117     uint256 public constant tokenCreationMin =  938000 * 10**decimals;
118 
119     // Setting the exchange rate for the first part of the ICO.
120     uint256 public constant credoEthExchangeRate = 3752;
121 
122     // Events for logging refunds and token creation.
123     event LogRefund(address indexed _to, uint256 _value);
124     event CreateCredoIco(address indexed _to, uint256 _value);
125 
126     // constructor
127     function CredoIco(address _etherProceedsAccount, uint256 _fundingStartBlock, uint256 _fundingEndBlock)
128     {
129       isFinalized                    = false;
130       etherProceedsAccount           = _etherProceedsAccount;
131       fundingStartBlock              = _fundingStartBlock;
132       fundingEndBlock                = _fundingEndBlock;
133       totalSupply                    = 0;
134     }
135 
136     function createTokens() payable external {
137       if (isFinalized) throw;
138       if (block.number < fundingStartBlock) throw;
139       if (block.number > fundingEndBlock) throw;
140       if (msg.value == 0) throw;
141 
142       uint256 tokens = safeMult(msg.value, credoEthExchangeRate);
143       uint256 checkedSupply = safeAdd(totalSupply, tokens);
144 
145       if (tokenCreationCap < checkedSupply) throw;
146 
147       totalSupply = checkedSupply;
148       balances[msg.sender] += tokens;
149       CreateCredoIco(msg.sender, tokens);
150     }
151 
152     function finalize() external {
153       if (isFinalized) throw;
154       if (msg.sender != etherProceedsAccount) throw;
155       if (totalSupply < tokenCreationMin) throw;
156       if (block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;
157 
158       isFinalized = true;
159 
160       if (!etherProceedsAccount.send(this.balance)) throw;
161     }
162 
163     function refund() external {
164       if (isFinalized) throw;
165       if (block.number <= fundingEndBlock) throw;
166       if (totalSupply >= tokenCreationMin) throw;
167       uint256 credoVal = balances[msg.sender];
168       if (credoVal == 0) throw;
169       balances[msg.sender] = 0;
170       totalSupply = safeSubtract(totalSupply, credoVal);
171       uint256 ethVal = credoVal / credoEthExchangeRate;
172       LogRefund(msg.sender, ethVal);
173       if (!msg.sender.send(ethVal)) throw;
174     }
175 
176 }