1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ForeignToken {
31     function balanceOf(address _owner) constant public returns (uint256);
32     function transfer(address _to, uint256 _value) public returns (bool);
33 }
34 
35 contract ERC20Basic {
36     uint256 public totalSupply;
37     function balanceOf(address who) public constant returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Alien_Economic is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56     mapping (address => bool) public Claimed; 
57 
58     string public constant name = "Alien Economic";
59     string public constant symbol = "AEC";
60     uint public constant decimals = 18;
61     uint public deadline = now + 45 * 1 days;
62     uint public round2 = now + 45 * 1 days;
63     uint public round1 = now + 30 * 1 days;
64     
65     uint256 public totalSupply = 26896423e18;
66     uint256 public totalDistributed;
67     uint256 public constant requestMinimum = 1 ether / 10000;
68     uint256 public tokensPerEth = 30000e18;
69     
70     uint public target0drop = 100000;
71     uint public progress0drop = 0;
72     
73     address multisig = 0xf2Fa88c2C8C3DD4349D9231377BE6743ce1812Be;
74 
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78     
79     event Distr(address indexed to, uint256 amount);
80     event DistrFinished();
81     
82     event Airdrop(address indexed _owner, uint _amount, uint _balance);
83 
84     event TokensPerEthUpdated(uint _tokensPerEth);
85     
86     event Burn(address indexed burner, uint256 value);
87     
88     event Add(uint256 value);
89 
90     bool public distributionFinished = false;
91     
92     modifier canDistr() {
93         require(!distributionFinished);
94         _;
95     }
96     
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101     
102     constructor() public {
103         uint256 teamFund = 6666666e18;
104         owner = msg.sender;
105         distr(owner, teamFund);
106     }
107     
108     function transferOwnership(address newOwner) onlyOwner public {
109         if (newOwner != address(0)) {
110             owner = newOwner;
111         }
112     }
113 
114     function finishDistribution() onlyOwner canDistr public returns (bool) {
115         distributionFinished = true;
116         emit DistrFinished();
117         return true;
118     }
119     
120     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
121         totalDistributed = totalDistributed.add(_amount);        
122         balances[_to] = balances[_to].add(_amount);
123         emit Distr(_to, _amount);
124         emit Transfer(address(0), _to, _amount);
125 
126         return true;
127     }
128     
129     function Distribute(address _participant, uint _amount) onlyOwner internal {
130 
131         require( _amount > 0 );      
132         require( totalDistributed < totalSupply );
133         balances[_participant] = balances[_participant].add(_amount);
134         totalDistributed = totalDistributed.add(_amount);
135 
136         if (totalDistributed >= totalSupply) {
137             distributionFinished = true;
138         }
139 
140         emit Airdrop(_participant, _amount, balances[_participant]);
141         emit Transfer(address(0), _participant, _amount);
142     }
143     
144     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
145         Distribute(_participant, _amount);
146     }
147 
148     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
149         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
150     }
151 
152     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
153         tokensPerEth = _tokensPerEth;
154         emit TokensPerEthUpdated(_tokensPerEth);
155     }
156            
157     function () external payable {
158         getTokens();
159      }
160 
161     function getTokens() payable canDistr  public {
162         uint256 tokens = 0;
163         uint256 bonus = 0;
164         uint256 countbonus = 0;
165         uint256 bonusCond1 = 1 ether / 10;
166         uint256 bonusCond2 = 5 ether / 10;
167         uint256 bonusCond3 = 1 ether;
168 
169         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
170         address investor = msg.sender;
171 
172         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
173             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
174                 countbonus = tokens * 10 / 100;
175             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
176                 countbonus = tokens * 20 / 100;
177             }else if(msg.value >= bonusCond3){
178                 countbonus = tokens * 35 / 100;
179             }
180         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
181             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
182                 countbonus = tokens * 2 / 100;
183             }else if(msg.value >= bonusCond3){
184                 countbonus = tokens * 3 / 100;
185             }
186         }else{
187             countbonus = 0;
188         }
189 
190         bonus = tokens + countbonus;
191         
192         if (tokens == 0) {
193             uint256 valdrop = 2e18;
194             if (Claimed[investor] == false && progress0drop <= target0drop ) {
195                 distr(investor, valdrop);
196                 Claimed[investor] = true;
197                 progress0drop++;
198             }else{
199                 require( msg.value >= requestMinimum );
200             }
201         }else if(tokens > 0 && msg.value >= requestMinimum){
202             if( now >= deadline && now >= round1 && now < round2){
203                 distr(investor, tokens);
204             }else{
205                 if(msg.value >= bonusCond1){
206                     distr(investor, bonus);
207                 }else{
208                     distr(investor, tokens);
209                 }   
210             }
211         }else{
212             require( msg.value >= requestMinimum );
213         }
214 
215         if (totalDistributed >= totalSupply) {
216             distributionFinished = true;
217         }
218         
219         multisig.transfer(msg.value);
220     }
221     
222     function balanceOf(address _owner) constant public returns (uint256) {
223         return balances[_owner];
224     }
225 
226     modifier onlyPayloadSize(uint size) {
227         assert(msg.data.length >= size + 4);
228         _;
229     }
230     
231     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
232 
233         require(_to != address(0));
234         require(_amount <= balances[msg.sender]);
235         
236         balances[msg.sender] = balances[msg.sender].sub(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         emit Transfer(msg.sender, _to, _amount);
239         return true;
240     }
241     
242     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
243 
244         require(_to != address(0));
245         require(_amount <= balances[_from]);
246         require(_amount <= allowed[_from][msg.sender]);
247         
248         balances[_from] = balances[_from].sub(_amount);
249         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
250         balances[_to] = balances[_to].add(_amount);
251         emit Transfer(_from, _to, _amount);
252         return true;
253     }
254     
255     function approve(address _spender, uint256 _value) public returns (bool success) {
256         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
257         allowed[msg.sender][_spender] = _value;
258         emit Approval(msg.sender, _spender, _value);
259         return true;
260     }
261     
262     function allowance(address _owner, address _spender) constant public returns (uint256) {
263         return allowed[_owner][_spender];
264     }
265     
266     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
267         ForeignToken t = ForeignToken(tokenAddress);
268         uint bal = t.balanceOf(who);
269         return bal;
270     }
271     
272     function withdrawAll() onlyOwner public {
273         address myAddress = this;
274         uint256 etherBalance = myAddress.balance;
275         owner.transfer(etherBalance);
276     }
277 
278     function withdraw(uint256 _wdamount) onlyOwner public {
279         uint256 wantAmount = _wdamount;
280         owner.transfer(wantAmount);
281     }
282 
283     function burn(uint256 _value) onlyOwner public {
284         require(_value <= balances[msg.sender]);
285         address burner = msg.sender;
286         balances[burner] = balances[burner].sub(_value);
287         totalSupply = totalSupply.sub(_value);
288         totalDistributed = totalDistributed.sub(_value);
289         emit Burn(burner, _value);
290     }
291     
292     function add(uint256 _value) onlyOwner public {
293         uint256 counter = totalSupply.add(_value);
294         totalSupply = counter; 
295         emit Add(_value);
296     }
297     
298     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
299         ForeignToken token = ForeignToken(_tokenContract);
300         uint256 amount = token.balanceOf(address(this));
301         return token.transfer(owner, amount);
302     }
303 }