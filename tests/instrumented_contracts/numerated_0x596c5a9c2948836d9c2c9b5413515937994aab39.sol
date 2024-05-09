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
52 contract XBORNID is ERC20 {
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
63     string public constant name = "XBORN ID";
64     string public constant symbol = "XBORNID";
65     uint public constant decimals = 18;
66     
67 uint256 public totalSupply = 1000000000e18;
68     
69 uint256 public totalDistributed = 300000000e18;
70     
71 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
72     
73 uint256 public value = 30000e18;
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
104     constructor() public {
105         owner = msg.sender;
106         balances[owner] = totalDistributed;
107     }
108     
109     function transferOwnership(address newOwner) onlyOwner public {
110         if (newOwner != address(0)) {
111             owner = newOwner;
112         }
113     }
114     
115     function finishDistribution() onlyOwner canDistr public returns (bool) {
116         distributionFinished = true;
117         emit DistrFinished();
118         return true;
119     }
120     
121     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
122         totalDistributed = totalDistributed.add(_amount);
123         totalRemaining = totalRemaining.sub(_amount);
124         balances[_to] = balances[_to].add(_amount);
125         emit Distr(_to, _amount);
126         emit Transfer(address(0), _to, _amount);
127         return true;
128         
129         if (totalDistributed >= totalSupply) {
130             distributionFinished = true;
131         }
132     }
133     
134     function () external payable {
135         getTokens();
136      }
137     
138     function getTokens() payable canDistr onlyWhitelist public {
139         if (value > totalRemaining) {
140             value = totalRemaining;
141         }
142         
143         require(value <= totalRemaining);
144         
145         address investor = msg.sender;
146         uint256 toGive = value;
147         
148         distr(investor, toGive);
149         
150         if (toGive > 0) {
151             blacklist[investor] = true;
152         }
153 
154         if (totalDistributed >= totalSupply) {
155             distributionFinished = true;
156         }
157         
158         value = value.div(100000).mul(99999);
159     }
160     
161     function doAirdrop(address _participant, uint _amount) internal {
162 
163         require( _amount > 0 );      
164 
165         require( totalDistributed < totalSupply );
166         
167         balances[_participant] = balances[_participant].add(_amount);
168         totalDistributed = totalDistributed.add(_amount);
169 
170         if (totalDistributed >= totalSupply) {
171             distributionFinished = true;
172         }
173 
174         // log
175         emit Airdrop(_participant, _amount, balances[_participant]);
176         emit Transfer(address(0), _participant, _amount);
177     }
178 
179     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
180         doAirdrop(_participant, _amount);
181     }
182 
183     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
184         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
185     }
186 
187     function balanceOf(address _owner) constant public returns (uint256) {
188         return balances[_owner];
189     }
190 
191     modifier onlyPayloadSize(uint size) {
192         assert(msg.data.length >= size + 4);
193         _;
194     }
195     
196     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
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
207         require(_to != address(0));
208         require(_amount <= balances[_from]);
209         require(_amount <= allowed[_from][msg.sender]);
210         
211         balances[_from] = balances[_from].sub(_amount);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
213         balances[_to] = balances[_to].add(_amount);
214         emit Transfer(_from, _to, _amount);
215         return true;
216     }
217     
218     function approve(address _spender, uint256 _value) public returns (bool success) {
219         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224     
225     function allowance(address _owner, address _spender) constant public returns (uint256) {
226         return allowed[_owner][_spender];
227     }
228     
229     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
230         ForeignToken t = ForeignToken(tokenAddress);
231         uint bal = t.balanceOf(who);
232         return bal;
233     }
234     
235     function withdraw() onlyOwner public {
236         uint256 etherBalance = address(this).balance;
237         owner.transfer(etherBalance);
238     }
239     
240     function burn(uint256 _value) onlyOwner public {
241         require(_value <= balances[msg.sender]);
242 
243         address burner = msg.sender;
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         totalDistributed = totalDistributed.sub(_value);
247         emit Burn(burner, _value);
248     }
249     
250     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
251         ForeignToken token = ForeignToken(_tokenContract);
252         uint256 amount = token.balanceOf(address(this));
253         return token.transfer(owner, amount);
254     }
255 }