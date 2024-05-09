1 // SPDX-License-Identifier: MIT
2 
3 /*
4      .____    .__             .__    .___
5      |    |   |__| ________ __|__| __| _/
6      |    |   |  |/ ____/  |  \  |/ __ |
7      |    |___|  < <_|  |  |  /  / /_/ |
8      |_______ \__|\__   |____/|__\____ |
9              \/      |__|             \/
10  ___________.__  __
11  \__    ___/|__|/  |______    ____   ______
12    |    |   |  \   __\__  \  /    \ /  ___/
13    |    |   |  ||  |  / __ \|   |  \\___ \
14    |____|   |__||__| (____  /___|  /____  >
15                           \/     \/     \/
16 
17 We don't need no water, let that motherf*cker burn!
18 */
19 
20 pragma solidity ^0.8.0;
21 
22 interface IERC721 {
23     function ownerOf(uint256 tokenId) external view returns (address owner);
24 
25     function getApproved(uint256 tokenId) external view returns (address);
26 
27     function safeTransferFrom(
28         address from,
29         address to,
30         uint256 tokenId
31     ) external;
32 
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 interface IERC1155 {
37     function balanceOf(
38         address account,
39         uint256 id
40     ) external view returns (uint256);
41 
42     function safeTransferFrom(
43         address from,
44         address to,
45         uint256 id,
46         uint256 amount,
47         bytes calldata data
48     ) external;
49 }
50 
51 contract TitanItemBurns {
52     address public DEAD = 0x000000000000000000000000000000000000dEaD;
53     address public Legends = 0x372405A6d95628Ad14518BfE05165D397f43dE1D;
54     address public Invaders = 0x2f3A9adc5301600Cd9205eF7657cF0733fF71D04;
55     address public Artifacts = 0xf85906f89aecA56aff6D34790677595aF6B4FBD7;
56     address public Titans = 0x21d6Fe3B109808Fc69CDaF9829457B0d780Bd975;
57     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
58 
59     // NOTE: We could have done this brute-force with a bunch of static fields, but
60     //       instead we are doing it with a dynamic set of traits contained in the traits
61     //       struct and a mapping into that struct for updates. It's harder and takes
62     //       a bit more gas, but doesn't force us into static traits in the future if
63     //       we add additional items to the list
64     //
65     struct TokenBurnContract {
66         uint256 maxTokenId;
67         string name;
68     }
69     mapping(address => TokenBurnContract) public TokenBurnContracts;
70 
71     struct TitanLevels {
72         address contractAddress;
73         uint256 tokenId;
74     }
75 
76     mapping(uint256 => mapping(address => TitanLevels)) public AllTitanLevels;
77 
78     constructor() {
79         addTokenBurnContract(
80             0x656BCe393341ED876c2e429B29B2Ff1C935b3c4B,
81             27,
82             "Armor"
83         );
84         addTokenBurnContract(
85             0x93c9c0cE57e4Bf051AB81B6A9c683a932A7c8fEc,
86             24,
87             "Weapon"
88         );
89         addTokenBurnContract(
90             0x0814aB15114D303e9970a3463e0ef170C6A406DE,
91             24,
92             "Enhancement"
93         );
94         addTokenBurnContract(
95             0xDde7505f40a61032Ed076452f85C0F54DFA208Bd,
96             18,
97             "Artifact"
98         );
99     }
100 
101     // ------------------------------------------------------------------------
102     // Add and remove tokens that can be burned, spindled, folded, & mutilated
103     // ------------------------------------------------------------------------
104     function addTokenBurnContract(
105         address contractAddress,
106         uint256 maxTokenId,
107         string memory name
108     ) public {
109         require(
110             msg.sender == LiquidDeployer,
111             "Only LiquidDeployer can add Token burn contracts"
112         );
113 
114         TokenBurnContracts[contractAddress] = TokenBurnContract(
115             maxTokenId,
116             name
117         );
118     }
119 
120     function removeTokenBurnContract(address contractAddress) public {
121         require(
122             msg.sender == LiquidDeployer,
123             "Only LiquidDeployer can remove Token burn contracts"
124         );
125 
126         delete TokenBurnContracts[contractAddress];
127     }
128 
129     function updateTokenBurnContract(
130         address contractAddress,
131         uint256 maxTokenId,
132         string memory name
133     ) public {
134         require(
135             msg.sender == LiquidDeployer,
136             "Only LiquidDeployer can update Token burn contracts"
137         );
138 
139         TokenBurnContracts[contractAddress] = TokenBurnContract(
140             maxTokenId,
141             name
142         );
143     }
144 
145     // -------------------------------------------------------------------------
146     // The functions used by the account burning the artifact or nfts for traits
147     // -------------------------------------------------------------------------
148 
149     function getTitanLevels(
150         uint256 key,
151         address addr
152     ) public view returns (TitanLevels memory) {
153         return AllTitanLevels[key][addr];
154     }
155 
156     event TitanLevelUp(
157         address indexed owner,
158         uint256 titanId,
159         address contractAddress,
160         string contractName,
161         uint256 tokenId
162     );
163 
164     // This requires an approval for the contract and token before it will work
165     // Go to the original contract and "Approve All" instead of each token id
166     // to save gas over the long term
167     function updateTitanLevel(
168         uint256 titanId,
169         address contractAddress,
170         uint256 tokenId
171     ) public {
172         require(
173             IERC1155(contractAddress).balanceOf(msg.sender, tokenId) > 0,
174             "Only the owner of the token can update the titan level"
175         );
176         require(
177             IERC721(Titans).ownerOf(titanId) == msg.sender,
178             "You do not own this Titan!"
179         );
180         TitanLevels storage titanLevel = AllTitanLevels[titanId][
181             contractAddress
182         ];
183         if (titanLevel.contractAddress == address(0)) {
184             titanLevel.contractAddress = contractAddress;
185             titanLevel.tokenId = tokenId;
186         } else if (tokenId <= titanLevel.tokenId) {
187             revert(
188                 "Token ID must be greater than the current token ID for this titan"
189             );
190         } else if (tokenId > titanLevel.tokenId + 1) {
191             revert(
192                 "Token ID must be less than or equal to current token ID + 1 for this titan"
193             );
194         } else {
195             titanLevel.tokenId = tokenId;
196         }
197         IERC1155(contractAddress).safeTransferFrom(
198             msg.sender,
199             DEAD,
200             tokenId,
201             1,
202             ""
203         );
204     }
205 
206     // This is the end. My only friend, the end [of the contract].
207 }