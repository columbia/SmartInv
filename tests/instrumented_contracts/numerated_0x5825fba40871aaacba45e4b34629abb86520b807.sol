1 pragma solidity ^0.4.25;
2 
3 library SafeMath { 
4     
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         assert(b <= a);
7         return a - b;
8     }
9     
10     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         c = a + b;
12         assert(c >= a);
13         return c;
14     }
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23     
24     function div(uint256 a, uint256 b) internal pure returns (uint256) { 
25         return a / b;
26     }
27 }
28 
29 contract ERC20Basic {
30     uint256 public totalSupply;
31     function balanceOf(address who) public constant returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender) public constant returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 contract AltcoinToken {
45     function balanceOf(address _owner) constant public returns (uint256);
46     function transfer(address _to, uint256 _value) public returns (bool);
47 }
48 contract CPAY is ERC20 {
49     
50     using SafeMath for uint256;
51     address owner = msg.sender;
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;    
55 
56     string public constant name = "ChainPay";
57     string public constant symbol = "CPAY";
58     uint public constant decimals = 8;
59     
60     uint256 public totalSupply = 5555555e8;
61     uint256 public totalDistributed = 0;     
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     
66     event Distr(address indexed to, uint256 amount);
67     event DistrFinished();
68 
69     event Airdrop(address indexed _owner, uint _amount, uint _balance); 
70     
71     event Burn(address indexed burner, uint256 value);
72 
73     bool public distributionFinished = false;
74     
75     modifier canDistr() {
76         require(!distributionFinished);
77         _;
78     }
79     
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     constructor() public {
86         owner = msg.sender;
87         
88         uint256 devTokens = (totalSupply);
89         distr(owner, devTokens); 
90     }
91     
92     
93     function transferOwnership(address newOwner) onlyOwner public {
94         if (newOwner != address(0)) {
95             owner = newOwner;
96         }
97     }
98     
99 
100     function finishDistribution() onlyOwner canDistr public returns (bool) {
101         distributionFinished = true;
102         emit DistrFinished();
103         return true;
104     }
105     
106     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
107         totalDistributed = totalDistributed.add(_amount);        
108         balances[_to] = balances[_to].add(_amount);
109         emit Distr(_to, _amount);
110         emit Transfer(address(0), _to, _amount);
111 
112         return true;
113     }
114 
115     function doAirdrop(address _participant, uint _amount) internal {
116 
117         require( _amount > 0 );      
118 
119         require( totalDistributed < totalSupply );
120         
121         balances[_participant] = balances[_participant].add(_amount);
122         totalDistributed = totalDistributed.add(_amount);
123 
124         if (totalDistributed >= totalSupply) {
125             distributionFinished = true;
126         }
127 
128         // log
129         emit Airdrop(_participant, _amount, balances[_participant]);
130         emit Transfer(address(0), _participant, _amount);
131     }
132 
133     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
134         doAirdrop(_participant, _amount);
135     }
136 
137     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
138         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
139     }
140     
141     function () external payable {
142         getTokens();
143      }
144     
145     function getTokens() payable canDistr  public { 
146 
147         require( msg.value > 0 ); 
148 
149         if (totalDistributed >= totalSupply) {
150             distributionFinished = true;
151         }
152     }
153 
154     function balanceOf(address _owner) constant public returns (uint256) {
155         return balances[_owner];
156     }
157 
158 
159     modifier onlyPayloadSize(uint size) {
160         assert(msg.data.length >= size + 4);
161         _;
162     }
163     
164     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
165 
166         require(_to != address(0));
167         require(_amount <= balances[msg.sender]);
168         
169         balances[msg.sender] = balances[msg.sender].sub(_amount);
170         balances[_to] = balances[_to].add(_amount);
171         emit Transfer(msg.sender, _to, _amount);
172         return true;
173     }
174     
175     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
176 
177         require(_to != address(0));
178         require(_amount <= balances[_from]);
179         require(_amount <= allowed[_from][msg.sender]);
180         
181         balances[_from] = balances[_from].sub(_amount);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
183         balances[_to] = balances[_to].add(_amount);
184         emit Transfer(_from, _to, _amount);
185         return true;
186     }
187     
188     function approve(address _spender, uint256 _value) public returns (bool success) {
189         // mitigates the ERC20 spend/approval race condition
190         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
191         allowed[msg.sender][_spender] = _value;
192         emit Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     function allowance(address _owner, address _spender) constant public returns (uint256) {
197         return allowed[_owner][_spender];
198     }
199     
200     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
201         AltcoinToken t = AltcoinToken(tokenAddress);
202         uint bal = t.balanceOf(who);
203         return bal;
204     }
205     
206     function withdraw() onlyOwner public {
207         address myAddress = this;
208         uint256 etherBalance = myAddress.balance;
209         owner.transfer(etherBalance);
210     }
211     
212     function burn(uint256 _value) onlyOwner public {
213         require(_value <= balances[msg.sender]);
214         
215         address burner = msg.sender;
216         balances[burner] = balances[burner].sub(_value);
217         totalSupply = totalSupply.sub(_value);
218         totalDistributed = totalDistributed.sub(_value);
219         emit Burn(burner, _value);
220     }
221     
222     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
223         AltcoinToken token = AltcoinToken(_tokenContract);
224         uint256 amount = token.balanceOf(address(this));
225         return token.transfer(owner, amount);
226     }  
227 
228 }