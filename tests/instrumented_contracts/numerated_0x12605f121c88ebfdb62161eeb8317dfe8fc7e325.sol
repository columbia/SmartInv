1 pragma solidity ^0.4.24;
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
30 contract AltcoinToken {
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
49 contract Penchant is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     string public constant name = "Penchant Token";
58     string public constant symbol = "PCT";
59     uint public constant decimals = 18;
60     
61     uint256 public totalSupply = 5000000000e18;
62     uint256 public totalDistributed = 0;        
63     uint256 public tokensPerEth = 3000000e18;
64     uint256 public bonus = 0;   
65     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
66     uint256 public constant minBonus = 1 ether / 2; // 0.5 Ether
67     uint256 public constant maxBonus = 1 ether / 1; // 1 Ether
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71     
72     event Distr(address indexed to, uint256 amount);
73     event DistrFinished();
74 
75     event Airdrop(address indexed _owner, uint _amount, uint _balance);
76 
77     event TokensPerEthUpdated(uint _tokensPerEth);
78     
79     event Burn(address indexed burner, uint256 value);
80 
81     bool public distributionFinished = false;
82     
83     modifier canDistr() {
84         require(!distributionFinished);
85         _;
86     }
87     
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     
94     function Penchant () public {
95         owner = msg.sender;
96         uint256 devTokens = 2250000000e18;
97         distr(owner, devTokens);
98     }
99     
100     function transferOwnership(address newOwner) onlyOwner public {
101         if (newOwner != address(0)) {
102             owner = newOwner;
103         }
104     }
105 
106     function finishDistribution() onlyOwner canDistr public returns (bool) {
107         distributionFinished = true;
108         emit DistrFinished();
109         return true;
110     }
111     
112     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
113         totalDistributed = totalDistributed.add(_amount);        
114         balances[_to] = balances[_to].add(_amount);
115         emit Distr(_to, _amount);
116         emit Transfer(address(0), _to, _amount);
117 
118         return true;
119     }
120 
121     function doAirdrop(address _participant, uint _amount) internal {
122 
123         require( _amount > 0 );      
124 
125         require( totalDistributed < totalSupply );
126         
127         balances[_participant] = balances[_participant].add(_amount);
128         totalDistributed = totalDistributed.add(_amount);
129 
130         if (totalDistributed >= totalSupply) {
131             distributionFinished = true;
132         }
133 
134         emit Airdrop(_participant, _amount, balances[_participant]);
135         emit Transfer(address(0), _participant, _amount);
136     }
137 
138     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
139         doAirdrop(_participant, _amount);
140     }
141 
142     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
143         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
144     }
145 
146     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
147         tokensPerEth = _tokensPerEth;
148         emit TokensPerEthUpdated(_tokensPerEth);
149     }
150            
151     function () external payable {
152         getTokens();
153      }
154     
155     function getTokens() payable canDistr  public {
156         uint256 tokens = 0;
157 
158         require( msg.value >= minContribution );
159 
160         require( msg.value > 0 );
161 
162         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
163         address investor = msg.sender;
164         bonus = 0;
165 
166         if ( msg.value >= minBonus ) {
167             bonus = tokens / 5;
168         }
169 
170         if ( msg.value >= maxBonus ) {
171             bonus = tokens / 2;
172         }
173 
174         tokens = tokens + bonus;
175 
176         if (tokens > 0) {
177             distr(investor, tokens);
178         }
179 
180         if (totalDistributed >= totalSupply) {
181             distributionFinished = true;
182         }
183     }
184 
185     function balanceOf(address _owner) constant public returns (uint256) {
186         return balances[_owner];
187     }
188 
189     // mitigates the ERC20 short address attack
190     modifier onlyPayloadSize(uint size) {
191         assert(msg.data.length >= size + 4);
192         _;
193     }
194     
195     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
196 
197         require(_to != address(0));
198         require(_amount <= balances[msg.sender]);
199         
200         balances[msg.sender] = balances[msg.sender].sub(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         emit Transfer(msg.sender, _to, _amount);
203         return true;
204     }
205     
206     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
207 
208         require(_to != address(0));
209         require(_amount <= balances[_from]);
210         require(_amount <= allowed[_from][msg.sender]);
211         
212         balances[_from] = balances[_from].sub(_amount);
213         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
214         balances[_to] = balances[_to].add(_amount);
215         emit Transfer(_from, _to, _amount);
216         return true;
217     }
218     
219     function approve(address _spender, uint256 _value) public returns (bool success) {
220         // mitigates the ERC20 spend/approval race condition
221         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224         return true;
225     }
226     
227     function allowance(address _owner, address _spender) constant public returns (uint256) {
228         return allowed[_owner][_spender];
229     }
230     
231     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
232         AltcoinToken t = AltcoinToken(tokenAddress);
233         uint bal = t.balanceOf(who);
234         return bal;
235     }
236     
237     function withdraw() onlyOwner public {
238         address myAddress = this;
239         uint256 etherBalance = myAddress.balance;
240         owner.transfer(etherBalance);
241     }
242     
243     function burn(uint256 _value) onlyOwner public {
244         require(_value <= balances[msg.sender]);
245         
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         totalDistributed = totalDistributed.sub(_value);
250         emit Burn(burner, _value);
251     }
252     
253     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
254         AltcoinToken token = AltcoinToken(_tokenContract);
255         uint256 amount = token.balanceOf(address(this));
256         return token.transfer(owner, amount);
257     }
258 }