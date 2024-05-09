1 pragma solidity ^0.4.24;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-07-25 - batchTransfer     */
9 /******************************************/
10 library SafeMath {
11 
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a / b;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract NetkillerAdvancedToken {
38     
39     using SafeMath for uint256;
40     
41     address public owner;
42     // Public variables of the token
43     string public name;
44     string public symbol;
45     uint public decimals;
46     // 18 decimals is the strongly suggested default, avoid changing it
47     uint256 public totalSupply;
48     
49     // This creates an array with all balances
50     mapping (address => uint256) internal balances;
51     mapping (address => mapping (address => uint256)) internal allowed;
52 
53     // This generates a public event on the blockchain that will notify clients
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     // This notifies clients about the amount burnt
57     event Burn(address indexed from, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     
60     mapping (address => bool) public frozenAccount;
61 
62     /* This generates a public event on the blockchain that will notify clients */
63     event FrozenFunds(address indexed target, bool frozen);
64 
65     bool public lock = false;                   // Global lock
66 
67     /**
68      * Constrctor function
69      *
70      * Initializes contract with initial supply tokens to the creator of the contract
71      */
72     constructor(
73         uint256 initialSupply,
74         string tokenName,
75         string tokenSymbol,
76         uint decimalUnits
77     ) public {
78         owner = msg.sender;
79         name = tokenName;                                   // Set the name for display purposes
80         symbol = tokenSymbol; 
81         decimals = decimalUnits;
82         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
83         balances[msg.sender] = totalSupply;                // Give the creator all initial token
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     modifier isLock {
92         require(!lock);
93         _;
94     }
95     
96     function setLock(bool _lock) onlyOwner public returns (bool status){
97         lock = _lock;
98         return lock;
99     }
100 
101     function transferOwnership(address _newOwner) onlyOwner public {
102         if (_newOwner != address(0)) {
103             owner = _newOwner;
104         }
105     }
106     function balanceOf(address _address) view public returns (uint256 balance) {
107         return balances[_address];
108     }
109     
110     /* Internal transfer, only can be called by this contract */
111     function _transfer(address _from, address _to, uint256 _value) isLock internal {
112         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
113         require (balances[_from] >= _value);                // Check if the sender has enough
114         require (balances[_to] + _value > balances[_to]);   // Check for overflows
115         require(!frozenAccount[_from]);                     // Check if sender is frozen
116         require(!frozenAccount[_to]);                       // Check if recipient is frozen
117         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
118         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
119         emit Transfer(_from, _to, _value);
120     }
121 
122     /**
123      * Transfer tokens
124      *
125      * Send `_value` tokens to `_to` from your account
126      *
127      * @param _to The address of the recipient
128      * @param _value the amount to send
129      */
130     function transfer(address _to, uint256 _value) public returns (bool success) {
131         _transfer(msg.sender, _to, _value);
132         return true;
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
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);     // Check allowance
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         _transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      */
160     function approve(address _spender, uint256 _value) public returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 
169     /**
170      * @dev Increase the amount of tokens that an owner allowed to a spender.
171      *
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * @param _spender The address which will spend the funds.
177      * @param _addedValue The amount of tokens to increase the allowance by.
178      */
179     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     /**
186      * @dev Decrease the amount of tokens that an owner allowed to a spender.
187      *
188      * approve should be called when allowed[_spender] == 0. To decrement
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * @param _spender The address which will spend the funds.
193      * @param _subtractedValue The amount of tokens to decrease the allowance by.
194      */
195     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
196         uint oldValue = allowed[msg.sender][_spender];
197         if (_subtractedValue > oldValue) {
198             allowed[msg.sender][_spender] = 0;
199         } else {
200             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201         }
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206     /**
207      * Destroy tokens
208      *
209      * Remove `_value` tokens from the system irreversibly
210      *
211      * @param _value the amount of money to burn
212      */
213     function burn(uint256 _value) onlyOwner public returns (bool success) {
214         require(balances[msg.sender] >= _value);                    // Check if the sender has enough
215         balances[msg.sender] = balances[msg.sender].sub(_value);    // Subtract from the sender
216         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
217         emit Burn(msg.sender, _value);
218         return true;
219     }
220 
221     /**
222      * Destroy tokens from other account
223      *
224      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
225      *
226      * @param _from the address of the sender
227      * @param _value the amount of money to burn
228      */
229     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
230         require(balances[_from] >= _value);                                      // Check if the targeted balance is enough
231         require(_value <= allowed[_from][msg.sender]);                           // Check allowance
232         balances[_from] = balances[_from].sub(_value);                           // Subtract from the targeted balance
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);     // Subtract from the sender's allowance
234         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
235         emit Burn(_from, _value);
236         return true;
237     }
238 
239     /// @notice Create `_amount` tokens and send it to `_to`
240     /// @param _to Address to receive the tokens
241     /// @param _amount the amount of tokens it will receive
242     function mintToken(address _to, uint256 _amount) onlyOwner public {
243         uint256 amount = _amount * 10 ** uint256(decimals);
244         totalSupply = totalSupply.add(amount);
245         balances[_to] = balances[_to].add(amount);
246         emit Transfer(this, _to, amount);
247     }
248 
249     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
250     /// @param target Address to be frozen
251     /// @param freeze either to freeze it or not
252     function freezeAccount(address target, bool freeze) onlyOwner public {
253         frozenAccount[target] = freeze;
254         emit FrozenFunds(target, freeze);
255     }
256 
257     function airdrop(address[] _to, uint256 _value) public returns (bool success) {
258         for (uint i=0; i<_to.length; i++) {
259             _transfer(msg.sender, _to[i], _value);
260         }
261         return true;
262     }
263     
264     function batchTransfer(address[] _to, uint256[] _value) public returns (bool success) {
265         require(_to.length == _value.length);
266 
267         uint256 amount = 0;
268         for(uint n=0;n<_value.length;n++){
269             amount += _value[n];
270         }
271         
272         require(amount > 0 && balanceOf(msg.sender) >= amount);
273         
274         for (uint i=0; i<_to.length; i++) {
275             transfer(_to[i], _value[i]);
276         }
277         return true;
278     }
279 }