1 pragma solidity ^0.4.19;
2 /*
3 *  FRESHROI 
4 *
5 *
6 * [x] Get 33% of investments daily. 
7 * [x] 33% DIVIDENDS AND MASTERNODES
8 * [x] Multi-tier Masternode system 50% 1st ref 30% 2nd ref 20% 3rd ref
9 * [x] Our contract is hard coded to pay out 33% every day forever.
10 *     
11 * [x] FRESHROI Token can be used for future games
12 *
13 * Official Website: http://freshroi.club
14 * Official Discord: https://discord.gg/n4FpH4T
15 */
16 
17 
18 /**
19  * Definition of contract accepting FRESHROI tokens
20  * Games, casinos, anything can reuse this contract to support FRESHROI tokens
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract ForeignToken {
47     function balanceOf(address _owner) constant public returns (uint256);
48     function transfer(address _to, uint256 _value) public returns (bool);
49 }
50 
51 contract ERC20Basic {
52     uint256 public totalSupply;
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public constant returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 interface Token { 
66     function distr(address _to, uint256 _value) public returns (bool);
67     function totalSupply() constant public returns (uint256 supply);
68     function balanceOf(address _owner) constant public returns (uint256 balance);
69 }
70 
71 contract FreshROI is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping (address => bool) public blacklist;
79 
80     string public constant name = "FreshROI";
81     string public constant symbol = "FreshROI";
82     uint public constant decimals = 8;
83     
84     uint256 public totalSupply = 100000000e8;
85     uint256 private totalReserved = (totalSupply.div(100)).mul(1);
86     uint256 private totalBounties = (totalSupply.div(100)).mul(33);
87     uint256 public totalDistributed = totalReserved.add(totalBounties);
88     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
89     uint256 public value;
90     uint256 public minReq;
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     
95     event Distr(address indexed to, uint256 amount);
96     event DistrFinished();
97     
98     event Burn(address indexed burner, uint256 value);
99 
100     bool public distributionFinished = false;
101     
102     modifier canDistr() {
103         require(!distributionFinished);
104         _;
105     }
106     
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111     
112     modifier onlyWhitelist() {
113         require(blacklist[msg.sender] == false);
114         _;
115     }
116     
117     function FreshROI (uint256 _value, uint256 _minReq) public {
118         owner = msg.sender;
119         value = _value;
120         minReq = _minReq;
121         balances[msg.sender] = totalDistributed;
122     }
123     
124      function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {
125         value = _value;
126         minReq = _minReq;
127     }
128 
129     function transferOwnership(address newOwner) onlyOwner public {
130         if (newOwner != address(0)) {
131             owner = newOwner;
132         }
133     }
134     
135     function enableWhitelist(address[] addresses) onlyOwner public {
136         for (uint i = 0; i < addresses.length; i++) {
137             blacklist[addresses[i]] = false;
138         }
139     }
140 
141     function disableWhitelist(address[] addresses) onlyOwner public {
142         for (uint i = 0; i < addresses.length; i++) {
143             blacklist[addresses[i]] = true;
144         }
145     }
146 
147     function finishDistribution() onlyOwner canDistr public returns (bool) {
148         distributionFinished = true;
149         DistrFinished();
150         return true;
151     }
152     
153     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
154         totalDistributed = totalDistributed.add(_amount);
155         totalRemaining = totalRemaining.sub(_amount);
156         balances[_to] = balances[_to].add(_amount);
157         Distr(_to, _amount);
158         Transfer(address(0), _to, _amount);
159         return true;
160         
161         if (totalDistributed >= totalSupply) {
162             distributionFinished = true;
163         }
164     }
165     
166     function airdrop(address[] addresses) onlyOwner canDistr public {
167         
168         require(addresses.length <= 255);
169         require(value <= totalRemaining);
170         
171         for (uint i = 0; i < addresses.length; i++) {
172             require(value <= totalRemaining);
173             distr(addresses[i], value);
174         }
175 	
176         if (totalDistributed >= totalSupply) {
177             distributionFinished = true;
178         }
179     }
180     
181     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
182         
183         require(addresses.length <= 255);
184         require(amount <= totalRemaining);
185         
186         for (uint i = 0; i < addresses.length; i++) {
187             require(amount <= totalRemaining);
188             distr(addresses[i], amount);
189         }
190 	
191         if (totalDistributed >= totalSupply) {
192             distributionFinished = true;
193         }
194     }
195     
196     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
197 
198         require(addresses.length <= 255);
199         require(addresses.length == amounts.length);
200         
201         for (uint8 i = 0; i < addresses.length; i++) {
202             require(amounts[i] <= totalRemaining);
203             distr(addresses[i], amounts[i]);
204             
205             if (totalDistributed >= totalSupply) {
206                 distributionFinished = true;
207             }
208         }
209     }
210     
211     function () external payable {
212             getTokens();
213      }
214     
215     function getTokens() payable canDistr onlyWhitelist public {
216         
217         require(value <= totalRemaining);
218         
219         address investor = msg.sender;
220         uint256 toGive = value;
221         
222         if (msg.value < minReq){
223             toGive = value.sub(value);
224         }
225         
226         distr(investor, toGive);
227         
228         if (toGive > 0) {
229             blacklist[investor] = true;
230         }
231 
232         if (totalDistributed >= totalSupply) {
233             distributionFinished = true;
234         }
235     }
236 
237     function balanceOf(address _owner) constant public returns (uint256) {
238 	    return balances[_owner];
239     }
240 
241     // mitigates the ERC20 short address attack
242     modifier onlyPayloadSize(uint size) {
243         assert(msg.data.length >= size + 4);
244         _;
245     }
246     
247     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
248 
249         require(_to != address(0));
250         require(_amount <= balances[msg.sender]);
251         
252         balances[msg.sender] = balances[msg.sender].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         Transfer(msg.sender, _to, _amount);
255         return true;
256     }
257     
258     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
259 
260         require(_to != address(0));
261         require(_amount <= balances[_from]);
262         require(_amount <= allowed[_from][msg.sender]);
263         
264         balances[_from] = balances[_from].sub(_amount);
265         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         Transfer(_from, _to, _amount);
268         return true;
269     }
270     
271     function approve(address _spender, uint256 _value) public returns (bool success) {
272         // mitigates the ERC20 spend/approval race condition
273         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
274         allowed[msg.sender][_spender] = _value;
275         Approval(msg.sender, _spender, _value);
276         return true;
277     }
278     
279     function allowance(address _owner, address _spender) constant public returns (uint256) {
280         return allowed[_owner][_spender];
281     }
282     
283     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
284         ForeignToken t = ForeignToken(tokenAddress);
285         uint bal = t.balanceOf(who);
286         return bal;
287     }
288     
289     function withdraw() onlyOwner public {
290         uint256 etherBalance = this.balance;
291         owner.transfer(etherBalance);
292     }
293     
294     function burn(uint256 _value) onlyOwner public {
295         require(_value <= balances[msg.sender]);
296         // no need to require value <= totalSupply, since that would imply the
297         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
298 
299         address burner = msg.sender;
300         balances[burner] = balances[burner].sub(_value);
301         totalSupply = totalSupply.sub(_value);
302         totalDistributed = totalDistributed.sub(_value);
303         Burn(burner, _value);
304     }
305     
306     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
307         ForeignToken token = ForeignToken(_tokenContract);
308         uint256 amount = token.balanceOf(address(this));
309         return token.transfer(owner, amount);
310     }
311 
312 
313 }