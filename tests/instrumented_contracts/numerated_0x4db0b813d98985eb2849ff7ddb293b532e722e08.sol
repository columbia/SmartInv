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
16         address _tokenOwnerAfterSale,
17         uint256 _rate,
18         uint256 _starRate,
19         address _wallet,
20         uint256 _softCap,
21         uint256 _crowdsaleCap,
22         bool    _isWeiAccepted,
23         bool    _isMinting
24     )
25     external;
26 }
27 
28 // File: contracts\cloneFactory\CloneFactory.sol
29 
30 /*
31 The MIT License (MIT)
32 Copyright (c) 2018 Murray Software, LLC.
33 Permission is hereby granted, free of charge, to any person obtaining
34 a copy of this software and associated documentation files (the
35 "Software"), to deal in the Software without restriction, including
36 without limitation the rights to use, copy, modify, merge, publish,
37 distribute, sublicense, and/or sell copies of the Software, and to
38 permit persons to whom the Software is furnished to do so, subject to
39 the following conditions:
40 The above copyright notice and this permission notice shall be included
41 in all copies or substantial portions of the Software.
42 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
43 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
44 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
45 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
46 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
47 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
48 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
49 */
50 //solhint-disable max-line-length
51 //solhint-disable no-inline-assembly
52 
53 contract CloneFactory {
54 
55   event CloneCreated(address indexed target, address clone);
56 
57   function createClone(address target) internal returns (address result) {
58     bytes memory clone = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";
59     bytes20 targetBytes = bytes20(target);
60     for (uint i = 0; i < 20; i++) {
61       clone[20 + i] = targetBytes[i];
62     }
63     assembly {
64       let len := mload(clone)
65       let data := add(clone, 0x20)
66       result := create(0, data, len)
67     }
68   }
69 }
70 
71 // File: contracts\cloneFactory\TokenSaleCloneFactory.sol
72 
73 contract TokenSaleCloneFactory is CloneFactory {
74     // TokenSale contract address for cloning purposes
75     address public libraryAddress;
76     address public starToken;
77 
78     mapping(address => bool) public isInstantiation;
79     mapping(address => address[]) public instantiations;
80 
81     event ContractInstantiation(address msgSender, address instantiation);
82 
83     //
84     /**
85     * @dev set TokenSale contract clone as well as starToken upon deployment
86     * @param _libraryAddress TokenSale contract address for cloning purposes
87     * @param _starToken Star contract address in the _libraryAddress deployment
88     */
89     constructor(address _libraryAddress, address _starToken) public {
90         require(
91             _libraryAddress != address(0) && _starToken != address(0),
92             "_libraryAddress and _starToken should not be empty!"
93         );
94         libraryAddress = _libraryAddress;
95         starToken = _starToken;
96     }
97 
98     /**
99      * @dev Returns number of instantiations by creator.
100      * @param creator Contract creator.
101      * @return Returns number of instantiations by creator.
102      */
103     function getInstantiationCount(address creator)
104         public
105         view
106         returns (uint256)
107     {
108         return instantiations[creator].length;
109     }
110 
111     /**
112      * @dev Allows verified creation of pools.
113      * @param _startTime The timestamp of the beginning of the crowdsale
114      * @param _endTime Timestamp when the crowdsale will finish
115      * @param _whitelist contract containing the whitelisted addresses
116      * @param _companyToken ERC20 CompanyToken contract address
117      * @param _tokenOwnerAfterSale Token on sale owner address after sale is finished
118      * @param _rate The token rate per ETH
119      * @param _starRate The token rate per STAR
120      * @param _wallet Multisig wallet that will hold the crowdsale funds.
121      * @param _softCap Soft cap of the token sale
122      * @param _crowdsaleCap Cap for the token sale
123      * @param _isWeiAccepted Bool for acceptance of ether in token sale
124      * @param _isMinting Bool for indication if new tokens are minted or existing ones are transferred
125      */
126     function create
127     (
128         uint256 _startTime,
129         uint256 _endTime,
130         address _whitelist,
131         address _companyToken,
132         address _tokenOwnerAfterSale,
133         uint256 _rate,
134         uint256 _starRate,
135         address _wallet,
136         uint256 _softCap,
137         uint256 _crowdsaleCap,
138         bool    _isWeiAccepted,
139         bool    _isMinting
140     )
141         public
142     {
143         address tokenSale = createClone(libraryAddress);
144         TokenSaleInterface(tokenSale).init(
145             _startTime,
146             _endTime,
147             _whitelist,
148             starToken,
149             _companyToken,
150             _tokenOwnerAfterSale,
151             _rate,
152             _starRate,
153             _wallet,
154             _softCap,
155             _crowdsaleCap,
156             _isWeiAccepted,
157             _isMinting
158         );
159 
160         register(tokenSale);
161     }
162 
163     /**
164      * @dev Registers contract in factory registry.
165      * @param instantiation Address of contract instantiation.
166      */
167     function register(address instantiation)
168         internal
169     {
170         isInstantiation[instantiation] = true;
171         instantiations[msg.sender].push(instantiation);
172 
173         emit ContractInstantiation(msg.sender, instantiation);
174     }
175 }