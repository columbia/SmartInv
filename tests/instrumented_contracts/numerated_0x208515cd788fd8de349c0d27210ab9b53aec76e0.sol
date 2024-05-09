1 pragma solidity ^0.4.19;
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
22 contract ILMTToken {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Burn(address indexed from, uint256 value);
35 
36     function ILMTToken(
37         uint256 initialSupply,
38         string tokenName,
39         string tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
42         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
43         name = tokenName;                                   // Set the name for display purposes
44         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
58 
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);     // Check allowance
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69     
70     function approve(address _spender, uint256 _value) public
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
77         public
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, this, _extraData);
82             return true;
83         }
84     }
85 
86     function burnFrom(address _from, uint256 _value) public returns (bool success) {
87         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
88         require(_value <= allowance[_from][msg.sender]);    // Check allowance
89         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
90         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
91         totalSupply -= _value;                              // Update totalSupply
92         Burn(_from, _value);
93         return true;
94     }
95 
96 
97 }
98 
99 contract Illuminati is owned, ILMTToken {
100 
101     uint256 public sellPrice;
102     uint256 public buyPrice;
103 
104 
105     function Illuminati (
106         uint256 initialSupply,
107         string tokenName,
108         string tokenSymbol
109     ) ILMTToken(initialSupply, tokenName, tokenSymbol) public {}
110 
111     function _transfer(address _from, address _to, uint _value) internal {
112         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
113         require (balanceOf[_from] >= _value);               // Check if the sender has enough
114         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
115         balanceOf[_from] -= _value;                         // Subtract from the sender
116         balanceOf[_to] += _value;                           // Add the same to the recipient
117         Transfer(_from, _to, _value);
118     }
119 
120     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
121         balanceOf[target] += mintedAmount;
122         totalSupply += mintedAmount;
123         Transfer(0, this, mintedAmount);
124         Transfer(this, target, mintedAmount);
125     }
126 
127 }