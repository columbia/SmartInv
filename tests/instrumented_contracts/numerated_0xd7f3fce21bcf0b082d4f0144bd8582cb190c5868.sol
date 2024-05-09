1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 pragma solidity ^0.4.6;
7 
8 contract SafeMath {
9     //internals
10 
11     function safeMul(uint a, uint b) internal returns (uint) {
12       uint c = a * b;
13       assert(a == 0 || c / a == b);
14       return c;
15     }
16 
17     function safeSub(uint a, uint b) internal returns (uint) {
18       assert(b <= a);
19       return a - b;
20     }
21 
22     function safeAdd(uint a, uint b) internal returns (uint) {
23       uint c = a + b;
24       assert(c>=a && c>=b);
25       return c;
26     }
27 
28     function assert(bool assertion) internal {
29       if (!assertion) throw;
30     }
31 }
32 
33 /**
34  * ERC 20 token
35  *
36  * https://github.com/ethereum/EIPs/issues/20
37  */
38 contract Token {
39 
40     /// @return total amount of tokens
41     function totalSupply() constant returns (uint256 supply) {}
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance) {}
46 
47     /// @notice send `_value` token to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _value) returns (bool success) {}
52 
53     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
59 
60     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of wei to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) returns (bool success) {}
65 
66     /// @param _owner The address of the account owning tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @return Amount of remaining tokens allowed to spent
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74 }
75 
76 /**
77  * ERC 20 token
78  *
79  * https://github.com/ethereum/EIPs/issues/20
80  */
81 contract StandardToken is Token {
82 
83     /**
84      * Reviewed:
85      * - Interger overflow = OK, checked
86      */
87 
88     function transfer(address _to, uint256 _value) returns (bool success) {
89       //Default assumes totalSupply can't be over max (2^256 - 1).
90       //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
91       //Replace the if with this one instead.
92       if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93         //if (balances[msg.sender] >= _value && _value > 0) {
94         balances[msg.sender] -= _value;
95         balances[_to] += _value;
96         Transfer(msg.sender, _to, _value);
97         return true;
98       } else { return false; }
99     }
100 
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102         //same as above. Replace this line with the following if you want to protect against wrapping uints.
103       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
104         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105         balances[_to] += _value;
106         balances[_from] -= _value;
107         allowed[_from][msg.sender] -= _value;
108         Transfer(_from, _to, _value);
109         return true;
110       } else { return false; }
111     }
112 
113     function balanceOf(address _owner) constant returns (uint256 balance) {
114       return balances[_owner];
115     }
116 
117     function approve(address _spender, uint256 _value) returns (bool success) {
118       allowed[msg.sender][_spender] = _value;
119       Approval(msg.sender, _spender, _value);
120       return true;
121     }
122 
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124       return allowed[_owner][_spender];
125     }
126 
127     mapping (address => uint256) balances;
128 
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     uint256 public totalSupply;
132 
133 }
134 
135 
136 /**
137  *  AntiqueCoin Main Contract
138  *
139  */
140 contract AntiqueCoin is StandardToken, SafeMath {
141 
142     string public name = "AntiqueCoin";
143     string public symbol = "1XNC";
144     uint public decimals = 18;
145     address public founder = 0x0;
146     uint private counter = 0;
147 
148     mapping (bytes32 => address) public antiques;
149 
150 
151     event RegistrationAntique(bytes32 hash);
152     event TransferAntique(bytes32 filehash, address from, address to);
153 
154     // Initial founder address (set in constructor)
155 
156     function AntiqueCoin(address _founder,  uint256 _totalSupply) {
157       founder = _founder;
158       balances[_founder] = _totalSupply;
159       totalSupply = _totalSupply;
160     }
161 
162     function registerAntique(bytes32 _fileHash) returns (bool success){
163       if (msg.sender != founder) throw;
164     //  if (antiques[_fileHash] != 0x0) throw;
165       antiques[_fileHash] = msg.sender;
166       RegistrationAntique(_fileHash);
167       return true;
168     }
169 
170 
171     function transferAntique(address _to, bytes32 _fileHash) returns (bool success){
172       if (antiques[_fileHash] != msg.sender) throw;
173       antiques[_fileHash] = _to;
174       TransferAntique(_fileHash, msg.sender, _to);
175       return true;
176     }
177 
178 
179     function changeFounder(address _newFounder) returns (bool success){
180       if (msg.sender!=founder) throw;
181       balances[_newFounder] = safeAdd(balances[_newFounder], balances[founder]);
182       balances[founder] = 0;
183       founder = _newFounder;
184       return true;
185     }
186 
187     function() {
188       throw;
189     }
190 
191 }