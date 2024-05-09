1 pragma solidity ^0.4.21;
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
20 contract admined is owned {
21     address public admin;
22 
23     function admined() public {
24         admin = msg.sender;
25     }
26 
27     modifier onlyAdmin {
28         require(msg.sender == admin || msg.sender == owner);
29         _;
30     }
31 
32     function transferAdmin(address newAdmin) onlyOwner public {
33         admin = newAdmin;
34     }
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   /**
66   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
84 
85 contract TokenERC20 {
86     using SafeMath for uint256;
87     // Public variables of the token
88     string public name;
89     string public symbol;
90     uint256 public decimals = 18;
91     // 18 decimals is the strongly suggested default, avoid changing it
92     uint256 public totalSupply;
93 
94     // This creates an array with all balances
95     mapping (address => uint256) public balanceOf;
96     mapping (address => mapping (address => uint256)) public allowance;
97 
98     // This generates a public event on the blockchain that will notify clients
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     // This notifies clients about the amount burnt
102     event Burn(address indexed from, uint256 value);
103 
104     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
105 
106     /**
107      * Constrctor function
108      *
109      * Initializes contract with initial supply tokens to the creator of the contract
110      */
111     function TokenERC20(
112         uint256 initialSupply,
113         string tokenName,
114         uint256 decimalsToken,
115         string tokenSymbol
116     ) public {
117         decimals = decimalsToken;
118         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
119         emit Transfer(0, msg.sender, totalSupply);
120         balanceOf[msg.sender] = totalSupply;                // Give the contract itself all initial tokens
121         name = tokenName;                                   // Set the name for display purposes
122         symbol = tokenSymbol;                               // Set the symbol for display purposes
123     }
124 
125     /**
126      * Internal transfer, only can be called by this contract
127      */
128     function _transfer(address _from, address _to, uint _value) internal {
129         // Prevent transfer to 0x0 address. Use burn() instead
130         require(_to != 0x0);
131         // Subtract from the sender
132         balanceOf[_from] = balanceOf[_from].sub(_value);
133         // Add the same to the recipient
134         balanceOf[_to] = balanceOf[_to].add(_value);
135         emit Transfer(_from, _to, _value);
136     }
137 
138     /**
139      * Transfer tokens
140      *
141      * Send `_value` tokens to `_to` from your account
142      *
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transfer(address _to, uint256 _value) public {
147         _transfer(msg.sender, _to, _value);
148     }
149 
150     /**
151      * Transfer tokens from other address
152      *
153      * Send `_value` tokens to `_to` in behalf of `_from`
154      *
155      * @param _from The address of the sender
156      * @param _to The address of the recipient
157      * @param _value the amount to send
158      */
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
160         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
161         _transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * Set allowance for other address
167      *
168      * Allows `_spender` to spend no more than `_value` tokens in your behalf
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      */
173     function approve(address _spender, uint256 _value) public
174         returns (bool success) {
175         allowance[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * Set allowance for other address and notify
182      *
183      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
184      *
185      * @param _spender The address authorized to spend
186      * @param _value the max amount they can spend
187      * @param _extraData some extra information to send to the approved contract
188      */
189     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
190         returns (bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.receiveApproval(msg.sender, _value, this, _extraData);
194             return true;
195         }
196     }
197 
198     /**
199      * Destroy tokens
200      *
201      * Remove `_value` tokens from the system irreversibly
202      *
203      * @param _value the amount of money to burn
204      */
205     function burn(uint256 _value) public returns (bool success) {
206         _burn(msg.sender, _value);
207         return true;
208     }
209     
210     function _burn(address _who, uint256 _value) internal {
211         balanceOf[_who] = balanceOf[_who].sub(_value);  // Subtract from the sender
212         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
213         emit Burn(_who, _value);
214         emit Transfer(_who, address(0), _value);
215     }
216 
217     /**
218      * Destroy tokens from other account
219      *
220      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
221      *
222      * @param _from the address of the sender
223      * @param _value the amount of money to burn
224      */
225     function burnFrom(address _from, uint256 _value) public returns (bool success) {
226         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
227         _burn(_from, _value);
228         return true;
229     }
230 
231     function getBalance(address _to) view public returns(uint res) {
232         return balanceOf[_to];
233     }
234 
235 }
236 
237 contract CPROPToken is admined, TokenERC20  {
238     function CPROPToken(
239         uint256 initialSupply,
240         string tokenName,
241         uint256 decimalsToken,
242         string tokenSymbol
243     ) TokenERC20(initialSupply, tokenName, decimalsToken, tokenSymbol) public {
244     }
245 }