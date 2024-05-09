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
68 contract batnani is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed;
76 
77     string public constant name   = "Batnani";
78     string public constant symbol = "BTNI";
79 
80     uint public constant decimals = 10;
81     uint public bonusDeadlineDefault = 30;
82     uint public bonusDeadline = now + bonusDeadlineDefault * 1 days;
83     
84     uint256 public totalDistributed;    
85     uint256 public constant MIN_CONTRIBUTION = 1 ether / 10000; // 0.0001 Ether
86     uint256 public totalSupply  = 300000000e10;
87     uint256 public tokensPerEth = 300000e10;
88     uint256 public initialBonus = 100000e10;
89     uint256 public zeroBonus    = 1000e10;
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93     
94     event Distr(address indexed to, uint256 amount);
95     event DistrFinished();
96     
97     event Airdrop(address indexed _owner, uint _amount, uint _balance);
98 
99     event TokensPerEthUpdated(uint _tokensPerEth);
100 
101     event InitialBonusUpdated(uint _initialBonus);
102 
103     event InitialBonusZero(uint _initialZero);
104     
105     event Burn(uint256 value);
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
119     
120     function transferOwnership(address newOwner) onlyOwner public {
121         if (newOwner != address(0)) {
122             owner = newOwner;
123         }
124     }
125 
126     function finishDistribution() onlyOwner canDistr public returns (bool) {
127         distributionFinished = true;
128         emit DistrFinished();
129         return true;
130     }
131     
132     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
133         totalDistributed = totalDistributed.add(_amount);        
134         balances[_to] = balances[_to].add(_amount);
135         emit Distr(_to, _amount);
136         emit Transfer(address(0), _to, _amount);
137 
138         return true;
139     }
140     
141     function Distribute(address _participant, uint _amount) onlyOwner internal {
142 
143         require( _amount > 0 );      
144 
145         require( totalDistributed < totalSupply );
146         
147         balances[_participant] = balances[_participant].add(_amount);
148         totalDistributed = totalDistributed.add(_amount);
149 
150         if (totalDistributed >= totalSupply) {
151             distributionFinished = true;
152         }
153 
154         // log
155         emit Airdrop(_participant, _amount, balances[_participant]);
156         emit Transfer(address(0), _participant, _amount);
157     }
158     
159     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
160         Distribute(_participant, _amount);
161     }
162 
163     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
164         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
165     }
166 
167     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
168         tokensPerEth = _tokensPerEth;
169         emit TokensPerEthUpdated(_tokensPerEth);
170     }
171 
172     function updateInitialBonus(uint _initialBonus) public onlyOwner {        
173         initialBonus = _initialBonus;
174         emit InitialBonusUpdated(_initialBonus);
175     }
176 
177     function updateInitialZero(uint _initialZero) public onlyOwner {        
178         zeroBonus = _initialZero;
179         emit InitialBonusZero(_initialZero);
180     }
181            
182     function () external payable {
183         getTokens();
184      }
185     
186     function getTokens() payable canDistr public {
187         uint256 tokens = 0;
188         uint256 bonusInitial = 0;
189         uint256 bonusZero = 0;
190         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
191         address investor = msg.sender;
192         bonusInitial = tokens + initialBonus;
193         bonusZero = tokens + zeroBonus;
194 
195         if (msg.value <= 0 && msg.value < MIN_CONTRIBUTION && Claimed[investor] == false && now >= bonusDeadline) {
196             distr(investor, bonusZero);
197             Claimed[investor] = true;
198         }else if( msg.value >= MIN_CONTRIBUTION && now >= bonusDeadline){
199             distr(investor, bonusInitial);
200         }else{
201             distr(investor, tokens);
202         }
203 
204         if (totalDistributed >= totalSupply) {
205             distributionFinished = true;
206         }
207     }
208     
209     function balanceOf(address _owner) constant public returns (uint256) {
210         return balances[_owner];
211     }
212 
213     modifier onlyPayloadSize(uint size) {
214         assert(msg.data.length >= size + 4);
215         _;
216     }
217     
218     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
219 
220         require(_to != address(0));
221         require(_amount <= balances[msg.sender]);
222         
223         balances[msg.sender] = balances[msg.sender].sub(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         emit Transfer(msg.sender, _to, _amount);
226         return true;
227     }
228     
229     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
230 
231         require(_to != address(0));
232         require(_amount <= balances[_from]);
233         require(_amount <= allowed[_from][msg.sender]);
234         
235         balances[_from] = balances[_from].sub(_amount);
236         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         emit Transfer(_from, _to, _amount);
239         return true;
240     }
241     
242     function approve(address _spender, uint256 _value) public returns (bool success) {
243         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
244         allowed[msg.sender][_spender] = _value;
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248     
249     function allowance(address _owner, address _spender) constant public returns (uint256) {
250         return allowed[_owner][_spender];
251     }
252     
253     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
254         ForeignToken t = ForeignToken(tokenAddress);
255         uint bal = t.balanceOf(who);
256         return bal;
257     }
258     
259     function withdraw() onlyOwner public {
260         address myAddress = this;
261         uint256 etherBalance = myAddress.balance;
262         owner.transfer(etherBalance);
263     }
264     
265     function burn(uint256 _value) onlyOwner public {
266         uint256 cek = totalSupply - totalDistributed;
267         require(_value <= cek);
268         uint256 counter = totalDistributed + totalSupply.sub(_value) - totalDistributed;
269         totalSupply = counter; 
270         emit Burn(_value);
271     }
272     
273     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
274         ForeignToken token = ForeignToken(_tokenContract);
275         uint256 amount = token.balanceOf(address(this));
276         return token.transfer(owner, amount);
277     }
278 }