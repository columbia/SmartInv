1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title RB
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ForeignToken {
49     function balanceOf(address _owner) constant public returns (uint256);
50     function transfer(address _to, uint256 _value) public returns (bool);
51 }
52 
53 contract ERC20Basic {
54     uint256 public totalSupply;
55     function balanceOf(address who) public constant returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract RB is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public Claimed; 
75 
76     string public constant name = "RBCoin";
77     string public constant symbol = "RBC";
78     uint public constant decimals = 2;
79     uint public deadline = now + 370 * 1 days;
80     uint public round2 = now + 320 * 1 days;
81     uint public round1 = now + 220 * 1 days;
82     
83     uint256 public totalSupply = 10000000000;
84     uint256 public totalDistributed;
85     uint256 public constant requestMinimum = 1 ether / 200; // 0.005 Ether
86     uint256 public tokensPerEth = 300000;
87     
88     uint public target0drop = 10;
89     uint public progress0drop = 0;
90     
91     //here u will write your ether address
92     address multisig = 0x607aB9F2f5c20648902B233F75fA9Bd0012243f4
93     ;
94 
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98     
99     event Distr(address indexed to, uint256 amount);
100     event DistrFinished();
101     
102     event Airdrop(address indexed _owner, uint _amount, uint _balance);
103 
104     event TokensPerEthUpdated(uint _tokensPerEth);
105     
106     event Burn(address indexed burner, uint256 value);
107     
108     event Add(uint256 value);
109 
110     bool public distributionFinished = false;
111     
112     modifier canDistr() {
113         require(!distributionFinished);
114         _;
115     }
116     
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121     
122     constructor() public {
123         uint256 teamFund = 50000000e2;
124         owner = msg.sender;
125         distr(owner, teamFund);
126     }
127     
128     function transferOwnership(address newOwner) onlyOwner public {
129         if (newOwner != address(0)) {
130             owner = newOwner;
131         }
132     }
133 
134     function finishDistribution() onlyOwner canDistr public returns (bool) {
135         distributionFinished = true;
136         emit DistrFinished();
137         return true;
138     }
139     
140     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
141         totalDistributed = totalDistributed.add(_amount);        
142         balances[_to] = balances[_to].add(_amount);
143         emit Distr(_to, _amount);
144         emit Transfer(address(0), _to, _amount);
145 
146         return true;
147     }
148     
149     function Distribute(address _participant, uint _amount) onlyOwner internal {
150 
151         require( _amount > 0 );      
152         require( totalDistributed < totalSupply );
153         balances[_participant] = balances[_participant].add(_amount);
154         totalDistributed = totalDistributed.add(_amount);
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159 
160         // log
161         emit Airdrop(_participant, _amount, balances[_participant]);
162         emit Transfer(address(0), _participant, _amount);
163     }
164     
165     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
166         Distribute(_participant, _amount);
167     }
168 
169     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
170         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
171     }
172 
173     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
174         tokensPerEth = _tokensPerEth;
175         emit TokensPerEthUpdated(_tokensPerEth);
176     }
177            
178     function () external payable {
179         getTokens();
180      }
181 
182         
183     function getTokens() payable canDistr  public {
184         uint256 tokens = 0;
185         uint256 bonus = 0;
186         uint256 countbonus = 0;
187         uint256 bonusCond1 = 10 ether / 10;
188         uint256 bonusCond2 = 10 ether;
189         uint256 bonusCond3 = 50 ether;
190 
191         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
192         address investor = msg.sender;
193 
194         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
195             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
196                 countbonus = tokens * 0 / 100;
197             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
198                 countbonus = tokens * 20 / 100;
199             }else if(msg.value >= bonusCond3){
200                 countbonus = tokens * 35 / 100;
201             }
202         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
203             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
204                 countbonus = tokens * 20 / 100;
205             }else if(msg.value >= bonusCond3){
206                 countbonus = tokens * 35 / 100;
207             }
208         }else{
209             countbonus = 0;
210         }
211 
212         bonus = tokens + countbonus;
213         
214         if (tokens == 0) {
215             uint256 valdrop = 30e8;
216             if (Claimed[investor] == false && progress0drop <= target0drop ) {
217                 distr(investor, valdrop);
218                 Claimed[investor] = true;
219                 progress0drop++;
220             }else{
221                 require( msg.value >= requestMinimum );
222             }
223         }else if(tokens > 0 && msg.value >= requestMinimum){
224             if( now >= deadline && now >= round1 && now < round2){
225                 distr(investor, tokens);
226             }else{
227                 if(msg.value >= bonusCond1){
228                     distr(investor, bonus);
229                 }else{
230                     distr(investor, tokens);
231                 }   
232             }
233         }else{
234             require( msg.value >= requestMinimum );
235         }
236 
237         if (totalDistributed >= totalSupply) {
238             distributionFinished = true;
239         }
240         //here we will send all wei to your address
241         multisig.transfer(msg.value);
242     }
243     
244     function balanceOf(address _owner) constant public returns (uint256) {
245         return balances[_owner];
246     }
247 
248     modifier onlyPayloadSize(uint size) {
249         assert(msg.data.length >= size + 4);
250         _;
251     }
252     
253     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
254 
255         require(_to != address(0));
256         require(_amount <= balances[msg.sender]);
257         
258         balances[msg.sender] = balances[msg.sender].sub(_amount);
259         balances[_to] = balances[_to].add(_amount);
260         emit Transfer(msg.sender, _to, _amount);
261         return true;
262     }
263     
264     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
265 
266         require(_to != address(0));
267         require(_amount <= balances[_from]);
268         require(_amount <= allowed[_from][msg.sender]);
269         
270         balances[_from] = balances[_from].sub(_amount);
271         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
272         balances[_to] = balances[_to].add(_amount);
273         emit Transfer(_from, _to, _amount);
274         return true;
275     }
276     
277     function approve(address _spender, uint256 _value) public returns (bool success) {
278         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
279         allowed[msg.sender][_spender] = _value;
280         emit Approval(msg.sender, _spender, _value);
281         return true;
282     }
283     
284     function allowance(address _owner, address _spender) constant public returns (uint256) {
285         return allowed[_owner][_spender];
286     }
287     
288     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
289         ForeignToken t = ForeignToken(tokenAddress);
290         uint bal = t.balanceOf(who);
291         return bal;
292     }
293     
294     function withdrawAll() onlyOwner public {
295         address myAddress = this;
296         uint256 etherBalance = myAddress.balance;
297         owner.transfer(etherBalance);
298     }
299 
300     function withdraw(uint256 _wdamount) onlyOwner public {
301         uint256 wantAmount = _wdamount;
302         owner.transfer(wantAmount);
303     }
304 
305     function burn(uint256 _value) onlyOwner public {
306         require(_value <= balances[msg.sender]);
307         address burner = msg.sender;
308         balances[burner] = balances[burner].sub(_value);
309         totalSupply = totalSupply.sub(_value);
310         totalDistributed = totalDistributed.sub(_value);
311         emit Burn(burner, _value);
312     }
313     
314     function add(uint256 _value) onlyOwner public {
315         uint256 counter = totalSupply.add(_value);
316         totalSupply = counter; 
317         emit Add(_value);
318     }
319     
320     
321     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
322         ForeignToken token = ForeignToken(_tokenContract);
323         uint256 amount = token.balanceOf(address(this));
324         return token.transfer(owner, amount);
325     }
326 }