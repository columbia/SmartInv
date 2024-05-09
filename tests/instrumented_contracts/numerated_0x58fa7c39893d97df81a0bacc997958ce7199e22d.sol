1 pragma solidity ^0.4.18;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     // solhint-disable-next-line no-simple-event-func-name  
46     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract EIP20 is EIP20Interface {
51 
52     uint256 constant private MAX_UINT256 = 2**256 - 1;
53     mapping (address => uint256) public balances;
54     mapping (address => mapping (address => uint256)) public allowed;
55     /*
56     NOTE:
57     The following variables are OPTIONAL vanities. One does not have to include them.
58     They allow one to customise the token contract & in no way influences the core functionality.
59     Some wallets/interfaces might not even bother to look at this information.
60     */
61     string public name;                   //fancy name: eg Simon Bucks
62     uint8 public decimals;                //How many decimals to show.
63     string public symbol;                 //An identifier: eg SBX
64 
65     function EIP20(
66         uint256 _initialAmount,
67         string _tokenName,
68         uint8 _decimalUnits,
69         string _tokenSymbol
70     ) public {
71         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
72         totalSupply = _initialAmount;                        // Update total supply
73         name = _tokenName;                                   // Set the name for display purposes
74         decimals = _decimalUnits;                            // Amount of decimals for display purposes
75         symbol = _tokenSymbol;                               // Set the symbol for display purposes
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         require(balances[msg.sender] >= _value);
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         uint256 allowance = allowed[_from][msg.sender];
88         require(balances[_from] >= _value && allowance >= _value);
89         balances[_to] += _value;
90         balances[_from] -= _value;
91         if (allowance < MAX_UINT256) {
92             allowed[_from][msg.sender] -= _value;
93         }
94         emit Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }   
111 }
112 
113 contract EIP20Factory {
114 
115     mapping(address => address[]) public created;
116     mapping(address => bool) public isEIP20; //verify without having to do a bytecode check.
117     bytes public EIP20ByteCode; // solhint-disable-line var-name-mixedcase  
118 
119     function EIP20Factory() public {
120         //upon creation of the factory, deploy a EIP20 (parameters are meaningless) and store the bytecode provably.
121         address verifiedToken = createEIP20(10000, "Verify Token", 3, "VTX");
122         EIP20ByteCode = codeAt(verifiedToken);
123     }
124 
125     //verifies if a contract that has been deployed is a Human Standard Token.
126     //NOTE: This is a very expensive function, and should only be used in an eth_call. ~800k gas
127     function verifyEIP20(address _tokenContract) public view returns (bool) {
128         bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
129 
130         if (fetchedTokenByteCode.length != EIP20ByteCode.length) {
131             return false; //clear mismatch
132         }
133 
134       //starting iterating through it if lengths match
135         for (uint i = 0; i < fetchedTokenByteCode.length; i++) {
136             if (fetchedTokenByteCode[i] != EIP20ByteCode[i]) {
137                 return false;
138             }
139         }
140         return true;
141     }
142     
143     function createEIP20(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) 
144         public 
145     returns (address) {
146 
147         EIP20 newToken = (new EIP20(_initialAmount, _name, _decimals, _symbol));
148         created[msg.sender].push(address(newToken));
149         isEIP20[address(newToken)] = true;
150         //the factory will own the created tokens. You must transfer them.
151         newToken.transfer(msg.sender, _initialAmount); 
152         return address(newToken);
153     }
154 
155     //for now, keeping this internal. Ideally there should also be a live version of this that 
156     // any contract can use, lib-style.
157     //retrieves the bytecode at a specific address.
158     function codeAt(address _addr) internal view returns (bytes outputCode) {
159         assembly { // solhint-disable-line no-inline-assembly   
160             // retrieve the size of the code, this needs assembly
161             let size := extcodesize(_addr)
162             // allocate output byte array - this could also be done without assembly
163             // by using outputCode = new bytes(size)
164             outputCode := mload(0x40)
165             // new "memory end" including padding
166             mstore(0x40, add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
167             // store length in memory
168             mstore(outputCode, size)
169             // actually retrieve the code, this needs assembly
170             extcodecopy(_addr, add(outputCode, 0x20), 0, size)
171         }
172     }
173 }