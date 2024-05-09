1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, February 27, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 /**
8  * @title MYHUBBS  Project
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 contract ForeignToken {
53     function balanceOf(address _owner) constant public returns (uint256);
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract ERC20Basic {
58     uint256 public totalSupply;
59     function balanceOf(address who) public constant returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public constant returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract HUBBSGOLD is ERC20 {
72     
73     using SafeMath for uint256;
74     address owner = msg.sender;
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping (address => bool) public Claimed; 
79 
80     string public constant name = "HUBBSGOLD";
81     string public constant symbol = "HUG";
82     uint public constant decimals = 8;
83     uint public deadline = now + 37 * 1 days;
84     uint public round2 = now + 32 * 1 days;
85     uint public round1 = now + 22 * 1 days;
86     
87     uint256 public totalSupply = 120000000e8;
88     uint256 public totalDistributed;
89     uint256 public constant requestMinimum = 5 ether / 1000; // 0.005 Ether
90     uint256 public tokensPerEth = 500000e8;
91     
92     uint public target0drop = 1000000;
93     uint public progress0drop = 0;
94     
95     //here u will write your ether address
96     address multisig = 0x8Fe8cE138510b2B22b866D09B71F6D24c994477B ;
97 
98 
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101     
102     event Distr(address indexed to, uint256 amount);
103     event DistrFinished();
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
126         uint256 teamFund = 100000000e8;
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
143     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
144         totalDistributed = totalDistributed.add(_amount);        
145         balances[_to] = balances[_to].add(_amount);
146         emit Distr(_to, _amount);
147         emit Transfer(address(0), _to, _amount);
148 
149         return true;
150     }
151     
152     function Distribute(address _participant, uint _amount) onlyOwner internal {
153 
154         require( _amount > 0 );      
155         require( totalDistributed < totalSupply );
156         balances[_participant] = balances[_participant].add(_amount);
157         totalDistributed = totalDistributed.add(_amount);
158 
159         if (totalDistributed >= totalSupply) {
160             distributionFinished = true;
161         }
162 
163         // log
164         emit Airdrop(_participant, _amount, balances[_participant]);
165         emit Transfer(address(0), _participant, _amount);
166     }
167     
168     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
169         Distribute(_participant, _amount);
170     }
171 
172     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
173         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
174     }
175 
176     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
177         tokensPerEth = _tokensPerEth;
178         emit TokensPerEthUpdated(_tokensPerEth);
179     }
180            
181     function () external payable {
182         getTokens();
183      }
184 
185     function getTokens() payable canDistr  public {
186         uint256 tokens = 0;
187         uint256 bonus = 0;
188         uint256 countbonus = 0;
189         uint256 bonusCond1 = 1 ether / 10;
190         uint256 bonusCond2 = 1 ether;
191         uint256 bonusCond3 = 5 ether;
192 
193         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
194         address investor = msg.sender;
195 
196         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
197             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
198                 countbonus = tokens * 5 / 100;
199             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
200                 countbonus = tokens * 10 / 100;
201             }else if(msg.value >= bonusCond3){
202                 countbonus = tokens * 15 / 100;
203             }
204         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
205             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
206                 countbonus = tokens * 5 / 100;
207             }else if(msg.value >= bonusCond3){
208                 countbonus = tokens * 10 / 100;
209             }
210         }else{
211             countbonus = 0;
212         }
213 
214         bonus = tokens + countbonus;
215         
216         if (tokens == 0) {
217             uint256 valdrop = 50e8;
218             if (Claimed[investor] == false && progress0drop <= target0drop ) {
219                 distr(investor, valdrop);
220                 Claimed[investor] = true;
221                 progress0drop++;
222             }else{
223                 require( msg.value >= requestMinimum );
224             }
225         }else if(tokens > 0 && msg.value >= requestMinimum){
226             if( now >= deadline && now >= round1 && now < round2){
227                 distr(investor, tokens);
228             }else{
229                 if(msg.value >= bonusCond1){
230                     distr(investor, bonus);
231                 }else{
232                     distr(investor, tokens);
233                 }   
234             }
235         }else{
236             require( msg.value >= requestMinimum );
237         }
238 
239         if (totalDistributed >= totalSupply) {
240             distributionFinished = true;
241         }
242         
243         //here we will send all wei to your address
244         multisig.transfer(msg.value);
245     }
246     
247     function balanceOf(address _owner) constant public returns (uint256) {
248         return balances[_owner];
249     }
250 
251     modifier onlyPayloadSize(uint size) {
252         assert(msg.data.length >= size + 4);
253         _;
254     }
255     
256     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
257 
258         require(_to != address(0));
259         require(_amount <= balances[msg.sender]);
260         
261         balances[msg.sender] = balances[msg.sender].sub(_amount);
262         balances[_to] = balances[_to].add(_amount);
263         emit Transfer(msg.sender, _to, _amount);
264         return true;
265     }
266     
267     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
268 
269         require(_to != address(0));
270         require(_amount <= balances[_from]);
271         require(_amount <= allowed[_from][msg.sender]);
272         
273         balances[_from] = balances[_from].sub(_amount);
274         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         emit Transfer(_from, _to, _amount);
277         return true;
278     }
279     
280     function approve(address _spender, uint256 _value) public returns (bool success) {
281         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
282         allowed[msg.sender][_spender] = _value;
283         emit Approval(msg.sender, _spender, _value);
284         return true;
285     }
286     
287     function allowance(address _owner, address _spender) constant public returns (uint256) {
288         return allowed[_owner][_spender];
289     }
290     
291     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
292         ForeignToken t = ForeignToken(tokenAddress);
293         uint bal = t.balanceOf(who);
294         return bal;
295     }
296     
297     function withdrawAll() onlyOwner public {
298         address myAddress = this;
299         uint256 etherBalance = myAddress.balance;
300         owner.transfer(etherBalance);
301     }
302 
303     function withdraw(uint256 _wdamount) onlyOwner public {
304         uint256 wantAmount = _wdamount;
305         owner.transfer(wantAmount);
306     }
307 
308     function burn(uint256 _value) onlyOwner public {
309         require(_value <= balances[msg.sender]);
310         address burner = msg.sender;
311         balances[burner] = balances[burner].sub(_value);
312         totalSupply = totalSupply.sub(_value);
313         totalDistributed = totalDistributed.sub(_value);
314         emit Burn(burner, _value);
315     }
316     
317     function add(uint256 _value) onlyOwner public {
318         uint256 counter = totalSupply.add(_value);
319         totalSupply = counter; 
320         emit Add(_value);
321     }
322     
323     
324     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
325         ForeignToken token = ForeignToken(_tokenContract);
326         uint256 amount = token.balanceOf(address(this));
327         return token.transfer(owner, amount);
328     }
329 }