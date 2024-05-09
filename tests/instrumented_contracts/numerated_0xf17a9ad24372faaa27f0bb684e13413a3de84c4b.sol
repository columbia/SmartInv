1 pragma solidity ^0.4.25;
2 /**
3  //This Contract Migration From SmokeCoin(you can Check OldContract https://etherscan.io/token/0x84ff1ecf963dbe51a91c7310edce3a4243da3370)
4 //SmokeCoin Lincense by SmokeCoin
5 //Website (https://www.SmokeCoin.xyz)
6 //
7 /**
8 
9 /**
10  * @title  Project
11  * SmokeCoinV_2
12  * this migration From SmokeCoin
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract ForeignToken {
57     function balanceOf(address _owner) constant public returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59 }
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public constant returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract SmokeCoinV_2 is ERC20 {
76     
77     using SafeMath for uint256;
78     address owner = msg.sender;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     mapping (address => bool) public Claimed; 
83 
84     string public constant name = "SmokeCoinV_2";
85     string public constant symbol = "SMKC";
86     uint public constant decimals = 8;
87     uint public deadline = now + 200 * 1 days;
88     uint public round2 = now + 50 * 1 days;
89     uint public round1 = now + 150 * 1 days;
90     
91     uint256 public totalSupply = 754654e8;
92     uint256 public totalDistributed;
93     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
94     uint256 public tokensPerEth = 22220000000;
95     
96     uint public target0drop = 4222;
97     uint public progress0drop = 0;
98     
99     //here u will write your ether address
100     address multisig = 0xb7Ef2B8514A27bf63e8F5397Fd6DBDCa95809883;
101 
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     
106     event Distr(address indexed to, uint256 amount);
107     event DistrFinished();
108     
109     event Airdrop(address indexed _owner, uint _amount, uint _balance);
110 
111     event TokensPerEthUpdated(uint _tokensPerEth);
112     
113     event Burn(address indexed burner, uint256 value);
114     
115     event Add(uint256 value);
116 
117     bool public distributionFinished = false;
118     
119     modifier canDistr() {
120         require(!distributionFinished);
121         _;
122     }
123     
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128     
129     constructor() public {
130         uint256 teamFund = 5690000000000;
131         owner = msg.sender;
132         distr(owner, teamFund);
133     }
134     
135     function transferOwnership(address newOwner) onlyOwner public {
136         if (newOwner != address(0)) {
137             owner = newOwner;
138         }
139     }
140 
141     function finishDistribution() onlyOwner canDistr public returns (bool) {
142         distributionFinished = true;
143         emit DistrFinished();
144         return true;
145     }
146     
147     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
148         totalDistributed = totalDistributed.add(_amount);        
149         balances[_to] = balances[_to].add(_amount);
150         emit Distr(_to, _amount);
151         emit Transfer(address(0), _to, _amount);
152 
153         return true;
154     }
155     
156     function Distribute(address _participant, uint _amount) onlyOwner internal {
157 
158         require( _amount > 0 );      
159         require( totalDistributed < totalSupply );
160         balances[_participant] = balances[_participant].add(_amount);
161         totalDistributed = totalDistributed.add(_amount);
162 
163         if (totalDistributed >= totalSupply) {
164             distributionFinished = true;
165         }
166 
167         // log
168         emit Airdrop(_participant, _amount, balances[_participant]);
169         emit Transfer(address(0), _participant, _amount);
170     }
171     
172     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
173         Distribute(_participant, _amount);
174     }
175 
176     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
177         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
178     }
179 
180     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
181         tokensPerEth = _tokensPerEth;
182         emit TokensPerEthUpdated(_tokensPerEth);
183     }
184            
185     function () external payable {
186         getTokens();
187      }
188 
189     function getTokens() payable canDistr  public {
190         uint256 tokens = 0;
191         uint256 bonus = 0;
192         uint256 countbonus = 0;
193         uint256 bonusCond1 = 1 ether / 10;
194         uint256 bonusCond2 = 5 ether / 10;
195         uint256 bonusCond3 = 1 ether;
196 
197         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
198         address investor = msg.sender;
199 
200         if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {
201             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
202                 countbonus = tokens * 10 / 100;
203             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
204                 countbonus = tokens * 20 / 100;
205             }else if(msg.value >= bonusCond3){
206                 countbonus = tokens * 35 / 100;
207             }
208         }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){
209             if(msg.value >= bonusCond2 && msg.value < bonusCond3){
210                 countbonus = tokens * 2 / 100;
211             }else if(msg.value >= bonusCond3){
212                 countbonus = tokens * 3 / 100;
213             }
214         }else{
215             countbonus = 0;
216         }
217 
218         bonus = tokens + countbonus;
219         
220         if (tokens == 0) {
221             uint256 valdrop = 20000000;
222             if (Claimed[investor] == false && progress0drop <= target0drop ) {
223                 distr(investor, valdrop);
224                 Claimed[investor] = true;
225                 progress0drop++;
226             }else{
227                 require( msg.value >= requestMinimum );
228             }
229         }else if(tokens > 0 && msg.value >= requestMinimum){
230             if( now >= deadline && now >= round1 && now < round2){
231                 distr(investor, tokens);
232             }else{
233                 if(msg.value >= bonusCond1){
234                     distr(investor, bonus);
235                 }else{
236                     distr(investor, tokens);
237                 }   
238             }
239         }else{
240             require( msg.value >= requestMinimum );
241         }
242 
243         if (totalDistributed >= totalSupply) {
244             distributionFinished = true;
245         }
246         
247         //here we will send all wei to your address
248         multisig.transfer(msg.value);
249     }
250     
251     function balanceOf(address _owner) constant public returns (uint256) {
252         return balances[_owner];
253     }
254 
255     modifier onlyPayloadSize(uint size) {
256         assert(msg.data.length >= size + 4);
257         _;
258     }
259     
260     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
261 
262         require(_to != address(0));
263         require(_amount <= balances[msg.sender]);
264         
265         balances[msg.sender] = balances[msg.sender].sub(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         emit Transfer(msg.sender, _to, _amount);
268         return true;
269     }
270     
271     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
272 
273         require(_to != address(0));
274         require(_amount <= balances[_from]);
275         require(_amount <= allowed[_from][msg.sender]);
276         
277         balances[_from] = balances[_from].sub(_amount);
278         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
279         balances[_to] = balances[_to].add(_amount);
280         emit Transfer(_from, _to, _amount);
281         return true;
282     }
283     
284     function approve(address _spender, uint256 _value) public returns (bool success) {
285         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
286         allowed[msg.sender][_spender] = _value;
287         emit Approval(msg.sender, _spender, _value);
288         return true;
289     }
290     
291     function allowance(address _owner, address _spender) constant public returns (uint256) {
292         return allowed[_owner][_spender];
293     }
294     
295     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
296         ForeignToken t = ForeignToken(tokenAddress);
297         uint bal = t.balanceOf(who);
298         return bal;
299     }
300     
301     function withdrawAll() onlyOwner public {
302         address myAddress = this;
303         uint256 etherBalance = myAddress.balance;
304         owner.transfer(etherBalance);
305     }
306 
307     function withdraw(uint256 _wdamount) onlyOwner public {
308         uint256 wantAmount = _wdamount;
309         owner.transfer(wantAmount);
310     }
311 
312     function burn(uint256 _value) onlyOwner public {
313         require(_value <= balances[msg.sender]);
314         address burner = msg.sender;
315         balances[burner] = balances[burner].sub(_value);
316         totalSupply = totalSupply.sub(_value);
317         totalDistributed = totalDistributed.sub(_value);
318         emit Burn(burner, _value);
319     }
320     
321     function add(uint256 _value) onlyOwner public {
322         uint256 counter = totalSupply.add(_value);
323         totalSupply = counter; 
324         emit Add(_value);
325     }
326     
327     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
328         ForeignToken token = ForeignToken(_tokenContract);
329         uint256 amount = token.balanceOf(address(this));
330         return token.transfer(owner, amount);
331     }
332 }