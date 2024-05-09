1 // Twitter: @HealthAidToken
2 // Github: @HealthAidToken
3 // Telegram of developer: @roby_manuel
4 
5 pragma solidity ^0.4.25;
6 
7 library SafeMath {
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
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract AltcoinToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47 }
48 
49 contract InvestHAT2 is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     address _tokenContract = 0xe6465c1909d5721c3d573fab1198182e4309b1a1;
58     AltcoinToken thetoken = AltcoinToken(_tokenContract);
59 
60     uint256 public tokensPerEth = 25000000e8;
61     uint256 public tokensPerAirdrop = 500e8;
62     uint256 public airdropcounter = 0;
63     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 
67     event Distr(address indexed to, uint256 amount);
68 
69     event TokensPerEthUpdated(uint _tokensPerEth);
70     
71     event TokensPerAirdropUpdated(uint _tokensPerEth);
72 
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77     
78     function InvestHAT2 () public {
79         owner = msg.sender;
80     }
81     
82     function transferOwnership(address newOwner) onlyOwner public {
83         if (newOwner != address(0)) {
84             owner = newOwner;
85         }
86     }
87 
88     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
89         tokensPerEth = _tokensPerEth;
90         emit TokensPerEthUpdated(_tokensPerEth);
91     }
92     
93     function updateTokensPerAirdrop(uint _tokensPerAirdrop) public onlyOwner {        
94         tokensPerAirdrop = _tokensPerAirdrop;
95         emit TokensPerAirdropUpdated(_tokensPerAirdrop);
96     }
97 
98            
99     function () external payable {
100         if ( msg.value >= minContribution) {
101            sendTokens();
102         }
103         else if ( msg.value < minContribution) {
104            airdropcounter = airdropcounter + 1;
105            sendAirdrop();
106         }
107     }
108      
109     function sendTokens() private returns (bool) {
110         uint256 tokens = 0;
111 
112         require( msg.value >= minContribution );
113 
114         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
115         address investor = msg.sender;
116 
117         sendtokens(thetoken, tokens, investor);
118         address myAddress = this;
119         uint256 etherBalance = myAddress.balance;
120         owner.transfer(etherBalance);
121     }
122     
123     function sendAirdrop() private returns (bool) {
124         uint256 tokens = 0;
125         
126         require( airdropcounter < 1000 );
127 
128         tokens = tokensPerAirdrop;        
129         address holder = msg.sender;
130         sendtokens(thetoken, tokens, holder);
131     }
132 
133     function balanceOf(address _owner) constant public returns (uint256) {
134         return balances[_owner];
135     }
136 
137     // mitigates the ERC20 short address attack
138     modifier onlyPayloadSize(uint size) {
139         assert(msg.data.length >= size + 4);
140         _;
141     }
142     
143     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
144 
145         require(_to != address(0));
146         require(_amount <= balances[msg.sender]);
147         
148         balances[msg.sender] = balances[msg.sender].sub(_amount);
149         balances[_to] = balances[_to].add(_amount);
150         emit Transfer(msg.sender, _to, _amount);
151         return true;
152     }
153     
154     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
155 
156         require(_to != address(0));
157         require(_amount <= balances[_from]);
158         require(_amount <= allowed[_from][msg.sender]);
159         
160         balances[_from] = balances[_from].sub(_amount);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit Transfer(_from, _to, _amount);
164         return true;
165     }
166     
167     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
168         AltcoinToken t = AltcoinToken(tokenAddress);
169         uint bal = t.balanceOf(who);
170         return bal;
171     }
172     
173     function withdraw() onlyOwner public {
174         address myAddress = this;
175         uint256 etherBalance = myAddress.balance;
176         owner.transfer(etherBalance);
177     }
178     
179     function resetAirdrop() onlyOwner public {
180         airdropcounter=0;
181     }
182     
183     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
184         AltcoinToken anytoken = AltcoinToken(anycontract);
185         uint256 amount = anytoken.balanceOf(address(this));
186         return anytoken.transfer(owner, amount);
187     }
188     
189     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
190         AltcoinToken alttoken = AltcoinToken(contrato);
191         return alttoken.transfer(who, amount);
192     }
193 }