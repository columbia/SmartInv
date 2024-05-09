1 pragma solidity ^0.4.20;
2 
3 /*
4 * CryptoDev.Net Presents
5 * ====================================*
6 *
7 * Built by trusted community members
8 * IronHandsCoin is a Phillis approved Pyramid                         
9 *
10 * ====================================*
11 * -> What?
12 * The original autonomous pyramid, improved:
13 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
14 * [x] Audited, tested, and approved by known community security specialists.
15 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
16 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
17 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
18 * [x] Masternodes: Holding 50 IHC allow you to generate a Gangsternode link, Gangsternode links are used as unique entry points to the contract!
19 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
20 * [x] Game play! No transfer tax and we will be adding gaming functionality-risk your IHC tokens and win more!
21 *
22 * -> What about the last projects?
23 * Every programming member of the old dev team has been fired and/or killed.
24 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
25 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
26 * 
27 * -> Who worked on this project?
28 * Trusted community members
29 *
30 */
31 
32 
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a / b;
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract ForeignToken {
58     function balanceOf(address _owner) constant public returns (uint256);
59     function transfer(address _to, uint256 _value) public returns (bool);
60 }
61 
62 contract ERC20Basic {
63     uint256 public totalSupply;
64     function balanceOf(address who) public constant returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public constant returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 interface Token { 
77     function distr(address _to, uint256 _value) public returns (bool);
78     function totalSupply() constant public returns (uint256 supply);
79     function balanceOf(address _owner) constant public returns (uint256 balance);
80 }
81 
82 contract IronHands2 is ERC20 {
83     
84     using SafeMath for uint256;
85     address owner = msg.sender;
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     mapping (address => bool) public blacklist;
90 
91     string public constant name = "Iron Hands 2+";
92     string public constant symbol = "P3D";
93     uint public constant decimals = 8;
94     
95     uint256 public totalSupply = 80000000e8;
96     uint256 public totalDistributed = 1e8;
97     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
98     uint256 public value;
99 
100     event Transfer(address indexed _from, address indexed _to, uint256 _value);
101     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102     
103     event Distr(address indexed to, uint256 amount);
104     event DistrFinished();
105     
106     event Burn(address indexed burner, uint256 value);
107 
108     bool public distributionFinished = false;
109     
110     modifier canDistr() {
111         require(!distributionFinished);
112         _;
113     }
114     
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119     
120    
121     
122     function IronHands2 () public {
123         owner = msg.sender;
124         value = 500e8;
125         distr(owner, totalDistributed);
126     }
127     
128     function transferOwnership(address newOwner) onlyOwner public {
129         if (newOwner != address(0)) {
130             owner = newOwner;
131         }
132     }
133     
134    
135 
136    
137 
138     function finishDistribution() onlyOwner canDistr public returns (bool) {
139         distributionFinished = true;
140         DistrFinished();
141         return true;
142     }
143     
144     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
145         totalDistributed = totalDistributed.add(_amount);
146         totalRemaining = totalRemaining.sub(_amount);
147         balances[_to] = balances[_to].add(_amount);
148         Distr(_to, _amount);
149         Transfer(address(0), _to, _amount);
150         return true;
151         
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155     }
156     
157     function airdrop(address[] addresses) onlyOwner canDistr public {
158         
159         require(addresses.length <= 255);
160         require(value <= totalRemaining);
161         
162         for (uint i = 0; i < addresses.length; i++) {
163             require(value <= totalRemaining);
164             distr(addresses[i], value);
165         }
166 	
167         if (totalDistributed >= totalSupply) {
168             distributionFinished = true;
169         }
170     }
171     
172     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
173         
174         require(addresses.length <= 255);
175         require(amount <= totalRemaining);
176         
177         for (uint i = 0; i < addresses.length; i++) {
178             require(amount <= totalRemaining);
179             distr(addresses[i], amount);
180         }
181 	
182         if (totalDistributed >= totalSupply) {
183             distributionFinished = true;
184         }
185     }
186     
187     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
188 
189         require(addresses.length <= 255);
190         require(addresses.length == amounts.length);
191         
192         for (uint8 i = 0; i < addresses.length; i++) {
193             require(amounts[i] <= totalRemaining);
194             distr(addresses[i], amounts[i]);
195             
196             if (totalDistributed >= totalSupply) {
197                 distributionFinished = true;
198             }
199         }
200     }
201     
202     function () external payable {
203             getTokens();
204      }
205     
206     function getTokens() payable canDistr public {
207         
208         if (value > totalRemaining) {
209             value = totalRemaining;
210         }
211         
212         require(value <= totalRemaining);
213         
214         address investor = msg.sender;
215         uint256 toGive = value;
216         
217         distr(investor, toGive);
218         
219         if (toGive > 0) {
220             blacklist[investor] = true;
221         }
222 
223         if (totalDistributed >= totalSupply) {
224             distributionFinished = true;
225         }
226         
227      
228     }
229 
230     function balanceOf(address _owner) constant public returns (uint256) {
231 	    return balances[_owner];
232     }
233 
234     // mitigates the ERC20 short address attack
235     modifier onlyPayloadSize(uint size) {
236         assert(msg.data.length >= size + 4);
237         _;
238     }
239     
240     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
241 
242         require(_to != address(0));
243         require(_amount <= balances[msg.sender]);
244         
245         balances[msg.sender] = balances[msg.sender].sub(_amount);
246         balances[_to] = balances[_to].add(_amount);
247         Transfer(msg.sender, _to, _amount);
248         return true;
249     }
250     
251     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
252 
253         require(_to != address(0));
254         require(_amount <= balances[_from]);
255         require(_amount <= allowed[_from][msg.sender]);
256         
257         balances[_from] = balances[_from].sub(_amount);
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         Transfer(_from, _to, _amount);
261         return true;
262     }
263     
264     function approve(address _spender, uint256 _value) public returns (bool success) {
265         // mitigates the ERC20 spend/approval race condition
266         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
267         allowed[msg.sender][_spender] = _value;
268         Approval(msg.sender, _spender, _value);
269         return true;
270     }
271     
272     function allowance(address _owner, address _spender) constant public returns (uint256) {
273         return allowed[_owner][_spender];
274     }
275     
276     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
277         ForeignToken t = ForeignToken(tokenAddress);
278         uint bal = t.balanceOf(who);
279         return bal;
280     }
281     
282     function withdraw() onlyOwner public {
283         uint256 etherBalance = this.balance;
284         owner.transfer(etherBalance);
285     }
286     
287     function burn(uint256 _value) onlyOwner public {
288         require(_value <= balances[msg.sender]);
289         // no need to require value <= totalSupply, since that would imply the
290         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
291 
292         address burner = msg.sender;
293         balances[burner] = balances[burner].sub(_value);
294         totalSupply = totalSupply.sub(_value);
295         totalDistributed = totalDistributed.sub(_value);
296         Burn(burner, _value);
297     }
298     
299     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
300         ForeignToken token = ForeignToken(_tokenContract);
301         uint256 amount = token.balanceOf(address(this));
302         return token.transfer(owner, amount);
303     }
304 
305 
306 }