1 pragma solidity 0.4.25;
2    
3     /**
4      * @title SafeMath
5      * @dev Math operations with safety checks that throw on error
6      */
7     library SafeMath {
8       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10           return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15       }
16     
17       function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22       }
23     
24       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27       }
28     
29       function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33       }
34     }
35     
36     contract ForeignToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 contract PikToken is ERC20 {
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public frozenAccount;
63 
64     string public constant name = "Pik Token";
65     string public constant symbol = "PIK";
66     uint public constant decimals = 8;
67     
68         uint256 public totalSupply          = 20000000000e8;
69         uint256 public tokensForSale        = 10000000000e8;
70         uint256 public totalDistributed;
71         uint256 public totalTokenSold; 
72         uint256 public totalWeiReceived;
73         uint256 public constant requestMinimum = 1 ether / 100;
74         uint256 public tokensPerEth = 20000000e8;
75         uint public deadline = 9999999999999;
76         uint public round1   = 99999999999;
77         
78         address public teamWallet = 0xa269a3109521B03991691646575e9F3438aB3164;
79         address public ownerWallet = 0x0f02529A5DB2bf4f5c0871f089B5C63E20ea0749;
80         address public advisorWallet = 0xfB167e1aDcea5932Ac77E0E1E7ED5FbE3Fb3B5F1;
81         address public developmentWallet = 0xcCA255aE8E85E1bD8264Fa9d03eB5CdaA3A344bb;
82         address public marketingWallet = 0x1d4c855Dc093e4558341b77bEcb9234FCc2A6fdb;
83         
84         address multisig = 0xF37dFcB77574Ab8CaDC4C6AE636AF42704135Aab;
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91     event ICOStarted();
92     
93     event Airdrop(address indexed _owner, uint _amount, uint _balance);
94 
95     event TokensPerEthUpdated(uint _tokensPerEth);
96     event FrozenFunds(address target, bool frozen);
97     
98 
99     bool public distributionFinished = false;
100     bool public icoStarted = false;
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
113         owner = msg.sender;
114     }
115     
116     function transferOwnership(address newOwner) onlyOwner public {
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121     
122     function startICO() onlyOwner public returns (bool) {
123         icoStarted = true;
124         distributionFinished = false;
125         emit ICOStarted();
126         return true;
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
144     function doAirdrop(address _participant, uint _amount) internal {
145 
146         require( _amount > 0 );      
147 
148         require( totalDistributed < totalSupply );
149         
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
162     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
163         doAirdrop(_participant, _amount);
164     }
165 
166     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
167         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
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
180         require(icoStarted);
181         uint256 tokens = 0;
182         uint256 bonus = 0;
183         uint256 countbonus = 0;
184         uint256 bonusCond1 = 1 ether;
185         uint256 bonusCond2 = 5 ether;
186         uint256 bonusCond3 = 10 ether;
187 
188         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
189         address investor = msg.sender;
190 
191         if (msg.value >= requestMinimum && now < deadline && now < round1) {
192             if(msg.value >= bonusCond1 && msg.value < bonusCond2){
193                 countbonus = tokens * 10 / 100;
194             }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){
195                 countbonus = tokens * 15 / 100;
196             }else if(msg.value >= bonusCond3){
197                 countbonus = tokens * 20 / 100;
198             }
199         }else{
200             countbonus = 0;
201         }
202 
203         bonus = tokens + countbonus;
204         
205          if (tokens > 0 && msg.value >= requestMinimum){
206             if( now >= deadline && now >= round1){
207                 distr(investor, tokens);
208                 totalWeiReceived = totalWeiReceived.add(msg.value);
209                 totalTokenSold = totalTokenSold.add(tokens);
210             }else{
211                 if(msg.value >= bonusCond1){
212                     distr(investor, bonus);
213                     totalWeiReceived = totalWeiReceived.add(msg.value);
214                     totalTokenSold = totalTokenSold.add(tokens);
215                 }else{
216                     distr(investor, tokens);
217                     totalWeiReceived = totalWeiReceived.add(msg.value);
218                     totalTokenSold = totalTokenSold.add(tokens);
219                 }   
220             }
221         }else{
222             require( msg.value >= requestMinimum );
223             
224         }
225 
226         if (totalTokenSold >= tokensForSale) {
227             distributionFinished = true;
228         }
229         
230          multisig.transfer(msg.value);
231     }
232     
233     function balanceOf(address _owner) constant public returns (uint256) {
234         return balances[_owner];
235     }
236 
237     modifier onlyPayloadSize(uint size) {
238         assert(msg.data.length >= size + 4);
239         _;
240     }
241     
242     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
243         if (frozenAccount[msg.sender]) return false;
244         require(_to != address(0));
245         require(_amount <= balances[msg.sender]);
246         
247         balances[msg.sender] = balances[msg.sender].sub(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Transfer(msg.sender, _to, _amount);
250         return true;
251     }
252     
253     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
254         if (frozenAccount[msg.sender]) return false;
255         require(_to != address(0));
256         require(_amount <= balances[_from]);
257         require(_amount <= allowed[_from][msg.sender]);
258         
259         balances[_from] = balances[_from].sub(_amount);
260         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
261         balances[_to] = balances[_to].add(_amount);
262         emit Transfer(_from, _to, _amount);
263         return true;
264     }
265     
266     function approve(address _spender, uint256 _value) public returns (bool success) {
267         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
268         allowed[msg.sender][_spender] = _value;
269         emit Approval(msg.sender, _spender, _value);
270         return true;
271     }
272     
273     function allowance(address _owner, address _spender) constant public returns (uint256) {
274         return allowed[_owner][_spender];
275     }
276     
277     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
278         ForeignToken t = ForeignToken(tokenAddress);
279         uint bal = t.balanceOf(who);
280         return bal;
281     }
282     
283     function withdrawAll() onlyOwner public {
284         address myAddress = this;
285         uint256 etherBalance = myAddress.balance;
286         owner.transfer(etherBalance);
287     }
288 
289     function withdraw(uint256 _wdamount) onlyOwner public {
290         uint256 wantAmount = _wdamount;
291         owner.transfer(wantAmount);
292     }
293     
294     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
295         ForeignToken token = ForeignToken(_tokenContract);
296         uint256 amount = token.balanceOf(address(this));
297         return token.transfer(owner, amount);
298     }
299         
300     function freezeAccount(address target, bool freeze) onlyOwner public {
301         frozenAccount[target] = freeze;
302       emit  FrozenFunds(target, freeze);
303     }
304 }