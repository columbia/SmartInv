1 pragma solidity ^0.4.25;
2 //---------------------------------------------------------------------------------------
3 // 'HuapuChain' contract
4 // Deployed to : 0x77dEC6ffCA0A7cd0E3262E450e4E4A12458B9573
5 // Symbol      : HUP
6 // Name        : Huapu Pay
7 // Total supply: 10,000,000,000
8 // Decimals    : 18
9 // Copyright (c) 2018 HuapuPay Inc
10 //---------------------------------------------------------------------------------------
11 
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a / b;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 contract ForeignToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 contract ERC20 is ERC20Basic {
45     function allowance(address owner, address spender) public constant returns (uint256);
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47     function approve(address spender, uint256 value) public returns (bool);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 contract HuapuPay is ERC20 {
51     using SafeMath for uint256;
52     address owner = msg.sender;
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     string public constant name = 'Huapu Pay';
56     string public constant symbol = 'HUP';
57     uint public constant decimals = 18;
58     uint256 public totalSupply = 10000000000e18;
59     uint256 public totalDistributed =  2000000000e18;    
60     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100;
61     uint256 public tokensPerEth = 20000000e18;
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64     event Distr(address indexed to, uint256 amount);
65     event DistrFinished();
66     event Airdrop(address indexed _owner, uint _amount, uint _balance);
67     event TokensPerEthUpdated(uint _tokensPerEth);
68     event Burn(address indexed burner, uint256 value);
69     bool public distributionFinished = false;
70     modifier canDistr() {
71         require(!distributionFinished);
72         _;
73     }
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78     constructor () public {
79         owner = msg.sender;
80         distr(owner, totalDistributed);
81     }
82     function transferOwnership(address newOwner) onlyOwner public {
83         if (newOwner != address(0)) {
84             owner = newOwner;
85         }
86     }
87     function finishDistribution() onlyOwner canDistr public returns (bool) {
88         distributionFinished = true;
89         emit DistrFinished();
90         return true;
91     }
92     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
93         totalDistributed = totalDistributed.add(_amount);        
94         balances[_to] = balances[_to].add(_amount);
95         emit Distr(_to, _amount);
96         emit Transfer(address(0), _to, _amount);
97         return true;
98     }
99     function doAirdrop(address _participant, uint _amount) internal {
100         require(_amount > 0);      
101         require(totalDistributed < totalSupply);
102         balances[_participant] = balances[_participant].add(_amount);
103         totalDistributed = totalDistributed.add(_amount);
104         if (totalDistributed >= totalSupply) {
105             distributionFinished = true;
106         }
107         emit Airdrop(_participant, _amount, balances[_participant]);
108         emit Transfer(address(0), _participant, _amount);
109     }
110     function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
111         doAirdrop(_participant, _amount);
112     }
113     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
114         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
115     }
116     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
117         tokensPerEth = _tokensPerEth;
118         emit TokensPerEthUpdated(_tokensPerEth);
119     }
120     function () external payable {
121         getTokens();
122     }
123     function getTokens() payable canDistr  public {
124         uint256 tokens = 0;
125         uint256 bonus = 0;
126         require(msg.value >= MIN_CONTRIBUTION);
127         require(msg.value > 0);
128         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
129         address investor = msg.sender;
130         if (msg.value >= 0.5 ether) {
131             bonus = (tokens * 5) / 100;
132         }
133         if (msg.value >= 1 ether) {
134             bonus = (tokens * 10) / 100;
135         }
136         if (msg.value >= 4 ether) {
137             bonus = (tokens * 15) / 100;
138         }
139         if (tokens > 0) {
140             distr(investor, (tokens + bonus));
141         }
142         if (totalDistributed >= totalSupply) {
143             distributionFinished = true;
144         }
145     }
146     function balanceOf(address _owner) constant public returns (uint256) {
147         return balances[_owner];
148     }
149     modifier onlyPayloadSize(uint size) {
150         assert(msg.data.length >= size + 4);
151         _;
152     }
153     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
154         require(_to != address(0));
155         require(_amount <= balances[msg.sender]);
156         balances[msg.sender] = balances[msg.sender].sub(_amount);
157         balances[_to] = balances[_to].add(_amount);
158         emit Transfer(msg.sender, _to, _amount);
159         return true;
160     }
161     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
162         require(_to != address(0));
163         require(_amount <= balances[_from]);
164         require(_amount <= allowed[_from][msg.sender]);
165         balances[_from] = balances[_from].sub(_amount);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
167         balances[_to] = balances[_to].add(_amount);
168         emit Transfer(_from, _to, _amount);
169         return true;
170     }
171     function approve(address _spender, uint256 _value) public returns (bool success) {
172         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177     function allowance(address _owner, address _spender) constant public returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
181         ForeignToken t = ForeignToken(tokenAddress);
182         uint bal = t.balanceOf(who);
183         return bal;
184     }
185     function withdraw() onlyOwner public {
186         address myAddress = this;
187         uint256 etherBalance = myAddress.balance;
188         owner.transfer(etherBalance);
189     }
190     function burn(uint256 _value) onlyOwner public {
191         require(_value <= balances[msg.sender]);
192         address burner = msg.sender;
193         balances[burner] = balances[burner].sub(_value);
194         totalSupply = totalSupply.sub(_value);
195         totalDistributed = totalDistributed.sub(_value);
196         emit Burn(burner, _value);
197     }
198     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
199         ForeignToken token = ForeignToken(_tokenContract);
200         uint256 amount = token.balanceOf(address(this));
201         return token.transfer(owner, amount);
202     }
203 }