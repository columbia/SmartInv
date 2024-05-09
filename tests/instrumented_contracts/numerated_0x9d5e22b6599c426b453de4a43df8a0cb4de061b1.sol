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
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract YAKcoinERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      */
43     function YAKcoinERC20(
44     ) public {
45         totalSupply = 60000000000 * 10 ** uint256(decimals);  
46         balanceOf[msg.sender] = totalSupply;               
47         name = "YAK Coin";                                  
48         symbol = "YAK";                             
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     /**
73      * Transfer tokens
74      *
75      * Send `_value` tokens to `_to` from your account
76      *
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /**
85      * Transfer tokens from other address
86      *
87      * Send `_value` tokens to `_to` on behalf of `_from`
88      *
89      * @param _from The address of the sender
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_value <= allowance[_from][msg.sender]);     // Check allowance
95         allowance[_from][msg.sender] -= _value;
96         _transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address
102      *
103      * Allows `_spender` to spend no more than `_value` tokens on your behalf
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      */
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address and notify
116      *
117      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      * @param _extraData some extra information to send to the approved contract
122      */
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
142         balanceOf[msg.sender] -= _value;            // Subtract from the sender
143         totalSupply -= _value;                      // Updates totalSupply
144         Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
158         require(_value <= allowance[_from][msg.sender]);    // Check allowance
159         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
160         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
161         totalSupply -= _value;                              // Update totalSupply
162         Burn(_from, _value);
163         return true;
164     }
165 }