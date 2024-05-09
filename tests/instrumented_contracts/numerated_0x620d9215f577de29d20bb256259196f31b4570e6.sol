1 pragma solidity ^0.4.21;
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external ; }
21 
22 contract TokenERC20 is owned {
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals = 2;
27     uint256 public totalSupply;
28     uint256 public sellPrice;
29     uint256 public buyPrice;
30 
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => uint256) public info;
34     mapping (address => mapping (address => uint256)) public allowance;
35     mapping (address => bool) public frozenAccount;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Burn(address indexed from, uint256 value);    
39     event FrozenFunds(address target, bool frozen);
40 
41     function TokenERC20(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);
47         balanceOf[msg.sender] = totalSupply/2; 
48         balanceOf[this] = totalSupply/2;
49         name = tokenName;
50         symbol = tokenSymbol;
51         sellPrice = 1 * 10 ** 16;
52         buyPrice = 1 * 10 ** 16;
53     }
54 
55     function _transfer(address _from, address _to, uint _value) internal {
56         require(_to != 0x0);
57         require(balanceOf[_from] >= _value);
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     function transfer(address _to, uint256 _value) public {
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function approve(address _spender, uint256 _value) public
78         returns (bool success) {
79         allowance[msg.sender][_spender] = _value;
80         return true;
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
84         public
85         returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 
93     function burn(uint256 _value) public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);   
95         balanceOf[msg.sender] -= _value;            
96         totalSupply -= _value;                      
97         emit Burn(msg.sender, _value);
98         return true;
99     }
100 
101     function burnFrom(address _from, uint256 _value) public returns (bool success) {
102         require(balanceOf[_from] >= _value);                
103         require(_value <= allowance[_from][msg.sender]);    
104         balanceOf[_from] -= _value;                         
105         allowance[_from][msg.sender] -= _value;             
106         totalSupply -= _value;                              
107         emit Burn(_from, _value);
108         return true;
109     }
110 
111     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
112         balanceOf[target] += mintedAmount;
113         totalSupply += mintedAmount;
114         emit Transfer(0, this, mintedAmount);
115         emit Transfer(this, target, mintedAmount);
116     }
117 
118     function freezeAccount(address target, bool freeze) onlyOwner public {
119         frozenAccount[target] = freeze;
120         emit FrozenFunds(target, freeze);
121     }
122 
123     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
124         sellPrice = newSellPrice;
125         buyPrice = newBuyPrice;
126     }
127 
128     function buy() payable public {
129         uint256 amount = msg.value / buyPrice;
130         require(balanceOf[this] >= amount);
131         _transfer(this, msg.sender, amount);
132     }
133 
134     function sell(uint256 amount) public {
135         require(address(this).balance >= amount * sellPrice);
136         _transfer(msg.sender, this, amount); 
137         msg.sender.transfer(amount * sellPrice); 
138     }
139 }