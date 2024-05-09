1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 
50 contract ERC20Protocol {
51     /* This is a slight change to the ERC20 base standard.
52     function totalSupply() constant returns (uint supply);
53     is replaced with:
54     uint public totalSupply;
55     This automatically creates a getter function for the totalSupply.
56     This is moved to the base contract since public getter functions are not
57     currently recognised as an implementation of the matching abstract
58     function by the compiler.
59     */
60     /// total amount of tokens
61     uint public totalSupply;
62 
63     /// @param _owner The address from which the balance will be retrieved
64     /// @return The balance
65     function balanceOf(address _owner) constant returns (uint balance);
66 
67     /// @notice send `_value` token to `_to` from `msg.sender`
68     /// @param _to The address of the recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transfer(address _to, uint _value) returns (bool success);
72 
73     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
74     /// @param _from The address of the sender
75     /// @param _to The address of the recipient
76     /// @param _value The amount of token to be transferred
77     /// @return Whether the transfer was successful or not
78     function transferFrom(address _from, address _to, uint _value) returns (bool success);
79 
80     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
81     /// @param _spender The address of the account able to transfer the tokens
82     /// @param _value The amount of tokens to be approved for transfer
83     /// @return Whether the approval was successful or not
84     function approve(address _spender, uint _value) returns (bool success);
85 
86     /// @param _owner The address of the account owning tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @return Amount of remaining tokens allowed to spent
89     function allowance(address _owner, address _spender) constant returns (uint remaining);
90 
91     event Transfer(address indexed _from, address indexed _to, uint _value);
92     event Approval(address indexed _owner, address indexed _spender, uint _value);
93 }
94 
95 
96 contract StandardToken is ERC20Protocol {
97     using SafeMath for uint;
98 
99     /**
100     * @dev Fix for the ERC20 short address attack.
101     */
102     modifier onlyPayloadSize(uint size) {
103         require(msg.data.length >= size + 4);
104         _;
105     }
106 
107     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
108         //Default assumes totalSupply can't be over max (2^256 - 1).
109         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
110         //Replace the if with this one instead.
111         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112         if (balances[msg.sender] >= _value) {
113             balances[msg.sender] -= _value;
114             balances[_to] += _value;
115             Transfer(msg.sender, _to, _value);
116             return true;
117         } else { return false; }
118     }
119 
120     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
121         //same as above. Replace this line with the following if you want to protect against wrapping uints.
122         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
123         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
124             balances[_to] += _value;
125             balances[_from] -= _value;
126             allowed[_from][msg.sender] -= _value;
127             Transfer(_from, _to, _value);
128             return true;
129         } else { return false; }
130     }
131 
132     function balanceOf(address _owner) constant returns (uint balance) {
133         return balances[_owner];
134     }
135 
136     function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
137         // To change the approve amount you first have to reduce the addresses`
138         //  allowance to zero by calling `approve(_spender, 0)` if it is not
139         //  already 0 to mitigate the race condition described here:
140         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function allowance(address _owner, address _spender) constant returns (uint remaining) {
149       return allowed[_owner][_spender];
150     }
151 
152     mapping (address => uint) balances;
153     mapping (address => mapping (address => uint)) allowed;
154 }
155 
156 /// @title Wanchain Token Contract
157 /// For more information about this token sale, please visit https://wanchain.org
158 /// @author Cathy - <cathy@wanchain.org>
159 contract WanToken is StandardToken {
160     using SafeMath for uint;
161 
162     /// Constant token specific fields
163     string public constant name = "WanCoin";
164     string public constant symbol = "WAN";
165     uint public constant decimals = 18;
166 
167     /// Wanchain total tokens supply
168     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 210000000 ether;
169 
170     /// Fields that are only changed in constructor
171     /// Wanchain contribution contract
172     address public minter; 
173     /// ICO start time
174     uint public startTime;
175     /// ICO end time
176     uint public endTime;
177 
178     /// Fields that can be changed by functions
179     mapping (address => uint) public lockedBalances;
180     /*
181      * MODIFIERS
182      */
183 
184     modifier onlyMinter {
185         assert(msg.sender == minter);
186         _;
187     }
188 
189     modifier isLaterThan (uint x){
190         assert(now > x);
191         _;
192     }
193 
194     modifier maxWanTokenAmountNotReached (uint amount){
195         assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
196         _;
197     }
198 
199     /**
200      * CONSTRUCTOR 
201      * 
202      * @dev Initialize the Wanchain Token
203      * @param _minter The Wanchain Contribution Contract     
204      * @param _startTime ICO start time
205      * @param _endTime ICO End Time
206      */
207     function WanToken(address _minter, uint _startTime, uint _endTime){
208         minter = _minter;
209         startTime = _startTime;
210         endTime = _endTime;
211     }
212 
213     /**
214      * EXTERNAL FUNCTION 
215      * 
216      * @dev Contribution contract instance mint token
217      * @param receipent The destination account owned mint tokens    
218      * @param amount The amount of mint token
219      * be sent to this address.
220      */    
221     function mintToken(address receipent, uint amount)
222         external
223         onlyMinter
224         maxWanTokenAmountNotReached(amount)
225         returns (bool)
226     {
227         require(now <= endTime);
228         lockedBalances[receipent] = lockedBalances[receipent].add(amount);
229         totalSupply = totalSupply.add(amount);
230         return true;
231     }
232 
233     /*
234      * PUBLIC FUNCTIONS
235      */
236 
237     /// @dev Locking period has passed - Locked tokens have turned into tradeable
238     ///      All tokens owned by receipent will be tradeable
239     function claimTokens(address receipent)
240         public
241         onlyMinter
242     {
243         balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
244         lockedBalances[receipent] = 0;
245     }
246 
247     /*
248      * CONSTANT METHODS
249      */
250     function lockedBalanceOf(address _owner) constant returns (uint balance) {
251         return lockedBalances[_owner];
252     }
253 }