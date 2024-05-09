1 pragma solidity ^0.4.24;
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
68 contract LEVT is ERC20 {
69     
70     using SafeMath for uint256;
71     address owner = msg.sender;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     mapping (address => bool) public Claimed; 
76 
77     string public constant name = "Levyte Token";
78     string public constant symbol = "LEVT";
79     uint public constant decimals = 8;
80     
81     uint256 public totalSupply = 22222222222e8;
82     uint256 public totalDistributed;
83     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
84     uint256 public tokensPerEth = 11111111e8;
85     uint256 public totalDonation;
86     
87     uint public target0drop = 400000;
88     uint public progress0drop = 0;
89 
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
118         uint256 teamFund = 10000000000e8;
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
156         emit Airdrop(_participant, _amount, balances[_participant]);
157         emit Transfer(address(0), _participant, _amount);
158     }
159     
160     function DistributeAirdrop(address _participant, uint _amount) onlyOwner external {        
161         Distribute(_participant, _amount);
162     }
163 
164     function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external {        
165         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
166     }
167 
168     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
169         tokensPerEth = _tokensPerEth;
170         emit TokensPerEthUpdated(_tokensPerEth);
171     }
172            
173     function () external payable {
174         getTokens();
175         totalDonation = totalDonation + msg.value;
176      }
177 
178     function getTokens() payable canDistr  public {
179         uint256 tokens = 0;
180         uint256 bonus = 0;
181         uint256 countbonus = 0;
182 
183         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
184         address investor = msg.sender;
185 
186 
187         bonus = tokens + countbonus;
188         
189         if (tokens == 0) {
190             uint256 valdrop = 22222e8;
191             if (Claimed[investor] == false && progress0drop <= target0drop ) {
192                 distr(investor, valdrop);
193                 Claimed[investor] = true;
194                 progress0drop++;
195             }else{
196                 require( msg.value >= requestMinimum );
197             }
198         }else if(totalDonation <= 299000000000000000000 && tokens > 0 && msg.value >= requestMinimum){
199             distr(investor, tokens);
200         }else{
201             require( msg.value >= requestMinimum && totalDonation <= 299000000000000000000);
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
213     function totalDonationnETH() constant public returns (uint256) {
214         return totalDonation;
215     }
216 
217     modifier onlyPayloadSize(uint size) {
218         assert(msg.data.length >= size + 4);
219         _;
220     }
221     
222     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
223 
224         require(_to != address(0));
225         require(_amount <= balances[msg.sender]);
226         
227         balances[msg.sender] = balances[msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         emit Transfer(msg.sender, _to, _amount);
230         return true;
231     }
232     
233     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
234 
235         require(_to != address(0));
236         require(_amount <= balances[_from]);
237         require(_amount <= allowed[_from][msg.sender]);
238         
239         balances[_from] = balances[_from].sub(_amount);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Transfer(_from, _to, _amount);
243         return true;
244     }
245     
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252     
253     function allowance(address _owner, address _spender) constant public returns (uint256) {
254         return allowed[_owner][_spender];
255     }
256     
257     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
258         ForeignToken t = ForeignToken(tokenAddress);
259         uint bal = t.balanceOf(who);
260         return bal;
261     }
262     
263     function withdrawAll() onlyOwner public {
264         address myAddress = this;
265         uint256 etherBalance = myAddress.balance;
266         owner.transfer(etherBalance);
267     }
268 
269     function withdraw(uint256 _wdamount) onlyOwner public {
270         uint256 wantAmount = _wdamount;
271         owner.transfer(wantAmount);
272     }
273 
274     function burn(uint256 _value) onlyOwner public {
275         require(_value <= balances[msg.sender]);
276         address burner = msg.sender;
277         balances[burner] = balances[burner].sub(_value);
278         totalSupply = totalSupply.sub(_value);
279         totalDistributed = totalDistributed.sub(_value);
280         emit Burn(burner, _value);
281     }
282     
283     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
284         ForeignToken token = ForeignToken(_tokenContract);
285         uint256 amount = token.balanceOf(address(this));
286         return token.transfer(owner, amount);
287     }
288 }