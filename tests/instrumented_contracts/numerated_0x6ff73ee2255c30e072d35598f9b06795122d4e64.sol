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
52 contract DigitalEnthusiasts is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     mapping (address => bool) public blacklist;
60 
61     string public constant name = "DigitalEnthusiasts";
62     string public constant symbol = "GDE";
63     uint public constant decimals = 18;
64     
65     uint256 public decimalsValue = 1e18;
66     uint256 public totalSupply = 1000000000*decimalsValue;
67     uint256 public totalDistributed = 0;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     bool public distributionFinished = false;
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73     
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76     
77     event Burn(address indexed burner, uint256 value);
78     
79     modifier canDistr() {
80         assert(!distributionFinished);
81         _;
82     }
83     
84     modifier onlyOwner() {
85         assert(msg.sender == owner);
86         _;
87     }
88     
89     modifier onlyWhitelist() {
90         assert(blacklist[msg.sender] == false);
91         _;
92     }
93     
94     modifier onlyPayloadSize(uint size) {
95         assert(msg.data.length >= size + 4);
96         _;
97     }
98     
99     function DigitalEnthusiasts() public {
100         owner = msg.sender;
101         distr(owner, 300000000*decimalsValue);
102     }
103     
104     function transferOwnership(address newOwner) onlyOwner public {
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109     
110     function enableWhitelist(address[] addresses) onlyOwner public {
111         for (uint i = 0; i < addresses.length; i++) {
112             blacklist[addresses[i]] = false;
113         }
114     }
115 
116     function disableWhitelist(address[] addresses) onlyOwner public {
117         for (uint i = 0; i < addresses.length; i++) {
118             blacklist[addresses[i]] = true;
119         }
120     }
121 
122     function finishDistribution() onlyOwner canDistr public returns (bool) {
123         distributionFinished = true;
124         DistrFinished();
125         return true;
126     }
127     
128     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
129         totalDistributed = totalDistributed.add(_amount);
130         totalRemaining = totalRemaining.sub(_amount);
131         balances[_to] = balances[_to].add(_amount);
132         Distr(_to, _amount);
133         Transfer(address(0), _to, _amount);
134         return true;
135     }
136     
137     function () external payable canDistr onlyWhitelist{
138         uint256 toGive = 2000*decimalsValue + 120000*msg.value;
139         if (toGive > totalRemaining) {
140             toGive = totalRemaining;
141         }
142         assert(toGive <= totalRemaining);
143         address investor = msg.sender;
144         distr(investor, toGive);
145         if (toGive > 0) {
146             blacklist[investor] = true;
147         }
148         if (totalDistributed >= totalSupply) {
149             distributionFinished = true;
150         }
151         uint256 etherBalance = this.balance;
152         if (etherBalance > 0) {
153             owner.transfer(etherBalance);
154         }
155     }
156 
157     function balanceOf(address _owner) constant public returns (uint256) {
158         return balances[_owner];
159     }
160     
161     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
162         assert(_to != address(0));
163         assert(_amount <= balances[msg.sender]);
164         
165         balances[msg.sender] = balances[msg.sender].sub(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         Transfer(msg.sender, _to, _amount);
168         return true;
169     }
170     
171     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
172         assert(_to != address(0));
173         assert(_amount <= balances[_from]);
174         assert(_amount <= allowed[_from][msg.sender]);
175         
176         balances[_from] = balances[_from].sub(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179         Transfer(_from, _to, _amount);
180         return true;
181     }
182     
183     function approve(address _spender, uint256 _value) public returns (bool success) {
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
194     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
195         ForeignToken t = ForeignToken(tokenAddress);
196         uint bal = t.balanceOf(who);
197         return bal;
198     }
199     
200     function withdraw() onlyOwner public {
201         uint256 etherBalance = this.balance;
202         owner.transfer(etherBalance);
203     }
204     
205     function burn(uint256 _value) onlyOwner public {
206         assert(_value <= balances[msg.sender]);
207         address burner = msg.sender;
208         balances[burner] = balances[burner].sub(_value);
209         totalSupply = totalSupply.sub(_value);
210         totalDistributed = totalDistributed.sub(_value);
211         Burn(burner, _value);
212     }
213     
214     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
215         ForeignToken token = ForeignToken(_tokenContract);
216         uint256 amount = token.balanceOf(address(this));
217         if (amount > 0) {
218             return token.transfer(owner, amount);
219         }
220         return true;
221     }
222 }