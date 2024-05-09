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
49 contract AllyICO is ERC20 {
50     
51     using SafeMath for uint256;
52     address owner = msg.sender;
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;    
56 
57     address _tokenContract = 0x34A0263cEC3d616677df10962e24f97EF283891a;
58     AltcoinToken cddtoken = AltcoinToken(_tokenContract);
59 
60     string public constant name = "AllyICO";
61     string public constant symbol = "ICO";
62     uint public constant decimals = 8;
63     uint256 public totalSupply = 12000000000e8;
64     uint256 public totalDistributed = 0;        
65     uint256 public tokensPerEth = 20000000e8;
66     uint256 public constant minContribution = 1 ether / 100; // 0.01 Ether
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     
71     event Distr(address indexed to, uint256 amount);
72     event DistrFinished();
73 
74     event TokensPerEthUpdated(uint _tokensPerEth);
75 
76     bool public distributionFinished = false;
77     
78     modifier canDistr() {
79         require(!distributionFinished);
80         _;
81     }
82     
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87     
88     function AllyICO () public {
89         owner = msg.sender;
90     }
91     
92     function transferOwnership(address newOwner) onlyOwner public {
93         if (newOwner != address(0)) {
94             owner = newOwner;
95         }
96     }
97 
98     function finishDistribution() onlyOwner canDistr public returns (bool) {
99         distributionFinished = true;
100         emit DistrFinished();
101         return true;
102     }
103     
104     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
105         totalDistributed = totalDistributed.add(_amount);        
106         balances[_to] = balances[_to].add(_amount);
107         emit Distr(_to, _amount);
108         emit Transfer(address(0), _to, _amount);
109 
110         return true;
111     }
112 
113     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
114         tokensPerEth = _tokensPerEth;
115         emit TokensPerEthUpdated(_tokensPerEth);
116     }
117            
118     function () external payable {
119         sendTokens();
120     }
121      
122     function sendTokens() private returns (bool) {
123         uint256 tokens = 0;
124 
125         require( msg.value >= minContribution );
126 
127         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
128         address investor = msg.sender;
129 
130         sendICO(cddtoken, tokens, investor);
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
167     function approve(address _spender, uint256 _value) public returns (bool success) {
168         // mitigates the ERC20 spend/approval race condition
169         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174     
175     function allowance(address _owner, address _spender) constant public returns (uint256) {
176         return allowed[_owner][_spender];
177     }
178     
179     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
180         AltcoinToken t = AltcoinToken(tokenAddress);
181         uint bal = t.balanceOf(who);
182         return bal;
183     }
184     
185     function withdraw() onlyOwner public {
186         address myAddress = this;
187         uint256 etherBalance = myAddress.balance;
188         owner.transfer(etherBalance);
189     }
190     
191     function withdrawAltcoinTokens(address anycontract) onlyOwner public returns (bool) {
192         AltcoinToken anytoken = AltcoinToken(anycontract);
193         uint256 amount = anytoken.balanceOf(address(this));
194         return anytoken.transfer(owner, amount);
195     }
196     
197     function sendICO(address contrato, uint256 amount, address who) private returns (bool) {
198         AltcoinToken alttoken = AltcoinToken(contrato);
199         return alttoken.transfer(who, amount);
200     }
201 }