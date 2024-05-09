1 pragma solidity ^0.4.25;
2 contract Token {
3 
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /*
101 This implements ONLY the standard functions and NOTHING else.
102 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
103 
104 If you deploy this, you won't have anything useful.
105 
106 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
107 .*/
108 
109 contract StandardToken is Token {
110 
111     function transfer(address _to, uint256 _value) returns (bool success) {
112       require(_value <= balances[msg.sender]);
113       require(_to != address(0));
114       balances[msg.sender] = balances[msg.sender].sub(_value);
115       balances[_to] = balances[_to].add(_value);
116       emit Transfer(msg.sender, _to, _value);
117       return true;
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
121         //same as above. Replace this line with the following if you want to protect against wrapping uints.
122         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
123         require(_value <= balances[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125         require(_to != address(0));
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         emit Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) returns (bool success) {
138         require(_spender != address(0));
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145       return allowed[_owner][_spender];
146     }
147     using SafeMath for uint256;
148     mapping (address => uint256) balances;
149     mapping (address => mapping (address => uint256)) allowed;
150     uint256 public totalSupply;
151 }
152 
153 /*
154 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
155 
156 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
157 Imagine coins, currencies, shares, voting weight, etc.
158 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
159 
160 1) Initial Finite Supply (upon creation one specifies how much is minted).
161 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
162 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
163 
164 .*/
165 
166 contract HumanStandardToken is StandardToken {
167 
168     function () {
169         //if ether is sent to this address, send it back.
170         throw;
171     }
172 
173     /* Public variables of the token */
174 
175     /*
176     NOTE:
177     The following variables are OPTIONAL vanities. One does not have to include them.
178     They allow one to customise the token contract & in no way influences the core functionality.
179     Some wallets/interfaces might not even bother to look at this information.
180     */
181     string public name;                   //fancy name: eg Simon Bucks
182     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
183     string public symbol;                 //An identifier: eg SBX
184     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
185 
186     function HumanStandardToken(
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
199     /* Approves and then calls the receiving contract */
200     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
201         approve(_spender, _value);
202              if(!_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData))) { throw; }
203         return true;
204     }
205 }