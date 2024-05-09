1 pragma solidity 0.4.24;
2 
3 // File: contracts\TokenSaleInterface.sol
4 
5 /**
6  * @title TokenSale contract interface
7  */
8 interface TokenSaleInterface {
9     function init
10     (
11         uint256 _startTime,
12         uint256 _endTime,
13         address _whitelist,
14         address _starToken,
15         address _companyToken,
16         uint256 _rate,
17         uint256 _starRate,
18         address _wallet,
19         uint256 _crowdsaleCap,
20         bool    _isWeiAccepted
21     )
22     external;
23 }
24 
25 // File: contracts\cloneFactory\CloneFactory.sol
26 
27 /*
28 The MIT License (MIT)
29 Copyright (c) 2018 Murray Software, LLC.
30 Permission is hereby granted, free of charge, to any person obtaining
31 a copy of this software and associated documentation files (the
32 "Software"), to deal in the Software without restriction, including
33 without limitation the rights to use, copy, modify, merge, publish,
34 distribute, sublicense, and/or sell copies of the Software, and to
35 permit persons to whom the Software is furnished to do so, subject to
36 the following conditions:
37 The above copyright notice and this permission notice shall be included
38 in all copies or substantial portions of the Software.
39 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
40 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
41 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
42 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
43 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
44 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
45 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
46 */
47 //solhint-disable max-line-length
48 //solhint-disable no-inline-assembly
49 
50 contract CloneFactory {
51 
52   event CloneCreated(address indexed target, address clone);
53 
54   function createClone(address target) internal returns (address result) {
55     bytes memory clone = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";
56     bytes20 targetBytes = bytes20(target);
57     for (uint i = 0; i < 20; i++) {
58       clone[20 + i] = targetBytes[i];
59     }
60     assembly {
61       let len := mload(clone)
62       let data := add(clone, 0x20)
63       result := create(0, data, len)
64     }
65   }
66 }
67 
68 // File: contracts\lib\Ownable.sol
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address public _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82      * account.
83      */
84     constructor () internal {
85         _owner = msg.sender;
86         emit OwnershipTransferred(address(0), _owner);
87     }
88 
89     /**
90      * @return the address of the owner.
91      */
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(isOwner());
101         _;
102     }
103 
104     /**
105      * @return true if `msg.sender` is the owner of the contract.
106      */
107     function isOwner() public view returns (bool) {
108         return msg.sender == _owner;
109     }
110 
111     /**
112      * @dev Allows the current owner to relinquish control of the contract.
113      * @notice Renouncing to ownership will leave the contract without an owner.
114      * It will not be possible to call the functions with the `onlyOwner`
115      * modifier anymore.
116      */
117     function renounceOwnership() public onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122     /**
123      * @dev Allows the current owner to transfer control of the contract to a newOwner.
124      * @param newOwner The address to transfer ownership to.
125      */
126     function transferOwnership(address newOwner) public onlyOwner {
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers control of the contract to a newOwner.
132      * @param newOwner The address to transfer ownership to.
133      */
134     function _transferOwnership(address newOwner) internal {
135         require(newOwner != address(0));
136         emit OwnershipTransferred(_owner, newOwner);
137         _owner = newOwner;
138     }
139 }
140 
141 // File: contracts\cloneFactory\TokenSaleCloneFactory.sol
142 
143 contract TokenSaleCloneFactory is Ownable, CloneFactory {
144     // TokenSale contract address for cloning purposes
145     address public libraryAddress;
146     address public starToken;
147 
148     mapping(address => bool) public isInstantiation;
149     mapping(address => address[]) public instantiations;
150 
151     event ContractInstantiation(address msgSender, address instantiation);
152 
153     //
154     /**
155     * @dev set TokenSale contract clone as well as starToken upon deployment
156     * @param _libraryAddress TokenSale contract address for cloning purposes
157     * @param _starToken Star contract address in the _libraryAddress deployment
158     */
159     constructor(address _libraryAddress, address _starToken) public {
160         require(
161             _libraryAddress != address(0) && _starToken != address(0),
162             "_libraryAddress and _starToken should not be empty!"
163         );
164         libraryAddress = _libraryAddress;
165         starToken = _starToken;
166     }
167 
168    /**
169     * @dev Have the option of updating the TokenSale contract for cloning.
170     * @param _libraryAddress Address for new contract
171     */
172     function setLibraryAddress(address _libraryAddress) external onlyOwner {
173         require(_libraryAddress != address(0), "_libraryAddress should not be empty!");
174         libraryAddress = _libraryAddress;
175     }
176 
177     /**
178      * @dev Returns number of instantiations by creator.
179      * @param creator Contract creator.
180      * @return Returns number of instantiations by creator.
181      */
182     function getInstantiationCount(address creator)
183         public
184         view
185         returns (uint256)
186     {
187         return instantiations[creator].length;
188     }
189 
190     /**
191      * @dev Allows verified creation of pools.
192      * @param _startTime The timestamp of the beginning of the crowdsale
193      * @param _endTime Timestamp when the crowdsale will finish
194      * @param _whitelist contract containing the whitelisted addresses
195      * @param _companyToken ERC20 CompanyToken contract address
196      * @param _rate The token rate per ETH
197      * @param _starRate The token rate per STAR
198      * @param _wallet Multisig wallet that will hold the crowdsale funds.
199      * @param _crowdsaleCap Cap for the token sale
200      * @param _isWeiAccepted Bool for acceptance of ether in token sale
201      */
202     function create
203     (
204         uint256 _startTime,
205         uint256 _endTime,
206         address _whitelist,
207         address _companyToken,
208         uint256 _rate,
209         uint256 _starRate,
210         address _wallet,
211         uint256 _crowdsaleCap,
212         bool    _isWeiAccepted
213     )
214         public
215     {
216         address tokenSale = createClone(libraryAddress);
217         TokenSaleInterface(tokenSale).init(
218             _startTime,
219             _endTime,
220             _whitelist,
221             starToken,
222             _companyToken,
223             _rate,
224             _starRate,
225             _wallet,
226             _crowdsaleCap,
227             _isWeiAccepted
228         );
229 
230         register(tokenSale);
231     }
232 
233     /**
234      * @dev Registers contract in factory registry.
235      * @param instantiation Address of contract instantiation.
236      */
237     function register(address instantiation)
238         internal
239     {
240         isInstantiation[instantiation] = true;
241         instantiations[msg.sender].push(instantiation);
242 
243         emit ContractInstantiation(msg.sender, instantiation);
244     }
245 }