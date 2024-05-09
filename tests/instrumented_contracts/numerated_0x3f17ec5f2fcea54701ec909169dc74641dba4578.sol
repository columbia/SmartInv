1 pragma solidity ^0.4.16;
2  
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 contract owned 
5 {
6     address public owner;
7     function owned () public
8     {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner 
13     {
14         require (msg.sender == owner);
15         _;
16     }
17  
18 
19     function transferOwnership(address newOwner) onlyOwner public 
20     {
21         if (newOwner != address(0)) 
22         {
23             owner = newOwner;
24         }
25     }
26 }
27 
28 contract TokenERC20 
29 {
30     string public name; 
31     string public symbol; 
32     uint8 public decimals = 18; 
33     uint256 public totalSupply; 
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37  
38     event Transfer(address indexed from, address indexed to, uint256 value);  
39     event Burn(address indexed from, uint256 value);  
40 
41     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public 
42     {
43         totalSupply = initialSupply * 10 ** uint256(decimals);   
44         balanceOf[msg.sender] = totalSupply;
45         name = tokenName;
46         symbol = tokenSymbol;
47     }
48 
49     function _transfer(address _from, address _to, uint256 _value) internal
50     {
51       require(_to != 0x0);
52  
53       require(balanceOf[_from] >= _value);
54  
55       require(balanceOf[_to] + _value > balanceOf[_to]);
56 
57       uint previousBalances = balanceOf[_from] + balanceOf[_to];
58  
59       balanceOf[_from] -= _value;
60 
61       balanceOf[_to] += _value;
62 
63       Transfer(_from, _to, _value);
64 
65       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68     function transfer(address _to, uint256 _value) public
69     {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
74     {
75         require(_value <= allowance[_from][msg.sender]);
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) 
82     {
83         allowance[msg.sender][_spender] = _value;
84         return true;
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
88     {
89         tokenRecipient spender = tokenRecipient(_spender);
90         if (approve(_spender, _value)) 
91         {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96 
97     function burn(uint256 _value) public returns (bool success) 
98     {
99         require(balanceOf[msg.sender] >= _value);
100         balanceOf[msg.sender] -= _value;
101         totalSupply -= _value;
102         Burn(msg.sender, _value);
103         return true;
104     }
105 
106     function burnFrom(address _from, uint256 _value) public returns (bool success)
107     {
108         require(balanceOf[_from] >= _value);
109         require(_value <= allowance[_from][msg.sender]);
110         balanceOf[_from] -= _value;
111         allowance[_from][msg.sender] -= _value;
112         totalSupply -= _value;
113         Burn(_from, _value);
114         return true;
115     }
116 }
117 
118 contract MyAdvancedToken is owned, TokenERC20
119  {
120     uint256 public sellPrice;
121     uint256 public buyPrice;
122     mapping (address => bool) public frozenAccount;
123     event FrozenFunds(address target, bool frozen);
124 
125         function MyAdvancedToken(
126         uint256 initialSupply,
127         string tokenName,
128         string tokenSymbol
129     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
130 
131     function _transfer(address _from, address _to, uint _value) internal 
132     {
133  
134         require (_to != 0x0);
135  
136         require (balanceOf[_from] >= _value);
137  
138         require (balanceOf[_to] + _value > balanceOf[_to]);
139  
140         require(!frozenAccount[_from]);
141 
142         require(!frozenAccount[_to]);
143  
144         balanceOf[_from] -= _value;
145  
146         balanceOf[_to] += _value;
147  
148         Transfer(_from, _to, _value);
149  
150     }
151 
152     function mintToken(address target, uint256 mintedAmount) onlyOwner public
153     {
154         balanceOf[target] += mintedAmount;
155         totalSupply += mintedAmount;
156  
157  
158         Transfer(0, this, mintedAmount);
159         Transfer(this, target, mintedAmount);
160     }
161 
162     function freezeAccount(address target, bool freeze) onlyOwner public
163     {
164         frozenAccount[target] = freeze;
165         FrozenFunds(target, freeze);
166     }
167 
168     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public
169     {
170         sellPrice = newSellPrice;
171         buyPrice = newBuyPrice;
172     }
173 }