1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract Registry is Ownable {
55 
56     struct ModuleForSale {
57         uint price;
58         bytes32 sellerUsername;
59         bytes32 moduleName;
60         address sellerAddress;
61         bytes4 licenseId;
62     }
63 
64     mapping(string => uint) internal moduleIds;
65     mapping(uint => ModuleForSale) public modules;
66 
67     uint public numModules;
68     uint public version;
69 
70     // ------------------------------------------------------------------------
71     // Constructor, establishes ownership because contract is owned
72     // ------------------------------------------------------------------------
73     constructor() public {
74         numModules = 0;
75         version = 1;
76     }
77 
78     // ------------------------------------------------------------------------
79     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
80     // ------------------------------------------------------------------------
81     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
82         return ERC20(tokenAddress).transfer(owner, tokens);
83     }
84 
85     // ------------------------------------------------------------------------
86     // Lets a user list a software module for sale in this registry
87     // ------------------------------------------------------------------------
88     function listModule(uint price, bytes32 sellerUsername, bytes32 moduleName, string usernameAndProjectName, bytes4 licenseId) public {
89         // make sure input params are valid
90         require(price != 0 && sellerUsername != "" && moduleName != "" && bytes(usernameAndProjectName).length != 0 && licenseId != 0);
91 
92         // make sure the name isn't already taken
93         require(moduleIds[usernameAndProjectName] == 0);
94 
95         numModules += 1;
96         moduleIds[usernameAndProjectName] = numModules;
97 
98         ModuleForSale storage module = modules[numModules];
99 
100         module.price = price;
101         module.sellerUsername = sellerUsername;
102         module.moduleName = moduleName;
103         module.sellerAddress = msg.sender;
104         module.licenseId = licenseId;
105     }
106 
107     // ------------------------------------------------------------------------
108     // Get the ID number of a module given the username and project name of that module
109     // ------------------------------------------------------------------------
110     function getModuleId(string usernameAndProjectName) public view returns (uint) {
111         return moduleIds[usernameAndProjectName];
112     }
113 
114     // ------------------------------------------------------------------------
115     // Get info stored for a module by id
116     // ------------------------------------------------------------------------
117     function getModuleById(
118         uint moduleId
119     ) 
120         public 
121         view 
122         returns (
123             uint price, 
124             bytes32 sellerUsername, 
125             bytes32 moduleName, 
126             address sellerAddress, 
127             bytes4 licenseId
128         ) 
129     {
130         ModuleForSale storage module = modules[moduleId];
131         
132 
133         if (module.sellerAddress == address(0)) {
134             return;
135         }
136 
137         price = module.price;
138         sellerUsername = module.sellerUsername;
139         moduleName = module.moduleName;
140         sellerAddress = module.sellerAddress;
141         licenseId = module.licenseId;
142     }
143 
144     // ------------------------------------------------------------------------
145     // get info stored for a module by name
146     // ------------------------------------------------------------------------
147     function getModuleByName(
148         string usernameAndProjectName
149     ) 
150         public 
151         view
152         returns (
153             uint price, 
154             bytes32 sellerUsername, 
155             bytes32 moduleName, 
156             address sellerAddress, 
157             bytes4 licenseId
158         ) 
159     {
160         uint moduleId = moduleIds[usernameAndProjectName];
161         if (moduleId == 0) {
162             return;
163         }
164         ModuleForSale storage module = modules[moduleId];
165 
166         price = module.price;
167         sellerUsername = module.sellerUsername;
168         moduleName = module.moduleName;
169         sellerAddress = module.sellerAddress;
170         licenseId = module.licenseId;
171     }
172 
173     // ------------------------------------------------------------------------
174     // Edit a module listing
175     // ------------------------------------------------------------------------
176     function editModule(uint moduleId, uint price, address sellerAddress, bytes4 licenseId) public {
177         // Make sure input params are valid
178         require(moduleId != 0 && price != 0 && sellerAddress != address(0) && licenseId != 0);
179 
180         ModuleForSale storage module = modules[moduleId];
181 
182         // prevent editing an empty module (effectively listing a module)
183         require(
184             module.price != 0 && module.sellerUsername != "" && module.moduleName != "" && module.licenseId != 0 && module.sellerAddress != address(0)
185         );
186 
187         // require that sender is the original module lister, or the contract owner
188         // the contract owner clause lets us recover a module listing if a dev loses access to their privkey
189         require(msg.sender == module.sellerAddress || msg.sender == owner);
190 
191         module.price = price;
192         module.sellerAddress = sellerAddress;
193         module.licenseId = licenseId;
194     }
195 }