1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract WeiFangQiCoin is owned {
21     string constant public name="Wei Fang Qi Coin";
22     uint8 constant public decimals=2; 
23     string constant public symbol="WFQ";
24     uint256 constant private _initialAmount = 950000;
25 
26     uint256 constant private MAX_UINT256 = 2**256 - 1;
27 
28     uint256 public totalSupply;
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowed;
31     uint256 public sellPrice; //=10000000000000000;
32     uint256 public buyPrice;
33     mapping (address => bool) public frozenAccount;
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     event Burn(address indexed _from,uint256 _value);
38     event FrozenFunds(address indexed target, bool frozen);
39     event MintToken(address indexed target,uint256 _value);
40     event Buy(address indexed target,uint256 _value);
41     event WithDraw(address _value);
42 
43     constructor(
44         /* uint256 _initialAmount,
45         string _tokenName,
46         uint8 _decimalUnits,
47         string _tokenSymbol */) 
48             public payable {
49         uint256 mint_total=_initialAmount * 10 ** uint256(decimals);
50         balanceOf[msg.sender] = mint_total;
51         totalSupply = mint_total;
52         /*
53         name = _tokenName;
54         decimals = _decimalUnits;
55         symbol = _tokenSymbol; 
56         */
57     }
58     function() public payable {
59         buy();
60     }
61 
62     function buy() payable public returns (bool success) {
63         //require(!frozenAccount[msg.sender]); 
64         uint256 amount = msg.value / buyPrice; 
65         _transfer(owner, msg.sender, amount); 
66         emit Buy(msg.sender,amount);
67         //token(owner).transfer(msg.sender,msg.value);
68         return true;
69     }
70 
71     function _transfer(address _from, address _to, uint _value) internal {
72         require(_to != 0x0);
73         require(balanceOf[_from] >= _value);
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         require(!frozenAccount[_from]);
76         require(!frozenAccount[_to]); 
77         if (_from == _to)
78             return;
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         balanceOf[_from] -= _value;
81         balanceOf[_to] += _value;
82         emit Transfer(_from, _to, _value);
83         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84     }
85     
86     function transfer(address _to, uint256 _value) public returns (bool success) {
87         _transfer(msg.sender,_to,_value);
88         return true;
89     }
90     /*
91     function adminTransfer(address _from,address _to, uint256 _value) onlyOwner public returns (bool success) {
92         _transfer(_from,_to,_value);
93         return true;
94     }*/
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         uint256 allowance = allowed[_from][msg.sender];
97         require(balanceOf[_from] >= _value && allowance >= _value);
98         _transfer(_from,_to,_value);
99         if (allowance < MAX_UINT256) {
100             allowed[_from][msg.sender] -= _value;
101         }
102         return true;
103     }
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
110         return allowed[_owner][_spender];
111     }
112     function burn(uint256 _value) public  {
113         require(balanceOf[msg.sender] >= _value);
114         balanceOf[msg.sender] -= _value;
115         totalSupply -= _value;
116         //balanceOf[msg.sender] -= _value * 10 ** uint256(decimals);
117         //totalSupply -= _value * 10 ** uint256(decimals);
118         emit Burn(msg.sender, _value);
119     }
120     function burnFrom(address _from, uint256 _value) public {
121         require(balanceOf[_from] >= _value);
122         require(_value <= allowed[_from][msg.sender]);
123         balanceOf[_from] -= _value;
124         allowed[_from][msg.sender] -= _value;
125         totalSupply -= _value;
126         /*
127         balanceOf[_from] -= _value * 10 ** uint256(decimals);
128         allowed[_from][msg.sender] -= _value * 10 ** uint256(decimals);
129         totalSupply -= _value * 10 ** uint256(decimals);
130         */
131         emit Burn(_from, _value);
132     }
133     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
134         balanceOf[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         //balanceOf[target] += mintedAmount * 10 ** uint256(decimals);
137         //totalSupply += mintedAmount * 10 ** uint256(decimals);
138         //emit Transfer(0, this, mintedAmount);
139         //emit Transfer(this, target, mintedAmount);
140         emit MintToken(target,mintedAmount);
141     }
142     function freezeAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         emit FrozenFunds(target, freeze);
145     }
146     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
147         sellPrice = newSellPrice;
148         buyPrice = newBuyPrice;
149     }
150     function sell(uint256 _amount) public returns (bool success){
151         require(!frozenAccount[msg.sender]);
152         //uint256 amount = _amount * 10 ** uint256(decimals); 
153         require(balanceOf[msg.sender] >= _amount);
154         require(address(this).balance >= _amount * sellPrice);
155         _transfer(msg.sender, owner, _amount);
156         if (!msg.sender.send(_amount * sellPrice)) {
157             return false;
158         }
159         return true;
160     }
161     function withdraw(address target) onlyOwner public {
162         //require(withdrawPassword == 888888);
163         target.transfer(address(this).balance);
164         emit WithDraw(target);
165         /*
166         if (!msg.sender.send(amount)) {
167             return false;
168         }
169         */
170     }
171     /*
172     function withDrawInWei(uint256 amount) onlyOwner public returns (bool) {
173         if (!msg.sender.send(amount)) {
174             return false;
175         }
176         return true;
177     }
178     */
179     function killSelf(uint256 target) onlyOwner public returns (bool success){
180         if (target == 31415926){
181             selfdestruct(owner);
182             return true;
183         }
184         return false;
185     }
186 }