1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79     event Paused(address account);
80     event Unpaused(address account);
81 
82     bool private _paused;
83 
84     constructor () internal {
85         _paused = false;
86     }
87 
88     /**
89      * @return true if the contract is paused, false otherwise.
90      */
91     function paused() public view returns (bool) {
92         return _paused;
93     }
94 
95     /**
96      * @dev Modifier to make a function callable only when the contract is not paused.
97      */
98     modifier whenNotPaused() {
99         require(!_paused);
100         _;
101     }
102 
103     /**
104      * @dev Modifier to make a function callable only when the contract is paused.
105      */
106     modifier whenPaused() {
107         require(_paused);
108         _;
109     }
110 
111     /**
112      * @dev called by the owner to pause, triggers stopped state
113      */
114     function pause() public onlyOwner whenNotPaused {
115         _paused = true;
116         emit Paused(msg.sender);
117     }
118 
119     /**
120      * @dev called by the owner to unpause, returns to normal state
121      */
122     function unpause() public onlyOwner whenPaused {
123         _paused = false;
124         emit Unpaused(msg.sender);
125     }
126 }
127 
128 interface tokenRecipient { 
129     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
130 }
131 
132 contract TokenERC20 is Pausable{
133     // Public variables of the token
134     string public name;
135     string public symbol;
136     uint8 public decimals = 0;
137     // 18 decimals is the strongly suggested default, avoid changing it
138     uint256 public totalSupply;
139 
140     // This creates an array with all balances
141     mapping (address => uint256) public balanceOf;
142     mapping (address => mapping (address => uint256)) public allowance;
143 
144     // This generates a public event on the blockchain that will notify clients
145     event Transfer(address indexed from, address indexed to, uint256 value);
146     
147     // This generates a public event on the blockchain that will notify clients
148     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
149 
150     // This notifies clients about the amount burnt
151     event Burn(address indexed from, uint256 value);
152 
153     /**
154      * Constructor function
155      *
156      * Initializes contract with initial supply tokens to the creator of the contract
157      */
158     constructor(
159         uint256 initialSupply,
160         string memory tokenName,
161         string memory tokenSymbol
162     ) public {
163         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
164         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
165         name = tokenName;                                   // Set the name for display purposes
166         symbol = tokenSymbol;                               // Set the symbol for display purposes
167     }
168 
169     /**
170      * Internal transfer, only can be called by this contract
171      */
172     function _transfer(address _from, address _to, uint _value) whenNotPaused internal {
173         // Prevent transfer to 0x0 address. Use burn() instead
174         require(_to != address(0x0));
175         // Check if the sender has enough
176         require(balanceOf[_from] >= _value);
177         // Check for overflows
178         require(balanceOf[_to] + _value >= balanceOf[_to]);
179         // Save this for an assertion in the future
180         uint previousBalances = balanceOf[_from] + balanceOf[_to];
181         // Subtract from the sender
182         balanceOf[_from] -= _value;
183         // Add the same to the recipient
184         balanceOf[_to] += _value;
185         emit Transfer(_from, _to, _value);
186         // Asserts are used to use static analysis to find bugs in your code. They should never fail
187         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
188     }
189 
190     /**
191      * Transfer tokens
192      *
193      * Send `_value` tokens to `_to` from your account
194      *
195      * @param _to The address of the recipient
196      * @param _value the amount to send
197      */
198     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
199         _transfer(msg.sender, _to, _value);
200         return true;
201     }
202 
203     /**
204      * Transfer tokens from other address
205      *
206      * Send `_value` tokens to `_to` on behalf of `_from`
207      *
208      * @param _from The address of the sender
209      * @param _to The address of the recipient
210      * @param _value the amount to send
211      */
212     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
213         require(_value <= allowance[_from][msg.sender]);     // Check allowance
214         allowance[_from][msg.sender] -= _value;
215         _transfer(_from, _to, _value);
216         return true;
217     }
218 
219     /**
220      * Set allowance for other address
221      *
222      * Allows `_spender` to spend no more than `_value` tokens on your behalf
223      *
224      * @param _spender The address authorized to spend
225      * @param _value the max amount they can spend
226      */
227     function approve(address _spender, uint256 _value) whenNotPaused public
228         returns (bool success) {
229         allowance[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     }
233 
234     /**
235      * Set allowance for other address and notify
236      *
237      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
238      *
239      * @param _spender The address authorized to spend
240      * @param _value the max amount they can spend
241      * @param _extraData some extra information to send to the approved contract
242      */
243     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
244         whenNotPaused
245         public
246         returns (bool success) {
247         tokenRecipient spender = tokenRecipient(_spender);
248         if (approve(_spender, _value)) {
249             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
250             return true;
251         }
252     }
253 
254     /**
255      * Destroy tokens
256      *
257      * Remove `_value` tokens from the system irreversibly
258      *
259      * @param _value the amount of money to burn
260      */
261     function burn(uint256 _value) whenNotPaused public returns (bool success) {
262         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
263         balanceOf[msg.sender] -= _value;            // Subtract from the sender
264         totalSupply -= _value;                      // Updates totalSupply
265         emit Burn(msg.sender, _value);
266         return true;
267     }
268 
269     /**
270      * Destroy tokens from other account
271      *
272      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
273      *
274      * @param _from the address of the sender
275      * @param _value the amount of money to burn
276      */
277     function burnFrom(address _from, uint256 _value) whenNotPaused public returns (bool success) {
278         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
279         require(_value <= allowance[_from][msg.sender]);    // Check allowance
280         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
281         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
282         totalSupply -= _value;                              // Update totalSupply
283         emit Burn(_from, _value);
284         return true;
285     }
286     
287     function mintToken(uint256 _mintedAmount) onlyOwner whenNotPaused public returns (bool success){
288         require( balanceOf[msg.sender] + _mintedAmount>_mintedAmount);
289         balanceOf[msg.sender] += _mintedAmount;
290         totalSupply += _mintedAmount;
291         emit Transfer(address(0), msg.sender, _mintedAmount);
292         emit Transfer(msg.sender, msg.sender, _mintedAmount);
293         return true;
294     }
295     
296 }