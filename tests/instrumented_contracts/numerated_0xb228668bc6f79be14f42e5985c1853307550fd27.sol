1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // EXCRETEUM
5 // Standard ERC20 Token
6 // 120M supply distributed as such: 10M creators, 20M marketing, 90M ico
7 // ----------------------------------------------------------------------------------------------
8 
9 contract ERC20Interface {
10 
11     function totalSupply() constant returns (uint256 totalSupply);
12     function balanceOf(address _owner) constant returns (uint256 balance);
13     function transfer(address _to, uint256 _value) returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21 }
22 
23 // As of 2017
24 // 14 000 000 000 000 US dollars go through the banking system daily
25 
26 // In America, the top 1% earns $360 000 per year
27 // Roughly ten times the average income
28 // The top 0.01% earns $10 000 000 per year
29 // Roughly thirty times as much as the top 1%
30 
31 // The human brain handles large numbers poorly
32 // The difference between a billionaire and a millionaire is remote to most
33 // The difference between 1M, 10M and 100M even more so
34 
35 contract ExcreteumToken is ERC20Interface {
36     
37     string public constant symbol = "SHET";
38     string public constant name = "Excreteum";
39     uint8 public constant decimals = 8;
40     uint256 _totalSupply = 12000000000000000;
41 
42     // 1. EQUALITY IS AN ILLUSION
43     //
44     // People are born with varied levels of ability
45     // Further enhanced or discouraged by environmental factors
46     //
47     // Natural selection demands competition
48     // Attempts to enforce a level-playing field cannot change this nature
49     // Only the nature of said competition differs
50 
51     address public owner;
52     mapping(address => uint256) balances;
53     mapping(address => mapping (address => uint256)) allowed;
54 
55     modifier onlyOwner() {
56         if (msg.sender != owner) {
57             throw;
58         }
59         _;
60     }
61     
62     // 2. CODE CANNOT BE LAW
63     //
64     // Technology is beyond the intuition of the average person
65     // The knowledge gap widens with each innovation
66     //
67     // A sufficiently advanced decentralized system becomes defacto centralized
68     // As actors who understand this system are increasingly sparse
69     
70     function ExcreteumToken() {
71         owner = msg.sender;
72         balances[owner] = _totalSupply;
73     }
74 
75     function totalSupply() constant returns (uint256 totalSupply) {
76         totalSupply = _totalSupply;
77     }
78     
79     // 3. TRUST IS MANDATORY
80     //
81     // Social bridges are required even in trustless environments
82     // Confidence is built between people rather than systems
83     //
84     // Benevolent dictators can foster positive communities
85     // In the absence of guidance, negative actors will fill that gap
86 
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function transfer(address _to, uint256 _amount) returns (bool success) {
92         if (balances[msg.sender] >= _amount 
93             && _amount > 0
94             && balances[_to] + _amount > balances[_to]) {
95             balances[msg.sender] -= _amount;
96             balances[_to] += _amount;
97             Transfer(msg.sender, _to, _amount);
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     // 4. TRANSPARENCY IS SYNONYMOUS WITH ANONYMITY
105     //
106     // Transparency in action keeps actors honest
107     // Transparency in identity opens up single points of failure
108     //
109     // An immutable ledger works best when no human transactions occur offchain
110     // Anonymous entities cannot be silenced, influenced or disposed of
111     
112     function transferFrom(
113         address _from,
114         address _to,
115         uint256 _amount
116     ) returns (bool success) {
117         if (balances[_from] >= _amount
118             && allowed[_from][msg.sender] >= _amount
119             && _amount > 0
120             && balances[_to] + _amount > balances[_to]) {
121             balances[_from] -= _amount;
122             allowed[_from][msg.sender] -= _amount;
123             balances[_to] += _amount;
124             Transfer(_from, _to, _amount);
125             return true;
126         } else {
127             return false;
128         }
129     }
130 
131     // 5. INFORMATION IS PRICELESS
132     //
133     // Neither assets nor currencies have inherent worth
134     // Asynchronous value comes from asynchronous information
135     //
136     // Sharing knowledge at any level of understanding help actors make choices
137     // Information is useful regardless of veracity
138 
139 
140     function approve(address _spender, uint256 _amount) returns (bool success) {
141         allowed[msg.sender][_spender] = _amount;
142         Approval(msg.sender, _spender, _amount);
143         return true;
144     }
145 
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147         return allowed[_owner][_spender];
148     }
149 
150     // 6. NATURE IS GOOD
151     //
152     // Take a walk outside
153     // Learn to build a campfire
154     // Plant a tree this year
155     // Watch out for cow dung
156     
157 }