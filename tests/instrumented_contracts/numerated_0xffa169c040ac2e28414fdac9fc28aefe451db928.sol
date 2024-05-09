1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   function decimals() public view returns (uint256);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 library ERC20SafeTransfer {
39     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
40 
41         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
42 
43         return fetchReturnData();
44     }
45 
46     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
47 
48         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
49 
50         return fetchReturnData();
51     }
52 
53     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
54 
55         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
56 
57         return fetchReturnData();
58     }
59 
60     function fetchReturnData() internal returns (bool success){
61         assembly {
62             switch returndatasize()
63             case 0 {
64                 success := 1
65             }
66             case 32 {
67                 returndatacopy(0, 0, 32)
68                 success := mload(0)
69             }
70             default {
71                 revert(0, 0)
72             }
73         }
74     }
75 
76 }
77 
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85 
86   event OwnershipRenounced(address indexed previousOwner);
87   event OwnershipTransferred(
88     address indexed previousOwner,
89     address indexed newOwner
90   );
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   constructor() public {
97     owner = msg.sender;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to relinquish control of the contract.
110    * @notice Renouncing to ownership will leave the contract without an owner.
111    * It will not be possible to call the functions with the `onlyOwner`
112    * modifier anymore.
113    */
114   function renounceOwnership() public onlyOwner {
115     emit OwnershipRenounced(owner);
116     owner = address(0);
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param _newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address _newOwner) public onlyOwner {
124     _transferOwnership(_newOwner);
125   }
126 
127   /**
128    * @dev Transfers control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function _transferOwnership(address _newOwner) internal {
132     require(_newOwner != address(0));
133     emit OwnershipTransferred(owner, _newOwner);
134     owner = _newOwner;
135   }
136 }
137 
138 /*
139 
140   Copyright 2018 ZeroEx Intl.
141 
142   Licensed under the Apache License, Version 2.0 (the "License");
143   you may not use this file except in compliance with the License.
144   You may obtain a copy of the License at
145 
146     http://www.apache.org/licenses/LICENSE-2.0
147 
148   Unless required by applicable law or agreed to in writing, software
149   distributed under the License is distributed on an "AS IS" BASIS,
150   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
151   See the License for the specific language governing permissions and
152   limitations under the License.
153 
154 */
155 
156 pragma solidity 0.4.25;
157 
158 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
159 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
160 contract TokenTransferProxy is Ownable {
161 
162     /// @dev Only authorized addresses can invoke functions with this modifier.
163     modifier onlyAuthorized {
164         require(authorized[msg.sender]);
165         _;
166     }
167 
168     modifier targetAuthorized(address target) {
169         require(authorized[target]);
170         _;
171     }
172 
173     modifier targetNotAuthorized(address target) {
174         require(!authorized[target]);
175         _;
176     }
177 
178     mapping (address => bool) public authorized;
179     address[] public authorities;
180 
181     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
182     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
183 
184     /*
185      * Public functions
186      */
187 
188     /// @dev Authorizes an address.
189     /// @param target Address to authorize.
190     function addAuthorizedAddress(address target)
191         public
192         onlyOwner
193         targetNotAuthorized(target)
194     {
195         authorized[target] = true;
196         authorities.push(target);
197         emit LogAuthorizedAddressAdded(target, msg.sender);
198     }
199 
200     /// @dev Removes authorizion of an address.
201     /// @param target Address to remove authorization from.
202     function removeAuthorizedAddress(address target)
203         public
204         onlyOwner
205         targetAuthorized(target)
206     {
207         delete authorized[target];
208         for (uint i = 0; i < authorities.length; i++) {
209             if (authorities[i] == target) {
210                 authorities[i] = authorities[authorities.length - 1];
211                 authorities.length -= 1;
212                 break;
213             }
214         }
215         emit LogAuthorizedAddressRemoved(target, msg.sender);
216     }
217 
218     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
219     /// @param token Address of token to transfer.
220     /// @param from Address to transfer token from.
221     /// @param to Address to transfer token to.
222     /// @param value Amount of token to transfer.
223     /// @return Success of transfer.
224     function transferFrom(
225         address token,
226         address from,
227         address to,
228         uint value)
229         public
230         onlyAuthorized
231         returns (bool)
232     {
233         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
234     }
235 
236     /*
237      * Public constant functions
238      */
239 
240     /// @dev Gets all authorized addresses.
241     /// @return Array of authorized addresses.
242     function getAuthorizedAddresses()
243         public
244         view
245         returns (address[])
246     {
247         return authorities;
248     }
249 }