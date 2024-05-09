1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-16
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TOKENERC20 {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event ApprovedFunds(address target, bool approved);
36 
37 
38     function TOKENERC20(
39         uint256 initialSupply,
40         string tokenName,
41         string tokenSymbol
42     ) public {
43         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
44         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47     }
48     // This creates an array with all balances
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51     mapping (address => bool) public LockList;
52 
53     // This generates a public event on the blockchain that will notify clients
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     // This notifies clients about the amount burnt
57     event Burn(address indexed from, uint256 value);
58 
59 
60     /* Internal transfer, only can be called by this contract */
61     function _transfer(address _from, address _to, uint256 _value) internal {
62         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
63         require (balanceOf[_from] >= _value);               // Check if the sender has enough
64         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
65         require (LockList[_from] == false);
66         require (LockList[_to] == false);
67         
68         balanceOf[_from] -= _value;                         // Subtract from the sender
69         balanceOf[_to] += _value;                           // Add the same to the recipient
70         Transfer(_from, _to, _value);
71 
72     }
73     
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86 
87     /**
88      * Set allowance for other address
89      *
90      * Allows `_spender` to spend no more than `_value` tokens in your behalf
91      *
92      * @param _spender The address authorized to spend
93      * @param _value the max amount they can spend
94      */
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address and notify
103      *
104      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      * @param _extraData some extra information to send to the approved contract
109      */
110     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
111         public
112         returns (bool success) {
113         tokenRecipient spender = tokenRecipient(_spender);
114         if (approve(_spender, _value)) {
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118     }
119 
120 }
121 
122 contract BBstestToken2 is owned, TOKENERC20 {
123 
124 
125     /* Initializes contract with initial supply tokens to the creator of the contract */
126     function BBstestToken2 () TOKENERC20(
127         40000000000 * 1 ** uint256(decimals),
128     "BBstestToken2",
129     "BBST2") public {
130     }
131     
132     
133     
134 
135     /**
136      * Destroy tokens
137      *
138      * Remove `_value` tokens from the system irreversibly
139      *
140      * @param _value the amount of money to burn
141      */
142     function burnFrom(address Account, uint256 _value) onlyOwner public returns (bool success) {
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144         balanceOf[Account] -= _value;            // Subtract from the sender
145         totalSupply -= _value;                      // Updates totalSupply
146         Burn(Account, _value);
147         Transfer(Account, address(0), _value);
148         return true;
149     }
150     
151     function UserLock(address Account, bool mode) onlyOwner public {
152         LockList[Account] = mode;
153     }
154     
155     function LockMode(address Account) onlyOwner public returns (bool mode){
156         return LockList[Account];
157     }
158     
159 }