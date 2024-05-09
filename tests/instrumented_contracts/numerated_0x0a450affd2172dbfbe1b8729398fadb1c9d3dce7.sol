1 // © DreamMaker token 2018 All Rights Reserved
2 // Telegram group: @DRMKtoken
3 // Twitter: @DRMKtoken
4 // Telegram of the founder: @DRMKdev
5 
6 pragma solidity ^0.4.25;
7 
8 contract ForeignToken {
9     function balanceOf(address _owner) public constant returns (uint256);
10     function transfer(address _to, uint256 _value) public returns (bool);
11 }
12 
13 contract ERC20Basic {
14 
15   uint256 public totalSupply;
16   function balanceOf(address who) public constant returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 
20 }
21 
22 contract ERC20 is ERC20Basic {
23 
24   function allowance(address owner, address spender) public constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29 }
30 
31 contract DreamMaker is ERC20 {
32     
33     address owner = msg.sender;
34 
35     mapping (address => uint256) balances;
36     mapping (address => mapping (address => uint256)) allowed;
37     
38     uint256 public totalSupply = 86000000 * 10000;
39 
40     function name() public constant returns (string) { return "DreamMaker"; }
41     function symbol() public constant returns (string) { return "DRMK"; }
42     function decimals() public constant returns (uint8) { return 4; }
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     event DistrFinished();
48 
49     bool public distributionFinished = false;
50 
51     modifier canDistr() {
52     require(!distributionFinished);
53     _;
54     }
55 
56     function DreamMaker() public {
57         owner = msg.sender;
58         balances[msg.sender] = totalSupply;
59     }
60 
61     modifier onlyOwner { 
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner public {
67         owner = newOwner;
68     }
69 
70     function getEthBalance(address _addr) constant public returns(uint) {
71     return _addr.balance;
72     }
73 
74     function distributeDRMK(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
75          for (uint i = 0; i < addresses.length; i++) {
76 	     if (getEthBalance(addresses[i]) < _ethbal) {
77  	         continue;
78              }
79              balances[owner] -= _value;
80              balances[addresses[i]] += _value;
81              emit Transfer(owner, addresses[i], _value);
82          }
83     }
84     
85     function balanceOf(address _owner) constant public returns (uint256) {
86 	 return balances[_owner];
87     }
88 
89     // mitigates the ERC20 short address attack
90     modifier onlyPayloadSize(uint size) {
91         assert(msg.data.length >= size + 4);
92         _;
93     }
94     
95     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
96 
97          if (balances[msg.sender] >= _amount
98              && _amount > 0
99              && balances[_to] + _amount > balances[_to]) {
100              balances[msg.sender] -= _amount;
101              balances[_to] += _amount;
102              emit Transfer(msg.sender, _to, _amount);
103              return true;
104          } else {
105              return false;
106          }
107     }
108     
109     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
110 
111          if (balances[_from] >= _amount
112              && allowed[_from][msg.sender] >= _amount
113              && _amount > 0
114              && balances[_to] + _amount > balances[_to]) {
115              balances[_from] -= _amount;
116              allowed[_from][msg.sender] -= _amount;
117              balances[_to] += _amount;
118              emit Transfer(_from, _to, _amount);
119              return true;
120          } else {
121             return false;
122          }
123     }
124     
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         // mitigates the ERC20 spend/approval race condition
127         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
128         
129         allowed[msg.sender][_spender] = _value;
130         
131         emit Approval(msg.sender, _spender, _value);
132         return true;
133     }
134     
135     function allowance(address _owner, address _spender) constant public returns (uint256) {
136         return allowed[_owner][_spender];
137     }
138 
139     function finishDistribution() onlyOwner public returns (bool) {
140     distributionFinished = true;
141     emit DistrFinished();
142     return true;
143     }
144 
145     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
146         require(msg.sender == owner);
147         ForeignToken token = ForeignToken(_tokenContract);
148         uint256 amount = token.balanceOf(address(this));
149         return token.transfer(owner, amount);
150     }
151 
152 }