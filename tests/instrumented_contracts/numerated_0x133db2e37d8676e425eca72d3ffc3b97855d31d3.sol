1 pragma solidity ^0.5.3;
2 
3 pragma solidity ^0.5.3;
4 
5 /**
6  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
7  * Modified by https://www.coinfabrik.com/
8  */
9 
10 pragma solidity ^0.5.3;
11 
12 /**
13  * Interface for the standard token.
14  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
15  */
16 contract EIP20Token {
17 
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool success);
21   function transferFrom(address from, address to, uint256 value) public returns (bool success);
22   function approve(address spender, uint256 value) public returns (bool success);
23   function allowance(address owner, address spender) public view returns (uint256 remaining);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27 }
28 
29 pragma solidity ^0.5.3;
30 
31 /**
32  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
33  * Modified by https://www.coinfabrik.com/
34  */
35 
36 /**
37  * Math operations with safety checks
38  */
39 library SafeMath {
40   function mul(uint a, uint b) internal pure returns (uint) {
41     uint c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint a, uint b) internal pure returns (uint) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint a, uint b) internal pure returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint a, uint b) internal pure returns (uint) {
59     uint c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 
64   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
65     return a >= b ? a : b;
66   }
67 
68   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
69     return a < b ? a : b;
70   }
71 
72   function max256(uint a, uint b) internal pure returns (uint) {
73     return a >= b ? a : b;
74   }
75 
76   function min256(uint a, uint b) internal pure returns (uint) {
77     return a < b ? a : b;
78   }
79 }
80 
81 pragma solidity ^0.5.3;
82 
83 // Interface for burning tokens
84 contract Burnable {
85   // @dev Destroys tokens for an account
86   // @param account Account whose tokens are destroyed
87   // @param value Amount of tokens to destroy
88   function burnTokens(address account, uint value) internal;
89   event Burned(address account, uint value);
90 }
91 
92 pragma solidity ^0.5.3;
93 
94 /**
95  * Authored by https://www.coinfabrik.com/
96  */
97 
98 
99 /**
100  * Internal interface for the minting of tokens.
101  */
102 contract Mintable {
103 
104   /**
105    * @dev Mints tokens for an account
106    * This function should emit the Minted event.
107    */
108   function mintInternal(address receiver, uint amount) internal;
109 
110   /** Token supply got increased and a new owner received these tokens */
111   event Minted(address receiver, uint amount);
112 }
113 
114 
115 /**
116  * @title Standard token
117  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
118  */
119 contract StandardToken is EIP20Token, Burnable, Mintable {
120   using SafeMath for uint;
121 
122   uint private total_supply;
123   mapping(address => uint) private balances;
124   mapping(address => mapping (address => uint)) private allowed;
125 
126 
127   function totalSupply() public view returns (uint) {
128     return total_supply;
129   }
130 
131   /**
132    * @dev transfer token for a specified address
133    * @param to The address to transfer to.
134    * @param value The amount to be transferred.
135    */
136   function transfer(address to, uint value) public returns (bool success) {
137     balances[msg.sender] = balances[msg.sender].sub(value);
138     balances[to] = balances[to].add(value);
139     emit Transfer(msg.sender, to, value);
140     return true;
141   }
142 
143   /**
144    * @dev Gets the balance of the specified address.
145    * @param account The address whose balance is to be queried.
146    * @return An uint representing the amount owned by the passed address.
147    */
148   function balanceOf(address account) public view returns (uint balance) {
149     return balances[account];
150   }
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param from address The address which you want to send tokens from
155    * @param to address The address which you want to transfer to
156    * @param value uint the amout of tokens to be transfered
157    */
158   function transferFrom(address from, address to, uint value) public returns (bool success) {
159     uint allowance = allowed[from][msg.sender];
160 
161     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
162     // require(value <= allowance);
163     // SafeMath uses assert instead of require though, beware when using an analysis tool
164 
165     balances[from] = balances[from].sub(value);
166     balances[to] = balances[to].add(value);
167     allowed[from][msg.sender] = allowance.sub(value);
168     emit Transfer(from, to, value);
169     return true;
170   }
171 
172   /**
173    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * @param spender The address which will spend the funds.
175    * @param value The amount of tokens to be spent.
176    */
177   function approve(address spender, uint value) public returns (bool success) {
178 
179     // To change the approve amount you first have to reduce the addresses'
180     //  allowance to zero by calling `approve(spender, 0)` if it is not
181     //  already 0 to mitigate the race condition described here:
182     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183     require (value == 0 || allowed[msg.sender][spender] == 0);
184 
185     allowed[msg.sender][spender] = value;
186     emit Approval(msg.sender, spender, value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens than an owner allowed to a spender.
192    * @param account address The address which owns the funds.
193    * @param spender address The address which will spend the funds.
194    * @return A uint specifing the amount of tokens still avaible for the spender.
195    */
196   function allowance(address account, address spender) public view returns (uint remaining) {
197     return allowed[account][spender];
198   }
199 
200   /**
201    * Atomic increment of approved spending
202    *
203    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    *
205    */
206   function addApproval(address spender, uint addedValue) public returns (bool success) {
207       uint oldValue = allowed[msg.sender][spender];
208       allowed[msg.sender][spender] = oldValue.add(addedValue);
209       emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
210       return true;
211   }
212 
213   /**
214    * Atomic decrement of approved spending.
215    *
216    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    */
218   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
219 
220       uint oldVal = allowed[msg.sender][spender];
221 
222       if (subtractedValue > oldVal) {
223           allowed[msg.sender][spender] = 0;
224       } else {
225           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
226       }
227       emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
228       return true;
229   }
230 
231   /**
232    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
233    */
234   function burnTokens(address account, uint value) internal {
235     balances[account] = balances[account].sub(value);
236     total_supply = total_supply.sub(value);
237     emit Transfer(account, address(0), value);
238     emit Burned(account, value);
239   }
240 
241   /**
242    * @dev Provides an internal minting function.
243    */
244   function mintInternal(address receiver, uint amount) internal {
245     total_supply = total_supply.add(amount);
246     balances[receiver] = balances[receiver].add(amount);
247     emit Minted(receiver, amount);
248 
249     // Beware: Address zero may be used for special transactions in a future fork.
250     // This will make the mint transaction appear in EtherScan.io
251     // We can remove this after there is a standardized minting event
252     emit Transfer(address(0), receiver, amount);
253   }
254 
255 }
256 
257 
258 /**
259  * @title LeaxToken
260  * @dev ERC20 Token implementation with burning capabilities
261  */
262 contract LeaxToken is StandardToken {
263 
264     string public constant name = "LEAXEX";
265     string public constant symbol = "LXX";
266     uint8 public constant decimals = 18;
267     uint256 public constant initial_supply = 21000000000 * (10 ** 18);
268     address public constant initial_holder = 0xDc29D066d85650887B5d2B860e2413B54c5f39B1;
269 
270     constructor() public {
271         // Mint the entire supply for the initial holder
272         mintInternal(initial_holder, initial_supply);
273     }
274 
275     /**
276      * @dev Allows users to burn their own tokens
277      */
278     function burn(uint256 amount) public {
279         burnTokens(msg.sender, amount);
280     }
281 }