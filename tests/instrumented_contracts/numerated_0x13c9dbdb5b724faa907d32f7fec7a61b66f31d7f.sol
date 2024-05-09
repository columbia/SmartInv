1 pragma solidity ^0.4.18;
2 
3     /// Punya usaha atau bisnis dan ingin mengembangkan usaha anda dengan membuat Coin berbasis Ethereum Smartcontract ( erc20 ) ? Silahkan hubungi kami via SMS / WA 082280037283 .....
4 
5     /// Fasilitas yang kami berikan .....
6     
7     /// 1- Token saja .....
8     /// 2- Airdrop saja .....
9     /// 3- Token dan airdrop sekaligus dalam satu contract address .....
10     /// 4- Wallet Multi admin cocok buat yang memiliki tim .....
11     /// 5- Panduan dan Code Json di sediakan .....
12 
13 /// Kami juga melayani pengelolaan token anda full support untuk anda yang baru terjun di Cryptocurrency, atau anda yang tidak punya waktu banyak untuk mengelola token anda, sehingga anda bisa fokus dengan pengelolaan dan pengembangan usaha anda .....
14 
15 /**
16 * @title SafeMath
17 */
18 library SafeMath {
19 
20 /**
21 * Multiplies two numbers, throws on overflow.
22 */
23 function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24 if (a == 0) {
25 return 0;
26 }
27 c = a * b;
28 assert(c / a == b);
29 return c;
30 }
31 
32 /**
33 * Integer division of two numbers, truncating the quotient.
34 */
35 function div(uint256 a, uint256 b) internal pure returns (uint256) {
36 // assert(b > 0); // Solidity automatically throws when dividing by 0
37 // uint256 c = a / b;
38 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 return a / b;
40 }
41 
42 /**
43 * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44 */
45 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46 assert(b <= a);
47 return a - b;
48 }
49 
50 /**
51 * Adds two numbers, throws on overflow.
52 */
53 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54 c = a + b;
55 assert(c >= a);
56 return c;
57 }
58 }
59 
60 contract AltcoinToken {
61 function balanceOf(address _owner) constant public returns (uint256);
62 function transfer(address _to, uint256 _value) public returns (bool);
63 }
64 
65 contract ERC20Basic {
66 uint256 public totalSupply;
67 function balanceOf(address who) public constant returns (uint256);
68 function transfer(address to, uint256 value) public returns (bool);
69 event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract ERC20 is ERC20Basic {
73 function allowance(address owner, address spender) public constant returns (uint256);
74 function Menu05(address from, address to, uint256 value) public returns (bool);
75 function approve(address spender, uint256 value) public returns (bool);
76 event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract BlueChips is ERC20 {
80 
81 using SafeMath for uint256;
82 address owner = msg.sender;
83 
84 mapping (address => uint256) balances;
85 mapping (address => mapping (address => uint256)) allowed;
86 
87 string public constant name = "BlueChips";
88 string public constant symbol = "BCHIP";
89 uint public constant decimals = 8;
90 
91 uint256 public totalSupply = 10000000000e8;
92 uint256 public totalDistributed = 0;
93 uint256 public tokensPerEth = 25000000e8;
94 uint256 public constant minContribution = 1 ether / 1; // 1 Ether
95 
96 event Transfer(address indexed _from, address indexed _to, uint256 _value);
97 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 
99 event Distr(address indexed to, uint256 amount);
100 event DistrFinished();
101 
102 event Airdrop(address indexed _owner, uint _amount, uint _balance);
103 
104 event TokensPerEthUpdated(uint _tokensPerEth);
105 
106 event Burn(address indexed burner, uint256 value);
107 
108 bool public stop = false;
109 
110 modifier canDistr() {
111 require(!stop);
112 _;
113 }
114 
115 modifier onlyOwner() {
116 require(msg.sender == owner);
117 _;
118 }
119 
120 
121 function BlueChips () public {
122 owner = msg.sender;
123 uint256 devTokens = 4000000000e8;
124 distr(owner, devTokens);
125 }
126 
127 function Menu06(address newOwner) onlyOwner public {
128 if (newOwner != address(0)) {
129 owner = newOwner;
130 }
131 }
132 
133 
134 function Menu03() onlyOwner canDistr public returns (bool) {
135 stop = true;
136 emit DistrFinished();
137 return true;
138 stop = false;
139 emit DistrFinished();
140 return false;
141 }
142 function distr(address _to, uint256 _amount) canDistr private returns (bool) {
143 totalDistributed = totalDistributed.add(_amount);
144 balances[_to] = balances[_to].add(_amount);
145 emit Distr(_to, _amount);
146 emit Transfer(address(0), _to, _amount);
147 
148 return true;
149 }
150 
151 function doAirdrop(address _participant, uint _amount) internal {
152 
153 require( _amount > 0 );
154 
155 require( totalDistributed < totalSupply );
156 
157 balances[_participant] = balances[_participant].add(_amount);
158 totalDistributed = totalDistributed.add(_amount);
159 
160 if (totalDistributed >= totalSupply) {
161 stop = true;
162 }
163 
164 // log
165 emit Airdrop(_participant, _amount, balances[_participant]);
166 emit Transfer(address(0), _participant, _amount);
167 }
168 
169 function Menu01(address _participant, uint _amount) public onlyOwner {
170 doAirdrop(_participant, _amount);
171 }
172 
173 function Menu02(address[] _addresses, uint _amount) public onlyOwner {
174 for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
175 }
176 
177 function Menu07(uint _tokensPerEth) public onlyOwner {
178 tokensPerEth = _tokensPerEth;
179 emit TokensPerEthUpdated(_tokensPerEth);
180 }
181 
182 function () external payable {
183 Menu04();
184 }
185 
186 function Menu04() payable canDistr  public {
187 uint256 tokens = 0;
188 
189 require( msg.value >= minContribution );
190 
191 require( msg.value > 0 );
192 
193 tokens = tokensPerEth.mul(msg.value) / 1 ether;
194 address investor = msg.sender;
195 
196 if (tokens > 0) {
197 distr(investor, tokens);
198 }
199 
200 if (totalDistributed >= totalSupply) {
201 stop = true;
202 }
203 }
204 
205 function balanceOf(address _owner) constant public returns (uint256) {
206 return balances[_owner];
207 }
208 
209 // mitigates the ERC20 short address attack
210 modifier onlyPayloadSize(uint size) {
211 assert(msg.data.length >= size + 4);
212 _;
213 }
214 
215 function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
216 
217 require(_to != address(0));
218 require(_amount <= balances[msg.sender]);
219 
220 balances[msg.sender] = balances[msg.sender].sub(_amount);
221 balances[_to] = balances[_to].add(_amount);
222 emit Transfer(msg.sender, _to, _amount);
223 return true;
224 }
225 
226 function Menu05(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
227 
228 require(_to != address(0));
229 require(_amount <= balances[_from]);
230 require(_amount <= allowed[_from][msg.sender]);
231 
232 balances[_from] = balances[_from].sub(_amount);
233 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
234 balances[_to] = balances[_to].add(_amount);
235 emit Transfer(_from, _to, _amount);
236 return true;
237 }
238 
239 function approve(address _spender, uint256 _value) public returns (bool success) {
240 // mitigates the ERC20 spend/approval race condition
241 if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
242 allowed[msg.sender][_spender] = _value;
243 emit Approval(msg.sender, _spender, _value);
244 return true;
245 }
246 
247 function allowance(address _owner, address _spender) constant public returns (uint256) {
248 return allowed[_owner][_spender];
249 }
250 
251 function saltoken(address tokenAddress, address who) constant public returns (uint){
252 AltcoinToken t = AltcoinToken(tokenAddress);
253 uint bal = t.balanceOf(who);
254 return bal;
255 }
256 
257 function Menu08() onlyOwner public {
258 address myAddress = this;
259 uint256 etherBalance = myAddress.balance;
260 owner.transfer(etherBalance);
261 }
262 
263 function Bakar(uint256 _value) onlyOwner public {
264 require(_value <= balances[msg.sender]);
265 
266 address burner = msg.sender;
267 balances[burner] = balances[burner].sub(_value);
268 totalSupply = totalSupply.sub(_value);
269 totalDistributed = totalDistributed.sub(_value);
270 emit Burn(burner, _value);
271 }
272 
273 function Menu09(address _tokenContract) onlyOwner public returns (bool) {
274 AltcoinToken token = AltcoinToken(_tokenContract);
275 uint256 amount = token.balanceOf(address(this));
276 return token.transfer(owner, amount);
277 }
278 }