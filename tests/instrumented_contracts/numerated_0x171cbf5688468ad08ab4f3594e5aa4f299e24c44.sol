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
68 
69     event Burn(address indexed from, uint value);
70     /* Address of the owner */
71     address public owner;
72 
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address newOwner) onlyOwner public{
83         require(newOwner != owner);
84         require(newOwner != address(0));
85         owner = newOwner;
86     }
87 
88 }
89 
90 /**
91  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
92  *
93  * Based on code by FirstBlood:
94  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, SafeMath, ERC223Interface, Ownable {
97 
98     /* Actual balances of token holders */
99     mapping(address => uint) balances;
100     uint public totalSupply;
101 
102     /* approve() allowances */
103     mapping (address => mapping (address => uint)) internal allowed;
104     /**
105      *
106      * Fix for the ERC20 short address attack
107      *
108      * http://vessenes.com/the-erc20-short-address-attack-explained/
109      */
110     modifier onlyPayloadSize(uint size) {
111         if(msg.data.length < size + 4) {
112             revert();
113         }
114         _;
115     }
116 
117 
118     function burn(address from, uint amount) onlyOwner public{
119         require(balances[from] >= amount && amount > 0);
120         balances[from] = safeSub(balances[from],amount);
121         totalSupply = safeSub(totalSupply, amount);
122         emit Transfer(from, address(0), amount);
123         emit Burn(from, amount);
124     }
125 
126     function burn(uint amount) onlyOwner public {
127         burn(msg.sender, amount);
128     }
129 
130     /**
131      * @dev Transfer the specified amount of tokens to the specified address.
132      *    Invokes the `tokenFallback` function if the recipient is a contract.
133      *    The token transfer fails if the recipient is a contract
134      *    but does not implement the `tokenFallback` function
135      *    or the fallback function to receive funds.
136      *
137      * @param _to    Receiver address.
138      * @param _value Amount of tokens that will be transferred.
139      * @param _data    Transaction metadata.
140      */
141     function transfer(address _to, uint _value, bytes _data)
142     onlyPayloadSize(2 * 32) 
143     public
144     returns (bool success) 
145     {
146         require(_to != address(0));
147         if (balances[msg.sender] >= _value && _value > 0) {
148             // Standard function transfer similar to ERC20 transfer with no _data .
149             // Added due to backwards compatibility reasons .
150             uint codeLength;
151 
152             assembly {
153             // Retrieve the size of the code on target address, this needs assembly .
154             codeLength := extcodesize(_to)
155             }
156             balances[msg.sender] = safeSub(balances[msg.sender], _value);
157             balances[_to] = safeAdd(balances[_to], _value);
158             if(codeLength>0) {
159                 ContractReceiver receiver = ContractReceiver(_to);
160                 receiver.tokenFallback(msg.sender, _value, _data);
161             }
162             emit Transfer(msg.sender, _to, _value, _data);
163             return true;
164         }else{return false;}
165 
166     }
167     
168     /**
169      *
170      * Transfer with ERC223 specification
171      *
172      * http://vessenes.com/the-erc20-short-address-attack-explained/
173      */
174     function transfer(address _to, uint _value) 
175     onlyPayloadSize(2 * 32) 
176     public
177     returns (bool success)
178     {
179         require(_to != address(0));
180         if (balances[msg.sender] >= _value && _value > 0) {
181             uint codeLength;
182             bytes memory empty;
183             assembly {
184             // Retrieve the size of the code on target address, this needs assembly .
185             codeLength := extcodesize(_to)
186             }
187 
188             balances[msg.sender] = safeSub(balances[msg.sender], _value);
189             balances[_to] = safeAdd(balances[_to], _value);
190             if(codeLength>0) {
191                 ContractReceiver receiver = ContractReceiver(_to);
192                 receiver.tokenFallback(msg.sender, _value, empty);
193             }
194             emit Transfer(msg.sender, _to, _value);
195             return true;
196         } else { return false; }
197 
198     }
199 
200     function transferFrom(address _from, address _to, uint _value)
201     public
202     returns (bool success) 
203     {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207         uint _allowance = allowed[_from][msg.sender];
208         balances[_to] = safeAdd(balances[_to], _value);
209         balances[_from] = safeSub(balances[_from], _value);
210         allowed[_from][msg.sender] = safeSub(_allowance, _value);
211         emit Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     function balanceOf(address _owner) public view returns (uint balance) {
216         return balances[_owner];
217     }
218 
219     function approve(address _spender, uint _value) 
220     public
221     returns (bool success)
222     {
223         require(_spender != address(0));
224         // To change the approve amount you first have to reduce the addresses`
225         //    allowance to zero by calling `approve(_spender, 0)` if it is not
226         //    already 0 to mitigate the race condition described here:
227         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228         //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
229         require(_value == 0 || allowed[msg.sender][_spender] == 0);
230         allowed[msg.sender][_spender] = _value;
231         emit Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     /**
236      * approve should be called when allowed[_spender] == 0. To increment
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      */
241     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248         uint oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue > oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
253         }
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     function allowance(address _owner, address _spender) public view returns (uint remaining) {
259         return allowed[_owner][_spender];
260     }
261 
262 }
263 
264 
265 contract LICOToken is StandardToken {
266     string public name;
267     uint8 public decimals; 
268     string public symbol;
269     string public version = "1.0";
270     uint totalEthInWei;
271 
272     constructor() public{
273         decimals = 18;     // Amount of decimals for display purposes
274         totalSupply = 315000000 * 10 ** uint256(decimals);    // Give the creator all initial tokens
275         balances[msg.sender] = totalSupply;     // Update total supply
276         name = "LifeCrossCoin";    // Set the name for display purposes
277         symbol = "LICO";    // Set the symbol for display purposes
278     }
279 
280     /* Approves and then calls the receiving contract */
281     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
282     public
283     returns (bool success) {
284         allowed[msg.sender][_spender] = _value;
285         emit Approval(msg.sender, _spender, _value);
286         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
287         return true;
288     }
289 
290     // can accept ether
291     function() payable public{
292         revert();
293     }
294 
295     function transferToCrowdsale(address _to, uint _value) 
296     onlyPayloadSize(2 * 32) 
297     onlyOwner
298     public
299     returns (bool success)
300     {
301         require(_to != address(0));
302         if (balances[msg.sender] >= _value && _value > 0) {
303             balances[msg.sender] = safeSub(balances[msg.sender], _value);
304             balances[_to] = safeAdd(balances[_to], _value);
305             emit Transfer(msg.sender, _to, _value);
306             return true;
307         } else { return false; }
308 
309     }
310     
311     function withdrawTokenFromCrowdsale(address _crowdsale) onlyOwner public returns (bool success){
312         require(_crowdsale != address(0));
313         if (balances[_crowdsale] >  0) {
314             uint _value = balances[_crowdsale];
315             balances[_crowdsale] = 0;
316             balances[owner] = safeAdd(balances[owner], _value);
317             emit Transfer(_crowdsale, owner, _value);
318             return true;
319         } else { return false; }
320     }
321 }