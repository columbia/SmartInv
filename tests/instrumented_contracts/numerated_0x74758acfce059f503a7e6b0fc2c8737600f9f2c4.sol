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
37 library ERC20SafeTransfer {
38     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
39 
40         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
41 
42         return fetchReturnData();
43     }
44 
45     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
46 
47         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
48 
49         return fetchReturnData();
50     }
51 
52     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
53 
54         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
55 
56         return fetchReturnData();
57     }
58 
59     function fetchReturnData() internal returns (bool success){
60         assembly {
61             switch returndatasize()
62             case 0 {
63                 success := 1
64             }
65             case 32 {
66                 returndatacopy(0, 0, 32)
67                 success := mload(0)
68             }
69             default {
70                 revert(0, 0)
71             }
72         }
73     }
74 
75 }
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83   address public owner;
84 
85   event OwnershipRenounced(address indexed previousOwner);
86   event OwnershipTransferred(
87     address indexed previousOwner,
88     address indexed newOwner
89   );
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   constructor() public {
96     owner = msg.sender;
97   }
98 
99   /**
100    * @dev Throws if called by any account other than the owner.
101    */
102   modifier onlyOwner() {
103     require(msg.sender == owner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to relinquish control of the contract.
109    * @notice Renouncing to ownership will leave the contract without an owner.
110    * It will not be possible to call the functions with the `onlyOwner`
111    * modifier anymore.
112    */
113   function renounceOwnership() public onlyOwner {
114     emit OwnershipRenounced(owner);
115     owner = address(0);
116   }
117 
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address _newOwner) public onlyOwner {
123     _transferOwnership(_newOwner);
124   }
125 
126   /**
127    * @dev Transfers control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function _transferOwnership(address _newOwner) internal {
131     require(_newOwner != address(0));
132     emit OwnershipTransferred(owner, _newOwner);
133     owner = _newOwner;
134   }
135 }
136 
137 /*
138 
139   Copyright 2018 ZeroEx Intl.
140 
141   Licensed under the Apache License, Version 2.0 (the "License");
142   you may not use this file except in compliance with the License.
143   You may obtain a copy of the License at
144 
145     http://www.apache.org/licenses/LICENSE-2.0
146 
147   Unless required by applicable law or agreed to in writing, software
148   distributed under the License is distributed on an "AS IS" BASIS,
149   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
150   See the License for the specific language governing permissions and
151   limitations under the License.
152 
153 */
154 
155 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
156 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
157 contract TokenTransferProxy is Ownable {
158 
159     /// @dev Only authorized addresses can invoke functions with this modifier.
160     modifier onlyAuthorized {
161         require(authorized[msg.sender]);
162         _;
163     }
164 
165     modifier targetAuthorized(address target) {
166         require(authorized[target]);
167         _;
168     }
169 
170     modifier targetNotAuthorized(address target) {
171         require(!authorized[target]);
172         _;
173     }
174 
175     mapping (address => bool) public authorized;
176     address[] public authorities;
177 
178     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
179     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
180 
181     /*
182      * Public functions
183      */
184 
185     /// @dev Authorizes an address.
186     /// @param target Address to authorize.
187     function addAuthorizedAddress(address target)
188         public
189         onlyOwner
190         targetNotAuthorized(target)
191     {
192         authorized[target] = true;
193         authorities.push(target);
194         emit LogAuthorizedAddressAdded(target, msg.sender);
195     }
196 
197     /// @dev Removes authorizion of an address.
198     /// @param target Address to remove authorization from.
199     function removeAuthorizedAddress(address target)
200         public
201         onlyOwner
202         targetAuthorized(target)
203     {
204         delete authorized[target];
205         for (uint i = 0; i < authorities.length; i++) {
206             if (authorities[i] == target) {
207                 authorities[i] = authorities[authorities.length - 1];
208                 authorities.length -= 1;
209                 break;
210             }
211         }
212         emit LogAuthorizedAddressRemoved(target, msg.sender);
213     }
214 
215     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
216     /// @param token Address of token to transfer.
217     /// @param from Address to transfer token from.
218     /// @param to Address to transfer token to.
219     /// @param value Amount of token to transfer.
220     /// @return Success of transfer.
221     function transferFrom(
222         address token,
223         address from,
224         address to,
225         uint value)
226         public
227         onlyAuthorized
228         returns (bool)
229     {
230         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
231         return true;
232     }
233 
234     /*
235      * Public constant functions
236      */
237 
238     /// @dev Gets all authorized addresses.
239     /// @return Array of authorized addresses.
240     function getAuthorizedAddresses()
241         public
242         view
243         returns (address[])
244     {
245         return authorities;
246     }
247 }