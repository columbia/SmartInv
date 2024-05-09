1 /**
2 Moontok.io Ads Payment
3 
4 Website: https://www.moontok.io
5 TG Channel: https://t.me/Moontok_Channel
6 TG Group: https://t.me/Moontok_Group
7 TG Alert: https://t.me/moontok_listing
8 Tiktok: https://www.tiktok.com/@moontokofficial
9 Twitter: http://twitter.com/MoontokOfficial
10 Email: team@moontok.io
11 */
12 
13 pragma solidity ^0.6.12;
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 contract Ownable is Context {
29     address payable private _owner;
30     address private _previousOwner;
31     uint256 private _lockTime;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor () internal {
39         _owner = msg.sender;
40         emit OwnershipTransferred(address(0), _owner);
41     }
42 
43     /**
44      * @dev Returns the address of the current owner.
45      */
46     function owner() public view returns (address payable) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 }
58 
59 contract MoontokPay is Context, Ownable {
60     
61     //record
62     struct BuyData {
63         uint256 coinId;
64         uint256 adsType;
65         uint256 amount;
66     }
67     uint256 private currentBuyIndex;
68     mapping (uint256 => BuyData) private buyRecord;
69 
70     constructor () public {
71         currentBuyIndex = 1;
72     }
73     
74     //toplist support
75     function getBuyCount() public view returns (uint256) {
76         return currentBuyIndex;
77     }
78     
79     function getBuyRecord(uint256 idx) public view returns (uint256, uint256, uint256) {
80         require(idx <= currentBuyIndex, "Index out of bounds");
81         
82         return (buyRecord[idx].coinId, buyRecord[idx].adsType, buyRecord[idx].amount);
83     }
84     
85     function payWithETH(uint256 coinId, uint256 adsType) external payable {
86         require(coinId > 0, "Invalid coin ID");
87         require(msg.value >= 0.01 ether);
88         
89         bool success = owner().send(msg.value);
90         require(success, "Money transfer failed");
91         
92         buyRecord[currentBuyIndex] = BuyData(coinId, adsType, msg.value);
93         ++currentBuyIndex;
94     }
95     
96      
97     //to recieve ETH from uniswapV2Router when swaping
98     receive() external payable {
99          bool success = owner().send(msg.value);
100          require(success, "Money transfer failed");
101     }
102 }