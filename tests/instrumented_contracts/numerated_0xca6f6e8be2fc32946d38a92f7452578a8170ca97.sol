1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
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
53  
54 
55 contract MRC is ERC20 {
56     using SafeMath for uint256;
57     address owner = msg.sender;
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     mapping (address => bool) public blacklist;
61     string public constant name = "MobileRechargez";
62     string public constant symbol = "MRC";
63     uint public constant decimals = 18;
64     uint256 public totalSupply = 900000000e18;
65     uint256 public totalDistributed = 0;
66     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
67     uint256 public value;
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71     event Distr(address indexed to, uint256 amount);
72     event DistrFinished();
73     event Burn(address indexed burner, uint256 value);
74 
75     bool public distributionFinished = false;
76 
77     modifier canDistr() {
78         require(!distributionFinished);
79         _;
80     }
81 
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     modifier onlyWhitelist() {
88         require(blacklist[msg.sender] == false);
89         _;
90     }
91 
92     //May 01, 2018 00:00:00 UTC
93     modifier notPaused {
94     require(now > 1525132800  || msg.sender == owner);
95     _;
96     }
97     function MRC () public {
98         owner = msg.sender;
99         distr(owner, 300000000e18);
100     }
101 
102     function transferOwnership(address newOwner) onlyOwner public {
103         if (newOwner != address(0)) {
104             owner = newOwner;
105         }
106     }
107 
108     function enableWhitelist(address[] addresses) onlyOwner public {
109         for (uint i = 0; i < addresses.length; i++) {
110             blacklist[addresses[i]] = false;
111         }
112     }
113 
114     function disableWhitelist(address[] addresses) onlyOwner public {
115         for (uint i = 0; i < addresses.length; i++) {
116             blacklist[addresses[i]] = true;
117         }
118     }
119 
120     function finishDistribution() onlyOwner canDistr public returns (bool) {
121         distributionFinished = true;
122         DistrFinished();
123         return true;
124     }
125 
126     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127         totalDistributed = totalDistributed.add(_amount);
128         totalRemaining = totalRemaining.sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         Distr(_to, _amount);
131         Transfer(address(0), _to, _amount);
132         return true;
133 
134         if (totalDistributed >= totalSupply) {
135             distributionFinished = true;
136         }
137     }
138 
139     function airdrop(address[] addresses) onlyOwner canDistr public {
140         require(addresses.length <= 255);
141         require(value <= totalRemaining);
142 
143         for (uint i = 0; i < addresses.length; i++) {
144             require(value <= totalRemaining);
145             distr(addresses[i], value);
146         }
147         if (totalDistributed >= totalSupply) {
148             distributionFinished = true;
149         }
150     }
151 
152     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
153         require(addresses.length <= 255);
154         require(amount <= totalRemaining);
155 
156         for (uint i = 0; i < addresses.length; i++) {
157             require(amount <= totalRemaining);
158             distr(addresses[i], amount);
159         }
160 
161         if (totalDistributed >= totalSupply) {
162             distributionFinished = true;
163         }
164     }
165 
166     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
167 
168         require(addresses.length <= 255);
169         require(addresses.length == amounts.length);
170         for (uint8 i = 0; i < addresses.length; i++) {
171             require(amounts[i] <= totalRemaining);
172             distr(addresses[i], amounts[i]);
173             if (totalDistributed >= totalSupply) {
174                 distributionFinished = true;
175             }
176         }
177     }
178 
179     function () external payable {
180             getTokens();
181      }
182 
183     function getTokens() payable canDistr onlyWhitelist public {
184         require(msg.value >= 0.0001 ether);
185         require(msg.value*1000000 <= totalRemaining);
186         distr(msg.sender,  msg.value*1000000);
187         if (totalDistributed >= totalSupply) {
188             distributionFinished = true;
189         }
190     }
191 
192     function balanceOf(address _owner) constant public returns (uint256) {
193                 return balances[_owner];
194     }
195 
196     // mitigates the ERC20 short address attack
197     modifier onlyPayloadSize(uint size) {
198         assert(msg.data.length >= size + 4);
199         _;
200     }
201 
202     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public notPaused  returns (bool success) {
203         require(_to != address(0));
204         require(_amount <= balances[msg.sender]);
205         balances[msg.sender] = balances[msg.sender].sub(_amount);
206         balances[_to] = balances[_to].add(_amount);
207         Transfer(msg.sender, _to, _amount);
208         return true;
209     }
210 
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212         require(_to != address(0));
213         require(_amount <= balances[_from]);
214         require(_amount <= allowed[_from][msg.sender]);
215         balances[_from] = balances[_from].sub(_amount);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         Transfer(_from, _to, _amount);
219         return true;
220     }
221 
222     function approve(address _spender, uint256 _value) public returns (bool success) {
223         // mitigates the ERC20 spend/approval race condition
224         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
225         allowed[msg.sender][_spender] = _value;
226         Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     function allowance(address _owner, address _spender) constant public returns (uint256) {
231         return allowed[_owner][_spender];
232     }
233     
234     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
235         ForeignToken t = ForeignToken(tokenAddress);
236         uint bal = t.balanceOf(who);
237         return bal;
238     }
239 
240     function withdraw() onlyOwner public {
241         uint256 etherBalance = this.balance;
242         owner.transfer(etherBalance);
243     }
244 
245     function burn(uint256 _value) onlyOwner public {
246         require(_value <= balances[msg.sender]);
247         // no need to require value <= totalSupply, since that would imply the
248         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249         address burner = msg.sender;
250         balances[burner] = balances[burner].sub(_value);
251         totalSupply = totalSupply.sub(_value);
252         totalDistributed = totalDistributed.sub(_value);
253         Burn(burner, _value);
254     }
255 
256     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
257         ForeignToken token = ForeignToken(_tokenContract);
258         uint256 amount = token.balanceOf(address(this));
259         return token.transfer(owner, amount);
260     }
261 }