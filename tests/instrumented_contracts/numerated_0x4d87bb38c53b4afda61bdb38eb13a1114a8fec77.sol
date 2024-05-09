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
54 contract APIRegistry is Ownable {
55 
56     struct APIForSale {
57         uint pricePerCall;
58         bytes32 sellerUsername;
59         bytes32 apiName;
60         address sellerAddress;
61         string hostname;
62         string docsUrl;
63     }
64 
65     mapping(string => uint) internal apiIds;
66     mapping(uint => APIForSale) public apis;
67 
68     uint public numApis;
69     uint public version;
70 
71     // ------------------------------------------------------------------------
72     // Constructor, establishes ownership because contract is owned
73     // ------------------------------------------------------------------------
74     constructor() public {
75         numApis = 0;
76         version = 1;
77     }
78 
79     // ------------------------------------------------------------------------
80     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
81     // ------------------------------------------------------------------------
82     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
83         return ERC20(tokenAddress).transfer(owner, tokens);
84     }
85 
86     // ------------------------------------------------------------------------
87     // Lets a user list an API to sell
88     // ------------------------------------------------------------------------
89     function listApi(uint pricePerCall, bytes32 sellerUsername, bytes32 apiName, string hostname, string docsUrl) public {
90         // make sure input params are valid
91         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && bytes(hostname).length != 0);
92         
93         // make sure the name isn't already taken
94         require(apiIds[hostname] == 0);
95 
96         numApis += 1;
97         apiIds[hostname] = numApis;
98 
99         APIForSale storage api = apis[numApis];
100 
101         api.pricePerCall = pricePerCall;
102         api.sellerUsername = sellerUsername;
103         api.apiName = apiName;
104         api.sellerAddress = msg.sender;
105         api.hostname = hostname;
106         api.docsUrl = docsUrl;
107     }
108 
109     // ------------------------------------------------------------------------
110     // Get the ID number of an API given it's hostname
111     // ------------------------------------------------------------------------
112     function getApiId(string hostname) public view returns (uint) {
113         return apiIds[hostname];
114     }
115 
116     // ------------------------------------------------------------------------
117     // Get info stored for the API but without the dynamic members, because solidity can't return dynamics to other smart contracts yet
118     // ------------------------------------------------------------------------
119     function getApiByIdWithoutDynamics(
120         uint apiId
121     ) 
122         public
123         view 
124         returns (
125             uint pricePerCall, 
126             bytes32 sellerUsername,
127             bytes32 apiName, 
128             address sellerAddress
129         ) 
130     {
131         APIForSale storage api = apis[apiId];
132 
133         pricePerCall = api.pricePerCall;
134         sellerUsername = api.sellerUsername;
135         apiName = api.apiName;
136         sellerAddress = api.sellerAddress;
137     }
138 
139     // ------------------------------------------------------------------------
140     // Get info stored for an API by id
141     // ------------------------------------------------------------------------
142     function getApiById(
143         uint apiId
144     ) 
145         public 
146         view 
147         returns (
148             uint pricePerCall, 
149             bytes32 sellerUsername, 
150             bytes32 apiName, 
151             address sellerAddress, 
152             string hostname, 
153             string docsUrl
154         ) 
155     {
156         APIForSale storage api = apis[apiId];
157 
158         pricePerCall = api.pricePerCall;
159         sellerUsername = api.sellerUsername;
160         apiName = api.apiName;
161         sellerAddress = api.sellerAddress;
162         hostname = api.hostname;
163         docsUrl = api.docsUrl;
164     }
165 
166     // ------------------------------------------------------------------------
167     // Get info stored for an API by hostname
168     // ------------------------------------------------------------------------
169     function getApiByName(
170         string _hostname
171     ) 
172         public 
173         view 
174         returns (
175             uint pricePerCall, 
176             bytes32 sellerUsername, 
177             bytes32 apiName, 
178             address sellerAddress, 
179             string hostname, 
180             string docsUrl
181         ) 
182     {
183         uint apiId = apiIds[_hostname];
184         if (apiId == 0) {
185             return;
186         }
187         APIForSale storage api = apis[apiId];
188 
189         pricePerCall = api.pricePerCall;
190         sellerUsername = api.sellerUsername;
191         apiName = api.apiName;
192         sellerAddress = api.sellerAddress;
193         hostname = api.hostname;
194         docsUrl = api.docsUrl;
195     }
196 
197     // ------------------------------------------------------------------------
198     // Edit an API listing
199     // ------------------------------------------------------------------------
200     function editApi(uint apiId, uint pricePerCall, address sellerAddress, string docsUrl) public {
201         require(apiId != 0 && pricePerCall != 0 && sellerAddress != address(0));
202 
203         APIForSale storage api = apis[apiId];
204 
205         // prevent editing an empty api (effectively listing an api)
206         require(
207             api.pricePerCall != 0 && api.sellerUsername != "" && api.apiName != "" &&  bytes(api.hostname).length != 0 && api.sellerAddress != address(0)
208         );
209 
210         // require that sender is the original api lister, or the contract owner
211         // the contract owner clause lets us recover a api listing if a dev loses access to their privkey
212         require(msg.sender == api.sellerAddress || msg.sender == owner);
213 
214         api.pricePerCall = pricePerCall;
215         api.sellerAddress = sellerAddress;
216         api.docsUrl = docsUrl;
217     }
218 }