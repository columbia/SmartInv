1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 /**
80  * @title Pausable
81  * @dev Base contract which allows children to implement an emergency stop mechanism.
82  */
83 contract Pausable is Ownable {
84   event Pause();
85   event Unpause();
86 
87   bool public paused = false;
88 
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is not paused.
92    */
93   modifier whenNotPaused() {
94     require(!paused);
95     _;
96   }
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is paused.
100    */
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to pause, triggers stopped state
108    */
109   function pause() onlyOwner whenNotPaused public {
110     paused = true;
111     emit Pause();
112   }
113 
114   /**
115    * @dev called by the owner to unpause, returns to normal state
116    */
117   function unpause() onlyOwner whenPaused public {
118     paused = false;
119     emit Unpause();
120   }
121 }
122 
123 
124 /**
125  * @title ERC223Interface
126  * @dev Simpler version of ERC223 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/223
128  */
129 
130 contract ERC223Interface {
131     uint public totalSupply;
132     function balanceOf(address who) public constant returns (uint);
133     function transfer(address to, uint value) public;
134     function transfer(address to, uint value, bytes data) public;
135     event Transfer(address indexed from, address indexed to, uint value, bytes data);
136 }
137 
138 /**
139  * @title Contract that will work with ERC223 tokens.
140  */
141  
142 contract ERC223ReceivingContract { 
143 /**
144  * @dev Standard ERC223 function that will handle incoming token transfers.
145  *
146  * @param _from  Token sender address.
147  * @param _value Amount of tokens.
148  * @param _data  Transaction metadata.
149  */
150     function tokenFallback(address _from, uint _value, bytes _data) public;
151 }
152 
153 /**
154  * @title Reference implementation of the ERC223 standard token.
155  */
156  
157 contract ERC223Token is ERC223Interface, Pausable  {
158     using SafeMath for uint;
159 
160     mapping(address => uint) balances; // List of user balances.
161     
162     /**
163      * @dev Transfer the specified amount of tokens to the specified address.
164      *      Invokes the `tokenFallback` function if the recipient is a contract.
165      *      The token transfer fails if the recipient is a contract
166      *      but does not implement the `tokenFallback` function
167      *      or the fallback function to receive funds.
168      *
169      * @param _to    Receiver address.
170      * @param _value Amount of tokens that will be transferred.
171      * @param _data  Transaction metadata.
172      */
173      
174     function transfer(address _to, uint _value, bytes _data) public whenNotPaused {
175         // Standard function transfer similar to ERC20 transfer with no _data .
176         // Added due to backwards compatibility reasons .
177         uint codeLength;
178 
179         assembly {
180             // Retrieve the size of the code on target address, this needs assembly .
181             codeLength := extcodesize(_to)
182         }
183 
184         balances[msg.sender] = balances[msg.sender].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         if(codeLength>0) {
187             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
188             receiver.tokenFallback(msg.sender, _value, _data);
189         }
190         emit Transfer(msg.sender, _to, _value, _data);
191     }
192     
193     /**
194      * @dev Transfer the specified amount of tokens to the specified address.
195      *      This function works the same with the previous one
196      *      but doesn't contain `_data` param.
197      *      Added due to backwards compatibility reasons.
198      *
199      * @param _to    Receiver address.
200      * @param _value Amount of tokens that will be transferred.
201      */
202     function transfer(address _to, uint _value) public whenNotPaused {
203         uint codeLength;
204         bytes memory empty;
205 
206         assembly {
207             // Retrieve the size of the code on target address, this needs assembly .
208             codeLength := extcodesize(_to)
209         }
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         if(codeLength>0) {
214             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
215             receiver.tokenFallback(msg.sender, _value, empty);
216         }
217         emit Transfer(msg.sender, _to, _value, empty);
218     }
219 
220     
221     /**
222      * @dev Returns balance of the `_owner`.
223      *
224      * @param _owner   The address whose balance will be returned.
225      * @return balance Balance of the `_owner`.
226      */
227     function balanceOf(address _owner) public whenNotPaused constant returns (uint balance)  {
228         return balances[_owner];
229     }
230 }
231 
232 
233 contract ZetTokenMint is ERC223Token {
234     
235     string public constant name = "ZETCAB";   // Set the name for display purposes
236     string public constant symbol = "PZE";  // Set the symbol for display purposes
237     uint256 public constant decimals = 18;  // 18 decimals is the strongly suggested default, avoid changing it
238     uint256 public constant INITIAL_SUPPLY = 25000000000 * (10 ** uint256(decimals));    // Set the initial supply
239     uint256 public totalSupply = INITIAL_SUPPLY;    // Set the total supply
240        	
241     address internal ZETCABOwner = 0xeA746e7A51173d6Ce404A107ab4C655d8C80716c;  // Set a ZETCABOwner's address
242 
243      /**
244      * @dev The log is output when the contract is distributed.
245      */
246     
247     constructor() public {
248        
249         balances[ZETCABOwner] = totalSupply;
250         
251     }
252     
253 }