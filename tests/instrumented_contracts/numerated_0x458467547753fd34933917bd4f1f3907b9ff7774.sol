1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 interface tokenRecipient { 
20     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
21 }
22 
23 contract UCCoin is owned {
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     mapping (address => bool) public frozenAccount;
33 
34     mapping (address => bool) public admins;
35 
36     event FrozenFunds(address target, bool frozen);
37 
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Burn(address indexed from, uint256 value);
42 
43     bool public ico = true;
44     modifier notICO {
45         require(admins[msg.sender] || !ico);
46         _;
47     }
48     function UCCoin(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57 
58         admins[msg.sender] = true;
59     }
60     function setICO(bool isIco) onlyOwner public {
61         ico = isIco;
62     }
63 
64     function setAdmin(address target, bool isAdmin) onlyOwner public {
65         admins[target] = isAdmin;
66     }
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value > balanceOf[_to]);
74 
75         require(!frozenAccount[_from]);                     // Check if sender is frozen
76         require(!frozenAccount[_to]);                       // Check if recipient is frozen
77 
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88     function transfer(address _to, uint256 _value) notICO public {
89         _transfer(msg.sender, _to, _value);
90     }
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97     function freezeAccount(address target, bool freeze) onlyOwner public {
98         frozenAccount[target] = freeze;
99         FrozenFunds(target, freeze);
100     }
101     function approve(address _spender, uint256 _value) public
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         return true;
105     }
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
107         public
108         returns (bool success) {
109         tokenRecipient spender = tokenRecipient(_spender);
110         if (approve(_spender, _value)) {
111             spender.receiveApproval(msg.sender, _value, this, _extraData);
112             return true;
113         }
114     }
115     function burn(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
117         balanceOf[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122     function burnFrom(address _from, uint256 _value) public returns (bool success) {
123         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
124         require(_value <= allowance[_from][msg.sender]);    // Check allowance
125         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
126         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
127         totalSupply -= _value;                              // Update totalSupply
128         Burn(_from, _value);
129         return true;
130     }
131 }