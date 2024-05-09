1 pragma solidity 0.4.18;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19     /**
20     * @dev Multiplies two numbers, throws on overflow.
21     */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     /**
42     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 contract ERC223 {
60     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
61 }
62 
63 contract ERC223Receiver {
64 /**
65  * @dev Standard ERC223 function that will handle incoming token transfers.
66  *
67  * @param _from  Token sender address.
68  * @param _value Amount of tokens.
69  * @param _data  Transaction metadata.
70  */
71     function tokenFallback(address _from, uint256 _value, bytes _data) public;
72 }
73 
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     uint256 totalSupply_;
80 
81     /**
82     * @dev total number of tokens in existence
83     */
84     function totalSupply() public view returns (uint256) {
85         return totalSupply_;
86     }
87 
88     /**
89     * @dev transfer token for a specified address
90     * @param _to The address to transfer to.
91     * @param _value The amount to be transferred.
92     */
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         // SafeMath.sub will throw if there is not enough balance.
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         Transfer(msg.sender, _to, _value);
101         return true;
102     }
103 
104     /**
105     * @dev Gets the balance of the specified address.
106     * @param _owner The address to query the the balance of.
107     * @return An uint256 representing the amount owned by the passed address.
108     */
109     function balanceOf(address _owner) public view returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117     mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      *
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 
164     /**
165      * @dev Increase the amount of tokens that an owner allowed to a spender.
166      *
167      * approve should be called when allowed[_spender] == 0. To increment
168      * allowed value is better to use this function to avoid 2 calls (and wait until
169      * the first transaction is mined)
170      * From MonolithDAO Token.sol
171      * @param _spender The address which will spend the funds.
172      * @param _addedValue The amount of tokens to increase the allowance by.
173      */
174     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
175         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180     /**
181      * @dev Decrease the amount of tokens that an owner allowed to a spender.
182      *
183      * approve should be called when allowed[_spender] == 0. To decrement
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * @param _spender The address which will spend the funds.
188      * @param _subtractedValue The amount of tokens to decrease the allowance by.
189      */
190     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
191         uint256 oldValue = allowed[msg.sender][_spender];
192         if (_subtractedValue > oldValue) {
193             allowed[msg.sender][_spender] = 0;
194         } else {
195             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196         }
197         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201 }
202 
203 contract Standard223Token is StandardToken, ERC223 {
204     using SafeMath for uint256;
205 
206     /**
207      * @dev Transfer the specified amount of tokens to the specified address.
208      *      Invokes the `tokenFallback` function if the recipient is a contract.
209      *      The token transfer fails if the recipient is a contract
210      *      but does not implement the `tokenFallback` function
211      *
212      * @param _to    Receiver address.
213      * @param _value Amount of tokens that will be transferred.
214      * @param _data  Transaction metadata.
215     */
216     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
217         require(_to != address(0));
218         require(_value <= balances[msg.sender]);
219 
220         if(isContract(_to)) {
221             return transferToContract(_to, _value, _data);
222         } else {
223             return transferToAddress(_to, _value);
224         }
225     }
226 
227     /**
228      * @dev Transfer the specified amount of tokens to the specified address.
229      *      Invokes the `_custom_fallback` function if the recipient is a contract.
230      *      The token transfer fails if the recipient is a contract
231      *      but does not implement the `_custom_fallback` function
232      *
233      * @param _to    Receiver address.
234      * @param _value Amount of tokens that will be transferred.
235      * @param _data  Transaction metadata.
236     */
237     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
238         require(_to != address(0));
239         require(_value <= balances[msg.sender]);
240 
241         if(isContract(_to)) {
242             balances[msg.sender] = balances[msg.sender].sub(_value);
243             balances[_to] = balances[_to].add(_value);
244             /* solium-disable-next-line */
245             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
246             Transfer(msg.sender, _to, _value);
247             return true;
248         } else {
249             return transferToAddress(_to, _value);
250         }
251     }
252 
253     /**
254      * @dev Transfer the specified amount of tokens to the specified address.
255      *      Added due to backwards compatibility reasons.
256      *
257      * @param _to    Receiver address.
258      * @param _value Amount of tokens that will be transferred.
259     */
260     function transfer(address _to, uint256 _value) public returns (bool success) {
261         return transfer(_to, _value, new bytes(0));
262     }
263 
264     function transferToAddress(address _to, uint _value) private returns (bool success) {
265         balances[msg.sender] = balances[msg.sender].sub(_value);
266         balances[_to] = balances[_to].add(_value);
267         Transfer(msg.sender, _to, _value);
268         return true;
269     }
270 
271     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
272         balances[msg.sender] = balances[msg.sender].sub(_value);
273         balances[_to] = balances[_to].add(_value);
274         ERC223Receiver reciever = ERC223Receiver(_to);
275         reciever.tokenFallback(msg.sender, _value, _data);
276         Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     /**
281     * @dev Retrieve the size of the code on target address, this needs assembly.
282     *
283     * @param _addr  The address to check if it's a contract.
284     *
285     * @return is_contract   TRUE if it's a contract else false.
286     */
287     function isContract(address _addr) private view returns (bool is_contract) {
288         uint256 length;
289         /* solium-disable-next-line */
290         assembly {
291             length := extcodesize(_addr)
292         }
293         return length > 0;
294     }
295 }
296 
297 contract TrueToken is Standard223Token {
298 
299     string public name;
300     string public symbol;
301     uint8 public decimals;
302     uint256 public INITIAL_SUPPLY = 25000000;   // 25 million
303 
304     function TrueToken() public {
305         name = "TRUE";
306         symbol = "TRUE";
307         decimals = 18;
308 
309         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
310         balances[msg.sender] = totalSupply_;
311     }
312 }