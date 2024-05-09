1 pragma solidity ^0.4.18;
2 
3 contract CryptoCourt{
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     address public owner;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     
20 
21     /**
22      * Constructor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function CryptoCourt(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol
30     ) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33         name = tokenName;                                   // Set the name for display purposes
34         symbol = tokenSymbol;                               // Set the symbol for display purposes
35       
36         
37     }
38    
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         // Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         emit Transfer(_from, _to, _value);
57         // Asserts are used to use static analysis to find bugs in your code. They should never fail
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     /**
62      * Transfer tokens
63      *
64      * Send `_value` tokens to `_to` from your account
65      *
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74      * Transfer tokens from other address
75      *
76      * Send `_value` tokens to `_to` on behalf of `_from`
77      *
78      * @param _from The address of the sender
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89    
90 
91     }