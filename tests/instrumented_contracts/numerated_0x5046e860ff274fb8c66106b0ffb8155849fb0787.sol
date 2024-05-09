1 pragma solidity ^0.4.16;
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
29 contract JavaScriptToken is ERC20 {
30     
31     address owner = msg.sender;
32 
33     mapping (address => uint256) balances;
34     mapping (address => mapping (address => uint256)) allowed;
35     
36     uint256 public totalSupply = 7991996 * 10**8;
37 
38     function name() public constant returns (string) { return "JavaScript"; }
39     function symbol() public constant returns (string) { return "JS"; }
40     function decimals() public constant returns (uint8) { return 8; }
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
54     function JavaScriptToken() public {
55         owner = msg.sender;
56         balances[msg.sender] = totalSupply;
57     }
58 
59     modifier onlyOwner { 
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address newOwner) onlyOwner public {
65         owner = newOwner;
66     }
67 
68     function getEthBalance(address _addr) constant public returns(uint) {
69     return _addr.balance;
70     }
71 
72     function distributeJST(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
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
83     function balanceOf(address _owner) constant public returns (uint256) {
84 	 return balances[_owner];
85     }
86 
87     // mitigates the ERC20 short address attack
88     modifier onlyPayloadSize(uint size) {
89         assert(msg.data.length >= size + 4);
90         _;
91     }
92     
93     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
94 
95          if (balances[msg.sender] >= _amount
96              && _amount > 0
97              && balances[_to] + _amount > balances[_to]) {
98              balances[msg.sender] -= _amount;
99              balances[_to] += _amount;
100              Transfer(msg.sender, _to, _amount);
101              return true;
102          } else {
103              return false;
104          }
105     }
106     
107     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
108 
109          if (balances[_from] >= _amount
110              && allowed[_from][msg.sender] >= _amount
111              && _amount > 0
112              && balances[_to] + _amount > balances[_to]) {
113              balances[_from] -= _amount;
114              allowed[_from][msg.sender] -= _amount;
115              balances[_to] += _amount;
116              Transfer(_from, _to, _amount);
117              return true;
118          } else {
119             return false;
120          }
121     }
122     
123     function approve(address _spender, uint256 _value) public returns (bool success) {
124         // mitigates the ERC20 spend/approval race condition
125         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
126         
127         allowed[msg.sender][_spender] = _value;
128         
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132     
133     function allowance(address _owner, address _spender) constant public returns (uint256) {
134         return allowed[_owner][_spender];
135     }
136 
137     function finishDistribution() onlyOwner public returns (bool) {
138     distributionFinished = true;
139     DistrFinished();
140     return true;
141     }
142 
143     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
144         require(msg.sender == owner);
145         ForeignToken token = ForeignToken(_tokenContract);
146         uint256 amount = token.balanceOf(address(this));
147         return token.transfer(owner, amount);
148     }
149 
150 
151 }