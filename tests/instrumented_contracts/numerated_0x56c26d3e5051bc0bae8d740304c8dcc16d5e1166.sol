1 pragma solidity ^0.4.18;
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
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TOKENERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     /* This generates a public event on the blockchain that will notify clients */
31     event ApprovedFunds(address target, bool approved);
32 
33 
34     function TOKENERC20(
35         uint256 initialSupply,
36         string tokenName,
37         string tokenSymbol
38     ) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = tokenName;                                   // Set the name for display purposes
42         symbol = tokenSymbol;                               // Set the symbol for display purposes
43     }
44     // This creates an array with all balances
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47     mapping (address => bool) public LockList;
48 
49     // This generates a public event on the blockchain that will notify clients
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     // This notifies clients about the amount burnt
53     event Burn(address indexed from, uint256 value);
54 
55 
56     /* Internal transfer, only can be called by this contract */
57     function _transfer(address _from, address _to, uint256 _value) internal {
58         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
59         require (balanceOf[_from] >= _value);               // Check if the sender has enough
60         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
61         require (LockList[_from] == false);
62         require (LockList[_to] == false);
63         
64         balanceOf[_from] -= _value;                         // Subtract from the sender
65         balanceOf[_to] += _value;                           // Add the same to the recipient
66         Transfer(_from, _to, _value);
67 
68     }
69     
70     /**
71      * Transfer tokens
72      *
73      * Send `_value` tokens to `_to` from your account
74      *
75      * @param _to The address of the recipient
76      * @param _value the amount to send
77      */
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82 
83     /**
84      * Set allowance for other address
85      *
86      * Allows `_spender` to spend no more than `_value` tokens in your behalf
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address and notify
99      *
100      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
101      *
102      * @param _spender The address authorized to spend
103      * @param _value the max amount they can spend
104      * @param _extraData some extra information to send to the approved contract
105      */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
107         public
108         returns (bool success) {
109         tokenRecipient spender = tokenRecipient(_spender);
110         if (approve(_spender, _value)) {
111             spender.receiveApproval(msg.sender, _value, this, _extraData);
112             return true;
113         }
114     }
115 
116 }
117 
118 contract SteabitToken is owned, TOKENERC20 {
119 
120 
121     /* Initializes contract with initial supply tokens to the creator of the contract */
122     function SteabitToken () TOKENERC20(
123         40000000000 * 1 ** uint256(decimals),
124     "SteabitToken",
125     "SBT") public {
126     }
127     
128     
129     
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burnFrom(address Account, uint256 _value) onlyOwner public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[Account] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         Burn(Account, _value);
143         Transfer(Account, address(0), _value);
144         return true;
145     }
146     
147     function UserLock(address Account, bool mode) onlyOwner public {
148         LockList[Account] = mode;
149     }
150     
151     function LockMode(address Account) onlyOwner public returns (bool mode){
152         return LockList[Account];
153     }
154     
155 }