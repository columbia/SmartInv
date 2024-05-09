1 pragma solidity ^0.4.15;
2 //Owner Contract-For Defining Owner and Transferring Ownership
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() public {
7         owner = 0x2e1977127F682723C778bBcac576A4aF2c0e790d;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal constant returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal constant returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract TokenRecipient {
52     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
53 }
54 
55 
56 
57 //Token Format
58 contract ERC20 is Ownable {
59     using SafeMath for uint256;
60     //Public Variables of the token
61     string public name;
62     string public symbol;
63     uint8 public decimals;
64     uint256 public totalSupply;
65 
66 
67     mapping (address => uint256) public balances;
68 
69     mapping (address => mapping (address => uint256)) public allowed;
70 
71     /* This generates a public event on the blockchain that will notify clients */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed _owner, address indexed _spender, uint _value);
74 
75     //Constructor
76     function ERC20(
77     uint256 _initialSupply,
78     string _tokenName,
79     uint8 _decimalUnits,
80     string _tokenSymbol
81     ) public
82     {
83 
84         balances[0x2e1977127F682723C778bBcac576A4aF2c0e790d] = _initialSupply;
85         totalSupply = _initialSupply;
86         decimals = _decimalUnits;
87         symbol = _tokenSymbol;
88         name = _tokenName;
89     }
90 
91     /* public methods */
92     function transfer(address _to, uint256 _value) public  returns (bool) {
93 
94 
95         bool status = transferInternal(msg.sender, _to, _value);
96 
97         require(status == true);
98 
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103 
104 
105         allowed[msg.sender][_spender] = _value;
106 
107         Approval(msg.sender, _spender, _value);
108 
109         return true;
110     }
111 
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
113 
114 
115         TokenRecipient spender = TokenRecipient(_spender);
116 
117         if (approve(_spender, _value)) {
118             spender.receiveApproval(msg.sender, _value, this, _extraData);
119             return true;
120         }
121     }
122 
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
124 
125 
126         if (allowed[_from][msg.sender] < _value) {
127             return false;
128         }
129 
130         bool _success = transferInternal(_from, _to, _value);
131 
132         if (_success) {
133             allowed[_from][msg.sender] -= _value;
134         }
135 
136         return _success;
137     }
138 
139     /*constant functions*/
140     function totalSupply() public constant returns (uint256) {
141         return totalSupply;
142     }
143 
144     function balanceOf(address _address) public constant returns (uint256 balance) {
145         return balances[_address];
146     }
147 
148     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151 
152     /* internal functions*/
153     function setBalance(address _holder, uint256 _amount) internal {
154         balances[_holder] = _amount;
155     }
156 
157     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
158 
159         if (_value == 0) {
160             Transfer(_from, _to, _value);
161 
162             return true;
163         }
164 
165         if (balances[_from] < _value) {
166             return false;
167         }
168 
169         setBalance(_from, balances[_from].sub(_value));
170         setBalance(_to, balances[_to].add(_value));
171 
172         Transfer(_from, _to, _value);
173 
174         return true;
175     }
176 }
177 
178 contract ERC223 {
179     event Transfer(address indexed from, address indexed to, uint value, bytes  data);
180     function transfer(address to, uint value, bytes data) public returns (bool ok);
181     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
182 }
183 
184 
185 contract ContractReceiver {
186     function tokenFallback(address _from, uint _value, bytes _data) public;
187 }
188 
189 
190 /******************************************/
191 /** Axpire TOKEN **/
192 /******************************************/
193 contract AxpireToken is ERC223,ERC20 {
194 
195     uint256 initialSupply= 350000000 * 10**8;
196     string tokenName="aXpire Token";
197     string tokenSymbol="AXP";
198     uint8 decimalUnits=8;
199 
200     //Constructor
201     function AxpireToken() public
202     ERC20(initialSupply, tokenName, decimalUnits, tokenSymbol)
203     {
204         owner = 0x2e1977127F682723C778bBcac576A4aF2c0e790d;
205         //Assigning total no of tokens
206         balances[owner] = initialSupply;
207         totalSupply = initialSupply;
208     }
209 
210 
211     function transfer(address to, uint256 value, bytes data) public returns (bool success) {
212 
213         bool status = transferInternal(msg.sender, to, value, data);
214 
215         return status;
216     }
217 
218     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool success) {
219 
220         bool status = transferInternal(msg.sender, to, value, data, true, customFallback);
221 
222         return status;
223     }
224 
225     // rollback changes to transferInternal for transferFrom
226     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
227 
228         if (allowed[_from][msg.sender] < _value) {
229             return false;
230         }
231 
232         bool _success = super.transferInternal(_from, _to, _value);
233 
234         if (_success) {
235             allowed[_from][msg.sender] -= _value;
236         }
237 
238         return _success;
239     }
240 
241     function transferInternal(address from, address to, uint256 value, bytes data) internal returns (bool success) {
242         return transferInternal(from, to, value, data, false, "");
243     }
244 
245     function transferInternal(
246     address from,
247     address to,
248     uint256 value,
249     bytes data,
250     bool useCustomFallback,
251     string customFallback
252     )
253     internal returns (bool success)
254     {
255         bool status = super.transferInternal(from, to, value);
256 
257         if (status) {
258             if (isContract(to)) {
259                 ContractReceiver receiver = ContractReceiver(to);
260 
261                 if (useCustomFallback) {
262                     // solhint-disable-next-line avoid-call-value
263                     require(receiver.call.value(0)(bytes4(keccak256(customFallback)), from, value, data) == true);
264                 } else {
265                     receiver.tokenFallback(from, value, data);
266                 }
267             }
268 
269             Transfer(from, to, value, data);
270         }
271 
272         return status;
273     }
274 
275     function transferInternal(address from, address to, uint256 value) internal returns (bool success) {
276 
277         bytes memory data;
278 
279         return transferInternal(from, to, value, data, false, "");
280     }
281 
282     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
283     function isContract(address _addr) private returns (bool) {
284         uint length;
285         assembly {
286         //retrieve the size of the code on target address, this needs assembly
287         length := extcodesize(_addr)
288         }
289         return (length > 0);
290     }
291 
292 }