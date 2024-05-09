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
19 contract BIGCToken {
20     string public name = "BiaoIGe Token";
21     string public symbol = "BIGC";
22     uint8 public decimals = 18;
23     uint256 public totalSupply = 96000000;
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29 
30     function BIGCToken(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol
34     ) public {
35         totalSupply = initialSupply;
36         balanceOf[msg.sender] = totalSupply; 
37         name = tokenName;
38         symbol = tokenSymbol;
39     }
40 
41     function _transfer(address _from, address _to, uint _value) internal {
42         require(_to != 0x0);
43         require(balanceOf[_from] >= _value);
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46         balanceOf[_from] -= _value;
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value);
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(_value <= allowance[_from][msg.sender]);
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function approve(address _spender, uint256 _value) public
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
70         public
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }
78 
79     function burn(uint256 _value) public returns (bool success) {
80         require(balanceOf[msg.sender] >= _value);
81         balanceOf[msg.sender] -= _value;
82         totalSupply -= _value;
83         Burn(msg.sender, _value);
84         return true;
85     }
86 
87     function burnFrom(address _from, uint256 _value) public returns (bool success) {
88         require(balanceOf[_from] >= _value);
89         require(_value <= allowance[_from][msg.sender]);
90         balanceOf[_from] -= _value; 
91         allowance[_from][msg.sender] -= _value;
92         totalSupply -= _value;
93         Burn(_from, _value);
94         return true;
95     }
96 }
97 
98 contract BIGCAdvancedToken is owned, BIGCToken {
99 
100     uint256 public sellPrice;
101     uint256 public buyPrice;
102 
103     mapping (address => bool) public frozenAccount;
104 
105     event FrozenFunds(address target, bool frozen);
106 
107     function BIGCAdvancedToken(
108         uint256 initialSupply,
109         string tokenName,
110         string tokenSymbol
111     ) BIGCToken(initialSupply, tokenName, tokenSymbol) public {}
112 
113     function _transfer(address _from, address _to, uint _value) internal {
114         require (_to != 0x0);
115         require (balanceOf[_from] >= _value);
116         require (balanceOf[_to] + _value > balanceOf[_to]);
117         require(!frozenAccount[_from]);
118         require(!frozenAccount[_to]); 
119         balanceOf[_from] -= _value;
120         balanceOf[_to] += _value;
121         Transfer(_from, _to, _value);
122     }
123 
124     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
125         balanceOf[target] += mintedAmount;
126         totalSupply += mintedAmount;
127         Transfer(0, this, mintedAmount);
128         Transfer(this, target, mintedAmount);
129     }
130 
131     function freezeAccount(address target, bool freeze) onlyOwner public {
132         frozenAccount[target] = freeze;
133         FrozenFunds(target, freeze);
134     }
135 
136     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
137         sellPrice = newSellPrice;
138         buyPrice = newBuyPrice;
139     }
140 
141     function buy() payable public {
142         uint amount = msg.value / buyPrice;
143         _transfer(this, msg.sender, amount);
144     }
145 
146     function sell(uint256 amount) public {
147         require(this.balance >= amount * sellPrice); 
148         _transfer(msg.sender, this, amount);
149         msg.sender.transfer(amount * sellPrice);
150     }
151 }