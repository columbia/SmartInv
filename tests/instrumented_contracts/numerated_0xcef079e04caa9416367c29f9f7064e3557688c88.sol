1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title Safemath library taken from openzeppline
5 *
6 **/
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ForeignToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 interface Token { 
56     function distr(address _to, uint256 _value)  external returns (bool);
57     function totalSupply() constant external returns (uint256 supply);
58     function balanceOf(address _owner) constant external returns (uint256 balance);
59 }
60 
61 contract GlobalTourToken is ERC20 {
62     
63     using SafeMath for uint256;
64     address owner = msg.sender;
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;    
68 
69     string public constant name = "Global Tour Token";
70     string public constant symbol = "GTT";
71     uint public constant decimals = 8;
72     
73     uint256 public totalSupply = 10000000000e8;
74     uint256 public totalDistributed = 1000000000e8;    
75     uint256 public value;
76     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100; // 0.01 Ether
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     event Distr(address indexed to, uint256 amount);
82     event DistrFinished();
83     
84     event Burn(address indexed burner, uint256 value);
85 
86     bool public distributionFinished = false;
87     
88     modifier canDistr() {
89         require(!distributionFinished);
90         _;
91     }
92     
93     modifier onlyOwner() {
94         require(msg.sender == owner);
95         _;
96     }
97     
98     
99     function GlobalTourToken () public {
100         owner = msg.sender;
101         value = 200000e8;
102         distr(owner, totalDistributed);
103     }
104     
105     function transferOwnership(address newOwner) onlyOwner public {
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110     
111 
112     function finishDistribution() onlyOwner canDistr public returns (bool) {
113         distributionFinished = true;
114         emit DistrFinished();
115         return true;
116     }
117     
118     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
119         totalDistributed = totalDistributed.add(_amount);        
120         balances[_to] = balances[_to].add(_amount);
121         emit Distr(_to, _amount);
122         emit Transfer(address(0), _to, _amount);
123 
124         return true;
125     }
126            
127     function () external payable {
128             getTokens();
129      }
130     
131     function getTokens() payable canDistr  public {
132         
133         // minimum contribution
134         require( msg.value >= MIN_CONTRIBUTION );
135 
136         uint256 toGive = value;
137         address investor = msg.sender;
138         distr(investor, toGive);
139 
140         if (totalDistributed >= totalSupply) {
141             distributionFinished = true;
142         }
143     }
144 
145     function balanceOf(address _owner) constant public returns (uint256) {
146         return balances[_owner];
147     }
148 
149     // mitigates the ERC20 short address attack
150     modifier onlyPayloadSize(uint size) {
151         assert(msg.data.length >= size + 4);
152         _;
153     }
154     
155     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
156 
157         require(_to != address(0));
158         require(_amount <= balances[msg.sender]);
159         
160         balances[msg.sender] = balances[msg.sender].sub(_amount);
161         balances[_to] = balances[_to].add(_amount);
162         emit Transfer(msg.sender, _to, _amount);
163         return true;
164     }
165     
166     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
167 
168         require(_to != address(0));
169         require(_amount <= balances[_from]);
170         require(_amount <= allowed[_from][msg.sender]);
171         
172         balances[_from] = balances[_from].sub(_amount);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         emit Transfer(_from, _to, _amount);
176         return true;
177     }
178     
179     function approve(address _spender, uint256 _value) public returns (bool success) {
180         // mitigates the ERC20 spend/approval race condition
181         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186     
187     function allowance(address _owner, address _spender) constant public returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190     
191     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
192         ForeignToken t = ForeignToken(tokenAddress);
193         uint bal = t.balanceOf(who);
194         return bal;
195     }
196     
197     function withdraw() onlyOwner public {
198         address myAddress = this;
199         uint256 etherBalance = myAddress.balance;
200         owner.transfer(etherBalance);
201     }
202     
203     function burn(uint256 _value) onlyOwner public {
204         require(_value <= balances[msg.sender]);
205         // no need to require value <= totalSupply, since that would imply the
206         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208         address burner = msg.sender;
209         balances[burner] = balances[burner].sub(_value);
210         totalSupply = totalSupply.sub(_value);
211         totalDistributed = totalDistributed.sub(_value);
212         emit Burn(burner, _value);
213     }
214     
215     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
216         ForeignToken token = ForeignToken(_tokenContract);
217         uint256 amount = token.balanceOf(address(this));
218         return token.transfer(owner, amount);
219     }
220 }