1 pragma solidity >=0.4.17;
2 
3 contract Migrations {
4     address public owner;
5 
6     event TransferOwnership(address oldaddr, address newaddr);
7 
8     modifier onlyOwner() { require(msg.sender == owner); _; }
9 
10     function Migrations() public {
11         owner = msg.sender;
12     }
13 
14     function transferOwnership(address _new) onlyOwner public {
15         address oldaddr = owner;
16         owner = _new;
17         TransferOwnership(oldaddr, owner);
18     }
19 }
20 
21 
22 
23 
24 
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33     /**
34      * @dev Multiplies two numbers, throws on overflow.
35      */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     /**
46      * @dev Integer division of two numbers, truncating the quotient.
47      */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // assert(b > 0); // Solidity automatically throws when dividing by 0
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52         return c;
53     }
54 
55     /**
56      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61     }
62 
63     /**
64      * @dev Adds two numbers, throws on overflow.
65      */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 }
72 
73 
74 
75 
76 
77 
78 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
79 
80 contract BezantERC20Base {
81     using SafeMath for uint256;
82 
83         // Public variables of the token
84                        string public name;
85     string public symbol;
86     uint8 public decimals = 18;
87     // 18 decimals is the strongly suggested default, avoid changing it
88     uint256 public totalSupply;
89 
90     // This creates an array with all balances
91     mapping (address => uint256) public balanceOf;
92     mapping (address => mapping (address => uint256)) public allowance;
93 
94     // This generates a public event on the blockchain that will notify clients
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     // This notifies clients about the amount burnt
98     event Burn(address indexed from, uint256 value);
99 
100     /**
101      * Constrctor function
102      *
103      * Initializes contract with initial supply tokens to the creator of the contract
104      */
105     function BezantERC20Base(string tokenName) public {
106         uint256 initialSupply = 1000000000;
107         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
108         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
109         name = tokenName;                                       // Set the name for display purposes
110         symbol = 'BZNT';                                   // Set the symbol for display purposes
111     }
112 
113     /**
114      * Internal transfer, only can be called by this contract
115      */
116     function _transfer(address _from, address _to, uint _value) internal {
117         // Prevent transfer to 0x0 address. Use burn() instead
118         require(_to != 0x0);
119         // Check if the sender has enough
120         require(balanceOf[_from] >= _value);
121         // Check for overflows
122         require(balanceOf[_to] + _value > balanceOf[_to]);
123         // Save this for an assertion in the future
124         uint previousBalances = balanceOf[_from] + balanceOf[_to];
125         // Subtract from the sender
126         balanceOf[_from] -= _value;
127         // Add the same to the recipient
128         balanceOf[_to] += _value;
129         Transfer(_from, _to, _value);
130         // Asserts are used to use static analysis to find bugs in your code. They should never fail
131         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
132     }
133 
134     /**
135      * Transfer tokens
136      *
137      * Send `_value` tokens to `_to` from your account
138      *
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transfer(address _to, uint256 _value) public {
143         _transfer(msg.sender, _to, _value);
144     }
145 
146     /**
147      * Transfer tokens from other address
148      *
149      * Send `_value` tokens to `_to` in behalf of `_from`
150      *
151      * @param _from The address of the sender
152      * @param _to The address of the recipient
153      * @param _value the amount to send
154      */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
156         require(_value <= allowance[_from][msg.sender]);     // Check allowance
157         allowance[_from][msg.sender] -= _value;
158         _transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * Set allowance for other address
164      *
165      * Allows `_spender` to spend no more than `_value` tokens in your behalf
166      *
167      * @param _spender The address authorized to spend
168      * @param _value the max amount they can spend
169      */
170     function approve(address _spender, uint256 _value) public
171     returns (bool success) {
172         allowance[msg.sender][_spender] = _value;
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address and notify
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      * @param _extraData some extra information to send to the approved contract
184      */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
186         tokenRecipient spender = tokenRecipient(_spender);
187         if (approve(_spender, _value)) {
188             spender.receiveApproval(msg.sender, _value, this, _extraData);
189             return true;
190         }
191     }
192 
193     /**
194      * Destroy tokens
195      *
196      * Remove `_value` tokens from the system irreversibly
197      *
198      * @param _value the amount of money to burn
199      */
200     function burn(uint256 _value) public returns (bool success) {
201         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
202         balanceOf[msg.sender] -= _value;            // Subtract from the sender
203         totalSupply -= _value;                      // Updates totalSupply
204         Burn(msg.sender, _value);
205         return true;
206     }
207 
208     /**
209      * Destroy tokens from other account
210      *
211      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
212      *
213      * @param _from the address of the sender
214      * @param _value the amount of money to burn
215      */
216     function burnFrom(address _from, uint256 _value) public returns (bool success) {
217         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
218         require(_value <= allowance[_from][msg.sender]);    // Check allowance
219         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
220         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
221         totalSupply -= _value;                              // Update totalSupply
222         Burn(_from, _value);
223         return true;
224     }
225 }
226 
227 contract BezantToken is Migrations, BezantERC20Base {
228 
229     mapping (address => bool) public frozenAccount;
230 
231     event FrozenFunds(address target, bool frozen);
232 
233     function BezantToken(string tokenName) BezantERC20Base(tokenName) onlyOwner public {}
234 
235     function _transfer(address _from, address _to, uint _value) internal {
236         require (_to != 0x0);
237         require (balanceOf[_from] >= _value);
238         require (balanceOf[_to] + _value > balanceOf[_to]);
239         require(!frozenAccount[_from]);
240         require(!frozenAccount[_to]);
241         balanceOf[_from] -= _value;
242         balanceOf[_to] += _value;
243         Transfer(_from, _to, _value);
244     }
245 
246     function freezeAccount(address _runner, address target, bool freeze) public {
247         require(_runner == owner);
248         frozenAccount[target] = freeze;
249         FrozenFunds(target, freeze);
250     }
251 
252     function getBalance(address _address) public onlyOwner constant returns(uint _availableToken)  {
253         _availableToken = balanceOf[_address];
254     }
255 }