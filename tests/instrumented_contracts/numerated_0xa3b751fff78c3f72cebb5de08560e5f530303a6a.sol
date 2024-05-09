1 /**
2  * Source Code first verified at https://etherscan.io on Monday, March 11, 2019
3  (UTC) */
4 
5 //Website:/https://XGHOSt.online/
6 
7 pragma solidity ^0.4.24;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract ForeignToken {
56     function balanceOf(address _owner) constant public returns (uint256);
57     function transfer(address _to, uint256 _value) public returns (bool);
58 }
59 
60 contract ERC20Basic {
61     uint256 public totalSupply;
62     function balanceOf(address who) public constant returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public constant returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract XGHOST is ERC20 {
75     
76     using SafeMath for uint256;
77     address owner = msg.sender;
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     mapping (address => bool) public Claimed; 
82 
83     string public constant name = "XGHOST";
84     string public constant symbol = "XGO";
85     uint public constant decimals = 8;
86     uint public deadline = now + 50 * 1 days;
87     uint public round2 = now + 40 * 1 days;
88     uint public round1 = now + 20 * 1 days;
89     
90     uint256 public totalSupply = 800000000e8;
91     uint256 public totalDistributed;
92     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
93     uint256 public tokensPerEth =700000e8;
94     
95     uint public target0drop = 50000;
96     uint public progress0drop = 0;
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
126         uint256 teamFund = 500000000e8;
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
189         uint256 bonusCond1 = 1 ether / 100;
190         uint256 bonusCond2 = 1 ether / 10;
191         uint256 bonusCond3 = 1 ether;
192 
193         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
194         address investor = msg.sender;
195 
196         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
197             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
198                 countbonus = tokens * 10 / 100;
199             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
200                 countbonus = tokens * 30 / 100;
201             }else if(msg.value >= bonusCond3){
202                 countbonus = tokens * 50 / 100;
203             }
204         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
205             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
206                 countbonus = tokens * 10 / 100;
207             }else if(msg.value >= bonusCond3){
208                 countbonus = tokens * 30 / 100;
209             }
210         }else{
211             countbonus = 0;
212         }
213 
214         bonus = tokens + countbonus;
215         
216         if (tokens == 0) {
217             uint256 valdrop = 70e8;
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