1 pragma solidity ^0.4.18;
2 
3     /// Punya usaha atau bisnis dan ingin mengembangkan usaha anda dengan membuat Coin berbasis Ethereum Smartcontract ( erc20 ) ? Silahkan hubungi kami via SMS / WA 082280037283 ///
4 
5     /// Fasilitas yang kami berikan ///
6     /// 1- Token saja ///
7     /// 2- Airdrop saja ///
8     /// 3- Token dan airdrop sekaligus dalam satu contract address ///
9     /// 4- Panduan dan Code Json di sediakan ///
10 
11 /// Kami juga melayani pengelolaan token anda full support untuk anda yang baru terjun di Cryptocurrency, atau anda yang tidak punya waktu banyak untuk mengelola token anda, sehingga anda bisa fokus dengan pengelolaan dan pengembangan usaha anda.///
12 
13 /**
14 * @title SafeMath
15 */
16 library SafeMath {
17 
18 /**
19 * Multiplies two numbers, throws on overflow.
20 */
21 function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22 if (a == 0) {
23 return 0;
24 }
25 c = a * b;
26 assert(c / a == b);
27 return c;
28 }
29 
30 /**
31 * Integer division of two numbers, truncating the quotient.
32 */
33 function div(uint256 a, uint256 b) internal pure returns (uint256) {
34 // assert(b > 0); // Solidity automatically throws when dividing by 0
35 // uint256 c = a / b;
36 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 return a / b;
38 }
39 
40 /**
41 * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42 */
43 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44 assert(b <= a);
45 return a - b;
46 }
47 
48 /**
49 * Adds two numbers, throws on overflow.
50 */
51 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52 c = a + b;
53 assert(c >= a);
54 return c;
55 }
56 }
57 
58 contract AltcoinToken {
59 function balanceOf(address _owner) constant public returns (uint256);
60 function transfer(address _to, uint256 _value) public returns (bool);
61 }
62 
63 contract ERC20Basic {
64 uint256 public totalSupply;
65 function balanceOf(address who) public constant returns (uint256);
66 function transfer(address to, uint256 value) public returns (bool);
67 event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ERC20 is ERC20Basic {
71 function allowance(address owner, address spender) public constant returns (uint256);
72 function XXXXXXXX06(address from, address to, uint256 value) public returns (bool);
73 function approve(address spender, uint256 value) public returns (bool);
74 event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract ShopDexToken is ERC20 {
78 
79 using SafeMath for uint256;
80 address owner = msg.sender;
81 
82 mapping (address => uint256) balances;
83 mapping (address => mapping (address => uint256)) allowed;
84 
85 string public constant name = "Shop Dex";
86 string public constant symbol = "S-D-E-X";
87 uint public constant decimals = 8;
88 
89 uint256 public totalSupply = 18000000000e8;
90 uint256 public totalDistributed = 0;
91 uint256 public tokensPerEth = 20000000e8;
92 uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
93 
94 event Transfer(address indexed _from, address indexed _to, uint256 _value);
95 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97 event Distr(address indexed to, uint256 amount);
98 event DistrFinished();
99 
100 event Airdrop(address indexed _owner, uint _amount, uint _balance);
101 
102 event TokensPerEthUpdated(uint _tokensPerEth);
103 
104 event Burn(address indexed burner, uint256 value);
105 
106 bool public stop = false;
107 
108 modifier canDistr() {
109 require(!stop);
110 _;
111 }
112 
113 modifier onlyOwner() {
114 require(msg.sender == owner);
115 _;
116 }
117 
118 
119 function ShopDexToken () public {
120 owner = msg.sender;
121 uint256 devTokens = 2000000000e8;
122 distr(owner, devTokens);
123 }
124 
125 function XXXXXXXX07(address newOwner) onlyOwner public {
126 if (newOwner != address(0)) {
127 owner = newOwner;
128 }
129 }
130 
131 
132 function XXXXXXXX04() onlyOwner canDistr public returns (bool) {
133 stop = true;
134 emit DistrFinished();
135 return true;
136 stop = false;
137 emit DistrFinished();
138 return false;
139 }
140 function distr(address _to, uint256 _amount) canDistr private returns (bool) {
141 totalDistributed = totalDistributed.add(_amount);
142 balances[_to] = balances[_to].add(_amount);
143 emit Distr(_to, _amount);
144 emit Transfer(address(0), _to, _amount);
145 
146 return true;
147 }
148 
149 function doAirdrop(address _participant, uint _amount) internal {
150 
151 require( _amount > 0 );
152 
153 require( totalDistributed < totalSupply );
154 
155 balances[_participant] = balances[_participant].add(_amount);
156 totalDistributed = totalDistributed.add(_amount);
157 
158 if (totalDistributed >= totalSupply) {
159 stop = true;
160 }
161 
162 // log
163 emit Airdrop(_participant, _amount, balances[_participant]);
164 emit Transfer(address(0), _participant, _amount);
165 }
166 
167 function XXXXXXXX01(address _participant, uint _amount) public onlyOwner {
168 doAirdrop(_participant, _amount);
169 }
170 
171 function XXXXXXXX02(address[] _addresses, uint _amount) public onlyOwner {
172 for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
173 }
174 
175 function XXXXXXXX08(uint _tokensPerEth) public onlyOwner {
176 tokensPerEth = _tokensPerEth;
177 emit TokensPerEthUpdated(_tokensPerEth);
178 }
179 
180 function () external payable {
181 XXXXXXXX05();
182 }
183 
184 function XXXXXXXX05() payable canDistr  public {
185 uint256 tokens = 0;
186 
187 require( msg.value >= minContribution );
188 
189 require( msg.value > 0 );
190 
191 tokens = tokensPerEth.mul(msg.value) / 1 ether;
192 address investor = msg.sender;
193 
194 if (tokens > 0) {
195 distr(investor, tokens);
196 }
197 
198 if (totalDistributed >= totalSupply) {
199 stop = true;
200 }
201 }
202 
203 function balanceOf(address _owner) constant public returns (uint256) {
204 return balances[_owner];
205 }
206 
207 // mitigates the ERC20 short address attack
208 modifier onlyPayloadSize(uint size) {
209 assert(msg.data.length >= size + 4);
210 _;
211 }
212 
213 function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
214 
215 require(_to != address(0));
216 require(_amount <= balances[msg.sender]);
217 
218 balances[msg.sender] = balances[msg.sender].sub(_amount);
219 balances[_to] = balances[_to].add(_amount);
220 emit Transfer(msg.sender, _to, _amount);
221 return true;
222 }
223 
224 function XXXXXXXX06(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
225 
226 require(_to != address(0));
227 require(_amount <= balances[_from]);
228 require(_amount <= allowed[_from][msg.sender]);
229 
230 balances[_from] = balances[_from].sub(_amount);
231 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
232 balances[_to] = balances[_to].add(_amount);
233 emit Transfer(_from, _to, _amount);
234 return true;
235 }
236 
237 function approve(address _spender, uint256 _value) public returns (bool success) {
238 // mitigates the ERC20 spend/approval race condition
239 if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
240 allowed[msg.sender][_spender] = _value;
241 emit Approval(msg.sender, _spender, _value);
242 return true;
243 }
244 
245 function allowance(address _owner, address _spender) constant public returns (uint256) {
246 return allowed[_owner][_spender];
247 }
248 
249 function saltoken(address tokenAddress, address who) constant public returns (uint){
250 AltcoinToken t = AltcoinToken(tokenAddress);
251 uint bal = t.balanceOf(who);
252 return bal;
253 }
254 
255 function XXXXXXXX09() onlyOwner public {
256 address myAddress = this;
257 uint256 etherBalance = myAddress.balance;
258 owner.transfer(etherBalance);
259 }
260 
261 function XXXXXXXX03(uint256 _value) onlyOwner public {
262 require(_value <= balances[msg.sender]);
263 
264 address burner = msg.sender;
265 balances[burner] = balances[burner].sub(_value);
266 totalSupply = totalSupply.sub(_value);
267 totalDistributed = totalDistributed.sub(_value);
268 emit Burn(burner, _value);
269 }
270 
271 function XXXXXXXX10(address _tokenContract) onlyOwner public returns (bool) {
272 AltcoinToken token = AltcoinToken(_tokenContract);
273 uint256 amount = token.balanceOf(address(this));
274 return token.transfer(owner, amount);
275 }
276 }