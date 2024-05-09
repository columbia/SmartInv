1 pragma solidity ^0.4.16;
2 
3 
4 contract UKHToken {
5     // Public variables of the token
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14 
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     
19 
20     /**
21      * Constructor function
22      *
23      * Initializes contract with initial supply tokens to the creator of the contract
24      */
25     function UKHToken(
26         uint256 initialSupply,
27         string tokenName,
28         string tokenSymbol
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
32         name = tokenName;                                   // Set the name for display purposes
33         symbol = tokenSymbol;                               // Set the symbol for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         // Prevent transfer to 0x0 address. Use burn() instead
41         require(_to != 0x0);
42         // Check if the sender has enough
43         require(balanceOf[_from] >= _value);
44         // Check for overflows
45         require(balanceOf[_to] + _value >= balanceOf[_to]);
46         // Save this for an assertion in the future
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         // Subtract from the sender
49         balanceOf[_from] -= _value;
50         // Add the same to the recipient
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         // Asserts are used to use static analysis to find bugs in your code. They should never fail
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     /**
58      * Transfer tokens
59      *
60      * Send `_value` tokens to `_to` from your account
61      *
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         _transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70 
71 
72 }