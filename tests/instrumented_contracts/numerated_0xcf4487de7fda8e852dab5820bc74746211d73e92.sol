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
14 
15 }
16 
17 
18 contract TokenERC20 {
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25 
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /**
33      * Constrctor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function TokenERC20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
43         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46     }
47 
48     /**
49      * Internal transfer, only can be called by this contract
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         // Save this for an assertion in the future
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         // Subtract from the sender
61         balanceOf[_from] -= _value;
62         // Add the same to the recipient
63         balanceOf[_to] += _value;
64         Transfer(_from, _to, _value);
65         // Asserts are used to use static analysis to find bugs in your code. They should never fail
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 
69     /**
70      * Transfer tokens
71      *
72      * Send `_value` tokens to `_to` from your account
73      *
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81 
82 }
83 
84 
85 contract MVPToken is owned, TokenERC20 {
86 
87     /* Initializes contract with initial supply tokens to the creator of the contract */
88     function MVPToken(
89     ) TokenERC20(10000000000, "Media Value Pact Token", "MVPT") public {}
90 
91     /* Internal transfer, only can be called by this contract */
92     function _transfer(address _from, address _to, uint _value) internal {
93         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
94         require (balanceOf[_from] >= _value);               // Check if the sender has enough
95         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
96         balanceOf[_from] -= _value;                         // Subtract from the sender
97         balanceOf[_to] += _value;                           // Add the same to the recipient
98         Transfer(_from, _to, _value);
99     }
100 
101 }