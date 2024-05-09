1 pragma solidity ^0.4.25;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 contract ERC20Basic {
9 
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 
15 }
16 
17 contract ERC20 is ERC20Basic {
18 
19   function allowance(address owner, address spender) public constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24 }
25 
26 contract AllyNetworkToken is ERC20 {
27     
28     address owner = msg.sender;
29 
30     mapping (address => uint256) balances;
31     mapping (address => mapping (address => uint256)) allowed;
32     
33     uint256 public totalSupply = 12000000000 * 100000000;
34 
35     function name() public constant returns (string) { return "Ally Network Token"; }
36     function symbol() public constant returns (string) { return "ALLY"; }
37     function decimals() public constant returns (uint8) { return 8; }
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 
42     event DistrFinished();
43 
44     bool public distributionFinished = false;
45 
46     modifier canDistr() {
47     require(!distributionFinished);
48     _;
49     }
50 
51     function AllyNetworkToken() public {
52         owner = msg.sender;
53         balances[msg.sender] = totalSupply;
54     }
55 
56     modifier onlyOwner { 
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 
65     function getEthBalance(address _addr) constant public returns(uint) {
66     return _addr.balance;
67     }
68 
69     function distributeALLY(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
70          for (uint i = 0; i < addresses.length; i++) {
71 	     if (getEthBalance(addresses[i]) < _ethbal) {
72  	         continue;
73              }
74              balances[owner] -= _value;
75              balances[addresses[i]] += _value;
76              emit Transfer(owner, addresses[i], _value);
77          }
78     }
79     
80     function balanceOf(address _owner) constant public returns (uint256) {
81 	 return balances[_owner];
82     }
83 
84     // mitigates the ERC-20 short address attack
85     modifier onlyPayloadSize(uint size) {
86         assert(msg.data.length >= size + 4);
87         _;
88     }
89     
90     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
91 
92          if (balances[msg.sender] >= _amount
93              && _amount > 0
94              && balances[_to] + _amount > balances[_to]) {
95              balances[msg.sender] -= _amount;
96              balances[_to] += _amount;
97              emit Transfer(msg.sender, _to, _amount);
98              return true;
99          } else {
100              return false;
101          }
102     }
103     
104     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
105 
106          if (balances[_from] >= _amount
107              && allowed[_from][msg.sender] >= _amount
108              && _amount > 0
109              && balances[_to] + _amount > balances[_to]) {
110              balances[_from] -= _amount;
111              allowed[_from][msg.sender] -= _amount;
112              balances[_to] += _amount;
113              emit Transfer(_from, _to, _amount);
114              return true;
115          } else {
116             return false;
117          }
118     }
119     
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         // mitigates the ERC20 spend/approval race condition
122         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
123         
124         allowed[msg.sender][_spender] = _value;
125         
126         emit Approval(msg.sender, _spender, _value);
127         return true;
128     }
129     
130     function allowance(address _owner, address _spender) constant public returns (uint256) {
131         return allowed[_owner][_spender];
132     }
133 
134     function finishDistribution() onlyOwner public returns (bool) {
135     distributionFinished = true;
136     emit DistrFinished();
137     return true;
138     }
139 
140     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
141         require(msg.sender == owner);
142         ForeignToken token = ForeignToken(_tokenContract);
143         uint256 amount = token.balanceOf(address(this));
144         return token.transfer(owner, amount);
145     }
146 }