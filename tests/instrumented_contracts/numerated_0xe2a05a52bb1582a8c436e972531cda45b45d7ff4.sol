1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract owned {
34     address public owner;
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46         owner = newOwner;
47     }
48 }
49 
50 contract TokenERC20 {
51     using SafeMath for uint256;
52     
53     // Public variables of the token
54     string public name;
55     string public symbol;
56     uint8 public decimals = 18;
57     // 18 decimals is the strongly suggested default, avoid changing it
58     uint256 public totalSupply;
59 
60     // This creates an array with all balances
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     // This generates a public event on the blockchain that will notify clients
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     // 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value);
70 
71     /**
72      * Constrctor function
73      *
74      * Initializes contract with initial supply tokens to the creator of the contract
75      */
76     constructor(
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
96         require(balanceOf[_to] + _value > balanceOf[_to]);
97         // Save this for an assertion in the future
98         uint previousBalances = balanceOf[_from] + balanceOf[_to];
99         // Subtract from the sender
100         balanceOf[_from] -= _value;
101         // Add the same to the recipient
102         balanceOf[_to] += _value;
103         emit Transfer(_from, _to, _value);
104         // Asserts are used to use static analysis to find bugs in your code. They should never fail
105         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
116     function transfer(address _to, uint256 _value) public returns (bool success) {
117         _transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122      * Transfer tokens from other address
123      *
124      * Send `_value` tokens to `_to` in behalf of `_from`
125      *
126      * @param _from The address of the sender
127      * @param _to The address of the recipient
128      * @param _value the amount to send
129      */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]);     // Check allowance
132         allowance[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      */
145     function approve(address _spender, uint256 _value) public
146         returns (bool success) {
147         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
148         allowance[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * Destroy tokens
155      *
156      * Remove `_value` tokens from the system irreversibly
157      *
158      * @param _value the amount of money to burn
159      */
160     function burn(uint256 _value) public returns (bool success) {
161         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
162         balanceOf[msg.sender] -= _value;            // Subtract from the sender
163         // totalSupply -= _value;                      // Updates totalSupply
164         totalSupply = totalSupply.sub(_value);
165         emit Burn(msg.sender, _value);
166         return true;
167     }
168 
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
179         require(_value <= allowance[_from][msg.sender]);    // Check allowance
180         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
181         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
182         // totalSupply -= _value;                              // Update totalSupply
183         totalSupply = totalSupply.sub(_value);
184         emit Burn(_from, _value);
185         return true;
186     }
187 }
188 
189 /******************************************/
190 /*       ADVANCED TOKEN STARTS HERE       */
191 /******************************************/
192 
193 contract MyAdvancedToken is owned, TokenERC20 {
194 
195     /*
196     uint256 public sellPrice;
197     uint256 public buyPrice;
198     */
199 
200     mapping (address => bool) public frozenAccount;
201 
202     /* This generates a public event on the blockchain that will notify clients */
203     event FrozenFunds(address target, bool frozen);
204 
205     /* Initializes contract with initial supply tokens to the creator of the contract */
206     constructor(
207         uint256 initialSupply,
208         string tokenName,
209         string tokenSymbol
210     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
211 
212     /* Internal transfer, only can be called by this contract */
213     function _transfer(address _from, address _to, uint _value) internal {
214         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
215         require (balanceOf[_from] >= _value);               // Check if the sender has enough
216         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
217         require(!frozenAccount[_from]);                     // Check if sender is frozen
218         require(!frozenAccount[_to]);                       // Check if recipient is frozen
219         balanceOf[_from] -= _value;                         // Subtract from the sender
220         balanceOf[_to] += _value;                           // Add the same to the recipient
221         emit Transfer(_from, _to, _value);
222     }
223 
224     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
225     /// @param target Address to be frozen
226     /// @param freeze either to freeze it or not
227     function freezeAccount(address target, bool freeze) onlyOwner public {
228         frozenAccount[target] = freeze;
229         emit FrozenFunds(target, freeze);
230     }
231 }