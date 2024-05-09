1 pragma solidity ^0.4.0;
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
17 
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
28 library SaferMath {
29   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 contract ETHOS is ERC20 {
57     
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     
63     uint256 public totalSupply = 2200000000 * 10**8;
64 
65     function name() public constant returns (string) { return "ETHOS"; }
66     function symbol() public constant returns (string) { return "ETHOS"; }
67     function decimals() public constant returns (uint8) { return 8; }
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72     event DistrFinished();
73 
74     bool public distributionFinished = false;
75 
76     modifier canDistr() {
77     require(!distributionFinished);
78     _;
79     }
80 
81     function ETHOS() public {
82         owner = msg.sender;
83         balances[msg.sender] = totalSupply;
84     }
85 
86     modifier onlyOwner { 
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address newOwner) onlyOwner public {
92         owner = newOwner;
93     }
94 
95     function getEthBalance(address _addr) constant public returns(uint) {
96     return _addr.balance;
97     }
98 
99     function distributeETHOS(address[] addresses, uint256 _value) onlyOwner canDistr public {
100          for (uint i = 0; i < addresses.length; i++) {
101              balances[owner] -= _value;
102              balances[addresses[i]] += _value;
103              emit Transfer(owner, addresses[i], _value);
104          }
105     }
106     
107     
108     function balanceOf(address _owner) constant public returns (uint256) {
109 	 return balances[_owner];
110     }
111 
112     // mitigates the ERC20 short address attack
113     modifier onlyPayloadSize(uint size) {
114         assert(msg.data.length >= size + 4);
115         _;
116     }
117     
118     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
119 
120          if (balances[msg.sender] >= _amount
121              && _amount > 0
122              && balances[_to] + _amount > balances[_to]) {
123              balances[msg.sender] -= _amount;
124              balances[_to] += _amount;
125              Transfer(msg.sender, _to, _amount);
126              return true;
127          } else {
128              return false;
129          }
130     }
131     
132     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
133 
134          if (balances[_from] >= _amount
135              && allowed[_from][msg.sender] >= _amount
136              && _amount > 0
137              && balances[_to] + _amount > balances[_to]) {
138              balances[_from] -= _amount;
139              allowed[_from][msg.sender] -= _amount;
140              balances[_to] += _amount;
141              Transfer(_from, _to, _amount);
142              return true;
143          } else {
144             return false;
145          }
146     }
147     
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         // mitigates the ERC20 spend/approval race condition
150         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
151         
152         allowed[msg.sender][_spender] = _value;
153         
154         Approval(msg.sender, _spender, _value);
155         return true;
156     }
157     
158     function allowance(address _owner, address _spender) constant public returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     function finishDistribute() onlyOwner public returns (bool) {
163     distributionFinished = true;
164     DistrFinished();
165     return true;
166     }
167 
168     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
169         require(msg.sender == owner);
170         ForeignToken token = ForeignToken(_tokenContract);
171         uint256 amount = token.balanceOf(address(this));
172         return token.transfer(owner, amount);
173     }
174 
175 
176 }