1 pragma solidity ^0.4.19;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract ForeignToken {
29     function balanceOf(address _owner) constant returns (uint256);
30     function transfer(address _to, uint256 _value) returns (bool);
31 }
32 
33 contract Virgo_ZodiacToken {
34     address owner = msg.sender;
35 
36     bool public purchasingAllowed = true;
37 
38     mapping (address => uint256) balances;
39     mapping (address => mapping (address => uint256)) allowed;
40 
41     uint256 public totalContribution = 0;
42     uint256 public totalBonusTokensIssued = 0;
43     uint    public MINfinney    = 0;
44     uint    public AIRDROPBounce    = 50000000;
45     uint    public ICORatio     = 144000;
46     uint256 public totalSupply = 0;
47 
48     function name() constant returns (string) { return "Virgo_ZodiacToken"; }
49     function symbol() constant returns (string) { return "VIR♍"; }
50     function decimals() constant returns (uint8) { return 8; }
51     event Burnt(
52         address indexed _receiver,
53         uint indexed _num,
54         uint indexed _total_supply
55     );
56  
57  
58  
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60        assert(b <= a);
61        return a - b;
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
65     
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         // mitigates the ERC20 short address attack
68         if(msg.data.length < (2 * 32) + 4) { throw; }
69 
70         if (_value == 0) { return false; }
71 
72         uint256 fromBalance = balances[msg.sender];
73 
74         bool sufficientFunds = fromBalance >= _value;
75         bool overflowed = balances[_to] + _value < balances[_to];
76         
77         if (sufficientFunds && !overflowed) {
78             balances[msg.sender] -= _value;
79             balances[_to] += _value;
80             
81             Transfer(msg.sender, _to, _value);
82             return true;
83         } else { return false; }
84     }
85     
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
87         // mitigates the ERC20 short address attack
88         if(msg.data.length < (3 * 32) + 4) { throw; }
89 
90         if (_value == 0) { return false; }
91         
92         uint256 fromBalance = balances[_from];
93         uint256 allowance = allowed[_from][msg.sender];
94 
95         bool sufficientFunds = fromBalance <= _value;
96         bool sufficientAllowance = allowance <= _value;
97         bool overflowed = balances[_to] + _value > balances[_to];
98 
99         if (sufficientFunds && sufficientAllowance && !overflowed) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             
103             allowed[_from][msg.sender] -= _value;
104             
105             Transfer(_from, _to, _value);
106             return true;
107         } else { return false; }
108     }
109     
110     function approve(address _spender, uint256 _value) returns (bool success) {
111         // mitigates the ERC20 spend/approval race condition
112         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
113         
114         allowed[msg.sender][_spender] = _value;
115         
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119     
120     function allowance(address _owner, address _spender) constant returns (uint256) {
121         return allowed[_owner][_spender];
122     }
123 
124     event Transfer(address indexed _from, address indexed _to, uint256 _value);
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126     event Burn(address indexed burner, uint256 value);
127 
128 	
129     function enablePurchasing() {
130         if (msg.sender != owner) { throw; }
131 
132         purchasingAllowed = true;
133     }
134 
135     function disablePurchasing() {
136         if (msg.sender != owner) { throw; }
137 
138         purchasingAllowed = false;
139     }
140 
141     function withdrawForeignTokens(address _tokenContract) returns (bool) {
142         if (msg.sender != owner) { throw; }
143 
144         ForeignToken token = ForeignToken(_tokenContract);
145 
146         uint256 amount = token.balanceOf(address(this));
147         return token.transfer(owner, amount);
148     }
149 
150     function getStats() constant returns (uint256, uint256, uint256, bool) {
151         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
152     }
153 
154     function setAIRDROPBounce(uint _newPrice)  {
155         if (msg.sender != owner) { throw; }
156         AIRDROPBounce = _newPrice;
157     }
158 
159     function setICORatio(uint _newPrice)  {
160         if (msg.sender != owner) { throw; }
161         ICORatio = _newPrice;
162     }
163 
164     function setMINfinney(uint _newPrice)  {
165         if (msg.sender != owner) { throw; }
166         MINfinney = _newPrice;
167     }
168  
169 
170     function() payable {
171         if (!purchasingAllowed) { throw; }
172         
173         if (msg.value < 1 finney * MINfinney) { return; }
174 
175         owner.transfer(msg.value);
176         totalContribution += msg.value;
177 
178         uint256 tokensIssued = (msg.value / 1e10) * ICORatio + AIRDROPBounce * 1e8;
179 
180 
181         totalSupply += tokensIssued;
182         balances[msg.sender] += tokensIssued;
183         
184         Transfer(address(this), msg.sender, tokensIssued);
185     }
186 
187     function withdraw() public {
188         uint256 etherBalance = this.balance;
189         owner.transfer(etherBalance);
190     }
191 
192     function burn(uint num) public {
193         require(num * 1e8 > 0);
194         require(balances[msg.sender] >= num * 1e8);
195         require(totalSupply >= num * 1e8);
196 
197         uint pre_balance = balances[msg.sender];
198 
199         balances[msg.sender] -= num * 1e8;
200         totalSupply -= num * 1e8;
201         Burnt(msg.sender, num * 1e8, totalSupply);
202         Transfer(msg.sender, 0x0, num * 1e8);
203 
204         assert(balances[msg.sender] == pre_balance - num * 1e8);
205     }
206 
207     
208 }