1 pragma solidity ^0.4.24;
2 
3 /*
4  * @title  Copyright Protection System (CPS)
5  */
6 library SafeMath {
7 
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20 
21         return a / b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract ForeignToken {
38     function balanceOf(address _owner) constant public returns (uint256);
39     function transfer(address _to, uint256 _value) public returns (bool);
40 }
41 
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public constant returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public constant returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract CPS is ERC20 {
57     
58     using SafeMath for uint256;
59     address owner = msg.sender;
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63  
64 
65     string public constant name = "Copyright Protection System";
66     string public constant symbol = "CPS";
67     uint public constant decimals = 3;
68 
69     
70     uint256 public totalSupply = 32000000e3;
71     uint256 public totalDistributed;
72     uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether
73     uint256 public CPSPerEth = 2500e3;
74     
75     
76 
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     event Distr(address indexed to, uint256 amount);
82     event DistrFinished();
83     
84 
85 
86     event CPSPerEthUpdated(uint _CPSPerEth);
87     
88     event Burn(address indexed burner, uint256 value);
89     
90     event Add(uint256 value);
91 
92     bool public distributionFinished = false;
93     
94     modifier canDistr() {
95         require(!distributionFinished);
96         _;
97     }
98     
99     modifier onlyOwner() {
100         require(msg.sender == owner);
101         _;
102     }
103     
104     
105     function transferOwnership(address newOwner) onlyOwner public {
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110 
111     function finishDistribution() onlyOwner canDistr public returns (bool) {
112         distributionFinished = true;
113         emit DistrFinished();
114         return true;
115     }
116     
117     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
118         totalDistributed = totalDistributed.add(_amount);        
119         balances[_to] = balances[_to].add(_amount);
120         emit Distr(_to, _amount);
121         emit Transfer(address(0), _to, _amount);
122 
123         return true;
124     }
125     
126     function Distribute(address _participant, uint _amount) onlyOwner internal {
127 
128         require( _amount > 0 );      
129         require( totalDistributed < totalSupply );
130         balances[_participant] = balances[_participant].add(_amount);
131         totalDistributed = totalDistributed.add(_amount);
132 
133         if (totalDistributed >= totalSupply) {
134             distributionFinished = true;
135         }
136 
137        
138         emit Transfer(address(0), _participant, _amount);
139     }
140     
141     function SendCPSTokens(address _participant, uint _amount) onlyOwner external {        
142         Distribute(_participant, _amount);
143     }
144 
145     function SendCPSTokensMultiple(address[] _addresses, uint _amount) onlyOwner external {        
146         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
147     }
148 
149     function updateCPSPerEth(uint _CPSPerEth) public onlyOwner {        
150         CPSPerEth = _CPSPerEth;
151         emit CPSPerEthUpdated(_CPSPerEth);
152     }
153            
154     function () external payable {
155         getTokens();
156      }
157 
158     function getTokens() payable canDistr  public {
159         uint256 tokens = 0;
160         uint256 bonus = 0;
161         uint256 levelbonus = 0;
162         uint256 bonuslevel1 = 1 ether / 10;
163         uint256 bonuslevel2 = 1 ether ;
164 
165 
166         tokens = CPSPerEth.mul(msg.value) / 1 ether;        
167         address investor = msg.sender;
168 
169         if (msg.value >= requestMinimum) {
170             if(msg.value >= bonuslevel1 && msg.value < bonuslevel2){
171                 levelbonus = tokens * 10 / 100;
172             }else if(msg.value >= bonuslevel2){
173                 levelbonus = tokens * 35 / 100;
174             }else{
175             levelbonus = 0;
176         }
177 
178         bonus = tokens + levelbonus;
179 		
180 		distr(investor, bonus);
181 		owner.transfer(msg.value);
182          }else{
183             require( msg.value >= requestMinimum );
184         }
185 
186         if (totalDistributed >= totalSupply) {
187             distributionFinished = true;
188         }
189         
190     }
191     
192     function balanceOf(address _owner) constant public returns (uint256) {
193         return balances[_owner];
194     }
195 
196     modifier onlyPayloadSize(uint size) {
197         assert(msg.data.length >= size + 4);
198         _;
199     }
200     
201     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
202 
203         require(_to != address(0));
204         require(_amount <= balances[msg.sender]);
205         
206         balances[msg.sender] = balances[msg.sender].sub(_amount);
207         balances[_to] = balances[_to].add(_amount);
208         emit Transfer(msg.sender, _to, _amount);
209         return true;
210     }
211     
212     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
213 
214         require(_to != address(0));
215         require(_amount <= balances[_from]);
216         require(_amount <= allowed[_from][msg.sender]);
217         
218         balances[_from] = balances[_from].sub(_amount);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
220         balances[_to] = balances[_to].add(_amount);
221         emit Transfer(_from, _to, _amount);
222         return true;
223     }
224     
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
227         allowed[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231     
232     function allowance(address _owner, address _spender) constant public returns (uint256) {
233         return allowed[_owner][_spender];
234     }
235     
236     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
237         ForeignToken t = ForeignToken(tokenAddress);
238         uint bal = t.balanceOf(who);
239         return bal;
240     }
241     
242 
243 
244     function burn(uint256 _value) onlyOwner public {
245         require(_value <= balances[msg.sender]);
246         address burner = msg.sender;
247         balances[burner] = balances[burner].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         totalDistributed = totalDistributed.sub(_value);
250         emit Burn(burner, _value);
251     }
252     
253     function add(uint256 _value) onlyOwner public {
254         uint256 counter = totalSupply.add(_value);
255         totalSupply = counter; 
256         emit Add(_value);
257     }
258     
259     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
260         ForeignToken token = ForeignToken(_tokenContract);
261         uint256 amount = token.balanceOf(address(this));
262         return token.transfer(owner, amount);
263     }
264 }