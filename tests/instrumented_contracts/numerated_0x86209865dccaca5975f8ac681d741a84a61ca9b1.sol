1 pragma solidity ^0.4.18;
2 
3 
4     contract owned {
5         address public owner;
6 
7         constructor() public {
8             owner = msg.sender;
9         }
10 
11         modifier onlyOwner {
12             require(msg.sender == owner);
13             _;
14         }
15 
16         function transferOwnership(address newOwner) onlyOwner public {
17             owner = newOwner;
18         }
19     }
20 
21     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
22 
23     contract TokenERC20 {
24         address public owner;
25         string public name;
26         string public symbol;
27         uint8 public decimals = 18;
28         uint256 public totalSupply;
29 
30 
31         mapping (address => uint256) public balanceOf;
32         mapping (address => mapping (address => uint256)) public allowance;
33 
34 
35         event Transfer(address indexed from, address indexed to, uint256 value);
36 
37 
38         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 
41         event Burn(address indexed from, uint256 value);
42 
43 
44         constructor(
45             uint256 initialSupply,
46             string tokenName,
47             string tokenSymbol
48         ) public {
49             totalSupply = initialSupply * 10 ** uint256(decimals);
50             balanceOf[msg.sender] = totalSupply;
51             name = tokenName;
52             symbol = tokenSymbol;
53             owner = msg.sender;
54         }
55 
56 
57 
58         function _transfer(address _from, address _to, uint _value) internal {
59 
60             require(_to != 0x0);
61 
62             require(balanceOf[_from] >= _value);
63 
64             require(balanceOf[_to] + _value > balanceOf[_to]);
65 
66             uint previousBalances = balanceOf[_from] + balanceOf[_to];
67 
68             balanceOf[_from] -= _value;
69 
70             balanceOf[_to] += _value;
71             emit Transfer(_from, _to, _value);
72 
73             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74         }
75 
76 
77         function transfer(address _to, uint256 _value) public returns (bool success) {
78             _transfer(msg.sender, _to, _value);
79             return true;
80         }
81 
82 
83         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84             require (owner == msg.sender);
85             allowance[_from][msg.sender] -= _value;
86             _transfer(_from, _to, _value);
87             return true;
88         }
89 
90 
91         function approve(address _spender, uint256 _value) public
92             returns (bool success) {
93             allowance[msg.sender][_spender] = _value;
94             emit Approval(msg.sender, _spender, _value);
95             return true;
96         }
97 
98 
99         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100             public
101             returns (bool success) {
102             tokenRecipient spender = tokenRecipient(_spender);
103             if (approve(_spender, _value)) {
104                 spender.receiveApproval(msg.sender, _value, this, _extraData);
105                 return true;
106             }
107         }
108 
109 
110         function burn(uint256 _value) public returns (bool success) {
111             require(balanceOf[msg.sender] >= _value);
112             balanceOf[msg.sender] -= _value;
113             totalSupply -= _value;
114             emit Burn(msg.sender, _value);
115             return true;
116         }
117 
118 
119         function burnFrom(address _from, uint256 _value) public returns (bool success) {
120             require(balanceOf[_from] >= _value);
121             require(msg.sender == owner);
122             balanceOf[_from] -= _value;
123             allowance[_from][msg.sender] -= _value;
124             totalSupply -= _value;
125             emit Burn(_from, _value);
126             return true;
127         }
128     }
129 
130     /******************************************/
131     /*       ADVANCED TOKEN STARTS HERE       */
132     /******************************************/
133 
134     contract EntCoin is owned, TokenERC20 {
135 
136         uint256 public sellPrice;
137         uint256 public buyPrice;
138 
139         /* Initializes contract with initial supply tokens to the creator of the contract */
140         constructor(
141             uint256 initialSupply,
142             string tokenName,
143             string tokenSymbol
144         ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
145 
146         function _transfer(address _from, address _to, uint _value) internal {
147             require (_to != 0x0);
148             require (balanceOf[_from] >= _value);
149             require (balanceOf[_to] + _value >= balanceOf[_to]);
150             balanceOf[_from] -= _value;
151             balanceOf[_to] += _value;
152             emit Transfer(_from, _to, _value);
153         }
154 
155 
156         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
157             balanceOf[target] += mintedAmount;
158             totalSupply += mintedAmount;
159             emit Transfer(0, this, mintedAmount);
160             emit Transfer(this, target, mintedAmount);
161         }
162         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
163             sellPrice = newSellPrice;
164             buyPrice = newBuyPrice;
165         }
166 
167         function buy() payable public {
168             uint amount = msg.value / buyPrice;
169             _transfer(this, msg.sender, amount);
170         }
171 
172         function sell(uint256 amount) public {
173             address myAddress = this;
174             require(myAddress.balance >= amount * sellPrice);
175             _transfer(msg.sender, this, amount);
176             msg.sender.transfer(amount * sellPrice);
177         }
178 
179     }