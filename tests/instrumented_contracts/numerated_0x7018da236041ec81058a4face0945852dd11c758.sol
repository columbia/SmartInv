1 pragma solidity ^0.4.18;
2 
3     /// Punya usaha atau bisnis dan ingin mengembangkan usaha anda dengan membuat Coin berbasis Ethereum Smartcontract ( erc20 ) ? Silahkan hubungi kami via SMS / WA 082280037283 ///
4 
5     /// Fasilitas yang kami berikan ///
6     /// 1- Token saja ///
7     /// 2- Airdrop saja ///
8     /// 3- Token dan airdrop sekaligus dalam satu contract address ///
9     /// 4- Full panduan dan bantuan sampai sampai di bursa ///
10     /// 5- Code JSON agar token bisa anda akses di visual studio ///
11 
12 /**
13  * @title SafeMath
14  */
15 library SafeMath {
16 
17     /**
18     * Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     /**
48     * Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract AltcoinToken {
58     function balanceOf(address _owner) constant public returns (uint256);
59     function transfer(address _to, uint256 _value) public returns (bool);
60 }
61 
62 contract ERC20Basic {
63     uint256 public totalSupply;
64     function balanceOf(address who) public constant returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public constant returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract GarudaToken is ERC20 {
77     
78     using SafeMath for uint256;
79     address owner = msg.sender;
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;    
83 
84     string public constant name = "Garuda Token";
85     string public constant symbol = "GAD";
86     uint public constant decimals = 8;
87     
88     uint256 public totalSupply = 370000000e8;
89     uint256 public totalDistributed = 0;        
90     uint256 public tokensPerEth = 100000e8;
91     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
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
117     
118        function GarudaToken () public {
119         owner = msg.sender;
120         uint256 devTokens = 20000000e8;
121         distr(owner, devTokens);
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         if (newOwner != address(0)) {
126             owner = newOwner;
127         }
128     }
129     
130 
131     function finishDistribution() onlyOwner canDistr public returns (bool) {
132         distributionFinished = true;
133         emit DistrFinished();
134         return true;
135         distributionFinished = false;
136         emit DistrFinished();
137         return false;
138     }
139     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
140         totalDistributed = totalDistributed.add(_amount);        
141         balances[_to] = balances[_to].add(_amount);
142         emit Distr(_to, _amount);
143         emit Transfer(address(0), _to, _amount);
144 
145         return true;
146     }
147 
148     function doAirdrop(address _participant, uint _amount) internal {
149 
150         require( _amount > 0 );      
151 
152         require( totalDistributed < totalSupply );
153         
154         balances[_participant] = balances[_participant].add(_amount);
155         totalDistributed = totalDistributed.add(_amount);
156 
157         if (totalDistributed >= totalSupply) {
158             distributionFinished = true;
159         }
160 
161         // log
162         emit Airdrop(_participant, _amount, balances[_participant]);
163         emit Transfer(address(0), _participant, _amount);
164     }
165 
166     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
167         doAirdrop(_participant, _amount);
168     }
169 
170     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
171         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
172     }
173 
174     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
175         tokensPerEth = _tokensPerEth;
176         emit TokensPerEthUpdated(_tokensPerEth);
177     }
178            
179     function () external payable {
180         getTokens();
181      }
182     
183     function getTokens() payable canDistr  public {
184         uint256 tokens = 0;
185 
186         require( msg.value >= minContribution );
187 
188         require( msg.value > 0 );
189         
190         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
191         address investor = msg.sender;
192         
193         if (tokens > 0) {
194             distr(investor, tokens);
195         }
196 
197         if (totalDistributed >= totalSupply) {
198             distributionFinished = true;
199         }
200     }
201 
202     function balanceOf(address _owner) constant public returns (uint256) {
203         return balances[_owner];
204     }
205 
206     // mitigates the ERC20 short address attack
207     modifier onlyPayloadSize(uint size) {
208         assert(msg.data.length >= size + 4);
209         _;
210     }
211     
212     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
213 
214         require(_to != address(0));
215         require(_amount <= balances[msg.sender]);
216         
217         balances[msg.sender] = balances[msg.sender].sub(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Transfer(msg.sender, _to, _amount);
220         return true;
221     }
222     
223     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
224 
225         require(_to != address(0));
226         require(_amount <= balances[_from]);
227         require(_amount <= allowed[_from][msg.sender]);
228         
229         balances[_from] = balances[_from].sub(_amount);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         emit Transfer(_from, _to, _amount);
233         return true;
234     }
235     
236     function approve(address _spender, uint256 _value) public returns (bool success) {
237         // mitigates the ERC20 spend/approval race condition
238         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
239         allowed[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243     
244     function allowance(address _owner, address _spender) constant public returns (uint256) {
245         return allowed[_owner][_spender];
246     }
247     
248     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
249         AltcoinToken t = AltcoinToken(tokenAddress);
250         uint bal = t.balanceOf(who);
251         return bal;
252     }
253     
254     function withdraw() onlyOwner public {
255         address myAddress = this;
256         uint256 etherBalance = myAddress.balance;
257         owner.transfer(etherBalance);
258     }
259     
260     function burn(uint256 _value) onlyOwner public {
261         require(_value <= balances[msg.sender]);
262         
263         address burner = msg.sender;
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         totalDistributed = totalDistributed.sub(_value);
267         emit Burn(burner, _value);
268     }
269     
270     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
271         AltcoinToken token = AltcoinToken(_tokenContract);
272         uint256 amount = token.balanceOf(address(this));
273         return token.transfer(owner, amount);
274     }
275 }