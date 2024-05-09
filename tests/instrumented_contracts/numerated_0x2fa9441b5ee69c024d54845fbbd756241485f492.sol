1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7     if (_a == 0) {
8       return 0;
9     }
10     uint256 c = _a * _b;
11     require(c / _a == _b);
12     return c;
13   }
14 
15   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16     require(_b > 0); 
17     uint256 c = _a / _b;
18     return c;
19   }
20 
21   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     require(_b <= _a);
23     uint256 c = _a - _b;
24     return c;
25   }
26 
27   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     uint256 c = _a + _b;
29     require(c >= _a);
30     return c;
31   }
32 
33   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b != 0);
35     return a % b;
36   }
37 }
38 
39 
40 contract owned {
41     address public owner;
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         owner = newOwner;
54     }
55 }
56 
57 
58 contract TokenERC20 {
59     // Public variables of the token
60     string public name;
61     string public symbol;
62     uint8 public decimals = 8;
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     // This notifies clients about the amount burnt
73     event Burn(address indexed from, uint256 value);
74 
75 
76     constructor(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  
82         balanceOf[msg.sender] = totalSupply;                
83         name = tokenName;                                  
84         symbol = tokenSymbol;                              
85     }
86 
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != 0x0);
90         // Check if the sender has enough
91         require(balanceOf[_from] >= _value);
92         // Check for overflows
93         require(balanceOf[_to] + _value > balanceOf[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         // Subtract from the sender
97         balanceOf[_from] = SafeMath.sub(balanceOf[_from],_value);
98         // Add the same to the recipient
99         balanceOf[_to] = SafeMath.add(balanceOf[_to],_value);
100         emit Transfer(_from, _to, _value);
101         // Asserts are used to use static analysis to find bugs in your code. They should never fail
102         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
103     }
104 
105     function transfer(address _to, uint256 _value) public {
106         _transfer(msg.sender, _to, _value);
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
110         require(_value <= allowance[_from][msg.sender]);     // Check allowance
111         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender],_value);
112         _transfer(_from, _to, _value);
113         return true;
114     }
115     
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
135         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender],_value);            // Subtract from the sender
136         totalSupply = SafeMath.sub(totalSupply,_value);                                // Updates totalSupply
137         emit Burn(msg.sender, _value);
138         return true;
139     }
140 
141 
142     function burnFrom(address _from, uint256 _value) public returns (bool success) {
143         require(balanceOf[_from] >= _value);                                                // Check if the targeted balance is enough
144         require(_value <= allowance[_from][msg.sender]);                                    // Check allowance
145         balanceOf[_from] = SafeMath.sub(balanceOf[_from],_value);                           // Subtract from the targeted balance
146         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender],_value);   // Subtract from the sender's allowance
147         totalSupply = SafeMath.sub(totalSupply,_value);                                     // Update totalSupply
148         emit Burn(_from, _value);
149         return true;
150     }
151 }
152 
153 
154 contract AL is owned, TokenERC20 {
155 
156     mapping (address => bool) public frozenAccount;
157 
158     /* This generates a public event on the blockchain that will notify clients */
159     event FrozenFunds(address target, bool frozen);
160 
161     /* Initializes contract with initial supply tokens to the creator of the contract */
162     constructor(
163         uint256 initialSupply,
164         string tokenName,
165         string tokenSymbol
166     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
167 
168     /* Internal transfer, only can be called by this contract */
169     function _transfer(address _from, address _to, uint _value) internal {
170         require (_to != 0x0);                                              // Prevent transfer to 0x0 address. Use burn() instead
171         require (balanceOf[_from] >= _value);                              // Check if the sender has enough
172         require (balanceOf[_to] + _value > balanceOf[_to]);                // Check for overflows
173         require(!frozenAccount[_from]);                                    // Check if sender is frozen
174         require(!frozenAccount[_to]);                                      // Check if recipient is frozen
175         balanceOf[_from] = SafeMath.sub(balanceOf[_from],_value);          // Subtract from the sender
176         balanceOf[_to] = SafeMath.add(balanceOf[_to],_value);              // Add the same to the recipient
177         emit Transfer(_from, _to, _value);
178     }
179 
180     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
181         balanceOf[target] = SafeMath.add(balanceOf[target],mintedAmount);
182         totalSupply = SafeMath.add(totalSupply,mintedAmount); 
183         emit Transfer(0, this, mintedAmount);
184         emit Transfer(this, target, mintedAmount);
185     }
186 
187     function freezeAccount(address target, bool freeze) onlyOwner public {
188         frozenAccount[target] = freeze;
189         emit FrozenFunds(target, freeze);
190     }
191 
192 }