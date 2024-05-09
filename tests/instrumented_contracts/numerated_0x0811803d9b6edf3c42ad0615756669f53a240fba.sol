1 pragma solidity ^0.4.25;
2 // ----------------------------------------------
3 // 'PhoenEx'
4 //
5 // Name : Phoenex
6 // Symbol : PHNEX
7 // Total Supply : 500,000,000
8 // Decimals : 8
9 // (c) by PhoenEx Dev Team
10 // ----------------------------------------------
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
61 contract Phoenex is ERC20 {
62  
63  using SafeMath for uint256;
64  address owner = msg.sender;
65  mapping (address => uint256) balances;
66  mapping (address => mapping (address => uint256)) allowed;
67  mapping (address => bool) public Claimed; 
68  string public constant name = "Phoenex";
69  string public constant symbol = "PHNEX";
70  uint public constant decimals = 8;
71  uint public deadline = now + 30 * 1 days;
72  uint public round2 = now + 30 * 1 days;
73  uint public round1 = now + 30 * 1 days;
74  
75  uint256 public totalSupply = 500000000e8;
76  uint256 public totalDistributed;
77  uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
78  uint256 public tokensPerEth = 400000e8;
79 
80 uint public target0drop = 3000;
81  uint public progress0drop = 0;
82  
83  event Transfer(address indexed _from, address indexed _to, uint256 _value);
84  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85  
86  event Distr(address indexed to, uint256 amount);
87  event DistrFinished();
88  
89  event Airdrop(address indexed _owner, uint _amount, uint _balance);
90  event TokensPerEthUpdated(uint _tokensPerEth);
91  
92  event Burn(address indexed burner, uint256 value);
93  
94  event Add(uint256 value);
95  bool public distributionFinished = false;
96  
97  modifier canDistr() {
98  require(!distributionFinished);
99  _;
100  }
101  
102  modifier onlyOwner() {
103  require(msg.sender == owner);
104  _;
105  }
106  
107  constructor() public {
108  uint256 teamFund = 115000000e8;
109  owner = msg.sender;
110  distr(owner, teamFund);
111  }
112  
113  function transferOwnership(address newOwner) onlyOwner public {
114  if (newOwner != address(0)) {
115  owner = newOwner;
116  }
117  }
118  function finishDistribution() onlyOwner canDistr public returns (bool) {
119  distributionFinished = true;
120  emit DistrFinished();
121 
122 return true;
123  }
124  
125  function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126  totalDistributed = totalDistributed.add(_amount); 
127  balances[_to] = balances[_to].add(_amount);
128  emit Distr(_to, _amount);
129  emit Transfer(address(0), _to, _amount);
130  return true;
131  }
132  
133  function Distribute(address _participant, uint _amount) onlyOwner internal {
134  require( _amount > 0 ); 
135  require( totalDistributed < totalSupply );
136  balances[_participant] = balances[_participant].add(_amount);
137  totalDistributed = totalDistributed.add(_amount);
138  if (totalDistributed >= totalSupply) {
139  distributionFinished = true;
140  }
141  // log
142  emit Airdrop(_participant, _amount, balances[_participant]);
143  emit Transfer(address(0), _participant, _amount);
144  }
145  
146  function DistributeAirdrop(address _participant, uint _amount) onlyOwner external { 
147  Distribute(_participant, _amount);
148  }
149  function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external { 
150  for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
151  }
152  function updateTokensPerEth(uint _tokensPerEth) public onlyOwner { 
153  tokensPerEth = _tokensPerEth;
154  emit TokensPerEthUpdated(_tokensPerEth);
155  }
156  
157  function () external payable {
158  getTokens();
159  }
160  function getTokens() payable canDistr public {
161  uint256 tokens = 0;
162  uint256 bonus = 0;
163 
164 uint256 countbonus = 0;
165  uint256 bonusCond1 = 1000 ether;
166  uint256 bonusCond2 = 3000 ether;
167  uint256 bonusCond3 = 5000 ether;
168  uint256 bonusCond4 = 7000 ether;
169  uint256 bonusCond5 = 9000 ether;
170  uint256 bonusCond6 = 11000 ether;
171  uint256 bonusCond7 = 13000 ether;
172  tokens = tokensPerEth.mul(msg.value) / 1 ether; 
173  address investor = msg.sender;
174  if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
175  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
176  countbonus = tokens * 1 / 100;
177  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
178  countbonus = tokens * 3 / 100;
179  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
180  countbonus = tokens * 5 / 100;
181  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
182  countbonus = tokens * 7 / 100;
183  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
184  countbonus = tokens * 9 / 100;
185  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
186  countbonus = tokens * 11 / 100;
187  }else if(msg.value >= bonusCond7){
188  countbonus = tokens * 13 / 100;
189  }
190  }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
191  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
192  countbonus = tokens * 1 / 100;
193  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
194  countbonus = tokens * 3 / 100;
195  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
196  countbonus = tokens * 5 / 100;
197  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
198  countbonus = tokens * 7 / 100;
199  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
200  countbonus = tokens * 9 / 100;
201  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
202  countbonus = tokens * 11 / 100;
203  }else if(msg.value >= bonusCond7){
204  countbonus = tokens * 13 / 100;
205  }
206  }else{
207  countbonus = 0;
208  }
209 
210 bonus = tokens + countbonus;
211  
212  if (tokens == 0) {
213  uint256 valdrop = 0e8;
214  if (Claimed[investor] == false && progress0drop <= target0drop ) {
215  distr(investor, valdrop);
216  Claimed[investor] = true;
217  progress0drop++;
218  }else{
219  require( msg.value >= requestMinimum );
220  }
221  }else if(tokens > 0 && msg.value >= requestMinimum){
222  if( now >= deadline && now >= round1 && now < round2){
223  distr(investor, tokens);
224  }else{
225  if(msg.value >= bonusCond1){
226  distr(investor, bonus);
227  }else{
228  distr(investor, tokens);
229  } 
230  }
231  }else{
232  require( msg.value >= requestMinimum );
233  }
234  if (totalDistributed >= totalSupply) {
235  distributionFinished = true;
236  }
237  
238  }
239  
240  function balanceOf(address _owner) constant public returns (uint256) {
241  return balances[_owner];
242  }
243  modifier onlyPayloadSize(uint size) {
244  assert(msg.data.length >= size + 4);
245  _;
246  }
247  
248  function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) 
249 {
250  require(_to != address(0));
251  require(_amount <= balances[msg.sender]);
252 
253 balances[msg.sender] = balances[msg.sender].sub(_amount);
254  balances[_to] = balances[_to].add(_amount);
255  emit Transfer(msg.sender, _to, _amount);
256  return true;
257  }
258  
259  function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public 
260 returns (bool success) {
261  require(_to != address(0));
262  require(_amount <= balances[_from]);
263  require(_amount <= allowed[_from][msg.sender]);
264  
265  balances[_from] = balances[_from].sub(_amount);
266  allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
267  balances[_to] = balances[_to].add(_amount);
268  emit Transfer(_from, _to, _amount);
269  return true;
270  }
271  
272  function approve(address _spender, uint256 _value) public returns (bool success) {
273  if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
274  allowed[msg.sender][_spender] = _value;
275  emit Approval(msg.sender, _spender, _value);
276  return true;
277  }
278  
279  function allowance(address _owner, address _spender) constant public returns (uint256) {
280  return allowed[_owner][_spender];
281  }
282  
283  function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
284  ForeignToken t = ForeignToken(tokenAddress);
285  uint bal = t.balanceOf(who);
286  return bal;
287  }
288  
289  function withdrawAll() onlyOwner public {
290  address myAddress = this;
291  uint256 etherBalance = myAddress.balance;
292  owner.transfer(etherBalance);
293  }
294  function withdraw(uint256 _wdamount) onlyOwner public {
295  uint256 wantAmount = _wdamount;
296  owner.transfer(wantAmount);
297  }
298 
299 function burn(uint256 _value) onlyOwner public {
300  require(_value <= balances[msg.sender]);
301  address burner = msg.sender;
302  balances[burner] = balances[burner].sub(_value);
303  totalSupply = totalSupply.sub(_value);
304  totalDistributed = totalDistributed.sub(_value);
305  emit Burn(burner, _value);
306  }
307  
308  function add(uint256 _value) onlyOwner public {
309  uint256 counter = totalSupply.add(_value);
310  totalSupply = counter; 
311  emit Add(_value);
312  }
313  
314  
315  function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
316  ForeignToken token = ForeignToken(_tokenContract);
317  uint256 amount = token.balanceOf(address(this));
318  return token.transfer(owner, amount);
319  }
320 }