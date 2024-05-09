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
11         owner = 0xF342EFcd569cF461ffEFf42E72fA8433459339D6;
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
56 contract XCPToken is pays_commission, owned {
57     string public name;
58     string public symbol;
59     uint8 public decimals = 0;
60     uint256 public totalSupply;
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63     uint256 public buyPrice = 70000000000;
64     uint256 public sellPrice = 50000000000;
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
125     function mintToken(uint256 mintedAmount)
126     onlyOwner public {
127         balanceOf[owner] += mintedAmount;
128         totalSupply += mintedAmount;
129         emit Transfer(0, this, mintedAmount);
130         emit Transfer(this, owner, mintedAmount);
131     }
132 
133     function freezeAccount(address target, bool freeze)
134     onlyOwner public {
135         frozenAccount[target] = freeze;
136         emit FrozenFunds(target, freeze);
137     }
138 
139     function setPrices(uint256 newSellPrice, uint256 newBuyPrice)
140     onlyOwner public {
141         sellPrice = newSellPrice;
142         buyPrice = newBuyPrice;
143     }
144 
145     function setStatus(bool isClosedSell)
146     onlyOwner public {
147         closeSell = isClosedSell;
148     }
149 
150     function withdrawEther(uint amountInWeis)
151     onlyOwner public {
152         address contr = this;
153         require(contr.balance >= amountInWeis);
154         emit Withdrawal(msg.sender, amountInWeis);
155         owner.transfer(amountInWeis);
156     }
157 
158 
159     // Public functions
160 
161     function transfer(address _to, uint256 _value)
162     public {
163         _pay_token_commission(_value);
164         _transfer(msg.sender, _to, _value);
165     }
166 
167     function approve(address _spender, uint256 _value)
168     public returns (bool success) {
169         allowance[msg.sender][_spender] = _value;
170         return true;
171     }
172 
173     function transferFrom(address _from, address _to, uint256 _value)
174     public returns (bool success) {
175         require(_value <= allowance[_from][msg.sender]);
176         _pay_token_commission(_value);
177         allowance[_from][msg.sender] -= _value;
178         _transfer(_from, _to, _value);
179         return true;
180     }
181 
182     function depositEther() payable
183     public returns(bool success) {
184         address contr = this;
185         require((contr.balance + msg.value) > contr.balance);
186         emit Deposit(msg.sender, msg.value);
187         return true;
188     }
189 
190     function buy() payable
191     public {
192         uint amount = msg.value / buyPrice;
193         uint market_value = amount * buyPrice;
194         uint commission = market_value * 1 / 100;
195         // The comision is paid with Ether
196         if (commission < minimumEtherCommission){
197             commission = minimumEtherCommission;
198         }
199         address contr = this;
200         require(contr.balance >= commission);
201         commissionGetter.transfer(commission);
202         _transfer(this, msg.sender, amount);
203     }
204 
205     function sell(uint256 amount)
206     public {
207     	require(!closeSell);
208         _pay_token_commission(amount);
209         _transfer(msg.sender, this, amount);
210         uint market_value = amount * sellPrice;
211         address contr = this;
212         require(contr.balance >= market_value);
213         msg.sender.transfer(market_value);
214     }
215 
216     function () payable
217     public {
218         buy();
219     }
220 }