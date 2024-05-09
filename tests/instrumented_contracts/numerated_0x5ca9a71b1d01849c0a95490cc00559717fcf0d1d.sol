1 pragma solidity ^0.4.15;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of wei to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51 You should inherit from StandardToken or, for a token like you would want to
52 deploy in something like Mist, see HumanStandardToken.sol.
53 (This implements ONLY the standard functions and NOTHING else.
54 If you deploy this, you won't have anything useful.)
55 
56 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
57 .*/
58 
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66 				require(balances[msg.sender] >= _value && _value >= 0);
67 				balances[msg.sender] -= _value;
68 				balances[_to] += _value;
69 				Transfer(msg.sender, _to, _value);
70 				return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76 				require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
77 				balances[_to] += _value;
78 				balances[_from] -= _value;
79 				allowed[_from][msg.sender] -= _value;
80 				Transfer(_from, _to, _value);
81 				return true;
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 
102 
103 contract HumanStandardToken is StandardToken {
104 
105     function () {
106         //if ether is sent to this address, send it back.
107         revert();
108     }
109 
110     /* Public variables of the token */
111 
112     /*
113     NOTE:
114     The following variables are OPTIONAL vanities. One does not have to include them.
115     They allow one to customise the token contract & in no way influences the core functionality.
116     Some wallets/interfaces might not even bother to look at this information.
117     */
118     string public name;                   //fancy name: eg Simon Bucks
119     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
120     string public symbol;                 //An identifier: eg SBX
121     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
122 
123     function HumanStandardToken(
124         uint256 _initialAmount,
125         string _tokenName,
126         uint8 _decimalUnits,
127         string _tokenSymbol
128         ) {
129         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
130         totalSupply = _initialAmount;                        // Update total supply
131         name = _tokenName;                                   // Set the name for display purposes
132         decimals = _decimalUnits;                            // Amount of decimals for display purposes
133         symbol = _tokenSymbol;                               // Set the symbol for display purposes
134     }
135 
136     /* Approves and then calls the receiving contract */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         // call the receiveApproval function on the contract you want to be notified.
142         // This crafts the function signature manually so one doesn't have to include
143         // a contract in here just for this.
144         // receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
145         // it is assumed that when does this that the call *should* succeed, otherwise
146         // one would use vanilla approve instead.
147 				require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
148         return true;
149     }
150 }
151 
152 contract PrefilledToken is HumanStandardToken {
153 
154   bool public prefilled = false;
155   address public creator = msg.sender;
156 
157   function prefill (address[] _addresses, uint[] _values)
158     only_not_prefilled
159     only_creator
160   {
161     uint total = totalSupply;
162 
163     for (uint i = 0; i < _addresses.length; i++) {
164       address who = _addresses[i];
165       uint val = _values[i];
166 
167       if (balances[who] != val) {
168         total -= balances[who];
169 
170         balances[who] = val;
171         total += val;
172 				Transfer(0x0, who, val);
173       }
174     }
175 
176     totalSupply = total;
177   }
178 
179   function launch ()
180     only_not_prefilled
181     only_creator
182   {
183     prefilled = true;
184   }
185 
186   /**
187    * Following standard token methods needs to wait
188    * for the Token to be prefilled first.
189    */
190 
191   function transfer(address _to, uint256 _value) returns (bool success) {
192 		assert(prefilled);
193 
194     return super.transfer(_to, _value);
195   }
196 
197   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
198 		assert(prefilled);
199 
200     return super.transferFrom(_from, _to, _value);
201   }
202 
203   function approve(address _spender, uint256 _value) returns (bool success) {
204 		assert(prefilled);
205 
206     return super.approve(_spender, _value);
207   }
208 
209   modifier only_creator () {
210 		require(msg.sender == creator);
211     _;
212   }
213 
214   modifier only_not_prefilled () {
215 		assert(!prefilled);
216     _;
217   }
218 }
219 
220 contract AEToken is PrefilledToken {
221 
222   // Date when the tokens won't be transferable anymore
223   uint public transferableUntil;
224 
225   /**
226    * HumanStandardToken(
227       uint256  initialAmount,
228       string   tokenName,
229       uint8    decimalUnits,
230       string   tokenSymbol
231     )
232    */
233   function AEToken() HumanStandardToken(0, "Aeternity", 18, "AE") {
234     uint nYears = 2;
235 
236     transferableUntil = now + (60 * 60 * 24 * 365 * nYears);
237   }
238 
239   function transfer(address _to, uint256 _value) only_transferable returns (bool success) {
240     return super.transfer(_to, _value);
241   }
242 
243   function transferFrom(address _from, address _to, uint256 _value) only_transferable returns (bool success) {
244     return super.transferFrom(_from, _to, _value);
245   }
246 
247   modifier only_transferable () {
248 		assert(now <= transferableUntil);
249     _;
250   }
251 }