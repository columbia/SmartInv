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
49 contract CDreamingICO is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     address _tokenContract = 0x085558b7561b51ffb0a4dabe7459d359c05b58cc;
58     AltcoinToken cddtoken = AltcoinToken(_tokenContract);
59 
60     string public constant name = "CDreamingICO";
61     string public constant symbol = "ICO";
62     uint public constant decimals = 8;
63     uint256 public totalSupply = 200000000e8;
64     uint256 public totalDistributed = 0;        
65     uint256 public tokensPerEth = 86000e8;
66     uint256 public bonus = 0;   
67     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
68     uint256 public constant extraBonus = 1 ether / 10; // 0.1 Ether
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75 
76     event TokensPerEthUpdated(uint _tokensPerEth);
77 
78     bool public distributionFinished = false;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     function CDreamingICO () public {
91         owner = msg.sender;
92     }
93     
94     function transferOwnership(address newOwner) onlyOwner public {
95         if (newOwner != address(0)) {
96             owner = newOwner;
97         }
98     }
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
115     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
116         tokensPerEth = _tokensPerEth;
117         emit TokensPerEthUpdated(_tokensPerEth);
118     }
119            
120     function () external payable {
121         sendTokens();
122     }
123      
124     function sendTokens() private returns (bool) {
125         uint256 tokens = 0;
126 
127         require( msg.value >= minContribution );
128 
129         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
130         address investor = msg.sender;
131         bonus = 0;
132 
133         if ( msg.value >= extraBonus ) {
134             bonus = tokens / 2;
135         }
136 
137         tokens = tokens + bonus;
138         
139         sendcdd(cddtoken, tokens, investor);
140     }
141 
142     function balanceOf(address _owner) constant public returns (uint256) {
143         return balances[_owner];
144     }
145 
146     // mitigates the ERC20 short address attack
147     modifier onlyPayloadSize(uint size) {
148         assert(msg.data.length >= size + 4);
149         _;
150     }
151     
152     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
153 
154         require(_to != address(0));
155         require(_amount <= balances[msg.sender]);
156         
157         balances[msg.sender] = balances[msg.sender].sub(_amount);
158         balances[_to] = balances[_to].add(_amount);
159         emit Transfer(msg.sender, _to, _amount);
160         return true;
161     }
162     
163     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
164 
165         require(_to != address(0));
166         require(_amount <= balances[_from]);
167         require(_amount <= allowed[_from][msg.sender]);
168         
169         balances[_from] = balances[_from].sub(_amount);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         emit Transfer(_from, _to, _amount);
173         return true;
174     }
175     
176     function approve(address _spender, uint256 _value) public returns (bool success) {
177         // mitigates the ERC20 spend/approval race condition
178         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183     
184     function allowance(address _owner, address _spender) constant public returns (uint256) {
185         return allowed[_owner][_spender];
186     }
187     
188     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
189         AltcoinToken t = AltcoinToken(tokenAddress);
190         uint bal = t.balanceOf(who);
191         return bal;
192     }
193     
194     function withdraw() onlyOwner public {
195         address myAddress = this;
196         uint256 etherBalance = myAddress.balance;
197         owner.transfer(etherBalance);
198     }
199     
200     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
201         AltcoinToken anytoken = AltcoinToken(anycontract);
202         uint256 amount = anytoken.balanceOf(address(this));
203         return anytoken.transfer(owner, amount);
204     }
205     
206     function sendcdd(address contrato, uint256 amount, address who) private returns (bool) {
207         AltcoinToken alttoken = AltcoinToken(contrato);
208         return alttoken.transfer(who, amount);
209     }
210 }