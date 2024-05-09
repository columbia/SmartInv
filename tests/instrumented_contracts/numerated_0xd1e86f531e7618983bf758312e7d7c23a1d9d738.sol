1 pragma solidity 0.4.24;
2 
3 // File: contracts/TokenSaleInterface.sol
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
25 // File: contracts/cloneFactory/CloneFactory.sol
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
68 // File: contracts/lib/Ownable.sol
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78   event OwnershipRenounced(address indexed previousOwner);
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner, "only owner is able to call this function");
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to relinquish control of the contract.
102    * @notice Renouncing to ownership will leave the contract without an owner.
103    * It will not be possible to call the functions with the `onlyOwner`
104    * modifier anymore.
105    */
106   function renounceOwnership() public onlyOwner {
107     emit OwnershipRenounced(owner);
108     owner = address(0);
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address _newOwner) public onlyOwner {
116     _transferOwnership(_newOwner);
117   }
118 
119   /**
120    * @dev Transfers control of the contract to a newOwner.
121    * @param _newOwner The address to transfer ownership to.
122    */
123   function _transferOwnership(address _newOwner) internal {
124     require(_newOwner != address(0));
125     emit OwnershipTransferred(owner, _newOwner);
126     owner = _newOwner;
127   }
128 }
129 
130 // File: contracts/cloneFactory/TokenSaleCloneFactory.sol
131 
132 contract TokenSaleCloneFactory is Ownable, CloneFactory {
133     // TokenSale contract address for cloning purposes
134     address public libraryAddress;
135     address public starToken;
136 
137     mapping(address => bool) public isInstantiation;
138     mapping(address => address[]) public instantiations;
139 
140     event ContractInstantiation(address msgSender, address instantiation);
141 
142     //
143     /**
144     * @dev set TokenSale contract clone as well as starToken upon deployment
145     * @param _libraryAddress TokenSale contract address for cloning purposes
146     * @param _starToken Star contract address in the _libraryAddress deployment
147     */
148     constructor(address _libraryAddress, address _starToken) public {
149         require(
150             _libraryAddress != address(0) && _starToken != address(0),
151             "_libraryAddress and _starToken should not be empty!"
152         );
153         libraryAddress = _libraryAddress;
154         starToken = _starToken;
155     }
156 
157    /**
158     * @dev Have the option of updating the TokenSale contract for cloning.
159     * @param _libraryAddress Address for new contract
160     */
161     function setLibraryAddress(address _libraryAddress) external onlyOwner {
162         require(_libraryAddress != address(0), "_libraryAddress should not be empty!");
163         libraryAddress = _libraryAddress;
164     }
165 
166     /**
167      * @dev Returns number of instantiations by creator.
168      * @param creator Contract creator.
169      * @return Returns number of instantiations by creator.
170      */
171     function getInstantiationCount(address creator)
172         public
173         view
174         returns (uint256)
175     {
176         return instantiations[creator].length;
177     }
178 
179     /**
180      * @dev Allows verified creation of pools.
181      * @param _startTime The timestamp of the beginning of the crowdsale
182      * @param _endTime Timestamp when the crowdsale will finish
183      * @param _whitelist contract containing the whitelisted addresses
184      * @param _companyToken ERC20 CompanyToken contract address
185      * @param _rate The token rate per ETH
186      * @param _starRate The token rate per STAR
187      * @param _wallet Multisig wallet that will hold the crowdsale funds.
188      * @param _crowdsaleCap Cap for the token sale
189      * @param _isWeiAccepted Bool for acceptance of ether in token sale
190      */
191     function create
192     (
193         uint256 _startTime,
194         uint256 _endTime,
195         address _whitelist,
196         address _companyToken,
197         uint256 _rate,
198         uint256 _starRate,
199         address _wallet,
200         uint256 _crowdsaleCap,
201         bool    _isWeiAccepted
202     )
203         public
204     {
205         address tokenSale = createClone(libraryAddress);
206         TokenSaleInterface(tokenSale).init(
207             _startTime,
208             _endTime,
209             _whitelist,
210             starToken,
211             _companyToken,
212             _rate,
213             _starRate,
214             _wallet,
215             _crowdsaleCap,
216             _isWeiAccepted
217         );
218 
219         register(tokenSale);
220     }
221 
222     /**
223      * @dev Registers contract in factory registry.
224      * @param instantiation Address of contract instantiation.
225      */
226     function register(address instantiation)
227         internal
228     {
229         isInstantiation[instantiation] = true;
230         instantiations[msg.sender].push(instantiation);
231 
232         emit ContractInstantiation(msg.sender, instantiation);
233     }
234 }