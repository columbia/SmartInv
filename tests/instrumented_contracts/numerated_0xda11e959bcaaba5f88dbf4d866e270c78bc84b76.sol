1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ForeignToken {
50     function balanceOf(address _owner) constant public returns (uint256);
51     function transfer(address _to, uint256 _value) public returns (bool);
52 }
53 
54 contract ERC20Basic {
55     uint256 public totalSupply;
56     function balanceOf(address who) public constant returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract EBP is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed; 
76 
77     string public constant name = "eBlockPower";
78     string public constant symbol = "EBP";
79     uint public constant decimals = 8;
80     uint public deadline = now + 37 * 1 days;
81     uint public round2 = now + 32 * 1 days;
82     uint public round1 = now + 22 * 1 days;
83     
84     uint256 public totalSupply = 20000000000e8;
85     uint256 public totalDistributed;
86     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
87     uint256 public tokensPerEth = 15000000e8;
88     
89     uint public target0drop = 2000;
90     uint public progress0drop = 0;
91 
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98     
99     event Airdrop(address indexed _owner, uint _amount, uint _balance);
100 
101     event TokensPerEthUpdated(uint _tokensPerEth);
102     
103     event Burn(address indexed burner, uint256 value);
104     
105     event Add(uint256 value);
106 
107     bool public distributionFinished = false;
108     
109     modifier canDistr() {
110         require(!distributionFinished);
111         _;
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     constructor() public {
120         uint256 teamFund = 5000000000e8;
121         owner = msg.sender;
122         distr(owner, teamFund);
123     }
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135     }
136     
137     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
138         totalDistributed = totalDistributed.add(_amount);        
139         balances[_to] = balances[_to].add(_amount);
140         emit Distr(_to, _amount);
141         emit Transfer(address(0), _to, _amount);
142 
143         return true;
144     }
145     
146     function Distribute(address _participant, uint _amount) onlyOwner internal {
147 
148         require( _amount > 0 );      
149         require( totalDistributed < totalSupply );
150         balances[_participant] = balances[_participant].add(_amount);
151         totalDistributed = totalDistributed.add(_amount);
152 
153         if (totalDistributed >= totalSupply) {
154             distributionFinished = true;
155         }
156 
157         // log
158         emit Airdrop(_participant, _amount, balances[_participant]);
159         emit Transfer(address(0), _participant, _amount);
160     }
161     
162     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
163         Distribute(_participant, _amount);
164     }
165 
166     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
167         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
168     }
169 
170     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
171         tokensPerEth = _tokensPerEth;
172         emit TokensPerEthUpdated(_tokensPerEth);
173     }
174            
175     function () external payable {
176         getTokens();
177      }
178 
179     function getTokens() payable canDistr  public {
180         uint256 tokens = 0;
181         uint256 bonus = 0;
182         uint256 countbonus = 0;
183         uint256 bonusCond1 = 1 ether / 10;
184         uint256 bonusCond2 = 1 ether / 2;
185         uint256 bonusCond3 = 1 ether;
186 
187         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
188         address investor = msg.sender;
189 
190         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
191             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
192                 countbonus = tokens * 10 / 100;
193             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
194                 countbonus = tokens * 25 / 100;
195             }else if(msg.value >= bonusCond3){
196                 countbonus = tokens * 50 / 100;
197             }
198         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
199             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
200                 countbonus = tokens * 15 / 100;
201             }else if(msg.value >= bonusCond3){
202                 countbonus = tokens * 35 / 100;
203             }
204         }else{
205             countbonus = 0;
206         }
207 
208         bonus = tokens + countbonus;
209         
210         if (tokens == 0) {
211             uint256 valdrop = 10000e8;
212             if (Claimed[investor] == false && progress0drop <= target0drop ) {
213                 distr(investor, valdrop);
214                 Claimed[investor] = true;
215                 progress0drop++;
216             }else{
217                 require( msg.value >= requestMinimum );
218             }
219         }else if(tokens > 0 && msg.value >= requestMinimum){
220             if( now >= deadline && now >= round1 && now < round2){
221                 distr(investor, tokens);
222             }else{
223                 if(msg.value >= bonusCond1){
224                     distr(investor, bonus);
225                 }else{
226                     distr(investor, tokens);
227                 }   
228             }
229         }else{
230             require( msg.value >= requestMinimum );
231         }
232 
233         if (totalDistributed >= totalSupply) {
234             distributionFinished = true;
235         }
236     }
237     
238     function balanceOf(address _owner) constant public returns (uint256) {
239         return balances[_owner];
240     }
241 
242     modifier onlyPayloadSize(uint size) {
243         assert(msg.data.length >= size + 4);
244         _;
245     }
246     
247     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
248 
249         require(_to != address(0));
250         require(_amount <= balances[msg.sender]);
251         
252         balances[msg.sender] = balances[msg.sender].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         emit Transfer(msg.sender, _to, _amount);
255         return true;
256     }
257     
258     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
259 
260         require(_to != address(0));
261         require(_amount <= balances[_from]);
262         require(_amount <= allowed[_from][msg.sender]);
263         
264         balances[_from] = balances[_from].sub(_amount);
265         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         emit Transfer(_from, _to, _amount);
268         return true;
269     }
270     
271     function approve(address _spender, uint256 _value) public returns (bool success) {
272         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
273         allowed[msg.sender][_spender] = _value;
274         emit Approval(msg.sender, _spender, _value);
275         return true;
276     }
277     
278     function allowance(address _owner, address _spender) constant public returns (uint256) {
279         return allowed[_owner][_spender];
280     }
281     
282     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
283         ForeignToken t = ForeignToken(tokenAddress);
284         uint bal = t.balanceOf(who);
285         return bal;
286     }
287     
288     function withdrawAll() onlyOwner public {
289         address myAddress = this;
290         uint256 etherBalance = myAddress.balance;
291         owner.transfer(etherBalance);
292     }
293 
294     function withdraw(uint256 _wdamount) onlyOwner public {
295         uint256 wantAmount = _wdamount;
296         owner.transfer(wantAmount);
297     }
298 
299     function burn(uint256 _value) onlyOwner public {
300         require(_value <= balances[msg.sender]);
301         address burner = msg.sender;
302         balances[burner] = balances[burner].sub(_value);
303         totalSupply = totalSupply.sub(_value);
304         totalDistributed = totalDistributed.sub(_value);
305         emit Burn(burner, _value);
306     }
307     
308     function add(uint256 _value) onlyOwner public {
309         uint256 counter = totalSupply.add(_value);
310         totalSupply = counter; 
311         emit Add(_value);
312     }
313     
314     
315     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
316         ForeignToken token = ForeignToken(_tokenContract);
317         uint256 amount = token.balanceOf(address(this));
318         return token.transfer(owner, amount);
319     }
320 }