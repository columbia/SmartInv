1 pragma solidity ^0.4.11;
2 
3 
4 /* Interface of the ERC223 token */
5 contract ERC223TokenInterface {
6     function name() constant returns (string _name);
7     function symbol() constant returns (string _symbol);
8     function decimals() constant returns (uint8 _decimals);
9     function totalSupply() constant returns (uint256 _supply);
10 
11     function balanceOf(address _owner) constant returns (uint256 _balance);
12 
13     function approve(address _spender, uint256 _value) returns (bool _success);
14     function allowance(address _owner, address spender) constant returns (uint256 _remaining);
15 
16     function transfer(address _to, uint256 _value) returns (bool _success);
17     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success);
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Transfer(address indexed from, address indexed to, uint256 value, bytes metadata);
23 }
24 
25 
26 /* Interface of the contract that is going to receive ERC223 tokens */
27 contract ERC223ContractInterface {
28     function erc223Fallback(address _from, uint256 _value, bytes _data){
29         // to avoid warnings during compilation
30         _from = _from;
31         _value = _value;
32         _data = _data;
33         // Incoming transaction code here
34         throw;
35     }
36 }
37 
38 
39 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
40 contract SafeMath {
41     uint256 constant public MAX_UINT256 =
42     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
43 
44     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
45         if (x > MAX_UINT256 - y) throw;
46         return x + y;
47     }
48 
49     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
50         if (x < y) throw;
51         return x - y;
52     }
53 
54     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         if (y == 0) return 0;
56         if (x > MAX_UINT256 / y) throw;
57         return x * y;
58     }
59 }
60 
61 
62 contract ERC223Token is ERC223TokenInterface, SafeMath {
63 
64     /*
65       Storage of the contract
66     */
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowances;
70 
71     string public name;
72     string public symbol;
73     uint8 public decimals;
74     uint256 public totalSupply;
75 
76 
77     /*
78       Getters
79     */
80 
81     function name() constant returns (string _name) {
82         return name;
83     }
84 
85     function symbol() constant returns (string _symbol) {
86         return symbol;
87     }
88 
89     function decimals() constant returns (uint8 _decimals) {
90         return decimals;
91     }
92 
93     function totalSupply() constant returns (uint256 _supply) {
94         return totalSupply;
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 _balance) {
98         return balances[_owner];
99     }
100 
101 
102     /*
103       Allow to spend
104     */
105 
106     function approve(address _spender, uint256 _value) returns (bool _success) {
107         allowances[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 _remaining) {
113         return allowances[_owner][_spender];
114     }
115 
116 
117     /*
118       Transfer
119     */
120 
121     function transfer(address _to, uint256 _value) returns (bool _success) {
122         bytes memory emptyMetadata;
123         __transfer(msg.sender, _to, _value, emptyMetadata);
124         return true;
125     }
126 
127     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success)
128     {
129         __transfer(msg.sender, _to, _value, _metadata);
130         Transfer(msg.sender, _to, _value, _metadata);
131         return true;
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
135         if (allowances[_from][msg.sender] < _value) throw;
136 
137         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
138         bytes memory emptyMetadata;
139         __transfer(_from, _to, _value, emptyMetadata);
140         return true;
141     }
142 
143     function __transfer(address _from, address _to, uint256 _value, bytes _metadata) internal
144     {
145         if (_from == _to) throw;
146         if (_value == 0) throw;
147         if (balanceOf(_from) < _value) throw;
148 
149         balances[_from] = safeSub(balanceOf(_from), _value);
150         balances[_to] = safeAdd(balanceOf(_to), _value);
151 
152         if (isContract(_to)) {
153             ERC223ContractInterface receiverContract = ERC223ContractInterface(_to);
154             receiverContract.erc223Fallback(_from, _value, _metadata);
155         }
156 
157         Transfer(_from, _to, _value);
158     }
159 
160 
161     /*
162       Helpers
163     */
164 
165     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
166     function isContract(address _addr) internal returns (bool _isContract) {
167         _addr = _addr; // to avoid warnings during compilation
168 
169         uint256 length;
170         assembly {
171             //retrieve the size of the code on target address, this needs assembly
172             length := extcodesize(_addr)
173         }
174         return (length > 0);
175     }
176 }
177 
178 contract DASToken is ERC223Token {
179     mapping (address => bool) blockedAccounts;
180     address public secretaryGeneral;
181 
182 
183     // Constructor
184     function DASToken(
185             string _name,
186             string _symbol,
187             uint8 _decimals,
188             uint256 _totalSupply,
189             address _initialTokensHolder) {
190         secretaryGeneral = msg.sender;
191         name = _name;
192         symbol = _symbol;
193         decimals = _decimals;
194         totalSupply = _totalSupply;
195         balances[_initialTokensHolder] = _totalSupply;
196     }
197 
198 
199     modifier onlySecretaryGeneral {
200         if (msg.sender != secretaryGeneral) throw;
201         _;
202     }
203 
204 
205     // block account
206     function blockAccount(address _account) onlySecretaryGeneral {
207         blockedAccounts[_account] = true;
208     }
209 
210     // unblock account
211     function unblockAccount(address _account) onlySecretaryGeneral {
212         blockedAccounts[_account] = false;
213     }
214 
215     // check is account blocked
216     function isAccountBlocked(address _account) returns (bool){
217         return blockedAccounts[_account];
218     }
219 
220     // override transfer methods to throw on blocked accounts
221     function transfer(address _to, uint256 _value) returns (bool _success) {
222         if (blockedAccounts[msg.sender]) {
223             throw;
224         }
225         return super.transfer(_to, _value);
226     }
227 
228     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success) {
229         if (blockedAccounts[msg.sender]) {
230             throw;
231         }
232         return super.transfer(_to, _value, _metadata);
233     }
234 
235     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
236         if (blockedAccounts[_from]) {
237             throw;
238         }
239         return super.transferFrom(_from, _to, _value);
240     }
241 }