1 pragma solidity ^0.4.19;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract ForeignToken {
29     function balanceOf(address _owner) constant public returns (uint256);
30     function transfer(address _to, uint256 _value) public returns (bool);
31 }
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public constant returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface Token { 
48     function distr(address _to, uint256 _value) public returns (bool);
49     function totalSupply() constant public returns (uint256 supply);
50     function balanceOf(address _owner) constant public returns (uint256 balance);
51 }
52 
53 contract Testtoken is ERC20 {
54     
55     using SafeMath for uint256;
56     address owner = msg.sender;
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61 
62     string public constant name = "Testtoken";
63     string public constant symbol = "TXE";
64     uint public constant decimals = 18;
65     
66     uint256 public totalSupply = 10000000000e8;
67     uint256 public totalDistributed = 1000000000e8;
68     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
69     uint256 public value;
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73     
74     event Distr(address indexed to, uint256 amount);
75     event DistrFinished();
76     
77     event Burn(address indexed burner, uint256 value);
78 
79     bool public distributionFinished = false;
80     
81     modifier canDistr() {
82         require(!distributionFinished);
83         _;
84     }
85     
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90     
91     function Testtoken () public {
92         owner = msg.sender;
93         value = 4000e8;
94         distr(owner, totalDistributed);
95     }
96     
97     function transferOwnership(address newOwner) onlyOwner public {
98         if (newOwner != address(0)) {
99             owner = newOwner;
100         }
101     }
102     
103     function finishDistribution() onlyOwner canDistr public returns (bool) {
104         distributionFinished = true;
105         DistrFinished();
106         return true;
107     }
108     
109     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
110         totalDistributed = totalDistributed.add(_amount);
111         totalRemaining = totalRemaining.sub(_amount);
112         balances[_to] = balances[_to].add(_amount);
113         Distr(_to, _amount);
114         Transfer(address(0), _to, _amount);
115         return true;
116         
117         if (totalDistributed >= totalSupply) {
118             distributionFinished = true;
119         }
120     }
121     
122     function airdrop(address[] addresses) onlyOwner canDistr public {
123         
124         require(addresses.length <= 255);
125         require(value <= totalRemaining);
126         
127         for (uint i = 0; i < addresses.length; i++) {
128             require(value <= totalRemaining);
129             distr(addresses[i], value);
130         }
131 	
132         if (totalDistributed >= totalSupply) {
133             distributionFinished = true;
134         }
135     }
136     
137     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
138         
139         require(addresses.length <= 255);
140         require(amount <= totalRemaining);
141         
142         for (uint i = 0; i < addresses.length; i++) {
143             require(amount <= totalRemaining);
144             distr(addresses[i], amount);
145         }
146 	
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150     }
151     
152     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
153 
154         require(addresses.length <= 255);
155         require(addresses.length == amounts.length);
156         
157         for (uint8 i = 0; i < addresses.length; i++) {
158             require(amounts[i] <= totalRemaining);
159             distr(addresses[i], amounts[i]);
160             
161             if (totalDistributed >= totalSupply) {
162                 distributionFinished = true;
163             }
164         }
165     }
166 
167     function balanceOf(address _owner) constant public returns (uint256) {
168 	    return balances[_owner];
169     }
170 
171     // mitigates the ERC20 short address attack
172     modifier onlyPayloadSize(uint size) {
173         assert(msg.data.length >= size + 4);
174         _;
175     }
176     
177     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
178 
179         require(_to != address(0));
180         require(_amount <= balances[msg.sender]);
181         
182         balances[msg.sender] = balances[msg.sender].sub(_amount);
183         balances[_to] = balances[_to].add(_amount);
184         Transfer(msg.sender, _to, _amount);
185         return true;
186     }
187     
188     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
189 
190         require(_to != address(0));
191         require(_amount <= balances[_from]);
192         require(_amount <= allowed[_from][msg.sender]);
193         
194         balances[_from] = balances[_from].sub(_amount);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
196         balances[_to] = balances[_to].add(_amount);
197         Transfer(_from, _to, _amount);
198         return true;
199     }
200     
201     function approve(address _spender, uint256 _value) public returns (bool success) {
202         // mitigates the ERC20 spend/approval race condition
203         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208     
209     function allowance(address _owner, address _spender) constant public returns (uint256) {
210         return allowed[_owner][_spender];
211     }
212     
213     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
214         ForeignToken t = ForeignToken(tokenAddress);
215         uint bal = t.balanceOf(who);
216         return bal;
217     }
218     
219     function withdraw() onlyOwner public {
220         uint256 etherBalance = this.balance;
221         owner.transfer(etherBalance);
222     }
223     
224     function burn(uint256 _value) onlyOwner public {
225         require(_value <= balances[msg.sender]);
226         // no need to require value <= totalSupply, since that would imply the
227         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
228 
229         address burner = msg.sender;
230         balances[burner] = balances[burner].sub(_value);
231         totalSupply = totalSupply.sub(_value);
232         totalDistributed = totalDistributed.sub(_value);
233         Burn(burner, _value);
234     }
235     
236     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
237         ForeignToken token = ForeignToken(_tokenContract);
238         uint256 amount = token.balanceOf(address(this));
239         return token.transfer(owner, amount);
240     }
241 
242 
243 }