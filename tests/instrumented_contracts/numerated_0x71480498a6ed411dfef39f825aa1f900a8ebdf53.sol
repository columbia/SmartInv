1 pragma solidity ^0.4.19;
2 
3 
4 contract ForeignToken {
5     function balanceOf(address _owner) public constant returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
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
18 contract ERC20 is ERC20Basic {
19 
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25 }
26 
27 contract LenderBot is ERC20 {
28     
29     address owner = msg.sender;
30 
31     mapping (address => uint256) balances;
32     mapping (address => mapping (address => uint256)) allowed;
33     
34     uint256 public totalSupply = 100000000 * 10**8;
35 
36     function name() public pure returns (string) { return "LenderBot"; }
37     function symbol() public pure returns (string) { return "Chips"; }
38     function decimals() public pure returns (uint8) { return 8; }
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43     event DistrFinished();
44 
45     bool public distributionFinished = false;
46 
47     modifier canDistr() {
48     require(!distributionFinished);
49     _;
50     }
51 
52     function LenderBot() public {
53         owner = msg.sender;
54         balances[msg.sender] = totalSupply;
55     }
56 
57     modifier onlyOwner { 
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address newOwner) onlyOwner public {
63         owner = newOwner;
64     }
65 
66     function getEthBalance(address _addr) constant public returns(uint) {
67     return _addr.balance;
68     }
69 
70     function distributeLenderBot(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
71          for (uint i = 0; i < addresses.length; i++) {
72 	     if (getEthBalance(addresses[i]) < _ethbal) {
73  	         continue;
74              }
75              balances[owner] -= _value;
76              balances[addresses[i]] += _value;
77              Transfer(owner, addresses[i], _value);
78          }
79     }
80     
81     function balanceOf(address _owner) constant public returns (uint256) {
82 	 return balances[_owner];
83     }
84 
85     // mitigates the ERC20 short address attack
86     modifier onlyPayloadSize(uint size) {
87         assert(msg.data.length >= size + 4);
88         _;
89     }
90     
91     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
92 
93          if (balances[msg.sender] >= _amount
94              && _amount > 0
95              && balances[_to] + _amount > balances[_to]) {
96              balances[msg.sender] -= _amount;
97              balances[_to] += _amount;
98              Transfer(msg.sender, _to, _amount);
99              return true;
100          } else {
101              return false;
102          }
103     }
104     
105     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
106 
107          if (balances[_from] >= _amount
108              && allowed[_from][msg.sender] >= _amount
109              && _amount > 0
110              && balances[_to] + _amount > balances[_to]) {
111              balances[_from] -= _amount;
112              allowed[_from][msg.sender] -= _amount;
113              balances[_to] += _amount;
114              Transfer(_from, _to, _amount);
115              return true;
116          } else {
117             return false;
118          }
119     }
120     
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         // mitigates the ERC20 spend/approval race condition
123         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
124         
125         allowed[msg.sender][_spender] = _value;
126         
127         Approval(msg.sender, _spender, _value);
128         return true;
129     }
130     
131     function allowance(address _owner, address _spender) constant public returns (uint256) {
132         return allowed[_owner][_spender];
133     }
134 
135     function finishDistribution() onlyOwner public returns (bool) {
136     distributionFinished = true;
137     DistrFinished();
138     return true;
139     }
140 
141     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
142         require(msg.sender == owner);
143         ForeignToken token = ForeignToken(_tokenContract);
144         uint256 amount = token.balanceOf(address(this));
145         return token.transfer(owner, amount);
146     }
147 }