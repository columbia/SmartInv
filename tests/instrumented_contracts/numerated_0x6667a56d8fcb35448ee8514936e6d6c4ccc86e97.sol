1 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 //   ______   __            __          ______                                       ______             __              //
3 //  /      \ |  \          |  \        /      \                                     /      \           |  \             //
4 // |  $$$$$$\| $$  ______  | $$____   |  $$$$$$\ ______   _______    ______        |  $$$$$$\  ______   \$$ _______     //
5 // | $$ __\$$| $$ /      \ | $$    \  | $$_  \$$/      \ |       \  /      \       | $$   \$$ /      \ |  \|       \    // 
6 // | $$|    \| $$|  $$$$$$\| $$$$$$$\ | $$ \   |  $$$$$$\| $$$$$$$\|  $$$$$$\      | $$      |  $$$$$$\| $$| $$$$$$$\   //
7 // | $$ \$$$$| $$| $$  | $$| $$  | $$ | $$$$   | $$  | $$| $$  | $$| $$    $$      | $$   __ | $$  | $$| $$| $$  | $$   //
8 // | $$__| $$| $$| $$__/ $$| $$__/ $$ | $$     | $$__/ $$| $$  | $$| $$$$$$$$      | $$__/  \| $$__/ $$| $$| $$  | $$   //
9 //  \$$    $$| $$ \$$    $$| $$    $$ | $$      \$$    $$| $$  | $$ \$$     \       \$$    $$ \$$    $$| $$| $$  | $$   //
10 //   \$$$$$$  \$$  \$$$$$$  \$$$$$$$   \$$       \$$$$$$  \$$   \$$  \$$$$$$$        \$$$$$$   \$$$$$$  \$$ \$$   \$$   //
11 //                                                                                                                      //
12 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
13 
14 //Token Name    : Globfone Coin
15 //symbol        : GMC
16 //decimals      : 8
17 //website       : Globfone.Com
18 
19 
20 
21 
22 
23 pragma solidity ^0.4.23;
24 
25 
26 contract ERC20Basic {
27     uint256 public totalSupply;
28     function balanceOf(address who) public constant returns (uint256);
29     function transfer(address to, uint256 value) public returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 contract ERC20 is ERC20Basic {
34     function allowance(address owner, address spender) public constant returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38     mapping (address => uint256) public freezeOf;
39 }
40 
41 
42 library SafeMath {
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         if (a == 0) {
45             return 0;
46         }
47         c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a / b;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67     contract ForeignToken {
68         function balanceOf(address _owner) constant public returns (uint256);
69         function transfer(address _to, uint256 _value) public returns (bool);
70     }
71 
72 
73 
74 
75 contract GlobfoneCoin is ERC20 {
76     using SafeMath for uint256;
77     address owner = msg.sender;
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;    
80     string public constant name = "Globfone Coin"; //* Token Name *//
81     string public constant symbol = "GFC"; //* Globfone Coin Symbol *//
82     uint public constant decimals = 8; //* Number of Decimals *//
83     uint256 public totalSupply = 5000000000000000000; //* total supply of globfone coin *//
84     uint256 public totalDistributed =  2000000000000;  //* Initial Globfone coins that will give to contract creator *//
85     uint256 public constant MIN = 1 ether / 100;  //* Minimum Contribution for GlobFone Coin //
86     uint256 public tokensPerEth = 2000000000000000; //* Globfone Coin Amount per Ethereum *//
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89     event Distr(address indexed to, uint256 amount);
90     event DistrFinished();
91     event Airdrop(address indexed _owner, uint _amount, uint _balance);
92     event TokensPerEthUpdated(uint _tokensPerEth);
93     event Burn(address indexed burner, uint256 value);
94     event Freeze(address indexed from, uint256 value); //event freezing
95     event Unfreeze(address indexed from, uint256 value); //event Unfreezing
96     bool public distributionFinished = false;
97     modifier canDistr() {
98         require(!distributionFinished);
99         _;
100     }
101 
102     modifier onlyOwner() {
103         require(msg.sender == owner);
104         _;
105     }
106     
107     function GlobfoneCoin () public {
108         owner = msg.sender;    
109         distr(owner, totalDistributed);
110     }
111     
112     function transferOwnership(address newOwner) onlyOwner public {
113         if (newOwner != address(0)) {
114             owner = newOwner;
115         }
116     }
117     
118 
119     function finishDistribution() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124     
125     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
126         totalDistributed = totalDistributed.add(_amount);        
127         balances[_to] = balances[_to].add(_amount);
128         emit Distr(_to, _amount);
129         emit Transfer(address(0), _to, _amount);
130 
131         return true;
132     }
133 
134     function doAirdrop(address _participant, uint _amount) internal {
135 
136         require( _amount > 0 );      
137 
138         require( totalDistributed < totalSupply );
139         
140         balances[_participant] = balances[_participant].add(_amount);
141         totalDistributed = totalDistributed.add(_amount);
142 
143         if (totalDistributed >= totalSupply) {
144             distributionFinished = true;
145         }
146         emit Airdrop(_participant, _amount, balances[_participant]);
147         emit Transfer(address(0), _participant, _amount);
148     }
149 
150     function AirdropSingle(address _participant, uint _amount) public onlyOwner {        
151         doAirdrop(_participant, _amount);
152     }
153 
154     function AirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
155         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
156     }
157 
158     function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {        
159         tokensPerEth = _tokensPerEth;
160         emit TokensPerEthUpdated(_tokensPerEth);
161     }
162            
163     function () external payable {
164         getTokens();
165      }
166     
167     function getTokens() payable canDistr  public {
168         uint256 tokens = 0;
169         require( msg.value >= MIN );
170         require( msg.value > 0 );
171         tokens = tokensPerEth.mul(msg.value) / 1 ether;        
172         address investor = msg.sender;
173         
174         if (tokens > 0) {
175             distr(investor, tokens);
176         }
177 
178         if (totalDistributed >= totalSupply) {
179             distributionFinished = true;
180         }
181     }
182 
183 
184     modifier onlyPayloadSize(uint size) {
185         assert(msg.data.length >= size + 4);
186         _;
187     }
188 
189     function balanceOf(address _owner) constant public returns (uint256) {
190         return balances[_owner];
191     }
192     
193     
194     function freeze(uint256 _value) returns (bool success) {
195         if (balances[msg.sender] < _value) throw;                               // Check if the sender has enough
196 		if (_value <= 0) throw; 
197         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      // Subtract from the sender
198         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       // Updates totalSupply
199         Freeze(msg.sender, _value);
200         return true;
201     }
202 	
203 	function unfreeze(uint256 _value) returns (bool success) {
204         if (freezeOf[msg.sender] < _value) throw;                               // Check if the sender has enough
205 		if (_value <= 0) throw; 
206         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);      // Subtract from the sender
207 		balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
208         Unfreeze(msg.sender, _value);
209         return true;
210     }
211     
212     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
213         //check if sender has balance and for oveflow
214         require(_to != address(0));
215         require(_amount <= balances[msg.sender]);
216         balances[msg.sender] = balances[msg.sender].sub(_amount);
217         balances[_to] = balances[_to].add(_amount);
218         emit Transfer(msg.sender, _to, _amount);
219         return true;
220     }
221     
222     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
223         require(_to != address(0));
224         require(_amount <= balances[_from]);
225         require(_amount <= allowed[_from][msg.sender]);
226         balances[_from] = balances[_from].sub(_amount);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
228         balances[_to] = balances[_to].add(_amount);
229         emit Transfer(_from, _to, _amount);
230         return true;
231     }
232 
233     //allow the contract owner to withdraw any token that are not belongs to GlobfoneCoin Community
234      function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
235         ForeignToken token = ForeignToken(_tokenContract);
236         uint256 amount = token.balanceOf(address(this));
237         return token.transfer(owner, amount);
238     } //withdraw foreign tokens
239     
240     function approve(address _spender, uint256 _value) public returns (bool success) {
241         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     } 
246     
247     
248     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
249         ForeignToken t = ForeignToken(tokenAddress);
250         uint bal = t.balanceOf(who);
251         return bal;
252     }
253     
254     //withdraw Ethereum from Contract address
255     function withdrawEther() onlyOwner public {
256         address myAddress = this;
257         uint256 etherBalance = myAddress.balance;
258         owner.transfer(etherBalance);
259     }
260     
261     function allowance(address _owner, address _spender) constant public returns (uint256) {
262         return allowed[_owner][_spender];
263     }
264     
265     //Burning specific amount of GlobFone Coins
266     function burnGlobFoneCoin(uint256 _value) onlyOwner public {
267         require(_value <= balances[msg.sender]);
268         address burner = msg.sender;
269         balances[burner] = balances[burner].sub(_value);
270         totalSupply = totalSupply.sub(_value);
271         totalDistributed = totalDistributed.sub(_value);
272         emit Burn(burner, _value);
273     } 
274     
275 }