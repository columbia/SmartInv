1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract holicErc20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 8;
9     // 18 decimals is the strongly suggested default
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Constructor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function holicErc20(
28         uint256 initialSupply,
29         string tokenName,
30         string tokenSymbol
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = "HOLIC";                                   // Set the name for display purposes
35         symbol = "HOLIC";                               // Set the symbol for display purposes
36     }
37 
38     /**
39      * Internal transfer, only can be called by this contract
40      */
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
59     /**
60      * Transfer tokens
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * Transfer tokens from other address
68      */
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     /**
77      * Set allowance for other address
78      *
79      * Allows `_spender` to spend no more than `_value` tokens on your behalf
80      *
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address and notify
92      *
93      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      * @param _extraData some extra information to send to the approved contract
98      */
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
109     /**
110      * Destroy tokens
111      *
112      * Remove `_value` tokens from the system irreversibly
113      *
114      * @param _value the amount of money to burn
115      */
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] -= _value;            // Subtract from the sender
119         totalSupply -= _value;                      // Updates totalSupply
120         Burn(msg.sender, _value);
121         return true;
122     }
123 }