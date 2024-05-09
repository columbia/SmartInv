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
28 // File: contracts/cloneFactory/CloneFactory.sol
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
71 contract TokenSaleCloneFactory is CloneFactory {
72     // TokenSale contract address for cloning purposes
73     address public libraryAddress;
74     address public starToken;
75 
76     mapping(address => bool) public isInstantiation;
77     mapping(address => address[]) public instantiations;
78 
79     event ContractInstantiation(address msgSender, address instantiation);
80 
81     //
82     /**
83     * @dev set TokenSale contract clone as well as starToken upon deployment
84     * @param _libraryAddress TokenSale contract address for cloning purposes
85     * @param _starToken Star contract address in the _libraryAddress deployment
86     */
87     constructor(address _libraryAddress, address _starToken) public {
88         require(
89             _libraryAddress != address(0) && _starToken != address(0),
90             "_libraryAddress and _starToken should not be empty!"
91         );
92         libraryAddress = _libraryAddress;
93         starToken = _starToken;
94     }
95 
96     /**
97      * @dev Returns number of instantiations by creator.
98      * @param creator Contract creator.
99      * @return Returns number of instantiations by creator.
100      */
101     function getInstantiationCount(address creator)
102         public
103         view
104         returns (uint256)
105     {
106         return instantiations[creator].length;
107     }
108 
109     /**
110      * @dev Allows verified creation of pools.
111      * @param _startTime The timestamp of the beginning of the crowdsale
112      * @param _endTime Timestamp when the crowdsale will finish
113      * @param _whitelist contract containing the whitelisted addresses
114      * @param _companyToken ERC20 CompanyToken contract address
115      * @param _tokenOwnerAfterSale Token on sale owner address after sale is finished
116      * @param _rate The token rate per ETH
117      * @param _starRate The token rate per STAR
118      * @param _wallet Multisig wallet that will hold the crowdsale funds.
119      * @param _softCap Soft cap of the token sale
120      * @param _crowdsaleCap Cap for the token sale
121      * @param _isWeiAccepted Bool for acceptance of ether in token sale
122      * @param _isMinting Bool for indication if new tokens are minted or existing ones are transferred
123      */
124     function create
125     (
126         uint256 _startTime,
127         uint256 _endTime,
128         address _whitelist,
129         address _companyToken,
130         address _tokenOwnerAfterSale,
131         uint256 _rate,
132         uint256 _starRate,
133         address _wallet,
134         uint256 _softCap,
135         uint256 _crowdsaleCap,
136         bool    _isWeiAccepted,
137         bool    _isMinting
138     )
139         public
140     {
141         address tokenSale = createClone(libraryAddress);
142         TokenSaleInterface(tokenSale).init(
143             _startTime,
144             _endTime,
145             _whitelist,
146             starToken,
147             _companyToken,
148             _tokenOwnerAfterSale,
149             _rate,
150             _starRate,
151             _wallet,
152             _softCap,
153             _crowdsaleCap,
154             _isWeiAccepted,
155             _isMinting
156         );
157 
158         register(tokenSale);
159     }
160 
161     /**
162      * @dev Registers contract in factory registry.
163      * @param instantiation Address of contract instantiation.
164      */
165     function register(address instantiation)
166         internal
167     {
168         isInstantiation[instantiation] = true;
169         instantiations[msg.sender].push(instantiation);
170 
171         emit ContractInstantiation(msg.sender, instantiation);
172     }
173 }