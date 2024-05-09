1 pragma solidity ^0.4.18;
2 
3 /*
4  * ERC223 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  * see https://github.com/ethereum/EIPs/issues/223
7  */
8 contract ERC223 {
9     function totalSupply() constant public returns (uint256 outTotalSupply);
10     function balanceOf( address _owner) constant public returns (uint256 balance);
11     function transfer( address _to, uint256 _value) public returns (bool success);
12     function transfer( address _to, uint256 _value, bytes _data) public returns (bool success);
13     function transferFrom( address _from, address _to, uint256 _value) public returns (bool success);
14     function approve( address _spender, uint256 _value) public returns (bool success);
15     function allowance( address _owner, address _spender) constant public returns (uint256 remaining);
16     event Transfer( address indexed _from, address indexed _to, uint _value, bytes _data);
17     event Approval( address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 
21 contract ERC223Receiver { 
22     /**
23      * @dev Standard ERC223 function that will handle incoming token transfers.
24      *
25      * @param _from  Token sender address.
26      * @param _value Amount of tokens.
27      * @param _data  Transaction metadata.
28      */
29     function tokenFallback(address _from, uint _value, bytes _data) public;
30 }
31 
32 /**
33  * Math operations with safety checks
34  */
35 contract SafeMath {
36     function safeMul(uint a, uint b) internal pure returns (uint) {
37         uint c = a * b;
38         assert(a == 0 || c / a == b);
39         return c;
40     }
41 
42     function safeDiv(uint a, uint b) internal pure returns (uint) {
43         assert(b > 0);
44         uint c = a / b;
45         assert(a == b * c + a % b);
46         return c;
47     }
48 
49     function safeSub(uint a, uint b) internal pure returns (uint) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     function safeAdd(uint a, uint b) internal pure returns (uint) {
55         uint c = a + b;
56         assert(c>=a && c>=b);
57         return c;
58     }
59 
60     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
61         return a >= b ? a : b;
62     }
63 
64     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
65         return a < b ? a : b;
66     }
67 
68     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a >= b ? a : b;
70     }
71 
72     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a < b ? a : b;
74     }
75 
76  
77 }
78 
79 
80 
81 /**
82  * Standard ERC223
83  */
84 contract StandardToken is ERC223, SafeMath {
85         
86     uint256 public supplyNum;
87     
88     uint256 public decimals;
89 
90     /* Actual mapBalances of token holders */
91     mapping(address => uint) mapBalances;
92 
93     /* approve() allowances */
94     mapping (address => mapping (address => uint)) mapApproved;
95 
96     /* Interface declaration */
97     function isToken() public pure returns (bool weAre) {
98         return true;
99     }
100 
101 
102     function totalSupply() constant public returns (uint256 outTotalSupply) {
103         return supplyNum;
104     }
105 
106     
107     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
108         // Standard function transfer similar to ERC20 transfer with no _data .
109         // Added due to backwards compatibility reasons .
110         uint codeLength;
111 
112         assembly {
113             // Retrieve the size of the code on target address, this needs assembly .
114             codeLength := extcodesize(_to)
115         }
116 
117         mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);
118         mapBalances[_to] = safeAdd(mapBalances[_to], _value);
119         
120         if (codeLength > 0) {
121             ERC223Receiver receiver = ERC223Receiver(_to);
122             receiver.tokenFallback(msg.sender, _value, _data);
123         }
124         emit Transfer(msg.sender, _to, _value, _data);
125         return true;
126     }
127     
128     
129     function transfer(address _to, uint _value) public returns (bool) {
130         uint codeLength;
131         bytes memory empty;
132 
133         assembly {
134             // Retrieve the size of the code on target address, this needs assembly .
135             codeLength := extcodesize(_to)
136         }
137 
138         mapBalances[msg.sender] = safeSub(mapBalances[msg.sender], _value);
139         mapBalances[_to] = safeAdd(mapBalances[_to], _value);
140         
141         if (codeLength > 0) {
142             ERC223Receiver receiver = ERC223Receiver(_to);
143             receiver.tokenFallback(msg.sender, _value, empty);
144         }
145         emit Transfer(msg.sender, _to, _value, empty);
146         return true;
147     }
148     
149     
150 
151     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
152         mapApproved[_from][msg.sender] = safeSub(mapApproved[_from][msg.sender], _value);
153         mapBalances[_from] = safeSub(mapBalances[_from], _value);
154         mapBalances[_to] = safeAdd(mapBalances[_to], _value);
155         
156         bytes memory empty;
157         emit Transfer(_from, _to, _value, empty);
158                 
159         return true;
160     }
161 
162     function balanceOf(address _owner) view public returns (uint balance)    {
163         return mapBalances[_owner];
164     }
165 
166     function approve(address _spender, uint _value) public returns (bool success)    {
167 
168         // To change the approve amount you first have to reduce the addresses`
169         //    allowance to zero by calling `approve(_spender, 0)` if it is not
170         //    already 0 to mitigate the race condition described here:
171         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172         require (_value != 0); 
173         require (mapApproved[msg.sender][_spender] == 0);
174 
175         mapApproved[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     function allowance(address _owner, address _spender) view public returns (uint remaining)    {
181         return mapApproved[_owner][_spender];
182     }
183 
184 }
185 
186 
187 
188 
189 /**
190  * Centrally issued Ethereum token.
191  *
192  * We mix in burnable and upgradeable traits.
193  *
194  * Token supply is created in the token contract creation and allocated to owner.
195  * The owner can then transfer from its supply to crowdsale participants.
196  * The owner, or anybody, can burn any excessive tokens they are holding.
197  *
198  */
199 contract BetOnMe is StandardToken {
200 
201     string public name = "BetOnMe";
202     string public symbol = "BOM";
203     
204     
205     address public coinMaster;
206     
207     
208     /** Name and symbol were updated. */
209     event UpdatedInformation(string newName, string newSymbol);
210 
211     function BetOnMe() public {
212         supplyNum = 1000000000000 * (10 ** 18);
213         decimals = 18;
214         coinMaster = msg.sender;
215 
216         // Allocate initial balance to the owner
217         mapBalances[coinMaster] = supplyNum;
218     }
219 
220     /**
221      * Owner can update token information here.
222      *
223      * It is often useful to conceal the actual token association, until
224      * the token operations, like central issuance or reissuance have been completed.
225      * In this case the initial token can be supplied with empty name and symbol information.
226      *
227      * This function allows the token owner to rename the token after the operations
228      * have been completed and then point the audience to use the token contract.
229      */
230     function setTokenInformation(string _name, string _symbol) public {
231         require(msg.sender == coinMaster) ;
232 
233         require(bytes(name).length > 0 && bytes(symbol).length > 0);
234 
235         name = _name;
236         symbol = _symbol;
237         emit UpdatedInformation(name, symbol);
238     }
239     
240     
241     
242     /// transfer dead tokens to contract master
243     function withdrawTokens() external {
244         uint256 fundNow = balanceOf(this);
245         transfer(coinMaster, fundNow);//token
246         
247         uint256 balance = address(this).balance;
248         coinMaster.transfer(balance);//eth
249     }
250 
251 }