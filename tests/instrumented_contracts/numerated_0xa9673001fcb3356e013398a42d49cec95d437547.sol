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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // transfer event
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // burn event
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constructor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function TokenERC20(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75 
76     function transfer(address _to, uint256 _value) public {
77         _transfer(msg.sender, _to, _value);
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(_value <= allowance[_from][msg.sender]);     // Check allowance
82         allowance[_from][msg.sender] -= _value;
83         _transfer(_from, _to, _value);
84         return true;
85     }
86 
87     /**
88      * Set allowance for other address
89      *
90      * Allows `_spender` to spend no more than `_value` tokens in your behalf
91      *
92      * @param _spender The address authorized to spend
93      * @param _value the max amount they can spend
94      */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address and notify
103      *
104      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      * @param _extraData some extra information to send to the approved contract
109      */
110     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
111         public
112         returns (bool success) {
113         tokenRecipient spender = tokenRecipient(_spender);
114         if (approve(_spender, _value)) {
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118     }
119 
120     function burn(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         Burn(msg.sender, _value);
125         return true;
126     }
127 
128 
129 }
130 
131 contract AdvancedShit is owned, TokenERC20 {
132 
133     uint256 public sellPrice;
134     uint256 public buyPrice;
135 
136 
137     /* Initializes contract with initial supply tokens to the creator of the contract */
138     function AdvancedShit (
139         uint256 initialSupply,
140         string tokenName,
141         string tokenSymbol
142     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
143 
144     /* Internal transfer, only can be called by this contract */
145     function _transfer(address _from, address _to, uint _value) internal {
146         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
147         require (balanceOf[_from] >= _value);               // Check if the sender has enough
148         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
149         balanceOf[_from] -= _value;                         // Subtract from the sender
150         balanceOf[_to] += _value;                           // Add the same to the recipient
151         Transfer(_from, _to, _value);
152     }
153 
154     /// @notice Create `mintedAmount` tokens and send it to `target`
155     /// @param target Address to receive the tokens
156     /// @param mintedAmount the amount of tokens it will receive
157     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
158         balanceOf[target] += mintedAmount;
159         totalSupply += mintedAmount;
160         Transfer(0, this, mintedAmount);
161         Transfer(this, target, mintedAmount);
162     }
163 
164 }