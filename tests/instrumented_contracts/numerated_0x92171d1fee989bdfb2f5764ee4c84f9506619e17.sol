1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54     function totalSupply() public view returns (uint256);
55     function balanceOf(address who) public view returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public view returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80 
81     uint256 totalSupply_;
82 
83     /**
84     * @dev total number of tokens in existence
85     */
86     function totalSupply() public view returns (uint256) {
87         return totalSupply_;
88     }
89 
90     /**
91     * @dev transfer token for a specified address
92     * @param _to The address to transfer to.
93     * @param _value The amount to be transferred.
94     */
95     function transfer(address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98 
99         // SafeMath.sub will throw if there is not enough balance.
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     /**
107     * @dev Gets the balance of the specified address.
108     * @param _owner The address to query the the balance of.
109     * @return An uint256 representing the amount owned by the passed address.
110     */
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115 }
116 
117 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128     /* Public variables of the token */
129     string public standard = 'ERC20';
130 
131     string public name;
132 
133     string public symbol;
134 
135     uint8 public decimals;
136 
137     uint256 public totalSupply;
138 
139     address public owner;
140 
141     mapping (address => mapping (address => uint256)) internal allowed;
142 
143     function StandardToken(
144         uint256 initialSupply,
145         string tokenName,
146         uint8 decimalUnits,
147         string tokenSymbol
148     ) {
149         balances[msg.sender] = initialSupply;
150         // Give the creator all initial tokens
151         totalSupply = initialSupply;
152         // Update total supply
153         name = tokenName;
154         // Set the name for display purposes
155         symbol = tokenSymbol;
156         // Set the symbol for display purposes
157         decimals = decimalUnits;
158         // Amount of decimals for display purposes
159 
160         owner=msg.sender;
161     }
162 
163     modifier onlyOwner {
164         if (msg.sender != owner) throw;
165         _;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another
170      * @param _from address The address which you want to send tokens from
171      * @param _to address The address which you want to transfer to
172      * @param _value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      *
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param _spender The address which will spend the funds.
194      * @param _value The amount of tokens to be spent.
195      */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     function multiApprove(address[] _spender, uint256[] _value) public returns (bool){
203         require(_spender.length == _value.length);
204         for(uint i=0;i<=_spender.length;i++){
205             allowed[msg.sender][_spender[i]] = _value[i];
206             Approval(msg.sender, _spender[i], _value[i]);
207         }
208         return true;
209     }
210     /**
211      * @dev Function to check the amount of tokens that an owner allowed to a spender.
212      * @param _owner address The address which owns the funds.
213      * @param _spender address The address which will spend the funds.
214      * @return A uint256 specifying the amount of tokens still available for the spender.
215      */
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221      * @dev Increase the amount of tokens that an owner allowed to a spender.
222      *
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236     function multiIncreaseApproval(address[] _spender, uint[] _addedValue) public returns (bool) {
237         require(_spender.length == _addedValue.length);
238         for(uint i=0;i<=_spender.length;i++){
239             allowed[msg.sender][_spender[i]] = allowed[msg.sender][_spender[i]].add(_addedValue[i]);
240             Approval(msg.sender, _spender[i], allowed[msg.sender][_spender[i]]);
241         }
242         return true;
243     }
244     /**
245      * @dev Decrease the amount of tokens that an owner allowed to a spender.
246      *
247      * approve should be called when allowed[_spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * @param _spender The address which will spend the funds.
252      * @param _subtractedValue The amount of tokens to decrease the allowance by.
253      */
254     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
255         uint oldValue = allowed[msg.sender][_spender];
256         if (_subtractedValue > oldValue) {
257             allowed[msg.sender][_spender] = 0;
258         } else {
259             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260         }
261         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262         return true;
263     }
264 
265     function multiDecreaseApproval(address[] _spender, uint[] _subtractedValue) public returns (bool) {
266         require(_spender.length == _subtractedValue.length);
267         for(uint i=0;i<=_spender.length;i++){
268             uint oldValue = allowed[msg.sender][_spender[i]];
269             if (_subtractedValue[i] > oldValue) {
270                 allowed[msg.sender][_spender[i]] = 0;
271             } else {
272                 allowed[msg.sender][_spender[i]] = oldValue.sub(_subtractedValue[i]);
273             }
274             Approval(msg.sender, _spender[i], allowed[msg.sender][_spender[i]]);
275         }
276         return true;
277     }
278 
279     /* Approve and then comunicate the approved contract in a single tx */
280     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
281     returns (bool success) {
282         tokenRecipient spender = tokenRecipient(_spender);
283         if (approve(_spender, _value)) {
284             spender.receiveApproval(msg.sender, _value, this, _extraData);
285             return true;
286         }
287     }
288 
289 }