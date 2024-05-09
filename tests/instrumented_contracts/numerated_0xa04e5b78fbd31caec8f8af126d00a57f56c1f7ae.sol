1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender)
22     public view returns (uint256);
23 
24   function transferFrom(address from, address to, uint256 value)
25     public returns (bool);
26 
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 pragma solidity 0.4.24;
36 
37 contract Transfer {
38 
39     address constant public ETH = 0x0;
40 
41     /**
42     * @dev Transfer tokens from this contract to an account.
43     * @param token Address of token to transfer. 0x0 for ETH
44     * @param to Address to send tokens to.
45     * @param amount Amount of token to send.
46     */
47     function transfer(address token, address to, uint256 amount) internal returns (bool) {
48         if (token == ETH) {
49             to.transfer(amount);
50         } else {
51             require(ERC20(token).transfer(to, amount));
52         }
53         return true;
54     }
55 
56     /**
57     * @dev Transfer tokens from an account to this contract.
58     * @param token Address of token to transfer. 0x0 for ETH
59     * @param from Address to send tokens from.
60     * @param to Address to send tokens to.
61     * @param amount Amount of token to send.
62     */
63     function transferFrom(
64         address token,
65         address from,
66         address to,
67         uint256 amount
68     ) 
69         internal
70         returns (bool)
71     {
72         require(token == ETH && msg.value == amount || msg.value == 0);
73 
74         if (token != ETH) {
75             // Remember to approve first
76             require(ERC20(token).transferFrom(from, to, amount));
77         }
78         return true;
79     }
80 
81 }
82 
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
95     // benefit is lost if 'b' is also tested.
96     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97     if (a == 0) {
98       return 0;
99     }
100 
101     c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     // uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return a / b;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
128     c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 
135 /**
136  * @title Ownable
137  * @dev The Ownable contract has an owner address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable {
141   address public owner;
142 
143 
144   event OwnershipRenounced(address indexed previousOwner);
145   event OwnershipTransferred(
146     address indexed previousOwner,
147     address indexed newOwner
148   );
149 
150 
151   /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155   constructor() public {
156     owner = msg.sender;
157   }
158 
159   /**
160    * @dev Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner);
164     _;
165   }
166 
167   /**
168    * @dev Allows the current owner to relinquish control of the contract.
169    */
170   function renounceOwnership() public onlyOwner {
171     emit OwnershipRenounced(owner);
172     owner = address(0);
173   }
174 
175   /**
176    * @dev Allows the current owner to transfer control of the contract to a newOwner.
177    * @param _newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address _newOwner) public onlyOwner {
180     _transferOwnership(_newOwner);
181   }
182 
183   /**
184    * @dev Transfers control of the contract to a newOwner.
185    * @param _newOwner The address to transfer ownership to.
186    */
187   function _transferOwnership(address _newOwner) internal {
188     require(_newOwner != address(0));
189     emit OwnershipTransferred(owner, _newOwner);
190     owner = _newOwner;
191   }
192 }
193 
194 
195 /*
196 
197   Copyright 2018 Contra Labs Inc.
198 
199   Licensed under the Apache License, Version 2.0 (the "License");
200   you may not use this file except in compliance with the License.
201   You may obtain a copy of the License at
202 
203   http://www.apache.org/licenses/LICENSE-2.0
204 
205   Unless required by applicable law or agreed to in writing, software
206   distributed under the License is distributed on an "AS IS" BASIS,
207   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
208   See the License for the specific language governing permissions and
209   limitations under the License.
210 
211 */
212 
213 pragma solidity 0.4.24;
214 
215 
216 // @title Bank: Accept deposits and allow approved contracts to borrow Ether and ERC20 tokens.
217 // @author Rich McAteer <rich@marble.org>, Max Wolff <max@marble.org>
218 contract Bank is Ownable, Transfer {
219     using SafeMath for uint256;
220 
221     // Borrower => Approved
222     mapping (address => bool) public approved;
223 
224     modifier onlyApproved() {
225         require(approved[msg.sender] == true);
226         _;
227     }
228 
229     /**
230     * @dev Deposit tokens to the bank.
231     * @param token Address of token to deposit. 0x0 for ETH
232     * @param amount Amount of token to deposit.
233     */
234     function deposit(address token, uint256 amount) external onlyOwner payable {
235         transferFrom(token, msg.sender, this, amount);
236     }
237 
238     /**
239     * @dev Withdraw tokens from the bank.
240     * @param token Address of token to withdraw. 0x0 for ETH
241     * @param amount Amount of token to withdraw.
242     */
243     function withdraw(address token, uint256 amount) external onlyOwner {
244         transfer(token, msg.sender, amount);
245     }
246 
247     /**
248     * @dev Borrow tokens from the bank.
249     * @param token Address of token to borrow. 0x0 for ETH
250     * @param amount Amount of token to borrow.
251     */
252     function borrow(address token, uint256 amount) external onlyApproved {
253         borrowFor(token, msg.sender, amount);
254     }
255 
256     /**
257     * @dev Borrow tokens from the bank on behalf of another account.
258     * @param token Address of token to borrow. 0x0 for ETH
259     * @param who Address to send borrowed amount to.
260     * @param amount Amount of token to borrow.
261     */
262     function borrowFor(address token, address who, uint256 amount) public onlyApproved {
263         transfer(token, who, amount);        
264     }
265 
266     /**
267     * @dev Repay tokens to the bank.
268     * @param token Address of token to repay. 0x0 for ETH
269     * @param amount Amount of token to repay.
270     */
271     function repay(address token, uint256 amount) external payable {
272         transferFrom(token, msg.sender, this, amount);
273     }
274 
275     /**
276     * @dev Approve a new borrower.
277     * @param borrower Address of new borrower.
278     */
279     function addBorrower(address borrower) external onlyOwner {
280         approved[borrower] = true;
281     }
282 
283     /**
284     * @dev Revoke approval of a borrower.
285     * @param borrower Address of borrower to revoke.
286     */
287     function removeBorrower(address borrower) external onlyOwner {
288         approved[borrower] = false;
289     }
290 
291     /**
292     * @dev Gets balance of bank. 
293     * @param token Address of token to calculate total supply of.
294     */
295     function totalSupplyOf(address token) public view returns (uint256 balance) {
296         if (token == ETH) {
297             return address(this).balance; 
298         } else {
299             return ERC20(token).balanceOf(this); 
300         }
301     }
302 
303 }