1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;
42         name = tokenName;
43         symbol = tokenSymbol;
44     }
45 
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         emit Transfer(_from, _to, _value);
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         _transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]);
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75         public
76         returns (bool success) {
77         tokenRecipient spender = tokenRecipient(_spender);
78         if (approve(_spender, _value)) {
79             spender.receiveApproval(msg.sender, _value, this, _extraData);
80             return true;
81         }
82     }
83 
84     function burn(uint256 _value) public returns (bool success) {
85         require(balanceOf[msg.sender] >= _value);
86         balanceOf[msg.sender] -= _value;
87         totalSupply -= _value;
88         emit Burn(msg.sender, _value);
89         return true;
90     }
91     function burnFrom(address _from, uint256 _value) public returns (bool success) {
92         require(balanceOf[_from] >= _value);
93         require(_value <= allowance[_from][msg.sender]);
94         balanceOf[_from] -= _value;
95         allowance[_from][msg.sender] -= _value;
96         totalSupply -= _value;
97         emit Burn(_from, _value);
98         return true;
99     }
100 }
101 
102 contract EliteShipperToken is owned, TokenERC20 {
103 
104     uint256 public sellPrice;
105     uint256 public buyPrice;
106 
107     mapping (address => bool) public frozenAccount;
108 
109     event FrozenFunds(address target, bool frozen);
110 
111     function EliteShipperToken(
112         uint256 initialSupply,
113         string tokenName,
114         string tokenSymbol
115     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
116 
117     function _transfer(address _from, address _to, uint _value) internal {
118         require (_to != 0x0);
119         require (balanceOf[_from] >= _value);
120         require (balanceOf[_to] + _value >= balanceOf[_to]);
121         require(!frozenAccount[_from]);
122         require(!frozenAccount[_to]);
123         balanceOf[_from] -= _value;
124         balanceOf[_to] += _value;
125         emit Transfer(_from, _to, _value);
126     }
127 
128     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
129         balanceOf[target] += mintedAmount;
130         totalSupply += mintedAmount;
131         emit Transfer(0, this, mintedAmount);
132         emit Transfer(this, target, mintedAmount);
133     }
134 
135     function freezeAccount(address target, bool freeze) onlyOwner public {
136         frozenAccount[target] = freeze;
137         emit FrozenFunds(target, freeze);
138     }
139     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
140         sellPrice = newSellPrice;
141         buyPrice = newBuyPrice;
142     }
143 
144     function buy() payable public {
145         uint amount = msg.value / buyPrice;
146         _transfer(this, msg.sender, amount);
147     }
148 
149     function sell(uint256 amount) public {
150         address myAddress = this;
151         require(myAddress.balance >= amount * sellPrice);
152         _transfer(msg.sender, this, amount);
153         msg.sender.transfer(amount * sellPrice);
154     }
155 }