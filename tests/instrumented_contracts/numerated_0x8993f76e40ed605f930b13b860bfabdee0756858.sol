1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract ERC223 {
52     uint256 public totalSupply_;
53     function balanceOf(address _owner) public view returns (uint256 balance);
54     function totalSupply() public view returns (uint256 _supply);
55 
56     function allowance(address owner, address spender) public view returns (uint256);
57     function transferFrom(address from, address to, uint256 value) public returns (bool);
58     function approve(address spender, uint256 value) public returns (bool);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     function transfer(address to, uint value) public returns (bool success);
62     function transfer(address to, uint value, bytes data) public returns (bool success);
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
65 }
66 
67 
68 contract ContractReceiver {
69     /**
70      * @dev Standard ERC223 function that will handle incoming token transfers.
71      * @param _from  Token sender address.
72      * @param _value Amount of tokens.
73      * @param _data  Transaction metadata.
74      */
75     function tokenFallback(address _from, uint _value, bytes _data) public;
76 }
77 
78 
79 contract ERC223Token is ERC223 {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83     mapping (address => mapping (address => uint256)) internal allowed;
84 
85     uint256 public totalSupply_;
86 
87     /**
88     * @dev total number of tokens in existence
89     */
90     function totalSupply() public view returns (uint256 _supply) {
91         return totalSupply_;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     * @param _data Transaction metadata.
99     */
100     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
101         if (isContract(_to)) {
102             return transferToContract(_to, _value, _data);
103         } else {
104             return transferToAddress(_to, _value, _data);
105         }
106     }
107 
108     /**
109     * @dev transfer token for a specified address similar to ERC20 transfer.
110     * @dev Added due to backwards compatibility reasons.
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint _value) public returns (bool success) {
115         bytes memory empty;
116         if (isContract(_to)) {
117             return transferToContract(_to, _value, empty);
118         } else {
119             return transferToAddress(_to, _value, empty);
120         }
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public view returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     /**
133      * @dev Transfer tokens from one address to another
134      * @param _from address The address which you want to send tokens from
135      * @param _to address The address which you want to transfer to
136      * @param _value uint256 the amount of tokens to be transferred
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[_from]);
141         require(_value <= allowed[_from][msg.sender]);
142 
143         balances[_from] = balances[_from].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      *
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param _spender The address which will spend the funds.
158      * @param _value The amount of tokens to be spent.
159      */
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param _owner address The address which owns the funds.
169      * @param _spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(address _owner, address _spender) public view returns (uint256) {
173         return allowed[_owner][_spender];
174     }
175 
176     /**
177      * @dev Increase the amount of tokens that an owner allowed to a spender.
178      *
179      * approve should be called when allowed[_spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * @param _spender The address which will spend the funds.
184      * @param _addedValue The amount of tokens to increase the allowance by.
185      */
186     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189         return true;
190     }
191 
192     /**
193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
194      *
195      * approve should be called when allowed[_spender] == 0. To decrement
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * @param _spender The address which will spend the funds.
200      * @param _subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203         uint oldValue = allowed[msg.sender][_spender];
204         if (_subtractedValue > oldValue) {
205             allowed[msg.sender][_spender] = 0;
206         } else {
207             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208         }
209         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210         return true;
211     }
212 
213     /**
214     * @dev isContract
215     * @param _addr The address to check if it's a contract or not
216     * @return true if _addr is a contract
217     */
218     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
219     function isContract(address _addr) private view returns (bool is_contract) {
220         uint length;
221         /* solium-disable-next-line */
222         assembly {
223             //retrieve the size of the code on target address, this needs assembly
224             length := extcodesize(_addr)
225         }
226         if (length > 0) {
227             return true;
228         } else {
229             return false;
230         }
231     }
232 
233     /**
234     * @dev transferToAddress transfers the specified amount of tokens to the specified address
235     * @param _to    Receiver address.
236     * @param _value Amount of tokens that will be transferred.
237     * @param _data  Transaction metadata.
238     * @return true  if transaction went through
239     */
240     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
241         if (balanceOf(msg.sender) < _value) revert();
242         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
243         balances[_to] = balanceOf(_to).add(_value);
244         Transfer(msg.sender, _to, _value);
245         ERC223Transfer(msg.sender, _to, _value, _data);
246         return true;
247     }
248 
249     /**
250     * @dev transferToContract transfers the specified amount of tokens to the specified contract address
251     * @param _to    Receiver address.
252     * @param _value Amount of tokens that will be transferred.
253     * @param _data  Transaction metadata.
254     * @return true  if transaction went through
255     */
256     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
257         if (balanceOf(msg.sender) < _value) revert();
258         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
259         balances[_to] = balanceOf(_to).add(_value);
260         ContractReceiver reciever = ContractReceiver(_to);
261         reciever.tokenFallback(msg.sender, _value, _data);
262         Transfer(msg.sender, _to, _value);
263         ERC223Transfer(msg.sender, _to, _value, _data);
264         return true;
265     }
266 }
267 
268 /**
269  * @title BFEXToken Bank Future Exchange Token Contract by AngelCoin.io
270  */
271 contract BFEXToken is ERC223Token {
272 
273     string public constant name = "Bank Future Exchange";
274     string public constant symbol = "BFEX";
275     uint8 public constant decimals = 18;
276 
277     uint256 public constant INITIAL_SUPPLY = 210000000 * (10 ** uint256(decimals));
278 
279     /**
280      * @dev BFEXToken Constructor gives msg..
281      */
282     function BFEXToken() public {
283         totalSupply_ = INITIAL_SUPPLY;
284         balances[msg.sender] = INITIAL_SUPPLY;
285         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
286     }
287 
288 }