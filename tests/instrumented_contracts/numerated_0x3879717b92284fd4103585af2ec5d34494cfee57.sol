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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract AngleChain30{
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33 
34     function AngleChain30() public {
35         totalSupply = 1900000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
36         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
37         name = "Micro agricultural chain";                                   // Set the name for display purposes
38         symbol = "MACC";                               // Set the symbol for display purposes
39     }
40 
41     function _transfer(address _from, address _to, uint _value) internal {
42         // Prevent transfer to 0x0 address. Use burn() instead
43         require(_to != 0x0);
44         // Check if the sender has enough
45         require(balanceOf[_from] >= _value);
46         // Check for overflows
47         require(balanceOf[_to] + _value > balanceOf[_to]);
48         // Save this for an assertion in the future
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         // Subtract from the sender
51         balanceOf[_from] -= _value;
52         // Add the same to the recipient
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55         // Asserts are used to use static analysis to find bugs in your code. They should never fail
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     // Check allowance
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72 
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78 
79 
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 }
90 
91 contract MyAdvancedToken is owned, AngleChain30 {
92 
93     uint256 public sellPrice;
94     uint256 public buyPrice;
95 
96     mapping (address => bool) public frozenAccount;
97 
98     /* This generates a public event on the blockchain that will notify clients */
99     event FrozenFunds(address target, bool frozen);
100 
101     function MyAdvancedToken() public{}
102 
103     /* Internal transfer, only can be called by this contract */
104     function _transfer(address _from, address _to, uint _value) internal {
105         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
106         require (balanceOf[_from] > _value);                // Check if the sender has enough
107         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
108         require(!frozenAccount[_from]);                     // Check if sender is frozen
109         require(!frozenAccount[_to]);                       // Check if recipient is frozen
110         balanceOf[_from] -= _value;                         // Subtract from the sender
111         balanceOf[_to] += _value;                           // Add the same to the recipient
112         Transfer(_from, _to, _value);
113     }
114 
115     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
116         balanceOf[target] += mintedAmount;
117         totalSupply += mintedAmount;
118         Transfer(0, this, mintedAmount);
119         Transfer(this, target, mintedAmount);
120     }
121 
122     function freezeAccount(address target, bool freeze) onlyOwner public {
123         frozenAccount[target] = freeze;
124         FrozenFunds(target, freeze);
125     }
126 
127     function setPrices(uint256 newBuyPrice,uint256 newSellPrice) onlyOwner public {
128         buyPrice = newBuyPrice;
129         sellPrice = newSellPrice;
130     }
131 }