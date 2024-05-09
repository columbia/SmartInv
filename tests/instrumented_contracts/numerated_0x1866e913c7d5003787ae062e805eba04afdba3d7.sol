1 pragma solidity ^0.4.24;
2 
3 /*
4 Developed by: https://www.tradecryptocurrency.com/
5 */
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = 0x8297B007c3581C3501797d356ce940150290eB24;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner)
20     onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 
26 contract pays_commission {
27     address public commissionGetter;
28     uint256 public minimumEtherCommission;
29     uint public minimumTokenCommission;
30 
31     constructor() public {
32         commissionGetter = 0xCd8bf69ad65c5158F0cfAA599bBF90d7f4b52Bb0;
33         minimumEtherCommission = 50000000000;
34         minimumTokenCommission = 1;
35     }
36 
37     modifier onlyCommissionGetter {
38         require(msg.sender == commissionGetter);
39         _;
40     }
41 
42     function transferCommissionGetter(address newCommissionGetter)
43     onlyCommissionGetter public {
44         commissionGetter = newCommissionGetter;
45     }
46 
47     function changeMinimumCommission(
48         uint256 newMinEtherCommission, uint newMinTokenCommission)
49     onlyCommissionGetter public {
50         minimumEtherCommission = newMinEtherCommission;
51         minimumTokenCommission = newMinTokenCommission;
52     }
53 }
54 
55 
56 contract GN10Token is pays_commission, owned {
57     string public name;
58     string public symbol;
59     uint8 public decimals = 0;
60     uint256 public totalSupply;
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63     uint256 public buyPrice = 1700000000000000;
64     uint256 public sellPrice = 1500000000000000;
65     bool public closeSell = false;
66     mapping (address => bool) public frozenAccount;
67 
68 
69     // Events
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event FrozenFunds(address target, bool frozen);
73     event Deposit(address sender, uint amount);
74     event Withdrawal(address receiver, uint amount);
75 
76 
77     // Constructor
78 
79     constructor(uint256 initialSupply, string tokenName, string tokenSymbol)
80     public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);
82         balanceOf[owner] = totalSupply;
83         name = tokenName;
84         symbol = tokenSymbol;
85     }
86 
87 
88     // Internal functions
89 
90     function _transfer(address _from, address _to, uint _value)
91     internal {
92         require(_to != 0x0);
93         require(!frozenAccount[_from]);
94         require(!frozenAccount[_to]);
95         require(balanceOf[_from] >= _value);
96         require(balanceOf[_to] + _value > balanceOf[_to]);
97         uint previousBalances = balanceOf[_from] + balanceOf[_to];
98         balanceOf[_from] -= _value;
99         balanceOf[_to] += _value;
100         emit Transfer(_from, _to, _value);
101         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
102     }
103 
104     function _pay_token_commission (uint256 _value)
105     internal {
106         uint market_value = _value * sellPrice;
107         uint commission_value = market_value * 1 / 100;
108         // The comision is paid with tokens
109         uint commission = commission_value / sellPrice;
110         if (commission < minimumTokenCommission){ 
111             commission = minimumTokenCommission;
112         }
113         address contr = this;
114         _transfer(contr, commissionGetter, commission);
115     }
116 
117 
118     // Only owner functions
119 
120     function refillTokens(uint256 _value)
121     onlyOwner public {
122         _transfer(msg.sender, this, _value);
123     }
124 
125 
126     function freezeAccount(address target, bool freeze)
127     onlyOwner public {
128         frozenAccount[target] = freeze;
129         emit FrozenFunds(target, freeze);
130     }
131 
132     function setPrices(uint256 newSellPrice, uint256 newBuyPrice)
133     onlyOwner public {
134         sellPrice = newSellPrice;
135         buyPrice = newBuyPrice;
136     }
137 
138     function setStatus(bool isClosedSell)
139     onlyOwner public {
140         closeSell = isClosedSell;
141     }
142 
143     function withdrawEther(uint amountInWeis)
144     onlyOwner public {
145         address contr = this;
146         require(contr.balance >= amountInWeis);
147         emit Withdrawal(msg.sender, amountInWeis);
148         owner.transfer(amountInWeis);
149     }
150 
151 
152     // Public functions
153 
154     function transfer(address _to, uint256 _value)
155     public {
156         _pay_token_commission(_value);
157         _transfer(msg.sender, _to, _value);
158     }
159 
160     function approve(address _spender, uint256 _value)
161     public returns (bool success) {
162         allowance[msg.sender][_spender] = _value;
163         return true;
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value)
167     public returns (bool success) {
168         require(_value <= allowance[_from][msg.sender]);
169         _pay_token_commission(_value);
170         allowance[_from][msg.sender] -= _value;
171         _transfer(_from, _to, _value);
172         return true;
173     }
174 
175     function depositEther() payable
176     public returns(bool success) {
177         address contr = this;
178         require((contr.balance + msg.value) > contr.balance);
179         emit Deposit(msg.sender, msg.value);
180         return true;
181     }
182 
183     function buy() payable
184     public {
185         uint amount = msg.value / buyPrice;
186         uint market_value = amount * buyPrice;
187         uint commission = market_value * 1 / 100;
188         // The comision is paid with Ether
189         if (commission < minimumEtherCommission){
190             commission = minimumEtherCommission;
191         }
192         address contr = this;
193         require(contr.balance >= commission);
194         commissionGetter.transfer(commission);
195         _transfer(this, msg.sender, amount);
196     }
197 
198     function sell(uint256 amount)
199     public {
200     	require(!closeSell);
201         _pay_token_commission(amount);
202         _transfer(msg.sender, this, amount);
203         uint market_value = amount * sellPrice;
204         address contr = this;
205         require(contr.balance >= market_value);
206         msg.sender.transfer(market_value);
207     }
208 
209     function () payable
210     public {
211         buy();
212     }
213 }