1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _setOwner(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _setOwner(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _setOwner(newOwner);
81     }
82 
83     function _setOwner(address newOwner) private {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 interface Shard {
91     function balanceOf(address wallet) external view returns(uint256);
92     function burnShards(address wallet, uint256 amount) external;
93 }
94 
95 interface ShardOld {
96     function balanceOf(address wallet) external view returns(uint256);
97     function burnShards(address wallet, uint256 amount) external;
98 }
99 
100 interface MP {
101     function balanceOf(address wallet) external view returns(uint256);
102 }
103 
104 interface Frame {
105     function getTokensStaked(address wallet) external view returns (uint256[] memory);
106 }
107 
108 /*
109 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
110 ⠀*⠀⠀⠀⠀⢀⣀⣀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣀⣀⡀⠀⠀⠀⠀⠀
111 ⠀*⠀⠀⠀⠀⢸⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⡇⠀⠀⠀⠀⠀
112 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⣿⣿⡿⠟⠁⠀⠀⣀⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
113 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⡿⠋⠀⠀⠀⣠⣾⣿⡿⠋⠁⠀⣿⡇⠀⠀⠀⠀⠀
114 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⠟⠉⠀⠀⢀⣴⣾⣿⠿⠋⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
115 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣠⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
116 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⣠⣾⣿⡿⠋⠁⠀⠀⠀⠀⠀⣠⣶⠀⣿⡇⠀⠀⠀⠀⠀
117 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⠿⠋⠀⠀⠀⠀⠀⢀⣠⣾⡿⠟⠀⣿⡇⠀⠀⠀⠀⠀
118 ⠀*⠀⠀⠀⠀⢸⣿⠀⠘⠁⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⣠⣴⠀⣿⡇⠀⠀⠀⠀⠀
119 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⢁⣠⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
120 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⢀⣠⣾⡿⠋⢁⣴⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
121 ⠀*⠀⠀⠀⠀⢸⣿⣀⣀⣀⣈⣉⣉⣀⣀⣉⣉⣉⣉⣉⣉⣉⣀⣿⡇⠀⠀⠀⠀⠀
122 ⠀*⠀⠀⠀⠀⠘⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠛⠛⠃⠀⠀⠀⠀⠀
123 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
124  *          MIRRORPASS.XYZ
125  */
126 contract Reservation is Ownable {
127     Shard private shards;
128     ShardOld private shardOld;
129     MP private mp;
130     Frame private frame;
131 
132     uint256 public reserveTime = 0;
133     uint256 public closeTime = 0;
134 
135     uint256 public totalReserved = 0;
136     uint256 public reservePrice = 280 ether;
137 
138     mapping(address => uint256) public reservedBots;
139     mapping(address => bool) public adminAddresses;
140 
141     event Reserved(address wallet, uint256 amount, uint256 timestamp);
142 
143     modifier onlyAdmins() {
144         require(adminAddresses[msg.sender], "You're not authorized to call this");
145         _;
146     }
147 
148     modifier isNotContract() {
149         require(tx.origin == msg.sender, "No contracts allowed");
150         _;
151     }
152 
153     modifier isReservationAvailable() {
154         require(reserveTime > 0 && closeTime > 0,  "Reserving is currently disabled");
155         require(block.timestamp >= reserveTime, "Reserving is currently disabled");
156         require(closeTime > block.timestamp, "Reserving has now ended");
157         _;
158     }
159 
160     modifier isHolder() {
161         require(mp.balanceOf(msg.sender) > 0 || frame.getTokensStaked(msg.sender).length > 0, "You're not a mirror pass holder");
162         _;
163     }
164 
165     // this burns the tokens in order to reserve a bot for the mint
166     function reserve(uint256 amount, uint256 oldBal, uint256 newBal) public isNotContract isReservationAvailable isHolder {
167         require((shards.balanceOf(msg.sender) + shardOld.balanceOf(msg.sender)) >= amount * reservePrice, "Not enough shards to reserve this amount");
168         require(oldBal + newBal >= amount * reservePrice, "Not enough shards provided in the transaction");
169 
170         if (oldBal > 0) {
171             shardOld.burnShards(msg.sender, oldBal);
172         }
173 
174         if (newBal > 0) {
175             shards.burnShards(msg.sender, newBal);
176         }
177 
178         totalReserved += amount;
179         reservedBots[msg.sender] += amount;
180         emit Reserved(msg.sender, amount, block.timestamp);
181     }
182 
183     function changeReservedFromWallet(address wallet, uint256 amount) public onlyAdmins {
184         reservedBots[wallet] = amount;
185     }
186 
187     function setShardsContract(address shardsContract) public onlyOwner {
188         shards = Shard(shardsContract);
189     }
190 
191     function setOldShardsContract(address oldContract) public onlyOwner {
192         shardOld = ShardOld(oldContract);
193     }
194 
195     function setTokenContract(address tokenContract) public onlyOwner {
196         mp = MP(tokenContract);
197     }
198 
199     function setFrameContract(address frameContract) public onlyOwner {
200         frame = Frame(frameContract);
201     }
202 
203     function setReservePrice(uint256 amount) public onlyOwner {
204         reservePrice = amount;
205     }
206 
207     function setReserving(uint256 timestamp) public onlyOwner {
208         reserveTime = timestamp;
209         closeTime = timestamp + 1 days;
210     }
211 
212     // incase it's required
213     function forceCloseTime(uint256 time) public onlyOwner {
214         closeTime = time;
215     }
216     
217     function setAdminAddresses(address contractAddress, bool state) public onlyOwner {
218         adminAddresses[contractAddress] = state;
219     }
220 }