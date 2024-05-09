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
55 contract Tranium is ERC20 {
56     
57     using SafeMath for uint256;
58     address owner = msg.sender;
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     mapping (address => bool) public frozenAccount;
63 
64     string public constant name = "Tranium";
65     string public constant symbol = "TRM";
66     uint public constant decimals = 8;
67         
68         uint256 public totalSupply          = 15000000000e8;
69         uint256 public tokensForSale        = 65000000000e8;
70         uint256 public totalDistributed;
71         uint256 public totalTokenSold; 
72         uint256 public totalWeiReceived;
73         uint256 public constant requestMinimum = 1 ether / 100;
74         uint256 public tokensPerEth = 15000000e8;
75         
76         
77         address multisig = 0x24543bC9f23793bdcEa99569b602536C7B2CB6C6;
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
108     constructor () public {
109         owner = msg.sender;
110         uint256 devTokens = 2500000000e8;
111         distr(owner, devTokens);        
112     }
113     
114     function transferOwnership(address newOwner) onlyOwner public {
115         if (newOwner != address(0)) {
116             owner = newOwner;
117         }
118     }
119     
120     function startICO() onlyOwner public returns (bool) {
121         icoStarted = true;
122         distributionFinished = false;
123         emit ICOStarted();
124         return true;
125     }
126 
127     function finishDistribution() onlyOwner canDistr public returns (bool) {
128         distributionFinished = true;
129         emit DistrFinished();
130         return true;
131     }
132     
133     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
134         totalDistributed = totalDistributed.add(_amount);        
135         balances[_to] = balances[_to].add(_amount);
136         emit Distr(_to, _amount);
137         emit Transfer(address(0), _to, _amount);
138 
139         return true;
140     }
141 
142     function doAirdrop(address _participant, uint _amount) internal {
143 
144         require( _amount > 0 );      
145 
146         require( totalDistributed < totalSupply );
147         
148         balances[_participant] = balances[_participant].add(_amount);
149         totalDistributed = totalDistributed.add(_amount);
150 
151         if (totalDistributed >= totalSupply) {
152             distributionFinished = true;
153         }
154 
155         // log
156         emit Airdrop(_participant, _amount, balances[_participant]);
157         emit Transfer(address(0), _participant, _amount);
158     }
159 
160     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
161         doAirdrop(_participant, _amount);
162     }
163 
164     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
165         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
166     }
167     
168     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
169         tokensPerEth = _tokensPerEth;
170         emit TokensPerEthUpdated(_tokensPerEth);
171     }
172     
173     function () external payable {
174         getTokens();
175      }
176     
177     function getTokens() payable canDistr  public {
178         require(icoStarted);
179         uint256 tokens = 0;
180 
181         require( msg.value >= requestMinimum );
182 
183         require( msg.value > 0 );
184 
185         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
186         address investor = msg.sender;
187         
188         if (tokens > 0) {
189             distr(investor, tokens);
190             totalWeiReceived = totalWeiReceived.add(msg.value);
191             totalTokenSold = totalTokenSold.add(tokens);
192         }
193         
194         if (totalTokenSold >= tokensForSale) {
195             distributionFinished = true;
196         }
197         
198          multisig.transfer(msg.value);
199     }
200     
201     function balanceOf(address _owner) constant public returns (uint256) {
202         return balances[_owner];
203     }
204 
205     modifier onlyPayloadSize(uint size) {
206         assert(msg.data.length >= size + 4);
207         _;
208     }
209     
210     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
211         if (frozenAccount[msg.sender]) return false;
212         require(_to != address(0));
213         require(_amount <= balances[msg.sender]);
214         
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         emit Transfer(msg.sender, _to, _amount);
218         return true;
219     }
220     
221     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
222         if (frozenAccount[msg.sender]) return false;
223         require(_to != address(0));
224         require(_amount <= balances[_from]);
225         require(_amount <= allowed[_from][msg.sender]);
226         
227         balances[_from] = balances[_from].sub(_amount);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Transfer(_from, _to, _amount);
231         return true;
232     }
233     
234     function approve(address _spender, uint256 _value) public returns (bool success) {
235         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
236         allowed[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240     
241     function allowance(address _owner, address _spender) constant public returns (uint256) {
242         return allowed[_owner][_spender];
243     }
244     
245     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
246         ForeignToken t = ForeignToken(tokenAddress);
247         uint bal = t.balanceOf(who);
248         return bal;
249     }
250     
251     function withdrawAll() onlyOwner public {
252         address myAddress = this;
253         uint256 etherBalance = myAddress.balance;
254         owner.transfer(etherBalance);
255     }
256 
257     function withdraw(uint256 _wdamount) onlyOwner public {
258         uint256 wantAmount = _wdamount;
259         owner.transfer(wantAmount);
260     }
261     
262     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
263         ForeignToken token = ForeignToken(_tokenContract);
264         uint256 amount = token.balanceOf(address(this));
265         return token.transfer(owner, amount);
266     }
267     
268     function burn(uint256 _value) onlyOwner public {
269         require(_value <= balances[msg.sender]);
270         address burner = msg.sender;
271         balances[burner] = balances[burner].sub(_value);
272         totalSupply = totalSupply.sub(_value);
273         totalDistributed = totalDistributed.sub(_value);
274         emit Burn(burner, _value);
275     }
276     
277     function freezeAccount(address target, bool freeze) onlyOwner public {
278         frozenAccount[target] = freeze;
279       emit  FrozenFunds(target, freeze);
280     }
281 }