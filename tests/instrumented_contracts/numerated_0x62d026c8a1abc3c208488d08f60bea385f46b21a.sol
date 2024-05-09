1 pragma solidity ^0.8.6;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 
39 interface AvastarsNFT {
40     function safeTransferFrom(address from, address to, uint256 tokenId) external;
41     function balanceOf(address owner) external view returns (uint256 balance);
42     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
43 }
44 
45 contract TerminusClaim {
46 
47     address owner;
48     bool addressesFinalized;
49     mapping (address => uint256) private amountClaimableByAddress;
50     address public reserveAddress = 0xc53f5c08237F679b5411B0028c0c8FA4C91c54Ca; //terminus address 
51     
52     using Roles for Roles.Role;
53         
54     Roles.Role private _approvedCaller;
55 
56     AvastarsNFT private avastarsNFT = AvastarsNFT(0xF3E778F839934fC819cFA1040AabaCeCBA01e049);  //mainnet avastars 
57 
58     constructor() {
59         owner = msg.sender;
60     _approvedCaller.add(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3);
61     _approvedCaller.add(0xBFfAc0D7B5AfAED417C36Ec492BEA4ec16DfC8b9); 
62     _approvedCaller.add(0x442DCCEe68425828C106A3662014B4F131e3BD9b);    
63     }
64 
65     modifier isOwner() {
66         require(msg.sender == owner, "Not ownwer");
67         _;
68     }
69 
70     function pushAddresses(address[] memory attendee) public isOwner {
71 
72         for(uint256 i = 0; i < attendee.length; i++){
73             amountClaimableByAddress[attendee[i]] = 1;
74         }
75 
76     }
77 
78     function finalizeAddresses() public {
79         require(_approvedCaller.has(msg.sender), "Only team can finalize list.");
80         addressesFinalized = true;
81     }
82     
83     function getRandomAvastar(uint256 avastarsInReserve) internal view returns (uint256 randomAvastarIndex) {
84         uint256 hash = uint((keccak256(abi.encodePacked(avastarsInReserve,msg.sender,block.number))));
85         randomAvastarIndex = hash % avastarsInReserve;
86     }
87 
88     function claimAvastar() public {
89         require(addressesFinalized == true);
90         require(amountClaimableByAddress[msg.sender] == 1);
91         
92         amountClaimableByAddress[msg.sender] = 0;
93         
94         uint256 avastarsInReserve = avastarsNFT.balanceOf(reserveAddress);
95 
96         uint256 randomAvastarIndex = getRandomAvastar(avastarsInReserve); 
97         
98         uint256 avastarToSend = avastarsNFT.tokenOfOwnerByIndex(reserveAddress, randomAvastarIndex);
99         
100         avastarsNFT.safeTransferFrom(reserveAddress, msg.sender, avastarToSend);
101     }
102     
103     function avastarsRemaining() public view returns (uint256 avastarsInReserveAccount) {
104         avastarsInReserveAccount = avastarsNFT.balanceOf(reserveAddress);
105     }
106     
107     function addCaller(address newCaller) public isOwner {
108         _approvedCaller.add(newCaller);
109     }
110     
111     function removeCaller(address newCaller) public isOwner {
112         _approvedCaller.remove(newCaller);
113     }    
114 
115 }