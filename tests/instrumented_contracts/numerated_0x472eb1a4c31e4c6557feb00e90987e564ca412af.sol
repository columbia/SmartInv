1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b; 
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Owned {
32     address public owner;
33 
34     constructor() public {
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
48 contract Pausable is Owned {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     emit Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     emit Unpause();
85   }
86 }
87 
88 contract TokenERC20  is Pausable{
89     // This creates an array with all balances
90     mapping (address => uint256) public balanceOf;
91     mapping (address => mapping (address => uint256)) public allowance;
92 
93     // This generates a public event on the blockchain that will notify clients
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     
96     // This generates a public event on the blockchain that will notify clients
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 
99     // This notifies clients about the amount burnt
100     event Burn(address indexed from, uint256 value);
101 
102     /**
103      * Constructor function
104      *
105      * Initializes contract with initial supply tokens to the creator of the contract
106      */
107 
108 
109     /**
110      * Internal transfer, only can be called by this contract
111      */
112     function _transfer(address _from, address _to, uint _value) internal {
113         // Prevent transfer to 0x0 address. Use burn() instead
114         require(_to != 0x0);
115         // Check if the sender has enough
116         require(balanceOf[_from] >= _value);
117         // Check for overflows
118         require(balanceOf[_to] + _value >= balanceOf[_to]);
119         // Save this for an assertion in the future
120         uint previousBalances = balanceOf[_from] + balanceOf[_to];
121         // Subtract from the sender
122         balanceOf[_from] -= _value;
123         // Add the same to the recipient
124         balanceOf[_to] += _value;
125         emit Transfer(_from, _to, _value);
126         // Asserts are used to use static analysis to find bugs in your code. They should never fail
127         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
128     }
129 
130     /**
131      * Transfer tokens
132      *
133      * Send `_value` tokens to `_to` from your account
134      *
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
139         _transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     /**
144      * Transfer tokens from other address
145      *
146      * Send `_value` tokens to `_to` on behalf of `_from`
147      *
148      * @param _from The address of the sender
149      * @param _to The address of the recipient
150      * @param _value the amount to send
151      */
152     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
153         require(_value <= allowance[_from][msg.sender]);     // Check allowance
154         allowance[_from][msg.sender] -= _value;
155         _transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address
161      *
162      * Allows `_spender` to spend no more than `_value` tokens on your behalf
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      */
167     function approve(address _spender, uint256 _value) whenNotPaused public
168         returns (bool success) { 
169         allowance[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 
174     /**
175      * Set allowance for other address and notify
176      *
177      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
178      *
179      * @param _spender The address authorized to spend
180      * @param _value the max amount they can spend
181      * @param _extraData some extra information to send to the approved contract
182      */
183     function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused
184         public
185         returns (bool success) {
186         tokenRecipient spender = tokenRecipient(_spender);
187         if (approve(_spender, _value)) {
188             spender.receiveApproval(msg.sender, _value, this, _extraData);
189             return true;
190         }
191     }
192 }
193 
194 contract MogoToken is TokenERC20{
195     // Public variables of the token
196     string public name = "Morgan Option";
197     string public symbol = "mogo";
198     uint8 public decimals = 18;
199     // 18 decimals is the strongly suggested default, avoid changing it
200     uint256 public totalSupply = 200000000 * 10 ** uint256(decimals);
201 
202     mapping (address => bool) public frozenAccount;
203 
204     /* This generates a public event on the blockchain that will notify clients */
205     event FrozenFunds(address target, bool frozen);
206     
207     constructor() public{
208         balanceOf[msg.sender] = totalSupply;     
209     }
210 
211     function _transfer(address _from, address _to, uint _value) internal {
212         // Prevent transfer to 0x0 address. Use burn() instead
213         require(_to != 0x0);
214         // Check if the sender has enough
215         require(balanceOf[_from] >= _value);
216         // Check for overflows
217         require(balanceOf[_to] + _value >= balanceOf[_to]);
218         require(!frozenAccount[_from]);                     
219         // Check if sender is frozen
220         require(!frozenAccount[_to]);  
221         // Save this for an assertion in the future
222         uint previousBalances = balanceOf[_from] + balanceOf[_to];
223         // Subtract from the sender
224         balanceOf[_from] -= _value;
225         // Add the same to the recipient
226         balanceOf[_to] += _value;
227         emit Transfer(_from, _to, _value);
228         // Asserts are used to use static analysis to find bugs in your code. They should never fail
229         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
230     }
231     
232     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
233     /// @param target Address to be frozen
234     /// @param freeze either to freeze it or not
235     function freezeAccount(address target, bool freeze) onlyOwner public {
236         frozenAccount[target] = freeze;
237         emit FrozenFunds(target, freeze);
238     }
239     
240     /// @param addrs Address array
241     /// @param balances balance array 
242     function batchTransfer(address[] addrs, uint256[] balances) onlyOwner public {
243         require(addrs.length == balances.length);
244         uint totalValue;
245         for (uint i = 0; i < addrs.length; i++) {
246             uint value = balances[i];
247             balanceOf[addrs[i]] += value;
248             emit Transfer(owner, addrs[i], value);
249             totalValue = SafeMath.add(value,totalValue);
250         }
251         require(balanceOf[owner]>totalValue);
252         balanceOf[owner] -= totalValue;   
253     }
254     
255     /**
256      * Destroy tokens
257      *
258      * Remove `_value` tokens from the system irreversibly
259      *
260      * @param _value the amount of money to burn
261      */
262     function burn(uint256 _value) onlyOwner public returns (bool success) {
263         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
264         balanceOf[msg.sender] -= _value;            // Subtract from the sender
265         totalSupply -= _value;                      // Updates totalSupply
266         emit Burn(msg.sender, _value);
267         return true;
268     }
269 }