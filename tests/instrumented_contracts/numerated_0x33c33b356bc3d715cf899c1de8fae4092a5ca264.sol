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
45 contract ICOcontract is ERC20 {
46     
47     using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;    
52 
53     address _tokenContract = 0x0a450affd2172dbfbe1b8729398fadb1c9d3dce7;
54     AltcoinToken cddtoken = AltcoinToken(_tokenContract);
55 
56     uint256 public tokensPerEth = 86000e4;
57     uint256 public bonus = 0;   
58     uint256 public constant minContribution = 1 ether / 1000; // 0.001 Ether
59     uint256 public constant extraBonus = 1 ether / 10; // 0.1 Ether
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62 
63     event Distr(address indexed to, uint256 amount);
64 
65     event TokensPerEthUpdated(uint _tokensPerEth);
66 
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71     
72     function ICOcontract () public {
73         owner = msg.sender;
74     }
75     
76     function transferOwnership(address newOwner) onlyOwner public {
77         if (newOwner != address(0)) {
78             owner = newOwner;
79         }
80     }
81 
82     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
83         tokensPerEth = _tokensPerEth;
84         emit TokensPerEthUpdated(_tokensPerEth);
85     }
86            
87     function () external payable {
88         sendTokens();
89     }
90      
91     function sendTokens() private returns (bool) {
92         uint256 tokens = 0;
93 
94         require( msg.value >= minContribution );
95 
96         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
97         address investor = msg.sender;
98         bonus = 0;
99 
100         if ( msg.value >= extraBonus ) {
101             bonus = tokens / 2;
102         }
103 
104         tokens = tokens + bonus;
105         
106         sendtokens(cddtoken, tokens, investor);
107         address myAddress = this;
108         uint256 etherBalance = myAddress.balance;
109         owner.transfer(etherBalance);
110     }
111 
112     function balanceOf(address _owner) constant public returns (uint256) {
113         return balances[_owner];
114     }
115 
116     // mitigates the ERC20 short address attack
117     modifier onlyPayloadSize(uint size) {
118         assert(msg.data.length >= size + 4);
119         _;
120     }
121     
122     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
123 
124         require(_to != address(0));
125         require(_amount <= balances[msg.sender]);
126         
127         balances[msg.sender] = balances[msg.sender].sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         emit Transfer(msg.sender, _to, _amount);
130         return true;
131     }
132     
133     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
134 
135         require(_to != address(0));
136         require(_amount <= balances[_from]);
137         require(_amount <= allowed[_from][msg.sender]);
138         
139         balances[_from] = balances[_from].sub(_amount);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
141         balances[_to] = balances[_to].add(_amount);
142         emit Transfer(_from, _to, _amount);
143         return true;
144     }
145     
146     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
147         AltcoinToken t = AltcoinToken(tokenAddress);
148         uint bal = t.balanceOf(who);
149         return bal;
150     }
151     
152     function withdraw() onlyOwner public {
153         address myAddress = this;
154         uint256 etherBalance = myAddress.balance;
155         owner.transfer(etherBalance);
156     }
157     
158     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
159         AltcoinToken anytoken = AltcoinToken(anycontract);
160         uint256 amount = anytoken.balanceOf(address(this));
161         return anytoken.transfer(owner, amount);
162     }
163     
164     function sendtokens(address contrato, uint256 amount, address who) private returns (bool) {
165         AltcoinToken alttoken = AltcoinToken(contrato);
166         return alttoken.transfer(who, amount);
167     }
168 }