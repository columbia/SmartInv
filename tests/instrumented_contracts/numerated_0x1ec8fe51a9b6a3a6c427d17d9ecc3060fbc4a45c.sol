1 pragma solidity ^0.4.16;
2  
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4  
5 contract TokenERC20 {
6     // Public variables of the token
7     string public constant name = "smartillions.io A ETH";
8     string public constant symbol = "S-A-PAT";
9     uint8 public constant decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12     uint256 public initialSupply = 50000000;
13  
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17  
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * Constructor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     function TokenERC20() 
27     public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
29         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
30                                    // Set the symbol for display purposes
31     }
32     
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address.
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53  
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65  
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` in behalf of `_from`
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81    
82 }