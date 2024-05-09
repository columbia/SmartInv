1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Owned {
35     address public owner;
36 
37     function Owned() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner public {
47         owner = newOwner;
48     }
49 }
50 
51 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
52 
53 contract TokenERC20 {
54     using SafeMath for uint;
55     
56     string public name;
57     string public symbol;
58     uint8 public decimals = 18;
59 
60     uint256 public totalSupply;
61    
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64    
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     function TokenERC20(
68         uint256 initialSupply,
69         string tokenName,
70         string tokenSymbol
71     ) public {
72         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
73         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
74         name = tokenName;                                       // Set the name for display purposes
75         symbol = tokenSymbol;                                   // Set the symbol for display purposes
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public 
100         returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102 
103         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
104         _transfer(_from, _to, _value);
105 
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }   
140 
141     /**
142      * Internal transfer, only can be called by this contract
143      */
144     function _transfer(address _from, address _to, uint _value) internal {
145         // Prevent transfer to 0x0 address. Use burn() instead
146         require(_to != 0x0);
147         // Check if the sender has enough
148         require(balanceOf[_from] >= _value);
149         // Check for overflows
150         require(balanceOf[_to] + _value > balanceOf[_to]);
151 
152 
153         // Subtract from the sender
154         balanceOf[_from] = balanceOf[_from].sub(_value);
155         // Add the same to the recipient
156         balanceOf[_to] = balanceOf[_to].add(_value);
157 
158 
159         emit Transfer(_from, _to, _value);
160     } 
161 }
162 
163 contract WEKUToken is Owned, TokenERC20 {
164     
165     string public constant TOKEN_SYMBOL  = "WEKU"; 
166     string public constant TOKEN_NAME    = "WEKU Token";  
167     uint public constant INITIAL_SUPPLLY = 4 * 10 ** 8; 
168 
169     uint256 deployedTime;   // the time this constract is deployed.
170     address team;           // team account
171     uint256 teamTotal;      // total amount of token assigned to team.    
172     uint256 teamWithdrawed; // total withdrawed of team account
173 
174     mapping (address => bool) public frozenAccount;
175 
176     event FrozenFunds(address target, bool frozen);
177 
178     function WEKUToken(
179         address _team
180     ) TokenERC20(INITIAL_SUPPLLY, TOKEN_NAME, TOKEN_SYMBOL) public {
181         deployedTime = now;
182         team = _team; 
183         teamTotal = (INITIAL_SUPPLLY * 10 ** 18) / 5; 
184         // assign 20% to team team once and only once.         
185         _transfer(owner, team, teamTotal);
186     }
187 
188     /**
189      * Transfer tokens
190      *
191      * Send `_value` tokens to `_to` from your account
192      *
193      * @param _to The address of the recipient
194      * @param _value the amount to send
195      */
196     function transfer(address _to, uint256 _value) public {
197         _transfer(msg.sender, _to, _value);
198     }
199 
200     
201     /// @notice Create `mintedAmount` tokens and send it to `target`
202     /// @param target Address to receive the tokens
203     /// @param mintedAmount the amount of tokens it will receive
204     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
205         balanceOf[target] = balanceOf[target].add(mintedAmount);
206         totalSupply = totalSupply.add(mintedAmount);
207 
208         emit Transfer(0, this, mintedAmount);
209         emit Transfer(this, target, mintedAmount);
210     }
211 
212     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
213     /// @param target Address to be frozen
214     /// @param freeze either to freeze it or not
215     function freezeAccount(address target, bool freeze) onlyOwner public {
216         frozenAccount[target] = freeze;
217 
218         emit FrozenFunds(target, freeze);
219     }
220 
221     /// @notice batch assign tokens to users registered in airdrops
222     /// @param earlyBirds address[] format in wallet: ["address1", "address2", ...]
223     /// @param amount without decimal amount: 10**18
224     function assignToEarlyBirds(address[] earlyBirds, uint256 amount) onlyOwner public {
225         require(amount > 0);
226 
227         for (uint i = 0; i < earlyBirds.length; i++)
228             _transfer(msg.sender, earlyBirds[i], amount * 10 ** 18);
229     }
230 
231     /* Internal transfer, only can be called by this contract */
232     function _transfer(address _from, address _to, uint _value) internal { 
233         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
234         require (balanceOf[_from] >= _value);               // Check if the sender has enough
235         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
236         require(!frozenAccount[_from]);                     // Check if sender is frozen
237         require(!frozenAccount[_to]);                       // Check if recipient is frozen
238 
239         // make sure founders can only withdraw 25% each year after first year    
240         if(_from == team){
241             bool flag = _limitTeamWithdraw(_value, teamTotal, teamWithdrawed, deployedTime, now);
242             if(!flag)
243                 revert();
244         }          
245              
246         balanceOf[_from] = balanceOf[_from].sub(_value);                  // Subtract from the sender
247         balanceOf[_to] = balanceOf[_to].add(_value);                      // Add the same to the recipient
248 
249         if(_from == team) teamWithdrawed = teamWithdrawed.add(_value);    // record how many team withdrawed
250 
251         emit Transfer(_from, _to, _value);
252     }
253 
254     // setperate this function is for unit testing.
255     // limited withdraw: 
256     // after deployed:  40%
257     // after one year:  30% 
258     // after two years: 30%
259     function _limitTeamWithdraw(uint _amount, uint _teamTotal, uint _teamWithrawed, uint _deployedTime, uint _currentTime) internal pure returns(bool){
260         
261         bool flag  = true;
262 
263         uint _tenPercent = _teamTotal / 10;    
264         if(_currentTime <= _deployedTime + 1 days && _amount + _teamWithrawed >= _tenPercent * 4) 
265             flag = false;
266         else if(_currentTime <= _deployedTime + 365 days && _amount + _teamWithrawed >= _tenPercent * 7) 
267             flag = false; 
268 
269         return flag;
270 
271     }
272 }