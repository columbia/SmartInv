1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12     
13     /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17     constructor() public {
18         owner = msg.sender;
19     }
20     
21     /**
22    * @dev Throws if called by any account other than the owner.
23    */
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28     
29     /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 }
39 
40 
41 contract BB is Ownable {
42     // Public variables of the token
43     string public name;
44     string public symbol;
45     uint8 public decimals = 18;
46     // 18 decimals is the strongly suggested default, avoid changing it
47     uint256 public totalSupply;
48 
49 
50     // This creates an array with all balances
51     mapping (address => uint256) public balanceOf;
52     // This creates an array with all allowance
53     mapping (address => mapping (address => uint256)) public allowance;
54     // This creates an array with all freeze
55     mapping (address => bool) public frozenAccount;
56     
57 
58     // This generates a public event on the blockchain that will notify clients
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     // This generates a public event on the blockchain that will notify clients
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62     // This notifies clients about the amount burnt
63     event Burn(address indexed from, uint256 value);
64     // This notifies clients about the address was frozen
65     event FrozenFunds(address target, bool frozen);
66 
67     /**
68      * Constructor function
69      *
70      * Initializes contract with initial supply tokens to the creator of the contract
71      */
72     constructor (uint256 initialSupply, string tokenName, string tokenSymbol, address centralMinter) public {
73         if(centralMinter != 0) owner = centralMinter;
74         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78     }
79     
80     
81     /**
82      * Function that enables the owner to create new tokens
83      */
84     function mintToken(address target, uint256 mintedAmount) external onlyOwner {
85         balanceOf[target] += mintedAmount;
86         totalSupply += mintedAmount;
87         emit Transfer(0, owner, mintedAmount);
88         emit Transfer(owner, target, mintedAmount);
89     }
90     
91     
92     /**
93      * Function that enables the owner to freeze or unfreeze assets
94      */
95     function freezeAccount(address target, bool freeze) external onlyOwner {
96         frozenAccount[target] = freeze;
97         emit FrozenFunds(target, freeze);
98     }
99     
100 
101 
102     /**
103      * Internal transfer, only can be called by this contract
104      */
105     function _transfer(address _from, address _to, uint _value) internal {
106         // Prevent transfer to 0x0 address. Use burn() instead
107         require(_to != 0x0);
108         // Check if the sender has enough
109         require(balanceOf[_from] >= _value);
110         // Check for overflows
111         require(balanceOf[_to] + _value >= balanceOf[_to]);
112         //Check if sender is frozen
113         require(!frozenAccount[_from]);
114         //Check if recipient is frozen
115         require(!frozenAccount[_to]);
116         // Save this for an assertion in the future
117         uint previousBalances = balanceOf[_from] + balanceOf[_to];
118         // Subtract from the sender
119         balanceOf[_from] -= _value;
120         // Add the same to the recipient
121         balanceOf[_to] += _value;
122         emit Transfer(_from, _to, _value);
123         // Asserts are used to use static analysis to find bugs in your code. They should never fail
124         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
125     }
126 
127     /**
128      * Transfer tokens
129      *
130      * Send `_value` tokens to `_to` from your account
131      *
132      * @param _to The address of the recipient
133      * @param _value the amount to send
134      */
135     function transfer(address _to, uint256 _value) public returns (bool success) {
136         _transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     /**
141      * Transfer tokens from other address
142      *
143      * Send `_value` tokens to `_to` on behalf of `_from`
144      *
145      * @param _from The address of the sender
146      * @param _to The address of the recipient
147      * @param _value the amount to send
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
150         require(_value <= allowance[_from][msg.sender]);     // Check allowance
151         allowance[_from][msg.sender] -= _value;
152         _transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /**
157      * Set allowance for other address
158      *
159      * Allows `_spender` to spend no more than `_value` tokens on your behalf
160      *
161      * @param _spender The address authorized to spend
162      * @param _value the max amount they can spend
163      */
164     function approve(address _spender, uint256 _value) public
165         returns (bool success) {
166         allowance[msg.sender][_spender] = _value;
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172      * Set allowance for other address and notify
173      *
174      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
175      *
176      * @param _spender The address authorized to spend
177      * @param _value the max amount they can spend
178      * @param _extraData some extra information to send to the approved contract
179      */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
181         public
182         returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     /**
191      * Destroy tokens
192      *
193      * Remove `_value` tokens from the system irreversibly
194      *
195      * @param _value the amount of money to burn
196      */
197     function burn(uint256 _value) public returns (bool success) {
198         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
199         balanceOf[msg.sender] -= _value;            // Subtract from the sender
200         totalSupply -= _value;                      // Updates totalSupply
201         emit Burn(msg.sender, _value);
202         return true;
203     }
204 
205     /**
206      * Destroy tokens from other account
207      *
208      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
209      *
210      * @param _from the address of the sender
211      * @param _value the amount of money to burn
212      */
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
215         require(_value <= allowance[_from][msg.sender]);    // Check allowance
216         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
217         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
218         totalSupply -= _value;                              // Update totalSupply
219         emit Burn(_from, _value);
220         return true;
221     }
222 }