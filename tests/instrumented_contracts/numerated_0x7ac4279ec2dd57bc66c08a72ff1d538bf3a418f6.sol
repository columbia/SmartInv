1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'Balloon' Smart token contract
4 //
5 // Deployed to : 
6 // Symbol      : ABA
7 // Name        : Balloon Token
8 // Total supply: 100'000,000
9 // Decimals    : 18
10 //
11 // Create and Modify at some code by Compusam - Aballoon company
12 //
13 // (c) Base contract and help by source from the good internet
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, reverts on overflow.
23   */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38   /**
39   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
40   */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b > 0); // Solidity only automatically asserts when dividing by 0
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 
49   /**
50   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
51   */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b <= a);
54         uint256 c = a - b;
55 
56         return c;
57     }
58 
59   /**
60   * @dev Adds two numbers, reverts on overflow.
61   */
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a);
65 
66         return c;
67     }
68 
69   /**
70   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
71   * reverts when dividing by zero.
72   */
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b != 0);
75         return a % b;
76     }
77 }
78 
79 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
80 
81 contract TokenERC20 {
82 
83     using SafeMath for uint256;
84     // Public variables of the token
85     string public name;
86     string public symbol;
87     uint8 public decimals = 18;
88     // 18 decimals is the strongly suggested default, avoid changing it
89     uint256 public totalSupply;
90     uint public totalSoldSupply;
91     address owner = msg.sender;
92 
93     // This creates an array with all balances
94     mapping (address => uint256) public balanceOf;
95     mapping (address => mapping (address => uint256)) public allowance;
96 
97     // This generates a public event on the blockchain that will notify clients
98     event Transfer(address indexed from, address indexed to, uint256 value);
99     event FundTransfer(address backer, uint amount, bool isContribution);
100     event ActualSupply(uint totalsupply, uint initialsupply);
101 
102     
103     // This generates a public event on the blockchain that will notify clients
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 
106     // This notifies clients about the amount burnt
107     event Burn(address indexed from, uint256 value);
108 
109     /**
110      * Constructor function
111      *
112      * Initializes contract with initial supply tokens to the creator of the contract
113      */
114     constructor(
115         uint256 initialSupply,
116         string tokenName,
117         string tokenSymbol
118     ) public {
119         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
120         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
121         name = tokenName;                                   // Set the name for display purposes
122         symbol = tokenSymbol;                               // Set the symbol for display purposes
123         totalSoldSupply = 0;
124     }
125 
126     /**
127      * Internal transfer, only can be called by this contract
128      */
129     function _transfer(address _from, address _to, uint _value) internal {
130         // Prevent transfer to 0x0 address. Use burn() instead
131         require(_to != 0x0);
132         // Check if the sender has enough
133         require(balanceOf[_from] >= _value);
134         // Check for overflows
135         require(balanceOf[_to] + _value >= balanceOf[_to]);
136         // Save this for an assertion in the future
137         uint previousBalances = balanceOf[_from] + balanceOf[_to];
138         // Subtract from the sender
139         balanceOf[_from] -= _value;
140         // Add the same to the recipient
141         balanceOf[_to] += _value;
142         emit Transfer(_from, _to, _value);
143         // Asserts are used to use static analysis to find bugs in your code. They should never fail
144         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
145     }
146 
147     /**
148      * Transfer tokens
149      *
150      * Send `_value` tokens to `_to` from your account
151      *
152      * @param _to The address of the recipient
153      * @param _value the amount to send
154      */
155     function transfer(address _to, uint256 _value) public returns (bool success) {
156         _transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161      * Transfer tokens from other address
162      *
163      * Send `_value` tokens to `_to` on behalf of `_from`
164      *
165      * @param _from The address of the sender
166      * @param _to The address of the recipient
167      * @param _value the amount to send
168      */
169     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
170         require(_value <= allowance[_from][msg.sender]);     // Check allowance
171         allowance[_from][msg.sender] -= _value;
172         _transfer(_from, _to, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens on your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) public
185         returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         emit Approval(msg.sender, _spender, _value);
188         return true;
189     }
190 
191     /**
192      * Set allowance for other address and notify
193      *
194      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
195      *
196      * @param _spender The address authorized to spend
197      * @param _value the max amount they can spend
198      * @param _extraData some extra information to send to the approved contract
199      */
200     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
201         public
202         returns (bool success) {
203         tokenRecipient spender = tokenRecipient(_spender);
204         if (approve(_spender, _value)) {
205             spender.receiveApproval(msg.sender, _value, this, _extraData);
206             return true;
207         }
208     }
209 
210     /**
211      * Destroy tokens
212      *
213      * Remove `_value` tokens from the system irreversibly
214      *
215      * @param _value the amount of money to burn
216      */
217     function burn(uint256 _value) public returns (bool success) {
218         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
219         balanceOf[msg.sender] -= _value;            // Subtract from the sender
220         totalSupply -= _value;                      // Updates totalSupply
221         emit Burn(msg.sender, _value);
222         return true;
223     }
224     
225     // ------------------------------------------------------------------------
226     // Para saber las stats actuales
227     // ------------------------------------------------------------------------
228     function getStats() public view returns (uint256, uint256) {
229         return (totalSoldSupply, totalSupply);
230     }
231 
232     /**
233      * Fallback function
234      *
235      * The function without name is the default function that is called whenever anyone sends funds to a contract
236      */
237     function () payable public {
238         
239         uint256 amount = msg.value;
240         uint256 tokens;
241         tokens = amount.mul(2000);
242         // _transfer(owner,msg.sender, tokens);
243         // add safeMath
244         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
245         //balanceOf[msg.sender] += tokens;
246         totalSoldSupply = totalSoldSupply.add(tokens);
247         //_initialSupply += tokens;
248         // For decre the totalsupply
249         totalSupply = totalSupply.sub(tokens);
250         balanceOf[owner] = balanceOf[owner].sub(tokens);
251         emit ActualSupply(totalSupply, totalSoldSupply);
252         // balanceOf[owner] -= tokens;          // Subtract from the sender
253         // totalSupply -= tokens; // Updates totalSupply
254         // emit Burn(owner, tokens);
255         // para depositarle los Ethers a la cuenta maestra
256         owner.transfer(msg.value);
257         emit FundTransfer(msg.sender, amount, true);
258     }
259     /**
260      * Destroy tokens from other account
261      *
262      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
263      *
264      * @param _from the address of the sender
265      * @param _value the amount of money to burn
266      */
267     function burnFrom(address _from, uint256 _value) public returns (bool success) {
268         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
269         require(_value <= allowance[_from][msg.sender]);    // Check allowance
270         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
271         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
272         totalSupply -= _value;                              // Update totalSupply
273         emit Burn(_from, _value);
274         return true;
275     }
276 }