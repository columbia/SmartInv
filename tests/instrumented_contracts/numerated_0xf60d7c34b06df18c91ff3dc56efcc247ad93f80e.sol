1 pragma solidity ^0.4.16;
2 
3 contract XCareToken {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     mapping (address => string) public  keys;
15 
16     address[] public registerAddress;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Register (address user, string key);
21 
22     /**
23      * Constrctor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function XCareToken(
28         uint256 initialSupply,
29         string tokenName,
30         string tokenSymbol
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = tokenName;                                   // Set the name for display purposes
35         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
61      *
62      * Send `_value` tokens to `_to` from your account
63      *
64      * @param _to The address of the recipient
65      * @param _value the amount to send
66      */
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71     /**
72      * Transfer tokens from other address
73      *
74      * Send `_value` tokens to `_to` in behalf of `_from`
75      *
76      * @param _from The address of the sender
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
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
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99 
100     function register(string key) public {
101         require(bytes(key).length <= 64);
102 
103         keys[msg.sender] = key;
104         registerAddress.push(msg.sender);
105 
106         Register(msg.sender, key);
107     }
108 
109 }