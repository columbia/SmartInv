1 /**
2  * FreezeRule.sol
3  * Rule to restrict individual addresses from sending or receiving MPS tokens.
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
9 
10  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
11 
12  * @notice All matters regarding the intellectual property of this code 
13  * @notice or software are subject to Swiss Law without reference to its 
14  * @notice conflicts of law rules.
15 
16  * @notice License for each contract is available in the respective file
17  * @notice or in the LICENSE.md file.
18  * @notice https://github.com/MtPelerin/
19 
20  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
21  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
22  */
23 
24 pragma solidity ^0.4.24;
25 
26 // File: contracts/zeppelin/ownership/Ownable.sol
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipRenounced(address indexed previousOwner);
38   event OwnershipTransferred(
39     address indexed previousOwner,
40     address indexed newOwner
41   );
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(owner);
65     owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 
87 // File: contracts/Authority.sol
88 
89 /**
90  * @title Authority
91  * @dev The Authority contract has an authority address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  * Authority means to represent a legal entity that is entitled to specific rights
94  *
95  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
96  *
97  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
98  * @notice Please refer to the top of this file for the license.
99  *
100  * Error messages
101  * AU01: Message sender must be an authority
102  */
103 contract Authority is Ownable {
104 
105   address authority;
106 
107   /**
108    * @dev Throws if called by any account other than the authority.
109    */
110   modifier onlyAuthority {
111     require(msg.sender == authority, "AU01");
112     _;
113   }
114 
115   /**
116    * @dev return the address associated to the authority
117    */
118   function authorityAddress() public view returns (address) {
119     return authority;
120   }
121 
122   /**
123    * @dev rdefines an authority
124    * @param _name the authority name
125    * @param _address the authority address.
126    */
127   function defineAuthority(string _name, address _address) public onlyOwner {
128     emit AuthorityDefined(_name, _address);
129     authority = _address;
130   }
131 
132   event AuthorityDefined(
133     string name,
134     address _address
135   );
136 }
137 
138 // File: contracts/interface/IRule.sol
139 
140 /**
141  * @title IRule
142  * @dev IRule interface
143  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
144  *
145  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
146  * @notice Please refer to the top of this file for the license.
147  **/
148 interface IRule {
149   function isAddressValid(address _address) external view returns (bool);
150   function isTransferValid(address _from, address _to, uint256 _amount)
151     external view returns (bool);
152 }
153 
154 // File: contracts/rule/FreezeRule.sol
155 
156 /**
157  * @title FreezeRule
158  * @dev FreezeRule contract
159  * This rule allow a legal authority to enforce a freeze of assets.
160  *
161  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
162  *
163  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
164  * @notice Please refer to the top of this file for the license.
165  *
166  * Error messages
167  * E01: The address is frozen
168  */
169 contract FreezeRule is IRule, Authority {
170 
171   mapping(address => uint256) freezer;
172   uint256 allFreezedUntil;
173 
174   /**
175    * @dev is rule frozen
176    */
177   function isFrozen() public view returns (bool) {
178     // solium-disable-next-line security/no-block-members
179     return allFreezedUntil > now ;
180   }
181 
182   /**
183    * @dev is address frozen
184    */
185   function isAddressFrozen(address _address) public view returns (bool) {
186     // solium-disable-next-line security/no-block-members
187     return freezer[_address] > now;
188   }
189 
190   /**
191    * @dev allow authority to freeze the address
192    * @param _until allows to auto unlock if the frozen time is known initially.
193    * otherwise infinity can be used
194    */
195   function freezeAddress(address _address, uint256 _until)
196     public onlyAuthority returns (bool)
197   {
198     freezer[_address] = _until;
199     emit Freeze(_address, _until);
200   }
201 
202   /**
203    * @dev allow authority to freeze several addresses
204    * @param _until allows to auto unlock if the frozen time is known initially.
205    * otherwise infinity can be used
206    */
207   function freezeManyAddresses(address[] _addresses, uint256 _until)
208     public onlyAuthority returns (bool)
209   {
210     for (uint256 i = 0; i < _addresses.length; i++) {
211       freezer[_addresses[i]] = _until;
212       emit Freeze(_addresses[i], _until);
213     }
214   }
215 
216   /**
217    * @dev freeze all until
218    */
219   function freezeAll(uint256 _until) public
220     onlyAuthority returns (bool)
221   {
222     allFreezedUntil = _until;
223     emit FreezeAll(_until);
224   }
225 
226   /**
227    * @dev validates an address
228    */
229   function isAddressValid(address _address) public view returns (bool) {
230     return !isFrozen() && !isAddressFrozen(_address);
231   }
232 
233    /**
234    * @dev validates a transfer 
235    */
236   function isTransferValid(address _from, address _to, uint256 /* _amount */)
237     public view returns (bool)
238   {
239     return !isFrozen() && (!isAddressFrozen(_from) && !isAddressFrozen(_to));
240   }
241 
242   event FreezeAll(uint256 until);
243   event Freeze(address _address, uint256 until);
244 }