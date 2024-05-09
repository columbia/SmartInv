1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract AltcoinToken {
46     function balanceOf(address _owner) constant public returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48 }
49 
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public constant returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58     function allowance(address owner, address spender) public constant returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract LEVEBET is ERC20 {
65     
66     using SafeMath for uint256;
67     address owner = msg.sender;
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;    
71 
72     string public constant name = "LEVEBET Token";
73     string public constant symbol = "VCB";
74     uint public constant decimals = 18;
75     
76     uint256 public totalSupply = 20000000e18;
77     uint256 public totalDistributed = 0;
78     
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     
82     event Distr(address indexed to, uint256 amount);
83     event DistrFinished();
84 
85     event Airdrop(address indexed _owner, uint _amount, uint _balance);
86 
87     event TokensPerEthUpdated(uint _tokensPerEth);
88     
89     event Burn(address indexed burner, uint256 value);
90 
91     bool public distributionFinished = false;
92     
93     modifier canDistr() {
94         require(!distributionFinished);
95         _;
96     }
97     
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102     
103     function LEVEBET () public {
104         owner = msg.sender;
105         uint256 devTokens = 4000000e18;
106         distr(owner, devTokens);
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
123         balances[_to] = balances[_to].add(_amount);
124         emit Distr(_to, _amount);
125         emit Transfer(address(0), _to, _amount);
126 
127         return true;
128     }
129 
130     function () external payable {
131         getTokens();
132      }
133     
134     function getTokens() payable canDistr  public {
135         uint256 tokens = 0;
136 
137         require( msg.value > 0 );
138         
139         address investor = msg.sender;
140         
141         if (tokens > 0) {
142             distr(investor, tokens);
143         }
144 
145         if (totalDistributed >= totalSupply) {
146             distributionFinished = true;
147         }
148     }
149 
150     function balanceOf(address _owner) constant public returns (uint256) {
151         return balances[_owner];
152     }
153 
154     // mitigates the ERC20 short address attack
155     modifier onlyPayloadSize(uint size) {
156         assert(msg.data.length >= size + 4);
157         _;
158     }
159     
160     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
161 
162         require(_to != address(0));
163         require(_amount <= balances[msg.sender]);
164         
165         balances[msg.sender] = balances[msg.sender].sub(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         emit Transfer(msg.sender, _to, _amount);
168         return true;
169     }
170     
171     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
172 
173         require(_to != address(0));
174         require(_amount <= balances[_from]);
175         require(_amount <= allowed[_from][msg.sender]);
176         
177         balances[_from] = balances[_from].sub(_amount);
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         emit Transfer(_from, _to, _amount);
181         return true;
182     }
183     
184     function approve(address _spender, uint256 _value) public returns (bool success) {
185         // mitigates the ERC20 spend/approval race condition
186         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191     
192     function allowance(address _owner, address _spender) constant public returns (uint256) {
193         return allowed[_owner][_spender];
194     }
195     
196     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
197         AltcoinToken t = AltcoinToken(tokenAddress);
198         uint bal = t.balanceOf(who);
199         return bal;
200     }
201     
202     function withdraw() onlyOwner public {
203         address myAddress = this;
204         uint256 etherBalance = myAddress.balance;
205         owner.transfer(etherBalance);
206     }
207     
208     function burn(uint256 _value) onlyOwner public {
209         require(_value <= balances[msg.sender]);
210         
211         address burner = msg.sender;
212         balances[burner] = balances[burner].sub(_value);
213         totalSupply = totalSupply.sub(_value);
214         emit Burn(burner, _value);
215     }
216     
217     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
218         AltcoinToken token = AltcoinToken(_tokenContract);
219         uint256 amount = token.balanceOf(address(this));
220         return token.transfer(owner, amount);
221     }
222 }