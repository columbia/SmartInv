1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         assert_ex(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         // assert_ex(b > 0); // Solidity automatically throws when dividing by 0
15         uint c = a / b;
16         // assert_ex(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         assert_ex(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert_ex(c >= a);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal   pure  returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a < b ? a : b;
45     }
46 
47     function assert_ex(bool assert_exion) internal pure{
48         if (!assert_exion) {
49           revert();
50         }
51     }
52 }
53 
54 
55 contract Owned {
56     address public owner;
57 
58     function Owned() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address newOwner) onlyOwner public {
68         owner = newOwner;
69     }
70 }
71 
72 
73 contract ERC20Interface {
74 
75     using SafeMath for uint;
76     uint public _totalSupply;
77     string public name;
78     string public symbol;
79     uint8 public decimals;
80 
81 
82     mapping (address => uint) balances;
83     mapping (address => mapping (address => uint)) allowed;
84 
85     event Transfer(address indexed from, address indexed to, uint value, bytes data);
86     event Transfer(address indexed from, address indexed to, uint value);
87 
88     event Approval(address indexed _owner, address indexed _spender, uint _value);
89 
90 
91 
92     function totalSupply() constant returns (uint256 totalSupply) {
93       totalSupply = _totalSupply;
94     }
95 
96     /**
97      * @dev Returns balance of the `_owner`.
98      *
99      * @param _owner   The address whose balance will be returned.
100      * @return balance Balance of the `_owner`.
101      */
102     function balanceOf(address _owner) public view returns (uint balance) {
103         return balances[_owner];
104     }
105 
106     /**
107      * Set allowed for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint _value) public returns (bool success) {
115 
116         // To change the approve amount you first have to reduce the addresses`
117         //  allowed to zero by calling `approve(_spender, 0)` if it is not
118         //  already 0 to mitigate the race condition described here:
119         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
121           revert();
122         }
123 
124         allowed[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126         return true;
127     }
128 
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param _owner address The address which owns the funds.
133      * @param _spender address The address which will spend the funds.
134      * @return A uint specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address _owner, address _spender) public view returns (uint remaining) {
137         return allowed[_owner][_spender];
138     }
139 
140     /**
141      * Atomic increment of approved spending
142      *
143      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      */
146     function addApproval(address _spender, uint _addedValue) public returns (bool) {
147         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 
152     /**
153      * Atomic decrement of approved spending.
154      *
155      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      */
157     function subApproval(address _spender, uint _subtractedValue) public returns (bool) {
158         uint oldValue = allowed[msg.sender][_spender];
159         if (_subtractedValue > oldValue) {
160           allowed[msg.sender][_spender] = 0;
161         } else {
162           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168 }
169 
170 /**
171  * @title Contract that will work with ERC223 tokens.
172  */
173 contract ERC223ReceivingContract {
174 
175     event TokenFallback(address _from, uint _value, bytes _data);
176 
177     /**
178      * @dev Standard ERC223 function that will handle incoming token transfers.
179      *
180      * @param _from  Token sender address.
181      * @param _value Amount of tokens.
182      * @param _data  Transaction metadata.
183      */
184     function tokenFallback(address _from, uint _value, bytes _data)public {
185         TokenFallback(_from,_value,_data);
186     }
187 }
188 
189 
190 contract StanderdToken is ERC20Interface, ERC223ReceivingContract, Owned {
191 
192 
193 
194     /**
195      *
196      * Fix for the ERC20 short address attack
197      *
198      * http://vessenes.com/the-erc20-short-address-attack-explained/
199      */
200     modifier onlyPayloadSize(uint size) {
201         if(msg.data.length != size + 4) {
202          revert();
203         }
204         _;
205     }
206 
207     /**
208      * @dev Transfer the specified amount of tokens to the specified address.
209      *      This function works the same with the previous one
210      *      but doesn't contain `_data` param.
211      *      Added due to backwards compatibility reasons.
212      *
213      * @param _to    Receiver address.
214      * @param _value Amount of tokens that will be transferred.
215      */
216     function transfer(address _to, uint _value) public returns (bool) {
217         address _from = msg.sender;
218 
219         balances[_from] = balances[_from].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         Transfer(_from, _to, _value);
222         return true;
223     }
224 
225 
226     function transferFrom(address _from,address _to, uint _value) public returns (bool) {
227         //require(_to != address(0));
228         require(_value <= balances[_from]);
229         require(_value <= allowed[_from][msg.sender]);
230 
231         balances[_from] = balances[_from].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234         Transfer(_from, _to, _value);
235         return true;
236     }
237 }
238 
239 
240 contract PreviligedToken is Owned {
241 
242     using SafeMath for uint;
243 
244     mapping (address => uint) previligedBalances;
245     mapping (address => mapping (address => uint)) previligedallowed;
246 
247     event PreviligedLock(address indexed from, address indexed to, uint value);
248     event PreviligedUnLock(address indexed from, address indexed to, uint value);
249     event Previligedallowed(address indexed _owner, address indexed _spender, uint _value);
250 
251     function previligedBalanceOf(address _owner) public view returns (uint balance) {
252         return previligedBalances[_owner];
253     }
254 
255     function previligedApprove(address _owner, address _spender, uint _value) onlyOwner public returns (bool success) {
256 
257         // To change the approve amount you first have to reduce the addresses`
258         //  allowed to zero by calling `approve(_spender, 0)` if it is not
259         //  already 0 to mitigate the race condition described here:
260         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261         if ((_value != 0) && (previligedallowed[_owner][_spender] != 0)) {
262           revert();
263         }
264 
265         previligedallowed[_owner][_spender] = _value;
266         Previligedallowed(_owner, _spender, _value);
267         return true;
268     }
269 
270     function getPreviligedallowed(address _owner, address _spender) public view returns (uint remaining) {
271         return previligedallowed[_owner][_spender];
272     }
273 
274     function previligedAddApproval(address _owner, address _spender, uint _addedValue) onlyOwner public returns (bool) {
275         previligedallowed[_owner][_spender] = previligedallowed[_owner][_spender].add(_addedValue);
276         Previligedallowed(_owner, _spender, previligedallowed[_owner][_spender]);
277         return true;
278     }
279 
280     function previligedSubApproval(address _owner, address _spender, uint _subtractedValue) onlyOwner public returns (bool) {
281         uint oldValue = previligedallowed[_owner][_spender];
282         if (_subtractedValue > oldValue) {
283           previligedallowed[_owner][_spender] = 0;
284         } else {
285           previligedallowed[_owner][_spender] = oldValue.sub(_subtractedValue);
286         }
287         Previligedallowed(_owner, _spender, previligedallowed[_owner][_spender]);
288         return true;
289     }
290 }
291 
292 
293 contract MitToken is StanderdToken, PreviligedToken {
294 
295     using SafeMath for uint;
296 
297     event Burned(address burner, uint burnedAmount);
298 
299     function MitToken() public {
300 
301         uint initialSupply = 6000000000;
302 
303         decimals = 18;
304         _totalSupply = initialSupply * 10 ** uint(decimals);  // Update total supply with the decimal amount
305         balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens
306         name = "MitCoin";                                   // Set the name for display purposes
307         symbol = "MITC";                               // Set the symbol for display purposes3
308     }
309 
310     /**
311      * @dev Function to mint tokens
312      * @notice Create `mintedAmount` tokens and send it to `_target`
313      * @param _target The address that will receive the minted tokens.
314      * @param _mintedAmount The amount of tokens to mint.
315      * @return A boolean that indicates if the operation was successful.
316      */
317     function mintToken(address _target, uint _mintedAmount) onlyOwner public {
318         balances[_target] = balances[_target].add(_mintedAmount);
319         _totalSupply = _totalSupply.add(_mintedAmount);
320 
321         Transfer(address(0), _target, _mintedAmount);
322     }
323 
324     function burn(uint _amount) onlyOwner public {
325         address burner = msg.sender;
326         balances[burner] = balances[burner].sub(_amount);
327         _totalSupply = _totalSupply.sub(_amount);
328 
329         Burned(burner, _amount);
330     }
331 
332     function previligedLock(address _to, uint _value) onlyOwner public returns (bool) {
333         address _from = msg.sender;
334         balances[_from] = balances[_from].sub(_value);
335         //balances[_to] = balances[_to].add(_value);
336         previligedBalances[_to] = previligedBalances[_to].add(_value);
337         PreviligedLock(_from, _to, _value);
338         return true;
339     }
340 
341     function previligedUnLock(address _from, uint _value) public returns (bool) {
342         address to = msg.sender; // we force the address_to to be the the caller
343         require(to != address(0));
344         require(_value <= previligedBalances[_from]);
345         require(_value <= previligedallowed[_from][msg.sender]);
346 
347         previligedBalances[_from] = previligedBalances[_from].sub(_value);
348         balances[to] = balances[to].add(_value);
349         previligedallowed[_from][msg.sender] = previligedallowed[_from][msg.sender].sub(_value);
350         PreviligedUnLock(_from, to, _value);
351         return true;
352     }
353 }