1 pragma solidity ^0.4.24;
2 
3 /******************************************/
4 /*       Netkiller Mini TOKEN             */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-05-31 Fixed transfer bool */
9 /******************************************/
10 
11 contract NetkillerMiniToken {
12     address public owner;
13     // Public variables of the token
14     string public name;
15     string public symbol;
16     uint public decimals;
17     // 18 decimals is the strongly suggested default, avoid changing it
18     uint256 public totalSupply;
19 
20     // This creates an array with all balances
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * Constrctor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         uint256 initialSupply,
35         string tokenName,
36         string tokenSymbol,
37         uint decimalUnits
38     ) public {
39         owner = msg.sender;
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol; 
42         decimals = decimalUnits;
43         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
44         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial token
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57  
58     /* Internal transfer, only can be called by this contract */
59     function _transfer(address _from, address _to, uint _value) internal {
60         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
61         require (balanceOf[_from] >= _value);               // Check if the sender has enough
62         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
63         balanceOf[_from] -= _value;                         // Subtract from the sender
64         balanceOf[_to] += _value;                           // Add the same to the recipient
65         emit Transfer(_from, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public returns (bool success){
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     /**
82      * Transfer tokens from other address
83      *
84      * Send `_value` tokens to `_to` in behalf of `_from`
85      *
86      * @param _from The address of the sender
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);     // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address
99      *
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      */
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 }