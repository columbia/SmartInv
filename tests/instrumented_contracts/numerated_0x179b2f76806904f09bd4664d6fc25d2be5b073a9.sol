1 pragma solidity 0.7.5;
2 
3 /**
4  * Contract that exposes the needed erc20 token functions
5  */
6 
7 abstract contract ERC20Interface {
8   // Send _value amount of tokens to address _to
9   function transfer(address _to, uint256 _value)
10     public
11     virtual
12     returns (bool success);
13 
14   // Get the account balance of another account with address _owner
15   function balanceOf(address _owner)
16     public
17     virtual
18     view
19     returns (uint256 balance);
20 }
21 
22 
23 /**
24  * Contract that will forward any incoming Ether to the creator of the contract
25  *
26  */
27 contract Forwarder {
28   // Address to which any funds sent to this contract will be forwarded
29   address public parentAddress;
30   event ForwarderDeposited(address from, uint256 value, bytes data);
31 
32   /**
33    * Initialize the contract, and sets the destination address to that of the creator
34    */
35   function init(address _parentAddress) external onlyUninitialized {
36     parentAddress = _parentAddress;
37     uint256 value = address(this).balance;
38 
39     if (value == 0) {
40       return;
41     }
42 
43     (bool success, ) = parentAddress.call{ value: value }("");
44     require(success, "Flush failed");
45     // NOTE: since we are forwarding on initialization, 
46     // we don't have the context of the original sender. 
47     // We still emit an event about the forwarding but set
48     // the sender to the forwarder itself
49     emit ForwarderDeposited(address(this), value, msg.data);
50   }
51 
52   /**
53    * Modifier that will execute internal code block only if the sender is the parent address
54    */
55   modifier onlyParent {
56     require(msg.sender == parentAddress, "Only Parent");
57     _;
58   }
59 
60   /**
61    * Modifier that will execute internal code block only if the contract has not been initialized yet
62    */
63   modifier onlyUninitialized {
64     require(parentAddress == address(0x0), "Already initialized");
65     _;
66   }
67 
68   /**
69    * Default function; Gets called when data is sent but does not match any other function
70    */
71   fallback() external payable {
72     flush();
73   }
74 
75   /**
76    * Default function; Gets called when Ether is deposited with no data, and forwards it to the parent address
77    */
78   receive() external payable {
79     flush();
80   }
81 
82   /**
83    * Execute a token transfer of the full balance from the forwarder token to the parent address
84    * @param tokenContractAddress the address of the erc20 token contract
85    */
86   function flushTokens(address tokenContractAddress) external onlyParent {
87     ERC20Interface instance = ERC20Interface(tokenContractAddress);
88     address forwarderAddress = address(this);
89     uint256 forwarderBalance = instance.balanceOf(forwarderAddress);
90     if (forwarderBalance == 0) {
91       return;
92     }
93 
94     require(
95       instance.transfer(parentAddress, forwarderBalance),
96       "Token flush failed"
97     );
98   }
99 
100   /**
101    * Flush the entire balance of the contract to the parent address.
102    */
103   function flush() public {
104     uint256 value = address(this).balance;
105 
106     if (value == 0) {
107       return;
108     }
109 
110     (bool success, ) = parentAddress.call{ value: value }("");
111     require(success, "Flush failed");
112     emit ForwarderDeposited(msg.sender, value, msg.data);
113   }
114 }
115 
116 /*
117     The MIT License (MIT)
118     Copyright (c) 2018 Murray Software, LLC.
119     Permission is hereby granted, free of charge, to any person obtaining
120     a copy of this software and associated documentation files (the
121     "Software"), to deal in the Software without restriction, including
122     without limitation the rights to use, copy, modify, merge, publish,
123     distribute, sublicense, and/or sell copies of the Software, and to
124     permit persons to whom the Software is furnished to do so, subject to
125     the following conditions:
126     The above copyright notice and this permission notice shall be included
127     in all copies or substantial portions of the Software.
128     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
129     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
130     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
131     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
132     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
133     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
134     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
135 */
136 //solhint-disable max-line-length
137 //solhint-disable no-inline-assembly
138 
139 contract CloneFactory {
140   function createClone(address target, bytes32 salt)
141     internal
142     returns (address payable result)
143   {
144     bytes20 targetBytes = bytes20(target);
145     assembly {
146       // load the next free memory slot as a place to store the clone contract data
147       let clone := mload(0x40)
148 
149       // The bytecode block below is responsible for contract initialization
150       // during deployment, it is worth noting the proxied contract constructor will not be called during
151       // the cloning procedure and that is why an initialization function needs to be called after the
152       // clone is created
153       mstore(
154         clone,
155         0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
156       )
157 
158       // This stores the address location of the implementation contract
159       // so that the proxy knows where to delegate call logic to
160       mstore(add(clone, 0x14), targetBytes)
161 
162       // The bytecode block is the actual code that is deployed for each clone created.
163       // It forwards all calls to the already deployed implementation via a delegatecall
164       mstore(
165         add(clone, 0x28),
166         0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
167       )
168 
169       // deploy the contract using the CREATE2 opcode
170       // this deploys the minimal proxy defined above, which will proxy all
171       // calls to use the logic defined in the implementation contract `target`
172       result := create2(0, clone, 0x37, salt)
173     }
174   }
175 
176   function isClone(address target, address query)
177     internal
178     view
179     returns (bool result)
180   {
181     bytes20 targetBytes = bytes20(target);
182     assembly {
183       // load the next free memory slot as a place to store the comparison clone
184       let clone := mload(0x40)
185 
186       // The next three lines store the expected bytecode for a miniml proxy
187       // that targets `target` as its implementation contract
188       mstore(
189         clone,
190         0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000
191       )
192       mstore(add(clone, 0xa), targetBytes)
193       mstore(
194         add(clone, 0x1e),
195         0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
196       )
197 
198       // the next two lines store the bytecode of the contract that we are checking in memory
199       let other := add(clone, 0x40)
200       extcodecopy(query, other, 0, 0x2d)
201 
202       // Check if the expected bytecode equals the actual bytecode and return the result
203       result := and(
204         eq(mload(clone), mload(other)),
205         eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
206       )
207     }
208   }
209 }
210 
211 contract ForwarderFactory is CloneFactory {
212   address public implementationAddress;
213 
214   event ForwarderCreated(address newForwarderAddress, address parentAddress);
215 
216   constructor(address _implementationAddress) {
217     implementationAddress = _implementationAddress;
218   }
219 
220   function createForwarder(address parent, bytes32 salt) external {
221     // include the signers in the salt so any contract deployed to a given address must have the same signers
222     bytes32 finalSalt = keccak256(abi.encodePacked(parent, salt));
223 
224     address payable clone = createClone(implementationAddress, finalSalt);
225     Forwarder(clone).init(parent);
226     emit ForwarderCreated(clone, parent);
227   }
228 }