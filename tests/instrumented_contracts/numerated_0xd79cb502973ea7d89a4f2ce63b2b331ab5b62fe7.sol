1 pragma solidity ^0.4.21;
2 
3     /**
4     * Math operations with safety checks
5     */
6     library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         assert(b > 0);
15         uint c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
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
46     }
47 
48 
49     contract Owned {
50 
51         /// @dev `owner` is the only address that can call a function with this
52         /// modifier
53         modifier onlyOwner() {
54             require(msg.sender == owner);
55             _;
56         }
57 
58         address public owner;
59         /// @notice The Constructor assigns the message sender to be `owner`
60         function Owned() public {
61             owner = msg.sender;
62         }
63 
64         address public newOwner;
65 
66         /// @notice `owner` can step down and assign some other address to this role
67         /// @param _newOwner The address of the new owner. 0x0 can be used to create
68         ///  an unowned neutral vault, however that cannot be undone
69         function changeOwner(address _newOwner) onlyOwner public {
70             newOwner = _newOwner;
71         }
72 
73 
74         function acceptOwnership() public {
75             if (msg.sender == newOwner) {
76                 owner = newOwner;
77             }
78         }
79     }
80 
81 
82     contract ERC20Protocol {
83         /* This is a slight change to the ERC20 base standard.
84         function totalSupply() constant returns (uint supply);
85         is replaced with:
86         uint public totalSupply;
87         This automatically creates a getter function for the totalSupply.
88         This is moved to the base contract since public getter functions are not
89         currently recognised as an implementation of the matching abstract
90         function by the compiler.
91         */
92         /// total amount of tokens
93         uint public totalSupply;
94 
95         /// @param _owner The address from which the balance will be retrieved
96         /// @return The balance
97         function balanceOf(address _owner) constant public returns (uint balance);
98 
99         /// @notice send `_value` token to `_to` from `msg.sender`
100         /// @param _to The address of the recipient
101         /// @param _value The amount of token to be transferred
102         /// @return Whether the transfer was successful or not
103         function transfer(address _to, uint _value) public returns (bool success);
104 
105         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
106         /// @param _from The address of the sender
107         /// @param _to The address of the recipient
108         /// @param _value The amount of token to be transferred
109         /// @return Whether the transfer was successful or not
110         function transferFrom(address _from, address _to, uint _value) public returns (bool success);
111 
112         /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
113         /// @param _spender The address of the account able to transfer the tokens
114         /// @param _value The amount of tokens to be approved for transfer
115         /// @return Whether the approval was successful or not
116         function approve(address _spender, uint _value) public returns (bool success);
117 
118         /// @param _owner The address of the account owning tokens
119         /// @param _spender The address of the account able to transfer the tokens
120         /// @return Amount of remaining tokens allowed to spent
121         function allowance(address _owner, address _spender) constant public returns (uint remaining);
122 
123         event Transfer(address indexed _from, address indexed _to, uint _value);
124         event Approval(address indexed _owner, address indexed _spender, uint _value);
125     }
126 
127     contract StandardToken is ERC20Protocol {
128         using SafeMath for uint;
129 
130         /**
131         * @dev Fix for the ERC20 short address attack.
132         */
133         modifier onlyPayloadSize(uint size) {
134             require(msg.data.length >= size + 4);
135             _;
136         }
137 
138         function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
139             //Default assumes totalSupply can't be over max (2^256 - 1).
140             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
141             //Replace the if with this one instead.
142             //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
143             if (balances[msg.sender] >= _value) {
144                 balances[msg.sender] -= _value;
145                 balances[_to] += _value;
146                 emit Transfer(msg.sender, _to, _value);
147                 return true;
148             } else { return false; }
149         }
150 
151         function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool success) {
152             //same as above. Replace this line with the following if you want to protect against wrapping uints.
153             //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
154             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
155                 balances[_to] += _value;
156                 balances[_from] -= _value;
157                 allowed[_from][msg.sender] -= _value;
158                 emit Transfer(_from, _to, _value);
159                 return true;
160             } else { return false; }
161         }
162 
163         function balanceOf(address _owner) constant public returns (uint balance) {
164             return balances[_owner];
165         }
166 
167         function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
168             // To change the approve amount you first have to reduce the addresses`
169             //  allowance to zero by calling `approve(_spender, 0)` if it is not
170             //  already 0 to mitigate the race condition described here:
171             //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172             assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174             allowed[msg.sender][_spender] = _value;
175             emit Approval(msg.sender, _spender, _value);
176             return true;
177         }
178 
179         function allowance(address _owner, address _spender) constant public returns (uint remaining) {
180         return allowed[_owner][_spender];
181         }
182 
183         mapping (address => uint) balances;
184         mapping (address => mapping (address => uint)) allowed;
185     }
186 
187     contract OriginsTraceChainToken is StandardToken {
188         /// Constant token specific fields
189         string public constant name = "OriginsTraceChain";
190         string public constant symbol = "OTC";
191         uint public constant decimals = 18;
192 
193         /// OriginsTraceChain total tokens supply
194         uint public constant MAX_TOTAL_TOKEN_AMOUNT = 300000000 ether;
195 
196         /// Fields that are only changed in constructor
197         /// OriginsTraceChain contribution contract
198         address public minter;
199 
200         /*
201         * MODIFIERS
202         */
203 
204         modifier onlyMinter {
205             assert(msg.sender == minter);
206             _;
207         }
208 
209         modifier maxTokenAmountNotReached (uint amount){
210             assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
211             _;
212         }
213 
214         /**
215         * CONSTRUCTOR
216         *
217         * @dev Initialize the OriginsTraceChain Token
218         * @param _minter The OriginsTraceChain Crowd Funding Contract
219         */
220         function OriginsTraceChainToken(address _minter) public {
221             minter = _minter;
222         }
223 
224 
225         /**
226         * EXTERNAL FUNCTION
227         *
228         * @dev Contribution contract instance mint token
229         * @param recipient The destination account owned mint tokens
230         * be sent to this address.
231         */
232         function mintToken(address recipient, uint _amount)
233             public
234             onlyMinter
235             maxTokenAmountNotReached(_amount)
236             returns (bool)
237         {
238             totalSupply = totalSupply.add(_amount);
239             balances[recipient] = balances[recipient].add(_amount);
240             return true;
241         }
242     }