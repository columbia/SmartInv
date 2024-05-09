1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC223Interface {
52     uint public totalSupply;
53     function balanceOf(address who) constant returns (uint);
54     function transfer(address to, uint value) public returns (bool ok);
55     function batch_transfer(address[] to, uint[] value) public returns (bool ok);
56     function transfer(address to, uint value, bytes data) public returns (bool ok);
57     event Transfer(address indexed from, address indexed to, uint value);
58 }
59 
60 contract ERC223ReceivingContract { 
61 /**
62  * @dev Standard ERC223 function that will handle incoming token transfers.
63  *
64  * @param _from  Token sender address.
65  * @param _value Amount of tokens.
66  * @param _data  Transaction metadata.
67  */
68     function tokenFallback(address _from, uint _value, bytes _data);
69 }
70 
71 contract Owned {
72 
73     address public owner;
74     address public proposedOwner;
75     bool public paused = false;
76 
77     event OwnershipTransferInitiated(address indexed _proposedOwner);
78     event OwnershipTransferCompleted(address indexed _newOwner);
79 
80 
81     function Owned() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner() {
86         require(isOwner(msg.sender));
87         _;
88     }
89     
90     /**
91     * @dev called by the owner to pause, triggers stopped state
92     */
93     function pause() onlyOwner whenNotPaused public {
94         paused = true;
95     }
96 
97     /**
98      * @dev called by the owner to resume, returns to normal state
99      */
100     function resume() onlyOwner whenPaused public {
101         paused = false;
102     }
103     
104     /**
105     * @dev Modifier to make a function callable only when the contract is not paused.
106     */
107     modifier whenNotPaused() {
108         require(!paused);
109         _;
110     }
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is paused.
114      */
115     modifier whenPaused() {
116         require(paused);
117         _;
118     }
119 
120     function isOwner(address _address) internal view returns (bool) {
121         return (_address == owner);
122     }
123 
124 
125     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
126         proposedOwner = _proposedOwner;
127 
128         OwnershipTransferInitiated(_proposedOwner);
129 
130         return true;
131     }
132 
133 
134     function completeOwnershipTransfer() public returns (bool) {
135         require(msg.sender == proposedOwner);
136 
137         owner = proposedOwner;
138         proposedOwner = address(0);
139 
140         OwnershipTransferCompleted(owner);
141 
142         return true;
143     }
144 }
145 
146 contract TRNDToken is ERC223Interface, Owned {
147     using SafeMath for uint;
148     
149     string public constant symbol="TRND"; 
150     string public constant name="trend42"; 
151     uint8 public constant decimals=2;
152 
153     //totalsupplyoftoken 
154     uint public totalSupply = 42000000 * 10 ** uint(decimals);
155     
156     //map the addresses
157     mapping(address => uint256) balances;
158     mapping(address => mapping(address => uint256)) allowed;
159 
160     function TRNDToken() {
161         owner = msg.sender;
162         balances[owner] = totalSupply;
163     }
164     
165     event Burn(address indexed burner, uint256 value);
166 
167     /**
168     * @dev Burns a specific amount of tokens.
169     * @param _value The amount of token to be burned.
170     */
171     function burn(uint256 _value) public whenNotPaused {
172         _burn(msg.sender, _value);
173     }
174 
175     function _burn(address _who, uint256 _value) internal {
176         require(_value <= balances[_who]);
177         // no need to require value <= totalSupply, since that would imply the
178         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
179 
180         balances[_who] = SafeMath.sub(balances[_who], _value);
181         totalSupply = SafeMath.sub(totalSupply, _value);
182         emit Burn(_who, _value);
183         emit Transfer(_who, address(0), _value);
184     }
185 
186     function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool success) {
187         // Standard function transfer similar to ERC20 transfer with no _data .
188         // Added due to backwards compatibility reasons .
189         uint codeLength;
190 
191         assembly {
192             // Retrieve the size of the code on target address, this needs assembly .
193             codeLength := extcodesize(_to)
194         }
195 
196         balances[msg.sender] = balances[msg.sender].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         if(codeLength>0) {
199             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
200             receiver.tokenFallback(msg.sender, _value, _data);
201         }
202         emit Transfer(msg.sender, _to, _value);
203         return true;
204     }
205     
206     function transfer(address _to, uint _value) public whenNotPaused returns (bool success) {
207         uint codeLength;
208         bytes memory empty;
209 
210         assembly {
211             // Retrieve the size of the code on target address, this needs assembly .
212             codeLength := extcodesize(_to)
213         }
214 
215         balances[msg.sender] = balances[msg.sender].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         if(codeLength>0) {
218             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
219             receiver.tokenFallback(msg.sender, _value, empty);
220         }
221         emit Transfer(msg.sender, _to, _value);
222         return true;
223     }
224     
225     function batch_transfer(address[] _to, uint[] _value) public whenNotPaused returns (bool success) {
226         
227         require(_to.length <= 255);
228         /* Ensures _toAddress and _amounts have the same number of entries. */
229         require(_to.length == _value.length);
230         
231         for (uint8 i = 0; i < _to.length; i++) {
232             transfer(_to[i], _value[i]);
233         }
234         
235         return true;
236     }
237 
238     
239     /**
240      * @dev Returns balance of the `_owner`.
241      *
242      * @param _owner   The address whose balance will be returned.
243      * @return balance Balance of the `_owner`.
244      */
245     function balanceOf(address _owner) constant returns (uint balance) {
246         return balances[_owner];
247     }
248 }