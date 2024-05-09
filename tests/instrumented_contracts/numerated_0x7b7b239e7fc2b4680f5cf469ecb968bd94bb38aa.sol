1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7 
8     function safeMul(uint a, uint b)pure internal returns (uint) {
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint a, uint b)pure internal returns (uint) {
15         assert(b > 0);
16         uint c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function safeSub(uint a, uint b)pure internal returns (uint) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint a, uint b)pure internal returns (uint) {
27         uint c = a + b;
28         assert(c>=a && c>=b);
29         return c;
30     }
31 }
32 
33 /*
34  * Base Token for ERC20 compatibility
35  * ERC20 interface 
36  * see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 {
39     function balanceOf(address who) public view returns (uint);
40     function allowance(address owner, address spender) public view returns (uint);
41     function transfer(address to, uint value) public returns (bool ok);
42     function transferFrom(address from, address to, uint value) public returns (bool ok);
43     function approve(address spender, uint value) public returns (bool ok);
44     event Transfer(address indexed from, address indexed to, uint value);
45     event Approval(address indexed owner, address indexed spender, uint value);
46 }
47 
48 contract ERC223Interface {
49     function transfer(address to, uint value, bytes data) public returns (bool ok); // ERC223
50     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
51 }
52 
53 /*
54  * Contract that is working with ERC223 tokens
55  */
56  
57 contract ContractReceiver {
58     function tokenFallback(address _from, uint _value, bytes _data) public;
59 }
60 
61 /*
62  * Ownable
63  *
64  * Base contract with an owner.
65  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
66  */
67 contract Ownable {
68     /* Address of the owner */
69     address public owner;
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address newOwner) onlyOwner public{
81         require(newOwner != owner);
82         require(newOwner != address(0));
83         owner = newOwner;
84     }
85 
86 }
87 
88 /**
89  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
90  *
91  * Based on code by FirstBlood:
92  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20, SafeMath, ERC223Interface {
95 
96     /* Actual balances of token holders */
97     mapping(address => uint) balances;
98     uint public totalSupply;
99 
100     /* approve() allowances */
101     mapping (address => mapping (address => uint)) internal allowed;
102     /**
103      *
104      * Fix for the ERC20 short address attack
105      *
106      * http://vessenes.com/the-erc20-short-address-attack-explained/
107      */
108     modifier onlyPayloadSize(uint size) {
109         if(msg.data.length < size + 4) {
110             revert();
111         }
112         _;
113     }
114     /**
115      * @dev Transfer the specified amount of tokens to the specified address.
116      *    Invokes the `tokenFallback` function if the recipient is a contract.
117      *    The token transfer fails if the recipient is a contract
118      *    but does not implement the `tokenFallback` function
119      *    or the fallback function to receive funds.
120      *
121      * @param _to    Receiver address.
122      * @param _value Amount of tokens that will be transferred.
123      * @param _data    Transaction metadata.
124      */
125     function transfer(address _to, uint _value, bytes _data)
126     onlyPayloadSize(2 * 32) 
127     public
128     returns (bool success) 
129     {
130         require(_to != address(0));
131         if (balances[msg.sender] >= _value && _value > 0) {
132             // Standard function transfer similar to ERC20 transfer with no _data .
133             // Added due to backwards compatibility reasons .
134             uint codeLength;
135 
136             assembly {
137             // Retrieve the size of the code on target address, this needs assembly .
138             codeLength := extcodesize(_to)
139             }
140             balances[msg.sender] = safeSub(balances[msg.sender], _value);
141             balances[_to] = safeAdd(balances[_to], _value);
142             if(codeLength>0) {
143                 ContractReceiver receiver = ContractReceiver(_to);
144                 receiver.tokenFallback(msg.sender, _value, _data);
145             }
146             emit Transfer(msg.sender, _to, _value, _data);
147             return true;
148         }else{return false;}
149 
150     }
151     
152     /**
153      *
154      * Transfer with ERC223 specification
155      *
156      * http://vessenes.com/the-erc20-short-address-attack-explained/
157      */
158     function transfer(address _to, uint _value) 
159     onlyPayloadSize(2 * 32) 
160     public
161     returns (bool success)
162     {
163         require(_to != address(0));
164         if (balances[msg.sender] >= _value && _value > 0) {
165             uint codeLength;
166             bytes memory empty;
167             assembly {
168             // Retrieve the size of the code on target address, this needs assembly .
169             codeLength := extcodesize(_to)
170             }
171 
172             balances[msg.sender] = safeSub(balances[msg.sender], _value);
173             balances[_to] = safeAdd(balances[_to], _value);
174             if(codeLength>0) {
175                 ContractReceiver receiver = ContractReceiver(_to);
176                 receiver.tokenFallback(msg.sender, _value, empty);
177             }
178             emit Transfer(msg.sender, _to, _value);
179             return true;
180         } else { return false; }
181 
182     }
183 
184     function transferFrom(address _from, address _to, uint _value)
185     public
186     returns (bool success) 
187     {
188         require(_to != address(0));
189         require(_value <= balances[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191         uint _allowance = allowed[_from][msg.sender];
192         balances[_to] = safeAdd(balances[_to], _value);
193         balances[_from] = safeSub(balances[_from], _value);
194         allowed[_from][msg.sender] = safeSub(_allowance, _value);
195         emit Transfer(_from, _to, _value);
196         return true;
197     }
198 
199     function balanceOf(address _owner) public view returns (uint balance) {
200         return balances[_owner];
201     }
202 
203     function approve(address _spender, uint _value) 
204     public
205     returns (bool success)
206     {
207         require(_spender != address(0));
208         // To change the approve amount you first have to reduce the addresses`
209         //    allowance to zero by calling `approve(_spender, 0)` if it is not
210         //    already 0 to mitigate the race condition described here:
211         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212         //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
213         require(_value == 0 || allowed[msg.sender][_spender] == 0);
214         allowed[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      */
225     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232         uint oldValue = allowed[msg.sender][_spender];
233         if (_subtractedValue > oldValue) {
234             allowed[msg.sender][_spender] = 0;
235         } else {
236             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
237         }
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242     function allowance(address _owner, address _spender) public view returns (uint remaining) {
243         return allowed[_owner][_spender];
244     }
245 
246 }
247 
248 contract CoSoundToken is StandardToken, Ownable {
249     string public name;
250     uint8 public decimals; 
251     string public symbol;
252     uint totalEthInWei;
253 
254     constructor() public{
255         decimals = 18;     // Amount of decimals for display purposes
256         totalSupply = 1200000000 * 10 ** uint256(decimals);     // Update total supply
257         balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
258         name = "Cosound";    // Set the name for display purposes
259         symbol = "CSND";    // Set the symbol for display purposes
260     }
261 
262     /* Approves and then calls the receiving contract */
263     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
264     public
265     returns (bool success) {
266         allowed[msg.sender][_spender] = _value;
267         emit Approval(msg.sender, _spender, _value);
268         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
269         return true;
270     }
271 
272     // can accept ether
273     function() payable public{
274         revert();
275     }
276 
277     function transferToCrowdsale(address _to, uint _value) 
278     onlyPayloadSize(2 * 32) 
279     onlyOwner
280     public
281     returns (bool success)
282     {
283         require(_to != address(0));
284         if (balances[msg.sender] >= _value && _value > 0) {
285             balances[msg.sender] = safeSub(balances[msg.sender], _value);
286             balances[_to] = safeAdd(balances[_to], _value);
287             emit Transfer(msg.sender, _to, _value);
288             return true;
289         }
290         else { 
291             return false; 
292         }
293     }
294 }