1 // Invest LiteCoinE token
2 
3 pragma solidity ^0.4.25;
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract AltcoinToken {
33     function balanceOf(address _owner) constant public returns (uint256);
34     function transfer(address _to, uint256 _value) public returns (bool);
35 }
36 
37 contract ERC20Basic {
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45 }
46 
47 contract InvestLCE is ERC20 {
48     
49     using SafeMath for uint256;
50     address owner = msg.sender;
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;    
54 
55     address _tokenContract = 0x80D9bA39c7252CfeB23398D3DD32bfBE1772D790;
56     AltcoinToken thetoken = AltcoinToken(_tokenContract);
57 
58     uint256 public tokensPerEth = 50000e8;
59     uint256 public tokensPerAirdrop = 5e8;
60     uint256 public bonus = 0;
61     uint256 public airdropcounter = 0;
62     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
63     uint256 public constant extraBonus = 1 ether / 10; // 0.1 Ether
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
78     function InvestLCE () public {
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
116         bonus = 0;
117 
118         if ( msg.value >= extraBonus ) {
119             bonus = tokens / 4;
120         }
121 
122         tokens = tokens + bonus;
123         
124         sendtokens(thetoken, tokens, investor);
125     }
126     
127     function sendAirdrop() private returns (bool) {
128         uint256 tokens = 0;
129         
130         require( airdropcounter < 1000 );
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