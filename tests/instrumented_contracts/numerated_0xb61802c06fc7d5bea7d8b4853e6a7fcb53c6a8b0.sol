1 pragma solidity ^0.4.18;
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
82 contract HolyCoin is StandardToken, SafeMath {
83 
84     string public constant name = "HolyCoin";
85     string public constant symbol = "HOLY";
86     uint256 public constant decimals = 18;
87     string public version = "1.0";
88 
89     address public ethFundDeposit;
90     address public holyFoundersFundDeposit;
91     address public holyBountyFundDeposit;
92 
93     bool public isFinalized;
94     uint256 public fundingStartUnixTimestamp;
95     uint256 public fundingEndUnixTimestamp;
96     uint256 public constant foundersFund = 2400 * (10**3) * 10**decimals; // 2.4M HolyCoins
97     uint256 public constant bountyFund = 600 * (10**3) * 10**decimals; // 0.6M HolyCoins
98     uint256 public constant conversionRate = 900; // 900 HolyCoins = 1 ETH
99 
100     function tokenRate() constant returns(uint) {
101         return conversionRate;
102     }
103 
104     uint256 public constant tokenCreationCap =  12 * (10**6) * 10**decimals; // 12M HolyCoins maximum
105 
106 
107     // events
108     event CreateHOLY(address indexed _to, uint256 _value);
109 
110     // constructor
111     function HolyCoin(
112         address _ethFundDeposit,
113         address _holyFoundersFundDeposit,
114         address _holyBountyFundDeposit,
115         uint256 _fundingStartUnixTimestamp,
116         uint256 _fundingEndUnixTimestamp)
117     {
118       isFinalized = false;
119       ethFundDeposit = _ethFundDeposit;
120       holyFoundersFundDeposit = _holyFoundersFundDeposit;
121       holyBountyFundDeposit = _holyBountyFundDeposit;
122       fundingStartUnixTimestamp = _fundingStartUnixTimestamp;
123       fundingEndUnixTimestamp = _fundingEndUnixTimestamp;
124       totalSupply = foundersFund + bountyFund;
125       balances[holyFoundersFundDeposit] = foundersFund;
126       balances[holyBountyFundDeposit] = bountyFund;
127       CreateHOLY(holyFoundersFundDeposit, foundersFund);
128       CreateHOLY(holyBountyFundDeposit, bountyFund);
129     }
130 
131 
132     function makeTokens() payable  {
133       if (isFinalized) throw;
134       if (block.timestamp < fundingStartUnixTimestamp) throw;
135       if (block.timestamp > fundingEndUnixTimestamp) throw;
136       if (msg.value < 100 finney || msg.value > 100 ether) throw; // 100 finney = 0.1 ether
137 
138       uint256 tokens = safeMult(msg.value, tokenRate());
139 
140       uint256 checkedSupply = safeAdd(totalSupply, tokens);
141 
142       if (tokenCreationCap < checkedSupply) throw;
143 
144       totalSupply = checkedSupply;
145       balances[msg.sender] += tokens;
146       CreateHOLY(msg.sender, tokens);
147     }
148 
149     function() payable {
150         makeTokens();
151     }
152 
153     function finalize() external {
154       if (isFinalized) throw;
155       if (msg.sender != ethFundDeposit) throw;
156 
157       if(block.timestamp <= fundingEndUnixTimestamp && totalSupply != tokenCreationCap) throw;
158 
159       isFinalized = true;
160       if(!ethFundDeposit.send(this.balance)) throw;
161     }
162 
163 
164 
165 }