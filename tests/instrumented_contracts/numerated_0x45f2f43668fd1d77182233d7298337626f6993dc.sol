1 pragma solidity ^0.4.25;
2 // ----------------------------------------------
3 library SafeMath {
4  /**
5  *  Multiplies two numbers, throws on overflow.
6  */
7  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8  if (a == 0) {
9  return 0;
10  }
11  c = a * b;
12  assert(c / a == b);
13  return c;
14  }
15  /**
16  *  Integer division of two numbers, truncating the quotient.
17  */
18  function div(uint256 a, uint256 b) internal pure returns (uint256) {
19  // assert(b > 0); // Solidity automatically throws when dividing by 0
20  // uint256 c = a / b;
21  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22  return a / b;
23  }
24  /**
25  *  Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
26  */
27  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28  assert(b <= a);
29  return a - b;
30  }
31 function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32  c = a + b;
33  assert(c >= a);
34  return c;
35  }
36 }
37 contract ForeignToken {
38  function balanceOf(address _owner) constant public returns (uint256);
39  function transfer(address _to, uint256 _value) public returns (bool);
40 }
41 contract ERC20Basic {
42  uint256 public totalSupply;
43  function balanceOf(address who) public constant returns (uint256);
44  function transfer(address to, uint256 value) public returns (bool);
45  event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 contract ERC20 is ERC20Basic {
48  function allowance(address owner, address spender) public constant returns (uint256);
49  function transferFrom(address from, address to, uint256 value) public returns (bool);
50  function approve(address spender, uint256 value) public returns (bool);
51  event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 contract NAWRAS is ERC20 {
54  
55  using SafeMath for uint256;
56  address owner = msg.sender;
57  mapping (address => uint256) balances;
58  mapping (address => mapping (address => uint256)) allowed;
59  mapping (address => bool) public Claimed; 
60  string public constant name = "NAWRAS";
61  string public constant symbol = "NAWRAS";
62  uint public constant decimals = 8;
63  uint public deadline = now + 70 * 1 days;
64  uint public round2 = now + 30 * 1 days;
65  uint public round1 = now + 60 * 1 days;
66  
67  uint256 public totalSupply = 100000000000e8;
68  uint256 public totalDistributed;
69  uint256 public constant requestMinimum = 1 ether / 10; // 0.1 Ether
70  uint256 public tokensPerEth = 5000000e8;
71 
72  uint public target0drop = 200000;
73  uint public progress0drop = 0;
74  
75  //here u will write your ether address
76  address multisig = 0x0Cd682aC964C39a4A188267FE87784F31132C443;
77  event Transfer(address indexed _from, address indexed _to, uint256 _value);
78  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79  
80  event Distr(address indexed to, uint256 amount);
81  event DistrFinished();
82  
83  event Airdrop(address indexed _owner, uint _amount, uint _balance);
84  event TokensPerEthUpdated(uint _tokensPerEth);
85  
86  event Burn(address indexed burner, uint256 value);
87  
88  event Add(uint256 value);
89  bool public distributionFinished = false;
90  
91  modifier canDistr() {
92  require(!distributionFinished);
93  _;
94  }
95  
96  modifier onlyOwner() {
97  require(msg.sender == owner);
98  _;
99  }
100  
101  constructor() public {
102  uint256 teamFund = 35000000000e8;
103  owner = msg.sender;
104  distr(owner, teamFund);
105  }
106  
107  function transferOwnership(address newOwner) onlyOwner public {
108  if (newOwner != address(0)) {
109  owner = newOwner;
110  }
111  }
112  function finishDistribution() onlyOwner canDistr public returns (bool) {
113  distributionFinished = true;
114  emit DistrFinished();
115 
116 return true;
117  }
118  
119  function distr(address _to, uint256 _amount) canDistr private returns (bool) {
120  totalDistributed = totalDistributed.add(_amount); 
121  balances[_to] = balances[_to].add(_amount);
122  emit Distr(_to, _amount);
123  emit Transfer(address(0), _to, _amount);
124  return true;
125  }
126  
127  function Distribute(address _participant, uint _amount) onlyOwner internal {
128  require( _amount > 0 ); 
129  require( totalDistributed < totalSupply );
130  balances[_participant] = balances[_participant].add(_amount);
131  totalDistributed = totalDistributed.add(_amount);
132  if (totalDistributed >= totalSupply) {
133  distributionFinished = true;
134  }
135  // log
136  emit Airdrop(_participant, _amount, balances[_participant]);
137  emit Transfer(address(0), _participant, _amount);
138  }
139  
140  function DistributeAirdrop(address _participant, uint _amount) onlyOwner external { 
141  Distribute(_participant, _amount);
142  }
143  function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external { 
144  for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
145  }
146  function updateTokensPerEth(uint _tokensPerEth) public onlyOwner { 
147  tokensPerEth = _tokensPerEth;
148  emit TokensPerEthUpdated(_tokensPerEth);
149  }
150  
151  function () external payable {
152  getTokens();
153  }
154  function getTokens() payable canDistr public {
155  uint256 tokens = 0;
156  uint256 bonus = 0;
157 
158  uint256 countbonus = 0;
159  uint256 bonusCond1 = 0.1 ether;
160  uint256 bonusCond2 = 1 ether;
161  uint256 bonusCond3 = 5 ether;
162  uint256 bonusCond4 = 10 ether;
163  uint256 bonusCond5 = 20 ether;
164  uint256 bonusCond6 = 35 ether;
165  uint256 bonusCond7 = 50 ether;
166  tokens = tokensPerEth.mul(msg.value) / 1 ether; 
167  address investor = msg.sender;
168  if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
169  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
170  countbonus = tokens * 2 / 100;
171  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
172  countbonus = tokens * 5 / 100;
173  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
174  countbonus = tokens * 10 / 100;
175  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
176  countbonus = tokens * 15 / 100;
177  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
178  countbonus = tokens * 20 / 100;
179  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
180  countbonus = tokens * 25 / 100;
181  }else if(msg.value >= bonusCond7){
182  countbonus = tokens * 30 / 100;
183  }
184  }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
185  if(msg.value >= bonusCond1 && msg.value < bonusCond2){
186  countbonus = tokens * 2 / 100;
187  }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
188  countbonus = tokens * 5 / 100;
189  }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
190  countbonus = tokens * 10 / 100;
191  }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
192  countbonus = tokens * 15 / 100;
193  }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){
194  countbonus = tokens * 20 / 100;
195  }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){
196  countbonus = tokens * 25 / 100;
197  }else if(msg.value >= bonusCond7){
198  countbonus = tokens * 30 / 100;
199  }
200  }else{
201  countbonus = 0;
202  }
203 
204 bonus = tokens + countbonus;
205  
206  if (tokens == 0) {
207  uint256 valdrop = 50000e8;
208  if (Claimed[investor] == false && progress0drop <= target0drop ) {
209  distr(investor, valdrop);
210  Claimed[investor] = true;
211  progress0drop++;
212  }else{
213  require( msg.value >= requestMinimum );
214  }
215  }else if(tokens > 0 && msg.value >= requestMinimum){
216  if( now >= deadline && now >= round1 && now < round2){
217  distr(investor, tokens);
218  }else{
219  if(msg.value >= bonusCond1){
220  distr(investor, bonus);
221  }else{
222  distr(investor, tokens);
223  } 
224  }
225  }else{
226  require( msg.value >= requestMinimum );
227  }
228  if (totalDistributed >= totalSupply) {
229  distributionFinished = true;
230  }
231  
232  //here we will send all wei to your address
233  multisig.transfer(msg.value);
234  }
235  
236  function balanceOf(address _owner) constant public returns (uint256) {
237  return balances[_owner];
238  }
239  modifier onlyPayloadSize(uint size) {
240  assert(msg.data.length >= size + 4);
241  _;
242  }
243  
244  function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) 
245 {
246  require(_to != address(0));
247  require(_amount <= balances[msg.sender]);
248 
249 balances[msg.sender] = balances[msg.sender].sub(_amount);
250  balances[_to] = balances[_to].add(_amount);
251  emit Transfer(msg.sender, _to, _amount);
252  return true;
253  }
254  
255  function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public 
256 returns (bool success) {
257  require(_to != address(0));
258  require(_amount <= balances[_from]);
259  require(_amount <= allowed[_from][msg.sender]);
260  
261  balances[_from] = balances[_from].sub(_amount);
262  allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
263  balances[_to] = balances[_to].add(_amount);
264  emit Transfer(_from, _to, _amount);
265  return true;
266  }
267  
268  function approve(address _spender, uint256 _value) public returns (bool success) {
269  if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
270  allowed[msg.sender][_spender] = _value;
271  emit Approval(msg.sender, _spender, _value);
272  return true;
273  }
274  
275  function allowance(address _owner, address _spender) constant public returns (uint256) {
276  return allowed[_owner][_spender];
277  }
278  
279  function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
280  ForeignToken t = ForeignToken(tokenAddress);
281  uint bal = t.balanceOf(who);
282  return bal;
283  }
284  
285  function withdrawAll() onlyOwner public {
286  address myAddress = this;
287  uint256 etherBalance = myAddress.balance;
288  owner.transfer(etherBalance);
289  }
290  function withdraw(uint256 _wdamount) onlyOwner public {
291  uint256 wantAmount = _wdamount;
292  owner.transfer(wantAmount);
293  }
294 
295 function burn(uint256 _value) onlyOwner public {
296  require(_value <= balances[msg.sender]);
297  address burner = msg.sender;
298  balances[burner] = balances[burner].sub(_value);
299  totalSupply = totalSupply.sub(_value);
300  totalDistributed = totalDistributed.sub(_value);
301  emit Burn(burner, _value);
302  }
303  
304  function add(uint256 _value) onlyOwner public {
305  uint256 counter = totalSupply.add(_value);
306  totalSupply = counter; 
307  emit Add(_value);
308  }
309  
310  
311  function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
312  ForeignToken token = ForeignToken(_tokenContract);
313  uint256 amount = token.balanceOf(address(this));
314  return token.transfer(owner, amount);
315  }
316 }