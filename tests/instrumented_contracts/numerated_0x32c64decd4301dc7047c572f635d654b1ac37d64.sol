1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6     Fully commented standard ERC721 Distilled from OpenZeppelin Docs
7     Base for Building ERC721 by Martin McConnell
8     All the utility without the fluff.
9 */
10 
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _setOwner(_msgSender());
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is 0x address");
66         _setOwner(newOwner);
67     }
68 
69     function _setOwner(address newOwner) private {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 abstract contract Functional {
77     function toString(uint256 value) internal pure returns (string memory) {
78         if (value == 0) {
79             return "0";
80         }
81         uint256 temp = value;
82         uint256 digits;
83         while (temp != 0) {
84             digits++;
85             temp /= 10;
86         }
87         bytes memory buffer = new bytes(digits);
88         while (value != 0) {
89             digits -= 1;
90             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
91             value /= 10;
92         }
93         return string(buffer);
94     }
95     
96     bool private _reentryKey = false;
97     modifier reentryLock {
98         require(!_reentryKey, "attempt reenter locked function");
99         _reentryKey = true;
100         _;
101         _reentryKey = false;
102     }
103 }
104 
105 
106 contract ERC721 {
107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
110     function balanceOf(address owner) external view returns (uint256 balance){}
111     function ownerOf(uint256 tokenId) external view returns (address owner){}
112     function safeTransferFrom(address from,address to,uint256 tokenId) external{}
113     function transferFrom(address from, address to, uint256 tokenId) external{}
114     function approve(address to, uint256 tokenId) external{}
115     function getApproved(uint256 tokenId) external view returns (address operator){}
116     function setApprovalForAll(address operator, bool _approved) external{}
117     function isApprovedForAll(address owner, address operator) external view returns (bool){}
118     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{}
119 }
120 
121 // ******************************************************************************************************************************
122 // **************************************************  Start of Main Contract ***************************************************
123 // ******************************************************************************************************************************
124 
125 
126 contract gotchivender is Ownable, Functional {
127     uint256 public price;
128     uint256 public holderPrice;
129     uint256 public discountPrice;
130 
131     bool public mintActive;
132     string public name;
133 
134     ERC721 CHAMFAM;
135     ERC721[] DISCOUNT;
136 
137     address dev;
138     address community;
139     address chamagotchi;
140 
141     constructor() {
142         name = "Chamagotchis";
143         mintActive = false;
144 
145         //initialize discount contract
146         CHAMFAM = ERC721(0xFD3C3717164831916E6D2D7cdde9904dd793eC84); // mainnet
147 
148         dev             = payable(0x2E07cd18E675c921E8c523E36D79788734E94f88);
149         community       = payable(0x855bFE65652868920729b9d92D8d6030D01e3bFF);
150         chamagotchi     = payable(0x3083b00d19951c9f182c358e165460C52a729767);
151 
152         //DISCOUNT.push(CHAMFAM); //chamfam added to discount
153             //as an example
154 
155         price = 50 * (10 ** 15); // Replace leading value with price in finney
156         holderPrice = 25 * (10 ** 15); // Replace leading value with price in finney
157         discountPrice = 35 * (10 ** 15); // Replace leading value with price in finney
158 
159         DISCOUNT.push(ERC721(CHAMFAM));
160         
161     }
162 
163     function purchase() external payable {
164         uint256 cost = price;
165         if (CHAMFAM.balanceOf(_msgSender()) > 0){
166             cost = holderPrice;  // discount for chamfam holders
167         } else if (isDiscount()){
168             cost = discountPrice; // discount for associated NFTs
169         }
170 
171         require(msg.value >= cost, "Mint: Insufficient Funds");
172         require(mintActive);
173 
174         //Handle ETH transactions
175         uint256 cashIn = msg.value;
176         uint256 cashChange = 0;
177         if (cost > cashIn){
178             cashChange = cashIn - cost;
179         }
180                 
181         if (cashChange > 0){
182             (bool success, ) = msg.sender.call{value: cashChange}("");
183             require(success, "Mint: unable to send change");
184         }
185     }
186 
187     function isDiscount() public view returns (bool) {
188         for (uint256 i; i < DISCOUNT.length; i++){
189             if (DISCOUNT[i].balanceOf(_msgSender()) > 0) {
190                 return true;
191             }        
192         }
193         return false;
194     }
195     
196     function withdraw() external onlyOwner {
197         uint256 sendAmount = address(this).balance;
198         bool success;
199 
200         (success, ) = dev.call{value: ((sendAmount * 5)/100)}("");
201         require(success, "Txn Unsuccessful");
202 
203         (success, ) = community.call{value: ((sendAmount * 25)/100)}("");
204         require(success, "Txn Unsuccessful");
205 
206         (success, ) = chamagotchi.call{value: ((sendAmount * 70)/100)}("");
207         require(success, "Txn Unsuccessful");       
208     }
209 
210     function setDiscountPrice(uint256 newPrice) external onlyOwner{
211         discountPrice = newPrice;
212     }
213 
214     function setHolderPrice(uint256 newPrice) external onlyOwner{
215         holderPrice = newPrice;
216     }
217 
218     function addDiscountContract(address NFTaddress) external onlyOwner{
219         DISCOUNT.push(ERC721(NFTaddress));
220     }
221 
222     function activateMint() public onlyOwner {
223         mintActive = true;
224     }
225     
226     function deactivateMint() public onlyOwner {
227         mintActive = false;
228     }
229     
230     function setPrice(uint256 newPrice) public onlyOwner {
231         price = newPrice;
232     }
233 
234     receive() external payable {}
235     
236     fallback() external payable {}
237 }