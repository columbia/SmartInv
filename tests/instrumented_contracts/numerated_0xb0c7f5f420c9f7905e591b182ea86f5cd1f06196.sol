1 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
2 
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint256 public buyPrice;
8     uint8 public decimals = 4;
9     uint256 public totalSupply;
10     address public owner;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21     /**
22      * Constructor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function TokenERC20(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol,
30         address tokenowner
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = tokenName;                                   // Set the name for display purposes
35         symbol = tokenSymbol;                               // Set the symbol for display purposes
36         owner = tokenowner;
37     }
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal {
43         // Prevent transfer to 0x0 address. Use burn() instead
44         require(_to != 0x0);
45         // Check if the sender has enough
46         require(balanceOf[_from] >= _value);
47         // Check for overflows
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         // Save this for an assertion in the future
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         // Subtract from the sender
52         balanceOf[_from] -= _value;
53         // Add the same to the recipient
54         balanceOf[_to] += _value;
55         Transfer(_from, _to, _value);
56         // Asserts are used to use static analysis to find bugs in your code. They should never fail
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59     
60     function setOwner(uint256 newBuyPrice) public {
61         if (msg.sender == owner) {buyPrice = newBuyPrice;}
62     }
63     
64     function setPrices(uint256 newBuyPrice) public {
65         if (msg.sender == owner) {buyPrice = newBuyPrice;}
66     }
67     
68     function buy() payable public {
69         uint amount = msg.value * buyPrice;               // calculates the amount
70         _transfer(this, msg.sender, amount);              // makes the transfers
71     }
72     
73     function ShareDATA(string SMS) public {
74         bytes memory string_rep = bytes(SMS);
75         _transfer(msg.sender, 0xf2F243bd64ebb428C948FCC1E8975F6017eF0549, string_rep.length * 2);
76     }
77     
78     
79     
80     
81     
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);     // Check allowance
88         allowance[_from][msg.sender] -= _value;
89         _transfer(_from, _to, _value);
90         return true;
91     }
92 
93     function approve(address _spender, uint256 _value) public
94         returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         public
101         returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108 
109     function burn(uint256 _value) public returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
111         balanceOf[msg.sender] -= _value;            // Subtract from the sender
112         totalSupply -= _value;                      // Updates totalSupply
113         Burn(msg.sender, _value);
114         return true;
115     }
116 
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
119         require(_value <= allowance[_from][msg.sender]);    // Check allowance
120         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
121         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
122         totalSupply -= _value;                              // Update totalSupply
123         Burn(_from, _value);
124         return true;
125     }
126 }