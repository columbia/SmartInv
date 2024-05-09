1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 constant public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = tokenName;                                   // Set the name for display purposes
32         symbol = tokenSymbol;                               // Set the symbol for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint256 _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens from other address
70      *
71      * Send `_value` tokens to `_to` on behalf of `_from`
72      *
73      * @param _from The address of the sender
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     // Check allowance
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Set allowance for other address
86      *
87      * Allows `_spender` to spend no more than `_value` tokens on your behalf
88      *
89      * @param _spender The address authorized to spend
90      * @param _value the max amount they can spend
91      */
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         require(_spender != address(0));
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address and notify
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      * @param _extraData some extra information to send to the approved contract
106      */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
108         tokenRecipient spender = tokenRecipient(_spender);
109         if (approve(_spender, _value)) {
110             spender.receiveApproval(msg.sender, _value, this, _extraData);
111             return true;
112         }
113     }
114 
115     /**
116      * Destroy tokens
117      *
118      * Remove `_value` tokens from the system irreversibly
119      *
120      * @param _value the amount of money to burn
121      */
122     function burn(uint256 _value) public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
124         balanceOf[msg.sender] -= _value;            // Subtract from the sender
125         totalSupply -= _value;                      // Updates totalSupply
126         Burn(msg.sender, _value);
127         return true;
128     }
129 
130     /**
131      * Destroy tokens from other account
132      *
133      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
134      *
135      * @param _from the address of the sender
136      * @param _value the amount of money to burn
137      */
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
140         require(_value <= allowance[_from][msg.sender]);    // Check allowance
141         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
142         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
143         totalSupply -= _value;                              // Update totalSupply
144         Burn(_from, _value);
145         return true;
146     }
147 }
148 
149 contract OwnableToken is TokenERC20 {
150     address public owner;
151 
152     function OwnableToken(uint256 initialSupply, string tokenName, string tokenSymbol) public TokenERC20(initialSupply, tokenName, tokenSymbol) {
153         owner = msg.sender;
154     }
155 
156     function setOwner(address newOwner) public onlyOwner {
157         require(newOwner != address(0));
158         owner = newOwner;
159     }
160 
161     modifier onlyOwner {
162         require(msg.sender == owner);
163         _;
164     }
165 }
166 
167 contract StoppableToken is OwnableToken {
168     bool public stopped;
169     function StoppableToken(uint256 initialSupply, string tokenName, string tokenSymbol) public OwnableToken(initialSupply, tokenName, tokenSymbol) {
170         stopped = false;
171     }
172 
173     function stop() public onlyOwner {
174         require(stopped == false);
175         stopped = true;
176     }
177 
178     function resume() public onlyOwner {
179         require(stopped == true);
180         stopped = false;
181     }
182     
183     function transfer(address to, uint256 value) public {
184         require(stopped == false);
185         super.transfer(to, value);
186     }
187 
188     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
189         require(stopped == false);
190         return super.transferFrom(from, to, value);
191     }
192 
193     function approve(address spender, uint256 value) public returns (bool success) {
194         require(stopped == false);
195         return super.approve(spender, value);
196     }
197 
198     function burn(uint256 value) public onlyOwner returns (bool success) {
199         return super.burn(value);
200     }
201 
202     function burnFrom(address from, uint256 value) public onlyOwner returns (bool success) {
203         return super.burnFrom(from, value);
204     }
205 }
206 
207 contract CTToken is StoppableToken {
208     // Token constants
209     uint256 constant CTTOKEN_TOTAL_SUPLY = 20000000000; // total 20 billion
210     string constant CTTOKEN_NAME = "CrypTube";
211     string constant CTTOKEN_SYMBOL = "CT";
212     // Lock constants
213     uint256 constant OWNER_LOCKED_BALANCE_RELEASE_PERIOD_LEN_IN_SEC = 180 days;
214     uint16 constant OWNER_LOCKED_BALANCE_TOTAL_RELEASE_TIMES = 4;
215     uint256 constant OWNER_LOCKED_BALANCE_RELEASE_NUM_PER_TIMES = 750000000;
216 
217     uint256 public ownerLockedBalance;
218     uint256 public tokenCreateUtcTimeInSec;
219 
220     function CTToken() public StoppableToken(CTTOKEN_TOTAL_SUPLY, CTTOKEN_NAME, CTTOKEN_SYMBOL) {
221         tokenCreateUtcTimeInSec = block.timestamp;
222         ownerLockedBalance = OWNER_LOCKED_BALANCE_RELEASE_NUM_PER_TIMES * OWNER_LOCKED_BALANCE_TOTAL_RELEASE_TIMES * 10 ** uint256(decimals);
223         require(balanceOf[msg.sender] >= ownerLockedBalance);
224         balanceOf[msg.sender] -= ownerLockedBalance;
225     }
226 
227     // refuse any payment
228     function () public {
229         revert();
230     }
231 
232     function time() public view returns (uint) {
233         return block.timestamp;
234     }
235 
236     function unlockToken() public onlyOwner {
237         require(ownerLockedBalance > 0);
238         require(block.timestamp > tokenCreateUtcTimeInSec);
239         uint256 pastPeriodsSinceTokenCreate = (block.timestamp - tokenCreateUtcTimeInSec) / OWNER_LOCKED_BALANCE_RELEASE_PERIOD_LEN_IN_SEC;
240         if (pastPeriodsSinceTokenCreate > OWNER_LOCKED_BALANCE_TOTAL_RELEASE_TIMES) {
241             pastPeriodsSinceTokenCreate = OWNER_LOCKED_BALANCE_TOTAL_RELEASE_TIMES;
242         }
243         uint256 balanceShouldBeLocked = ((OWNER_LOCKED_BALANCE_TOTAL_RELEASE_TIMES - pastPeriodsSinceTokenCreate) * OWNER_LOCKED_BALANCE_RELEASE_NUM_PER_TIMES) * 10 ** uint256(decimals);
244         require(balanceShouldBeLocked < ownerLockedBalance);
245         uint256 balanceShouldBeUnlock = ownerLockedBalance - balanceShouldBeLocked;
246         ownerLockedBalance -= balanceShouldBeUnlock;
247         balanceOf[msg.sender] += balanceShouldBeUnlock;
248     }
249 }