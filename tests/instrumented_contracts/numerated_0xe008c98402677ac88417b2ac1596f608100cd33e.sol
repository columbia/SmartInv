1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath
7 {
8     function mul(uint a, uint b) internal returns (uint)
9     {
10         uint c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint a, uint b) internal returns (uint)
16     {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint a, uint b) internal returns (uint)
24     {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint a, uint b) internal returns (uint)
30     {
31         uint c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 
36     function max64(uint64 a, uint64 b) internal constant returns (uint64)
37     {
38         return a >= b ? a : b;
39     }
40 
41     function min64(uint64 a, uint64 b) internal constant returns (uint64)
42     {
43         return a < b ? a : b;
44     }
45 
46     function max256(uint256 a, uint256 b) internal constant returns (uint256)
47     {
48         return a >= b ? a : b;
49     }
50 
51     function min256(uint256 a, uint256 b) internal constant returns (uint256)
52     {
53         return a < b ? a : b;
54     }
55 
56     function assert(bool assertion) internal
57     {
58         if (!assertion)
59         {
60             throw;
61         }
62     }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20Basic
71 {
72     uint public totalSupply;
73     function balanceOf(address who) constant returns (uint);
74     function transfer(address to, uint value);
75     event Transfer(address indexed from, address indexed to, uint value);
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic
83 {
84     function allowance(address owner, address spender) constant returns (uint);
85     function transferFrom(address from, address to, uint value);
86     function approve(address spender, uint value);
87     event Approval(address indexed owner, address indexed spender, uint value);
88 }
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic
95 {
96     using SafeMath for uint;
97     mapping(address => uint) balances;
98 
99     /**
100      * @dev Fix for the ERC20 short address attack.
101      */
102     modifier onlyPayloadSize(uint size)
103     {
104         if(msg.data.length < size + 4)
105         {
106             throw;
107         }
108         _;
109     }
110 
111     /**
112      * @dev transfer token for a specified address
113      * @param _to The address to transfer to.
114      * @param _value The amount to be transferred.
115      */
116     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)
117     {
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         Transfer(msg.sender, _to, _value);
121     }
122 
123     /**
124      * @dev Gets the balance of the specified address.
125      * @param _owner The address to query the the balance of.
126      * @return An uint representing the amount owned by the passed address.
127      */
128     function balanceOf(address _owner) constant returns (uint balance)
129     {
130         return balances[_owner];
131     }
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is BasicToken, ERC20
142 {
143     mapping (address => mapping (address => uint)) allowed;
144 
145     /**
146      * @dev Transfer tokens from one address to another
147      * @param _from address The address which you want to send tokens from
148      * @param _to address The address which you want to transfer to
149      * @param _value uint the amout of tokens to be transfered
150      */
151     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)
152     {
153         uint _allowance = allowed[_from][msg.sender];
154         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155         // if (_value > _allowance) throw;
156         balances[_to] = balances[_to].add(_value);
157         balances[_from] = balances[_from].sub(_value);
158         allowed[_from][msg.sender] = _allowance.sub(_value);
159         Transfer(_from, _to, _value);
160     }
161 
162     /**
163      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
164      * @param _spender The address which will spend the funds.
165      * @param _value The amount of tokens to be spent.
166      */
167     function approve(address _spender, uint _value)
168     {
169 
170         // To change the approve amount you first have to reduce the addresses`
171         //  allowance to zero by calling `approve(_spender, 0)` if it is not
172         //  already 0 to mitigate the race condition described here:
173         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177     }
178 
179     /**
180      * @dev Function to check the amount of tokens than an owner allowed to a spender.
181      * @param _owner address The address which owns the funds.
182      * @param _spender address The address which will spend the funds.
183      * @return A uint specifing the amount of tokens still avaible for the spender.
184      */
185     function allowance(address _owner, address _spender) constant returns (uint remaining)
186     {
187         return allowed[_owner][_spender];
188     }
189 }
190 
191 /**
192  * @title Sophos ERC20 token
193  *
194  * @dev Implementation of the Sophos Token.
195  */
196 contract SophosToken is StandardToken
197 {
198     string public name = "Sophos";
199     string public symbol = "SOPH";
200     uint public decimals = 8 ;
201 
202     // Initial supply is 30,000,000.00000000
203     // AKA: 3 * (10 ** ( 7 + decimals )) when expressed as uint
204     uint public INITIAL_SUPPLY = 3000000000000000;
205 
206     // Allocation Constants
207 
208     // Expiration Unix Timestamp: Friday, November 1, 2019 12:00:00 AM
209     // https://www.unixtimestamp.com
210     uint public constant ALLOCATION_LOCK_END_TIMESTAMP = 1572566400;
211 
212     address public constant RAVI_ADDRESS = 0xB75066802f677bb5354F0850A1e1d3968E983BE8;
213     uint public constant    RAVI_ALLOCATION = 120000000000000; // 4%
214 
215     address public constant JULIAN_ADDRESS = 0xB2A76D747fC4A076D7f4Db3bA91Be97e94beB01C;
216     uint public constant    JULIAN_ALLOCATION = 120000000000000; // 4%
217 
218     address  public constant ABDEL_ADDRESS = 0x9894989fd6CaefCcEB183B8eB668B2d5614bEBb6;
219     uint public constant     ABDEL_ALLOCATION = 120000000000000; // 4%
220 
221     address public constant ASHLEY_ADDRESS = 0xb37B31f004dD8259F3171Ca5FBD451C03c3bC0Ae;
222     uint public constant    ASHLEY_ALLOCATION = 210000000000000; // 7%
223 
224     function SophosToken()
225     {
226         // Set total supply
227         totalSupply = INITIAL_SUPPLY;
228 
229         // Allocate total supply to sender
230         balances[msg.sender] = totalSupply;
231 
232         // Subtract team member allocations from total supply
233         balances[msg.sender] -= RAVI_ALLOCATION;
234         balances[msg.sender] -= JULIAN_ALLOCATION;
235         balances[msg.sender] -= ABDEL_ALLOCATION;
236         balances[msg.sender] -= ASHLEY_ALLOCATION;
237 
238         // Credit Team Member Allocation Addresses
239         balances[RAVI_ADDRESS]   = RAVI_ALLOCATION;
240         balances[JULIAN_ADDRESS] = JULIAN_ALLOCATION;
241         balances[ABDEL_ADDRESS]  = ABDEL_ALLOCATION;
242         balances[ASHLEY_ADDRESS] = ASHLEY_ALLOCATION;
243     }
244 
245     // Stop transactions from team member allocations during lock period
246     function isAllocationLocked(address _spender) constant returns (bool)
247     {
248         return inAllocationLockPeriod() && isTeamMember(_spender);
249     }
250 
251     // True if the current timestamp is before the allocation lock period
252     function inAllocationLockPeriod() constant returns (bool)
253     {
254         return (block.timestamp < ALLOCATION_LOCK_END_TIMESTAMP);
255     }
256 
257     // Is the spender address one of the Sophos Team?
258     function isTeamMember(address _spender) constant returns (bool)
259     {
260         return _spender == RAVI_ADDRESS  ||
261             _spender == JULIAN_ADDRESS ||
262             _spender == ABDEL_ADDRESS ||
263             _spender == ASHLEY_ADDRESS;
264     }
265 
266     // Function wrapper to check for allocation lock
267     function approve(address spender, uint tokens)
268     {
269         if (isAllocationLocked(spender))
270         {
271             throw;
272         }
273         else
274         {
275             super.approve(spender, tokens);
276         }
277     }
278 
279     // Function wrapper to check for allocation lock
280     function transfer(address to, uint tokens) onlyPayloadSize(2 * 32)
281     {
282         if (isAllocationLocked(to))
283         {
284             throw;
285         }
286         else
287         {
288             super.transfer(to, tokens);
289         }
290     }
291 
292     // Function wrapper to check for allocation lock
293     function transferFrom(address from, address to, uint tokens) onlyPayloadSize(3 * 32)
294     {
295         if (isAllocationLocked(from) || isAllocationLocked(to))
296         {
297             throw;
298         }
299         else
300         {
301             super.transferFrom(from, to, tokens);
302         }
303     }
304 }