1 pragma solidity ^0.4.16;
2 
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name = "Grinta Coin";
6     string public symbol = "GRIT";
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply = 1000000;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * Constrctor function
20      *
21      * Initializes contract with initial supply tokens to the creator of the contract
22      */
23     function TokenERC20() public {
24         totalSupply = totalSupply * 10 ** uint256(decimals);
25         balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
26     }
27 
28     /**
29      * Internal transfer, only can be called by this contract
30      */
31     function _transfer(address _from, address _to, uint _value) internal {
32         // Prevent transfer to 0x0 address. Use burn() instead
33         require(_to != 0x0);
34         // Check if the sender has enough
35         require(balanceOf[_from] >= _value);
36         // Check for overflows
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38         // Save this for an assertion in the future
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         // Subtract from the sender
41         balanceOf[_from] -= _value;
42         // Add the same to the recipient
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45         // Asserts are used to use static analysis to find bugs in your code. They should never fail
46         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
47     }
48 
49     /**
50      * Transfer tokens
51      *
52      * Send `_value` tokens to `_to` from your account
53      *
54      * @param _to The address of the recipient
55      * @param _value the amount to send
56      */
57     function transfer(address _to, uint256 _value) public {
58         _transfer(msg.sender, _to, _value);
59     }
60     
61     /**
62      * Transfer tokens from other address
63      *
64      * Send `_value` tokens to `_to` in behalf of `_from`
65      *
66      * @param _from The address of the sender
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76     
77     /**
78      * Set allowance for other address
79      *
80      * Allows `_spender` to spend no more than `_value` tokens in your behalf
81      *
82      * @param _spender The address authorized to spend
83      * @param _value the max amount they can spend
84      */
85     function approve(address _spender, uint256 _value) private
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90     
91     // Messages
92     event Message(address indexed from, string message);
93     
94     function writeMessage(string message)
95     public
96     returns (string)
97     {
98         emit Message(msg.sender, message);
99         return (message);
100     }
101 }