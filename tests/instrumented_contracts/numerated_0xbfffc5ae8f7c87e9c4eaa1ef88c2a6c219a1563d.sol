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
69         uint256 public tokensForSale        = 12000000000e8;
70         uint256 public totalDistributed;
71         uint256 public totalTokenSold; 
72         uint256 public totalWeiReceived;
73         uint256 public constant requestMinimum = 1 ether / 100;
74         uint256 public tokensPerEth = 20000000e8;
75         
76         
77         address multisig = 0xF37dFcB77574Ab8CaDC4C6AE636AF42704135Aab;
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84     event ICOStarted();
85     
86     event Airdrop(address indexed _owner, uint _amount, uint _balance);
87 
88     event TokensPerEthUpdated(uint _tokensPerEth);
89     
90     event Burn(address indexed burner, uint256 value);
91 
92     event FrozenFunds(address target, bool frozen);
93     
94 
95     bool public distributionFinished = false;
96     bool public icoStarted = false;
97     
98     modifier canDistr() {
99         require(!distributionFinished);
100         _;
101     }
102     
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107     
108     constructor() public {
109         owner = msg.sender;
110     }
111     
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118     function startICO() onlyOwner public returns (bool) {
119         icoStarted = true;
120         distributionFinished = false;
121         emit ICOStarted();
122         return true;
123     }
124 
125     function finishDistribution() onlyOwner canDistr public returns (bool) {
126         distributionFinished = true;
127         emit DistrFinished();
128         return true;
129     }
130     
131     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
132         totalDistributed = totalDistributed.add(_amount);        
133         balances[_to] = balances[_to].add(_amount);
134         emit Distr(_to, _amount);
135         emit Transfer(address(0), _to, _amount);
136 
137         return true;
138     }
139 
140     function doAirdrop(address _participant, uint _amount) internal {
141 
142         require( _amount > 0 );      
143 
144         require( totalDistributed < totalSupply );
145         
146         balances[_participant] = balances[_participant].add(_amount);
147         totalDistributed = totalDistributed.add(_amount);
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152 
153         // log
154         emit Airdrop(_participant, _amount, balances[_participant]);
155         emit Transfer(address(0), _participant, _amount);
156     }
157 
158     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
159         doAirdrop(_participant, _amount);
160     }
161 
162     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
163         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
164     }
165     
166     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
167         tokensPerEth = _tokensPerEth;
168         emit TokensPerEthUpdated(_tokensPerEth);
169     }
170     
171     function () external payable {
172         getTokens();
173      }
174     
175     function getTokens() payable canDistr  public {
176         require(icoStarted);
177         uint256 tokens = 0;
178 
179         require( msg.value >= requestMinimum );
180 
181         require( msg.value > 0 );
182 
183         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
184         address investor = msg.sender;
185         
186         if (tokens > 0) {
187             distr(investor, tokens);
188             totalWeiReceived = totalWeiReceived.add(msg.value);
189             totalTokenSold = totalTokenSold.add(tokens);
190         }
191         
192         if (totalTokenSold >= tokensForSale) {
193             distributionFinished = true;
194         }
195         
196          multisig.transfer(msg.value);
197     }
198     
199     function balanceOf(address _owner) constant public returns (uint256) {
200         return balances[_owner];
201     }
202 
203     modifier onlyPayloadSize(uint size) {
204         assert(msg.data.length >= size + 4);
205         _;
206     }
207     
208     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
209         if (frozenAccount[msg.sender]) return false;
210         require(_to != address(0));
211         require(_amount <= balances[msg.sender]);
212         
213         balances[msg.sender] = balances[msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(msg.sender, _to, _amount);
216         return true;
217     }
218     
219     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
220         if (frozenAccount[msg.sender]) return false;
221         require(_to != address(0));
222         require(_amount <= balances[_from]);
223         require(_amount <= allowed[_from][msg.sender]);
224         
225         balances[_from] = balances[_from].sub(_amount);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         emit Transfer(_from, _to, _amount);
229         return true;
230     }
231     
232     function approve(address _spender, uint256 _value) public returns (bool success) {
233         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
234         allowed[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     function allowance(address _owner, address _spender) constant public returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242     
243     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
244         ForeignToken t = ForeignToken(tokenAddress);
245         uint bal = t.balanceOf(who);
246         return bal;
247     }
248     
249     function withdrawAll() onlyOwner public {
250         address myAddress = this;
251         uint256 etherBalance = myAddress.balance;
252         owner.transfer(etherBalance);
253     }
254 
255     function withdraw(uint256 _wdamount) onlyOwner public {
256         uint256 wantAmount = _wdamount;
257         owner.transfer(wantAmount);
258     }
259     
260     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
261         ForeignToken token = ForeignToken(_tokenContract);
262         uint256 amount = token.balanceOf(address(this));
263         return token.transfer(owner, amount);
264     }
265     
266     function burn(uint256 _value) onlyOwner public {
267         require(_value <= balances[msg.sender]);
268         address burner = msg.sender;
269         balances[burner] = balances[burner].sub(_value);
270         totalSupply = totalSupply.sub(_value);
271         totalDistributed = totalDistributed.sub(_value);
272         emit Burn(burner, _value);
273     }
274     
275     function freezeAccount(address target, bool freeze) onlyOwner public {
276         frozenAccount[target] = freeze;
277       emit  FrozenFunds(target, freeze);
278     }
279 }