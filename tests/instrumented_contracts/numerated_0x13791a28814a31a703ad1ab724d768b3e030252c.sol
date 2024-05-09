1 pragma solidity ^0.4.16;
2 
3 
4 contract owned {
5 
6     address public owner;
7     address[] public admins;
8     mapping (address => bool) public isAdmin;
9 
10     function owned() public {
11         owner = msg.sender;
12         isAdmin[msg.sender] = true;
13         admins.push(msg.sender);
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     modifier onlyAdmin {
22         require(isAdmin[msg.sender]);
23         _;
24     }
25 
26     function addAdmin(address user) onlyOwner public {
27         require(!isAdmin[user]);
28         isAdmin[user] = true;
29         admins.push(user);
30     }
31 
32     function removeAdmin(address user) onlyOwner public {
33         require(isAdmin[user]);
34         isAdmin[user] = false;
35         for (uint i = 0; i < admins.length - 1; i++)
36             if (admins[i] == user) {
37                 admins[i] = admins[admins.length - 1];
38                 break;
39             }
40         admins.length -= 1;
41     }
42 
43     function replaceAdmin(address oldAdmin, address newAdmin) onlyOwner public {
44         require(isAdmin[oldAdmin]);
45         require(!isAdmin[newAdmin]);
46         for (uint i = 0; i < admins.length; i++)
47             if (admins[i] == oldAdmin) {
48                 admins[i] = newAdmin;
49                 break;
50             }
51         isAdmin[oldAdmin] = false;
52         isAdmin[newAdmin] = true;
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner public {
56         owner = newOwner;
57     }
58 
59     function getAdmins() public view returns (address[]) {
60         return admins;
61     }
62 
63 }
64 
65 
66 interface tokenRecipient {
67     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
68 }
69 
70 
71 contract TokenERC20 {
72     // Public variables of the token
73     string public name;
74     string public symbol;
75     uint8 public decimals = 18;
76     uint256 public totalSupply;
77 
78     // This creates an array with all balances
79     mapping (address => uint256) public balanceOf;
80     mapping (address => mapping (address => uint256)) public allowance;
81 
82     // This generates a public event on the blockchain that will notify clients
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     event Burn(address indexed from, uint256 value);
86 
87     /**
88      * Constrctor function
89      *
90      * Initializes contract with initial supply tokens to the creator of the contract
91      */
92     function TokenERC20(
93         uint256 initialSupply,
94         address initTarget,
95         string tokenName,
96         string tokenSymbol
97     ) public {
98         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
99         balanceOf[initTarget] = totalSupply;                    // Give the target address all initial tokens
100         name = tokenName;                                       // Set the name for display purposes
101         symbol = tokenSymbol;                                   // Set the symbol for display purposes
102     }
103 
104     /**
105      * Internal transfer, only can be called by this contract
106      */
107     function _transfer(address _from, address _to, uint256 _value) internal {
108         // Prevent transfer to 0x0 address. Use burn() instead
109         require(_to != 0x0);
110         // Check if the sender has enough
111         require(balanceOf[_from] >= _value);
112         // Check for overflows
113         require(balanceOf[_to] + _value > balanceOf[_to]);
114         // Save this for an assertion in the future
115         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
116         // Subtract from the sender
117         balanceOf[_from] -= _value;
118         // Add the same to the recipient
119         balanceOf[_to] += _value;
120         Transfer(_from, _to, _value);
121         // Asserts are used to use static analysis to find bugs in your code. They should never fail
122         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
123     }
124 
125     /**
126      * Transfer tokens
127      *
128      * Send `_value` tokens to `_to` from your account
129      *
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transfer(address _to, uint256 _value) public returns (bool success) {
134         _transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Transfer tokens from other address
140      *
141      * Send `_value` tokens to `_to` in behalf of `_from`
142      *
143      * @param _from The address of the sender
144      * @param _to The address of the recipient
145      * @param _value the amount to send
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require(_value <= allowance[_from][msg.sender]);     // Check allowance
149         allowance[_from][msg.sender] -= _value;
150         _transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address
156      *
157      * Allows `_spender` to spend no more than `_value` tokens in your behalf
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      */
162     function approve(address _spender, uint256 _value) public returns (bool success) {
163         allowance[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169      * Set allowance for other address and notify
170      *
171      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
172      *
173      * @param _spender The address authorized to spend
174      * @param _value the max amount they can spend
175      * @param _extraData some extra information to send to the approved contract
176      */
177     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
178         public
179         returns (bool success) {
180         tokenRecipient spender = tokenRecipient(_spender);
181         if (approve(_spender, _value)) {
182             spender.receiveApproval(msg.sender, _value, this, _extraData);
183             return true;
184         }
185     }
186 
187     /**
188      * Destroy tokens
189      *
190      * Remove `_value` tokens from the system irreversibly
191      *
192      * @param _value the amount of money to burn
193      */
194     function burn(uint256 _value) public returns (bool success) {
195         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
196         balanceOf[msg.sender] -= _value;            // Subtract from the sender
197         totalSupply -= _value;                      // Updates totalSupply
198         Burn(msg.sender, _value);
199         return true;
200     }
201 
202     /**
203      * Destroy tokens from other account
204      *
205      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
206      *
207      * @param _from the address of the sender
208      * @param _value the amount of money to burn
209      */
210     function burnFrom(address _from, uint256 _value) public returns (bool success) {
211         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
212         require(_value <= allowance[_from][msg.sender]);    // Check allowance
213         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
214         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
215         totalSupply -= _value;                              // Update totalSupply
216         Burn(_from, _value);
217         return true;
218     }
219 }
220 
221 
222 contract ZingCoin is owned, TokenERC20 {
223 
224     mapping (address => bool) public frozenAccount;
225 
226     event FrozenFunds(address target, bool frozen);
227 
228     /* Initializes contract with initial supply tokens to the target address */
229     function ZingCoin(
230         uint256 initialSupply,
231         address initTarget,
232         string tokenName,
233         string tokenSymbol
234     ) TokenERC20(initialSupply, initTarget, tokenName, tokenSymbol) public {}
235 
236     /* Internal transfer, only can be called by this contract */
237     function _transfer(address _from, address _to, uint256 _value) internal {
238         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
239         require (balanceOf[_from] >= _value);               // Check if the sender has enough
240         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
241         require(!frozenAccount[_from]);                     // Check if sender is frozen
242         require(!frozenAccount[_to]);                       // Check if recipient is frozen
243         balanceOf[_from] -= _value;                         // Subtract from the sender
244         balanceOf[_to] += _value;                           // Add the same to the recipient
245         Transfer(_from, _to, _value);
246     }
247 
248     /* roll in `amount` tokens to `target` */
249     function rollIn(address target, uint256 amount) onlyAdmin public {
250         balanceOf[target] += amount;
251         totalSupply += amount;
252         Transfer(0, this, amount);
253         Transfer(this, target, amount);
254     }
255 
256     /* roll out `amount` tokens from `target` */
257     function rollOut(address target, uint256 amount) onlyAdmin public returns (bool success) {
258         require(balanceOf[target] >= amount);       // Check if the target has enough
259         balanceOf[target] -= amount;                // Subtract from the target
260         totalSupply -= amount;                      // Updates totalSupply
261         Burn(target, amount);
262         return true;
263     }
264 
265     /* `freeze? Prevent | Allow` `target` from sending & receiving tokens */
266     function freezeAccount(address target, bool freeze) onlyAdmin public {
267         frozenAccount[target] = freeze;
268         FrozenFunds(target, freeze);
269     }
270 
271     function changeName(string _name) onlyOwner public {
272         name = _name;
273     }
274 
275     function changeSymbol(string _symbol) onlyOwner public {
276         symbol = _symbol;
277     }
278 
279 }