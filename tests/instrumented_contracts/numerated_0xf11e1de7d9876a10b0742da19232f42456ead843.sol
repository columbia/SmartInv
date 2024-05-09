1 pragma solidity ^0.4.25;
2 // -----------------------------------------
3 //==========================================
4 // =      Name : DXEA Coin                 =
5 // =      Symbol : DXEA                    =
6 // =      Total Supply : 15,000,000,000    =
7 // =      Decimals : 8                     =
8 // =      (c) by DXEA Developers Team      =
9 // =========================================
10 library SafeMath {
11  /**
12  * @dev Multiplies two numbers, throws on overflow.
13  */
14  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15  if (a == 0) {
16  return 0;
17  }
18  c = a * b;
19  assert(c / a == b);
20  return c;
21  }
22  /**
23  * @dev Integer division of two numbers, truncating the quotient.
24  */
25  function div(uint256 a, uint256 b) internal pure returns (uint256) {
26  // assert(b > 0); // Solidity automatically throws when dividing by 0
27  // uint256 c = a / b;
28  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29  return a / b;
30  }
31  /**
32  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33  */
34  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35  assert(b <= a);
36  return a - b;
37  }
38 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39  c = a + b;
40  assert(c >= a);
41  return c;
42  }
43 }
44 contract ForeignToken {
45  function balanceOf(address _owner) constant public returns (uint256);
46  function transfer(address _to, uint256 _value) public returns (bool);
47 }
48 contract ERC20Basic {
49  uint256 public totalSupply;
50  function balanceOf(address who) public constant returns (uint256);
51  function transfer(address to, uint256 value) public returns (bool);
52  event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 contract ERC20 is ERC20Basic {
55  function allowance(address owner, address spender) public constant returns (uint256);
56  function transferFrom(address from, address to, uint256 value) public returns (bool);
57  function approve(address spender, uint256 value) public returns (bool);
58  event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 contract DXEACoin is ERC20 {
61  
62  using SafeMath for uint256;
63  address owner = msg.sender;
64  mapping (address => uint256) balances;
65  mapping (address => mapping (address => uint256)) allowed;
66  mapping (address => bool) public Claimed; 
67  string public constant name = "DXEA Coin";
68  string public constant symbol = "DXEA";
69  uint public constant decimals = 8;
70  uint public deadline = now + 13 * 1 days;
71  uint public round2 = now + 8 * 1 days;
72  uint public round1 = now + 19 * 1 days;
73  
74  uint256 public totalSupply = 15000000000e8;
75  uint256 public totalDistributed;
76  uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
77  uint256 public tokensPerEth = 15500000e8;
78 
79 uint public target0drop = 30000;
80  uint public progress0drop = 0;
81  
82  ///
83  address multisig = 0x24aD8dC3119672F5a50C2ed25Fd4708FEe589281; 
84  event Transfer(address indexed _from, address indexed _to, uint256 _value);
85  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86  
87  event Distr(address indexed to, uint256 amount);
88  event DistrFinished();
89  
90  event Airdrop(address indexed _owner, uint _amount, uint _balance);
91  event TokensPerEthUpdated(uint _tokensPerEth);
92  
93  event Burn(address indexed burner, uint256 value);
94  
95  event Add(uint256 value);
96  bool public distributionFinished = false;
97  
98  modifier canDistr() {
99  require(!distributionFinished);
100  _;
101  }
102  
103  modifier onlyOwner() {
104  require(msg.sender == owner);
105  _;
106  }
107  
108  constructor() public {
109  uint256 teamFund = 10000000e8;
110  owner = msg.sender;
111  distr(owner, teamFund);
112  }
113  
114  function transferOwnership(address newOwner) onlyOwner public {
115  if (newOwner != address(0)) {
116  owner = newOwner;
117  }
118  }
119  function finishDistribution() onlyOwner canDistr public returns (bool) {
120  distributionFinished = true;
121  emit DistrFinished();
122 
123 return true;
124  }
125  
126  function distr(address _to, uint256 _amount) canDistr private returns (bool) {
127  totalDistributed = totalDistributed.add(_amount); 
128  balances[_to] = balances[_to].add(_amount);
129  emit Distr(_to, _amount);
130  emit Transfer(address(0), _to, _amount);
131  return true;
132  }
133  
134  function Distribute(address _participant, uint _amount) onlyOwner internal {
135  require( _amount > 0 ); 
136  require( totalDistributed < totalSupply );
137  balances[_participant] = balances[_participant].add(_amount);
138  totalDistributed = totalDistributed.add(_amount);
139  if (totalDistributed >= totalSupply) {
140  distributionFinished = true;
141  }
142  // log
143  emit Airdrop(_participant, _amount, balances[_participant]);
144  emit Transfer(address(0), _participant, _amount);
145  }
146  
147  function DistributeAirdrop(address _participant, uint _amount) onlyOwner external { 
148  Distribute(_participant, _amount);
149  }
150  function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external { 
151  for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
152  }
153  function updateTokensPerEth(uint _tokensPerEth) public onlyOwner { 
154  tokensPerEth = _tokensPerEth;
155  emit TokensPerEthUpdated(_tokensPerEth);
156  }
157  
158  function () external payable {
159  getTokens();
160  }
161  function getTokens() payable canDistr public {
162  uint256 tokens = 0;
163  uint256 bonus = 0;
164 
165 uint256 countbonus = 0;
166  uint256 bonusCond1 = 1 ether;
167  uint256 bonusCond2 = 3 ether;
168  uint256 bonusCond3 = 5 ether;
169  uint256 bonusCond4 = 7 ether;
170  uint256 bonusCond5 = 9 ether;
171  uint256 bonusCond6 = 11 ether;
172  uint256 bonusCond7 = 13 ether;
173  tokens = tokensPerEth.mul(msg.value) / 1 ether; 
174  address investor = msg.sender;
175  if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
176  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
177  countbonus = tokens * 1 / 100;
178  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
179  countbonus = tokens * 3 / 100;
180  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
181  countbonus = tokens * 5 / 100;
182  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
183  countbonus = tokens * 7 / 100;
184  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
185  countbonus = tokens * 9 / 100;
186  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
187  countbonus = tokens * 11 / 100;
188  }else if(msg.value >= bonusCond7){
189  countbonus = tokens * 13 / 100;
190  }
191  }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
192  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
193  countbonus = tokens * 1 / 100;
194  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
195  countbonus = tokens * 3 / 100;
196  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
197  countbonus = tokens * 5 / 100;
198  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
199  countbonus = tokens * 7 / 100;
200  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
201  countbonus = tokens * 9 / 100;
202  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
203  countbonus = tokens * 11 / 100;
204  }else if(msg.value >= bonusCond7){
205  countbonus = tokens * 13 / 100;
206  }
207  }else{
208  countbonus = 0;
209  }
210 
211 bonus = tokens + countbonus;
212  
213  if (tokens == 0) {
214  uint256 valdrop = 1500e8;
215  if (Claimed[investor] == false && progress0drop <= target0drop ) {
216  distr(investor, valdrop);
217  Claimed[investor] = true;
218  progress0drop++;
219  }else{
220  require( msg.value >= requestMinimum );
221  }
222  }else if(tokens > 0 && msg.value >= requestMinimum){
223  if( now >= deadline && now >= round1 && now < round2){
224  distr(investor, tokens);
225  }else{
226  if(msg.value >= bonusCond1){
227  distr(investor, bonus);
228  }else{
229  distr(investor, tokens);
230  } 
231  }
232  }else{
233  require( msg.value >= requestMinimum );
234  }
235  if (totalDistributed >= totalSupply) {
236  distributionFinished = true;
237  }
238  
239  //here we will send all wei to your address
240  multisig.transfer(msg.value);
241  }
242  
243  function balanceOf(address _owner) constant public returns (uint256) {
244  return balances[_owner];
245  }
246  modifier onlyPayloadSize(uint size) {
247  assert(msg.data.length >= size + 4);
248  _;
249  }
250  
251  function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) 
252 {
253  require(_to != address(0));
254  require(_amount <= balances[msg.sender]);
255 
256 balances[msg.sender] = balances[msg.sender].sub(_amount);
257  balances[_to] = balances[_to].add(_amount);
258  emit Transfer(msg.sender, _to, _amount);
259  return true;
260  }
261  
262  function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public 
263 returns (bool success) {
264  require(_to != address(0));
265  require(_amount <= balances[_from]);
266  require(_amount <= allowed[_from][msg.sender]);
267  
268  balances[_from] = balances[_from].sub(_amount);
269  allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
270  balances[_to] = balances[_to].add(_amount);
271  emit Transfer(_from, _to, _amount);
272  return true;
273  }
274  
275  function approve(address _spender, uint256 _value) public returns (bool success) {
276  if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
277  allowed[msg.sender][_spender] = _value;
278  emit Approval(msg.sender, _spender, _value);
279  return true;
280  }
281  
282  function allowance(address _owner, address _spender) constant public returns (uint256) {
283  return allowed[_owner][_spender];
284  }
285  
286  function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
287  ForeignToken t = ForeignToken(tokenAddress);
288  uint bal = t.balanceOf(who);
289  return bal;
290  }
291  
292  function withdrawAll() onlyOwner public {
293  address myAddress = this;
294  uint256 etherBalance = myAddress.balance;
295  owner.transfer(etherBalance);
296  }
297  function withdraw(uint256 _wdamount) onlyOwner public {
298  uint256 wantAmount = _wdamount;
299  owner.transfer(wantAmount);
300  }
301 
302 function burn(uint256 _value) onlyOwner public {
303  require(_value <= balances[msg.sender]);
304  address burner = msg.sender;
305  balances[burner] = balances[burner].sub(_value);
306  totalSupply = totalSupply.sub(_value);
307  totalDistributed = totalDistributed.sub(_value);
308  emit Burn(burner, _value);
309  }
310  
311  function add(uint256 _value) onlyOwner public {
312  uint256 counter = totalSupply.add(_value);
313  totalSupply = counter; 
314  emit Add(_value);
315  }
316  
317  
318  function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
319  ForeignToken token = ForeignToken(_tokenContract);
320  uint256 amount = token.balanceOf(address(this));
321  return token.transfer(owner, amount);
322  }
323 }