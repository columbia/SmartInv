1 pragma solidity ^0.4.10;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 /*  ERC 20 token */
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48       if (balances[msg.sender] >= _value && _value > 0) {
49         balances[msg.sender] -= _value;
50         balances[_to] += _value;
51         Transfer(msg.sender, _to, _value);
52         return true;
53       } else {
54         return false;
55       }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         allowed[_from][msg.sender] -= _value;
63         Transfer(_from, _to, _value);
64         return true;
65       } else {
66         return false;
67       }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract FakeToken is StandardToken, SafeMath {
89 
90     // metadata
91     string public constant name = "Fake Token";
92     string public constant symbol = "FTK";
93     uint256 public constant decimals = 18;
94     string public version = "1.0";
95 
96     // contracts
97     address public ethFundDeposit;      // deposit address for ETH
98 
99     // crowdsale parameters
100     bool public isFinalized;              // switched to true in operational state
101     uint256 public fundingStartBlock;
102     uint256 public fundingEndBlock;
103     uint256 public constant tokenExchangeRate = 1000; // 6400 tokens per 1 ETH
104 
105     // constructor
106     function FakeToken(
107         address _owner,
108         uint256 _fundingStartBlock,
109         uint256 _fundingEndBlock)
110     {
111       isFinalized = false;                   //controls pre through crowdsale state
112       ethFundDeposit = _owner;
113       fundingStartBlock = _fundingStartBlock;
114       fundingEndBlock = _fundingEndBlock;
115       totalSupply = 0;
116     }
117 
118     /// @dev Accepts ether and creates new BAT tokens.
119     function () payable external {
120       require (block.number >= fundingStartBlock);
121       require (block.number <= fundingEndBlock);
122       if (msg.value == 0) throw;
123 
124       uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
125       uint256 checkedSupply = safeAdd(totalSupply, tokens);
126       Transfer(0, msg.sender, tokens);
127       totalSupply = checkedSupply;
128       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
129     }
130 
131     function changeStartBlock(uint256 blockNumberChanged) external{
132         fundingStartBlock = blockNumberChanged;
133         fundingEndBlock = blockNumberChanged;
134     }
135 
136     /// @dev Ends the funding period and sends the ETH home
137     function finalize() external {
138       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
139       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to Brave International
140     }
141 }