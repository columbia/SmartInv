1 pragma solidity ^0.4.26;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
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
20 interface tokenRecipient { 
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
22 }
23 
24 contract ApproveAndCall {
25     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public returns(bool);
26 }
27 
28 contract TokenERC20 {
29     uint8 public decimals = 18;
30 
31     uint256 public totalSupply = 0;
32     string public name = "";
33     string public symbol = "";
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     event Burn(address indexed from, uint256 value);
41 
42     constructor (
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);
48         balanceOf[msg.sender] = totalSupply;
49         name = tokenName;
50         symbol = tokenSymbol;
51     }
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54         require(_to != 0x0);
55         require(balanceOf[_from] >= _value);
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         balanceOf[_from] -= _value;
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function approve(address _spender, uint256 _value) public
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, this, _extraData);
87             return true;
88         }
89     }
90 
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);
93         balanceOf[msg.sender] -= _value;
94         totalSupply -= _value;
95         emit Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);
101         require(_value <= allowance[_from][msg.sender]);
102         balanceOf[_from] -= _value;
103         allowance[_from][msg.sender] -= _value;
104         totalSupply -= _value;
105         emit Burn(_from, _value);
106         return true;
107     }
108 }
109 
110 contract XCMGToken is owned, TokenERC20 {
111 
112     uint256 public sellPrice;
113     uint256 public buyPrice;
114     
115     mapping (address => bool) public frozenAccount;
116 
117     event FrozenFunds(address target, bool frozen);
118 
119     constructor (
120         uint256 initialSupply,
121         string tokenName,
122         string tokenSymbol
123     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
124 
125     function _transfer(address _from, address _to, uint _value) internal {
126         require (_to != 0x0);
127         require (balanceOf[_from] >= _value);
128         require (balanceOf[_to] + _value > balanceOf[_to]);
129         require(!frozenAccount[_from]);
130         require(!frozenAccount[_to]);
131 
132         uint previousBalances = balanceOf[_from] + balanceOf[_to];
133 
134         balanceOf[_from] -= _value;
135         balanceOf[_to] += _value;
136         emit Transfer(_from, _to, _value);
137         
138         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
139     }
140 
141     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
142         balanceOf[target] += mintedAmount;
143         totalSupply += mintedAmount;
144         emit Transfer(0, this, mintedAmount);
145         emit Transfer(this, target, mintedAmount);
146     }
147 
148     function freezeAccount(address target, bool freeze) onlyOwner public {
149         frozenAccount[target] = freeze;
150         emit FrozenFunds(target, freeze);
151     }
152 
153     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
154         sellPrice = newSellPrice;
155         buyPrice = newBuyPrice;
156     }
157 
158     function buy() payable public {
159         uint amount = msg.value / buyPrice;
160         _transfer(this, msg.sender, amount);
161     }
162 
163     function sell(uint256 amount) public {
164         require(address(this).balance >= amount * sellPrice);
165         _transfer(msg.sender, this, amount);
166         msg.sender.transfer(amount * sellPrice);
167     }
168 }