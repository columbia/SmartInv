1 pragma solidity ^0.4.11;
2 
3 contract ERC20Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 
49 contract Controlled {
50     /// @notice The address of the controller is the only address that can call
51     ///  a function with this modifier
52     modifier onlyController { if (msg.sender != controller) throw; _; }
53 
54     address public controller;
55 
56     function Controlled() { controller = msg.sender;}
57 
58     /// @notice Changes the controller of the contract
59     /// @param _newController The new controller of the contract
60     function changeController(address _newController) onlyController {
61         controller = _newController;
62     }
63 }
64 
65 contract StandardToken is ERC20Token ,Controlled{
66 
67     bool public showValue=true;
68 
69     // Flag that determines if the token is transferable or not.
70     bool public transfersEnabled;
71 
72     function transfer(address _to, uint256 _value) returns (bool success) {
73 
74         if(!transfersEnabled) throw;
75 
76         if (balances[msg.sender] >= _value && _value > 0) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
87 
88         if(!transfersEnabled) throw;
89         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92             allowed[_from][msg.sender] -= _value;
93             Transfer(_from, _to, _value);
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     function balanceOf(address _owner) constant returns (uint256 balance) {
101         if(!showValue)
102         return 0;
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         if(!transfersEnabled) throw;
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114         if(!transfersEnabled) throw;
115         return allowed[_owner][_spender];
116     }
117 
118     /// @notice Enables token holders to transfer their tokens freely if true
119     /// @param _transfersEnabled True if transfers are allowed in the clone
120     function enableTransfers(bool _transfersEnabled) onlyController {
121         transfersEnabled = _transfersEnabled;
122     }
123     function enableShowValue(bool _showValue) onlyController {
124         showValue = _showValue;
125     }
126 
127     function generateTokens(address _owner, uint _amount
128     ) onlyController returns (bool) {
129         uint curTotalSupply = totalSupply;
130         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
131         totalSupply=curTotalSupply + _amount;
132 
133         balances[_owner]+=_amount;
134 
135         Transfer(0, _owner, _amount);
136         return true;
137     }
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140 }
141 
142 contract MiniMeTokenSimple is StandardToken {
143 
144     string public name;                //The Token's name: e.g. DigixDAO Tokens
145     uint8 public decimals;             //Number of decimals of the smallest unit
146     string public symbol;              //An identifier: e.g. REP
147     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
148 
149 
150     // `parentToken` is the Token address that was cloned to produce this token;
151     //  it will be 0x0 for a token that was not cloned
152     address public parentToken;
153 
154     // `parentSnapShotBlock` is the block number from the Parent Token that was
155     //  used to determine the initial distribution of the Clone Token
156     uint public parentSnapShotBlock;
157 
158     // `creationBlock` is the block number that the Clone Token was created
159     uint public creationBlock;
160 
161     // The factory used to create new clone tokens
162     address public tokenFactory;
163 
164     ////////////////
165     // Constructor
166     ////////////////
167 
168     /// @notice Constructor to create a MiniMeTokenSimple
169     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
170     ///  will create the Clone token contracts, the token factory needs to be
171     ///  deployed first
172     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
173     ///  new token
174     /// @param _parentSnapShotBlock Block of the parent token that will
175     ///  determine the initial distribution of the clone token, set to 0 if it
176     ///  is a new token
177     /// @param _tokenName Name of the new token
178     /// @param _decimalUnits Number of decimals of the new token
179     /// @param _tokenSymbol Token Symbol for the new token
180     /// @param _transfersEnabled If true, tokens will be able to be transferred
181     function MiniMeTokenSimple(
182     address _tokenFactory,
183     address _parentToken,
184     uint _parentSnapShotBlock,
185     string _tokenName,
186     uint8 _decimalUnits,
187     string _tokenSymbol,
188     bool _transfersEnabled
189     ) {
190         tokenFactory = _tokenFactory;
191         name = _tokenName;                                 // Set the name
192         decimals = _decimalUnits;                          // Set the decimals
193         symbol = _tokenSymbol;                             // Set the symbol
194         parentToken = _parentToken;
195         parentSnapShotBlock = _parentSnapShotBlock;
196         transfersEnabled = _transfersEnabled;
197         creationBlock = block.number;
198     }
199     //////////
200     // Safety Methods
201     //////////
202 
203     /// @notice This method can be used by the controller to extract mistakenly
204     ///  sent tokens to this contract.
205     /// @param _token The address of the token contract that you want to recover
206     ///  set to 0 in case you want to extract ether.
207     function claimTokens(address _token) onlyController {
208         if (_token == 0x0) {
209             controller.transfer(this.balance);
210             return;
211         }
212 
213         ERC20Token token = ERC20Token(_token);
214         uint balance = token.balanceOf(this);
215         token.transfer(controller, balance);
216         ClaimedTokens(_token, controller, balance);
217     }
218 
219     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
220 
221 }
222 
223 contract PFC is MiniMeTokenSimple {
224 
225     function PFC(address _tokenFactory)
226     MiniMeTokenSimple(
227     _tokenFactory,
228     0x0,                     // no parent token
229     0,                       // no snapshot block number from parent
230     "Power Fans Token",      // Token name
231     18,                      // Decimals
232     "PFC",                   // Symbol
233     false                    // Enable transfers
234     ) {}
235 }