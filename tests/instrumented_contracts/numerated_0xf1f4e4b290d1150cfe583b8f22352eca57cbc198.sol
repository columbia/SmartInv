1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5 
6       /$$$$$$   /$$$$$$  /$$      /$$
7      /$$__  $$ /$$__  $$| $$$    /$$$
8     |__/  \ $$| $$  \__/| $$$$  /$$$$
9        /$$$$$/| $$ /$$$$| $$ $$/$$ $$
10       |___  $$| $$|_  $$| $$  $$$| $$
11      /$$  \ $$| $$  \ $$| $$\  $ | $$
12     |  $$$$$$/|  $$$$$$/| $$ \/  | $$
13     \______/  \______/ |__/     |__/
14 
15 
16     ** Website
17        https://3gm.dev/
18 
19     ** Twitter
20        https://twitter.com/3gmdev
21 
22 **/
23 
24 
25 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
26 
27 
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
31 
32 
33 
34 /**
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         return msg.data;
51     }
52 }
53 
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 
126 contract Node is Ownable {
127 
128     event Payment(
129         uint256 discordID,
130         uint256 payment,
131         uint256 txTimestamp,
132         uint256 expireTimestamp
133     );
134 
135     uint256 public price;
136     bool public paused = true;
137 
138     mapping(uint256 => uint256) public userPayments;
139     uint256[] public nodeUsers;
140 
141     function makePayment(uint256 discordID, uint256 months) external payable {
142         require(!paused, "Paused");
143         require(discordID > 0 && months > 0, "No zero params");
144         uint256 payment = msg.value;
145         require(msg.sender != address(0), "No zero address");
146         require(payment == (price * months), "No enough payment");
147         uint256 expireTimestamp = userPayments[discordID];
148         if(block.timestamp >= expireTimestamp){
149             expireTimestamp = block.timestamp + (30 days * months);
150         }else{
151             expireTimestamp += (30 days * months);
152         }
153         _makePayment(discordID, payment, expireTimestamp);
154     }
155 
156     function withdraw() external onlyOwner {
157         uint256 balance = address(this).balance;
158         (bool success, ) = _msgSender().call{value: balance}("");
159         require(success, "Failed to send");
160     }
161 
162     function togglePause() external onlyOwner {
163         paused = !paused;
164     }
165 
166     function setPrice(uint256 _price) external onlyOwner {
167         price = _price;
168     }
169 
170     function makePaymentByAdmin(uint256 discordID, uint256 payment, uint256 expireTimestamps) external onlyOwner {
171         _makePayment(discordID, payment, expireTimestamps);
172     }
173 
174     function makePaymentsByAdmin(uint256[] calldata discordIDs, uint256[] calldata payments, uint256[] calldata expireTimestamps) external onlyOwner {
175         require(discordIDs.length == expireTimestamps.length, "Not same lenght");
176         for (uint256 i; i < discordIDs.length; i++) {
177             _makePayment(discordIDs[i], payments[i], expireTimestamps[i]);
178         }
179     }
180 
181     function checkAlreadyUser(uint256 discordID) internal view returns (bool) {
182         if(userPayments[discordID] == 0) return false;
183         return true;
184     }
185 
186     function _makePayment(uint256 discordID, uint256 payment, uint256 expireTimestamp) internal {
187         if(!checkAlreadyUser(discordID)){
188             nodeUsers.push(discordID);
189         }
190         userPayments[discordID] = expireTimestamp;
191         emit Payment(discordID, payment, block.timestamp, expireTimestamp);
192     }
193 
194     function getUsersList() public view returns (uint256[] memory) {
195         return nodeUsers;
196     }
197 }