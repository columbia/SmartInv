1 pragma solidity ^0.4.8;
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
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
55         require(balances[msg.sender] >= _value);
56         balances[msg.sender] -= _value;
57         balances[_to] += _value;
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 contract HumanStandardToken is StandardToken {
92 
93     /* Public variables of the token */
94 
95     /*
96     NOTE:
97     The following variables are OPTIONAL vanities. One does not have to include them.
98     They allow one to customise the token contract & in no way influences the core functionality.
99     Some wallets/interfaces might not even bother to look at this information.
100     */
101     string public name;                   //fancy name: eg Simon Bucks
102     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
103     string public symbol;                 //An identifier: eg SBX
104     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
105 
106     function HumanStandardToken(
107         uint256 _initialAmount,
108         string _tokenName,
109         uint8 _decimalUnits,
110         string _tokenSymbol
111         ) {
112         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
113         totalSupply = _initialAmount;                        // Update total supply
114         name = _tokenName;                                   // Set the name for display purposes
115         decimals = _decimalUnits;                            // Amount of decimals for display purposes
116         symbol = _tokenSymbol;                               // Set the symbol for display purposes
117     }
118 
119     /* Approves and then calls the receiving contract */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
125         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
126         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
127         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
128         return true;
129     }
130 }
131 contract HumanStandardTokenFactory {
132 
133     mapping(address => address[]) public created;
134     mapping(address => bool) public isHumanToken; //verify without having to do a bytecode check.
135     bytes public humanStandardByteCode;
136 
137     function HumanStandardTokenFactory() {
138       //upon creation of the factory, deploy a HumanStandardToken (parameters are meaningless) and store the bytecode provably.
139       address verifiedToken = createHumanStandardToken(10000, "Verify Token", 3, "VTX");
140       humanStandardByteCode = codeAt(verifiedToken);
141     }
142 
143     //verifies if a contract that has been deployed is a Human Standard Token.
144     //NOTE: This is a very expensive function, and should only be used in an eth_call. ~800k gas
145     function verifyHumanStandardToken(address _tokenContract) constant returns (bool) {
146       bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
147 
148       if (fetchedTokenByteCode.length != humanStandardByteCode.length) {
149         return false; //clear mismatch
150       }
151 
152       //starting iterating through it if lengths match
153       for (uint i = 0; i < fetchedTokenByteCode.length; i ++) {
154         if (fetchedTokenByteCode[i] != humanStandardByteCode[i]) {
155           return false;
156         }
157       }
158 
159       return true;
160     }
161 
162     //for now, keeping this internal. Ideally there should also be a live version of this that any contract can use, lib-style.
163     //retrieves the bytecode at a specific address.
164     function codeAt(address _addr) internal constant returns (bytes o_code) {
165       assembly {
166           // retrieve the size of the code, this needs assembly
167           let size := extcodesize(_addr)
168           // allocate output byte array - this could also be done without assembly
169           // by using o_code = new bytes(size)
170           o_code := mload(0x40)
171           // new "memory end" including padding
172           mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
173           // store length in memory
174           mstore(o_code, size)
175           // actually retrieve the code, this needs assembly
176           extcodecopy(_addr, add(o_code, 0x20), 0, size)
177       }
178     }
179 
180     function createHumanStandardToken(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) returns (address) {
181 
182         HumanStandardToken newToken = (new HumanStandardToken(_initialAmount, _name, _decimals, _symbol));
183         created[msg.sender].push(address(newToken));
184         isHumanToken[address(newToken)] = true;
185         newToken.transfer(msg.sender, _initialAmount); //the factory will own the created tokens. You must transfer them.
186         return address(newToken);
187     }
188 }