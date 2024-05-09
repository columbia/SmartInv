1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-24
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract ForeignToken {
54     function balanceOf(address _owner) constant public returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56 }
57 
58 contract ERC20Basic {
59     uint256 public totalSupply;
60     function balanceOf(address who) public constant returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract DAOT is ERC20 {
73     
74     using SafeMath for uint256;
75     address owner = msg.sender;
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79     mapping (address => bool) public Claimed; 
80 
81     string public constant name = "DAOT";
82     string public constant symbol = "DAOT";
83     uint public constant decimals = 8;
84     uint public deadline = now + 43 * 1 days;
85     uint public round2 = now + 40 * 1 days;
86     uint public round1 = now + 32 * 1 days;
87     
88     uint256 public totalSupply = 1000000000e8;
89     uint256 public totalDistributed;
90     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
91     uint256 public tokensPerEth = 100000e8;
92     
93     uint public target0drop = 100;
94     uint public progress0drop = 0;
95 
96 
97     event Transfer(address indexed _from, address indexed _to, uint256 _value);
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99     
100     event Distr(address indexed to, uint256 amount);
101     event DistrFinished();
102     
103     event DistrRestarted();
104     
105     event Airdrop(address indexed _owner, uint _amount, uint _balance);
106 
107     event TokensPerEthUpdated(uint _tokensPerEth);
108     
109     event Burn(address indexed burner, uint256 value);
110     
111     event Add(uint256 value);
112 
113     bool public distributionFinished = false;
114     
115     modifier canDistr() {
116         require(!distributionFinished);
117         _;
118     }
119     
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124     
125     constructor() public {
126         uint256 teamFund = 2000000e8;
127         owner = msg.sender;
128         distr(owner, teamFund);
129     }
130     
131     function transferOwnership(address newOwner) onlyOwner public {
132         if (newOwner != address(0)) {
133             owner = newOwner;
134         }
135     }
136 
137     function finishDistribution() onlyOwner canDistr public returns (bool) {
138         distributionFinished = true;
139         emit DistrFinished();
140         return true;
141     }
142     
143     function reDistribution() onlyOwner canDistr public returns (bool) {
144         distributionFinished = false;
145         emit DistrRestarted();
146         return true;
147     }
148     
149     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
150         totalDistributed = totalDistributed.add(_amount);        
151         balances[_to] = balances[_to].add(_amount);
152         emit Distr(_to, _amount);
153         emit Transfer(address(0), _to, _amount);
154 
155         return true;
156     }
157     
158     function Distribute(address _participant, uint _amount) onlyOwner internal {
159 
160         require( _amount > 0 );      
161         require( totalDistributed < totalSupply );
162         balances[_participant] = balances[_participant].add(_amount);
163         totalDistributed = totalDistributed.add(_amount);
164 
165         if (totalDistributed >= totalSupply) {
166             distributionFinished = true;
167         }
168 
169         // log
170         emit Airdrop(_participant, _amount, balances[_participant]);
171         emit Transfer(address(0), _participant, _amount);
172     }
173     
174     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
175         Distribute(_participant, _amount);
176     }
177 
178     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
179         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
180     }
181 
182     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
183         tokensPerEth = _tokensPerEth;
184         emit TokensPerEthUpdated(_tokensPerEth);
185     }
186            
187     function () external payable {
188         getTokens();
189      }
190 
191     function getTokens() payable canDistr  public {
192         uint256 tokens = 0;
193         uint256 bonus = 0;
194         uint256 countbonus = 0;
195         uint256 bonusCond1 = 1 ether / 10;
196         uint256 bonusCond2 = 1 ether / 2;
197         uint256 bonusCond3 = 1 ether;
198 
199         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
200         address investor = msg.sender;
201 
202         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
203             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
204                 countbonus = tokens * 25 / 100;
205             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
206                 countbonus = tokens * 15 / 100;
207             }else if(msg.value >= bonusCond3){
208                 countbonus = tokens * 10 / 100;
209             }
210         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
211             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
212                 countbonus = tokens * 25 / 100;
213             }else if(msg.value >= bonusCond3){
214                 countbonus = tokens * 15 / 100;
215             }
216         }else{
217             countbonus = 0;
218         }
219 
220         bonus = tokens + countbonus;
221         
222         if (tokens == 0) {
223             uint256 valdrop = 500e8;
224             if (Claimed[investor] == false && progress0drop <= target0drop ) {
225                 distr(investor, valdrop);
226                 Claimed[investor] = true;
227                 progress0drop++;
228             }else{
229                 require( msg.value >= requestMinimum );
230             }
231         }else if(tokens > 0 && msg.value >= requestMinimum){
232             if( now >= deadline && now >= round1 && now < round2){
233                 distr(investor, tokens);
234             }else{
235                 if(msg.value >= bonusCond1){
236                     distr(investor, bonus);
237                 }else{
238                     distr(investor, tokens);
239                 }   
240             }
241         }else{
242             require( msg.value >= requestMinimum );
243         }
244 
245         if (totalDistributed >= totalSupply) {
246             distributionFinished = true;
247         }
248     }
249     
250     function balanceOf(address _owner) constant public returns (uint256) {
251         return balances[_owner];
252     }
253 
254     modifier onlyPayloadSize(uint size) {
255         assert(msg.data.length >= size + 4);
256         _;
257     }
258     
259     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
260 
261         require(_to != address(0));
262         require(_amount <= balances[msg.sender]);
263         
264         balances[msg.sender] = balances[msg.sender].sub(_amount);
265         balances[_to] = balances[_to].add(_amount);
266         emit Transfer(msg.sender, _to, _amount);
267         return true;
268     }
269     
270     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
271 
272         require(_to != address(0));
273         require(_amount <= balances[_from]);
274         require(_amount <= allowed[_from][msg.sender]);
275         
276         balances[_from] = balances[_from].sub(_amount);
277         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
278         balances[_to] = balances[_to].add(_amount);
279         emit Transfer(_from, _to, _amount);
280         return true;
281     }
282     
283     function approve(address _spender, uint256 _value) public returns (bool success) {
284         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
285         allowed[msg.sender][_spender] = _value;
286         emit Approval(msg.sender, _spender, _value);
287         return true;
288     }
289     
290     function allowance(address _owner, address _spender) constant public returns (uint256) {
291         return allowed[_owner][_spender];
292     }
293     
294     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
295         ForeignToken t = ForeignToken(tokenAddress);
296         uint bal = t.balanceOf(who);
297         return bal;
298     }
299     
300     function withdrawAll() onlyOwner public {
301         address myAddress = this;
302         uint256 etherBalance = myAddress.balance;
303         owner.transfer(etherBalance);
304     }
305 
306     function withdraw(uint256 _wdamount) onlyOwner public {
307         uint256 wantAmount = _wdamount;
308         owner.transfer(wantAmount);
309     }
310 
311     function burn(uint256 _value) onlyOwner public {
312         require(_value <= balances[msg.sender]);
313         address burner = msg.sender;
314         balances[burner] = balances[burner].sub(_value);
315         totalSupply = totalSupply.sub(_value);
316         totalDistributed = totalDistributed.sub(_value);
317         emit Burn(burner, _value);
318     }
319     
320     function add(uint256 _value) onlyOwner public {
321         uint256 counter = totalSupply.add(_value);
322         totalSupply = counter; 
323         emit Add(_value);
324     }
325     
326     
327     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
328         ForeignToken token = ForeignToken(_tokenContract);
329         uint256 amount = token.balanceOf(address(this));
330         return token.transfer(owner, amount);
331     }
332 }