1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function toUINT112(uint256 a) internal constant returns(uint112) {
70     assert(uint112(a) == a);
71     return uint112(a);
72   }
73 
74   function toUINT120(uint256 a) internal constant returns(uint120) {
75     assert(uint120(a) == a);
76     return uint120(a);
77   }
78 
79   function toUINT128(uint256 a) internal constant returns(uint128) {
80     assert(uint128(a) == a);
81     return uint128(a);
82   }
83 }
84 
85 contract StandardToken is Token {
86     using SafeMath for uint256;
87     
88     function transfer(address _to, uint256 _value) returns (bool success) {
89         //Default assumes totalSupply can't be over max (2^256 - 1).
90         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
91         //Replace the if with this one instead.
92         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93         if (balances[msg.sender] >= _value && _value > 0) {
94             balances[msg.sender] = balances[msg.sender].sub(_value);
95             balances[_to] = balances[_to].add(_value);
96             Transfer(msg.sender, _to, _value);
97             return true;
98         } else { return false; }
99     }
100 
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102         //same as above. Replace this line with the following if you want to protect against wrapping uints.
103         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
104         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105             balances[_to] = balances[_to].add(_value);
106             balances[_from] = balances[_from].sub(_value);
107             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108             Transfer(_from, _to, _value);
109             return true;
110         } else { return false; }
111     }
112 
113     function balanceOf(address _owner) constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 
117     function approve(address _spender, uint256 _value) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124       return allowed[_owner][_spender];
125     }
126 
127     mapping (address => uint256) balances;
128     mapping (address => mapping (address => uint256)) allowed;
129     uint256 public totalSupply;
130 }
131 
132 
133 //name this contract whatever you'd like
134 contract CryptFillToken is StandardToken {
135         using SafeMath for uint256;
136         
137     function () {
138         //if ether is sent to this address, send it back.
139         throw;
140     }
141 
142     /* Public variables of the token */
143 
144     /*
145     NOTE:
146     The following variables are OPTIONAL vanities. One does not have to include them.
147     They allow one to customise the token contract & in no way influences the core functionality.
148     Some wallets/interfaces might not even bother to look at this information.
149     */
150     string public name;                   //fancy name: eg Simon Bucks
151     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
152     string public symbol;                 //An identifier: eg SBX
153     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
154     address public owner;                 //Owner of all the tokens
155 
156 //
157 // CHANGE THESE VALUES FOR YOUR TOKEN
158 //
159 
160 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
161 
162     function CryptFillToken(
163         ) {
164         balances[msg.sender] = 30000000 * 1000000000000000000;               // Give the creator all initial tokens (100000 for example)
165         totalSupply = 30000000 * 1000000000000000000;                        // Update total supply (100000 for example)
166         name = "CryptFillCoin";                                   // Set the name for display purposes
167         decimals = 18;                            // Amount of decimals for display purposes
168         symbol = "CFC";                               // Set the symbol for display purposes
169         owner = msg.sender;                               // Set the symbol for display purposes
170     }
171 
172     /* Approves and then calls the receiving contract */
173     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
174         allowed[msg.sender][_spender] = _value;
175         Approval(msg.sender, _spender, _value);
176 
177         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
178         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
179         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
180         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
181         return true;
182     }
183     
184     
185     /// @notice Will cause a certain `_value` of coins minted for `_to`.
186     /// @param _to The address that will receive the coin.
187     /// @param _value The amount of coin they will receive.
188     function mint(address _to, uint _value) public {
189         require(msg.sender == owner); // assuming you have a contract owner
190         mintToken(_to, _value);
191     }
192 
193     /// @notice Will allow multiple minting within a single call to save gas.
194     /// @param _to_list A list of addresses to mint for.
195     /// @param _values The list of values for each respective `_to` address.
196     function airdropMinting(address[] _to_list, uint[] _values) public {
197         require(msg.sender == owner); // assuming you have a contract owner
198         require(_to_list.length == _values.length);
199         for (uint i = 0; i < _to_list.length; i++) {
200             mintToken(_to_list[i], _values[i]);
201         }
202     }
203 
204     /// Internal method shared by `mint()` and `airdropMinting()`.
205     function mintToken(address _to, uint _value) internal {
206         balances[_to] = balances[_to].add(_value);
207         totalSupply = totalSupply.add(_value);
208         require(balances[_to] >= _value && totalSupply >= _value); // overflow checks
209         emit Transfer(address(0), _to, _value);
210     }
211     
212 }