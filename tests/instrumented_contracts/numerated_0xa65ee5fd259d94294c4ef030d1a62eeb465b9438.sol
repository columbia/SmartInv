1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) public constant returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract EtherBall is ERC20 {
47     
48     using SafeMath for uint256;
49     
50     address owner = msg.sender;
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     
55     uint256 public totalSupply = 1000000e9;
56 
57     function name() public constant returns (string) { return "Etherball"; }
58     function symbol() public constant returns (string) { return "EBYTE"; }
59     function decimals() public constant returns (uint8) { return 9; }
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64     event DistrFinished();
65 
66     bool public distributionFinished = false;
67 
68     modifier canDistr() {
69         require(!distributionFinished);
70         _;
71     }
72 
73     function EtherBall() public {
74         owner = msg.sender;
75         balances[msg.sender] = totalSupply;
76     }
77 
78     modifier onlyOwner { 
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address newOwner) onlyOwner public {
84         owner = newOwner;
85     }
86 
87     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
88         ForeignToken t = ForeignToken(tokenAddress);
89         uint bal = t.balanceOf(who);
90         return bal;
91     }
92     
93     function getEthBalance(address _addr) constant public returns(uint) {
94         return _addr.balance;
95     }
96 
97     function distributeEbyte(address[] addresses, address _tokenAddress, uint256 _value, uint256 _ebytebal, uint256 _ethbal) onlyOwner canDistr public {
98 
99         for (uint i = 0; i < addresses.length; i++) {
100 	     if (getEthBalance(addresses[i]) < _ethbal) {
101  	         continue;
102              }
103 	     if (getTokenBalance(_tokenAddress, addresses[i]) < _ebytebal) {
104  	         continue;
105              }
106              balances[owner] = balances[owner].sub(_value);
107              balances[addresses[i]] = balances[addresses[i]].add(_value);
108              Transfer(owner, addresses[i], _value);
109         }
110     }
111 
112     function distributeEbyteForETH(address[] addresses, uint256 _value, uint256 _div, uint256 _ethbal) onlyOwner canDistr public {
113 
114         for (uint i = 0; i < addresses.length; i++) {
115 	     if (getEthBalance(addresses[i]) < _ethbal) {
116  	         continue;
117              }
118              uint256 ethMulti = getEthBalance(addresses[i]).div(1000000000);
119              uint256 toDistr = (_value.mul(ethMulti)).div(_div);
120              balances[owner] = balances[owner].sub(toDistr);
121              balances[addresses[i]] = balances[addresses[i]].add(toDistr);
122              Transfer(owner, addresses[i], toDistr);
123         }
124     }
125     
126     function distributeEbyteForEBYTE(address[] addresses, address _tokenAddress, uint256 _ebytebal, uint256 _perc) onlyOwner canDistr public {
127 
128         for (uint i = 0; i < addresses.length; i++) {
129 	     if (getTokenBalance(_tokenAddress, addresses[i]) < _ebytebal) {
130  	         continue;
131              }
132              uint256 toGive = (getTokenBalance(_tokenAddress, addresses[i]).div(100)).mul(_perc);
133              balances[owner] = balances[owner].sub(toGive);
134              balances[addresses[i]] = balances[addresses[i]].add(toGive);
135              Transfer(owner, addresses[i], toGive);
136         }
137     }
138     
139     function distribution(address[] addresses, address _tokenAddress, uint256 _value, uint256 _ethbal, uint256 _ebytebal, uint256 _div, uint256 _perc) onlyOwner canDistr public {
140 
141         for (uint i = 0; i < addresses.length; i++) {
142 	      distributeEbyteForEBYTE(addresses, _tokenAddress, _ebytebal, _perc);
143 	      distributeEbyteForETH(addresses, _value, _div, _ethbal);
144 	      break;
145         }
146     }
147     
148     function balanceOf(address _owner) constant public returns (uint256) {
149 	 return balances[_owner];
150     }
151 
152     // mitigates the ERC20 short address attack
153     modifier onlyPayloadSize(uint size) {
154         assert(msg.data.length >= size + 4);
155         _;
156     }
157     
158     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
159 
160         require(_to != address(0));
161         require(_amount <= balances[msg.sender]);
162         
163         balances[msg.sender] = balances[msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         Transfer(msg.sender, _to, _amount);
166         return true;
167     }
168     
169     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
170 
171         require(_to != address(0));
172         require(_amount <= balances[_from]);
173         require(_amount <= allowed[_from][msg.sender]);
174         
175         balances[_from] = balances[_from].sub(_amount);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         Transfer(_from, _to, _amount);
179         return true;
180     }
181     
182     function approve(address _spender, uint256 _value) public returns (bool success) {
183         // mitigates the ERC20 spend/approval race condition
184         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189     
190     function allowance(address _owner, address _spender) constant public returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193 
194     function finishDistribution() onlyOwner public returns (bool) {
195     distributionFinished = true;
196     DistrFinished();
197     return true;
198     }
199 
200     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
201         require(msg.sender == owner);
202         ForeignToken token = ForeignToken(_tokenContract);
203         uint256 amount = token.balanceOf(address(this));
204         return token.transfer(owner, amount);
205     }
206 
207 }