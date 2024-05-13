1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {Ownable} from "./lib/Ownable.sol";
12 import {IDODO} from "./intf/IDODO.sol";
13 import {ICloneFactory} from "./helper/CloneFactory.sol";
14 
15 
16 /**
17  * @title DODOZoo
18  * @author DODO Breeder
19  *
20  * @notice Register of All DODO
21  */
22 contract DODOZoo is Ownable {
23     address public _DODO_LOGIC_;
24     address public _CLONE_FACTORY_;
25 
26     address public _DEFAULT_SUPERVISOR_;
27 
28     mapping(address => mapping(address => address)) internal _DODO_REGISTER_;
29     address[] public _DODOs;
30 
31     // ============ Events ============
32 
33     event DODOBirth(address newBorn, address baseToken, address quoteToken);
34 
35     // ============ Constructor Function ============
36 
37     constructor(
38         address _dodoLogic,
39         address _cloneFactory,
40         address _defaultSupervisor
41     ) public {
42         _DODO_LOGIC_ = _dodoLogic;
43         _CLONE_FACTORY_ = _cloneFactory;
44         _DEFAULT_SUPERVISOR_ = _defaultSupervisor;
45     }
46 
47     // ============ Admin Function ============
48 
49     function setDODOLogic(address _dodoLogic) external onlyOwner {
50         _DODO_LOGIC_ = _dodoLogic;
51     }
52 
53     function setCloneFactory(address _cloneFactory) external onlyOwner {
54         _CLONE_FACTORY_ = _cloneFactory;
55     }
56 
57     function setDefaultSupervisor(address _defaultSupervisor) external onlyOwner {
58         _DEFAULT_SUPERVISOR_ = _defaultSupervisor;
59     }
60 
61     function removeDODO(address dodo) external onlyOwner {
62         address baseToken = IDODO(dodo)._BASE_TOKEN_();
63         address quoteToken = IDODO(dodo)._QUOTE_TOKEN_();
64         require(isDODORegistered(baseToken, quoteToken), "DODO_NOT_REGISTERED");
65         _DODO_REGISTER_[baseToken][quoteToken] = address(0);
66         for (uint256 i = 0; i <= _DODOs.length - 1; i++) {
67             if (_DODOs[i] == dodo) {
68                 _DODOs[i] = _DODOs[_DODOs.length - 1];
69                 _DODOs.pop();
70                 break;
71             }
72         }
73     }
74 
75     function addDODO(address dodo) public onlyOwner {
76         address baseToken = IDODO(dodo)._BASE_TOKEN_();
77         address quoteToken = IDODO(dodo)._QUOTE_TOKEN_();
78         require(!isDODORegistered(baseToken, quoteToken), "DODO_REGISTERED");
79         _DODO_REGISTER_[baseToken][quoteToken] = dodo;
80         _DODOs.push(dodo);
81     }
82 
83     // ============ Breed DODO Function ============
84 
85     function breedDODO(
86         address maintainer,
87         address baseToken,
88         address quoteToken,
89         address oracle,
90         uint256 lpFeeRate,
91         uint256 mtFeeRate,
92         uint256 k,
93         uint256 gasPriceLimit
94     ) external onlyOwner returns (address newBornDODO) {
95         require(!isDODORegistered(baseToken, quoteToken), "DODO_REGISTERED");
96         newBornDODO = ICloneFactory(_CLONE_FACTORY_).clone(_DODO_LOGIC_);
97         IDODO(newBornDODO).init(
98             _OWNER_,
99             _DEFAULT_SUPERVISOR_,
100             maintainer,
101             baseToken,
102             quoteToken,
103             oracle,
104             lpFeeRate,
105             mtFeeRate,
106             k,
107             gasPriceLimit
108         );
109         addDODO(newBornDODO);
110         emit DODOBirth(newBornDODO, baseToken, quoteToken);
111         return newBornDODO;
112     }
113 
114     // ============ View Functions ============
115 
116     function isDODORegistered(address baseToken, address quoteToken) public view returns (bool) {
117         if (
118             _DODO_REGISTER_[baseToken][quoteToken] == address(0) &&
119             _DODO_REGISTER_[quoteToken][baseToken] == address(0)
120         ) {
121             return false;
122         } else {
123             return true;
124         }
125     }
126 
127     function getDODO(address baseToken, address quoteToken) external view returns (address) {
128         return _DODO_REGISTER_[baseToken][quoteToken];
129     }
130 
131     function getDODOs() external view returns (address[] memory) {
132         return _DODOs;
133     }
134 }
