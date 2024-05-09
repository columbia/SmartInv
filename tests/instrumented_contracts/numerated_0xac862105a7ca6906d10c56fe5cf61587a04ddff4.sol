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
164 
165 library StringUtils {
166     function strcpy(string dest, uint off, string src) private {
167         var len = bytes(src).length;
168         assembly {
169             dest := add(add(dest, off), 32)
170             src := add(src, 32)
171         }
172         
173         // Copy word-length chunks while possible
174         for(; len >= 32; len -= 32) {
175             assembly {
176                 mstore(add(dest, off), mload(src))
177                 dest := add(dest, 32)
178                 src := add(src, 32)
179             }
180         }
181 
182         // Copy remaining bytes
183         uint mask = 256 ** (32 - len) - 1;
184         assembly {
185             let srcpart := and(mload(src), not(mask))
186             let destpart := and(mload(dest), mask)
187             mstore(dest, or(destpart, srcpart))
188         }
189     }
190     
191     function concat(string a, string b) internal returns(string ret) {
192         ret = new string(bytes(a).length + bytes(b).length);
193         strcpy(ret, 0, a);
194         strcpy(ret, bytes(a).length, b);
195     }
196 }
197 
198 contract ShibbolethTokenFactory {
199     using StringUtils for *;
200     
201     ENS ens;
202     // namehash('myshibbol.eth')
203     bytes32 constant rootNode = 0x2952863bce80be8e995bbf003c7a1901dd801bb90c09327da9d029d0496c7010;
204     mapping(bytes32=>address) public addr;
205     
206     event NewToken(string indexed symbol, string _symbol, string name, address addr);
207     
208     function ShibbolethTokenFactory(ENS _ens) {
209         ens = _ens;
210     }
211     
212     function create(string symbol) returns(address) {
213         var name = symbol.concat(".myshibbol.eth");
214         var subnode = sha3(rootNode, sha3(symbol));
215         require(ens.owner(subnode) == 0);
216 
217         var token = create(symbol, name);
218 
219         ens.setSubnodeOwner(rootNode, sha3(symbol), this);
220         ens.setResolver(subnode, this);
221         addr[subnode] = token;
222 
223         return token;
224     }
225     
226     function create(string symbol, string name) returns(address) {
227         var token = new ShibbolethToken(ens, name, symbol, msg.sender);
228         NewToken(symbol, symbol, name, token);
229         return token;
230     }
231     
232     function abi(bytes32 node) constant returns (uint256, bytes) {
233         return (1, '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"issuer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"node","type":"bytes32"}],"name":"addr","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"version","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_issuer","type":"address"}],"name":"setIssuer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"node","type":"bytes32"}],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"issue","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"_ens","type":"address"},{"name":"_name","type":"string"},{"name":"_symbol","type":"string"},{"name":"_issuer","type":"address"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]');
234     }
235 }