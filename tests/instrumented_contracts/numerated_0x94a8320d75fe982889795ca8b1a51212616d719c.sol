1 pragma solidity ^0.4.11;
2 
3 library Math {
4     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5         return a >= b ? a : b;
6     }
7 
8     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9         return a < b ? a : b;
10     }
11 
12     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17         return a < b ? a : b;
18     }
19 }
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal constant returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal constant returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 contract Ownable {
49     address public owner;
50 
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     function Ownable() {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) onlyOwner {
75         if (newOwner != address(0)) {
76             owner = newOwner;
77         }
78     }
79 
80 }
81 
82 contract Claimable is Ownable {
83     address public pendingOwner;
84 
85     /**
86      * @dev Modifier throws if called by any account other than the pendingOwner.
87      */
88     modifier onlyPendingOwner() {
89         require(msg.sender == pendingOwner);
90         _;
91     }
92 
93     /**
94      * @dev Allows the current owner to set the pendingOwner address.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function transferOwnership(address newOwner) onlyOwner {
98         pendingOwner = newOwner;
99     }
100 
101     /**
102      * @dev Allows the pendingOwner address to finalize the transfer.
103      */
104     function claimOwnership() onlyPendingOwner {
105         owner = pendingOwner;
106         pendingOwner = 0x0;
107     }
108 }
109 
110 
111 /**
112  * @title Contactable token
113  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
114  * contact information.
115  */
116 contract Contactable is Ownable{
117 
118     string public contactInformation;
119 
120     /**
121      * @dev Allows the owner to set a string with their contact information.
122      * @param info The contact information to attach to the contract.
123      */
124     function setContactInformation(string info) onlyOwner{
125         contactInformation = info;
126     }
127 }
128 
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136     uint256 public totalSupply;
137     function balanceOf(address who) constant returns (uint256);
138     function transfer(address to, uint256 value) returns (bool);
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148     function allowance(address owner, address spender) constant returns (uint256);
149     function transferFrom(address from, address to, uint256 value) returns (bool);
150     function approve(address spender, uint256 value) returns (bool);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160     using SafeMath for uint256;
161 
162     mapping(address => uint256) balances;
163     uint256 public decimals;
164 
165     /**
166     * @dev transfer token for a specified address
167     * @param _to The address to transfer to.
168     * @param _value The amount to be transferred.
169     */
170     function transfer(address _to, uint256 _value) returns (bool) {
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         Transfer(msg.sender, _to, _value);
174         return true;
175     }
176 
177     /**
178     * @dev Gets the balance of the specified address.
179     * @param _owner The address to query the the balance of.
180     * @return An uint256 representing the amount owned by the passed address.
181     */
182     function balanceOf(address _owner) constant returns (uint256 balance) {
183         return balances[_owner];
184     }
185 
186 }
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198     mapping (address => mapping (address => uint256)) allowed;
199 
200 
201     /**
202      * @dev Transfer tokens from one address to another
203      * @param _from address The address which you want to send tokens from
204      * @param _to address The address which you want to transfer to
205      * @param _value uint256 the amout of tokens to be transfered
206      */
207     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
208         var _allowance = allowed[_from][msg.sender];
209 
210         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
211         // require (_value <= _allowance);
212 
213         balances[_to] = balances[_to].add(_value);
214         balances[_from] = balances[_from].sub(_value);
215         allowed[_from][msg.sender] = _allowance.sub(_value);
216         Transfer(_from, _to, _value);
217         return true;
218     }
219 
220     /**
221      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
222      * @param _spender The address which will spend the funds.
223      * @param _value The amount of tokens to be spent.
224      */
225     function approve(address _spender, uint256 _value) returns (bool) {
226 
227         // To change the approve amount you first have to reduce the addresses`
228         //  allowance to zero by calling `approve(_spender, 0)` if it is not
229         //  already 0 to mitigate the race condition described here:
230         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
232 
233         allowed[msg.sender][_spender] = _value;
234         Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     /**
239      * @dev Function to check the amount of tokens that an owner allowed to a spender.
240      * @param _owner address The address which owns the funds.
241      * @param _spender address The address which will spend the funds.
242      * @return A uint256 specifing the amount of tokens still avaible for the spender.
243      */
244     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
245         return allowed[_owner][_spender];
246     }
247 
248 }
249 
250 /**
251  * @title Token
252  * @dev The token implement Claimable, NoOwner, StandardToken, Contactable contracts.
253 **/
254 contract Token is Claimable, StandardToken, Contactable {
255     // public vals
256     string public name;
257     string public symbol;
258 
259     // @dev construct function for token
260     function Token() {
261         uint256 _decimals = 18;
262         uint256 _supply = 1000000000*(10**_decimals);
263 
264         balances[msg.sender] = _supply;
265         totalSupply = _supply;
266         decimals = 18;
267         name = "ISQ.store";
268         symbol = "ISQ";
269         contactInformation = "ISQ.store is a global new retail platform. ISQ tokens are issued by ISQ Holding Limited.";
270     }
271 }