1 pragma solidity ^0.4.16;
2  
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned 
6 {
7     address public owner;
8     
9     function owned () public
10     {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require (msg.sender == owner);
16         _;
17     }
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
28 contract TokenERC20 {
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18;
32     uint256 public totalSupply;
33  
34     mapping (address => uint256) public balanceOf;
35     
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);  
39     
40     event Burn(address indexed from, uint256 value);
41 
42     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public
43     {
44         totalSupply = initialSupply * 10 ** uint256(decimals);   
45         balanceOf[msg.sender] = totalSupply;
46         name = tokenName;
47         symbol = tokenSymbol;
48     }
49 
50     function _transfer(address _from, address _to, uint256 _value) internal 
51     {
52       require(_to != 0x0);
53  
54       require(balanceOf[_from] >= _value);
55  
56       require(balanceOf[_to] + _value > balanceOf[_to]);
57  
58       uint previousBalances = balanceOf[_from] + balanceOf[_to];
59  
60       balanceOf[_from] -= _value;
61  
62       balanceOf[_to] += _value;
63  
64       Transfer(_from, _to, _value);
65  
66       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72  
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function approve(address _spender, uint256 _value) public returns (bool success) {
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 }
93 
94 contract MyAdvancedToken is owned, TokenERC20 {
95  
96     uint256 public sellPrice;
97  
98     uint256 public buyPrice;
99 
100         function MyAdvancedToken(
101         uint256 initialSupply,
102         string tokenName,
103         string tokenSymbol
104     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
105 
106     function _transfer(address _from, address _to, uint _value) internal {
107  
108         require (_to != 0x0);
109  
110         require (balanceOf[_from] > _value);
111  
112         require (balanceOf[_to] + _value > balanceOf[_to]);
113  
114         balanceOf[_from] -= _value;
115  
116         balanceOf[_to] += _value;
117  
118         Transfer(_from, _to, _value);
119     }
120 
121     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
122  
123         balanceOf[target] += mintedAmount;
124         totalSupply += mintedAmount;
125         Transfer(0, this, mintedAmount);
126         Transfer(this, target, mintedAmount);
127     }
128     
129     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
130         sellPrice = newSellPrice;
131         buyPrice = newBuyPrice;
132     }
133 }