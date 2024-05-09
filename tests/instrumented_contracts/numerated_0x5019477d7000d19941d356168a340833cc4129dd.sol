1 pragma solidity 0.4.19;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ForeignToken {
35     function balanceOf(address _owner) constant returns (uint256);
36     function transfer(address _to, uint256 _value) returns (bool);
37 }
38 
39 contract ARITokenAbstract {
40     function unlock();
41 }
42 
43 contract ARICrowdsale {
44     using SafeMath for uint256;
45     address owner = msg.sender;
46 
47     bool public purchasingAllowed = false;
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51 
52     uint256 public totalContribution = 0;
53     uint256 public totalBonusTokensIssued = 0;
54     uint    public MINfinney    = 0;
55     uint    public MAXfinney    = 100000;
56     uint    public AIRDROPBounce    = 1200;
57     uint    public ICORatio     = 1440000;
58     uint256 public totalSupply = 0;
59 
60     address constant public ARI = 0xf8b7b391b7b7330d07a931a332a6620ca1a9f7f2;
61 
62     address public ARIWallet = 0x6346D35ceDd5b19c94EB1AbE9b5fbCAd7d95dAad;
63 
64     uint256 public rate = ICORatio;
65 
66     uint256 public weiRaised;
67 
68     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
69 
70     function () external payable {
71         buyTokens(msg.sender);
72     }
73 
74     function buyTokens(address beneficiary) public payable {
75     require(beneficiary != address(0));
76         if (!purchasingAllowed) { throw; }
77         
78         if (msg.value < 1 finney * MINfinney) { return; }
79         if (msg.value > 1 finney * MAXfinney) { return; }
80 
81     uint256 ARIAmounts = calculateObtained(msg.value);
82 
83     weiRaised = weiRaised.add(msg.value);
84 
85         require(ERC20Basic(ARI).transfer(beneficiary, ARIAmounts));
86         TokenPurchase(msg.sender, beneficiary, msg.value, ARIAmounts);
87         forwardFunds();
88     }
89 
90     function forwardFunds() internal {
91         ARIWallet.transfer(msg.value);
92     }
93 
94     function calculateObtained(uint256 amountEtherInWei) public view returns (uint256) {
95         return amountEtherInWei.mul(ICORatio).div(10 ** 6) + AIRDROPBounce * 10 ** 6;
96     } 
97 
98     function enablePurchasing() {
99         if (msg.sender != owner) { throw; }
100         purchasingAllowed = true;
101     }
102 
103     function disablePurchasing() {
104         if (msg.sender != owner) { throw; }
105         purchasingAllowed = false;
106     }
107 
108     function changeARIWallet(address _ARIWallet) public returns (bool) {
109         require (msg.sender == ARIWallet);
110         ARIWallet = _ARIWallet;
111     }
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113        assert(b <= a);
114        return a - b;
115     }
116 
117     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
118     
119     function transfer(address _to, uint256 _value) returns (bool success) {
120         if(msg.data.length < (2 * 32) + 4) { throw; }
121         if (_value == 0) { return false; }
122 
123         uint256 fromBalance = balances[msg.sender];
124         bool sufficientFunds = fromBalance >= _value;
125         bool overflowed = balances[_to] + _value < balances[_to];
126         
127         if (sufficientFunds && !overflowed) {
128             balances[msg.sender] -= _value;
129             balances[_to] += _value;
130             
131             Transfer(msg.sender, _to, _value);
132             return true;
133         } else { return false; }
134     }
135     
136     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
137         if(msg.data.length < (3 * 32) + 4) { throw; }
138         if (_value == 0) { return false; }
139         
140         uint256 fromBalance = balances[_from];
141         uint256 allowance = allowed[_from][msg.sender];
142 
143         bool sufficientFunds = fromBalance <= _value;
144         bool sufficientAllowance = allowance <= _value;
145         bool overflowed = balances[_to] + _value > balances[_to];
146 
147         if (sufficientFunds && sufficientAllowance && !overflowed) {
148             balances[_to] += _value;
149             balances[_from] -= _value;
150             
151             allowed[_from][msg.sender] -= _value;
152             
153             Transfer(_from, _to, _value);
154             return true;
155         } else { return false; }
156     }
157     
158     function approve(address _spender, uint256 _value) returns (bool success) {
159         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
160         
161         allowed[msg.sender][_spender] = _value;
162         
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166     
167     function allowance(address _owner, address _spender) constant returns (uint256) {
168         return allowed[_owner][_spender];
169     }
170 
171     event Transfer(address indexed _from, address indexed _to, uint256 _value);
172     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
173     event Burn(address indexed burner, uint256 value);
174 
175     function withdrawForeignTokens(address _tokenContract) returns (bool) {
176         if (msg.sender != owner) { throw; }
177 
178         ForeignToken token = ForeignToken(_tokenContract);
179 
180         uint256 amount = token.balanceOf(address(this));
181         return token.transfer(owner, amount);
182     }
183 
184     function getStats() constant returns (uint256, uint256, uint256, bool) {
185         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
186     }
187 
188     function setICOPrice(uint _newPrice)  {
189         if (msg.sender != owner) { throw; }
190         ICORatio = _newPrice;
191     }
192 
193     function setMINfinney(uint _newPrice)  {
194         if (msg.sender != owner) { throw; }
195         MINfinney = _newPrice;
196     }
197 
198     function setMAXfinney(uint _newPrice)  {
199         if (msg.sender != owner) { throw; }
200         MAXfinney = _newPrice;
201     }
202 
203     function setAIRDROPBounce(uint _newPrice)  {
204         if (msg.sender != owner) { throw; }
205         AIRDROPBounce = _newPrice;
206     }
207 
208     function withdraw() public {
209         uint256 etherBalance = this.balance;
210         owner.transfer(etherBalance);
211     }
212 }