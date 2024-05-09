1 /*
2 
3     Copyright 2018 The Hydro Protocol Foundation
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 /// @dev Math operations with safety checks that revert on error
22 library SafeMath {
23 
24     /// @dev Multiplies two numbers, reverts on overflow.
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "MUL_ERROR");
32 
33         return c;
34     }
35 
36     /// @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b > 0, "DIVIDING_ERROR");
39         uint256 c = a / b;
40         return c;
41     }
42 
43     /// @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SUB_ERROR");
46         uint256 c = a - b;
47         return c;
48     }
49 
50     /// @dev Adds two numbers, reverts on overflow.
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "ADD_ERROR");
54         return c;
55     }
56 
57     /// @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0, "MOD_ERROR");
60         return a % b;
61     }
62 }
63 
64 /// @title Ownable
65 /// @dev The Ownable contract has an owner address, and provides basic authorization control
66 /// functions, this simplifies the implementation of "user permissions".
67 contract LibOwnable {
68     address private _owner;
69 
70     event OwnershipTransferred(
71         address indexed previousOwner,
72         address indexed newOwner
73     );
74 
75     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
76     constructor() internal {
77         _owner = msg.sender;
78         emit OwnershipTransferred(address(0), _owner);
79     }
80 
81     /// @return the address of the owner.
82     function owner() public view returns(address) {
83         return _owner;
84     }
85 
86     /// @dev Throws if called by any account other than the owner.
87     modifier onlyOwner() {
88         require(isOwner(), "NOT_OWNER");
89         _;
90     }
91 
92     /// @return true if `msg.sender` is the owner of the contract.
93     function isOwner() public view returns(bool) {
94         return msg.sender == _owner;
95     }
96 
97     /// @dev Allows the current owner to relinquish control of the contract.
98     /// @notice Renouncing to ownership will leave the contract without an owner.
99     /// It will not be possible to call the functions with the `onlyOwner`
100     /// modifier anymore.
101     function renounceOwnership() public onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
107     /// @param newOwner The address to transfer ownership to.
108     function transferOwnership(address newOwner) public onlyOwner {
109         require(newOwner != address(0), "INVALID_OWNER");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 contract LibWhitelist is LibOwnable {
116     mapping (address => bool) public whitelist;
117     address[] public allAddresses;
118 
119     event AddressAdded(address indexed adr);
120     event AddressRemoved(address indexed adr);
121 
122     /// @dev Only address in whitelist can invoke functions with this modifier.
123     modifier onlyAddressInWhitelist {
124         require(whitelist[msg.sender], "SENDER_NOT_IN_WHITELIST_ERROR");
125         _;
126     }
127 
128     /// @dev add Address into whitelist
129     /// @param adr Address to add
130     function addAddress(address adr) external onlyOwner {
131         emit AddressAdded(adr);
132         whitelist[adr] = true;
133         allAddresses.push(adr);
134     }
135 
136     /// @dev remove Address from whitelist
137     /// @param adr Address to remove
138     function removeAddress(address adr) external onlyOwner {
139         emit AddressRemoved(adr);
140         delete whitelist[adr];
141         for(uint i = 0; i < allAddresses.length; i++){
142             if(allAddresses[i] == adr) {
143                 allAddresses[i] = allAddresses[allAddresses.length - 1];
144                 allAddresses.length -= 1;
145                 break;
146             }
147         }
148     }
149 
150     /// @dev Get all addresses in whitelist
151     function getAllAddresses() external view returns (address[] memory) {
152         return allAddresses;
153     }
154 }
155 
156 contract Proxy is LibWhitelist {
157     using SafeMath for uint256;
158 
159     mapping( address => uint256 ) public balances;
160 
161     event Deposit(address owner, uint256 amount);
162     event Withdraw(address owner, uint256 amount);
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     function depositEther() public payable {
166         balances[msg.sender] = balances[msg.sender].add(msg.value);
167         emit Deposit(msg.sender, msg.value);
168     }
169 
170     function withdrawEther(uint256 amount) public {
171         balances[msg.sender] = balances[msg.sender].sub(amount);
172         msg.sender.transfer(amount);
173         emit Withdraw(msg.sender, amount);
174     }
175 
176     function () public payable {
177         depositEther();
178     }
179 
180     /// @dev Invoking transferFrom.
181     /// @param token Address of token to transfer.
182     /// @param from Address to transfer token from.
183     /// @param to Address to transfer token to.
184     /// @param value Amount of token to transfer.
185     function transferFrom(address token, address from, address to, uint256 value)
186         external
187         onlyAddressInWhitelist
188     {
189         if (token == address(0)) {
190             transferEther(from, to, value);
191         } else {
192             transferToken(token, from, to, value);
193         }
194     }
195 
196     function transferEther(address from, address to, uint256 value)
197         internal
198         onlyAddressInWhitelist
199     {
200         balances[from] = balances[from].sub(value);
201         balances[to] = balances[to].add(value);
202 
203         emit Transfer(from, to, value);
204     }
205 
206     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
207     /// @param token Address of token to transfer.
208     /// @param from Address to transfer token from.
209     /// @param to Address to transfer token to.
210     /// @param value Amount of token to transfer.
211     function transferToken(address token, address from, address to, uint256 value)
212         internal
213         onlyAddressInWhitelist
214     {
215         assembly {
216 
217             // keccak256('transferFrom(address,address,uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
218             mstore(0, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
219 
220             // calldatacopy(t, f, s) copy s bytes from calldata at position f to mem at position t
221             // copy from, to, value from calldata to memory
222             calldatacopy(4, 36, 96)
223 
224             // call ERC20 Token contract transferFrom function
225             let result := call(gas, token, 0, 0, 100, 0, 32)
226 
227             // Some ERC20 Token contract doesn't return any value when calling the transferFrom function successfully.
228             // So we consider the transferFrom call is successful in either case below.
229             //   1. call successfully and nothing return.
230             //   2. call successfully, return value is 32 bytes long and the value isn't equal to zero.
231             switch eq(result, 1)
232             case 1 {
233                 switch or(eq(returndatasize, 0), and(eq(returndatasize, 32), gt(mload(0), 0)))
234                 case 1 {
235                     return(0, 0)
236                 }
237             }
238         }
239 
240         revert("TOKEN_TRANSFER_FROM_ERROR");
241     }
242 }