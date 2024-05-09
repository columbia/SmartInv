1 pragma solidity ^0.4.13;
2 
3 
4 contract admined {
5 	address public admin;
6     address public coAdmin;
7 
8 	function admined() {
9 		admin = msg.sender;
10         coAdmin = msg.sender;
11 	}
12 
13 	modifier onlyAdmin(){
14 		require((msg.sender == admin) || (msg.sender == coAdmin)) ;
15 		_;
16 	}
17 
18 	function transferAdminship(address newAdmin) onlyAdmin {
19 		admin = newAdmin;
20 	}
21 
22     function transferCoadminship(address newCoadmin) onlyAdmin {
23 		coAdmin = newCoadmin;
24 	}
25 
26 
27 } 
28 
29 contract Token {
30     /* This is a slight change to the ERC20 base standard.
31     function totalSupply() constant returns (uint256 supply);
32     is replaced with:
33     uint256 public totalSupply;
34     This automatically creates a getter function for the totalSupply.
35     This is moved to the base contract since public getter functions are not
36     currently recognised as an implementation of the matching abstract
37     function by the compiler.
38     */
39     /// total amount of tokens
40     uint256 public totalSupply;
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant returns (uint256 balance);
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) returns (bool success);
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) returns (bool success);
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
69 
70     // This generates a public event on the blockchain that will notify clients
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73     // This notifies clients about the amount burnt
74     event Burn(address indexed from, uint256 value);
75 }
76 
77 /*
78 You should inherit from StandardToken 
79 (This implements ONLY the standard functions and NOTHING else.
80 If you deploy this, you won't have anything useful.)
81 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
82 */
83 
84 contract StandardToken is Token {
85 
86     uint256 constant MAX_UINT256 = 2**256 - 1;
87 
88     function transfer(address _to, uint256 _value) returns (bool success) {
89         //Default assumes totalSupply can't be over max (2^256 - 1).
90         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
91         //Replace the if with this one instead.
92         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
93         require(balances[msg.sender] >= _value);
94         balances[msg.sender] -= _value;
95         balances[_to] += _value;
96         Transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         //same as above. Replace this line with the following if you want to protect against wrapping uints.
102         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
103 
104         // Prevent transfer to 0x0 address. Use burn() instead
105         require(_to != 0x0);
106         
107         require(_value > 0);
108         
109         // Check for overflows
110         require(balances[_to] + _value > balances[_to]);
111         
112         uint256 allowance = allowed[_from][msg.sender];
113         // Check if the sender has enough     
114         require(balances[_from] >= _value && allowance >= _value);
115         // Add the same to the recipient
116         balances[_to] += _value;
117         // Subtract from the sender
118         balances[_from] -= _value;
119         if (allowance < MAX_UINT256) {
120             allowed[_from][msg.sender] -= _value;
121         }
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function balanceOf(address _owner) constant returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130     /**
131      * Set allowance for other address
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      */
138     function approve(address _spender, uint256 _value) returns (bool success) {
139     		
140     		require(_value > 0);
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147       return allowed[_owner][_spender];
148     }
149 
150     // This creates an array with all balances
151     mapping (address => uint256) balances;
152     mapping (address => mapping (address => uint256)) allowed;
153 }
154 
155 
156 /*
157 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
158 
159 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
160 Imagine coins, currencies, shares, voting weight, etc.
161 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
162 
163 1) Initial Finite Supply (upon creation one specifies how much is minted).
164 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
165 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
166 
167 .*/
168 
169 
170 contract ZigguratToken is admined, StandardToken {
171 
172     /* Public variables of the token */
173 
174     /*
175     NOTE:
176     The following variables are OPTIONAL vanities. One does not have to include them.
177     They allow one to customise the token contract & in no way influences the core functionality.
178     Some wallets/interfaces might not even bother to look at this information.
179     */
180     string public name;                   //fancy name: eg Ziggurat Token
181     uint8 public decimals = 18;           //How many decimals to show. ie. 18 decimals is the strongly suggested default, avoid changing it
182     string public symbol;                 //An identifier: eg ZIG
183     string public version = "1.0";       //1 standard. Just an arbitrary versioning scheme.
184     uint256 public totalMaxSupply = 5310000000 * 10 ** 17; // 531M Limit
185     
186     function ZigguratToken(
187         uint256 _initialAmount,
188         string _tokenName,
189         uint8 _decimalUnits,
190         string _tokenSymbol
191         ) {
192         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
193         totalSupply = _initialAmount;                        // Update total supply
194         name = _tokenName;                                   // Set the name for display purposes
195         decimals = _decimalUnits;                            // Amount of decimals for display purposes
196         symbol = _tokenSymbol;                               // Set the symbol for display purposes
197     }
198 
199     //Supply may be increased at any time and by any amount by minting new tokens and transferring them to a desired address. 
200     //Adding ownership modifiers and restricting privileges would prove useful in most cases.
201 
202     function mintToken(address target, uint256 mintedAmount) onlyAdmin returns (bool success) {
203          // Maximum supply set and minting would break the limit
204         require ((totalMaxSupply == 0) || ((totalMaxSupply != 0) && (safeAdd (totalSupply, mintedAmount) <= totalMaxSupply )));
205 
206         balances[target] = safeAdd(balances[target], mintedAmount);
207         totalSupply = safeAdd(totalSupply, mintedAmount);
208 		Transfer(0, this, mintedAmount);
209 		Transfer(this, target, mintedAmount);
210         return true;
211 	} 
212 
213     function safeAdd(uint a, uint b) internal returns (uint) {
214         require (a + b >= a); 
215         return a + b;
216     }
217 
218     //Supply may be decreased at any time by subtracting from a desired address. 
219     //There is one caveat: the token balance of the provided party must be at least equal to the amount being subtracted from total supply.
220 
221     function decreaseSupply(uint _value, address _from) onlyAdmin returns (bool success) {
222     	  require(_value > 0);
223         balances[_from] = safeSub(balances[_from], _value);
224         totalSupply = safeSub(totalSupply, _value);  
225         Transfer(_from, 0, _value);
226         return true;
227     }
228 
229     function safeSub(uint a, uint b) internal returns (uint) {
230         require (b <= a); 
231         return a - b;
232     }
233 
234     /* Approves and then calls the receiving contract */
235         /**
236      * Set allowance for other address and notify
237      *
238      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
239      *
240      * @param _spender The address authorized to spend
241      * @param _value the max amount they can spend
242      * @param _extraData some extra information to send to the approved contract
243      */
244     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
245     		require(_value > 0);
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248 
249         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
250         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
251         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
252         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
253         return true;
254     }
255 
256 }