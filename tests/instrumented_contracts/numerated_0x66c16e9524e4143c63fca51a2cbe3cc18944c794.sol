1 pragma solidity 0.4.24;
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
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 pragma solidity 0.4.24;
35 
36 contract Transfer {
37 
38     address constant public ETH = 0x0;
39 
40     /**
41     * @dev Transfer tokens from this contract to an account.
42     * @param token Address of token to transfer. 0x0 for ETH
43     * @param to Address to send tokens to.
44     * @param amount Amount of token to send.
45     */
46     function transfer(address token, address to, uint256 amount) internal returns (bool) {
47         if (token == ETH) {
48             to.transfer(amount);
49         } else {
50             require(ERC20(token).transfer(to, amount));
51         }
52         return true;
53     }
54 
55     /**
56     * @dev Transfer tokens from an account to this contract.
57     * @param token Address of token to transfer. 0x0 for ETH
58     * @param from Address to send tokens from.
59     * @param to Address to send tokens to.
60     * @param amount Amount of token to send.
61     */
62     function transferFrom(
63         address token,
64         address from,
65         address to,
66         uint256 amount
67     ) 
68         internal
69         returns (bool)
70     {
71         require(token == ETH && msg.value == amount || msg.value == 0);
72 
73         if (token != ETH) {
74             // Remember to approve first
75             require(ERC20(token).transferFrom(from, to, amount));
76         }
77         return true;
78     }
79 
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipRenounced(address indexed previousOwner);
92   event OwnershipTransferred(
93     address indexed previousOwner,
94     address indexed newOwner
95   );
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to relinquish control of the contract.
116    */
117   function renounceOwnership() public onlyOwner {
118     emit OwnershipRenounced(owner);
119     owner = address(0);
120   }
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param _newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address _newOwner) public onlyOwner {
127     _transferOwnership(_newOwner);
128   }
129 
130   /**
131    * @dev Transfers control of the contract to a newOwner.
132    * @param _newOwner The address to transfer ownership to.
133    */
134   function _transferOwnership(address _newOwner) internal {
135     require(_newOwner != address(0));
136     emit OwnershipTransferred(owner, _newOwner);
137     owner = _newOwner;
138   }
139 }
140 
141 
142 interface IERC20 {
143     function balanceOf(address _owner) public view returns (uint balance);
144     function transfer(address _to, uint _value) public returns (bool success);
145 }
146 
147 
148 contract Withdrawable is Ownable {
149     function () public payable {}
150 
151     // Allow the owner to withdraw Ether
152     function withdraw() public onlyOwner {
153         owner.transfer(address(this).balance);
154     }
155     
156     // Allow the owner to withdraw tokens
157     function withdrawToken(address token) public onlyOwner returns (bool) {
158         IERC20 foreignToken = IERC20(token);
159         uint256 amount = foreignToken.balanceOf(address(this));
160         return foreignToken.transfer(owner, amount);
161     }
162 }
163 
164 pragma solidity 0.4.24;
165 
166 contract ExternalCall {
167     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
168     // call has been separated into its own function in order to take advantage
169     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
170     function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
171         bool result;
172         assembly {
173             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
174             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
175             result := call(
176                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
177                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
178                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
179                 destination,
180                 value,
181                 d,
182                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
183                 x,
184                 0                  // Output is ignored, therefore the output size is zero
185             )
186         }
187         return result;
188     }
189 }
190 
191 /*
192 
193   Copyright 2018 Contra Labs Inc.
194 
195   Licensed under the Apache License, Version 2.0 (the "License");
196   you may not use this file except in compliance with the License.
197   You may obtain a copy of the License at
198 
199   http://www.apache.org/licenses/LICENSE-2.0
200 
201   Unless required by applicable law or agreed to in writing, software
202   distributed under the License is distributed on an "AS IS" BASIS,
203   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
204   See the License for the specific language governing permissions and
205   limitations under the License.
206 
207 */
208 
209 pragma solidity 0.4.24;
210 
211 // @title TradeExecutor: Atomically execute two trades using decentralized exchange wrapper contracts.
212 // @author Rich McAteer <rich@marble.org>, Max Wolff <max@marble.org>
213 contract TradeExecutor is Transfer, Withdrawable, ExternalCall {
214 
215     // Allow exchange wrappers to send Ether
216     function () public payable {}
217 
218     /**
219      * @dev Execute multiple trades in a single transaction.
220      * @param wrappers Addresses of exchange wrappers.
221      * @param token Address of ERC20 token to receive in first trade.
222      * @param trade1 Calldata of Ether => ERC20 trade.
223      * @param trade2 Calldata of ERC20 => Ether trade.
224     */
225     function trade(
226         address[2] wrappers,
227         address token,
228         bytes trade1,
229         bytes trade2
230     )
231         external
232         payable
233     {
234         // Execute the first trade to get tokens
235         require(execute(wrappers[0], msg.value, trade1));
236 
237         uint256 tokenBalance = IERC20(token).balanceOf(this);
238 
239         // Transfer tokens to the next exchange wrapper
240         transfer(token, wrappers[1], tokenBalance);
241 
242         // Execute the second trade to get Ether
243         require(execute(wrappers[1], 0, trade2));
244         
245         // Send the arbitrageur Ether
246         msg.sender.transfer(address(this).balance);
247     }
248 
249     function tradeForTokens(
250         address[2] wrappers,
251         address token,
252         bytes trade1,
253         bytes trade2
254     )
255         external
256     {
257         // Transfer tokens to the first exchange wrapper
258         uint256 tokenBalance = IERC20(token).balanceOf(this);
259         transfer(token, wrappers[0], tokenBalance);
260 
261         // Execute the first trade to get Ether
262         require(execute(wrappers[0], 0, trade1));
263 
264         uint256 balance = address(this).balance;
265 
266         // Execute the second trade to get tokens
267         require(execute(wrappers[1], balance, trade2));
268 
269         tokenBalance = IERC20(token).balanceOf(this);
270         require(IERC20(token).transfer(msg.sender, tokenBalance));
271     }
272 
273     function execute(address wrapper, uint256 value, bytes data) private returns (bool) {
274         return external_call(wrapper, value, data.length, data);
275     }
276 
277 }