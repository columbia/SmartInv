1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-18
3 */
4 
5 // ----------------------------------------------------------------------------
6 // YFI Paprika (YFIP) Contract 
7 //
8 // Deployed to : 0x61F35411C4a8a1fD2039d23e320c8Ec667ddE91b
9 // Symbol      : YFIP
10 // Name        : YFI Paprika
11 // Total supply: 30,000
12 // Decimals    : 8
13 //
14 // Enjoy.
15 //
16 // (c) Created by YFI Paprika (https://yfipaprika.finance). The MIT Licence. E-mail admin@yfipaprika.finance
17 
18 
19 pragma solidity ^0.4.24;
20 
21 /**
22  * @title SafeMath
23  */
24 library SafeMath {
25 
26     /**
27     * @dev Multiplies two numbers, throws on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     /**
39     * @dev Integer division of two numbers, truncating the quotient.
40     */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         // uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return a / b;
46     }
47 
48     /**
49     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50     */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60         c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 contract ForeignToken {
67     function balanceOf(address _owner) constant public returns (uint256);
68     function transfer(address _to, uint256 _value) public returns (bool);
69 }
70 
71 contract ERC20Basic {
72     uint256 public totalSupply;
73     function balanceOf(address who) public constant returns (uint256);
74     function transfer(address to, uint256 value) public returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract ERC20 is ERC20Basic {
79     function allowance(address owner, address spender) public constant returns (uint256);
80     function transferFrom(address from, address to, uint256 value) public returns (bool);
81     function approve(address spender, uint256 value) public returns (bool);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 contract YFIPaprika is ERC20 {
86     
87     using SafeMath for uint256;
88     address owner = msg.sender;
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;    
92 
93     string public constant name = "YFI Paprika";
94     string public constant symbol = "YFIP";
95     uint public constant decimals = 8;
96     
97     uint256 public totalSupply = 3000000000000; // Supply
98     uint256 public totalDistributed = 0;    
99     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
100     uint256 public tokensPerEth = 0;
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104     event Distr(address indexed to, uint256 amount);
105     event DistrFinished();
106     event Airdrop(address indexed _owner, uint _amount, uint _balance);
107     event TokensPerEthUpdated(uint _tokensPerEth);
108     event Burn(address indexed burner, uint256 value);
109 
110     bool public distributionFinished = false;
111     
112     modifier canDistr() {
113         require(!distributionFinished);
114         _;
115     }
116     
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121     
122     
123    
124     
125     function transferOwnership(address newOwner) onlyOwner public {
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130     
131 
132     function finishDistribution() onlyOwner canDistr public returns (bool) {
133         distributionFinished = true;
134         emit DistrFinished();
135         return true;
136     }
137     
138     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
139         totalDistributed = totalDistributed.add(_amount);        
140         balances[_to] = balances[_to].add(_amount);
141         emit Distr(_to, _amount);
142         emit Transfer(address(0), _to, _amount);
143 
144         return true;
145     }
146 
147     function doAirdrop(address _participant, uint _amount) internal {
148 
149         require( _amount > 0 );      
150 
151         require( totalDistributed < totalSupply );
152         
153         balances[_participant] = balances[_participant].add(_amount);
154         totalDistributed = totalDistributed.add(_amount);
155 
156         if (totalDistributed >= totalSupply) {
157             distributionFinished = true;
158         }
159 
160         emit Airdrop(_participant, _amount, balances[_participant]);
161         emit Transfer(address(0), _participant, _amount);
162     }
163 
164     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
165         doAirdrop(_participant, _amount);
166     }
167 
168 
169     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
170         tokensPerEth = _tokensPerEth;
171         emit TokensPerEthUpdated(_tokensPerEth);
172     }
173            
174     function () external payable {
175         getTokens();
176      }
177     
178     function getTokens() payable canDistr  public {
179         uint256 tokens = 0;
180 
181         require( msg.value >= MIN_CONTRIBUTION );
182 
183         require( msg.value > 0 );
184 
185         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
186         address investor = msg.sender;
187         
188         if (tokens > 0) {
189             distr(investor, tokens);
190         }
191 
192         if (totalDistributed >= totalSupply) {
193             distributionFinished = true;
194         }
195     }
196 
197     function balanceOf(address _owner) constant public returns (uint256) {
198         return balances[_owner];
199     }
200 
201     // mitigates the ERC20 short address attack
202     modifier onlyPayloadSize(uint size) {
203         assert(msg.data.length >= size + 4);
204         _;
205     }
206     
207     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
208 
209         require(_to != address(0));
210         require(_amount <= balances[msg.sender]);
211         
212         balances[msg.sender] = balances[msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Transfer(msg.sender, _to, _amount);
215         return true;
216     }
217     
218     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
219 
220         require(_to != address(0));
221         require(_amount <= balances[_from]);
222         require(_amount <= allowed[_from][msg.sender]);
223         
224         balances[_from] = balances[_from].sub(_amount);
225         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
226         balances[_to] = balances[_to].add(_amount);
227         emit Transfer(_from, _to, _amount);
228         return true;
229     }
230     
231     function approve(address _spender, uint256 _value) public returns (bool success) {
232         // mitigates the ERC20 spend/approval race condition
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
249     function withdraw() onlyOwner public {
250         address myAddress = this;
251         uint256 etherBalance = myAddress.balance;
252         owner.transfer(etherBalance);
253     }
254     
255     function burn(uint256 _value) onlyOwner public {
256         require(_value <= balances[msg.sender]);
257 
258 
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         totalSupply = totalSupply.sub(_value);
262         totalDistributed = totalDistributed.sub(_value);
263         emit Burn(burner, _value);
264     }
265     
266     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
267         ForeignToken token = ForeignToken(_tokenContract);
268         uint256 amount = token.balanceOf(address(this));
269         return token.transfer(owner, amount);
270     }
271 }