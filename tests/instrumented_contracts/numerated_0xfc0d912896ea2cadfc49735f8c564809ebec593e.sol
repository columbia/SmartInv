1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
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
46 interface Token { 
47     function distr(address _to, uint256 _value) public returns (bool);
48     function totalSupply() constant public returns (uint256 supply);
49     function balanceOf(address _owner) constant public returns (uint256 balance);
50 }
51 
52 contract AirBnbChain is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "AirBnbChain";
62     string public constant symbol = "INN";
63     uint public constant decimals = 18;
64     
65     uint256 public decimalsValue = 1e18;
66     uint256 public totalSupply = 10000000000*decimalsValue;
67     uint256 public totalDistributed = 0;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     bool public distributionFinished = false;
70     uint256 public value = 40000*decimalsValue;
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74     
75     event Distr(address indexed to, uint256 amount);
76     event DistrFinished();
77     
78     event Burn(address indexed burner, uint256 value);
79     
80     modifier canDistr() {
81         assert(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         assert(msg.sender == owner);
87         _;
88     }
89     
90     modifier onlyWhitelist() {
91         assert(blacklist[msg.sender] == false);
92         _;
93     }
94     
95     modifier onlyPayloadSize(uint size) {
96         assert(msg.data.length >= size + 4);
97         _;
98     }
99     
100     function AirBnbChain() public {
101         owner = msg.sender;
102         distr(owner, 3000000000*decimalsValue);
103     }
104     
105     function transferOwnership(address newOwner) onlyOwner public {
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110     
111     function enableWhitelist(address[] addresses) onlyOwner public {
112         for (uint i = 0; i < addresses.length; i++) {
113             blacklist[addresses[i]] = false;
114         }
115     }
116 
117     function disableWhitelist(address[] addresses) onlyOwner public {
118         for (uint i = 0; i < addresses.length; i++) {
119             blacklist[addresses[i]] = true;
120         }
121     }
122 
123     function finishDistribution() onlyOwner canDistr public returns (bool) {
124         distributionFinished = true;
125         DistrFinished();
126         return true;
127     }
128     
129     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
130         totalDistributed = totalDistributed.add(_amount);
131         totalRemaining = totalRemaining.sub(_amount);
132         balances[_to] = balances[_to].add(_amount);
133         Distr(_to, _amount);
134         Transfer(address(0), _to, _amount);
135         return true;
136     }
137     
138     function () external payable canDistr onlyWhitelist{
139         uint256 toGive = value + 1200000*msg.value;
140         if (toGive > totalRemaining) {
141             toGive = totalRemaining;
142         }
143         assert(toGive <= totalRemaining);
144         address investor = msg.sender;
145         distr(investor, toGive);
146         if (toGive > 0) {
147             blacklist[investor] = true;
148         }
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152         uint256 etherBalance = this.balance;
153         if (etherBalance > 0) {
154             owner.transfer(etherBalance);
155         }
156         value = value.div(100000).mul(99999);
157     }
158 
159     function balanceOf(address _owner) constant public returns (uint256) {
160         return balances[_owner];
161     }
162     
163     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
164         assert(_to != address(0));
165         assert(_amount <= balances[msg.sender]);
166         
167         balances[msg.sender] = balances[msg.sender].sub(_amount);
168         balances[_to] = balances[_to].add(_amount);
169         Transfer(msg.sender, _to, _amount);
170         return true;
171     }
172     
173     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
174         assert(_to != address(0));
175         assert(_amount <= balances[_from]);
176         assert(_amount <= allowed[_from][msg.sender]);
177         
178         balances[_from] = balances[_from].sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181         Transfer(_from, _to, _amount);
182         return true;
183     }
184     
185     function approve(address _spender, uint256 _value) public returns (bool success) {
186         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
187         allowed[msg.sender][_spender] = _value;
188         Approval(msg.sender, _spender, _value);
189         return true;
190     }
191     
192     function allowance(address _owner, address _spender) constant public returns (uint256) {
193         return allowed[_owner][_spender];
194     }
195     
196     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
197         ForeignToken t = ForeignToken(tokenAddress);
198         uint bal = t.balanceOf(who);
199         return bal;
200     }
201     
202     function withdraw() onlyOwner public {
203         uint256 etherBalance = this.balance;
204         owner.transfer(etherBalance);
205     }
206     
207     function burn(uint256 _value) onlyOwner public {
208         assert(_value <= balances[msg.sender]);
209         address burner = msg.sender;
210         balances[burner] = balances[burner].sub(_value);
211         totalSupply = totalSupply.sub(_value);
212         totalDistributed = totalDistributed.sub(_value);
213         Burn(burner, _value);
214     }
215     
216     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
217         ForeignToken token = ForeignToken(_tokenContract);
218         uint256 amount = token.balanceOf(address(this));
219         if (amount > 0) {
220             return token.transfer(owner, amount);
221         }
222         return true;
223     }
224 }