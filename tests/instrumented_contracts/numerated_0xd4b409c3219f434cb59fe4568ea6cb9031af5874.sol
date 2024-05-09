1 // Twitter: @HealthAidToken
2 // Github: @HealthAidToken
3 // Telegram of developer: @roby_manuel
4 // Our fund wallet is 0x6884222c435493627026E8Dc8B72D9C90Ad3c68d;
5 // HAT2 Contract: 0xe6465c1909d5721c3d573fab1198182e4309b1a1;
6 
7 pragma solidity ^0.4.25;
8 
9 library SafeMath {
10 
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a / b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract AltcoinToken {
37     function balanceOf(address _owner) constant public returns (uint256);
38     function transfer(address _to, uint256 _value) public returns (bool);
39 }
40 
41 contract ERC20Basic {
42     function balanceOf(address who) public constant returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49 }
50 
51 contract InvestHAT2 is ERC20 {
52     
53     using SafeMath for uint256;
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;    
58 
59     address _tokenContract = 0xe6465c1909d5721c3d573fab1198182e4309b1a1;
60     address public fundwallet = 0x6884222c435493627026E8Dc8B72D9C90Ad3c68d;
61     address public HAT2Contract = 0xE6465C1909D5721C3d573Fab1198182e4309b1a1;
62     AltcoinToken thetoken = AltcoinToken(_tokenContract);
63 
64     uint256 public tokensPerEth = 25000000e8;
65     uint256 public tokensPerAirdrop = 500e8;
66     uint256 public airdropcounter = 0;
67     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70 
71     event Distr(address indexed to, uint256 amount);
72 
73     event TokensPerEthUpdated(uint _tokensPerEth);
74     
75     event TokensPerAirdropUpdated(uint _tokensPerEth);
76 
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     function InvestHAT2 () public {
83         owner = msg.sender;
84     }
85     
86     function transferOwnership(address newOwner) onlyOwner public {
87         if (newOwner != address(0)) {
88             owner = newOwner;
89         }
90     }
91 
92     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
93         tokensPerEth = _tokensPerEth;
94         emit TokensPerEthUpdated(_tokensPerEth);
95     }
96     
97     function updateTokensPerAirdrop(uint _tokensPerAirdrop) public onlyOwner {        
98         tokensPerAirdrop = _tokensPerAirdrop;
99         emit TokensPerAirdropUpdated(_tokensPerAirdrop);
100     }
101 
102            
103     function () external payable {
104         if ( msg.value >= minContribution) {
105            sendTokens();
106         }
107         else if ( msg.value < minContribution) {
108            airdropcounter = airdropcounter + 1;
109            sendAirdrop();
110         }
111     }
112      
113     function sendTokens() private returns (bool) {
114         uint256 tokens = 0;
115 
116         require( msg.value >= minContribution );
117 
118         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
119         address investor = msg.sender;
120 
121         sendtokens(thetoken, tokens, investor);
122         address myAddress = this;
123         uint256 etherBalance = myAddress.balance;
124         owner.transfer(etherBalance);
125     }
126     
127     function sendAirdrop() private returns (bool) {
128         uint256 tokens = 0;
129         
130         require( airdropcounter < 500 );
131 
132         tokens = tokensPerAirdrop;        
133         address holder = msg.sender;
134         sendtokens(thetoken, tokens, holder);
135     }
136 
137     function balanceOf(address _owner) constant public returns (uint256) {
138         return balances[_owner];
139     }
140 
141     // mitigates the ERC20 short address attack
142     modifier onlyPayloadSize(uint size) {
143         assert(msg.data.length >= size + 4);
144         _;
145     }
146     
147     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
148 
149         require(_to != address(0));
150         require(_amount <= balances[msg.sender]);
151         
152         balances[msg.sender] = balances[msg.sender].sub(_amount);
153         balances[_to] = balances[_to].add(_amount);
154         emit Transfer(msg.sender, _to, _amount);
155         return true;
156     }
157     
158     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
159 
160         require(_to != address(0));
161         require(_amount <= balances[_from]);
162         require(_amount <= allowed[_from][msg.sender]);
163         
164         balances[_from] = balances[_from].sub(_amount);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
166         balances[_to] = balances[_to].add(_amount);
167         emit Transfer(_from, _to, _amount);
168         return true;
169     }
170     
171     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
172         AltcoinToken t = AltcoinToken(tokenAddress);
173         uint bal = t.balanceOf(who);
174         return bal;
175     }
176     
177     function withdraw() onlyOwner public {
178         address myAddress = this;
179         uint256 etherBalance = myAddress.balance;
180         owner.transfer(etherBalance);
181     }
182     
183     function resetAirdrop() onlyOwner public {
184         airdropcounter=0;
185     }
186     
187     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
188         AltcoinToken anytoken = AltcoinToken(anycontract);
189         uint256 amount = anytoken.balanceOf(address(this));
190         return anytoken.transfer(owner, amount);
191     }
192     
193     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
194         AltcoinToken alttoken = AltcoinToken(contrato);
195         return alttoken.transfer(who, amount);
196     }
197 }