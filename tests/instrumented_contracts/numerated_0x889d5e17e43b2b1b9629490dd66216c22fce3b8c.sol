1 pragma solidity 0.4.23; 
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 contract CANDY {
4     // Public variables of the token
5     string public name; 
6     string public symbol; 
7     uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it 
8     uint256 public totalSupply; // This creates an array with all balances 
9     mapping (address => uint256) public balanceOf; 
10     mapping (address => mapping (address => uint256)) public allowance; // This generates a public event on the blockchain that will notify clients 
11     event Transfer(address indexed from, address indexed to, uint256 value); // This notifies clients about the amount burnt 
12     event Burn(address indexed from, uint256 value);
13     /**
14      * Constructor function
15      *
16      * Initializes contract with initial supply tokens to the creator of the contract
17      */ 
18      constructor (
19          uint256 initialSupply, 
20          string tokenName,
21          string tokenSymbol )public { 
22              totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount 
23              balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens 
24              name = tokenName; // Set the name for display purposes 
25              symbol = tokenSymbol; // Set the symbol for display purposes
26         }
27      /**
28      * Internal transfer, only can be called by this contract
29      */
30      function _transfer(address _from, address _to, uint _value) internal { 
31          // Prevent transfer to 0x0 address. Use burn() instead 
32          require(_to != 0x0); // Check if the sender has enough 
33          require(balanceOf[_from] >= _value); // Check for overflows 
34          require(balanceOf[_to] + _value >= balanceOf[_to]); // Save this for an assertion in the future 
35          uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Subtract from the sender 
36          balanceOf[_from] -= _value; // Add the same to the recipient 
37          balanceOf[_to] += _value;
38          emit Transfer(_from, _to, _value); // Asserts are used to use static analysis to find bugs in your code. They should never fail 
39          assert(balanceOf[_from] + balanceOf[_to] == previousBalances); } 
40     /**
41      * Transfer tokens
42      *
43      * Send `_value` tokens to `_to` from your account
44      *
45      * @param _to The address of the recipient
46      * @param _value the amount to send
47      */ 
48     function transfer(address _to, uint256 _value) public { 
49        _transfer(msg.sender, _to, _value); 
50     } 
51     /**
52      * Transfer tokens from other address
53      *
54      * Send `_value` tokens to `_to` on behalf of `_from`
55      *
56      * @param _from The address of the sender
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */ 
60      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
61      { 
62         require(_value <= allowance[_from][msg.sender]); // Check allowance 
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value); return true;
65      } 
66      /**
67      * Set allowance for other address
68      *
69      * Allows `_spender` to spend no more than `_value` tokens on your behalf
70      *
71      * @param _spender The address authorized to spend
72      * @param _value the max amount they can spend
73      */
74      function approve(address _spender, uint256 _value) public returns (bool success)
75      { 
76        allowance[msg.sender][_spender] = _value; return true;
77      }
78      /**
79      * Set allowance for other address and notify
80      *
81      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
82      *
83      * @param _spender The address authorized to spend
84      * @param _value the max amount they can spend
85      * @param _extraData some extra information to send to the approved contract
86      */ 
87      function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
88       {
89       tokenRecipient spender = tokenRecipient(_spender); 
90       if (approve(_spender, _value)) 
91         { spender.receiveApproval(msg.sender, _value, this, _extraData); 
92           return true;
93         }
94       } 
95      /**
96      * Destroy tokens
97      *
98      * Remove `_value` tokens from the system irreversibly
99      *
100      * @param _value the amount of money to burn
101      */ 
102      function burn(uint256 _value) public returns (bool success)   
103      { 
104          require(balanceOf[msg.sender] >= _value); // Check if the sender has enough  
105          balanceOf[msg.sender] -= _value; // Subtract from the sender 
106          totalSupply -= _value; // Updates totalSupply 
107          emit Burn(msg.sender, _value); return true; 
108          
109      } 
110      /**
111      * Destroy tokens from other account
112      *
113      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
114      *
115      * @param _from the address of the sender
116      * @param _value the amount of money to burn
117      */
118      function burnFrom(address _from, uint256 _value) public returns (bool success) 
119      { 
120          require(balanceOf[_from] >= _value); // Check if the targeted balance is enough 
121          require(_value <= allowance[_from][msg.sender]); // Check allowance 
122          balanceOf[_from] -= _value; // Subtract from the targeted balance 
123          allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance 
124          totalSupply -= _value; // Update totalSupply 
125          emit Burn(_from, _value); 
126          return true; 
127          
128      } 
129     
130 }