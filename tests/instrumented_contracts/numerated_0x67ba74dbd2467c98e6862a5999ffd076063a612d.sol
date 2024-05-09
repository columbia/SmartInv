1 // (c) Bitzlato Ltd, 2019
2 pragma solidity ^0.5.0 <6.0.0;
3 
4 contract RUBMToken {
5 
6     string public name = "Monolith RUB";    //  token name
7     string public symbol = "RUBM";          //  token symbol
8     uint256 public decimals = 0;            //  token digit
9 
10     mapping (address => uint256) private balances;
11     mapping (address => mapping (address => uint256)) private allowed;
12 
13     uint256 private _totalSupply = 0;
14     bool public stopped = false;
15 
16     uint256 constant valueFounder = 1e10;
17     address ownerA = address(0x0);
18     address ownerB = address(0x0);
19     address ownerC = address(0x0);
20     uint public voteA = 0;
21     uint public voteB = 0;
22     uint public voteC = 0;
23     uint public mintA = 0;
24     uint public mintB = 0;
25     uint public mintC = 0;
26 
27     modifier hasVote {
28         require((voteA + voteB + voteC) >= 2);
29         _;
30         voteA = 0;
31         voteB = 0;
32         voteC = 0;
33     }
34 
35     modifier isOwner {
36         assert(ownerA == msg.sender || ownerB == msg.sender || ownerC == msg.sender);
37         _;
38     }
39 
40     modifier isRunning {
41         assert (!stopped);
42         _;
43     }
44 
45     modifier validAddress {
46         assert(address(0x0) != msg.sender);
47         _;
48     }
49 
50     constructor(address _addressFounderB, address _addressFounderC) public {
51         assert(address(0x0) != msg.sender);
52         assert(address(0x0) != _addressFounderB);
53         assert(address(0x0) != _addressFounderC);
54         assert(_addressFounderB != _addressFounderC);
55         ownerA = msg.sender;
56         ownerB = _addressFounderB;
57         ownerC = _addressFounderC;
58         _totalSupply = valueFounder;
59         balances[ownerA] = valueFounder;
60         balances[ownerB] = 0;
61         balances[ownerC] = 0;
62         emit Transfer(address(0x0), ownerA, valueFounder);
63     }
64     
65     function totalSupply() public view returns (uint256 total) {
66         total = _totalSupply;
67     }
68  
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
74         return allowed[_owner][_spender];
75     }
76 
77     function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
78         require(balances[msg.sender] >= _value);
79         require(balances[_to] + _value >= balances[_to]);
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
87         require(balances[_from] >= _value);
88         require(balances[_to] + _value >= balances[_to]);
89         require(allowed[_from][msg.sender] >= _value);
90         balances[_to] += _value;
91         balances[_from] -= _value;
92         allowed[_from][msg.sender] -= _value;
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
98         require(_value == 0 || allowed[msg.sender][_spender] == 0);
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function stop() isOwner public {
105         stopped = true;
106     }
107 
108     function start() isOwner public {
109         stopped = false;
110     }
111 
112     function setName(string memory _name) isOwner public {
113         name = _name;
114     }
115 
116     function doMint(uint256 _value) isOwner hasVote public {
117         assert(_value > 0 && _value <= (mintA + mintB + mintC));
118         mintA = 0; mintB = 0; mintC = 0;
119         balances[msg.sender] += _value;
120         _totalSupply += _value;
121         emit DoMint(msg.sender, _value);
122     }
123 
124     function proposeMint(uint256 _value) public {
125         if (msg.sender == ownerA) {mintA = _value; emit ProposeMint(msg.sender, _value); return;}
126         if (msg.sender == ownerB) {mintB = _value; emit ProposeMint(msg.sender, _value); return;}
127         if (msg.sender == ownerC) {mintC = _value; emit ProposeMint(msg.sender, _value); return;}
128         assert(false);
129     }
130 
131     function vote(uint v) public {
132         uint s = 0;
133         if (v > 0) {s = 1;}
134         if (msg.sender == ownerA) {voteA = s; emit Vote(msg.sender, s); return;}
135         if (msg.sender == ownerB) {voteB = s; emit Vote(msg.sender, s); return;}
136         if (msg.sender == ownerC) {voteC = s; emit Vote(msg.sender, s); return;}
137 
138         assert(false);
139     }
140 
141     function burn(uint256 _value) public {
142         require(balances[msg.sender] >= _value);
143         balances[msg.sender] -= _value;
144         balances[address(0x0)] += _value;
145         emit Transfer(msg.sender, address(0x0), _value);
146     }
147 
148     function destroy(address _addr, uint256 _value) isOwner hasVote public {
149         require(balances[_addr] >= _value);
150         balances[_addr] -= _value;
151         balances[address(0x0)] += _value;
152         emit Transfer(_addr, address(0x0), _value);
153     }
154 
155     event Transfer(address indexed _from, address indexed _to, uint256 _value);
156     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
157     event ProposeMint(address indexed _owner, uint256 _value);
158     event Vote(address indexed _owner, uint v);
159     event DoMint(address indexed _from, uint256 _value);
160 }