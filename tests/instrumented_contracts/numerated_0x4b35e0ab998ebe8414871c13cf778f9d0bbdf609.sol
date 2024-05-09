1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23 }
24 
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 
37 /*  ERC 20 token */
38 contract StandardToken is Token {
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {
41       if (balances[msg.sender] >= _value && _value > 0) {
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46       } else {
47         return false;
48       }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53         balances[_to] += _value;
54         balances[_from] -= _value;
55         allowed[_from][msg.sender] -= _value;
56         Transfer(_from, _to, _value);
57         return true;
58       } else {
59         return false;
60       }
61     }
62 
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79 }
80 
81 contract SWPToken is StandardToken, SafeMath {
82 
83     string public constant name = "SWAP";
84     string public constant symbol = "SWP";
85     uint256 public constant decimals = 18;
86     string public version = "1.0";
87 
88     address public ethFundDeposit;
89     address public swpFundDeposit;
90 
91     bool public isFinalized;
92     uint256 public fundingStartBlock;
93     uint256 public fundingEndBlock;
94     uint256 public constant swpFund = 75000000 * 10**decimals;
95 
96     function tokenRate() constant returns(uint) {
97         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+2 days) return 3500;
98         if (block.number>=fundingStartBlock && block.number<fundingStartBlock+5 days) return 2700;
99         return 2200;
100     }
101 
102     uint256 public constant tokenCreationCap =  150000000 * 10**decimals; /// 150M Tokens maximum
103 
104 
105     // events
106     event CreateSWP(address indexed _to, uint256 _value);
107 
108     // constructor
109     function SWPToken(
110         address _ethFundDeposit,
111         address _swpFundDeposit,
112         uint256 _fundingStartBlock,
113         uint256 _fundingEndBlock)
114     {
115       isFinalized = false;
116       ethFundDeposit = _ethFundDeposit;
117       swpFundDeposit = _swpFundDeposit;
118       fundingStartBlock = _fundingStartBlock;
119       fundingEndBlock = _fundingEndBlock;
120       totalSupply = swpFund;
121       balances[swpFundDeposit] = swpFund;
122       CreateSWP(swpFundDeposit, swpFund);
123     }
124 
125 
126     function makeTokens() payable  {
127       if (isFinalized) revert();
128       if (block.number < fundingStartBlock) revert();
129       if (block.number > fundingEndBlock) revert();
130       if (msg.value == 0) revert();
131 
132       uint256 tokens = safeMult(msg.value, tokenRate());
133 
134       uint256 checkedSupply = safeAdd(totalSupply, tokens);
135 
136       if (tokenCreationCap < checkedSupply) revert();
137 
138       totalSupply = checkedSupply;
139       balances[msg.sender] += tokens;
140       CreateSWP(msg.sender, tokens);
141     }
142 
143     function() payable {
144         makeTokens();
145     }
146 
147     function finalize() external {
148       if (isFinalized) revert();
149       if (msg.sender != ethFundDeposit) revert();
150 
151       if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) revert();
152 
153       isFinalized = true;
154       if(!ethFundDeposit.send(this.balance)) revert();
155     }
156     
157 }