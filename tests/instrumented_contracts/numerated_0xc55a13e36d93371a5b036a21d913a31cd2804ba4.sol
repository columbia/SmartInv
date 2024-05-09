1 pragma solidity ^0.4.24;
2 
3 /**
4  * Note Of Exchange On The BlockChain
5  * Website: http://1-2.io
6  * Twitter: https://twitter.com/NoteOfExchange
7  */
8 library SafeMath {
9 
10     /**
11     * Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract OtherToken {
51     function balanceOf(address _owner) constant public returns (uint256);
52     function transfer(address _to, uint256 _value) public returns (bool);
53 }
54 
55 contract ERC20Basic {
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
68 contract NoteOfExchange is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) public balances;
74     mapping (address => mapping (address => uint256)) public allowed;    
75     mapping (address => bool) public joinOnce;
76     mapping (address => uint256) public frozenAccount;
77 
78     string  internal  name_ = "NoteOfExchange";
79     string  internal  symbol_ = "NOE";
80     uint8 internal  decimals_ = 8;    
81     uint256 internal  totalSupply_ = 200000000e8;
82 
83     uint256 internal  transGain=1;
84     uint256 public    totalDistributed = 0;        
85     uint256 public    tokensPerEth = 100000e8;
86     uint256 public    airdropBy0Eth = 1000e8;
87     uint256 public    officialHold = totalSupply_.mul(15).div(100);
88     uint256 public    minContribution = 1 ether / 10; // 0.1 Eth
89     bool    internal  distributionFinished = false;
90     bool    internal  EthGetFinished = false;
91     bool    internal  airdropBy0EthFinished = false;
92     bool    internal  transferGainFinished = true;  
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96     event Distr(address indexed to, uint256 amount);
97     event TokensPerEthUpdated(uint _tokensPerEth);
98     event Burn(address indexed burner, uint256 value);
99     event LockedFunds(address indexed target, uint256 locktime);
100 
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
112     
113     constructor(address target) public {
114         owner = msg.sender;
115         distr(target, officialHold);
116     }    
117     
118     function transferOwnership(address newOwner) onlyOwner public {
119         if (newOwner != address(0)) {
120             owner = newOwner;
121         }
122     }
123     
124 
125     function finishDistribution() onlyOwner  public returns (bool) {
126         distributionFinished = true;
127         return true;
128     }
129     function finishEthGet() onlyOwner  public returns (bool) {
130         EthGetFinished = true;
131         return true;
132     } 
133     function finishAirdropBy0Eth() onlyOwner  public returns (bool) {
134         airdropBy0EthFinished = true;
135         return true;
136     }   
137     function finishTransferGet() onlyOwner  public returns (bool) {
138         transferGainFinished = true;
139         return true;
140     }   
141 
142 
143 
144     function startDistribution() onlyOwner  public returns (bool) {
145         distributionFinished = false;
146         return true;
147     }
148     function startEthGet() onlyOwner  public returns (bool) {
149         EthGetFinished = false;
150         return true;
151     } 
152     function startAirdropBy0Eth() onlyOwner  public returns (bool) {
153         airdropBy0EthFinished = false;
154         return true;
155     }   
156     function startTransferGet() onlyOwner  public returns (bool) {
157         transferGainFinished = false;
158         return true;
159     } 
160 
161 
162     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
163         totalDistributed = totalDistributed.add(_amount);  
164         if (totalDistributed >= totalSupply_) {
165             distributionFinished = true;
166             totalDistributed=totalSupply_;
167         }              
168         balances[_to] = balances[_to].add(_amount);
169         emit Distr(_to, _amount);
170         emit Transfer(this, _to, _amount);
171 
172         return true;
173     }
174 
175     function selfLockFunds(uint _lockTime)  public {
176         require(balances[msg.sender] > 0 
177                  && _lockTime > 0);
178         uint256 lockt=_lockTime;
179         frozenAccount[msg.sender] = lockt.add(now);
180         emit LockedFunds(msg.sender, lockt);
181         
182     }
183 
184     function updateParameter(uint _tokensPerEth, uint _airdropBy0Eth, uint _transGain) onlyOwner public  {        
185         tokensPerEth = _tokensPerEth;
186         airdropBy0Eth = _airdropBy0Eth;
187         transGain = _transGain;
188     }
189            
190     function () external payable {
191         getTokens();
192      }
193     
194     function getTokens() payable canDistr  public {
195         uint256 tokens = 0;
196         address investor = msg.sender;
197         uint256 etherValue=msg.value;
198         if(etherValue >= minContribution){
199             owner.transfer(etherValue);
200             require(EthGetFinished==false);
201             tokens = tokensPerEth.mul(msg.value) / 1 ether;        
202             if (tokens >= 0)distr(investor, tokens);
203         }else{
204             require(airdropBy0EthFinished == false && joinOnce[investor] != true);
205             distr(investor,airdropBy0Eth);
206             joinOnce[investor] = true;
207             
208         }
209 
210 
211     }
212     function name() public view returns (string _name) {
213         return name_;
214     }
215 
216     function symbol() public view returns (string _symbol) {
217         return symbol_;
218     }
219 
220     function decimals() public view returns (uint8 _decimals) {
221         return decimals_;
222     }
223 
224     function totalSupply() public view returns (uint256 _totalSupply) {
225         return totalSupply_;
226     }
227     function balanceOf(address _owner) constant public returns (uint256) {
228         return balances[_owner];
229     }
230 
231     // mitigates the ERC20 short address attack
232     modifier onlyPayloadSize(uint size) {
233         assert(msg.data.length >= size + 4);
234         _;
235     }
236     
237     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
238 
239         require(_to != address(0) 
240                 && _amount <= balances[msg.sender] 
241                 && frozenAccount[msg.sender] < now);
242         uint256 incSend=0;
243         if(transferGainFinished == false && distributionFinished == false){
244                 incSend = _amount.mul(transGain).div(1000);
245         }
246         
247         balances[msg.sender] = balances[msg.sender].sub(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Transfer(msg.sender, _to, _amount);
250         if(transferGainFinished == false && distributionFinished == false){
251             distr(_to,incSend);
252         }
253         return true;
254     }
255     
256     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
257 
258         require(_to != address(0));
259         require(_amount <= balances[_from]);
260         require(_amount <= allowed[_from][msg.sender]);
261         
262         balances[_from] = balances[_from].sub(_amount);
263         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         emit Transfer(_from, _to, _amount);
266         return true;
267     }
268     
269     function approve(address _spender, uint256 _value) public returns (bool success) {
270         // mitigates the ERC20 spend/approval race condition
271         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
272         allowed[msg.sender][_spender] = _value;
273         emit Approval(msg.sender, _spender, _value);
274         return true;
275     }
276     
277     function allowance(address _owner, address _spender) constant public returns (uint256) {
278         return allowed[_owner][_spender];
279     }
280     
281 
282     
283     function withdraw() onlyOwner public {
284         address myAddress = this;
285         uint256 etherBalance = myAddress.balance;
286         owner.transfer(etherBalance);
287     }
288     
289     function burnFromAddress(uint256 _value) onlyOwner public {
290         require(_value <= balances[msg.sender]);
291         
292         address burner = msg.sender;
293         balances[burner] = balances[burner].sub(_value);
294         totalSupply_ = totalSupply_.sub(_value);
295         totalDistributed = totalDistributed.sub(_value);
296         emit Burn(burner, _value);
297     }
298     function burnFromTotal(uint256 _value) onlyOwner public {
299         if(totalDistributed >= totalSupply_.sub(_value)){
300             totalSupply_ = totalSupply_.sub(_value);
301             totalDistributed = totalSupply_;
302             distributionFinished = true;
303             EthGetFinished = true;
304             airdropBy0EthFinished = true;
305             transferGainFinished = true; 
306         }else{
307             totalSupply_ = totalSupply_.sub(_value);  
308         }    
309         emit Burn(this, _value);
310     }    
311     function withdrawOtherTokens(address _tokenContract) onlyOwner public returns (bool) {
312         OtherToken token = OtherToken(_tokenContract);
313         uint256 amount = token.balanceOf(address(this));
314         return token.transfer(owner, amount);
315     }
316 }