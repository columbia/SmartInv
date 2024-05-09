1 pragma solidity ^0.4.24;
2 library SafeMath {
3 
4         function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13         function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract AltcoinToken {
30     function balanceOf(address _owner) constant public returns (uint256);
31     function transfer(address _to, uint256 _value) public returns (bool);
32 }
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     function balanceOf(address who) public constant returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) public constant returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract iConsortCandyToken is ERC20 {
49     
50     using SafeMath for uint256;
51     address owner = msg.sender;
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;    
55 
56     string public constant name = "iconsortsolutions.com Candy Token";
57     string public constant symbol = "iconsortsolutions.com";
58     uint public constant decimals = 0;
59     
60     uint256 public totalSupply = 4000000000;
61     uint256 public totalDistributed = 0;        
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     
66     event Distr(address indexed to, uint256 amount);
67     event DistrFinished();
68 
69     event Airdrop(address indexed _owner, uint _amount, uint _balance);
70 
71    event Burn(address indexed burner, uint256 value);
72 
73     bool public distributionFinished = false;
74     
75     modifier canDistr() {
76         require(!distributionFinished);
77         _;
78     }
79     
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     function iConsortCandyToken () public {
86         owner = msg.sender;
87     }
88     
89     function transferOwnership(address newOwner) onlyOwner public {
90         if (newOwner != address(0)) {
91             owner = newOwner;
92         }
93     }
94     
95     function finishDistribution() onlyOwner canDistr public returns (bool) {
96         distributionFinished = true;
97         emit DistrFinished();
98         return true;
99     }
100     
101     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
102         totalDistributed = totalDistributed.add(_amount);        
103         balances[_to] = balances[_to].add(_amount);
104         emit Distr(_to, _amount);
105         emit Transfer(address(0), _to, _amount);
106         return true;
107     }
108 
109     function doAirdrop(address _participant, uint _amount) internal {
110         require( _amount > 0 );      
111         require( totalDistributed < totalSupply );
112         balances[_participant] = balances[_participant].add(_amount);
113         totalDistributed = totalDistributed.add(_amount);
114         if (totalDistributed >= totalSupply) {
115             distributionFinished = true;
116         }
117         emit Airdrop(_participant, _amount, balances[_participant]);
118         emit Transfer(address(0), _participant, _amount);
119     }
120 
121     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
122         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
123     }
124 
125        function () external payable {
126         getTokens();
127      }
128     
129     function getTokens() payable canDistr  public {
130         uint256 tokens = 0;
131         require( msg.value > 0 );
132         
133         address investor = msg.sender;
134         if (tokens > 0) {
135             distr(investor, tokens);
136         }
137 
138         if (totalDistributed >= totalSupply) {
139             distributionFinished = true;
140         }
141     }
142 
143     function balanceOf(address _owner) constant public returns (uint256) {
144         return balances[_owner];
145     }
146 
147     modifier onlyPayloadSize(uint size) {
148         assert(msg.data.length >= size + 4);
149         _;
150     }
151     
152     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
153         require(_to != address(0));
154         require(_amount <= balances[msg.sender]);
155         balances[msg.sender] = balances[msg.sender].sub(_amount);
156         balances[_to] = balances[_to].add(_amount);
157         emit Transfer(msg.sender, _to, _amount);
158         return true;
159     }
160     
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
171     
172     function approve(address _spender, uint256 _value) public returns (bool success) {
173         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178     
179     function allowance(address _owner, address _spender) constant public returns (uint256) {
180         return allowed[_owner][_spender];
181     }
182     
183     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
184         AltcoinToken t = AltcoinToken(tokenAddress);
185         uint bal = t.balanceOf(who);
186         return bal;
187     }
188     
189     function withdrawAltcoinTokens(address _tokenContract) onlyOwner public returns (bool) {
190         AltcoinToken token = AltcoinToken(_tokenContract);
191         uint256 amount = token.balanceOf(address(this));
192         return token.transfer(owner, amount);
193     }
194 }