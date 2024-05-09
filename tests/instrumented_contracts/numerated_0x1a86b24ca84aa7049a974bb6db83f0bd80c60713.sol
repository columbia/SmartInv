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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Burn(address indexed from, uint256 value);
31 
32     function TokenERC20(
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
100 /******************************************/
101 /*       ADVANCED Code STARTS HERE       */
102 /******************************************/
103 
104 contract DCoin is owned, TokenERC20 {
105 
106     uint256 public sellPrice;
107     uint256 public buyPrice;
108     mapping (address => bool) public frozenAccount;
109 
110     event FrozenFunds(address target, bool frozen);
111 
112     function DCoin(
113         uint256 initialSupply,
114         string tokenName,
115         string tokenSymbol
116     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
117 
118     function _transfer(address _from, address _to, uint _value) internal {
119         require (_to != 0x0);
120         require (balanceOf[_from] >= _value);
121         require (balanceOf[_to] + _value > balanceOf[_to]);
122         require(!frozenAccount[_from]);
123         require(!frozenAccount[_to]);
124         balanceOf[_from] -= _value;
125         balanceOf[_to] += _value;
126         Transfer(_from, _to, _value);
127     }
128 
129     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
130         balanceOf[target] += mintedAmount;
131         totalSupply += mintedAmount;
132         Transfer(0, this, mintedAmount);
133         Transfer(this, target, mintedAmount);
134     }
135 
136     function freezeAccount(address target, bool freeze) onlyOwner public {
137         frozenAccount[target] = freeze;
138         FrozenFunds(target, freeze);
139     }
140 
141     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
142         sellPrice = newSellPrice;
143         buyPrice = newBuyPrice;
144     }
145 
146     function buy() payable public {
147         uint amount = msg.value / buyPrice;
148         _transfer(this, msg.sender, amount);
149     }
150 
151     function sell(uint256 amount) public {
152         require(this.balance >= amount * sellPrice);
153         _transfer(msg.sender, this, amount);
154         msg.sender.transfer(amount * sellPrice);
155     }
156 }