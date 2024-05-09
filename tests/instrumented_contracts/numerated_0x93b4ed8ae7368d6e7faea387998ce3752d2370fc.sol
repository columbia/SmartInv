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
29 library SaferMath {
30   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 
56 
57 contract NIMBUS is ERC20 {
58     
59     address owner = msg.sender;
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     
64     uint256 public totalSupply = 3500000000 * 10**8;
65 
66     function name() public constant returns (string) { return "NIMBUS"; }
67     function symbol() public constant returns (string) { return "NIM"; }
68     function decimals() public constant returns (uint8) { return 8; }
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 
73     event DistrFinished();
74 
75     bool public distributionFinished = false;
76 
77     modifier canDistr() {
78     require(!distributionFinished);
79     _;
80     }
81 
82     function NIMBUS() public {
83         owner = msg.sender;
84         balances[msg.sender] = totalSupply;
85     }
86 
87     modifier onlyOwner { 
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address newOwner) onlyOwner public {
93         owner = newOwner;
94     }
95 
96     function getEthBalance(address _addr) constant public returns(uint) {
97     return _addr.balance;
98     }
99 
100     function distributeNIM(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
101          for (uint i = 0; i < addresses.length; i++) {
102 	     if (getEthBalance(addresses[i]) < _ethbal) {
103  	         continue;
104              }
105              balances[owner] -= _value;
106              balances[addresses[i]] += _value;
107              Transfer(owner, addresses[i], _value);
108          }
109     }
110     
111     function balanceOf(address _owner) constant public returns (uint256) {
112 	 return balances[_owner];
113     }
114 
115     // mitigates the ERC20 short address attack
116     modifier onlyPayloadSize(uint size) {
117         assert(msg.data.length >= size + 4);
118         _;
119     }
120     
121     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
122 
123          if (balances[msg.sender] >= _amount
124              && _amount > 0
125              && balances[_to] + _amount > balances[_to]) {
126              balances[msg.sender] -= _amount;
127              balances[_to] += _amount;
128              Transfer(msg.sender, _to, _amount);
129              return true;
130          } else {
131              return false;
132          }
133     }
134     
135     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
136 
137          if (balances[_from] >= _amount
138              && allowed[_from][msg.sender] >= _amount
139              && _amount > 0
140              && balances[_to] + _amount > balances[_to]) {
141              balances[_from] -= _amount;
142              allowed[_from][msg.sender] -= _amount;
143              balances[_to] += _amount;
144              Transfer(_from, _to, _amount);
145              return true;
146          } else {
147             return false;
148          }
149     }
150     
151     function approve(address _spender, uint256 _value) public returns (bool success) {
152         // mitigates the ERC20 spend/approval race condition
153         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
154         
155         allowed[msg.sender][_spender] = _value;
156         
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160     
161     function allowance(address _owner, address _spender) constant public returns (uint256) {
162         return allowed[_owner][_spender];
163     }
164 
165     function finishDistribution() onlyOwner public returns (bool) {
166     distributionFinished = true;
167     DistrFinished();
168     return true;
169     }
170 
171     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
172         require(msg.sender == owner);
173         ForeignToken token = ForeignToken(_tokenContract);
174         uint256 amount = token.balanceOf(address(this));
175         return token.transfer(owner, amount);
176     }
177 
178 
179 }