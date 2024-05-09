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
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   /**
49   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
67 
68 contract RoyalPanties {
69     // Public variables of the token
70     string public name;
71     string public symbol;
72     uint8 public decimals = 18;
73     // 18 decimals is the strongly suggested default, avoid changing it
74     uint256 public totalSupply;
75 
76     // This creates an array with all balances
77     mapping (address => uint256) public balanceOf;
78     mapping (address => mapping (address => uint256)) public allowance;
79 
80     // This generates a public event on the blockchain that will notify clients
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     // This notifies clients about the amount burnt
84     event Burn(address indexed from, uint256 value);
85 
86     /**
87      * Constrctor function
88      *
89      * Initializes contract with initial supply tokens to the creator of the contract
90      */
91     function RoyalPanties(
92         uint256 initialSupply,
93         string tokenName,
94         string tokenSymbol
95     ) public {
96         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
97         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
98         name = tokenName;                                   // Set the name for display purposes
99         symbol = tokenSymbol;                               // Set the symbol for display purposes
100     }
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
111         require(balanceOf[_to] + _value > balanceOf[_to]);
112         // Save this for an assertion in the future
113         uint previousBalances = balanceOf[_from] + balanceOf[_to];
114         // Subtract from the sender
115         balanceOf[_from] -= _value;
116         // Add the same to the recipient
117         balanceOf[_to] += _value;
118         Transfer(_from, _to, _value);
119         // Asserts are used to use static analysis to find bugs in your code. They should never fail
120         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
121     }
122 
123     /**
124      * Transfer tokens
125      *
126      * Send `_value` tokens to `_to` from your account
127      *
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transfer(address _to, uint256 _value) public {
132         _transfer(msg.sender, _to, _value);
133     }
134 
135     /**
136      * Transfer tokens from other address
137      *
138      * Send `_value` tokens to `_to` in behalf of `_from`
139      *
140      * @param _from The address of the sender
141      * @param _to The address of the recipient
142      * @param _value the amount to send
143      */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_value <= allowance[_from][msg.sender]);     // Check allowance
146         allowance[_from][msg.sender] -= _value;
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Set allowance for other address
153      *
154      * Allows `_spender` to spend no more than `_value` tokens in your behalf
155      *
156      * @param _spender The address authorized to spend
157      * @param _value the max amount they can spend
158      */
159     function approve(address _spender, uint256 _value) public
160         returns (bool success) {
161         allowance[msg.sender][_spender] = _value;
162         return true;
163     }
164 
165     /**
166      * Set allowance for other address and notify
167      *
168      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      * @param _extraData some extra information to send to the approved contract
173      */
174     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
175         public
176         returns (bool success) {
177         tokenRecipient spender = tokenRecipient(_spender);
178         if (approve(_spender, _value)) {
179             spender.receiveApproval(msg.sender, _value, this, _extraData);
180             return true;
181         }
182     }
183 
184     /**
185      * Destroy tokens
186      *
187      * Remove `_value` tokens from the system irreversibly
188      *
189      * @param _value the amount of money to burn
190      */
191     function burn(uint256 _value) public returns (bool success) {
192         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
193         balanceOf[msg.sender] -= _value;            // Subtract from the sender
194         totalSupply -= _value;                      // Updates totalSupply
195         Burn(msg.sender, _value);
196         return true;
197     }
198 
199     /**
200      * Destroy tokens from other account
201      *
202      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from the address of the sender
205      * @param _value the amount of money to burn
206      */
207     function burnFrom(address _from, uint256 _value) public returns (bool success) {
208         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
209         require(_value <= allowance[_from][msg.sender]);    // Check allowance
210         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
211         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
212         totalSupply -= _value;                              // Update totalSupply
213         Burn(_from, _value);
214         return true;
215     }
216 }