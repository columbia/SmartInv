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
80 interface NonCompliantEIP20 {
81     function transfer(address _to, uint _value) external;
82     function transferFrom(address _from, address _to, uint _value) external;
83     function approve(address _spender, uint _value) external;
84 }
85 
86 /**
87  * @title EIP20/ERC20 wrapper that will support noncompliant ERC20s
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  * @dev see https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
90  */
91 contract EIP20Wrapper {
92 
93     function eip20Transfer(
94         address token,
95         address to,
96         uint256 value)
97         internal
98         returns (bool result) {
99 
100         NonCompliantEIP20(token).transfer(to, value);
101 
102         assembly {
103             switch returndatasize()   
104             case 0 {                        // non compliant ERC20
105                 result := not(0)            // result is true
106             }
107             case 32 {                       // compliant ERC20
108                 returndatacopy(0, 0, 32) 
109                 result := mload(0)          // result == returndata of external call
110             }
111             default {                       // not an not an ERC20 token
112                 revert(0, 0) 
113             }
114         }
115 
116         require(result, "eip20Transfer failed");
117     }
118 
119     function eip20TransferFrom(
120         address token,
121         address from,
122         address to,
123         uint256 value)
124         internal
125         returns (bool result) {
126 
127         NonCompliantEIP20(token).transferFrom(from, to, value);
128 
129         assembly {
130             switch returndatasize()   
131             case 0 {                        // non compliant ERC20
132                 result := not(0)            // result is true
133             }
134             case 32 {                       // compliant ERC20
135                 returndatacopy(0, 0, 32) 
136                 result := mload(0)          // result == returndata of external call
137             }
138             default {                       // not an not an ERC20 token
139                 revert(0, 0) 
140             }
141         }
142 
143         require(result, "eip20TransferFrom failed");
144     }
145 
146     function eip20Approve(
147         address token,
148         address spender,
149         uint256 value)
150         internal
151         returns (bool result) {
152 
153         NonCompliantEIP20(token).approve(spender, value);
154 
155         assembly {
156             switch returndatasize()   
157             case 0 {                        // non compliant ERC20
158                 result := not(0)            // result is true
159             }
160             case 32 {                       // compliant ERC20
161                 returndatacopy(0, 0, 32) 
162                 result := mload(0)          // result == returndata of external call
163             }
164             default {                       // not an not an ERC20 token
165                 revert(0, 0) 
166             }
167         }
168 
169         require(result, "eip20Approve failed");
170     }
171 }
172 
173 contract BZRXFakeFaucet is EIP20Wrapper, Ownable {
174 
175     uint public faucetThresholdSecs = 14400; // 4 hours
176 
177     mapping (address => mapping (address => uint)) public faucetUsers; // mapping of users to mapping of tokens to last request times
178 
179     function() public payable {}
180 
181     function faucet(
182         address getToken,
183         address receiver)
184         public
185         returns (bool)
186     {
187         require(block.timestamp-faucetUsers[receiver][getToken] >= faucetThresholdSecs 
188             && block.timestamp-faucetUsers[msg.sender][getToken] >= faucetThresholdSecs, "BZRXFakeFaucet::faucet: token requested too recently");
189 
190         faucetUsers[receiver][getToken] = block.timestamp;
191         faucetUsers[msg.sender][getToken] = block.timestamp;
192 
193         eip20Transfer(
194             getToken,
195             receiver,
196             1 ether);
197 
198         return true;
199     }
200 
201     function withdrawEther(
202         address to,
203         uint value)
204         public
205         onlyOwner
206         returns (bool)
207     {
208         uint amount = value;
209         if (amount > address(this).balance) {
210             amount = address(this).balance;
211         }
212 
213         return (to.send(amount)); // solhint-disable-line check-send-result, multiple-sends
214     }
215 
216     function withdrawToken(
217         address token,
218         address to,
219         uint tokenAmount)
220         public
221         onlyOwner
222         returns (bool)
223     {
224         if (tokenAmount == 0) {
225             return false;
226         }
227         
228         eip20Transfer(
229             token,
230             to,
231             tokenAmount);
232 
233         return true;
234     }
235 
236     function depositToken(
237         address token,
238         address from,
239         uint tokenAmount)
240         public
241         onlyOwner
242         returns (bool)
243     {
244         if (tokenAmount == 0) {
245             return false;
246         }
247         
248         eip20TransferFrom(
249             token,
250             from,
251             this,
252             tokenAmount);
253 
254         return true;
255     }
256 
257     function transferTokenFrom(
258         address token,
259         address from,
260         address to,
261         uint tokenAmount)
262         public
263         onlyOwner
264         returns (bool)
265     {
266         if (tokenAmount == 0) {
267             return false;
268         }
269         
270         eip20TransferFrom(
271             token,
272             from,
273             to,
274             tokenAmount);
275 
276         return true;
277     }
278 
279     function setFaucetThresholdSecs(
280         uint newValue) 
281         public
282         onlyOwner
283     {
284         require(newValue != faucetThresholdSecs);
285         faucetThresholdSecs = newValue;
286     }
287 }