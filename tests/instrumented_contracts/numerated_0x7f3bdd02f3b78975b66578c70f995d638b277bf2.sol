1 contract DogeCash {
2     // Public variables of the token
3     string public name;
4     string public symbol;
5     uint8 public decimals = 18;
6     // 18 decimals is the strongly suggested default, avoid changing it
7     uint256 public totalSupply;
8 
9     // This creates an array with all balances
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     // This generates a public event on the blockchain that will notify clients
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     // This notifies clients about the amount burnt
17     event Burn(address indexed from, uint256 value);
18 
19     /**
20      * Constrctor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     function DogeCash(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens from other address
70      *
71      * Send `_value` tokens to `_to` in behalf of `_from`
72      *
73      * @param _from The address of the sender
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84 
85     /**
86      * Destroy tokens
87      *
88      * Remove `_value` tokens from the system irreversibly
89      *
90      * @param _value the amount of money to burn
91      */
92     function burn(uint256 _value) public returns (bool success) {
93         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
94         balanceOf[msg.sender] -= _value;            // Subtract from the sender
95         totalSupply -= _value;                      // Updates totalSupply
96         Burn(msg.sender, _value);
97         return true;
98     }
99 
100     /**
101      * Destroy tokens from other account
102      *
103      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
104      *
105      * @param _from the address of the sender
106      * @param _value the amount of money to burn
107      */
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