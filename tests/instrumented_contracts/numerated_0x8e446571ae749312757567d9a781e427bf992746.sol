1 pragma solidity ^0.4.18;
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
26 
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Burn(address indexed from, uint256 value);
35 
36     function TokenERC20(
37         uint256 initialSupply,
38         string tokenName,
39         string tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45     }
46 
47     function _transfer(address _from, address _to, uint _value) internal {
48         require(_to != 0x0);
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]);
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76         public
77         returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85     function burn(uint256 _value) public returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);
87         balanceOf[msg.sender] -= _value;
88         totalSupply -= _value;
89         Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) public returns (bool success) {
94         require(balanceOf[_from] >= _value);
95         require(_value <= allowance[_from][msg.sender]);
96         balanceOf[_from] -= _value;
97         allowance[_from][msg.sender] -= _value;
98         totalSupply -= _value;
99         Burn(_from, _value);
100         return true;
101     }
102 }
103 
104 contract Martcoin is owned, TokenERC20 {
105     string public name = "Martcoin";
106     string public symbol = "MART";
107     uint public decimals = 18;
108     uint public INITIAL_SUPPLY = 29000000;
109 
110     uint256 public sellPrice;
111     uint256 public buyPrice;
112 
113     mapping (address => bool) public frozenAccount;
114 
115     event FrozenFunds(address target, bool frozen);
116 
117     function Martcoin(
118         uint256 initialSupply,
119         string tokenName,
120         string tokenSymbol
121     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
122 
123     function _transfer(address _from, address _to, uint _value) internal {
124         require (_to != 0x0);
125         require (balanceOf[_from] >= _value);
126         require (balanceOf[_to] + _value > balanceOf[_to]);
127         require(!frozenAccount[_from]);
128         require(!frozenAccount[_to]);
129         balanceOf[_from] -= _value;
130         balanceOf[_to] += _value;
131         Transfer(_from, _to, _value);
132     }
133 
134     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
135         balanceOf[target] += mintedAmount;
136         totalSupply += mintedAmount;
137         Transfer(0, this, mintedAmount);
138         Transfer(this, target, mintedAmount);
139     }
140 
141     function freezeAccount(address target, bool freeze) onlyOwner public {
142         frozenAccount[target] = freeze;
143         FrozenFunds(target, freeze);
144     }
145 
146     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
147         sellPrice = newSellPrice;
148         buyPrice = newBuyPrice;
149     }
150 
151     function buy() payable public {
152         uint amount = msg.value / buyPrice;
153         _transfer(this, msg.sender, amount);
154     }
155 
156     function sell(uint256 amount) public {
157         require(this.balance >= amount * sellPrice);
158         _transfer(msg.sender, this, amount);
159         msg.sender.transfer(amount * sellPrice);
160     }
161 }