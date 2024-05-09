1 pragma solidity ^0.4.18;
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
20 library SafeMath {
21    function mul(uint a, uint b) internal pure returns (uint) {
22      if (a == 0) {
23         return 0;
24       }
25 
26       uint c = a * b;
27       assert(c / a == b);
28       return c;
29    }
30 
31    function sub(uint a, uint b) internal pure returns (uint) {
32       assert(b <= a);
33       return a - b;
34    }
35 
36    function add(uint a, uint b) internal pure returns (uint) {
37       uint c = a + b;
38       assert(c >= a);
39       return c;
40    }
41 
42   function div(uint a, uint b) internal pure returns (uint256) {
43     assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint c = a / b;
45     assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 }
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
51 
52 contract TokenERC20 {
53     using SafeMath for uint256;
54     // Public variables of the token
55     string public name;
56     string public symbol;
57     uint8 public decimals = 18;
58     // 18 decimals is the strongly suggested default, avoid changing it
59     uint256 public totalSupply;
60 
61     // This creates an array with all balances
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     // This generates a public event on the blockchain that will notify clients
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value);
70 
71     /**
72      * Constrctor function
73      *
74      * Initializes contract with initial supply tokens to the creator of the contract
75      */
76     function TokenERC20(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     /**
88      * Internal transfer, only can be called by this contract
89      */
90     function _transfer(address _from, address _to, uint _value) internal {
91         // Prevent transfer to 0x0 address. Use burn() instead
92         require(_to != 0x0);
93         // Check if the sender has enough
94         require(balanceOf[_from] >= _value);
95         // Check for overflows
96         require(balanceOf[_to].add(_value) > balanceOf[_to]);
97         // Save this for an assertion in the future
98         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
99         // Subtract from the sender
100         balanceOf[_from] = balanceOf[_from].sub(_value);
101         // Add the same to the recipient
102         balanceOf[_to] =balanceOf[_to].add(_value);
103         Transfer(_from, _to, _value);
104         // Asserts are used to use static analysis to find bugs in your code. They should never fail
105         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
106     }
107 
108     /**
109      * Transfer tokens
110      *
111      * Send `_value` tokens to `_to` from your account
112      *
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transfer(address _to, uint256 _value) public {
117         _transfer(msg.sender, _to, _value);
118     }
119 
120     /**
121      * Transfer tokens from other address
122      *
123      * Send `_value` tokens to `_to` in behalf of `_from`
124      *
125      * @param _from The address of the sender
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         require(_value <= allowance[_from][msg.sender]);     // Check allowance
131         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
132         _transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      */
144     function approve(address _spender, uint256 _value) public
145         returns (bool success) {
146         allowance[msg.sender][_spender] = _value;
147         return true;
148     }
149 
150     /**
151      * Set allowance for other address and notify
152      *
153      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
154      *
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
160         public
161         returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, this, _extraData);
165             return true;
166         }
167     }
168 
169     /**
170      * Destroy tokens
171      *
172      * Remove `_value` tokens from the system irreversibly
173      *
174      * @param _value the amount of money to burn
175      */
176     function burn(uint256 _value) public returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
178         balanceOf[msg.sender] -= _value;            // Subtract from the sender
179         totalSupply -= _value;                      // Updates totalSupply
180         Burn(msg.sender, _value);
181         return true;
182     }
183 
184     /**
185      * Destroy tokens from other account
186      *
187      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
188      *
189      * @param _from the address of the sender
190      * @param _value the amount of money to burn
191      */
192     function burnFrom(address _from, uint256 _value) public returns (bool success) {
193         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
194         require(_value <= allowance[_from][msg.sender]);    // Check allowance
195         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
196         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
197         totalSupply -= _value;                              // Update totalSupply
198         Burn(_from, _value);
199         return true;
200     }
201 }
202 
203 /******************************************/
204 /*       ADVANCED TOKEN STARTS HERE       */
205 /******************************************/
206 
207 contract TISCoin is owned, TokenERC20 {
208     using SafeMath for uint256;
209 
210     mapping (address => bool) public frozenAccount;
211 
212     /* This generates a public event on the blockchain that will notify clients */
213     event FrozenFunds(address target, bool frozen);
214 
215     /* Initializes contract with initial supply tokens to the creator of the contract */
216     function TISCoin(
217         uint256 initialSupply,
218         string tokenName,
219         string tokenSymbol
220     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
221 
222     /* Internal transfer, only can be called by this contract */
223     function _transfer(address _from, address _to, uint _value) internal {
224         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
225         require (balanceOf[_from] >= _value);               // Check if the sender has enough
226         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
227         require(!frozenAccount[_from]);                     // Check if sender is frozen
228         require(!frozenAccount[_to]);                       // Check if recipient is frozen
229         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
230         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
231         Transfer(_from, _to, _value);
232     }
233 
234     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
235     /// @param target Address to be frozen
236     /// @param freeze either to freeze it or not
237     function freezeAccount(address target, bool freeze) onlyOwner public {
238         frozenAccount[target] = freeze;
239         FrozenFunds(target, freeze);
240     }
241 
242 }