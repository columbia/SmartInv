1 pragma solidity ^0.4.18;
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
68 contract Labtorum is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;    
75 
76     string public constant name = "Labtorum";
77     string public constant symbol = "LTR";
78     uint public constant decimals = 8;
79     uint public deadline = now + 50 * 1 days;
80     uint public presaledeadline = now + 15 * 1 days;
81     
82     uint256 public totalSupply = 3000000000e8;
83     uint256 public totalDistributed;    
84     uint256 public constant requestMinimum = 1 ether / 500; // 0.005 Ether
85     uint256 public tokensPerEth = 300000e8;
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     
90     event Distr(address indexed to, uint256 amount);
91     event DistrFinished();
92     
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96     
97     event Burn(uint256 value);
98 
99     bool public distributionFinished = false;
100     
101     modifier canDistr() {
102         require(!distributionFinished);
103         _;
104     }
105     
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110     
111     function transferOwnership(address newOwner) onlyOwner public {
112         if (newOwner != address(0)) {
113             owner = newOwner;
114         }
115     }
116 
117     function finishDistribution() onlyOwner canDistr public returns (bool) {
118         distributionFinished = true;
119         emit DistrFinished();
120         return true;
121     }
122     
123     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
124         totalDistributed = totalDistributed.add(_amount);        
125         balances[_to] = balances[_to].add(_amount);
126         emit Distr(_to, _amount);
127         emit Transfer(address(0), _to, _amount);
128 
129         return true;
130     }
131     
132     function Distribute(address _participant, uint _amount) onlyOwner internal {
133 
134         require( _amount > 0 );      
135         require( totalDistributed < totalSupply );
136         balances[_participant] = balances[_participant].add(_amount);
137         totalDistributed = totalDistributed.add(_amount);
138 
139         if (totalDistributed >= totalSupply) {
140             distributionFinished = true;
141         }
142 
143         // log
144         emit Airdrop(_participant, _amount, balances[_participant]);
145         emit Transfer(address(0), _participant, _amount);
146     }
147     
148     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
149         Distribute(_participant, _amount);
150     }
151 
152     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
153         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
154     }
155 
156     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
157         tokensPerEth = _tokensPerEth;
158         emit TokensPerEthUpdated(_tokensPerEth);
159     }
160            
161     function () external payable {
162         getTokens();
163      }
164 
165     function getTokens() payable canDistr  public {
166         uint256 tokens = 0;
167         uint256 bonus = 0;
168         uint256 countbonus = 0;
169         uint256 bonusCond1 = 1 ether / 100;
170         uint256 bonusCond2 = 1 ether / 5;
171         uint256 bonusCond3 = 1 ether;
172         uint256 bonusCond4 = 1 ether * 5;
173         uint256 bonusCond5 = 1 ether * 10;
174 
175         require( msg.value >= requestMinimum );
176         require( msg.value > 0 );
177 
178         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
179         address investor = msg.sender;
180 
181         if (now < deadline && now < presaledeadline) {  //for pre ico
182             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
183                 countbonus = tokens * 10 / 100;
184             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
185                 countbonus = tokens * 20 / 100;
186             }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){
187                 countbonus = tokens * 30 / 100;
188             }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
189                 countbonus = tokens * 40 / 100;
190             }else if(msg.value >= bonusCond5){
191                 countbonus = tokens * 50 / 100;
192             }
193         }else if(now < deadline && now > presaledeadline){ //for ico
194             if(msg.value >= bonusCond3 && msg.value < bonusCond4){
195                 countbonus = tokens * 20 / 100; 
196             }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){
197                 countbonus = tokens * 25 / 100;
198             }else if(msg.value >= bonusCond5){
199                 countbonus = tokens * 30 / 100;
200             }
201         }else{
202             countbonus = 0;
203         }
204 
205         bonus = tokens + countbonus;
206         
207         if (tokens > 0) {
208             if( now >= deadline && now >= presaledeadline){
209                 distr(investor, tokens);
210             }else{
211                 if(msg.value >= bonusCond1){
212                     distr(investor, bonus);
213                 }else{
214                     distr(investor, tokens);
215                 }   
216             }
217         }
218 
219         if (totalDistributed >= totalSupply) {
220             distributionFinished = true;
221         }
222     }
223     
224     function balanceOf(address _owner) constant public returns (uint256) {
225         return balances[_owner];
226     }
227 
228     modifier onlyPayloadSize(uint size) {
229         assert(msg.data.length >= size + 4);
230         _;
231     }
232     
233     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
234 
235         require(_to != address(0));
236         require(_amount <= balances[msg.sender]);
237         
238         balances[msg.sender] = balances[msg.sender].sub(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         emit Transfer(msg.sender, _to, _amount);
241         return true;
242     }
243     
244     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
245 
246         require(_to != address(0));
247         require(_amount <= balances[_from]);
248         require(_amount <= allowed[_from][msg.sender]);
249         
250         balances[_from] = balances[_from].sub(_amount);
251         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
252         balances[_to] = balances[_to].add(_amount);
253         emit Transfer(_from, _to, _amount);
254         return true;
255     }
256     
257     function approve(address _spender, uint256 _value) public returns (bool success) {
258         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263     
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267     
268     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
269         ForeignToken t = ForeignToken(tokenAddress);
270         uint bal = t.balanceOf(who);
271         return bal;
272     }
273     
274     function withdrawAll() onlyOwner public {
275         address myAddress = this;
276         uint256 etherBalance = myAddress.balance;
277         owner.transfer(etherBalance);
278     }
279 
280     function withdraw(uint256 _wdamount) onlyOwner public {
281         uint256 wantAmount = _wdamount;
282         owner.transfer(wantAmount);
283     }
284 
285     function burn(uint256 _value) onlyOwner public {
286         uint256 cek = totalSupply - totalDistributed;
287         require(_value <= cek);
288         uint256 counter = totalDistributed + totalSupply.sub(_value) - totalDistributed;
289         totalSupply = counter; 
290         emit Burn(_value);
291     }
292     
293     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
294         ForeignToken token = ForeignToken(_tokenContract);
295         uint256 amount = token.balanceOf(address(this));
296         return token.transfer(owner, amount);
297     }
298 }