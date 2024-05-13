1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
7 import {IERC20Permit} from "@openzeppelin/contracts/drafts/IERC20Permit.sol";
8 import {TransferHelper} from "@uniswap/lib/contracts/libraries/TransferHelper.sol";
9 import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
10 import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/ERC721Holder.sol";
11 
12 import {IHypervisor} from "./hypervisor/Hypervisor.sol";
13 import {IUniversalVault} from "./visor/Visor.sol";
14 import {IFactory} from "./factory/IFactory.sol";
15 
16 /// @title Mainframe
17 contract Mainframe is ERC721Holder {
18     function mintVisorAndStake(
19         address hypervisor,
20         address visorFactory,
21         address visorOwner,
22         uint256 amount,
23         bytes32 salt,
24         bytes calldata permission
25     ) external returns (address vault) {
26         // create vault
27         vault = IFactory(visorFactory).create2("", salt);
28         // get staking token
29         address stakingToken = IHypervisor(hypervisor).getHypervisorData().stakingToken;
30         // transfer ownership
31         IERC721(visorFactory).safeTransferFrom(address(this), visorOwner, uint256(vault));
32         // transfer tokens
33         TransferHelper.safeTransferFrom(stakingToken, msg.sender, vault, amount);
34         // stake
35         IHypervisor(hypervisor).stake(vault, amount, permission);
36     }
37 
38     struct Permit {
39         address owner;
40         address spender;
41         uint256 value;
42         uint256 deadline;
43         uint8 v;
44         bytes32 r;
45         bytes32 s;
46     }
47 
48     function mintVisorPermitAndStake(
49         address hypervisor,
50         address visorFactory,
51         address visorOwner,
52         bytes32 salt,
53         Permit calldata permit,
54         bytes calldata permission
55     ) external returns (address vault) {
56         // create vault
57         vault = IFactory(visorFactory).create2("", salt);
58         // transfer ownership
59         IERC721(visorFactory).safeTransferFrom(address(this), visorOwner, uint256(vault));
60         // permit and stake
61         permitAndStake(hypervisor, vault, permit, permission);
62         // return vault
63         return vault;
64     }
65 
66     function permitAndStake(
67         address hypervisor,
68         address vault,
69         Permit calldata permit,
70         bytes calldata permission
71     ) public {
72         // get staking token
73         address stakingToken = IHypervisor(hypervisor).getHypervisorData().stakingToken;
74         // permit transfer
75         IERC20Permit(stakingToken).permit(
76             permit.owner,
77             permit.spender,
78             permit.value,
79             permit.deadline,
80             permit.v,
81             permit.r,
82             permit.s
83         );
84         // transfer tokens
85         TransferHelper.safeTransferFrom(stakingToken, msg.sender, vault, permit.value);
86         // stake
87         IHypervisor(hypervisor).stake(vault, permit.value, permission);
88     }
89 
90     struct StakeRequest {
91         address hypervisor;
92         address vault;
93         uint256 amount;
94         bytes permission;
95     }
96 
97     function stakeMulti(StakeRequest[] calldata requests) external {
98         for (uint256 index = 0; index < requests.length; index++) {
99             StakeRequest calldata request = requests[index];
100             IHypervisor(request.hypervisor).stake(request.vault, request.amount, request.permission);
101         }
102     }
103 
104     struct UnstakeRequest {
105         address hypervisor;
106         address vault;
107         uint256 amount;
108         bytes permission;
109     }
110 
111     function unstakeMulti(UnstakeRequest[] calldata requests) external {
112         for (uint256 index = 0; index < requests.length; index++) {
113             UnstakeRequest calldata request = requests[index];
114             IHypervisor(request.hypervisor).unstakeAndClaim(
115                 request.vault,
116                 request.amount,
117                 request.permission
118             );
119         }
120     }
121 
122     function predictDeterministicAddress(
123         address master,
124         bytes32 salt,
125         address deployer
126     ) external pure returns (address instance) {
127         return Clones.predictDeterministicAddress(master, salt, deployer);
128     }
129 
130     function stake(
131         address hypervisor,
132         address vault,
133         uint256 value,
134         bytes calldata permission
135     ) public {
136         // get staking token
137         address stakingToken = IHypervisor(hypervisor).getHypervisorData().stakingToken;
138         // transfer tokens
139         TransferHelper.safeTransferFrom(stakingToken, msg.sender, vault, value);
140         // stake
141         IHypervisor(hypervisor).stake(vault, value, permission);
142     }
143 }
