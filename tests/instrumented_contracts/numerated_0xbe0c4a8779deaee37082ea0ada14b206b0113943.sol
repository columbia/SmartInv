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
41 contract EEMTokenAbstract {
42   function unlock();
43 }
44 
45 
46 contract EEMCrowdsale {
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
58     uint    public MAXfinney    = 5000;
59     uint    public AIRDROPBounce    = 0;
60     uint    public ICORatio     = 168000;
61     uint256 public totalSupply = 0;
62 
63   // The token being sold
64   address constant public EEM = 0x5d48aca3954d288a5fea9fc374ac48a5dbf5fa6d;
65 
66   // start and end timestamps where investments are allowed (both inclusive)
67   uint256 public startTime;
68   uint256 public endTime;
69 
70   // address where funds are collected
71   address public EEMWallet = 0x4959935d592FE71583d813Af2E68a990ff597472;
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
96     uint256 EEMAmounts = calculateObtained(msg.value);
97 
98     // update state
99     weiRaised = weiRaised.add(msg.value);
100 
101     require(ERC20Basic(EEM).transfer(beneficiary, EEMAmounts));
102     TokenPurchase(msg.sender, beneficiary, msg.value, EEMAmounts);
103 
104     forwardFunds();
105   }
106 
107   // send ether to the fund collection wallet
108   // override to create custom fund forwarding mechanisms
109   function forwardFunds() internal {
110     EEMWallet.transfer(msg.value);
111   }
112 
113   function calculateObtained(uint256 amountEtherInWei) public view returns (uint256) {
114     return amountEtherInWei.mul(ICORatio).div(10 ** 10);
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
130   function changeEEMWallet(address _EEMWallet) public returns (bool) {
131     require (msg.sender == EEMWallet);
132     EEMWallet = _EEMWallet;
133   }
134 
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136        assert(b <= a);
137        return a - b;
138     }
139 
140     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
141     
142     function transfer(address _to, uint256 _value) returns (bool success) {
143         // mitigates the ERC20 short address attack
144         if(msg.data.length < (2 * 32) + 4) { throw; }
145 
146         if (_value == 0) { return false; }
147 
148         uint256 fromBalance = balances[msg.sender];
149 
150         bool sufficientFunds = fromBalance >= _value;
151         bool overflowed = balances[_to] + _value < balances[_to];
152         
153         if (sufficientFunds && !overflowed) {
154             balances[msg.sender] -= _value;
155             balances[_to] += _value;
156             
157             Transfer(msg.sender, _to, _value);
158             return true;
159         } else { return false; }
160     }
161     
162     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
163         // mitigates the ERC20 short address attack
164         if(msg.data.length < (3 * 32) + 4) { throw; }
165 
166         if (_value == 0) { return false; }
167         
168         uint256 fromBalance = balances[_from];
169         uint256 allowance = allowed[_from][msg.sender];
170 
171         bool sufficientFunds = fromBalance <= _value;
172         bool sufficientAllowance = allowance <= _value;
173         bool overflowed = balances[_to] + _value > balances[_to];
174 
175         if (sufficientFunds && sufficientAllowance && !overflowed) {
176             balances[_to] += _value;
177             balances[_from] -= _value;
178             
179             allowed[_from][msg.sender] -= _value;
180             
181             Transfer(_from, _to, _value);
182             return true;
183         } else { return false; }
184     }
185     
186     function approve(address _spender, uint256 _value) returns (bool success) {
187         // mitigates the ERC20 spend/approval race condition
188         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
189         
190         allowed[msg.sender][_spender] = _value;
191         
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     function allowance(address _owner, address _spender) constant returns (uint256) {
197         return allowed[_owner][_spender];
198     }
199 
200     event Transfer(address indexed _from, address indexed _to, uint256 _value);
201     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
202     event Burn(address indexed burner, uint256 value);
203 
204 
205     function withdrawForeignTokens(address _tokenContract) returns (bool) {
206         if (msg.sender != owner) { throw; }
207 
208         ForeignToken token = ForeignToken(_tokenContract);
209 
210         uint256 amount = token.balanceOf(address(this));
211         return token.transfer(owner, amount);
212     }
213 
214     function getStats() constant returns (uint256, uint256, uint256, bool) {
215         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
216     }
217 
218     function setICOPrice(uint _newPrice)  {
219         if (msg.sender != owner) { throw; }
220         ICORatio = _newPrice;
221     }
222 
223     function setMINfinney(uint _newPrice)  {
224         if (msg.sender != owner) { throw; }
225         MINfinney = _newPrice;
226     }
227 
228     function setMAXfinney(uint _newPrice)  {
229         if (msg.sender != owner) { throw; }
230         MAXfinney = _newPrice;
231     }
232 
233     function setAIRDROPBounce(uint _newPrice)  {
234         if (msg.sender != owner) { throw; }
235         AIRDROPBounce = _newPrice;
236     }
237 
238     function withdraw() public {
239         uint256 etherBalance = this.balance;
240         owner.transfer(etherBalance);
241     }
242 
243 
244     
245 }