1 // LiteCoin Smart
2 
3 pragma solidity ^0.4.25;
4 
5 contract ForeignToken {
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool);
8 }
9 
10 contract ERC20Basic {
11 
12   uint256 public totalSupply;
13   function balanceOf(address who) public constant returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 
17 }
18 
19 contract ERC20 is ERC20Basic {
20 
21   function allowance(address owner, address spender) public constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 }
27 
28 contract LiteCoin_Smart is ERC20 {
29     
30     address owner = msg.sender;
31 
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34     
35     uint256 public totalSupply = 84000000 * 10000;
36 
37     function name() public constant returns (string) { return "LiteCoin Smart"; }
38     function symbol() public constant returns (string) { return "LTCS"; }
39     function decimals() public constant returns (uint8) { return 4; }
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     event DistrFinished();
45 
46     bool public distributionFinished = false;
47 
48     modifier canDistr() {
49     require(!distributionFinished);
50     _;
51     }
52 
53     function LiteCoin_Smart() public {
54         owner = msg.sender;
55         balances[msg.sender] = totalSupply;
56     }
57 
58     modifier onlyOwner { 
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address newOwner) onlyOwner public {
64         owner = newOwner;
65     }
66 
67     function getEthBalance(address _addr) constant public returns(uint) {
68     return _addr.balance;
69     }
70 
71     function distributeLTCS(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
72          for (uint i = 0; i < addresses.length; i++) {
73 	     if (getEthBalance(addresses[i]) < _ethbal) {
74  	         continue;
75              }
76              balances[owner] -= _value;
77              balances[addresses[i]] += _value;
78              emit Transfer(owner, addresses[i], _value);
79          }
80     }
81     
82     function balanceOf(address _owner) constant public returns (uint256) {
83 	 return balances[_owner];
84     }
85 
86     // mitigates the ERC20 short address attack
87     modifier onlyPayloadSize(uint size) {
88         assert(msg.data.length >= size + 4);
89         _;
90     }
91     
92     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
93 
94          if (balances[msg.sender] >= _amount
95              && _amount > 0
96              && balances[_to] + _amount > balances[_to]) {
97              balances[msg.sender] -= _amount;
98              balances[_to] += _amount;
99              emit Transfer(msg.sender, _to, _amount);
100              return true;
101          } else {
102              return false;
103          }
104     }
105     
106     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
107 
108          if (balances[_from] >= _amount
109              && allowed[_from][msg.sender] >= _amount
110              && _amount > 0
111              && balances[_to] + _amount > balances[_to]) {
112              balances[_from] -= _amount;
113              allowed[_from][msg.sender] -= _amount;
114              balances[_to] += _amount;
115              emit Transfer(_from, _to, _amount);
116              return true;
117          } else {
118             return false;
119          }
120     }
121     
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123         // mitigates the ERC20 spend/approval race condition
124         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
125         
126         allowed[msg.sender][_spender] = _value;
127         
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131     
132     function allowance(address _owner, address _spender) constant public returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function finishDistribution() onlyOwner public returns (bool) {
137     distributionFinished = true;
138     emit DistrFinished();
139     return true;
140     }
141 
142     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
143         require(msg.sender == owner);
144         ForeignToken token = ForeignToken(_tokenContract);
145         uint256 amount = token.balanceOf(address(this));
146         return token.transfer(owner, amount);
147     }
148 }