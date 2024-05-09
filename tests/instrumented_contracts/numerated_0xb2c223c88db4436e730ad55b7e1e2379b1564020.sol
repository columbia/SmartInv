1 pragma solidity ^0.4.25;
2 
3 //Social media platforms
4 //https://dizoolcloud.com/
5 //https://twitter.com/DIZOOLTOKEN
6 //https://t.me/DIZOOL
7 //https://medium.com/@DIZOOLTOKEN
8 //https://github.com/DIZOOL-DZL
9 //https://dizoolcloud.com/home/WhitePaperDZL.pdf
10 
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract ForeignToken {
41     function balanceOf(address _owner) constant public returns (uint256);
42     function transfer(address _to, uint256 _value) public returns (bool);
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract DIZOOLCLOUD is ERC20 {
60     
61     using SafeMath for uint256;
62     address owner = msg.sender;
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     mapping (address => bool) public Claimed; 
67 
68     string public constant name = "DIZOOL CLOUD";
69     string public constant symbol = "DZL";
70     uint public constant decimals = 18;
71     uint public deadline = now + 360 * 1 days;
72     uint public round2 = now + 180 * 1 days;
73     uint public round1 = now + 180 * 1 days;
74     
75     uint256 public totalSupply = 600000000e18;
76     uint256 public totalDistributed;
77     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
78     uint256 public tokensPerEth = 100000e18;
79     
80     uint public target0drop = 1000;
81     uint public progress0drop = 0;
82     
83     address multisig = 0xC613D2aad28E8F3B63Ff5Ac736950D69a7f7841b;
84 
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91     
92     event Airdrop(address indexed _owner, uint _amount, uint _balance);
93 
94     event TokensPerEthUpdated(uint _tokensPerEth);
95     
96     event Burn(address indexed burner, uint256 value);
97     
98     event Add(uint256 value);
99 
100     bool public distributionFinished = false;
101     
102     modifier canDistr() {
103         require(!distributionFinished);
104         _;
105     }
106     
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111     
112     constructor() public {
113         uint256 teamFund = 300000000e18;
114         owner = msg.sender;
115         distr(owner, teamFund);
116     }
117     
118     function transferOwnership(address newOwner) onlyOwner public {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123 
124     function finishDistribution() onlyOwner canDistr public returns (bool) {
125         distributionFinished = true;
126         emit DistrFinished();
127         return true;
128     }
129     
130     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
131         totalDistributed = totalDistributed.add(_amount);        
132         balances[_to] = balances[_to].add(_amount);
133         emit Distr(_to, _amount);
134         emit Transfer(address(0), _to, _amount);
135 
136         return true;
137     }
138     
139     function Distribute(address _participant, uint _amount) onlyOwner internal {
140 
141         require( _amount > 0 );      
142         require( totalDistributed < totalSupply );
143         balances[_participant] = balances[_participant].add(_amount);
144         totalDistributed = totalDistributed.add(_amount);
145 
146         if (totalDistributed >= totalSupply) {
147             distributionFinished = true;
148         }
149         
150         emit Airdrop(_participant, _amount, balances[_participant]);
151         emit Transfer(address(0), _participant, _amount);
152     }
153     
154     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
155         Distribute(_participant, _amount);
156     }
157 
158     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
159         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
160     }
161 
162     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
163         tokensPerEth = _tokensPerEth;
164         emit TokensPerEthUpdated(_tokensPerEth);
165     }
166            
167     function () external payable {
168         getTokens();
169      }
170 
171     function getTokens() payable canDistr  public {
172         uint256 tokens = 0;
173         uint256 bonus = 0;
174         uint256 countbonus = 0;
175         uint256 bonusCond1 = 1 ether / 2;
176         uint256 bonusCond2 = 1 ether;
177         uint256 bonusCond3 = 3 ether;
178 
179         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
180         address investor = msg.sender;
181 
182         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
183             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
184                 countbonus = tokens * 2 / 100;
185             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
186                 countbonus = tokens * 4 / 100;
187             }else if(msg.value >= bonusCond3){
188                 countbonus = tokens * 6 / 100;
189             }
190         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
191             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
192                 countbonus = tokens * 4 / 100;
193             }else if(msg.value >= bonusCond3){
194                 countbonus = tokens * 6 / 100;
195             }
196         }else{
197             countbonus = 0;
198         }
199 
200         bonus = tokens + countbonus;
201         
202         if (tokens == 0) {
203             uint256 valdrop = 20e18;
204             if (Claimed[investor] == false && progress0drop <= target0drop ) {
205                 distr(investor, valdrop);
206                 Claimed[investor] = true;
207                 progress0drop++;
208             }else{
209                 require( msg.value >= requestMinimum );
210             }
211         }else if(tokens > 0 && msg.value >= requestMinimum){
212             if( now >= deadline && now >= round1 && now < round2){
213                 distr(investor, tokens);
214             }else{
215                 if(msg.value >= bonusCond1){
216                     distr(investor, bonus);
217                 }else{
218                     distr(investor, tokens);
219                 }   
220             }
221         }else{
222             require( msg.value >= requestMinimum );
223         }
224 
225         if (totalDistributed >= totalSupply) {
226             distributionFinished = true;
227         }
228         
229         multisig.transfer(msg.value);
230     }
231     
232     function balanceOf(address _owner) constant public returns (uint256) {
233         return balances[_owner];
234     }
235 
236     modifier onlyPayloadSize(uint size) {
237         assert(msg.data.length >= size + 4);
238         _;
239     }
240     
241     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
242 
243         require(_to != address(0));
244         require(_amount <= balances[msg.sender]);
245         
246         balances[msg.sender] = balances[msg.sender].sub(_amount);
247         balances[_to] = balances[_to].add(_amount);
248         emit Transfer(msg.sender, _to, _amount);
249         return true;
250     }
251     
252     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
253 
254         require(_to != address(0));
255         require(_amount <= balances[_from]);
256         require(_amount <= allowed[_from][msg.sender]);
257         
258         balances[_from] = balances[_from].sub(_amount);
259         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
260         balances[_to] = balances[_to].add(_amount);
261         emit Transfer(_from, _to, _amount);
262         return true;
263     }
264     
265     function approve(address _spender, uint256 _value) public returns (bool success) {
266         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
267         allowed[msg.sender][_spender] = _value;
268         emit Approval(msg.sender, _spender, _value);
269         return true;
270     }
271     
272     function allowance(address _owner, address _spender) constant public returns (uint256) {
273         return allowed[_owner][_spender];
274     }
275     
276     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
277         ForeignToken t = ForeignToken(tokenAddress);
278         uint bal = t.balanceOf(who);
279         return bal;
280     }
281     
282     function withdrawAll() onlyOwner public {
283         address myAddress = this;
284         uint256 etherBalance = myAddress.balance;
285         owner.transfer(etherBalance);
286     }
287 
288     function withdraw(uint256 _wdamount) onlyOwner public {
289         uint256 wantAmount = _wdamount;
290         owner.transfer(wantAmount);
291     }
292 
293     function burn(uint256 _value) onlyOwner public {
294         require(_value <= balances[msg.sender]);
295         address burner = msg.sender;
296         balances[burner] = balances[burner].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         totalDistributed = totalDistributed.sub(_value);
299         emit Burn(burner, _value);
300     }
301     
302     function add(uint256 _value) onlyOwner public {
303         uint256 counter = totalSupply.add(_value);
304         totalSupply = counter; 
305         emit Add(_value);
306     }
307     
308     
309     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
310         ForeignToken token = ForeignToken(_tokenContract);
311         uint256 amount = token.balanceOf(address(this));
312         return token.transfer(owner, amount);
313     }
314 }