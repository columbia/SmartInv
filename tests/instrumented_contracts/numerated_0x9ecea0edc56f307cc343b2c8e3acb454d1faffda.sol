1 /*
2 
3   Copyright 2018 bZeroX, LLC
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipRenounced(address indexed previousOwner);
31   event OwnershipTransferred(
32     address indexed previousOwner,
33     address indexed newOwner
34   );
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 // This provides a gatekeeping modifier for functions that can only be used by the bZx contract
81 // Since it inherits Ownable provides typical ownership functionality with a slight modification to the transferOwnership function
82 // Setting owner and bZxContractAddress to the same address is not supported.
83 contract BZxOwnable is Ownable {
84 
85     address public bZxContractAddress;
86 
87     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
88 
89     // modifier reverts if bZxContractAddress isn't set
90     modifier onlyBZx() {
91         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
92         _;
93     }
94 
95     /**
96     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
97     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
98     */
99     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
100         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
101         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
102         bZxContractAddress = newBZxContractAddress;
103     }
104 
105     /**
106     * @dev Allows the current owner to transfer control of the contract to a newOwner.
107     * @param newOwner The address to transfer ownership to.
108     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
109     */
110     function transferOwnership(address newOwner) public onlyOwner {
111         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115 }
116 
117 interface NonCompliantEIP20 {
118     function transfer(address _to, uint _value) external;
119     function transferFrom(address _from, address _to, uint _value) external;
120     function approve(address _spender, uint _value) external;
121 }
122 
123 /**
124  * @title EIP20/ERC20 wrapper that will support noncompliant ERC20s
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  * @dev see https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
127  */
128 contract EIP20Wrapper {
129 
130     function eip20Transfer(
131         address token,
132         address to,
133         uint256 value)
134         internal
135         returns (bool result) {
136 
137         NonCompliantEIP20(token).transfer(to, value);
138 
139         assembly {
140             switch returndatasize()   
141             case 0 {                        // non compliant ERC20
142                 result := not(0)            // result is true
143             }
144             case 32 {                       // compliant ERC20
145                 returndatacopy(0, 0, 32) 
146                 result := mload(0)          // result == returndata of external call
147             }
148             default {                       // not an not an ERC20 token
149                 revert(0, 0) 
150             }
151         }
152 
153         require(result, "eip20Transfer failed");
154     }
155 
156     function eip20TransferFrom(
157         address token,
158         address from,
159         address to,
160         uint256 value)
161         internal
162         returns (bool result) {
163 
164         NonCompliantEIP20(token).transferFrom(from, to, value);
165 
166         assembly {
167             switch returndatasize()   
168             case 0 {                        // non compliant ERC20
169                 result := not(0)            // result is true
170             }
171             case 32 {                       // compliant ERC20
172                 returndatacopy(0, 0, 32) 
173                 result := mload(0)          // result == returndata of external call
174             }
175             default {                       // not an not an ERC20 token
176                 revert(0, 0) 
177             }
178         }
179 
180         require(result, "eip20TransferFrom failed");
181     }
182 
183     function eip20Approve(
184         address token,
185         address spender,
186         uint256 value)
187         internal
188         returns (bool result) {
189 
190         NonCompliantEIP20(token).approve(spender, value);
191 
192         assembly {
193             switch returndatasize()   
194             case 0 {                        // non compliant ERC20
195                 result := not(0)            // result is true
196             }
197             case 32 {                       // compliant ERC20
198                 returndatacopy(0, 0, 32) 
199                 result := mload(0)          // result == returndata of external call
200             }
201             default {                       // not an not an ERC20 token
202                 revert(0, 0) 
203             }
204         }
205 
206         require(result, "eip20Approve failed");
207     }
208 }
209 
210 contract BZxVault is EIP20Wrapper, BZxOwnable {
211 
212     // Only the bZx contract can directly deposit ether
213     function() public payable onlyBZx {}
214 
215     function withdrawEther(
216         address to,
217         uint value)
218         public
219         onlyBZx
220         returns (bool)
221     {
222         uint amount = value;
223         if (amount > address(this).balance) {
224             amount = address(this).balance;
225         }
226 
227         return (to.send(amount));
228     }
229 
230     function depositToken(
231         address token,
232         address from,
233         uint tokenAmount)
234         public
235         onlyBZx
236         returns (bool)
237     {
238         if (tokenAmount == 0) {
239             return false;
240         }
241         
242         eip20TransferFrom(
243             token,
244             from,
245             this,
246             tokenAmount);
247 
248         return true;
249     }
250 
251     function withdrawToken(
252         address token,
253         address to,
254         uint tokenAmount)
255         public
256         onlyBZx
257         returns (bool)
258     {
259         if (tokenAmount == 0) {
260             return false;
261         }
262         
263         eip20Transfer(
264             token,
265             to,
266             tokenAmount);
267 
268         return true;
269     }
270 
271     function transferTokenFrom(
272         address token,
273         address from,
274         address to,
275         uint tokenAmount)
276         public
277         onlyBZx
278         returns (bool)
279     {
280         if (tokenAmount == 0) {
281             return false;
282         }
283         
284         eip20TransferFrom(
285             token,
286             from,
287             to,
288             tokenAmount);
289 
290         return true;
291     }
292 }