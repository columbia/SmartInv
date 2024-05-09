1 pragma solidity ^0.4.16;
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
14 }
15 
16 contract TokenERC20 {
17     // Public variables of the token
18     string public name;
19     string public symbol;
20     uint8 public decimals = 18;
21     // 18 decimals is the strongly suggested default, avoid changing it
22     uint256 public totalSupply;
23 
24     // This creates an array with all balances
25     mapping (address => uint256) public balanceOf;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     /**
31      * Constrctor function
32      *
33      * Initializes contract with initial supply tokens to the creator of the contract
34      */
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44     }
45 
46     /**
47      * Internal transfer, only can be called by this contract
48      */
49     function _transfer(address _from, address _to, uint _value) internal {
50         // Prevent transfer to 0x0 address. Use burn() instead
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balanceOf[_from] >= _value);
54         // Check for overflows
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         // Save this for an assertion in the future
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Subtract from the sender
59         balanceOf[_from] -= _value;
60         // Add the same to the recipient
61         balanceOf[_to] += _value;
62         Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
77     }
78 }
79 
80 /**
81  * Faith
82  */
83 contract TMCoin is owned, TokenERC20 {
84     function TMCoin() TokenERC20(21000000, "TM Token", "TM") public {}
85     function _transfer(address _from, address _to, uint _value) internal {
86         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
87         require (balanceOf[_from] >= _value);               // Check if the sender has enough
88         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
89         balanceOf[_from] -= _value;                         // Subtract from the sender
90         balanceOf[_to] += _value;                           // Add the same to the recipient
91         Transfer(_from, _to, _value);
92     }
93 }