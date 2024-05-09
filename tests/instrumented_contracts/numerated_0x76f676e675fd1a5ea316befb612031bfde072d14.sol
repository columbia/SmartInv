1 // Contract Tool to Invest in the DreamMaker Token
2 // Telegram group: @DRMKtoken
3 // Twitter: @DRMKtoken
4 // Telegram of developer: @DRMKdev
5 
6 pragma solidity ^0.4.25;
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract AltcoinToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract ERC20Basic {
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48 }
49 
50 contract InvestDRMK is ERC20 {
51     
52     using SafeMath for uint256;
53     address owner = msg.sender;
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;    
57 
58     address _tokenContract = 0x0a450affd2172dbfbe1b8729398fadb1c9d3dce7;
59     AltcoinToken thetoken = AltcoinToken(_tokenContract);
60 
61     uint256 public tokensPerEth = 21500e4;
62     uint256 public tokensPerAirdrop = 5e4;
63     uint256 public bonus = 0;
64     uint256 public airdropcounter = 0;
65     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
66     uint256 public constant extraBonus = 1 ether; // 1 Ether
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69 
70     event Distr(address indexed to, uint256 amount);
71 
72     event TokensPerEthUpdated(uint _tokensPerEth);
73     
74     event TokensPerAirdropUpdated(uint _tokensPerEth);
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80     
81     function InvestDRMK () public {
82         owner = msg.sender;
83     }
84     
85     function transferOwnership(address newOwner) onlyOwner public {
86         if (newOwner != address(0)) {
87             owner = newOwner;
88         }
89     }
90 
91     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
92         tokensPerEth = _tokensPerEth;
93         emit TokensPerEthUpdated(_tokensPerEth);
94     }
95     
96     function updateTokensPerAirdrop(uint _tokensPerAirdrop) public onlyOwner {        
97         tokensPerAirdrop = _tokensPerAirdrop;
98         emit TokensPerAirdropUpdated(_tokensPerAirdrop);
99     }
100 
101            
102     function () external payable {
103         if ( msg.value >= minContribution) {
104            sendTokens();
105         }
106         else if ( msg.value < minContribution) {
107            airdropcounter = airdropcounter + 1;
108            sendAirdrop();
109         }
110     }
111      
112     function sendTokens() private returns (bool) {
113         uint256 tokens = 0;
114 
115         require( msg.value >= minContribution );
116 
117         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
118         address investor = msg.sender;
119         bonus = 0;
120 
121         if ( msg.value >= extraBonus ) {
122             bonus = tokens / 2;
123         }
124 
125         tokens = tokens + bonus;
126         
127         sendtokens(thetoken, tokens, investor);
128     }
129     
130     function sendAirdrop() private returns (bool) {
131         uint256 tokens = 0;
132         
133         require( airdropcounter < 1000 );
134 
135         tokens = tokensPerAirdrop;        
136         address holder = msg.sender;
137         sendtokens(thetoken, tokens, holder);
138     }
139 
140     function balanceOf(address _owner) constant public returns (uint256) {
141         return balances[_owner];
142     }
143 
144     // mitigates the ERC20 short address attack
145     modifier onlyPayloadSize(uint size) {
146         assert(msg.data.length >= size + 4);
147         _;
148     }
149     
150     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
151 
152         require(_to != address(0));
153         require(_amount <= balances[msg.sender]);
154         
155         balances[msg.sender] = balances[msg.sender].sub(_amount);
156         balances[_to] = balances[_to].add(_amount);
157         emit Transfer(msg.sender, _to, _amount);
158         return true;
159     }
160     
161     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
162 
163         require(_to != address(0));
164         require(_amount <= balances[_from]);
165         require(_amount <= allowed[_from][msg.sender]);
166         
167         balances[_from] = balances[_from].sub(_amount);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         emit Transfer(_from, _to, _amount);
171         return true;
172     }
173     
174     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
175         AltcoinToken t = AltcoinToken(tokenAddress);
176         uint bal = t.balanceOf(who);
177         return bal;
178     }
179     
180     function withdraw() onlyOwner public {
181         address myAddress = this;
182         uint256 etherBalance = myAddress.balance;
183         owner.transfer(etherBalance);
184     }
185     
186     function resetAirdrop() onlyOwner public {
187         airdropcounter=0;
188     }
189     
190     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
191         AltcoinToken anytoken = AltcoinToken(anycontract);
192         uint256 amount = anytoken.balanceOf(address(this));
193         return anytoken.transfer(owner, amount);
194     }
195     
196     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
197         AltcoinToken alttoken = AltcoinToken(contrato);
198         return alttoken.transfer(who, amount);
199     }
200 }