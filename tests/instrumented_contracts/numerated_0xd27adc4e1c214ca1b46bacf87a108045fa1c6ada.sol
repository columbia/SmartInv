1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28 }
29 
30 contract ERC20 {
31     uint256 public totalSupply;
32 
33     bool public transfersEnabled;
34 
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36 
37     function transfer(address _to, uint256 _value) public returns (bool success);
38 
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract ERC223Basic {
51     uint256 public totalSupply;
52 
53     bool public transfersEnabled;
54 
55     function balanceOf(address who) public view returns (uint256);
56 
57     function transfer(address to, uint256 value) public returns (bool);
58 
59     function transfer(address to, uint256 value, bytes data) public;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
62 
63 }
64 
65 contract ERC223ReceivingContract {
66     /**
67      * @dev Standard ERC223 function that will handle incoming token transfers.
68      *
69      * @param _from  Token sender address.
70      * @param _value Amount of tokens.
71      * @param _data  Transaction metadata.
72      */
73     function tokenFallback(address _from, uint _value, bytes _data) public;
74 }
75 
76 contract ERC223Token is ERC223Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances; // List of user balances.
80 
81     /**
82     * @dev protection against short address attack
83     */
84     modifier onlyPayloadSize(uint numwords) {
85         assert(msg.data.length == numwords * 32 + 4);
86         _;
87     }
88 
89     /**
90      * @dev Transfer the specified amount of tokens to the specified address.
91      *      Invokes the `tokenFallback` function if the recipient is a contract.
92      *      The token transfer fails if the recipient is a contract
93      *      but does not implement the `tokenFallback` function
94      *      or the fallback function to receive funds.
95      *
96      * @param _to    Receiver address.
97      * @param _value Amount of tokens that will be transferred.
98      * @param _data  Transaction metadata.
99      */
100     function transfer(address _to, uint _value, bytes _data) public onlyPayloadSize(3) {
101         // Standard function transfer similar to ERC20 transfer with no _data .
102         // Added due to backwards compatibility reasons .
103         uint codeLength;
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106         require(transfersEnabled);
107 
108     assembly {
109         // Retrieve the size of the code on target address, this needs assembly .
110             codeLength := extcodesize(_to)
111         }
112 
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         if(codeLength>0) {
116             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
117             receiver.tokenFallback(msg.sender, _value, _data);
118         }
119         emit Transfer(msg.sender, _to, _value, _data);
120     }
121 
122     /**
123      * @dev Transfer the specified amount of tokens to the specified address.
124      *      This function works the same with the previous one
125      *      but doesn't contain `_data` param.
126      *      Added due to backwards compatibility reasons.
127      *
128      * @param _to    Receiver address.
129      * @param _value Amount of tokens that will be transferred.
130      */
131     function transfer(address _to, uint _value) public onlyPayloadSize(2) returns(bool) {
132         uint codeLength;
133         bytes memory empty;
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136         require(transfersEnabled);
137 
138         assembly {
139         // Retrieve the size of the code on target address, this needs assembly .
140             codeLength := extcodesize(_to)
141         }
142 
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         if(codeLength>0) {
146             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
147             receiver.tokenFallback(msg.sender, _value, empty);
148         }
149         emit Transfer(msg.sender, _to, _value, empty);
150         return true;
151     }
152 
153 
154     /**
155      * @dev Returns balance of the `_owner`.
156      *
157      * @param _owner   The address whose balance will be returned.
158      * @return balance Balance of the `_owner`.
159      */
160     function balanceOf(address _owner) public constant returns (uint256 balance) {
161         return balances[_owner];
162     }
163 }
164 
165 contract StandardToken is ERC20, ERC223Token {
166 
167     mapping(address => mapping(address => uint256)) internal allowed;
168 
169     /**
170      * @dev Transfer tokens from one address to another
171      * @param _from address The address which you want to send tokens from
172      * @param _to address The address which you want to transfer to
173      * @param _value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         require(transfersEnabled);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }
238 
239 contract Cbdnano is StandardToken {
240 
241     string public constant name = "CBDNANO";
242     string public constant symbol = "CBDN";
243     uint8 public constant decimals = 18;
244     uint256 public constant INITIAL_SUPPLY = 10**9 * (10**uint256(decimals));
245     address public owner;
246 
247     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
248 
249     constructor(address _owner) public {
250         totalSupply = INITIAL_SUPPLY;
251         owner = _owner;
252         //owner = msg.sender; // for testing
253         balances[owner] = INITIAL_SUPPLY;
254         transfersEnabled = true;
255     }
256 
257     // fallback function can be used to buy tokens
258     function() payable public {
259         revert();
260     }
261 
262     modifier onlyOwner() {
263         require(msg.sender == owner);
264         _;
265     }
266 
267     function changeOwner(address _newOwner) onlyOwner public returns (bool){
268         require(_newOwner != address(0));
269         emit OwnerChanged(owner, _newOwner);
270         owner = _newOwner;
271         return true;
272     }
273 
274     function enableTransfers(bool _transfersEnabled) onlyOwner public {
275         transfersEnabled = _transfersEnabled;
276     }
277 
278 }