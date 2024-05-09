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
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract ForeignToken {
36     function balanceOf(address _owner) constant returns (uint256);
37     function transfer(address _to, uint256 _value) returns (bool);
38 }
39 
40 
41 contract WLMTokenAbstract {
42   function unlock();
43 }
44 
45 
46 contract WLMCrowdsale {
47   using SafeMath for uint256;
48     address owner = msg.sender;
49 
50     bool public purchasingAllowed = false;
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54 
55     uint256 public totalContribution = 0;
56     uint256 public totalBonusTokensIssued = 0;
57     uint    public MINfinney    = 0;
58     uint    public MAXfinney    = 100000;
59     uint    public AIRDROPBounce    = 0;
60     uint    public ICORatio     = 36000;
61     uint256 public totalSupply = 0;
62 
63   // The token being sold
64   address constant public WLM = 0xb679aFD97bCBc7448C1B327795c3eF226b39f0E9;
65 
66   // start and end timestamps where investments are allowed (both inclusive)
67   uint256 public startTime;
68   uint256 public endTime;
69 
70   // address where funds are collected
71   address public WLMWallet = 0x8e7a75D5E7eFE2981AC06a2C6D4CA8A987A44492;
72 
73   // how many token units a buyer gets per wei
74   uint256 public rate = ICORatio;
75 
76   // amount of raised money in wei
77   uint256 public weiRaised;
78 
79   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
80 
81   // fallback function can be used to buy tokens
82   function () external payable {
83     buyTokens(msg.sender);
84   }
85 
86   // low level token purchase function
87   function buyTokens(address beneficiary) public payable {
88     require(beneficiary != address(0));
89         if (!purchasingAllowed) { throw; }
90         
91         if (msg.value < 1 finney * MINfinney) { return; }
92         if (msg.value > 1 finney * MAXfinney) { return; }
93 
94 
95     // calculate token amount to be created
96     uint256 WLMAmounts = calculateObtained(msg.value);
97 
98     // update state
99     weiRaised = weiRaised.add(msg.value);
100 
101     require(ERC20Basic(WLM).transfer(beneficiary, WLMAmounts));
102     TokenPurchase(msg.sender, beneficiary, msg.value, WLMAmounts);
103 
104     forwardFunds();
105   }
106 
107   // send ether to the fund collection wallet
108   // override to create custom fund forwarding mechanisms
109   function forwardFunds() internal {
110     WLMWallet.transfer(msg.value);
111   }
112 
113   function calculateObtained(uint256 amountEtherInWei) public view returns (uint256) {
114     return amountEtherInWei.mul(ICORatio).div(10 ** 12) + AIRDROPBounce * 10 ** 6;
115   } 
116 
117 	
118     function enablePurchasing() {
119         if (msg.sender != owner) { throw; }
120 
121         purchasingAllowed = true;
122     }
123 
124     function disablePurchasing() {
125         if (msg.sender != owner) { throw; }
126 
127         purchasingAllowed = false;
128     }
129 
130   function changeWLMWallet(address _WLMWallet) public returns (bool) {
131     require (msg.sender == WLMWallet);
132     WLMWallet = _WLMWallet;
133   }
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135        assert(b <= a);
136        return a - b;
137     }
138 
139     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
140     
141     function transfer(address _to, uint256 _value) returns (bool success) {
142         // mitigates the ERC20 short address attack
143         if(msg.data.length < (2 * 32) + 4) { throw; }
144 
145         if (_value == 0) { return false; }
146 
147         uint256 fromBalance = balances[msg.sender];
148 
149         bool sufficientFunds = fromBalance >= _value;
150         bool overflowed = balances[_to] + _value < balances[_to];
151         
152         if (sufficientFunds && !overflowed) {
153             balances[msg.sender] -= _value;
154             balances[_to] += _value;
155             
156             Transfer(msg.sender, _to, _value);
157             return true;
158         } else { return false; }
159     }
160     
161     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
162         // mitigates the ERC20 short address attack
163         if(msg.data.length < (3 * 32) + 4) { throw; }
164 
165         if (_value == 0) { return false; }
166         
167         uint256 fromBalance = balances[_from];
168         uint256 allowance = allowed[_from][msg.sender];
169 
170         bool sufficientFunds = fromBalance <= _value;
171         bool sufficientAllowance = allowance <= _value;
172         bool overflowed = balances[_to] + _value > balances[_to];
173 
174         if (sufficientFunds && sufficientAllowance && !overflowed) {
175             balances[_to] += _value;
176             balances[_from] -= _value;
177             
178             allowed[_from][msg.sender] -= _value;
179             
180             Transfer(_from, _to, _value);
181             return true;
182         } else { return false; }
183     }
184     
185     function approve(address _spender, uint256 _value) returns (bool success) {
186         // mitigates the ERC20 spend/approval race condition
187         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
188         
189         allowed[msg.sender][_spender] = _value;
190         
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     
195     function allowance(address _owner, address _spender) constant returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198 
199     event Transfer(address indexed _from, address indexed _to, uint256 _value);
200     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
201     event Burn(address indexed burner, uint256 value);
202 
203 
204     function withdrawForeignTokens(address _tokenContract) returns (bool) {
205         if (msg.sender != owner) { throw; }
206 
207         ForeignToken token = ForeignToken(_tokenContract);
208 
209         uint256 amount = token.balanceOf(address(this));
210         return token.transfer(owner, amount);
211     }
212 
213     function getStats() constant returns (uint256, uint256, uint256, bool) {
214         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
215     }
216 
217     function setICOPrice(uint _newPrice)  {
218         if (msg.sender != owner) { throw; }
219         ICORatio = _newPrice;
220     }
221 
222     function setAIRDROPPrice(uint _newPrice)  {
223         if (msg.sender != owner) { throw; }
224         AIRDROPBounce = _newPrice;
225     }
226 
227     function setMINfinney(uint _newPrice)  {
228         if (msg.sender != owner) { throw; }
229         MINfinney = _newPrice;
230     }
231 
232     function setMAXfinney(uint _newPrice)  {
233         if (msg.sender != owner) { throw; }
234         MAXfinney = _newPrice;
235     }
236 
237     function withdraw() public {
238         uint256 etherBalance = this.balance;
239         owner.transfer(etherBalance);
240     }
241 
242 }