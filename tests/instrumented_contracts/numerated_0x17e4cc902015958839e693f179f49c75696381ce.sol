1 pragma solidity ^0.4.16;
2 
3 
4 contract ForeignToken {
5     function balanceOf(address _owner) constant returns (uint256);
6     function transfer(address _to, uint256 _value) returns (bool);
7 }
8 
9 contract ERC20Basic {
10 
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 
16 }
17 
18 
19 
20 contract ERC20 is ERC20Basic {
21 
22   function allowance(address owner, address spender) public constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27 }
28 
29 contract DimonCoin is ERC20 {
30     
31     address owner = msg.sender;
32 
33     mapping (address => uint256) balances;
34     mapping (address => mapping (address => uint256)) allowed;
35     
36     uint256 public totalSupply = 100000000 * 10**8;
37 
38     function name() constant returns (string) { return "DimonCoin"; }
39     function symbol() constant returns (string) { return "FUDD"; }
40     function decimals() constant returns (uint8) { return 8; }
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45     event DistrFinished();
46 
47     bool public distributionFinished = false;
48 
49     modifier canDistr() {
50     require(!distributionFinished);
51     _;
52     }
53 
54     function DimonCoin() {
55         owner = msg.sender;
56         balances[msg.sender] = totalSupply;
57     }
58 
59     modifier onlyOwner { 
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address newOwner) onlyOwner {
65         owner = newOwner;
66     }
67 
68     function getEthBalance(address _addr) constant returns(uint) {
69     return _addr.balance;
70     }
71 
72     function distributeFUDD(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr {
73          for (uint i = 0; i < addresses.length; i++) {
74 	     if (getEthBalance(addresses[i]) < _ethbal) {
75  	         continue;
76              }
77              balances[owner] -= _value;
78              balances[addresses[i]] += _value;
79              Transfer(owner, addresses[i], _value);
80          }
81     }
82     
83     function balanceOf(address _owner) constant returns (uint256) {
84 	 return balances[_owner];
85     }
86 
87     // mitigates the ERC20 short address attack
88     modifier onlyPayloadSize(uint size) {
89         assert(msg.data.length >= size + 4);
90         _;
91     }
92     
93     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
94 
95         if (_value == 0) { return false; }
96 
97         uint256 fromBalance = balances[msg.sender];
98 
99         bool sufficientFunds = fromBalance >= _value;
100         bool overflowed = balances[_to] + _value < balances[_to];
101         
102         if (sufficientFunds && !overflowed) {
103             balances[msg.sender] -= _value;
104             balances[_to] += _value;
105             
106             Transfer(msg.sender, _to, _value);
107             return true;
108         } else { return false; }
109     }
110     
111     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
112 
113         if (_value == 0) { return false; }
114         
115         uint256 fromBalance = balances[_from];
116         uint256 allowance = allowed[_from][msg.sender];
117 
118         bool sufficientFunds = fromBalance <= _value;
119         bool sufficientAllowance = allowance <= _value;
120         bool overflowed = balances[_to] + _value > balances[_to];
121 
122         if (sufficientFunds && sufficientAllowance && !overflowed) {
123             balances[_to] += _value;
124             balances[_from] -= _value;
125             
126             allowed[_from][msg.sender] -= _value;
127             
128             Transfer(_from, _to, _value);
129             return true;
130         } else { return false; }
131     }
132     
133     function approve(address _spender, uint256 _value) returns (bool success) {
134         // mitigates the ERC20 spend/approval race condition
135         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
136         
137         allowed[msg.sender][_spender] = _value;
138         
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142     
143     function allowance(address _owner, address _spender) constant returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147     function finishDistribution() onlyOwner public returns (bool) {
148     distributionFinished = true;
149     DistrFinished();
150     return true;
151     }
152 
153     function withdrawForeignTokens(address _tokenContract) returns (bool) {
154         require(msg.sender == owner);
155         ForeignToken token = ForeignToken(_tokenContract);
156         uint256 amount = token.balanceOf(address(this));
157         return token.transfer(owner, amount);
158     }
159 
160 
161 }