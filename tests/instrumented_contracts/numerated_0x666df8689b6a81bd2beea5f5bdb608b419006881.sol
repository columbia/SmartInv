1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b > 0);
28     uint256 c = a / b;
29     assert(a == b * c + a % b);
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract owned {
52     address public owner;
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address newOwner) onlyOwner public {
64         owner = newOwner;
65     }
66 }
67 
68 contract KFToken is owned{
69     using SafeMath for uint256;
70     
71     // Public variables of the token
72     string constant public name = "KF Token";
73     string constant public symbol = "KT";
74     uint8 constant public decimals = 18;
75     uint256 public totalSupply;
76 
77     // This creates an array with all balances
78     mapping (address => uint256) public balanceOf;
79     mapping (address => mapping (address => uint256)) public allowance;
80 
81     // This generates a public event on the blockchain that will notify clients
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     // This notifies clients about the amount burnt
85     event Burn(address indexed from, uint256 value);
86 
87     /**
88      * Constrctor function
89      *
90      * Initializes contract with initial supply tokens to the creator of the contract
91      */
92     constructor(
93         uint256 initialSupply
94     ) public {
95         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
96         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
97     }
98     
99     /**
100      * Internal transfer, only can be called by this contract
101      */
102     function _transfer(address _from, address _to, uint _value) internal {
103         // Prevent transfer to 0x0 address. Use burn() instead
104         require(_to != 0x0);
105         // Check if the sender has enough
106         require(balanceOf[_from] >= _value);
107         // Check for overflows
108         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
109         // Save this for an assertion in the future
110         uint previousBalances = balanceOf[_from] + balanceOf[_to];
111         // Subtract from the sender
112         balanceOf[_from] = balanceOf[_from].sub(_value);
113         // Add the same to the recipient
114         balanceOf[_to] = balanceOf[_to].add(_value);
115         emit Transfer(_from, _to, _value);
116         // Asserts are used to use static analysis to find bugs in your code. They should never fail
117         assert(balanceOf[_from]+balanceOf[_to] == previousBalances);
118     }
119 
120     /**
121      * Transfer tokens
122      *
123      * Send `_value` tokens to `_to` from your account
124      *
125      * @param _to The address of the recipient
126      * @param _value the amount to send
127      */
128     function transfer(address _to, uint256 _value) public {
129         _transfer(msg.sender, _to, _value);
130     }
131 
132     /**
133      * Transfer tokens from other address
134      *
135      * Send `_value` tokens to `_to` on behalf of `_from`
136      *
137      * @param _from The address of the sender
138      * @param _to The address of the recipient
139      * @param _value the amount to send
140      */
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(_value <= allowance[_from][msg.sender]);     // Check allowance
143         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
144         _transfer(_from, _to, _value);
145         return true;
146     }
147 
148     /**
149      * Set allowance for other address
150      *
151      * Allows `_spender` to spend no more than `_value` tokens on your behalf
152      *
153      * @param _spender The address authorized to spend
154      * @param _value the max amount they can spend
155      */
156     function approve(address _spender, uint256 _value) public returns (bool success) {
157         allowance[msg.sender][_spender] = _value;
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address and notify
163      *
164      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 
178     /**
179      * Destroy tokens
180      *
181      * Remove `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to burn
184      */
185     function burn(uint256 _value) onlyOwner public returns (bool success) {
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
188         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
189         emit Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
204         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
205         emit Burn(_from, _value);
206         return true;
207     }
208 }