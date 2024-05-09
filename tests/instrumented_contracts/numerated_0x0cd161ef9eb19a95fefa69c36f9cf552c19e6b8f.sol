1 pragma solidity ^0.4.20;
2 
3 
4 contract AMXToken {
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
31 contract AnimatixToken is ERC20 {
32     
33     address owner = msg.sender;
34 
35     mapping (address => uint256) balances;
36     mapping (address => mapping (address => uint256)) allowed;
37     
38     uint256 public totalSupply = 0.1*10**25;
39 
40     function name() public constant returns (string) { return "ANIMATIX"; }
41     function symbol() public constant returns (string) { return "AMX"; }
42     function decimals() public constant returns (uint8) { return 18; }
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
56     function AnimatixToken() public {
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
70     
71     function distributeToken(address[] addresses, uint256 _value) onlyOwner {
72      for (uint i = 0; i < addresses.length; i++) {
73          balances[owner] -= _value;
74          balances[addresses[i]] += _value;
75          Transfer(owner, addresses[i], _value);
76      }
77 }
78     
79     function balanceOf(address _owner) constant public returns (uint256) {
80 	 return balances[_owner];
81     }
82 
83     // mitigates the ERC20 short address attack
84     modifier onlyPayloadSize(uint size) {
85         assert(msg.data.length >= size + 4);
86         _;
87     }
88     
89     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
90 
91          if (balances[msg.sender] >= _amount
92              && _amount > 0
93              && balances[_to] + _amount > balances[_to]) {
94              balances[msg.sender] -= _amount;
95              balances[_to] += _amount;
96              Transfer(msg.sender, _to, _amount);
97              return true;
98          } else {
99              return false;
100          }
101     }
102     
103     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
104 
105          if (balances[_from] >= _amount
106              && allowed[_from][msg.sender] >= _amount
107              && _amount > 0
108              && balances[_to] + _amount > balances[_to]) {
109              balances[_from] -= _amount;
110              allowed[_from][msg.sender] -= _amount;
111              balances[_to] += _amount;
112              Transfer(_from, _to, _amount);
113              return true;
114          } else {
115             return false;
116          }
117     }
118     
119     function approve(address _spender, uint256 _value) public returns (bool success) {
120         // mitigates the ERC20 spend/approval race condition
121         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
122         
123         allowed[msg.sender][_spender] = _value;
124         
125         Approval(msg.sender, _spender, _value);
126         return true;
127     }
128     
129     function allowance(address _owner, address _spender) constant public returns (uint256) {
130         return allowed[_owner][_spender];
131     }
132 
133     function finishDistribution() onlyOwner public returns (bool) {
134     distributionFinished = true;
135     DistrFinished();
136     return true;
137     }
138 
139     function withdrawGxTokens(address _tokenContract) public returns (bool) {
140         require(msg.sender == owner);
141         AMXToken token = AMXToken(_tokenContract);
142         uint256 amount = token.balanceOf(address(this));
143         return token.transfer(owner, amount);
144     }
145 
146 
147 }