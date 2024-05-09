1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Energem  Project
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
67 contract Energem is ERC20 {
68     
69     using SafeMath for uint256;
70     address owner = msg.sender;
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public Claimed; 
75 
76     string public constant name = "Energem";
77     string public constant symbol = "NRGM";
78     uint public constant decimals = 18;
79     uint public deadline = now + 37 * 1 days;
80     uint public round2 = now + 32 * 1 days;
81     uint public round1 = now + 22 * 1 days;
82     
83     uint256 public totalSupply = 3000000000e18;
84     uint256 public totalDistributed;
85     uint256 public constant requestMinimum = 1 ether / 200; // 0.005 Ether
86     uint256 public tokensPerEth = 250000e18;
87     
88     //here u will write your ether address
89     address multisig = 0x9990e0fD09274f1Ff7b43175b0Ee917071Ef5d01
90     ;
91 
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95     
96     event Distr(address indexed to, uint256 amount);
97     event DistrFinished();
98 
99     event TokensPerEthUpdated(uint _tokensPerEth);
100     
101     event Burn(address indexed burner, uint256 value);
102     
103     event Add(uint256 value);
104 
105     bool public distributionFinished = false;
106     
107     modifier canDistr() {
108         require(!distributionFinished);
109         _;
110     }
111     
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     constructor() public {
118         uint256 teamFund = 1000000000e18;
119         owner = msg.sender;
120         distr(owner, teamFund);
121     }
122     
123     function transferOwnership(address newOwner) onlyOwner public {
124         if (newOwner != address(0)) {
125             owner = newOwner;
126         }
127     }
128 
129     function finishDistribution() onlyOwner canDistr public returns (bool) {
130         distributionFinished = true;
131         emit DistrFinished();
132         return true;
133     }
134     
135     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
136         totalDistributed = totalDistributed.add(_amount);        
137         balances[_to] = balances[_to].add(_amount);
138         emit Distr(_to, _amount);
139         emit Transfer(address(0), _to, _amount);
140 
141         return true;
142     }
143     
144     function Distribute(address _participant, uint _amount) onlyOwner internal {
145 
146         require( _amount > 0 );      
147         require( totalDistributed < totalSupply );
148         balances[_participant] = balances[_participant].add(_amount);
149         totalDistributed = totalDistributed.add(_amount);
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154 
155         // log
156         emit Transfer(address(0), _participant, _amount);
157     }
158 
159     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
160         tokensPerEth = _tokensPerEth;
161         emit TokensPerEthUpdated(_tokensPerEth);
162     }
163            
164     function () external payable {
165         getTokens();
166      }
167 
168     function getTokens() payable canDistr  public {
169         uint256 tokens = 0;
170         uint256 bonus = 0;
171         uint256 countbonus = 0;
172         uint256 bonusCond1 = 1 ether / 10;
173         uint256 bonusCond2 = 1 ether;
174         uint256 bonusCond3 = 5 ether;
175 
176         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
177         address investor = msg.sender;
178 
179         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
180             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
181                 countbonus = tokens * 10 / 100;
182             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
183                 countbonus = tokens * 20 / 100;
184             }else if(msg.value >= bonusCond3){
185                 countbonus = tokens * 35 / 100;
186             }
187         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
188             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
189                 countbonus = tokens * 20 / 100;
190             }else if(msg.value >= bonusCond3){
191                 countbonus = tokens * 35 / 100;
192             }
193         }else{
194             countbonus = 0;
195         }
196 
197         bonus = tokens + countbonus;
198         
199         if(tokens > 0 && msg.value >= requestMinimum){
200             if( now >= deadline && now >= round1 && now < round2){
201                 distr(investor, tokens);
202             }else{
203                 if(msg.value >= bonusCond1){
204                     distr(investor, bonus);
205                 }else{
206                     distr(investor, tokens);
207                 }   
208             }
209         }else{
210             require( msg.value >= requestMinimum );
211         }
212 
213         if (totalDistributed >= totalSupply) {
214             distributionFinished = true;
215         }
216         
217         //here we will send all wei to your address
218         multisig.transfer(msg.value);
219     }
220     
221     function balanceOf(address _owner) constant public returns (uint256) {
222         return balances[_owner];
223     }
224 
225     modifier onlyPayloadSize(uint size) {
226         assert(msg.data.length >= size + 4);
227         _;
228     }
229     
230     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
231 
232         require(_to != address(0));
233         require(_amount <= balances[msg.sender]);
234         
235         balances[msg.sender] = balances[msg.sender].sub(_amount);
236         balances[_to] = balances[_to].add(_amount);
237         emit Transfer(msg.sender, _to, _amount);
238         return true;
239     }
240     
241     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
242 
243         require(_to != address(0));
244         require(_amount <= balances[_from]);
245         require(_amount <= allowed[_from][msg.sender]);
246         
247         balances[_from] = balances[_from].sub(_amount);
248         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
249         balances[_to] = balances[_to].add(_amount);
250         emit Transfer(_from, _to, _amount);
251         return true;
252     }
253     
254     function approve(address _spender, uint256 _value) public returns (bool success) {
255         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
256         allowed[msg.sender][_spender] = _value;
257         emit Approval(msg.sender, _spender, _value);
258         return true;
259     }
260     
261     function allowance(address _owner, address _spender) constant public returns (uint256) {
262         return allowed[_owner][_spender];
263     }
264     
265     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
266         ForeignToken t = ForeignToken(tokenAddress);
267         uint bal = t.balanceOf(who);
268         return bal;
269     }
270     
271     function withdrawAll() onlyOwner public {
272         address myAddress = this;
273         uint256 etherBalance = myAddress.balance;
274         owner.transfer(etherBalance);
275     }
276 
277     function withdraw(uint256 _wdamount) onlyOwner public {
278         uint256 wantAmount = _wdamount;
279         owner.transfer(wantAmount);
280     }
281 
282     function burn(uint256 _value) onlyOwner public {
283         require(_value <= balances[msg.sender]);
284         address burner = msg.sender;
285         balances[burner] = balances[burner].sub(_value);
286         totalSupply = totalSupply.sub(_value);
287         totalDistributed = totalDistributed.sub(_value);
288         emit Burn(burner, _value);
289     }
290     
291     function add(uint256 _value) onlyOwner public {
292         uint256 counter = totalSupply.add(_value);
293         totalSupply = counter; 
294         emit Add(_value);
295     }
296     
297     
298     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
299         ForeignToken token = ForeignToken(_tokenContract);
300         uint256 amount = token.balanceOf(address(this));
301         return token.transfer(owner, amount);
302     }
303 }