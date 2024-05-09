1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract owned {
48     address public owner;
49     constructor() public {
50         owner = msg.sender;
51     }
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56     function transferOwnership(address _newOwner) onlyOwner public {
57         owner = _newOwner;
58     }
59 }
60 
61 contract GOG is owned {
62 
63     using SafeMath for uint256;
64     // Public variables of the GOG token
65     string public name;
66     string public symbol;
67     uint8 public decimals = 6;
68     // 6 decimals for GOG
69     uint256 public totalSupply;
70     bool public paused;
71 
72     // This creates an array with all balances
73     mapping (address => uint256) public balances;
74     // this creates an 2 x 2 array with allowances
75     mapping (address => mapping (address => uint256)) public allowance;
76     
77     // This generates a public event on the blockchain that will notify clients transfering of funds
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     // This notifies clients about the amount burnt
80     event Burn(address indexed from, uint256 value);
81     // This notifies clients about approval of allowances
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83     event Pause(address indexed owner);
84     event Unpause(address indexed owner);
85 
86     modifier onlyUnpaused() {
87       require(!paused);
88       _;
89     }
90 
91     /**
92      * Constrctor function
93      * Initializes contract with initial supply tokens to the creator of the contract
94      */
95     constructor() public {
96         totalSupply = 10000000000000000;               // GOG's total supply is 10 billion with 6 decimals
97         balances[msg.sender] = totalSupply;          // Give the creator all initial tokens
98         name = "GoGlobe Token";                       // Token name is GoGlobe Token
99         symbol = "GOG";                               // token symbol is GOG
100     }
101 
102     /**
103      * get the balance of account
104      * @param _owner The account address
105      */
106     function balanceOf(address _owner) view public returns (uint256) {
107         return balances[_owner];
108     }
109 
110     /**
111      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
112      * @param _spender The address which will spend the funds.
113      * @param _value The amount of tokens to be spent.
114      */
115     function approve(address _spender, uint256 _value) public onlyUnpaused returns (bool) {
116         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
117         allowance[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121     
122       /**
123    * @dev Increase the amount of tokens that an owner allowed to a spender.
124    *
125    * approve should be called when allowed[_spender] == 0. To increment
126    * allowed value is better to use this function to avoid 2 calls (and wait until
127    * the first transaction is mined)
128    * From MonolithDAO Token.sol
129    * @param _spender The address which will spend the funds.
130    * @param _addedValue The amount of tokens to increase the allowance by.
131    */
132   function increaseApproval(address _spender, uint _addedValue) public onlyUnpaused returns (bool) {
133     allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
134     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
135     return true;
136   }
137 
138   /**
139    * @dev Decrease the amount of tokens that an owner allowed to a spender.
140    *
141    * approve should be called when allowed[_spender] == 0. To decrement
142    * allowed value is better to use this function to avoid 2 calls (and wait until
143    * the first transaction is mined)
144    * From MonolithDAO Token.sol
145    * @param _spender The address which will spend the funds.
146    * @param _subtractedValue The amount of tokens to decrease the allowance by.
147    */
148   function decreaseApproval(address _spender, uint _subtractedValue) public onlyUnpaused returns (bool) {
149     uint oldValue = allowance[msg.sender][_spender];
150     if (_subtractedValue > oldValue) {
151       allowance[msg.sender][_spender] = 0;
152     } else {
153       allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154     }
155     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
156     return true;
157   }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowance to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifing the amount of tokens still avaible for the spender.
164      */
165     function allowance(address _owner, address _spender) view public returns (uint256) {
166         return allowance[_owner][_spender];
167     }
168 
169     /**
170      * Internal transfer, only can be called by this contract
171      */
172     function _transfer(address _from, address _to, uint _value) internal {
173         // Prevent transfer to 0x0 address. Use burn() instead
174         require(_to != address(0));
175 
176         // Check if the sender has enough
177         require(balances[_from] >= _value);
178         // Save this for an assertion in the future
179         uint previousBalances = balances[_from].add(balances[_to]);
180         // Subtract from the sender
181         balances[_from] = balances[_from].sub(_value);
182         // Add the same to the recipient
183         balances[_to] = balances[_to].add(_value);
184         emit Transfer(_from, _to, _value);
185         // Asserts are used to use static analysis to find bugs in your code. They should never fail
186         assert(balances[_from] + balances[_to] == previousBalances);
187     }
188 
189     /**
190      * Transfer tokens
191      * Send `_value` tokens to `_to` from your account
192      * @param _to The address of the recipient
193      * @param _value the amount to send
194      */
195     function transfer(address _to, uint256 _value) public onlyUnpaused {
196         _transfer(msg.sender, _to, _value);
197     }
198 
199     /**
200      * Transfer tokens from other address
201      * Send `_value` tokens to `_to` on behalf of `_from`
202      * @param _from The address of the sender
203      * @param _to The address of the recipient
204      * @param _value the amount to send
205      */
206     function transferFrom(address _from, address _to, uint256 _value) public onlyUnpaused returns (bool) {
207         require(_value <= allowance[_from][msg.sender]);     // Check allowance
208         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
209         _transfer(_from, _to, _value);
210         return true;
211     }
212 
213     /**
214      * Destroy tokens
215      * Remove `_value` tokens from the system irreversibly
216      * @param _value the amount of money to burn
217      */
218     function burn(uint256 _value) public onlyUnpaused returns (bool) {
219         require(balances[msg.sender] >= _value);   // Check if the sender has enough
220         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
221         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
222         emit Burn(msg.sender, _value);
223         return true;
224     }
225 
226     /**
227      * Destroy tokens from other account
228      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
229      * @param _from the address of the sender
230      * @param _value the amount of money to burn
231      */
232     function burnFrom(address _from, uint256 _value) public onlyUnpaused returns (bool) {
233         require(balances[_from] >= _value);                // Check if the targeted balance is enough
234         require(_value <= allowance[_from][msg.sender]);    // Check allowance
235         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
236         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
237         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
238         emit Burn(_from, _value);
239         return true;
240     }
241 
242     function pause() public onlyOwner returns (bool) {
243       paused = true;
244       return true;
245     }
246 
247     function unPause() public onlyOwner returns (bool) {
248       paused = false;
249       return true;
250     }
251 }