1 pragma solidity ^0.4.18;
2 
3 /*
4     2018 Proxycard
5 */
6 
7 // Abstract contract for the full ERC 20 Token standard
8 // https://github.com/ethereum/EIPs/issues/20
9 
10 interface ERC20Token {
11 	/// @param _owner The address from which the balance will be retrieved
12 	/// @return The balance
13 	function balanceOf(address _owner) public view returns (uint256);
14 
15 	/// @notice send `_value` token to `_to` from `msg.sender`
16 	/// @param _to The address of the recipient
17 	/// @param _value The amount of token to be transferred
18 	/// @return Whether the transfer was successful or not
19 	function transfer(address _to, uint256 _value) public returns (bool);
20 
21 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22 	/// @param _from The address of the sender
23 	/// @param _to The address of the recipient
24 	/// @param _value The amount of token to be transferred
25 	/// @return Whether the transfer was successful or not
26 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
27 
28 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
29 	/// @param _spender The address of the account able to transfer the tokens
30 	/// @param _value The amount of tokens to be approved for transfer
31 	/// @return Whether the approval was successful or not
32 	function approve(address _spender, uint256 _value) public returns (bool);
33 
34 	/// @param _owner The address of the account owning tokens
35 	/// @param _spender The address of the account able to transfer the tokens
36 	/// @return Amount of remaining tokens allowed to spent
37 	function allowance(address _owner, address _spender) public view returns (uint256);
38 
39 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
40 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract Owned {
44     /// @notice The address of the owner is the only address that can call
45     ///  a function with this modifier
46     modifier onlyOwner { require(msg.sender == owner); _; }
47 
48     address public owner;
49 
50     function Owned() public { owner = msg.sender;}
51 
52     /// @notice Changes the owner of the contract
53     /// @param _newOwner The new owner of the contract
54     function changeOwner(address _newOwner) onlyOwner public {
55         owner = _newOwner;
56     }
57 }
58 
59 library SafeMathMod {// Partial SafeMath Library
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
62         require((c = a - b) < a);
63     }
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66         require((c = a + b) > a);
67     }
68 }
69 
70 contract EPRX is Owned, ERC20Token  {
71     using SafeMathMod for uint256;
72 
73     /**
74     * @constant name The name of the token
75     * @constant symbol  The symbol used to display the currency
76     * @constant decimals  The number of decimals used to display a balance
77     * @constant totalSupply The total number of tokens times 10^ of the number of decimals
78     * @constant MAX_UINT256 Magic number for unlimited allowance
79     * @storage balanceOf Holds the balances of all token holders
80     * @storage allowed Holds the allowable balance to be transferable by another address.
81     */
82 
83     string constant public name = "eProxy";
84 
85     string constant public symbol = "ePRX";
86 
87     uint8 constant public decimals = 8;
88 
89     uint256 constant public totalSupply = 50000000e8;
90 	
91 	address public issuingTokenOwner;
92 
93     mapping (address => uint256) public balanceOf;
94 
95     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
96     mapping (address => mapping (address => uint256)) public allowed;
97 
98     // Flag that determines if the token is transferable or not.
99     bool public transfersEnabled;
100 
101 	////////////////
102 	// Events
103 	////////////////
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);	
107     event ClaimedTokens(address indexed _token, address indexed _Owner, uint256 _amount);
108     event SwappedTokens(address indexed _owner, uint256 _amountOffered, uint256 _amountReceived);
109  
110  	////////////////
111 	// Constructor
112 	////////////////   
113     function EPRX() public { 
114 		issuingTokenOwner = msg.sender;
115         balanceOf[issuingTokenOwner] = totalSupply; 
116         transfersEnabled = true;
117     }
118 
119 	///////////////////
120 	// ERC20 Methods
121 	///////////////////
122 
123     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
124     /// @param _to The address of the recipient
125     /// @param _amount The amount of tokens to be transferred
126     /// @return Whether the transfer was successful or not
127     function transfer(address _to, uint256 _amount) public returns (bool success) {
128         if (msg.sender != owner) {
129             require(transfersEnabled);
130         }
131         return doTransfer(msg.sender, _to, _amount);
132     }
133 
134     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
135     ///  is approved by `_from`
136     /// @param _from The address holding the tokens being transferred
137     /// @param _to The address of the recipient
138     /// @param _amount The amount of tokens to be transferred
139     /// @return True if the transfer was successful
140     function transferFrom(address _from, address _to, uint256 _amount
141     ) public returns (bool success) {
142 
143         // The owner of this contract can move tokens around at will,
144         //  this is important to recognize! Confirm that you trust the
145         //  owner of this contract
146         if (msg.sender != owner) {
147             require(transfersEnabled);
148 
149             // The standard ERC20 transferFrom functionality
150             // require(allowed[_from][msg.sender] >= _amount);
151 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
152         }
153 
154         return doTransfer(_from, _to, _amount);
155     }
156 
157     /// @dev This is the actual transfer function in the token contract, it can
158     ///  only be called by other functions in this contract.
159     /// @param _from The address holding the tokens being transferred
160     /// @param _to The address of the recipient
161     /// @param _amount The amount of tokens to be transferred
162     /// @return True if the transfer was successful
163     function doTransfer(address _from, address _to, uint _amount
164     ) internal returns(bool) {
165 	
166 		if(_amount == 0) {
167 			return true;
168 		}
169 
170 		// Do not allow transfer to 0x0 or the token contract itself
171 		require((_to != 0) && (_to != address(this)));
172 
173 		/* SafeMathMOd.sub will throw if there is not enough balance
174 		   and if the transfer value is 0. */
175 		balanceOf[_from] = balanceOf[_from].sub(_amount);
176 		balanceOf[_to] = balanceOf[_to].add(_amount);
177 
178 		// An event to make the transfer easy to find on the blockchain
179 		Transfer(_from, _to, _amount);
180 
181         return true;
182     }
183 
184     /// @param _owner The address that's balance is being requested
185     /// @return The balance of `_owner` at the current block
186     function balanceOf(address _owner) public view returns (uint256) {
187         return balanceOf[_owner];
188     }
189 
190     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
191     ///  its behalf. This is a modified version of the ERC20 approve function
192     ///  to be a little bit safer
193     /// @param _spender The address of the account able to transfer the tokens
194     /// @param _amount The amount of tokens to be approved for transfer
195     /// @return True if the approval was successful
196     function approve(address _spender, uint256 _amount) public returns (bool) {
197         require(transfersEnabled);
198 
199         /* Ensures address "0x0" is not assigned allowance. */
200         require(_spender != address(0));
201 
202         // To change the approve amount you first have to reduce the addresses`
203         //  allowance to zero by calling `approve(_spender,0)` if it is not
204         //  already 0 to mitigate the race condition described here:
205         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
207 
208         allowed[msg.sender][_spender] = _amount;
209         Approval(msg.sender, _spender, _amount);
210 		
211         return true;
212     }
213 
214     /// @dev This function makes it easy to read the `allowed[]` map
215     /// @param _owner The address of the account that owns the token
216     /// @param _spender The address of the account able to transfer the tokens
217     /// @return Amount of remaining tokens of _owner that _spender is allowed
218     ///  to spend
219     function allowance(address _owner, address _spender
220     ) public view returns (uint256 remaining) {
221         return allowed[_owner][_spender];
222     }
223 
224 	////////////////
225 	// Enable tokens transfers
226 	////////////////
227 
228     /// @notice Enables token holders to transfer their tokens freely if true
229     /// @param _transfersEnabled True if transfers are allowed in the clone
230     function enableTransfers(bool _transfersEnabled) onlyOwner public {
231         transfersEnabled = _transfersEnabled;
232     }
233 
234 	//////////
235 	// Safety Methods
236 	//////////
237 
238     /// @notice This method can be used by the owner to extract mistakenly
239     ///  sent tokens to this contract.
240     /// @param _token The address of the token contract that you want to recover
241     ///  set to 0 in case you want to extract ether.
242     function claimTokens(address _token) onlyOwner public {
243         // Transfer ether
244         if (_token == 0x0) {
245             owner.transfer(this.balance);
246             return;
247         }
248 
249         ERC20Token token = ERC20Token(_token);
250         uint balance = token.balanceOf(this);
251         token.transfer(owner, balance);
252         ClaimedTokens(_token, owner, balance);
253     }
254 
255     /// @notice This method can be used by users holding old proxy tokens
256     ///  to swap for new tokens at the ratio of 1 : 2.
257     function swapProxyTokens() public {
258         ERC20Token oldToken = ERC20Token(0x81BE91c7E74Ad0957B4156F782263e7B0B88cF7b);
259         uint256 oldTokenBalance = oldToken.balanceOf(msg.sender);
260 
261         require(oldTokenBalance > 0);
262 
263         // User must first approve address(this) as a spender by calling the below
264         // approve(<address of this contract>, oldTokenBalance);
265 		
266         // Convert old proxy token to new token for any user authorizing the transfer
267         if(oldToken.transferFrom(msg.sender, issuingTokenOwner, oldTokenBalance)) {
268             require(oldToken.balanceOf(msg.sender) == 0);
269 			
270             // Transfer new token to user
271 			uint256 newTokenAmount = 200 * oldTokenBalance;
272             doTransfer(issuingTokenOwner, msg.sender, newTokenAmount);
273 
274             SwappedTokens(msg.sender, oldTokenBalance, newTokenAmount);
275         }
276         
277     }
278 
279 }