1 pragma solidity 0.7.5;
2 
3 /*
4     The MIT License (MIT)
5     Copyright (c) 2018 Murray Software, LLC.
6     Permission is hereby granted, free of charge, to any person obtaining
7     a copy of this software and associated documentation files (the
8     "Software"), to deal in the Software without restriction, including
9     without limitation the rights to use, copy, modify, merge, publish,
10     distribute, sublicense, and/or sell copies of the Software, and to
11     permit persons to whom the Software is furnished to do so, subject to
12     the following conditions:
13     The above copyright notice and this permission notice shall be included
14     in all copies or substantial portions of the Software.
15     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
16     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
17     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
18     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
19     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
20     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
21     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
22 */
23 //solhint-disable max-line-length
24 //solhint-disable no-inline-assembly
25 
26 contract CloneFactory {
27   function createClone(address target, bytes32 salt)
28     internal
29     returns (address payable result)
30   {
31     bytes20 targetBytes = bytes20(target);
32     assembly {
33       // load the next free memory slot as a place to store the clone contract data
34       let clone := mload(0x40)
35 
36       // The bytecode block below is responsible for contract initialization
37       // during deployment, it is worth noting the proxied contract constructor will not be called during
38       // the cloning procedure and that is why an initialization function needs to be called after the
39       // clone is created
40       mstore(
41         clone,
42         0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
43       )
44 
45       // This stores the address location of the implementation contract
46       // so that the proxy knows where to delegate call logic to
47       mstore(add(clone, 0x14), targetBytes)
48 
49       // The bytecode block is the actual code that is deployed for each clone created.
50       // It forwards all calls to the already deployed implementation via a delegatecall
51       mstore(
52         add(clone, 0x28),
53         0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
54       )
55 
56       // deploy the contract using the CREATE2 opcode
57       // this deploys the minimal proxy defined above, which will proxy all
58       // calls to use the logic defined in the implementation contract `target`
59       result := create2(0, clone, 0x37, salt)
60     }
61   }
62 
63   function isClone(address target, address query)
64     internal
65     view
66     returns (bool result)
67   {
68     bytes20 targetBytes = bytes20(target);
69     assembly {
70       // load the next free memory slot as a place to store the comparison clone
71       let clone := mload(0x40)
72 
73       // The next three lines store the expected bytecode for a miniml proxy
74       // that targets `target` as its implementation contract
75       mstore(
76         clone,
77         0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000
78       )
79       mstore(add(clone, 0xa), targetBytes)
80       mstore(
81         add(clone, 0x1e),
82         0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
83       )
84 
85       // the next two lines store the bytecode of the contract that we are checking in memory
86       let other := add(clone, 0x40)
87       extcodecopy(query, other, 0, 0x2d)
88 
89       // Check if the expected bytecode equals the actual bytecode and return the result
90       result := and(
91         eq(mload(clone), mload(other)),
92         eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
93       )
94     }
95   }
96 }
97 
98 
99 /**
100  * Contract that exposes the needed erc20 token functions
101  */
102 
103 abstract contract ERC20Interface {
104   // Send _value amount of tokens to address _to
105   function transfer(address _to, uint256 _value)
106     public
107     virtual
108     returns (bool success);
109 
110   // Get the account balance of another account with address _owner
111   function balanceOf(address _owner)
112     public
113     virtual
114     view
115     returns (uint256 balance);
116 }
117 
118 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
119 library TransferHelper {
120     function safeApprove(
121         address token,
122         address to,
123         uint256 value
124     ) internal {
125         // bytes4(keccak256(bytes('approve(address,uint256)')));
126         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
127         require(
128             success && (data.length == 0 || abi.decode(data, (bool))),
129             'TransferHelper::safeApprove: approve failed'
130         );
131     }
132 
133     function safeTransfer(
134         address token,
135         address to,
136         uint256 value
137     ) internal {
138         // bytes4(keccak256(bytes('transfer(address,uint256)')));
139         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
140         require(
141             success && (data.length == 0 || abi.decode(data, (bool))),
142             'TransferHelper::safeTransfer: transfer failed'
143         );
144     }
145 
146     function safeTransferFrom(
147         address token,
148         address from,
149         address to,
150         uint256 value
151     ) internal {
152         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
153         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
154         require(
155             success && (data.length == 0 || abi.decode(data, (bool))),
156             'TransferHelper::transferFrom: transferFrom failed'
157         );
158     }
159 
160     function safeTransferETH(address to, uint256 value) internal {
161         (bool success, ) = to.call{value: value}(new bytes(0));
162         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
163     }
164 }
165 
166 
167 /**
168  * Contract that will forward any incoming Ether to the creator of the contract
169  *
170  */
171 contract Forwarder {
172   // Address to which any funds sent to this contract will be forwarded
173   address public parentAddress;
174   event ForwarderDeposited(address from, uint256 value, bytes data);
175 
176   /**
177    * Initialize the contract, and sets the destination address to that of the creator
178    */
179   function init(address _parentAddress) external onlyUninitialized {
180     parentAddress = _parentAddress;
181     uint256 value = address(this).balance;
182 
183     if (value == 0) {
184       return;
185     }
186 
187     (bool success, ) = parentAddress.call{ value: value }('');
188     require(success, 'Flush failed');
189     // NOTE: since we are forwarding on initialization,
190     // we don't have the context of the original sender.
191     // We still emit an event about the forwarding but set
192     // the sender to the forwarder itself
193     emit ForwarderDeposited(address(this), value, msg.data);
194   }
195 
196   /**
197    * Modifier that will execute internal code block only if the sender is the parent address
198    */
199   modifier onlyParent {
200     require(msg.sender == parentAddress, 'Only Parent');
201     _;
202   }
203 
204   /**
205    * Modifier that will execute internal code block only if the contract has not been initialized yet
206    */
207   modifier onlyUninitialized {
208     require(parentAddress == address(0x0), 'Already initialized');
209     _;
210   }
211 
212   /**
213    * Default function; Gets called when data is sent but does not match any other function
214    */
215   fallback() external payable {
216     flush();
217   }
218 
219   /**
220    * Default function; Gets called when Ether is deposited with no data, and forwards it to the parent address
221    */
222   receive() external payable {
223     flush();
224   }
225 
226   /**
227    * Execute a token transfer of the full balance from the forwarder token to the parent address
228    * @param tokenContractAddress the address of the erc20 token contract
229    */
230   function flushTokens(address tokenContractAddress) external onlyParent {
231     ERC20Interface instance = ERC20Interface(tokenContractAddress);
232     address forwarderAddress = address(this);
233     uint256 forwarderBalance = instance.balanceOf(forwarderAddress);
234     if (forwarderBalance == 0) {
235       return;
236     }
237 
238     TransferHelper.safeTransfer(
239       tokenContractAddress,
240       parentAddress,
241       forwarderBalance
242     );
243   }
244 
245   /**
246    * Flush the entire balance of the contract to the parent address.
247    */
248   function flush() public {
249     uint256 value = address(this).balance;
250 
251     if (value == 0) {
252       return;
253     }
254 
255     (bool success, ) = parentAddress.call{ value: value }('');
256     require(success, 'Flush failed');
257     emit ForwarderDeposited(msg.sender, value, msg.data);
258   }
259 }
260 
261 contract ForwarderFactory is CloneFactory {
262   address public implementationAddress;
263 
264   event ForwarderCreated(address newForwarderAddress, address parentAddress);
265 
266   constructor(address _implementationAddress) {
267     implementationAddress = _implementationAddress;
268   }
269 
270   function createForwarder(address parent, bytes32 salt) external {
271     // include the signers in the salt so any contract deployed to a given address must have the same signers
272     bytes32 finalSalt = keccak256(abi.encodePacked(parent, salt));
273 
274     address payable clone = createClone(implementationAddress, finalSalt);
275     Forwarder(clone).init(parent);
276     emit ForwarderCreated(clone, parent);
277   }
278 }