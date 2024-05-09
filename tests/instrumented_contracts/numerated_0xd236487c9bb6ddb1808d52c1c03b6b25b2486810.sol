1 pragma solidity ^0.4.20;
2 library SafeMath {
3     function safeadd(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function safesub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11    
12 }
13 contract owned {
14     address public owner;
15 
16     function owned() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
31 
32 contract TokenERC20 {
33    
34     string public name;
35     string public symbol;
36     uint8 public decimals = 18;
37    
38     uint256 public totalSupply;
39 
40   
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44  
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47    
48     event Burn(address indexed from, uint256 value);
49 
50    
51     function TokenERC20(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60     }
61 
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);
73         // Add the same to the recipient
74         balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);
75         emit Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80    
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         _transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86    
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101    
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     function burn(uint256 _value) public returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
114         balanceOf[msg.sender] -= _value;            // Subtract from the sender
115         totalSupply -= _value;                      // Updates totalSupply
116         emit Burn(msg.sender, _value);
117         return true;
118     }
119 
120    
121     function burnFrom(address _from, uint256 _value) public returns (bool success) {
122         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
123         require(_value <= allowance[_from][msg.sender]);    // Check allowance
124         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
125         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
126         totalSupply -= _value;                              // Update totalSupply
127         emit Burn(_from, _value);
128         return true;
129     }
130 }
131 
132 
133 contract LP is owned, TokenERC20 {
134 
135    
136     mapping (address => bool) public frozenAccount;
137 
138    
139     event FrozenFunds(address target, bool frozen);
140 
141    
142     function LP(
143         uint256 initialSupply,
144         string tokenName,
145         string tokenSymbol
146     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
147 
148     
149     function _transfer(address _from, address _to, uint _value) internal {
150         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead	
151         require (balanceOf[_from] >= _value);               // Check if the sender has enough
152         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
153         require(!frozenAccount[_from]);                     // Check if sender is frozen
154         require(!frozenAccount[_to]);                       // Check if recipient is frozen
155         balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);                    // Subtract from the sender
156         balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);                         // Add the same to the recipient
157         emit Transfer(_from, _to, _value);
158     }
159 
160    
161 
162     function freezeAccount(address target, bool freeze) onlyOwner public {
163         frozenAccount[target] = freeze;
164         emit FrozenFunds(target, freeze);
165     }
166 
167     
168    
169 }