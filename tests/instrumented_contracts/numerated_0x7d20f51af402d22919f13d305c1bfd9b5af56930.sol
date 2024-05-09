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
59     AltcoinToken cddtoken = AltcoinToken(_tokenContract);
60 
61     uint256 public tokensPerEth = 21500e4;
62     uint256 public bonus = 0;   
63     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
64     uint256 public constant extraBonus = 1 ether; // 1 Ether
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 
68     event Distr(address indexed to, uint256 amount);
69 
70     event TokensPerEthUpdated(uint _tokensPerEth);
71 
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76     
77     function InvestDRMK () public {
78         owner = msg.sender;
79     }
80     
81     function transferOwnership(address newOwner) onlyOwner public {
82         if (newOwner != address(0)) {
83             owner = newOwner;
84         }
85     }
86 
87     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
88         tokensPerEth = _tokensPerEth;
89         emit TokensPerEthUpdated(_tokensPerEth);
90     }
91            
92     function () external payable {
93         sendTokens();
94     }
95      
96     function sendTokens() private returns (bool) {
97         uint256 tokens = 0;
98 
99         require( msg.value >= minContribution );
100 
101         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
102         address investor = msg.sender;
103         bonus = 0;
104 
105         if ( msg.value >= extraBonus ) {
106             bonus = tokens / 2;
107         }
108 
109         tokens = tokens + bonus;
110         
111         sendtokens(cddtoken, tokens, investor);
112         address myAddress = this;
113         uint256 etherBalance = myAddress.balance;
114         owner.transfer(etherBalance);
115     }
116 
117     function balanceOf(address _owner) constant public returns (uint256) {
118         return balances[_owner];
119     }
120 
121     // mitigates the ERC20 short address attack
122     modifier onlyPayloadSize(uint size) {
123         assert(msg.data.length >= size + 4);
124         _;
125     }
126     
127     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
128 
129         require(_to != address(0));
130         require(_amount <= balances[msg.sender]);
131         
132         balances[msg.sender] = balances[msg.sender].sub(_amount);
133         balances[_to] = balances[_to].add(_amount);
134         emit Transfer(msg.sender, _to, _amount);
135         return true;
136     }
137     
138     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
139 
140         require(_to != address(0));
141         require(_amount <= balances[_from]);
142         require(_amount <= allowed[_from][msg.sender]);
143         
144         balances[_from] = balances[_from].sub(_amount);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
146         balances[_to] = balances[_to].add(_amount);
147         emit Transfer(_from, _to, _amount);
148         return true;
149     }
150     
151     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
152         AltcoinToken t = AltcoinToken(tokenAddress);
153         uint bal = t.balanceOf(who);
154         return bal;
155     }
156     
157     function withdraw() onlyOwner public {
158         address myAddress = this;
159         uint256 etherBalance = myAddress.balance;
160         owner.transfer(etherBalance);
161     }
162     
163     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
164         AltcoinToken anytoken = AltcoinToken(anycontract);
165         uint256 amount = anytoken.balanceOf(address(this));
166         return anytoken.transfer(owner, amount);
167     }
168     
169     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
170         AltcoinToken alttoken = AltcoinToken(contrato);
171         return alttoken.transfer(who, amount);
172     }
173 }