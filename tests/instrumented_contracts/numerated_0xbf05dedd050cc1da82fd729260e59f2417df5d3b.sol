1 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
2 
3 contract GlobalIdolCoinToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 8;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event Burn(address indexed from, uint256 value);
15 
16 
17     function TokenERC20(
18         uint256 initialSupply,
19         string tokenName,
20         string tokenSymbol
21     ) public {
22         totalSupply = initialSupply * 1 * 10 ** (9 + uint256(decimals));  // Update total supply with the decimal amount
23         initialSupply = totalSupply;
24         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
25         name = "GlobalIdolCoinToken";                                   // Set the name for display purposes
26         symbol = "GICT";                               // Set the symbol for display purposes
27         tokenName = name;
28         tokenSymbol = symbol;
29         
30         
31     }
32 
33 
34     function _transfer(address _from, address _to, uint _value) internal {
35         // Prevent transfer to 0x0 address. Use burn() instead
36         require(_to != 0x0);
37         // Check if the sender has enough
38         require(balanceOf[_from] >= _value);
39         // Check for overflows
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41         // Save this for an assertion in the future
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48         // Asserts are used to use static analysis to find bugs in your code. They should never fail
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52 
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 
80 
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
83         balanceOf[msg.sender] -= _value;            // Subtract from the sender
84         totalSupply -= _value;                      // Updates totalSupply
85         Burn(msg.sender, _value);
86         return true;
87     }
88 
89     function burnFrom(address _from, uint256 _value) public returns (bool success) {
90         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
91         require(_value <= allowance[_from][msg.sender]);    // Check allowance
92         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
93         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
94         totalSupply -= _value;                              // Update totalSupply
95         Burn(_from, _value);
96         return true;
97     }
98 }