1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() constant external returns (uint256 supply);
49     function balanceOf(address _owner) constant external returns (uint256 balance);
50 }
51 
52 contract Dogethereum is ERC20 {
53 
54  
55     
56     using SafeMath for uint256;
57     address owner = msg.sender;
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     mapping (address => bool) public blacklist;
62 
63     string public name;
64     string public symbol;
65     uint public decimals= 18;
66     
67 uint256 public totalSupply = 100000000000e18;
68     
69 uint256 public totalDistributed = 99800000000e18;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public value = 5000e18;
74 
75 
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     
80     event Distr(address indexed to, uint256 amount);
81     event DistrFinished();
82     
83     event Airdrop(address indexed _owner, uint _amount, uint _balance);
84     
85     event Burn(address indexed burner, uint256 value);
86 
87     bool public distributionFinished = false;
88     
89     modifier canDistr() {
90         require(!distributionFinished);
91         _;
92     }
93     
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98     
99     modifier onlyWhitelist() {
100         require(blacklist[msg.sender] == false);
101         _;
102     }
103     
104     function Dogethereum (    
105         uint256 initialSupply,
106         string tokenName,
107         string tokenSymbol
108         ) public {
109         owner = msg.sender;
110         balances[owner] = totalDistributed;
111         name = tokenName;                                   
112         symbol = tokenSymbol;                               
113     }
114     
115     function transferOwnership(address newOwner) onlyOwner public {
116         if (newOwner != address(0)) {
117             owner = newOwner;
118         }
119     }
120     
121     function finishDistribution() onlyOwner canDistr public returns (bool) {
122         distributionFinished = true;
123         emit DistrFinished();
124         return true;
125     }
126     
127     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
128         totalDistributed = totalDistributed.add(_amount);
129         totalRemaining = totalRemaining.sub(_amount);
130         balances[_to] = balances[_to].add(_amount);
131         emit Distr(_to, _amount);
132         emit Transfer(address(0), _to, _amount);
133         return true;
134         
135         if (totalDistributed >= totalSupply) {
136             distributionFinished = true;
137         }
138     }
139     
140     function () external payable {
141         getTokens();
142      }
143     
144     function getTokens() payable canDistr onlyWhitelist public {
145         if (value > totalRemaining) {
146             value = totalRemaining;
147         }
148         
149         require(value <= totalRemaining);
150         
151         address investor = msg.sender;
152         uint256 toGive = value;
153         
154         distr(investor, toGive);
155         
156         if (toGive > 0) {
157             blacklist[investor] = true;
158         }
159 
160         if (totalDistributed >= totalSupply) {
161             distributionFinished = true;
162         }
163         
164         value = value.div(100000).mul(99999);
165     }
166     
167     function doAirdrop(address _participant, uint _amount) internal {
168 
169         require( _amount > 0 );      
170 
171         require( totalDistributed < totalSupply );
172         
173         balances[_participant] = balances[_participant].add(_amount);
174         totalDistributed = totalDistributed.add(_amount);
175 
176         if (totalDistributed >= totalSupply) {
177             distributionFinished = true;
178         }
179 
180         // log
181         emit Airdrop(_participant, _amount, balances[_participant]);
182         emit Transfer(address(0), _participant, _amount);
183     }
184 
185     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
186         doAirdrop(_participant, _amount);
187     }
188 
189     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
190         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
191     }
192 
193     function balanceOf(address _owner) constant public returns (uint256) {
194         return balances[_owner];
195     }
196 
197     modifier onlyPayloadSize(uint size) {
198         assert(msg.data.length >= size + 4);
199         _;
200     }
201     
202     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
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
213         require(_to != address(0));
214         require(_amount <= balances[_from]);
215         require(_amount <= allowed[_from][msg.sender]);
216         
217         balances[_from] = balances[_from].sub(_amount);
218         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
219         balances[_to] = balances[_to].add(_amount);
220         emit Transfer(_from, _to, _amount);
221         return true;
222     }
223     
224     function approve(address _spender, uint256 _value) public returns (bool success) {
225         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230     
231     function allowance(address _owner, address _spender) constant public returns (uint256) {
232         return allowed[_owner][_spender];
233     }
234     
235     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
236         ForeignToken t = ForeignToken(tokenAddress);
237         uint bal = t.balanceOf(who);
238         return bal;
239     }
240     
241     function withdraw() onlyOwner public {
242         uint256 etherBalance = address(this).balance;
243         owner.transfer(etherBalance);
244     }
245     
246     function burn(uint256 _value) onlyOwner public {
247         require(_value <= balances[msg.sender]);
248 
249         address burner = msg.sender;
250         balances[burner] = balances[burner].sub(_value);
251         totalSupply = totalSupply.sub(_value);
252         totalDistributed = totalDistributed.sub(_value);
253         emit Burn(burner, _value);
254     }
255     
256     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
257         ForeignToken token = ForeignToken(_tokenContract);
258         uint256 amount = token.balanceOf(address(this));
259         return token.transfer(owner, amount);
260     }
261 }