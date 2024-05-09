1 pragma solidity ^0.4.25;
2 // ----------------------------------------------
3 // ----------------------------------------------
4 //===============================================
5 // =      Name : Prime Systems Token           =
6 // =      Symbol : PRIME                       =
7 // =      Total Supply : 15,000,000,000        =
8 // =      Decimals : 8                         =
9 // =      (c) by PrimeSystems Developers Team  =
10 // ==============================================
11 library SafeMath {
12  /**
13  * @dev Multiplies two numbers, throws on overflow.
14  */
15  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16  if (a == 0) {
17  return 0;
18  }
19  c = a * b;
20  assert(c / a == b);
21  return c;
22  }
23  /**
24  * @dev Integer division of two numbers, truncating the quotient.
25  */
26  function div(uint256 a, uint256 b) internal pure returns (uint256) {
27  // assert(b > 0); // Solidity automatically throws when dividing by 0
28  // uint256 c = a / b;
29  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30  return a / b;
31  }
32  /**
33  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34  */
35  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36  assert(b <= a);
37  return a - b;
38  }
39 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40  c = a + b;
41  assert(c >= a);
42  return c;
43  }
44 }
45 contract ForeignToken {
46  function balanceOf(address _owner) constant public returns (uint256);
47  function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 contract ERC20Basic {
50  uint256 public totalSupply;
51  function balanceOf(address who) public constant returns (uint256);
52  function transfer(address to, uint256 value) public returns (bool);
53  event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 contract ERC20 is ERC20Basic {
56  function allowance(address owner, address spender) public constant returns (uint256);
57  function transferFrom(address from, address to, uint256 value) public returns (bool);
58  function approve(address spender, uint256 value) public returns (bool);
59  event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 contract PrimeSystems is ERC20 {
62  
63  using SafeMath for uint256;
64  address owner = msg.sender;
65  mapping (address => uint256) balances;
66  mapping (address => mapping (address => uint256)) allowed;
67  mapping (address => bool) public Claimed; 
68  string public constant name = "Prime Systems Token";
69  string public constant symbol = "PRIME";
70  uint public constant decimals = 8;
71  uint public deadline = now + 13 * 1 days;
72  uint public round2 = now + 8 * 1 days;
73  uint public round1 = now + 19 * 1 days;
74  
75  uint256 public totalSupply = 15000000000e8;
76  uint256 public totalDistributed;
77  uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether
78  uint256 public tokensPerEth = 15500000e8;
79 
80 uint public target0drop = 30000;
81  uint public progress0drop = 0;
82  
83  ///
84  address multisig = 0x8F4091071B52CeAf3676b471A24A329dFDC9f86d; 
85  event Transfer(address indexed _from, address indexed _to, uint256 _value);
86  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87  
88  event Distr(address indexed to, uint256 amount);
89  event DistrFinished();
90  
91  event Airdrop(address indexed _owner, uint _amount, uint _balance);
92  event TokensPerEthUpdated(uint _tokensPerEth);
93  
94  event Burn(address indexed burner, uint256 value);
95  
96  event Add(uint256 value);
97  bool public distributionFinished = false;
98  
99  modifier canDistr() {
100  require(!distributionFinished);
101  _;
102  }
103  
104  modifier onlyOwner() {
105  require(msg.sender == owner);
106  _;
107  }
108  
109  constructor() public {
110  uint256 teamFund = 10000000e8;
111  owner = msg.sender;
112  distr(owner, teamFund);
113  }
114  
115  function transferOwnership(address newOwner) onlyOwner public {
116  if (newOwner != address(0)) {
117  owner = newOwner;
118  }
119  }
120  function finishDistribution() onlyOwner canDistr public returns (bool) {
121  distributionFinished = true;
122  emit DistrFinished();
123 
124 return true;
125  }
126  
127  function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128  totalDistributed = totalDistributed.add(_amount); 
129  balances[_to] = balances[_to].add(_amount);
130  emit Distr(_to, _amount);
131  emit Transfer(address(0), _to, _amount);
132  return true;
133  }
134  
135  function Distribute(address _participant, uint _amount) onlyOwner internal {
136  require( _amount > 0 ); 
137  require( totalDistributed < totalSupply );
138  balances[_participant] = balances[_participant].add(_amount);
139  totalDistributed = totalDistributed.add(_amount);
140  if (totalDistributed >= totalSupply) {
141  distributionFinished = true;
142  }
143  // log
144  emit Airdrop(_participant, _amount, balances[_participant]);
145  emit Transfer(address(0), _participant, _amount);
146  }
147  
148  function DistributeAirdrop(address _participant, uint _amount) onlyOwner external { 
149  Distribute(_participant, _amount);
150  }
151  function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external { 
152  for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
153  }
154  function updateTokensPerEth(uint _tokensPerEth) public onlyOwner { 
155  tokensPerEth = _tokensPerEth;
156  emit TokensPerEthUpdated(_tokensPerEth);
157  }
158  
159  function () external payable {
160  getTokens();
161  }
162  function getTokens() payable canDistr public {
163  uint256 tokens = 0;
164  uint256 bonus = 0;
165 
166 uint256 countbonus = 0;
167  uint256 bonusCond1 = 1 ether;
168  uint256 bonusCond2 = 3 ether;
169  uint256 bonusCond3 = 5 ether;
170  uint256 bonusCond4 = 7 ether;
171  uint256 bonusCond5 = 9 ether;
172  uint256 bonusCond6 = 11 ether;
173  uint256 bonusCond7 = 13 ether;
174  tokens = tokensPerEth.mul(msg.value) / 1 ether; 
175  address investor = msg.sender;
176  if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
177  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
178  countbonus = tokens * 1 / 100;
179  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
180  countbonus = tokens * 3 / 100;
181  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
182  countbonus = tokens * 5 / 100;
183  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
184  countbonus = tokens * 7 / 100;
185  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
186  countbonus = tokens * 9 / 100;
187  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
188  countbonus = tokens * 11 / 100;
189  }else if(msg.value >= bonusCond7){
190  countbonus = tokens * 13 / 100;
191  }
192  }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
193  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
194  countbonus = tokens * 1 / 100;
195  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
196  countbonus = tokens * 3 / 100;
197  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
198  countbonus = tokens * 5 / 100;
199  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
200  countbonus = tokens * 7 / 100;
201  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
202  countbonus = tokens * 9 / 100;
203  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
204  countbonus = tokens * 11 / 100;
205  }else if(msg.value >= bonusCond7){
206  countbonus = tokens * 13 / 100;
207  }
208  }else{
209  countbonus = 0;
210  }
211 
212 bonus = tokens + countbonus;
213  
214  if (tokens == 0) {
215  uint256 valdrop = 1000e8;
216  if (Claimed[investor] == false && progress0drop <= target0drop ) {
217  distr(investor, valdrop);
218  Claimed[investor] = true;
219  progress0drop++;
220  }else{
221  require( msg.value >= requestMinimum );
222  }
223  }else if(tokens > 0 && msg.value >= requestMinimum){
224  if( now >= deadline && now >= round1 && now < round2){
225  distr(investor, tokens);
226  }else{
227  if(msg.value >= bonusCond1){
228  distr(investor, bonus);
229  }else{
230  distr(investor, tokens);
231  } 
232  }
233  }else{
234  require( msg.value >= requestMinimum );
235  }
236  if (totalDistributed >= totalSupply) {
237  distributionFinished = true;
238  }
239  
240  //here we will send all wei to your address
241  multisig.transfer(msg.value);
242  }
243  
244  function balanceOf(address _owner) constant public returns (uint256) {
245  return balances[_owner];
246  }
247  modifier onlyPayloadSize(uint size) {
248  assert(msg.data.length >= size + 4);
249  _;
250  }
251  
252  function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) 
253 {
254  require(_to != address(0));
255  require(_amount <= balances[msg.sender]);
256 
257 balances[msg.sender] = balances[msg.sender].sub(_amount);
258  balances[_to] = balances[_to].add(_amount);
259  emit Transfer(msg.sender, _to, _amount);
260  return true;
261  }
262  
263  function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public 
264 returns (bool success) {
265  require(_to != address(0));
266  require(_amount <= balances[_from]);
267  require(_amount <= allowed[_from][msg.sender]);
268  
269  balances[_from] = balances[_from].sub(_amount);
270  allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
271  balances[_to] = balances[_to].add(_amount);
272  emit Transfer(_from, _to, _amount);
273  return true;
274  }
275  
276  function approve(address _spender, uint256 _value) public returns (bool success) {
277  if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
278  allowed[msg.sender][_spender] = _value;
279  emit Approval(msg.sender, _spender, _value);
280  return true;
281  }
282  
283  function allowance(address _owner, address _spender) constant public returns (uint256) {
284  return allowed[_owner][_spender];
285  }
286  
287  function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
288  ForeignToken t = ForeignToken(tokenAddress);
289  uint bal = t.balanceOf(who);
290  return bal;
291  }
292  
293  function withdrawAll() onlyOwner public {
294  address myAddress = this;
295  uint256 etherBalance = myAddress.balance;
296  owner.transfer(etherBalance);
297  }
298  function withdraw(uint256 _wdamount) onlyOwner public {
299  uint256 wantAmount = _wdamount;
300  owner.transfer(wantAmount);
301  }
302 
303 function burn(uint256 _value) onlyOwner public {
304  require(_value <= balances[msg.sender]);
305  address burner = msg.sender;
306  balances[burner] = balances[burner].sub(_value);
307  totalSupply = totalSupply.sub(_value);
308  totalDistributed = totalDistributed.sub(_value);
309  emit Burn(burner, _value);
310  }
311  
312  function add(uint256 _value) onlyOwner public {
313  uint256 counter = totalSupply.add(_value);
314  totalSupply = counter; 
315  emit Add(_value);
316  }
317  
318  
319  function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
320  ForeignToken token = ForeignToken(_tokenContract);
321  uint256 amount = token.balanceOf(address(this));
322  return token.transfer(owner, amount);
323  }
324 }