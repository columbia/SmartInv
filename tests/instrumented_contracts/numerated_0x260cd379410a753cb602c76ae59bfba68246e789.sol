1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
18 
19 contract Token365 {
20     /* Public variables of the token */
21     string public standard = "Token 0.1";
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     uint256 public totalSupply;
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Burn(address indexed from, uint256 value);
31 
32     function Token365(
33         uint256 initialSupply,
34         string tokenName,
35         string tokenSymbol
36     ) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);
38         balanceOf[msg.sender] = totalSupply; 
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     function transfer(address _to, uint256 _value) public {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_value <= allowance[_from][msg.sender]);
60         allowance[_from][msg.sender] -= _value;
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public
66         returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70 
71     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
72         public
73         returns (bool success) {
74         tokenRecipient spender = tokenRecipient(_spender);
75         if (approve(_spender, _value)) {
76             spender.receiveApproval(msg.sender, _value, this, _extraData);
77             return true;
78         }
79     }
80 
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);
83         balanceOf[msg.sender] -= _value;
84         totalSupply -= _value;
85         Burn(msg.sender, _value);
86         return true;
87     }
88 
89     function burnFrom(address _from, uint256 _value) public returns (bool success) {
90         require(balanceOf[_from] >= _value);
91         require(_value <= allowance[_from][msg.sender]);
92         balanceOf[_from] -= _value; 
93         allowance[_from][msg.sender] -= _value;
94         totalSupply -= _value;
95         Burn(_from, _value);
96         return true;
97     }
98 }
99 
100 contract AdvancedToken365 is owned, Token365 {
101 
102     uint256 public sellPrice;
103     uint256 public buyPrice;
104 
105     mapping (address => bool) public frozenAccount;
106 
107     event FrozenFunds(address target, bool frozen);
108 
109     function AdvancedToken365(
110         uint256 initialSupply,
111         string tokenName,
112         string tokenSymbol
113     ) Token365(initialSupply, tokenName, tokenSymbol) public {}
114 
115     function _transfer(address _from, address _to, uint _value) internal {
116         require (_to != 0x0);
117         require (balanceOf[_from] >= _value);
118         require (balanceOf[_to] + _value > balanceOf[_to]);
119         require(!frozenAccount[_from]);
120         require(!frozenAccount[_to]); 
121         balanceOf[_from] -= _value;
122         balanceOf[_to] += _value;
123         Transfer(_from, _to, _value);
124     }
125 
126     function transfer(address _to, uint256 _value) public {
127         _transfer(msg.sender, _to, _value);
128     }
129 
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]);
132         allowance[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function freezeAccount(address target, bool freeze) onlyOwner public {
138         frozenAccount[target] = freeze;
139         FrozenFunds(target, freeze);
140     }
141 
142     function approvedAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         FrozenFunds(target, freeze);
145     }
146 
147     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
148         sellPrice = newSellPrice;
149         buyPrice = newBuyPrice;
150     }
151 
152     function buy() payable public {
153         uint amount = msg.value / buyPrice;
154         _transfer(this, msg.sender, amount);
155     }
156 
157     function sell(uint256 amount) public {
158 
159         require(this.balance >= amount * sellPrice); 
160         _transfer(msg.sender, this, amount);
161         msg.sender.transfer(amount * sellPrice);
162     }
163 }