1 pragma solidity ^0.4.18;
2 
3 contract Token {
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
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract StandardToken is Token {
50 
51     uint256 constant MAX_UINT256 = 2**256 - 1;
52     bool transferEnabled = false;
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
59         require(balances[msg.sender] >= _value);
60         require(transferEnabled);
61         balances[msg.sender] -= _value;
62         balances[_to] += _value;
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
70         uint256 allowance = allowed[_from][msg.sender];
71         require(balances[_from] >= _value && allowance >= _value);
72         require(transferEnabled);
73         balances[_to] += _value;
74         balances[_from] -= _value;
75         if (allowance < MAX_UINT256) {
76             allowed[_from][msg.sender] -= _value;
77         }
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function balanceOf(address _owner) view public returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99 
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   /**
125   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 contract RockToken is StandardToken {
143 
144     using SafeMath for uint;
145 
146     // UM
147     uint256 public million = 1000000;
148     uint8 public constant decimals = 18;
149     string public constant symbol = "RKT";
150     string public constant name = "Rock Token";
151     bool public canConvertTokens;
152 
153     // Inited in constructor
154     address public contractOwner; // Can stop the allocation of delayed tokens and can allocate delayed tokens.
155     address public futureOwner;
156     address public masterContractAddress; // The ICO contract to issue tokens.
157 
158     // Constructor
159     // Sets the contractOwner for the onlyOwner modifier
160     // Sets the public values in the ERC20 standard token
161     // Opens the delayed allocation window.
162     // can pre-allocate balances for an array of _accounts
163     function RockToken(address _masterContractAddress, address[] _accounts, uint[] _balances) public {
164         contractOwner = msg.sender;
165         masterContractAddress = _masterContractAddress;
166 
167         totalSupply = 0;
168         canConvertTokens = true;
169 
170         uint length = _accounts.length;
171         require(length == _balances.length);
172         for (uint i = 0; i < length; i++) {
173             balances[_accounts[i]] = _balances[i];
174             // Fire Transfer event for ERC-20 compliance. Adjust totalSupply.
175             Transfer(address(0), _accounts[i], _balances[i]);
176             totalSupply = totalSupply.add(_balances[i]);
177         }
178     }
179 
180     // Can only be called by the master contract during the TokenSale to issue tokens.
181     function convertTokens(uint256 _amount, address _tokenReceiver) onlyMasterContract public {
182         require(canConvertTokens);
183         balances[_tokenReceiver] = balances[_tokenReceiver].add(_amount);
184     }
185 
186     // Fire Transfer event for ERC-20 compliance. Adjust totalSupply. Can only be called by the Master Contract.
187     function reportConvertTokens(uint256 _amount, address _address) onlyMasterContract public {
188         require(canConvertTokens);
189         Transfer(address(0), _address, _amount);
190         totalSupply = totalSupply.add(_amount);
191     }
192 
193     function stopConvertTokens() onlyOwner public {
194         canConvertTokens = false;
195     }
196 
197     // Called by the token owner to block or unblock transfers
198     function enableTransfers() onlyOwner public {
199         transferEnabled = true;
200     }
201 
202     modifier onlyOwner() {
203         require(msg.sender == contractOwner);
204         _;
205     }
206 
207     modifier onlyMasterContract() {
208         require(msg.sender == masterContractAddress);
209         _;
210     }
211 
212     // Makes sure that the ownership is only changed by the owner
213     function transferOwnership(address _newOwner) public onlyOwner {
214     // Makes sure that the contract will have an owner
215         require(_newOwner != address(0));
216         futureOwner = _newOwner;
217     }
218 
219     function claimOwnership() public {
220         require(msg.sender == futureOwner);
221         contractOwner = msg.sender;
222         futureOwner = address(0);
223     }
224 
225 }