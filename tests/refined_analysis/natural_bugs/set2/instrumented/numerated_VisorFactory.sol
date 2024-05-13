1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
5 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
6 
7 import {IFactory} from "../factory/IFactory.sol";
8 import {IInstanceRegistry} from "../factory/InstanceRegistry.sol";
9 import {ProxyFactory} from "../factory/ProxyFactory.sol";
10 
11 import {IUniversalVault} from "./Visor.sol";
12 
13 /// @title VisorFactory
14 contract VisorFactory is Ownable, IFactory, IInstanceRegistry, ERC721 {
15 
16     bytes32[] public names;
17     mapping(bytes32=>address) public templates;
18     bytes32 public activeTemplate;
19 
20     mapping(address=>address[]) public userIndex;
21 
22     event TemplateAdded(bytes32 indexed name, address indexed template);
23     event TemplateActive(bytes32 indexed name, address indexed template);
24 
25     constructor() ERC721("VISOR", "VISOR") {}
26 
27     function addTemplate(bytes32 name, address template) public onlyOwner {
28         require(templates[name] == address(0), "Template already exists");
29         templates[name] = template;
30         if(names.length == 0) {
31           activeTemplate = name;
32           emit TemplateActive(name, template);
33         }
34         names.push(name);
35         emit TemplateAdded(name, template);
36     }
37 
38     function setActive(bytes32 name) public onlyOwner {
39       require(templates[name] != address(0), "Template does not exist");
40       activeTemplate = name;
41       emit TemplateActive(name, templates[name]);
42     }
43 
44     /* registry functions */
45 
46     function isInstance(address instance) external view override returns (bool validity) {
47         return ERC721._exists(uint256(instance));
48     }
49 
50     function instanceCount() external view override returns (uint256 count) {
51         return ERC721.totalSupply();
52     }
53 
54     function instanceAt(uint256 index) external view override returns (address instance) {
55         return address(ERC721.tokenByIndex(index));
56     }
57 
58     /* factory functions */
59 
60     function createSelected(bytes32 name) public returns (address vault) {
61         // create clone and initialize
62         vault = ProxyFactory._create(
63             templates[name],
64             abi.encodeWithSelector(IUniversalVault.initialize.selector)
65         );
66 
67         // mint nft to caller
68         ERC721._safeMint(msg.sender, uint256(vault));
69         userIndex[msg.sender].push(vault);
70 
71         // emit event
72         emit InstanceAdded(vault);
73 
74         // explicit return
75         return vault;
76     }
77 
78     function createSelected2(bytes32 name, bytes32 salt) public returns (address vault) {
79         // create clone and initialize
80         vault = ProxyFactory._create2(
81             templates[name],
82             abi.encodeWithSelector(IUniversalVault.initialize.selector),
83             salt
84         );
85 
86         // mint nft to caller
87         ERC721._safeMint(msg.sender, uint256(vault));
88         userIndex[msg.sender].push(vault);
89 
90         // emit event
91         emit InstanceAdded(vault);
92 
93         // explicit return
94         return vault;
95     }
96 
97     function create(bytes calldata) external override returns (address vault) {
98         return create();
99     }
100 
101     function create2(bytes calldata, bytes32 salt) external override returns (address vault) {
102         return create2(salt);
103     }
104 
105     function create() public returns (address vault) {
106         // create clone and initialize
107         vault = ProxyFactory._create(
108             templates[activeTemplate],
109             abi.encodeWithSelector(IUniversalVault.initialize.selector)
110         );
111 
112         // mint nft to caller
113         ERC721._safeMint(msg.sender, uint256(vault));
114         userIndex[msg.sender].push(vault);
115 
116         // emit event
117         emit InstanceAdded(vault);
118 
119         // explicit return
120         return vault;
121     }
122 
123     function create2(bytes32 salt) public returns (address vault) {
124         // create clone and initialize
125         vault = ProxyFactory._create2(
126             templates[activeTemplate],
127             abi.encodeWithSelector(IUniversalVault.initialize.selector),
128             salt
129         );
130 
131         // mint nft to caller
132         ERC721._safeMint(msg.sender, uint256(vault));
133         userIndex[msg.sender].push(vault);
134 
135         // emit event
136         emit InstanceAdded(vault);
137 
138         // explicit return
139         return vault;
140     }
141 
142     /* getter functions */
143 
144     function nameCount() public view returns(uint256) {
145         return names.length;
146     }
147 
148     function vaultCount(address user) public view returns(uint256) {
149         return userIndex[user].length;
150     }
151 
152     function getUserVault(address user, uint256 index) public view returns (address) {
153         return userIndex[user][index];
154     }
155 
156     function getTemplate() external view returns (address) {
157         return templates[activeTemplate];
158     }
159 }
