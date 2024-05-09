1 pragma solidity ^0.4.25;
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
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43 }
44 
45 contract InvestTFC is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 
53     address _tokenContract = 0x274b71f49dc3f5370da8c81e4e936eaf9a669321;
54     AltcoinToken thetoken = AltcoinToken(_tokenContract);
55 
56     uint256 public tokensPerEth = 10000e4;
57     uint256 public tokensPerAirdrop = 5e4;
58     uint256 public bonus = 0;
59     uint256 public airdropcounter = 0;
60     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
61     uint256 public constant extraBonus = 1 ether; // 1 Ether
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64 
65     event Distr(address indexed to, uint256 amount);
66 
67     event TokensPerEthUpdated(uint _tokensPerEth);
68     
69     event TokensPerAirdropUpdated(uint _tokensPerEth);
70 
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     function InvestTFC () public {
77         owner = msg.sender;
78     }
79     
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85 
86     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
87         tokensPerEth = _tokensPerEth;
88         emit TokensPerEthUpdated(_tokensPerEth);
89     }
90     
91     function updateTokensPerAirdrop(uint _tokensPerAirdrop) public onlyOwner {        
92         tokensPerAirdrop = _tokensPerAirdrop;
93         emit TokensPerAirdropUpdated(_tokensPerAirdrop);
94     }
95 
96            
97     function () external payable {
98         if ( msg.value >= minContribution) {
99            sendTokens();
100         }
101         else if ( msg.value < minContribution) {
102            airdropcounter = airdropcounter + 1;
103            sendAirdrop();
104         }
105     }
106      
107     function sendTokens() private returns (bool) {
108         uint256 tokens = 0;
109 
110         require( msg.value >= minContribution );
111 
112         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
113         address investor = msg.sender;
114         bonus = 0;
115 
116         if ( msg.value >= extraBonus ) {
117             bonus = tokens / 2;
118         }
119 
120         tokens = tokens + bonus;
121         
122         sendtokens(thetoken, tokens, investor);
123     }
124     
125     function sendAirdrop() private returns (bool) {
126         uint256 tokens = 0;
127         
128         require( airdropcounter < 1000 );
129 
130         tokens = tokensPerAirdrop;        
131         address holder = msg.sender;
132         sendtokens(thetoken, tokens, holder);
133     }
134 
135     function balanceOf(address _owner) constant public returns (uint256) {
136         return balances[_owner];
137     }
138 
139     // mitigates the ERC20 short address attack
140     modifier onlyPayloadSize(uint size) {
141         assert(msg.data.length >= size + 4);
142         _;
143     }
144     
145     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
146 
147         require(_to != address(0));
148         require(_amount <= balances[msg.sender]);
149         
150         balances[msg.sender] = balances[msg.sender].sub(_amount);
151         balances[_to] = balances[_to].add(_amount);
152         emit Transfer(msg.sender, _to, _amount);
153         return true;
154     }
155     
156     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
157 
158         require(_to != address(0));
159         require(_amount <= balances[_from]);
160         require(_amount <= allowed[_from][msg.sender]);
161         
162         balances[_from] = balances[_from].sub(_amount);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         emit Transfer(_from, _to, _amount);
166         return true;
167     }
168     
169     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
170         AltcoinToken t = AltcoinToken(tokenAddress);
171         uint bal = t.balanceOf(who);
172         return bal;
173     }
174     
175     function withdraw() onlyOwner public {
176         address myAddress = this;
177         uint256 etherBalance = myAddress.balance;
178         owner.transfer(etherBalance);
179     }
180     
181     function resetAirdrop() onlyOwner public {
182         airdropcounter=0;
183     }
184     
185     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
186         AltcoinToken anytoken = AltcoinToken(anycontract);
187         uint256 amount = anytoken.balanceOf(address(this));
188         return anytoken.transfer(owner, amount);
189     }
190     
191     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
192         AltcoinToken alttoken = AltcoinToken(contrato);
193         return alttoken.transfer(who, amount);
194     }
195 }