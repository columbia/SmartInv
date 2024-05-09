1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10     return 0;
11   }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner public {
67     require(newOwner != address(0));
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 }
72 
73 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
74 
75 contract CastleToken {
76     // Public variables of the token
77     string public name;
78     string public symbol;
79     uint8 public decimals = 18;
80     // 18 decimals is the strongly suggested default, avoid changing it
81     uint256 public totalSupply;
82 
83     // This creates an array with all balances
84     mapping (address => uint256) public balanceOf;
85     mapping (address => mapping (address => uint256)) public allowance;
86 
87     // This generates a public event on the blockchain that will notify clients
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     // This notifies clients about the amount burnt
91     event Burn(address indexed from, uint256 value);
92 
93     /**
94      * Constrctor function
95      *
96      * Initializes contract with initial supply tokens to the creator of the contract
97      */
98     function CastleToken(
99         uint256 initialSupply,
100         string tokenName,
101         string tokenSymbol
102     ) public {
103         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
104         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
105         name = tokenName;                                   // Set the name for display purposes
106         symbol = tokenSymbol;                               // Set the symbol for display purposes
107     }
108 
109     /**
110      * Internal transfer, only can be called by this contract
111      */
112     function _transfer(address _from, address _to, uint _value) internal {
113         // Prevent transfer to 0x0 address. Use burn() instead
114         require(_to != 0x0);
115         // Check if the sender has enough
116         require(balanceOf[_from] >= _value);
117         // Check for overflows
118         require(balanceOf[_to] + _value > balanceOf[_to]);
119         // Save this for an assertion in the future
120         uint previousBalances = balanceOf[_from] + balanceOf[_to];
121         // Subtract from the sender
122         balanceOf[_from] -= _value;
123         // Add the same to the recipient
124         balanceOf[_to] += _value;
125         Transfer(_from, _to, _value);
126         // Asserts are used to use static analysis to find bugs in your code. They should never fail
127         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
128     }
129 
130     /**
131      * Transfer tokens
132      *
133      * Send `_value` tokens to `_to` from your account
134      *
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transfer(address _to, uint256 _value) public {
139         _transfer(msg.sender, _to, _value);
140     }
141 
142     /**
143      * Transfer tokens from other address
144      *
145      * Send `_value` tokens to `_to` in behalf of `_from`
146      *
147      * @param _from The address of the sender
148      * @param _to The address of the recipient
149      * @param _value the amount to send
150      */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         require(_value <= allowance[_from][msg.sender]);     // Check allowance
153         allowance[_from][msg.sender] -= _value;
154         _transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      */
166     function approve(address _spender, uint256 _value) public
167         returns (bool success) {
168         allowance[msg.sender][_spender] = _value;
169         return true;
170     }
171 
172     /**
173      * Set allowance for other address and notify
174      *
175      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
176      *
177      * @param _spender The address authorized to spend
178      * @param _value the max amount they can spend
179      * @param _extraData some extra information to send to the approved contract
180      */
181     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
182         public
183         returns (bool success) {
184         tokenRecipient spender = tokenRecipient(_spender);
185         if (approve(_spender, _value)) {
186             spender.receiveApproval(msg.sender, _value, this, _extraData);
187             return true;
188         }
189     }
190 
191     /**
192      * Destroy tokens
193      *
194      * Remove `_value` tokens from the system irreversibly
195      *
196      * @param _value the amount of money to burn
197      */
198     function burn(uint256 _value) public returns (bool success) {
199         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
200         balanceOf[msg.sender] -= _value;            // Subtract from the sender
201         totalSupply -= _value;                      // Updates totalSupply
202         Burn(msg.sender, _value);
203         return true;
204     }
205 
206     /**
207      * Destroy tokens from other account
208      *
209      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
210      *
211      * @param _from the address of the sender
212      * @param _value the amount of money to burn
213      */
214     function burnFrom(address _from, uint256 _value) public returns (bool success) {
215         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
216         require(_value <= allowance[_from][msg.sender]);    // Check allowance
217         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
218         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
219         totalSupply -= _value;                              // Update totalSupply
220         Burn(_from, _value);
221         return true;
222     }
223 }