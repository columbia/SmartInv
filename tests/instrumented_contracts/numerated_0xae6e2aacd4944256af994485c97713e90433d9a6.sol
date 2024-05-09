1 pragma solidity 0.4.21;
2 
3 /*--------------------------------------------------------------/*
4         _      _                 _                _         
5   _ __ ( ) ___| | ___  _   _  __| |  _____      _(_)___ ___ 
6  | '_ \|/ / __| |/ _ \| | | |/ _` | / __\ \ /\ / / / __/ __|
7  | | | | | (__| | (_) | |_| | (_| |_\__ \\ V  V /| \__ \__ \
8  |_| |_|  \___|_|\___/ \__,_|\__,_(_)___/ \_/\_/ |_|___/___/
9                                                             
10                               NCU Token   
11                               
12                  Token Code created:   23.03.2018
13                                  - 
14                  Token Code published: 04.04.2018
15                  
16                         by n'cloud.swiss AG                                           
17 /*--------------------------------------------------------------*/
18 
19 contract owned {
20     address public owner;
21 
22     function owned() public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address newOwner) onlyOwner public {
32         owner = newOwner;
33     }
34 }
35 
36 library SafeMath {
37   function add(uint a, uint b) internal pure returns (uint c) {
38        c = a + b;
39         require(c >= a);
40    }
41     function sub(uint a, uint b) internal pure returns (uint c) {
42         require(b <= a);
43        c = a - b;
44    }
45     function mul(uint a, uint b) internal pure returns (uint c) {
46        c = a * b;
47        require(a == 0 || c / a == b);
48   }
49   function div(uint a, uint b) internal pure returns (uint c) {
50     require(b > 0);
51       c = a / b;
52    }
53 }
54 
55 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
56 
57 contract TokenERC20 {
58     
59     string public name;
60     string public symbol;
61     uint8 public decimals;
62     uint256 public totalSupply;
63 
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     event Burn(address indexed from, uint256 value);
70 
71     function TokenERC20(
72         uint256 initialSupply,
73         string tokenName,
74         string tokenSymbol
75 
76     ) public {
77         totalSupply = initialSupply * 10 ** uint256(decimals);
78         balanceOf[msg.sender] = totalSupply;
79         name = tokenName;
80         symbol = tokenSymbol;
81     }
82 
83     function _transfer(address _from, address _to, uint _value) internal {
84         require(_to != 0x0);
85         require(balanceOf[_from] >= _value);
86         require(balanceOf[_to] + _value > balanceOf[_to]);
87         uint previousBalances = balanceOf[_from] + balanceOf[_to];
88         balanceOf[_from] -= _value;
89         balanceOf[_to] += _value;
90         Transfer(_from, _to, _value);
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     function transfer(address _to, uint256 _value) public {
95         _transfer(msg.sender, _to, _value);
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public
106         returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110 
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112         public
113         returns (bool success) {
114         tokenRecipient spender = tokenRecipient(_spender);
115         if (approve(_spender, _value)) {
116             spender.receiveApproval(msg.sender, _value, this, _extraData);
117             return true;
118         }
119     }
120 
121 }
122 
123 contract NCU is owned, TokenERC20 {
124 
125     uint256 public sellPrice;
126     uint256 public buyPrice;
127     uint256 public constant decimals = 2;
128 
129     mapping (address => bool) public frozenAccount;
130 
131     event FrozenFunds(address target, bool frozen);
132 
133     function NCU(
134         uint256 initialSupply,
135         string tokenName,
136         string tokenSymbol
137         
138     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
139 
140 
141     function _transfer(address _from, address _to, uint _value) internal {
142         require (_to != 0x0);
143         require (balanceOf[_from] >= _value);
144         require (balanceOf[_to] + _value > balanceOf[_to]);
145         require(!frozenAccount[_from]);
146         require(!frozenAccount[_to]);
147         balanceOf[_from] -= _value;
148         balanceOf[_to] += _value;
149         Transfer(_from, _to, _value);
150     }
151 
152     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
153         balanceOf[target] += mintedAmount;
154         totalSupply += mintedAmount;
155         Transfer(0, this, mintedAmount);
156         Transfer(this, target, mintedAmount);
157     }
158 
159     function freezeAccount(address target, bool freeze) onlyOwner public {
160         frozenAccount[target] = freeze;
161         FrozenFunds(target, freeze);
162     }
163 
164     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
165         sellPrice = newSellPrice;
166         buyPrice = newBuyPrice;
167     }
168 
169     function buy() payable public {
170         uint amount = msg.value / buyPrice;
171         _transfer(this, msg.sender, amount);
172     }
173 
174     function sell(uint256 amount) public {
175         require(this.balance >= amount * sellPrice);
176         _transfer(msg.sender, this, amount);
177         msg.sender.transfer(amount * sellPrice);
178     }
179    }