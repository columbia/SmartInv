1 pragma solidity ^0.4.25;
2 //---------------------------------------------------------------------------------------
3 // 'Blocksol' contract
4 // Deployed to : 0x82B48350C51a0888d8e73d0a300F91A7c0B7ad2d
5 // Symbol      : BSO
6 // Name        : Blocksol
7 // Total supply: 5,000,000,000
8 // Decimals    : 18
9 // Copyright (c) 2018 Blockchain Solutions
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
50 contract Blocksol is ERC20 {
51     using SafeMath for uint256;
52     address owner = msg.sender;
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     string public constant name = 'Blocksol';
56     string public constant symbol = 'BSO';
57     uint public constant decimals = 18;
58     uint256 public totalSupply = 5000000000e18;
59     uint256 public totalDistributed =  2500000000e18;    
60     uint256 public constant MIN_CONTRIBUTION = 1 ether / 100;
61     uint256 public tokensPerEth = 10000000e18;
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
130         
131         if (msg.value >= 1 ether) {
132             bonus = (tokens * 20) / 100;
133         }
134         if (tokens > 0) {
135             distr(investor, (tokens + bonus));
136         }
137         if (totalDistributed >= totalSupply) {
138             distributionFinished = true;
139         }
140     }
141     function balanceOf(address _owner) constant public returns (uint256) {
142         return balances[_owner];
143     }
144     modifier onlyPayloadSize(uint size) {
145         assert(msg.data.length >= size + 4);
146         _;
147     }
148     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
149         require(_to != address(0));
150         require(_amount <= balances[msg.sender]);
151         balances[msg.sender] = balances[msg.sender].sub(_amount);
152         balances[_to] = balances[_to].add(_amount);
153         emit Transfer(msg.sender, _to, _amount);
154         return true;
155     }
156     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
157         require(_to != address(0));
158         require(_amount <= balances[_from]);
159         require(_amount <= allowed[_from][msg.sender]);
160         balances[_from] = balances[_from].sub(_amount);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit Transfer(_from, _to, _amount);
164         return true;
165     }
166     function approve(address _spender, uint256 _value) public returns (bool success) {
167         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172     function allowance(address _owner, address _spender) constant public returns (uint256) {
173         return allowed[_owner][_spender];
174     }
175     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
176         ForeignToken t = ForeignToken(tokenAddress);
177         uint bal = t.balanceOf(who);
178         return bal;
179     }
180     function withdraw() onlyOwner public {
181         address myAddress = this;
182         uint256 etherBalance = myAddress.balance;
183         owner.transfer(etherBalance);
184     }
185     function burn(uint256 _value) onlyOwner public {
186         require(_value <= balances[msg.sender]);
187         address burner = msg.sender;
188         balances[burner] = balances[burner].sub(_value);
189         totalSupply = totalSupply.sub(_value);
190         totalDistributed = totalDistributed.sub(_value);
191         emit Burn(burner, _value);
192     }
193     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
194         ForeignToken token = ForeignToken(_tokenContract);
195         uint256 amount = token.balanceOf(address(this));
196         return token.transfer(owner, amount);
197     }
198 }