1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract TokenERC20 is Ownable {
45     // Public variables of the token
46     string public name;
47     string public symbol;
48     uint8 public decimals = 18;
49     // 18 decimals is the strongly suggested default, avoid changing it
50     uint256 public totalSupply;
51 
52     // This creates an array with all balances
53     mapping (address => uint256) public balanceOf;
54     mapping (address => mapping (address => uint256)) public allowance;
55 
56     // This generates a public event on the blockchain that will notify clients
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     // This notifies clients about the amount burnt
60     event Burn(address indexed from, uint256 value);
61 
62     /**
63      * Constrctor function
64      *
65      * Initializes contract with initial supply tokens to the creator of the contract
66      */
67     function TokenERC20(
68         uint256 initialSupply,
69         string tokenName,
70         string tokenSymbol,
71 	address centralMinter
72     ) public {
73 	if(centralMinter != 0) owner = centralMinter;
74         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint256 _value) internal {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Save this for an assertion in the future
91         uint previousBalances = balanceOf[_from] + balanceOf[_to];
92         // Subtract from the sender
93         balanceOf[_from] -= _value;
94         // Add the same to the recipient
95         balanceOf[_to] += _value;
96         Transfer(_from, _to, _value);
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
99     }
100 
101     /**
102      * Transfer tokens
103      *
104      * Send `_value` tokens to `_to` from your account
105      *
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transfer(address _to, uint256 _value) public {
110         _transfer(msg.sender, _to, _value);
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` on behalf of `_from`
117      *
118      * @param _from The address of the sender
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_value <= allowance[_from][msg.sender]);     // Check allowance
124         allowance[_from][msg.sender] -= _value;
125         _transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153         public
154         returns (bool success) {
155         tokenRecipient spender = tokenRecipient(_spender);
156         if (approve(_spender, _value)) {
157             spender.receiveApproval(msg.sender, _value, this, _extraData);
158             return true;
159         }
160     }
161 
162     /**
163      * Destroy tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool success) {
170         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171         balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         Burn(msg.sender, _value);
174         return true;
175     }
176 
177     /**
178      * Destroy tokens from other account
179      *
180      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
181      *
182      * @param _from the address of the sender
183      * @param _value the amount of money to burn
184      */
185     function burnFrom(address _from, uint256 _value) public returns (bool success) {
186         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
187         require(_value <= allowance[_from][msg.sender]);    // Check allowance
188         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
189         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
190         totalSupply -= _value;                              // Update totalSupply
191         Burn(_from, _value);
192         return true;
193     }
194 
195     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
196         balanceOf[target] += mintedAmount;
197         totalSupply += mintedAmount;
198         Transfer(0, owner, mintedAmount);
199         Transfer(owner, target, mintedAmount);
200     }
201 }