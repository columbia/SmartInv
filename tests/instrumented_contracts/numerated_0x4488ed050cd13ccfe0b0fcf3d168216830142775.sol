1 pragma solidity ^0.4.21;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-05-16 - Add Global lock   */
9 /******************************************/
10 
11 contract NetkillerAdvancedTokenAirDrop {
12     address public owner;
13     // Public variables of the token
14     string public name;
15     string public symbol;
16     uint public decimals;
17     // 18 decimals is the strongly suggested default, avoid changing it
18     uint256 public totalSupply;
19     
20     // This creates an array with all balances
21     mapping (address => uint256) internal balances;
22     mapping (address => mapping (address => uint256)) internal allowed;
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30     
31     mapping (address => bool) public frozenAccount;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event FrozenFunds(address indexed target, bool frozen);
35 
36     bool public lock = false;                   // Global lock
37     bool public airdropStatus = false;          // Airdrop Status
38     uint256 public airdropTotalSupply;          // Airdrop Total Supply
39     uint256 public airdropCurrentTotal;    	    // Airdrop Current Total 
40     uint256 public airdropAmount;        		// Airdrop amount
41     mapping(address => bool) public touched;    // Airdrop history account
42     
43     event AirDrop(address indexed target, uint256 value);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function NetkillerAdvancedTokenAirDrop(
51         uint256 initialSupply,
52         string tokenName,
53         string tokenSymbol,
54         uint decimalUnits
55     ) public {
56         owner = msg.sender;
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol; 
59         decimals = decimalUnits;
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balances[msg.sender] = totalSupply;                // Give the creator all initial token
62         airdropAmount = 1 * 10 ** uint256(decimals);
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     modifier isLock {
71         require(!lock);
72         _;
73     }
74     
75     function setLock(bool _lock) onlyOwner public returns (bool status){
76         lock = _lock;
77         return lock;
78     }
79 
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85     function balanceOf(address _address) public returns (uint256 balance) {
86         return getBalance(_address);
87     }
88     
89     /* Internal transfer, only can be called by this contract */
90     function _transfer(address _from, address _to, uint _value) isLock internal {
91         initialize(_from);
92 
93         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
94         require (balances[_from] >= _value);               // Check if the sender has enough
95         require (balances[_to] + _value > balances[_to]); // Check for overflows
96         require(!frozenAccount[_from]);                     // Check if sender is frozen
97         require(!frozenAccount[_to]);                       // Check if recipient is frozen
98         balances[_from] -= _value;                         // Subtract from the sender
99         balances[_to] += _value;                           // Add the same to the recipient
100         emit Transfer(_from, _to, _value);
101     }
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public {
112         _transfer(msg.sender, _to, _value);
113     }
114 
115     /**
116      * Transfer tokens from other address
117      *
118      * Send `_value` tokens to `_to` in behalf of `_from`
119      *
120      * @param _from The address of the sender
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
125         require(_value <= allowed[_from][msg.sender]);     // Check allowance
126         allowed[_from][msg.sender] -= _value;
127         _transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      */
139     function approve(address _spender, uint256 _value) public returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147     /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) onlyOwner public returns (bool success) {
155         require(balances[msg.sender] >= _value);   // Check if the sender has enough
156         balances[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         emit Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
171         require(balances[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowed[_from][msg.sender]);    // Check allowance
173         balances[_from] -= _value;                         // Subtract from the targeted balance
174         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
175         totalSupply -= _value;                              // Update totalSupply
176         emit Burn(_from, _value);
177         return true;
178     }
179 
180     /// @notice Create `mintedAmount` tokens and send it to `target`
181     /// @param target Address to receive the tokens
182     /// @param mintedAmount the amount of tokens it will receive
183     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
184         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
185         balances[target] += _amount;
186         totalSupply += _amount;
187         emit Transfer(this, target, _amount);
188     }
189 
190     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
191     /// @param target Address to be frozen
192     /// @param freeze either to freeze it or not
193     function freezeAccount(address target, bool freeze) onlyOwner public {
194         frozenAccount[target] = freeze;
195         emit FrozenFunds(target, freeze);
196     }
197     // mint airdrop 
198     function mintAirdropToken(uint256 _mintedAmount) onlyOwner public {
199         uint256 _amount = _mintedAmount * 10 ** uint256(decimals);
200         totalSupply += _amount;
201         airdropTotalSupply += _amount;
202     }
203 
204     function setAirdropStatus(bool _status) onlyOwner public returns (bool status){
205         require(airdropTotalSupply > 0);
206         airdropStatus = _status;
207         return airdropStatus;
208     }
209     function setAirdropAmount(uint256 _amount) onlyOwner public{
210         airdropAmount = _amount * 10 ** uint256(decimals);
211     }
212     // internal private functions
213     function initialize(address _address) internal returns (bool success) {
214         if (airdropStatus && !touched[_address] && airdropCurrentTotal < airdropTotalSupply) {
215             touched[_address] = true;
216             airdropCurrentTotal += airdropAmount;
217             balances[_address] += airdropAmount;
218             emit AirDrop(_address, airdropAmount);
219         }
220         return true;
221     }
222 
223     function getBalance(address _address) internal returns (uint256) {
224         if (airdropStatus && !touched[_address] && airdropCurrentTotal < airdropTotalSupply) {
225             balances[_address] += airdropAmount;
226         }
227         return balances[_address];
228     }
229 }