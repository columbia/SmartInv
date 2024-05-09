1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33 
34     function owned() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) onlyOwner public {
44         owner = newOwner;
45     }
46 }
47 
48 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
49 
50 contract TokenERC20 {
51     // Public variables of the token
52     string public name;
53     string public symbol;
54     uint8 public decimals = 18;
55     // 18 decimals is the strongly suggested default, avoid changing it
56     uint256 public totalSupply;
57 
58     // This creates an array with all balances
59     mapping (address => uint256) public balances;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     // This notifies clients about the amount burnt
66     event Burn(address indexed from, uint256 value);
67 
68     /**
69      * Constrctor function
70      *
71      * Initializes contract with initial supply tokens to the creator of the contract
72      */
73     function TokenERC20(
74         uint256 initialSupply,
75         string tokenName,
76         string tokenSymbol
77     ) public {
78         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
79         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
80         name = tokenName;                                   // Set the name for display purposes
81         symbol = tokenSymbol;                               // Set the symbol for display purposes
82     }
83 
84     /**
85      * Internal transfer, only can be called by this contract
86      */
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != 0x0);
90         // Check if the sender has enough
91         require(balances[_from] >= _value);
92         // Check for overflows
93         require(balances[_to] + _value > balances[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balances[_from] + balances[_to];
96         // Subtract from the sender
97         balances[_from] -= _value;
98         // Add the same to the recipient
99         balances[_to] += _value;
100         Transfer(_from, _to, _value);
101         // Asserts are used to use static analysis to find bugs in your code. They should never fail
102         assert(balances[_from] + balances[_to] == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      *
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transfer(address _to, uint256 _value) public {
114         _transfer(msg.sender, _to, _value);
115     }
116 
117     /**
118      * Transfer tokens from other address
119      *
120      * Send `_value` tokens to `_to` in behalf of `_from`
121      *
122      * @param _from The address of the sender
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
127         require(_value <= allowance[_from][msg.sender]);     // Check allowance
128         allowance[_from][msg.sender] -= _value;
129         _transfer(_from, _to, _value);
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address
135      *
136      * Allows `_spender` to spend no more than `_value` tokens in your behalf
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      */
141     function approve(address _spender, uint256 _value) public
142         returns (bool success) {
143         allowance[msg.sender][_spender] = _value;
144         return true;
145     }
146 
147     /**
148      * Set allowance for other address and notify
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      * @param _extraData some extra information to send to the approved contract
155      */
156     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
157         public
158         returns (bool success) {
159         tokenRecipient spender = tokenRecipient(_spender);
160         if (approve(_spender, _value)) {
161             spender.receiveApproval(msg.sender, _value, this, _extraData);
162             return true;
163         }
164     }
165 
166     /**
167      * Destroy tokens
168      *
169      * Remove `_value` tokens from the system irreversibly
170      *
171      * @param _value the amount of money to burn
172      */
173     function burn(uint256 _value) public returns (bool success) {
174         require(balances[msg.sender] >= _value);   // Check if the sender has enough
175         balances[msg.sender] -= _value;            // Subtract from the sender
176         totalSupply -= _value;                      // Updates totalSupply
177         Burn(msg.sender, _value);
178         return true;
179     }
180 
181     /**
182      * Destroy tokens from other account
183      *
184      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
185      *
186      * @param _from the address of the sender
187      * @param _value the amount of money to burn
188      */
189     function burnFrom(address _from, uint256 _value) public returns (bool success) {
190         require(balances[_from] >= _value);                // Check if the targeted balance is enough
191         require(_value <= allowance[_from][msg.sender]);    // Check allowance
192         balances[_from] -= _value;                         // Subtract from the targeted balance
193         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
194         totalSupply -= _value;                              // Update totalSupply
195         Burn(_from, _value);
196         return true;
197     }
198 }
199 
200 /******************************************/
201 /*       ADVANCED TOKEN STARTS HERE       */
202 /******************************************/
203 
204 contract AppleToken is owned, TokenERC20 {
205 
206     using SafeMath for uint256;
207 
208     // for airdrop
209     bool public openAirDrop;
210     uint256 public currentTotalSupply = 0;
211     uint256 startBalance = 120 ether;
212     mapping(address => bool) touched;
213 
214     mapping (address => bool) public frozenAccount;
215 
216     /* This generates a public event on the blockchain that will notify clients */
217     event FrozenFunds(address target, bool frozen);
218 
219     /* Initializes contract with initial supply tokens to the creator of the contract */
220     function AppleToken (
221         uint256 initialSupply,
222         string tokenName,
223         string tokenSymbol,
224         bool airDrop
225     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
226         openAirDrop = airDrop;
227     }
228 
229     /* Internal transfer, only can be called by this contract */
230     function _transfer(address _from, address _to, uint _value) internal {
231         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
232         require (balances[_from] >= _value);               // Check if the sender has enough
233         require (balances[_to] + _value >= balances[_to]); // Check for overflows
234         require(!frozenAccount[_from]);                     // Check if sender is frozen
235         require(!frozenAccount[_to]);                       // Check if recipient is frozen
236         
237         // for airdrop
238         if ( openAirDrop && !touched[msg.sender] && currentTotalSupply < totalSupply && (msg.sender != owner) ) {
239             balances[msg.sender] = balances[msg.sender].add( startBalance );
240             touched[msg.sender] = true;
241             currentTotalSupply = currentTotalSupply.add( startBalance );
242         }
243         
244         balances[_from] -= _value;                         // Subtract from the sender
245         balances[_to] += _value;                           // Add the same to the recipient
246         Transfer(_from, _to, _value);
247     }
248 
249     function switchAirDrop(bool airDrop) onlyOwner public {
250         openAirDrop = airDrop;
251     }
252 
253     /// @notice Create `mintedAmount` tokens and send it to `target`
254     /// @param target Address to receive the tokens
255     /// @param mintedAmount the amount of tokens it will receive
256     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
257         balances[target] += mintedAmount;
258         totalSupply += mintedAmount;
259         Transfer(0, this, mintedAmount);
260         Transfer(this, target, mintedAmount);
261     }
262 
263     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
264     /// @param target Address to be frozen
265     /// @param freeze either to freeze it or not
266     function freezeAccount(address target, bool freeze) onlyOwner public {
267         frozenAccount[target] = freeze;
268         FrozenFunds(target, freeze);
269     }
270     
271     function getBalance(address _a) internal constant returns(uint256)
272     {
273         if( currentTotalSupply < totalSupply ){
274             if( touched[_a] )
275                 return balances[_a];
276             else {
277                 if (openAirDrop && (_a != owner)) {
278                     return balances[_a].add( startBalance );
279                 } else {
280                     return balances[_a];
281                 }
282             }
283         } else {
284             return balances[_a];
285         }
286     }
287     
288 
289     function balanceOf(address _owner) public view returns (uint256 balance) {
290         return getBalance( _owner );
291     }
292 }