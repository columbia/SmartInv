1 pragma solidity ^0.4.24;
2 
3 /// @title SafeMath library
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11  
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         // assert(b > 0); // Solidity automatically throws when dividing by 0
14         uint256 c = a / b;
15         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 /// @title Centralized administrator
31 /// @dev Centralized administrator parent contract
32 contract owned {
33     address public owner;
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         owner = newOwner;
46     }
47 }
48 
49 
50 /// @title Abstract contract for the full ERC 20 Token standard
51 /// @dev ERC 20 Token standard, ref to: https://github.com/ethereum/EIPs/issues/20
52 contract ERC20Token{
53     // Get the total token supply
54     function totalSupply() public view returns (uint256 supply);
55 
56     // Get the account balance of another account with address _owner
57     function balanceOf(address _owner) public view returns (uint256 balance);
58 
59     // Send _value amount of tokens to address _to
60     function transfer(address _to, uint256 _value) public returns (bool success);
61 
62     // Send _value amount of tokens from address _from to address _to
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
64 
65     // Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
66     // If this function is called again it overwrites the current allowance with _value.
67     function approve(address _spender, uint256 _value) public returns (bool success);
68 
69     // Returns the amount which _spender is still allowed to withdraw from _owner
70     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
71 
72     // Triggered when tokens are transferred.
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74 
75     // Triggered whenever approve(address _spender, uint256 _value) is called.
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 /// @title Token main contract
80 /// @dev Token main contract
81 contract GTLToken is ERC20Token, owned {
82     using SafeMath for uint256;
83 
84     // Public variables of the token
85     string public name;
86     string public symbol;
87     uint8 public constant decimals = 18;
88     uint256 _totalSupply;
89 
90     // Balances for each account
91     mapping (address => uint256) public balances;
92     // Owner of account approves the transfer of an amount to another account
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     // Struct of Freeze Information
96     struct FreezeAccountInfo {
97         uint256 freezeStartTime;
98         uint256 freezePeriod;
99         uint256 freezeTotal;
100     }
101 
102 
103 
104     // Freeze Information of accounts
105     mapping (address => FreezeAccountInfo) public freezeAccount;
106 
107     // Triggered when tokens are issue and freeze
108     event IssueAndFreeze(address indexed to, uint256 _value, uint256 _freezePeriod);
109 
110     /**
111      * Constrctor function
112      *
113      * Initializes contract with initial supply tokens to the creator of the contract
114      */
115     constructor(string _tokenName, string _tokenSymbol, uint256 _initialSupply) public {
116         _totalSupply = _initialSupply * 10 ** uint256(decimals);  // Total supply with the decimal amount
117         balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens
118         name = _tokenName;                                   // Set the name for display purposes
119         symbol = _tokenSymbol;                               // Set the symbol for display purposes
120     }
121 
122     /// @notice Get the total token supply
123     /// @dev Get the total token supply
124     /// @return Total token supply
125     function totalSupply() public view returns (uint256 supply) {
126         return _totalSupply;
127     }
128 
129     /// @notice Get balance of account
130     /// @dev Get balance of '_owner'
131     /// @param _owner Target address
132     /// @return balance of '_owner'
133     function balanceOf(address _owner) public view returns (uint256 balance){
134         return balances[_owner];
135     }
136 
137     /// @notice Issue tokens to account and these tokens will be frozen for a period of time
138     /// @dev Issue '_value' tokens to the address '_to' and these tokens will be frozen for a period of '_freezePeriod' minutes
139     /// @param _to Receiving address
140     /// @param _value The amount of frozen token to be issued
141     /// @param _freezePeriod Freeze Period(minutes)
142     function issueAndFreeze(address _to, uint _value, uint _freezePeriod) onlyOwner public {
143         _transfer(msg.sender, _to, _value);
144 
145         freezeAccount[_to] = FreezeAccountInfo({
146             freezeStartTime : now,
147             freezePeriod : _freezePeriod,
148             freezeTotal : _value
149         });
150 
151         emit IssueAndFreeze(_to, _value, _freezePeriod);
152     }
153 
154     /// @notice Get account's freeze information
155     /// @dev Get freeze information of '_target'
156     /// @param _target Target address
157     /// @return _freezeStartTime Freeze start time; _freezePeriod Freeze period(minutes); _freezeAmount Freeze token amount; _freezeDeadline Freeze deadline
158     function getFreezeInfo(address _target) public view returns(
159         uint _freezeStartTime, 
160         uint _freezePeriod, 
161         uint _freezeTotal, 
162         uint _freezeDeadline) {
163             
164         FreezeAccountInfo storage targetFreezeInfo = freezeAccount[_target];
165         uint freezeDeadline = targetFreezeInfo.freezeStartTime.add(targetFreezeInfo.freezePeriod.mul(1 minutes));
166         return (
167             targetFreezeInfo.freezeStartTime, 
168             targetFreezeInfo.freezePeriod,
169             targetFreezeInfo.freezeTotal,
170             freezeDeadline
171         );
172     }
173 
174     /// @dev Internal transfer, only can be called by this contract
175     /// @param _from The address of the sender
176     /// @param _to The address of the recipient
177     /// @param _value The amount to send
178     function _transfer(address _from, address _to, uint _value) internal {
179         // Prevent transfer to 0x0 address
180         require(_to != 0x0);
181         // Check if the sender has enough
182         require(balances[_from] >= _value);
183         // Check for overflows
184         require(balances[_to].add(_value) > balances[_to]);
185 
186         uint256 freezeStartTime;
187         uint256 freezePeriod;
188         uint256 freezeTotal;
189         uint256 freezeDeadline;
190 
191         // Get freeze information of sender
192         (freezeStartTime,freezePeriod,freezeTotal,freezeDeadline) = getFreezeInfo(_from);
193 
194         // The free amount of _from
195         uint256 freeTotalFrom = balances[_from].sub(freezeTotal);
196 
197         //Check if it is a freeze account
198         //Check if in Lock-up Period
199         //Check if the transfer amount > free amount
200         require(freezeStartTime == 0 || freezeDeadline < now || freeTotalFrom >= _value); 
201 
202         // Save this for an assertion in the future
203         uint previousBalances = balances[_from].add(balances[_to]);
204         // Subtract from the sender
205         balances[_from] = balances[_from].sub(_value);
206         // Add the same to the recipient
207         balances[_to] = balances[_to].add(_value);
208 
209         // Notify client the transfer
210         emit Transfer(_from, _to, _value);
211         // Asserting that the total balances before and after the transaction should be the same
212         assert(balances[_from].add(balances[_to]) == previousBalances);
213     }
214 
215     /// @notice Transfer tokens to account
216     /// @dev Send '_value' amount of tokens to address '_to'
217     /// @param _to The address of the recipient
218     /// @param _value The token amount to send
219     /// @return Whether succeed
220     function transfer(address _to, uint256 _value) public returns (bool success) {
221         _transfer(msg.sender, _to, _value);
222         return true;
223     }
224 
225     /// @notice Transfer tokens from other address
226     /// @dev Send '_value' amount of tokens from address '_from' to address '_to'
227     /// @param _from The address of the sender
228     /// @param _to The address of the recipient
229     /// @param _value The token amount to send
230     /// @return Whether succeed
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
232         require(_value <= allowance[_from][msg.sender]);     // Check allowance
233         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
234         _transfer(_from, _to, _value);
235         return true;
236     }
237 
238     /// @notice Set allowance for other address
239     /// @dev Allows '_spender' to spend no more than '_value' tokens in your behalf. If this function is called again it overwrites the current allowance with _value
240     /// @param _spender The address authorized to spend
241     /// @param _value The max amount they can spend
242     /// @return Whether succeed.
243     function approve(address _spender, uint256 _value) public returns (bool success) {
244         allowance[msg.sender][_spender] = _value;
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 
249     /// @notice Get the amount which '_spender' is still allowed to withdraw from '_owner'
250     /// @dev Get the amount which '_spender' is still allowed to withdraw from '_owner'
251     /// @param _owner Target address
252     /// @param _spender The address authorized to spend
253     /// @return The max amount can spend
254     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
255         return allowance[_owner][_spender];
256     }
257 }