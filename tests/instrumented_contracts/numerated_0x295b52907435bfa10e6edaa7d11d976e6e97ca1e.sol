1 pragma solidity ^0.4.16;
2 
3 
4 contract ForeignToken {
5     function balanceOf(address _owner) public constant returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
7 }
8 
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
19 
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
30 
31 contract LiteCoinW_Plus is ERC20 {
32     
33     address owner = msg.sender;
34 
35     mapping (address => uint256) balances;
36     mapping (address => mapping (address => uint256)) allowed;
37     
38     uint256 public totalSupply = 84000000 * 10**8;
39 
40     function name() public constant returns (string) { return "LiteCoinW Plus"; }
41     function symbol() public constant returns (string) { return "LCWP"; }
42     function decimals() public constant returns (uint8) { return 8; }
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
56     function LiteCoinW_Plus() public {
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
74     function distributeLCWP(address[] addresses, uint256 _value) onlyOwner canDistr public {
75          for (uint i = 0; i < addresses.length; i++) {
76              balances[owner] -= _value;
77              balances[addresses[i]] += _value;
78              Transfer(owner, addresses[i], _value);
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
99              Transfer(msg.sender, _to, _amount);
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
115              Transfer(_from, _to, _amount);
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
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131     
132     function allowance(address _owner, address _spender) constant public returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function finishDistribution() onlyOwner public returns (bool) {
137     distributionFinished = true;
138     DistrFinished();
139     return true;
140     }
141 
142     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
143         require(msg.sender == owner);
144         ForeignToken token = ForeignToken(_tokenContract);
145         uint256 amount = token.balanceOf(address(this));
146         return token.transfer(owner, amount);
147     }
148 
149 
150 }