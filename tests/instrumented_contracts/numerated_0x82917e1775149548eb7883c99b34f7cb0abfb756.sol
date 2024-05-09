1 /**
2 PeraBit - Token Distribution Protocol
3 email us at perabitdev@gmail.com
4 
5 */
6 
7 pragma solidity ^0.4.16;
8 
9 
10 contract ForeignToken {
11     function balanceOf(address _owner) public constant returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13 }
14 
15 contract ERC20Basic {
16 
17   uint256 public totalSupply;
18   function balanceOf(address who) public constant returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 
22 }
23 
24 
25 
26 contract ERC20 is ERC20Basic {
27 
28   function allowance(address owner, address spender) public constant returns (uint256);
29   function transferFrom(address from, address to, uint256 value) public returns (bool);
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33 }
34 
35 library SaferMath {
36   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 
63 contract PeraBit is ERC20 {
64     
65     address owner = msg.sender;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     
70     uint256 public totalSupply = 10000000 * 10**8;
71 
72     function name() public constant returns (string) { return "PeraBit"; }
73     function symbol() public constant returns (string) { return "PBIT"; }
74     function decimals() public constant returns (uint8) { return 8; }
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 
79     event DistrFinished();
80 
81     bool public distributionFinished = false;
82 
83     modifier canDistr() {
84     require(!distributionFinished);
85     _;
86     }
87 
88     function PeraBit() public {
89         owner = msg.sender;
90         balances[msg.sender] = totalSupply;
91     }
92 
93     modifier onlyOwner { 
94         require(msg.sender == owner);
95         _;
96     }
97 
98     function transferOwnership(address newOwner) onlyOwner public {
99         owner = newOwner;
100     }
101 
102     function getEthBalance(address _addr) constant public returns(uint) {
103     return _addr.balance;
104     }
105 
106     function distributePBIT(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
107          for (uint i = 0; i < addresses.length; i++) {
108 	     if (getEthBalance(addresses[i]) < _ethbal) {
109  	         continue;
110              }
111              balances[owner] -= _value;
112              balances[addresses[i]] += _value;
113              Transfer(owner, addresses[i], _value);
114          }
115     }
116     
117     function balanceOf(address _owner) constant public returns (uint256) {
118 	 return balances[_owner];
119     }
120 
121     // mitigates the ERC20 short address attack
122     modifier onlyPayloadSize(uint size) {
123         assert(msg.data.length >= size + 4);
124         _;
125     }
126     
127     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
128 
129          if (balances[msg.sender] >= _amount
130              && _amount > 0
131              && balances[_to] + _amount > balances[_to]) {
132              balances[msg.sender] -= _amount;
133              balances[_to] += _amount;
134              Transfer(msg.sender, _to, _amount);
135              return true;
136          } else {
137              return false;
138          }
139     }
140     
141     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
142 
143          if (balances[_from] >= _amount
144              && allowed[_from][msg.sender] >= _amount
145              && _amount > 0
146              && balances[_to] + _amount > balances[_to]) {
147              balances[_from] -= _amount;
148              allowed[_from][msg.sender] -= _amount;
149              balances[_to] += _amount;
150              Transfer(_from, _to, _amount);
151              return true;
152          } else {
153             return false;
154          }
155     }
156     
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         // mitigates the ERC20 spend/approval race condition
159         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
160         
161         allowed[msg.sender][_spender] = _value;
162         
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166     
167     function allowance(address _owner, address _spender) constant public returns (uint256) {
168         return allowed[_owner][_spender];
169     }
170 
171     function finishDistribution() onlyOwner public returns (bool) {
172     distributionFinished = true;
173     DistrFinished();
174     return true;
175     }
176 
177     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
178         require(msg.sender == owner);
179         ForeignToken token = ForeignToken(_tokenContract);
180         uint256 amount = token.balanceOf(address(this));
181         return token.transfer(owner, amount);
182     }
183 
184 
185 }
186 
187 /**
188    
189   PeraBit 2018 All Rights Reserved 
190    
191    
192  */