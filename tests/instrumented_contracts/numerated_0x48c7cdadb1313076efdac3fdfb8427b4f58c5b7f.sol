1 pragma solidity ^0.4.11;
2 
3 
4 /*
5   Author: Victor Mezrin  victor@mezrin.com
6 */
7 
8 
9 /* Interface of the ERC223 token */
10 contract ERC223TokenInterface {
11     function name() constant returns (string _name);
12     function symbol() constant returns (string _symbol);
13     function decimals() constant returns (uint8 _decimals);
14     function totalSupply() constant returns (uint256 _supply);
15 
16     function balanceOf(address _owner) constant returns (uint256 _balance);
17 
18     function approve(address _spender, uint256 _value) returns (bool _success);
19     function allowance(address _owner, address spender) constant returns (uint256 _remaining);
20 
21     function transfer(address _to, uint256 _value) returns (bool _success);
22     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success);
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Transfer(address indexed from, address indexed to, uint256 value, bytes metadata);
28 }
29 
30 
31 /* Interface of the contract that is going to receive ERC223 tokens */
32 contract ERC223ContractInterface {
33     function erc223Fallback(address _from, uint256 _value, bytes _data){
34         // to avoid warnings during compilation
35         _from = _from;
36         _value = _value;
37         _data = _data;
38         // Incoming transaction code here
39         throw;
40     }
41 }
42 
43 
44 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
45 contract SafeMath {
46     uint256 constant public MAX_UINT256 =
47     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
48 
49     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
50         if (x > MAX_UINT256 - y) throw;
51         return x + y;
52     }
53 
54     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         if (x < y) throw;
56         return x - y;
57     }
58 
59     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
60         if (y == 0) return 0;
61         if (x > MAX_UINT256 / y) throw;
62         return x * y;
63     }
64 }
65 
66 
67 contract ERC223Token is ERC223TokenInterface, SafeMath {
68 
69     /*
70       Storage of the contract
71     */
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowances;
75 
76     string public name;
77     string public symbol;
78     uint8 public decimals;
79     uint256 public totalSupply;
80 
81 
82     /*
83       Getters
84     */
85 
86     function name() constant returns (string _name) {
87         return name;
88     }
89 
90     function symbol() constant returns (string _symbol) {
91         return symbol;
92     }
93 
94     function decimals() constant returns (uint8 _decimals) {
95         return decimals;
96     }
97 
98     function totalSupply() constant returns (uint256 _supply) {
99         return totalSupply;
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 _balance) {
103         return balances[_owner];
104     }
105 
106 
107     /*
108       Allow to spend
109     */
110 
111     function approve(address _spender, uint256 _value) returns (bool _success) {
112         allowances[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant returns (uint256 _remaining) {
118         return allowances[_owner][_spender];
119     }
120 
121 
122     /*
123       Transfer
124     */
125 
126     function transfer(address _to, uint256 _value) returns (bool _success) {
127         bytes memory emptyMetadata;
128         __transfer(msg.sender, _to, _value, emptyMetadata);
129         return true;
130     }
131 
132     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success)
133     {
134         __transfer(msg.sender, _to, _value, _metadata);
135         Transfer(msg.sender, _to, _value, _metadata);
136         return true;
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
140         if (allowances[_from][msg.sender] < _value) throw;
141 
142         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
143         bytes memory emptyMetadata;
144         __transfer(_from, _to, _value, emptyMetadata);
145         return true;
146     }
147 
148     function __transfer(address _from, address _to, uint256 _value, bytes _metadata) internal
149     {
150         if (_from == _to) throw;
151         if (_value == 0) throw;
152         if (balanceOf(_from) < _value) throw;
153 
154         balances[_from] = safeSub(balanceOf(_from), _value);
155         balances[_to] = safeAdd(balanceOf(_to), _value);
156 
157         if (isContract(_to)) {
158             ERC223ContractInterface receiverContract = ERC223ContractInterface(_to);
159             receiverContract.erc223Fallback(_from, _value, _metadata);
160         }
161 
162         Transfer(_from, _to, _value);
163     }
164 
165 
166     /*
167       Helpers
168     */
169 
170     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
171     function isContract(address _addr) internal returns (bool _isContract) {
172         _addr = _addr; // to avoid warnings during compilation
173 
174         uint256 length;
175         assembly {
176             //retrieve the size of the code on target address, this needs assembly
177             length := extcodesize(_addr)
178         }
179         return (length > 0);
180     }
181 }
182 
183 
184 
185 // ERC223 token with the ability for the owner to block any account
186 contract DASToken is ERC223Token {
187     mapping (address => bool) blockedAccounts;
188     address public secretaryGeneral;
189 
190 
191     // Constructor
192     function DASToken(
193             string _name,
194             string _symbol,
195             uint8 _decimals,
196             uint256 _totalSupply,
197             address _initialTokensHolder) {
198         secretaryGeneral = msg.sender;
199         name = _name;
200         symbol = _symbol;
201         decimals = _decimals;
202         totalSupply = _totalSupply;
203         balances[_initialTokensHolder] = _totalSupply;
204     }
205 
206 
207     modifier onlySecretaryGeneral {
208         if (msg.sender != secretaryGeneral) throw;
209         _;
210     }
211 
212 
213     // block account
214     function blockAccount(address _account) onlySecretaryGeneral {
215         blockedAccounts[_account] = true;
216     }
217 
218     // unblock account
219     function unblockAccount(address _account) onlySecretaryGeneral {
220         blockedAccounts[_account] = false;
221     }
222 
223     // check is account blocked
224     function isAccountBlocked(address _account) returns (bool){
225         return blockedAccounts[_account];
226     }
227 
228     // override transfer methods to throw on blocked accounts
229     function transfer(address _to, uint256 _value) returns (bool _success) {
230         if (blockedAccounts[msg.sender]) {
231             throw;
232         }
233         return super.transfer(_to, _value);
234     }
235 
236     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success) {
237         if (blockedAccounts[msg.sender]) {
238             throw;
239         }
240         return super.transfer(_to, _value, _metadata);
241     }
242 
243     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
244         if (blockedAccounts[_from]) {
245             throw;
246         }
247         return super.transferFrom(_from, _to, _value);
248     }
249 }