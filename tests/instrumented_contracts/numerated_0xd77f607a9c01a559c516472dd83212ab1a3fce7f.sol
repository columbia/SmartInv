1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract Ownable {
6   address public owner;
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() {
13     owner = msg.sender;
14   }
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 }
24 
25 contract Pausable is Ownable {
26   event Pause();
27   event Unpause();
28 
29   bool public paused = false;
30 
31 
32   /**
33    * @dev Modifier to make a function callable only when the contract is not paused.
34    */
35   modifier whenNotPaused() {
36     require(!paused);
37     _;
38   }
39 
40   /**
41    * @dev Modifier to make a function callable only when the contract is paused.
42    */
43   modifier whenPaused() {
44     require(paused);
45     _;
46   }
47 
48   /**
49    * @dev called by the owner to pause, triggers stopped state
50    */
51   function pause() onlyOwner whenNotPaused public {
52     paused = true;
53     emit Pause();
54   }
55 
56   /**
57    * @dev called by the owner to unpause, returns to normal state
58    */
59   function unpause() onlyOwner whenPaused public {
60     paused = false;
61     emit Unpause();
62   }
63 }
64 
65 contract BlockchainMoneyEngine is Pausable {
66   address public owner;
67 
68   // Public variables of the token
69   string public name;
70   string public symbol;
71   uint8 public decimals = 18;
72   // 18 decimals is the strongly suggested default, avoid changing it
73   uint256 public totalSupply;
74 
75   // This creates an array with all balances
76   mapping (address => uint256) public balanceOf;
77   mapping (address => mapping (address => uint256)) public allowance;
78 
79   // This generates a public event on the blockchain that will notify clients
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 
82   // This notifies clients about the amount burnt
83   event Burn(address indexed from, uint256 value);
84 
85   /**
86    * Constructor function
87    *
88    * Initializes contract with initial supply tokens to the creator of the contract
89    */
90   function BlockchainMoneyEngine(
91     uint256 initialSupply,
92     string tokenName,
93     string tokenSymbol
94   ) public {
95     totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
96     balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
97     name = tokenName;                                   // Set the name for display purposes
98     symbol = tokenSymbol;                               // Set the symbol for display purposes
99     owner = msg.sender;
100   }
101 
102   function setName(string _name)
103   onlyOwner()
104   public
105   {
106     name = _name;
107   }
108 
109   function setSymbol(string _symbol)
110   onlyOwner()
111   public
112   {
113     symbol = _symbol;
114   }
115 
116   /**
117    * Internal transfer, only can be called by this contract
118    */
119   function _transfer(address _from, address _to, uint _value) internal {
120     // Prevent transfer to 0x0 address. Use burn() instead
121     require(_to != 0x0);
122     // Check if the sender has enough
123     require(balanceOf[_from] >= _value);
124     // Check for overflows
125     require(balanceOf[_to] + _value >= balanceOf[_to]);
126     // Save this for an assertion in the future
127     uint previousBalances = balanceOf[_from] + balanceOf[_to];
128     // Subtract from the sender
129     balanceOf[_from] -= _value;
130     // Add the same to the recipient
131     balanceOf[_to] += _value;
132     emit Transfer(_from, _to, _value);
133     // Asserts are used to use static analysis to find bugs in your code. They should never fail
134     assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
135   }
136   
137   function destruct() public {
138     if (owner == msg.sender) {
139       selfdestruct(owner);
140     }
141   }
142   
143   /**
144    * Transfer tokens
145    *
146    * Send `_value` tokens to `_to` from your account
147    *
148    * @param _to The address of the recipient
149    * @param _value the amount to send
150    */
151   function transfer(address _to, uint256 _value) public whenNotPaused {
152     _transfer(msg.sender, _to, _value);
153   }
154 
155   /**
156    * Transfer tokens from other address
157    *
158    * Send `_value` tokens to `_to` on behalf of `_from`
159    *
160    * @param _from The address of the sender
161    * @param _to The address of the recipient
162    * @param _value the amount to send
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
165     require(_value <= allowance[_from][msg.sender]);     // Check allowance
166     allowance[_from][msg.sender] -= _value;
167     _transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * Set allowance for other address
173    *
174    * Allows `_spender` to spend no more than `_value` tokens on your behalf
175    *
176    * @param _spender The address authorized to spend
177    * @param _value the max amount they can spend
178    */
179   function approve(address _spender, uint256 _value) public whenNotPaused
180   returns (bool success) {
181     allowance[msg.sender][_spender] = _value;
182     return true;
183   }
184 
185   /**
186    * Set allowance for other address and notify
187    *
188    * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
189    *
190    * @param _spender The address authorized to spend
191    * @param _value the max amount they can spend
192    * @param _extraData some extra information to send to the approved contract
193    */
194    
195   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
196   public
197   returns (bool success) {
198     tokenRecipient spender = tokenRecipient(_spender);
199     if (approve(_spender, _value)) {
200       spender.receiveApproval(msg.sender, _value, this, _extraData);
201       return true;
202     }
203   }
204 
205   /**
206    * Destroy tokens
207    *
208    * Remove `_value` tokens from the system irreversibly
209    *
210    * @param _value the amount of money to burn
211    */
212   function burn(uint256 _value) public returns (bool success) {
213     require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
214     balanceOf[msg.sender] -= _value;            // Subtract from the sender
215     totalSupply -= _value;                      // Updates totalSupply
216     emit Burn(msg.sender, _value);
217     return true;
218   }
219 
220   /**
221    * Destroy tokens from other account
222    *
223    * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
224    *
225    * @param _from the address of the sender
226    * @param _value the amount of money to burn
227    */
228   function burnFrom(address _from, uint256 _value) public returns (bool success) {
229     require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
230     require(_value <= allowance[_from][msg.sender]);    // Check allowance
231     balanceOf[_from] -= _value;                         // Subtract from the targeted balance
232     allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
233     totalSupply -= _value;                              // Update totalSupply
234     emit Burn(_from, _value);
235     return true;
236   }
237 }