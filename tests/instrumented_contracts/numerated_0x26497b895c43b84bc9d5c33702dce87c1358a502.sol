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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40 
41     function TokenERC20(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals); 
47         balanceOf[msg.sender] = totalSupply;             
48         name = tokenName;                    
49         symbol = tokenSymbol;              
50     }
51 
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         _transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84 
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91 
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
93         public
94         returns (bool success) {
95         tokenRecipient spender = tokenRecipient(_spender);
96         if (approve(_spender, _value)) {
97             spender.receiveApproval(msg.sender, _value, this, _extraData);
98             return true;
99         }
100     }
101 
102     function burn(uint256 _value) public returns (bool success) {
103         require(balanceOf[msg.sender] >= _value);  
104         balanceOf[msg.sender] -= _value;      
105         totalSupply -= _value;               
106         emit Burn(msg.sender, _value);
107         return true;
108     }
109 
110     function burnFrom(address _from, uint256 _value) public returns (bool success) {
111         require(balanceOf[_from] >= _value);               
112         require(_value <= allowance[_from][msg.sender]);  
113         balanceOf[_from] -= _value;                      
114         allowance[_from][msg.sender] -= _value;    
115         totalSupply -= _value;                  
116         emit Burn(_from, _value);
117         return true;
118     }
119 }
120 
121 contract SETC is owned, TokenERC20 {
122     mapping (address => bool) public frozenAccount;
123     event FrozenFunds(address target, bool frozen);
124     function SETC(
125         uint256 initialSupply,
126         string tokenName,
127         string tokenSymbol
128     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
129 
130     function _transfer(address _from, address _to, uint _value) internal {
131         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
132         require (balanceOf[_from] >= _value);               // Check if the sender has enough
133         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
134         require(!frozenAccount[_from]);                     // Check if sender is frozen
135         require(!frozenAccount[_to]);                       // Check if recipient is frozen
136         balanceOf[_from] -= _value;                         // Subtract from the sender
137         balanceOf[_to] += _value;                           // Add the same to the recipient
138         emit Transfer(_from, _to, _value);
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
153 }