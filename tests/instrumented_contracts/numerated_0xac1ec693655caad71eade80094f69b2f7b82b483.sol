1 pragma solidity ^0.4.16;
2 
3 
4 contract EBLCreation {
5 
6     //private variable
7     address creater;
8 
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     // mapping (address => uint256) public futureBalanceOf;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28 
29     function EBLCreation(uint256 initialSupply,string tokenName,string tokenSymbol) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
31         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
32         name = tokenName;                                       // Set the name for display purposes
33         symbol = tokenSymbol;                                   // Set the symbol for display purposes
34         creater = msg.sender;                             
35     }
36 
37     /**
38      * Internal transfer, only can be called by this contract
39      */
40 
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
67 
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72 
73     /**
74      * adds token to initial supply
75      *
76      * @param _value the amount of money to be add
77      */
78 
79     function addInInitialSupply(uint256 _value) public onlyCreater returns (bool success) {
80         totalSupply += _value;
81         balanceOf[msg.sender] += _value;
82         return true;
83     }
84 
85     /**
86      *  removes token from initial supply
87      *
88      * @param _value the amount of money to be remove
89      */
90 
91     function removeFromInitialSupply(uint256 _value) public onlyCreater returns (bool success) {
92         totalSupply -= _value;
93         balanceOf[msg.sender] -= _value;
94         return true;
95     }
96 
97     function tokenBalance() public constant returns (uint256) {
98         return (balanceOf[msg.sender]);
99     }
100 
101 
102     modifier onlyCreater() {
103         require(msg.sender == creater);
104         _;
105     }
106 }