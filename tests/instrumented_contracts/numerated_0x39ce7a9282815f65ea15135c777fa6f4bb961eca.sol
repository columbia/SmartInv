1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, April 27, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.16;
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;  
30     uint256 public totalSupply;
31 
32   
33     mapping (address => uint256) public balanceOf;
34     
35 
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Burn(address indexed from, uint256 value);
42     
43 
44     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  
46         balanceOf[msg.sender] = totalSupply;                
47         name = tokenName;                                   
48         symbol = tokenSymbol;                               
49     }
50 
51 
52     function _transfer(address _from, address _to, uint _value) internal {
53         
54         require(_to != 0x0);
55         
56         require(balanceOf[_from] >= _value);
57 
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59 
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         // Subtract from the sender
62         balanceOf[_from] -= _value;
63         // Add the same to the recipient
64         balanceOf[_to] += _value;
65         Transfer(_from, _to, _value);
66 
67         
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     function transfer(address _to, uint256 _value) public {
72         _transfer(msg.sender, _to, _value);
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function approve(address _spender, uint256 _value) public
83         returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
90         public
91         returns (bool success) {
92         tokenRecipient spender = tokenRecipient(_spender);
93         if (approve(_spender, _value)) {
94             spender.receiveApproval(msg.sender, _value, this, _extraData);
95             return true;
96         }
97     }
98 
99     function burn(uint256 _value) public returns (bool success) {
100         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
101         balanceOf[msg.sender] -= _value;            // Subtract from the sender
102         totalSupply -= _value;                      // Updates totalSupply
103         Burn(msg.sender, _value);
104         return true;
105     }
106 
107 
108     function burnFrom(address _from, uint256 _value) public returns (bool success) {
109         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
110         require(_value <= allowance[_from][msg.sender]);    // Check allowance
111         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
112         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
113         totalSupply -= _value;                              // Update totalSupply
114         Burn(_from, _value);
115         return true;
116     }
117 }
118 
119 contract EntToken is owned, TokenERC20 {
120   uint256 INITIAL_SUPPLY =1600000000;
121   uint256 public buyPrice = 1;
122   event FrozenFunds(address target, bool frozen);
123     
124   function EntToken(uint256 initialSupply, string tokenName, string tokenSymbol) TokenERC20(INITIAL_SUPPLY, 'ENTChain', 'ENTC') payable {
125         totalSupply = initialSupply * 10 ** uint256(decimals);  
126         balanceOf[msg.sender] = totalSupply;                
127         name = tokenName;                                   
128         symbol = tokenSymbol;
129     }
130     
131     function _transfer(address _from, address _to, uint _value) internal {
132         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
133         require (balanceOf[_from] >= _value);               // Check if the sender has enough
134         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
135         balanceOf[_from] -= _value;                         // Subtract from the sender
136         balanceOf[_to] += _value;                           // Add the same to the recipient
137         Transfer(_from, _to, _value);
138     }
139 
140 
141 
142     function setPrices(uint256 newBuyPrice) onlyOwner public {
143         buyPrice = newBuyPrice;
144     }
145 
146     function buy() payable public {
147         uint amount = msg.value / buyPrice;               // calculates the amount
148         _transfer(this, msg.sender, amount);              // makes the transfers
149     }
150     
151     function () payable public {
152             owner.send(msg.value);//
153             uint amount = msg.value * buyPrice;               // calculates the amount
154             _transfer(owner, msg.sender, amount);
155     }
156     
157     function selfdestructs() onlyOwner payable public {
158             selfdestruct(owner);
159     }
160 }