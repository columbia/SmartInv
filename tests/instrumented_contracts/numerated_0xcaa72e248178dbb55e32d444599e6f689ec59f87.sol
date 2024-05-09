1 //
2 //     NEW CONTRACT
3 //  Crypto Duel Coin 2018 
4 //
5 //       Crypto Duel Coin (CDC) is a cryptocurrency for online game and online casino. Our goal is very simple. It is create and operate an online game website   where the dedicated token is used. We will develop a lot of exciting games such as cards, roulette, chess, board games and original games and build the game website where people around the world can feel free to join.
6 
7 // 
8 //     INFORMATION
9 //  Name: Crypto Duel Coin 
10 //  Symbol: CDC
11 //  Decimal: 18
12 //  Supply: 40,000,000,000
13 // 
14 //
15 //
16 //
17 //
18 //  Website = http://cryptoduelcoin.com/   Twitter = https://twitter.com/CryptoDuelCoin
19 //
20 //
21 //  Telegram = https://t.me/CryptoDuelCoin  Medium = https://medium.com/crypto-duel-coin
22 //
23 //
24 // 
25 // 
26 //
27 // Crypto Duel Coin 
28 
29 
30 pragma solidity ^0.4.18;
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38     /**
39     * @dev Multiplies two numbers, throws on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         if (a == 0) {
43             return 0;
44         }
45         c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two numbers, truncating the quotient.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // assert(b > 0); // Solidity automatically throws when dividing by 0
55         // uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57         return a / b;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     /**
69     * @dev Adds two numbers, throws on overflow.
70     */
71     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
72         c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 contract ForeignToken {
79     function balanceOf(address _owner) constant public returns (uint256);
80     function transfer(address _to, uint256 _value) public returns (bool);
81 }
82 
83 contract ERC20Basic {
84     uint256 public totalSupply;
85     function balanceOf(address who) public constant returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract CryptoDuelCoin is ERC20 {
98     
99     using SafeMath for uint256;
100     address owner = msg.sender;
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;    
104 
105     string public constant name = "Crypto Duel Coin";
106     string public constant symbol = "CDC";
107     uint public constant decimals = 18;
108     
109     uint256 public totalSupply = 40000000000e18;
110     uint256 public totalDistributed = 0;    
111     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.005 Ether
112     uint256 public tokensPerEth = 10000000e18;
113 
114     event Transfer(address indexed _from, address indexed _to, uint256 _value);
115     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116     
117     event Distr(address indexed to, uint256 amount);
118     event DistrFinished();
119 
120     event Airdrop(address indexed _owner, uint _amount, uint _balance);
121 
122     event TokensPerEthUpdated(uint _tokensPerEth);
123     
124     event Burn(address indexed burner, uint256 value);
125 
126     bool public distributionFinished = false;
127     
128     modifier canDistr() {
129         require(!distributionFinished);
130         _;
131     }
132     
133     modifier onlyOwner() {
134         require(msg.sender == owner);
135         _;
136     }
137     
138     
139     function CryptoDuelCoin () public {
140         owner = msg.sender;    
141         distr(owner, totalDistributed);
142     }
143     
144     function transferOwnership(address newOwner) onlyOwner public {
145         if (newOwner != address(0)) {
146             owner = newOwner;
147         }
148     }
149     
150 
151     function finishDistribution() onlyOwner canDistr public returns (bool) {
152         distributionFinished = true;
153         emit DistrFinished();
154         return true;
155     }
156     
157     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
158         totalDistributed = totalDistributed.add(_amount);        
159         balances[_to] = balances[_to].add(_amount);
160         emit Distr(_to, _amount);
161         emit Transfer(address(0), _to, _amount);
162 
163         return true;
164     }
165 
166     function doAirdrop(address _participant, uint _amount) internal {
167 
168         require( _amount > 0 );      
169 
170         require( totalDistributed < totalSupply );
171         
172         balances[_participant] = balances[_participant].add(_amount);
173         totalDistributed = totalDistributed.add(_amount);
174 
175         if (totalDistributed >= totalSupply) {
176             distributionFinished = true;
177         }
178 
179         // log
180         emit Airdrop(_participant, _amount, balances[_participant]);
181         emit Transfer(address(0), _participant, _amount);
182     }
183 
184     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
185         doAirdrop(_participant, _amount);
186     }
187 
188     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
189         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
190     }
191 
192     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
193         tokensPerEth = _tokensPerEth;
194         emit TokensPerEthUpdated(_tokensPerEth);
195     }
196            
197     function () external payable {
198         getTokens();
199      }
200     
201     function getTokens() payable canDistr  public {
202         uint256 tokens = 0;
203 
204         // minimum contribution
205         require( msg.value >= MIN_CONTRIBUTION );
206 
207         require( msg.value > 0 );
208 
209         // get baseline number of tokens
210         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
211         address investor = msg.sender;
212         
213         if (tokens > 0) {
214             distr(investor, tokens);
215         }
216 
217         if (totalDistributed >= totalSupply) {
218             distributionFinished = true;
219         }
220     }
221 
222     function balanceOf(address _owner) constant public returns (uint256) {
223         return balances[_owner];
224     }
225 
226     // mitigates the ERC20 short address attack
227     modifier onlyPayloadSize(uint size) {
228         assert(msg.data.length >= size + 4);
229         _;
230     }
231     
232     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
233 
234         require(_to != address(0));
235         require(_amount <= balances[msg.sender]);
236         
237         balances[msg.sender] = balances[msg.sender].sub(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         emit Transfer(msg.sender, _to, _amount);
240         return true;
241     }
242     
243     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
244 
245         require(_to != address(0));
246         require(_amount <= balances[_from]);
247         require(_amount <= allowed[_from][msg.sender]);
248         
249         balances[_from] = balances[_from].sub(_amount);
250         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
251         balances[_to] = balances[_to].add(_amount);
252         emit Transfer(_from, _to, _amount);
253         return true;
254     }
255     
256     function approve(address _spender, uint256 _value) public returns (bool success) {
257         // mitigates the ERC20 spend/approval race condition
258         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263     
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267     
268     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
269         ForeignToken t = ForeignToken(tokenAddress);
270         uint bal = t.balanceOf(who);
271         return bal;
272     }
273     
274     function withdraw() onlyOwner public {
275         address myAddress = this;
276         uint256 etherBalance = myAddress.balance;
277         owner.transfer(etherBalance);
278     }
279     
280     function burn(uint256 _value) onlyOwner public {
281         require(_value <= balances[msg.sender]);
282         // no need to require value <= totalSupply, since that would imply the
283         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
284 
285         address burner = msg.sender;
286         balances[burner] = balances[burner].sub(_value);
287         totalSupply = totalSupply.sub(_value);
288         totalDistributed = totalDistributed.sub(_value);
289         emit Burn(burner, _value);
290     }
291     
292     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
293         ForeignToken token = ForeignToken(_tokenContract);
294         uint256 amount = token.balanceOf(address(this));
295         return token.transfer(owner, amount);
296     }
297 }