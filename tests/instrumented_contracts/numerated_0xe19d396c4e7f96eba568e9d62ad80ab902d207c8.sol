1 pragma solidity ^0.4.8;
2 
3 contract ENS {
4     function owner(bytes32 node) constant returns(address);
5     function resolver(bytes32 node) constant returns(address);
6     function ttl(bytes32 node) constant returns(uint64);
7     function setOwner(bytes32 node, address owner);
8     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
9     function setResolver(bytes32 node, address resolver);
10     function setTTL(bytes32 node, uint64 ttl);
11 
12     // Logged when the owner of a node assigns a new owner to a subnode.
13     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
14 
15     // Logged when the owner of a node transfers ownership to a new account.
16     event Transfer(bytes32 indexed node, address owner);
17 
18     // Logged when the resolver for a node changes.
19     event NewResolver(bytes32 indexed node, address resolver);
20 
21     // Logged when the TTL of a node changes
22     event NewTTL(bytes32 indexed node, uint64 ttl);
23 }
24 
25 contract ReverseRegistrar {
26     function setName(string name) returns (bytes32 node);
27     function claimWithResolver(address owner, address resolver) returns (bytes32 node);
28 }
29 
30 contract Token {
31     /* This is a slight change to the ERC20 base standard.
32     function totalSupply() constant returns (uint256 supply);
33     is replaced with:
34     uint256 public totalSupply;
35     This automatically creates a getter function for the totalSupply.
36     This is moved to the base contract since public getter functions are not
37     currently recognised as an implementation of the matching abstract
38     function by the compiler.
39     */
40     /// total amount of tokens
41     uint256 public totalSupply;
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 
47     /// @notice send `_value` token to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _value) returns (bool success);
52 
53     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
59 
60     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of tokens to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) returns (bool success);
65 
66     /// @param _owner The address of the account owning tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @return Amount of remaining tokens allowed to spent
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 contract StandardToken is Token {
76 
77     function transfer(address _to, uint256 _value) returns (bool success) {
78         //Default assumes totalSupply can't be over max (2^256 - 1).
79         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
80         //Replace the if with this one instead.
81         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
82         if (balances[msg.sender] >= _value) {
83             balances[msg.sender] -= _value;
84             balances[_to] += _value;
85             Transfer(msg.sender, _to, _value);
86             return true;
87         } else { return false; }
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
91         //same as above. Replace this line with the following if you want to protect against wrapping uints.
92         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
94             balances[_to] += _value;
95             balances[_from] -= _value;
96             allowed[_from][msg.sender] -= _value;
97             Transfer(_from, _to, _value);
98             return true;
99         } else { return false; }
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118 }
119 
120 contract ShibbolethToken is StandardToken {
121     ENS ens;    
122 
123     string public name;
124     string public symbol;
125     address public issuer;
126 
127     function version() constant returns(string) { return "S0.1"; }
128     function decimals() constant returns(uint8) { return 0; }
129     function name(bytes32 node) constant returns(string) { return name; }
130     
131     modifier issuer_only {
132         require(msg.sender == issuer);
133         _;
134     }
135     
136     function ShibbolethToken(ENS _ens, string _name, string _symbol, address _issuer) {
137         ens = _ens;
138         name = _name;
139         symbol = _symbol;
140         issuer = _issuer;
141         
142         var rr = ReverseRegistrar(ens.owner(0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2));
143         rr.claimWithResolver(this, this);
144     }
145     
146     function issue(uint _value) issuer_only {
147         require(totalSupply + _value >= _value);
148         balances[issuer] += _value;
149         totalSupply += _value;
150         Transfer(0, issuer, _value);
151     }
152     
153     function burn(uint _value) issuer_only {
154         require(_value <= balances[issuer]);
155         balances[issuer] -= _value;
156         totalSupply -= _value;
157         Transfer(issuer, 0, _value);
158     }
159     
160     function setIssuer(address _issuer) issuer_only {
161         issuer = _issuer;
162     }
163 }