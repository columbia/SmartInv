1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 
21 contract GUSDERC20 {
22     // Public variables of the token
23     string public name = "GUSD";
24     string public symbol = "GUSD" ;
25     uint8 public decimals = 0;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply = 50000000000;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31    
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor(
45     ) public {
46         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
47     }
48 
49     /**
50      * Internal transfer, only can be called by this contract
51      */
52     function _transfer(address _from, address _to, uint _value) internal {
53         // Prevent transfer to 0x0 address. Use burn() instead
54         require(_to != address(0x0));
55         // Check if the sender has enough
56         require(balanceOf[_from] >= _value);
57         // Check for overflows
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59         // Save this for an assertion in the future
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         // Subtract from the sender
62         balanceOf[_from] -= _value;
63         // Add the same to the recipient
64         balanceOf[_to] += _value;
65         emit Transfer(_from, _to, _value);
66         // Asserts are used to use static analysis to find bugs in your code. They should never fail
67         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     /**
84      * Destroy tokens
85      *
86      * Remove `_value` tokens from the system irreversibly
87      *
88      * @param _value the amount of money to burn
89      */
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
92         balanceOf[msg.sender] -= _value;            // Subtract from the sender
93         totalSupply -= _value;                      // Updates totalSupply
94         emit Burn(msg.sender, _value);
95         return true;
96     }
97 
98   
99 }
100 
101 /******************************************/
102 /*       ADVANCED TOKEN STARTS HERE       */
103 /******************************************/
104 
105 contract GUSDToken is owned, GUSDERC20 {
106 
107   
108     mapping (address => bool) public frozenAccount;
109 
110     /* This generates a public event on the blockchain that will notify clients */
111     event FrozenFunds(address target, bool frozen);
112 
113     /* Initializes contract with initial supply tokens to the creator of the contract */
114     constructor(
115      ) public {}
116 
117     /* Internal transfer, only can be called by this contract */
118     function _transfer(address _from, address _to, uint _value) internal {
119         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
120         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
121         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
122         require(!frozenAccount[_from]);                         // Check if sender is frozen
123         require(!frozenAccount[_to]);                           // Check if recipient is frozen
124         balanceOf[_from] -= _value;                             // Subtract from the sender
125         balanceOf[_to] += _value;                               // Add the same to the recipient
126         emit Transfer(_from, _to, _value);
127     }
128 
129     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
130     /// @param target Address to be frozen 
131     /// @param freeze either to freeze it or not
132     function freezeAccount(address target, bool freeze) onlyOwner public {
133         frozenAccount[target] = freeze;
134         emit FrozenFunds(target, freeze);
135     }
136 
137 }