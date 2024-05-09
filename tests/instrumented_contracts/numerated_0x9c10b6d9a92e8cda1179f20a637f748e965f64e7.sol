1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5     
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         require(newOwner != address(0));
20         require(newOwner != owner);  //check that ownership is not being transferred to self.
21         OwnershipTransferred(owner, newOwner);
22         owner = newOwner;
23     }
24 }
25 
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
28 
29 
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 contract TokenERC20 {
61     
62     using SafeMath for uint256;
63     
64     // This creates an array with all balances
65     mapping (address => uint256) public balanceOf;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     // This generates a public event on the blockchain that will notify clients
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * Internal transfer, only can be called by this contract
73      */
74     function _transfer(address _from, address _to, uint _value) internal {
75         
76         // Prevent transfer to 0x0 address. Use burn() instead
77         require(_to != 0x0);
78         // Check if the sender has enough
79         require(balanceOf[_from] >= _value);
80         // Check for overflows
81         require(balanceOf[_to] + _value > balanceOf[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
84         
85         // Subtract from the sender .. Add the same to the recipient
86         balanceOf[_from] = balanceOf[_from].sub(_value);
87         balanceOf[_to] = balanceOf[_to].add(_value);
88         
89         Transfer(_from, _to, _value);
90         // Asserts are used to use static analysis to find bugs in your code. They should never fail
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public
103         returns (bool success) {
104         allowance[msg.sender][_spender] = _value;
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127 }
128 
129 /******************************************/
130 /*       KONIOS TOKEN STARTS HERE       */
131 /******************************************/
132 
133 
134 contract KoniosToken is owned, TokenERC20 {
135 
136     // Public variables of the token
137     string public name;
138     string public symbol;
139     uint8 public decimals = 18;
140     // 18 decimals is the strongly suggested default, avoid changing it
141     uint256 public totalSupply;
142     
143     uint256 public soldTokens ;
144     
145     uint256 public remainingTokens ;
146 
147     uint256 startBlock; //crowdsale start block (set in constructor)
148 
149     uint256 teamLockup = 4505142; //team allocation cannot be created until this many blocks after endBlock (assuming 14 second blocks, this is 2 years)
150 
151     uint256 teamAllocation = 250000000 * 10 ** uint256(decimals); //5% of token supply(5,000,000,000) allocated post-crowdsale for the team fund
152     bool teamAllocated = false; //this will change to true when the team fund is allocated
153 
154     mapping (address => bool) public frozenAccount;
155 
156     /* This generates a public event on the blockchain that will notify clients */
157     event FrozenFunds(address target, bool frozen);
158 
159     /* This notifies clients about the amount allocated to team fund */
160     event AllocateTeamTokens(address indexed from, uint256 value);
161     
162      /* This notifies clients about the amount burned */
163     event Burn(address indexed from, uint256 value);
164 
165     /* Initializes contract with initial supply tokens to the creator of the contract */
166     function KoniosToken(
167         uint256 initialSupply,
168         string tokenName,
169         string tokenSymbol
170     ) public {
171             
172             totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
173             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
174             name = tokenName;                                   // Set the name for display purposes
175             symbol = tokenSymbol;                               // Set the symbol for display purposes
176             startBlock = block.number;
177             
178             remainingTokens = totalSupply ; //set the initial value of remainingTokens as totalSupply in the constructor
179 
180     }
181 
182     /**
183      * Transfer tokens
184      *
185      * Send `_value` tokens to `_to` from your account
186      *
187      * @param _to The address of the recipient
188      * @param _value the amount to send
189      */
190     function transfer(address _to, uint256 _value) public {
191         _transfer(msg.sender, _to, _value);
192         soldTokens = soldTokens.add(_value);
193         remainingTokens = remainingTokens.sub(_value);
194     }
195 
196     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
197     /// @param target Address to be frozen
198     /// @param freeze either to freeze it or not
199     function freezeAccount(address target, bool freeze) onlyOwner public {
200         frozenAccount[target] = freeze;
201         FrozenFunds(target, freeze);
202     }
203 
204     /**
205      * Set team tokens.
206      *
207      * Security review
208      *
209      * - Integer math: ok - only called once with fixed parameters
210      *
211      * Applicable tests:
212      *
213      * - Test founder token allocation too early
214      * - Test founder token allocation on time
215      * - Test founder token allocation twice
216      *
217      */
218     function allocateTeamTokens() onlyOwner public returns (bool success){
219         require( (startBlock + teamLockup) > block.number);          // Check if it is time to allocate team tokens
220         require(!teamAllocated);
221         //check if team tokens have already been allocated
222         balanceOf[msg.sender] = balanceOf[msg.sender].add(teamAllocation);
223         totalSupply = totalSupply.add(teamAllocation);
224         teamAllocated = true;
225         AllocateTeamTokens(msg.sender, teamAllocation);
226         return true;
227     }
228     
229     
230     /**
231      * Destroy tokens
232      *
233      * Remove `_value` tokens from the system irreversibly
234      *
235      * @param _value the amount of money to burn
236      */
237     function burn(uint256 _value) onlyOwner public returns (bool success) {
238         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
239         balanceOf[msg.sender] -= _value;            // Subtract from the sender
240         totalSupply -= _value;                      // Updates totalSupply
241         Burn(msg.sender, _value);
242         return true;
243     }
244 
245     /**
246      * Destroy tokens from other account
247      *
248      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
249      *
250      * @param _from the address of the sender
251      * @param _value the amount of money to burn
252      */
253     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
254         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
255         require(_value <= allowance[_from][msg.sender]);    // Check allowance
256         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
257         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
258         totalSupply -= _value;                              // Update totalSupply
259         Burn(_from, _value);
260         return true;
261     }
262 
263 
264 }