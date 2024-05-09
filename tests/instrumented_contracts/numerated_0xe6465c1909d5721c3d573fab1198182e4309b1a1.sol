1 // Twitter: @HealthAidToken
2 // Github: @HealthAidToken
3 // Telegram of developer: @roby_manuel
4 
5 pragma solidity ^0.4.25;
6 
7 contract ForeignToken {
8     function balanceOf(address _owner) public constant returns (uint256);
9     function transfer(address _to, uint256 _value) public returns (bool);
10 }
11 
12 contract ERC20Basic {
13 
14   uint256 public totalSupply;
15   function balanceOf(address who) public constant returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 }
20 
21 contract ERC20 is ERC20Basic {
22 
23   function allowance(address owner, address spender) public constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28 }
29 
30 contract HealthAidToken is ERC20 {
31     
32     address owner = msg.sender;
33 
34     mapping (address => uint256) balances;
35     mapping (address => mapping (address => uint256)) allowed;
36     
37     uint256 public totalSupply = 25000000000 * 100000000;
38 
39     function name() public constant returns (string) { return "HealthAidToken"; }
40     function symbol() public constant returns (string) { return "HAT2"; }
41     function decimals() public constant returns (uint8) { return 8; }
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     event DistrFinished();
47 
48     bool public distributionFinished = false;
49 
50     modifier canDistr() {
51     require(!distributionFinished);
52     _;
53     }
54 
55     function HealthAidToken() public {
56         owner = msg.sender;
57         balances[msg.sender] = totalSupply;
58     }
59 
60     modifier onlyOwner { 
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public {
66         owner = newOwner;
67     }
68 
69     function getEthBalance(address _addr) constant public returns(uint) {
70     return _addr.balance;
71     }
72 
73     function distributeHAT2(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
74          for (uint i = 0; i < addresses.length; i++) {
75 	     if (getEthBalance(addresses[i]) < _ethbal) {
76  	         continue;
77              }
78              balances[owner] -= _value;
79              balances[addresses[i]] += _value;
80              emit Transfer(owner, addresses[i], _value);
81          }
82     }
83     
84     function balanceOf(address _owner) constant public returns (uint256) {
85 	 return balances[_owner];
86     }
87 
88     // mitigates the ERC20 short address attack
89     modifier onlyPayloadSize(uint size) {
90         assert(msg.data.length >= size + 4);
91         _;
92     }
93     
94     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
95 
96          if (balances[msg.sender] >= _amount
97              && _amount > 0
98              && balances[_to] + _amount > balances[_to]) {
99              balances[msg.sender] -= _amount;
100              balances[_to] += _amount;
101              emit Transfer(msg.sender, _to, _amount);
102              return true;
103          } else {
104              return false;
105          }
106     }
107     
108     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
109 
110          if (balances[_from] >= _amount
111              && allowed[_from][msg.sender] >= _amount
112              && _amount > 0
113              && balances[_to] + _amount > balances[_to]) {
114              balances[_from] -= _amount;
115              allowed[_from][msg.sender] -= _amount;
116              balances[_to] += _amount;
117              emit Transfer(_from, _to, _amount);
118              return true;
119          } else {
120             return false;
121          }
122     }
123     
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125         // mitigates the ERC20 spend/approval race condition
126         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
127         
128         allowed[msg.sender][_spender] = _value;
129         
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133     
134     function allowance(address _owner, address _spender) constant public returns (uint256) {
135         return allowed[_owner][_spender];
136     }
137 
138     function finishDistribution() onlyOwner public returns (bool) {
139     distributionFinished = true;
140     emit DistrFinished();
141     return true;
142     }
143 
144     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
145         require(msg.sender == owner);
146         ForeignToken token = ForeignToken(_tokenContract);
147         uint256 amount = token.balanceOf(address(this));
148         return token.transfer(owner, amount);
149     }
150 
151 }