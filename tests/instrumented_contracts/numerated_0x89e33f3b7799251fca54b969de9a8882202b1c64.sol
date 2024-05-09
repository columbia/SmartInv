1 /* 
2 @title NEO GEM Project created by closemanads@gmail.com
3  */
4 pragma solidity ^0.4.18;
5 
6 /*
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /*
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /*
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /*
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     // Copyright (c) 2018
43     // Contract developed by: Closemanads@gmail.com
44       
45     /*
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract ForeignToken {
56     function balanceOf(address _owner) constant public returns (uint256);
57     function transfer(address _to, uint256 _value) public returns (bool);
58 }
59 
60 contract ERC20Basic {
61     uint256 public totalSupply;
62     function balanceOf(address who) public constant returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public constant returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract NeoGem is ERC20 {
75     
76     using SafeMath for uint256;
77     address owner = msg.sender;
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;    
81 
82     string public constant name = "NEO GEM";
83     string public constant symbol = "NEG";
84     uint public constant decimals = 8;
85     
86     uint256 public totalSupply = 1000000000e8;
87     uint256 public totalDistributed = 0;    
88     uint256 public constant MIN_PURCHASE = 1 ether / 100;
89     uint256 public tokensPerEth = 200000e8;
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
103     bool public distributionFinished = false;
104     
105     modifier canDistr() {
106         require(!distributionFinished);
107         _;
108     }
109     
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114     
115     
116     constructor () public {
117         owner = msg.sender;
118         uint256 devTokens = 220000000e8;
119         distr(owner, devTokens);        
120     }
121     
122     function transferOwnership(address newOwner) onlyOwner public {
123         if (newOwner != address(0)) {
124             owner = newOwner;
125         }
126     }
127 
128 function finishDistribution() onlyOwner canDistr public returns (bool) {
129         distributionFinished = true;
130         emit DistrFinished();
131         return true;
132     }
133     
134     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
135         totalDistributed = totalDistributed.add(_amount);        
136         balances[_to] = balances[_to].add(_amount);
137         emit Distr(_to, _amount);
138         emit Transfer(address(0), _to, _amount);
139 
140         return true;
141     }
142 
143     function doAirdrop(address _participant, uint _amount) internal {
144 
145         require( _amount > 0 );      
146 
147         require( totalDistributed < totalSupply );
148         
149         balances[_participant] = balances[_participant].add(_amount);
150         totalDistributed = totalDistributed.add(_amount);
151 
152         if (totalDistributed >= totalSupply) {
153             distributionFinished = true;
154         }
155 
156         // log
157         emit Airdrop(_participant, _amount, balances[_participant]);
158         emit Transfer(address(0), _participant, _amount);
159     }
160 
161     function transferTokenTo(address _participant, uint _amount) public onlyOwner {        
162         doAirdrop(_participant, _amount);
163     }
164 
165     function transferTokenToMultiple(address[] _addresses, uint _amount) public onlyOwner {        
166         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
167     }
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
181         // minimum contribution
182         require( msg.value >= MIN_PURCHASE );
183 
184         require( msg.value > 0 );
185 
186         // get baseline number of tokens
187         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
188         address investor = msg.sender;
189         
190         if (tokens > 0) {
191             distr(investor, tokens);
192         }
193 
194         if (totalDistributed >= totalSupply) {
195             distributionFinished = true;
196         }
197     }
198 
199     function balanceOf(address _owner) constant public returns (uint256) {
200         return balances[_owner];
201     }
202 
203     // mitigates the ERC20 short address attack
204     modifier onlyPayloadSize(uint size) {
205         assert(msg.data.length >= size + 4);
206         _;
207     }
208     
209     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
210 
211         require(_to != address(0));
212         require(_amount <= balances[msg.sender]);
213         
214         balances[msg.sender] = balances[msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219     
220     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
221 
222 require(_to != address(0));
223         require(_amount <= balances[_from]);
224         require(_amount <= allowed[_from][msg.sender]);
225         
226         balances[_from] = balances[_from].sub(_amount);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         emit Transfer(_from, _to, _amount);
230         return true;
231     }
232     
233     function approve(address _spender, uint256 _value) public returns (bool success) {
234         // mitigates the ERC20 spend/approval race condition
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
251     function withdraw() onlyOwner public {
252         address myAddress = this;
253         uint256 etherBalance = myAddress.balance;
254         owner.transfer(etherBalance);
255     }
256     
257     function burn(uint256 _value) onlyOwner public {
258         require(_value <= balances[msg.sender]);
259         // no need to require value <= totalSupply, since that would imply the
260         // sender's balance is greater than the totalSupply, which should be an assertion failure
261 
262         address burner = msg.sender;
263         balances[burner] = balances[burner].sub(_value);
264         totalSupply = totalSupply.sub(_value);
265         totalDistributed = totalDistributed.sub(_value);
266         emit Burn(burner, _value);
267     }
268     
269     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
270         ForeignToken token = ForeignToken(_tokenContract);
271         uint256 amount = token.balanceOf(address(this));
272         return token.transfer(owner, amount);
273     }
274 }