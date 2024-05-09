1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 
45 contract ETHERCFeeModifiers is Ownable {
46 
47     // common discount/rebate
48     uint256 public commonDiscount;
49     uint256 public commonRebate;
50 
51     // mapping of user addresses to fee discount
52     mapping (address => uint256) discounts;
53     // mapping of user addresses to fee rebate
54     mapping (address => uint256) rebates;
55 
56     function ETHERCFeeModifiers() public {
57         commonDiscount = 0;
58         commonRebate = 0;
59     }
60 
61     function accountFeeModifiers(address _user) public view returns (uint256 feeDiscount, uint256 feeRebate) {
62         feeDiscount = discounts[_user] > commonDiscount ? discounts[_user] : commonDiscount;
63         feeRebate = rebates[_user] > commonRebate ? rebates[_user] : commonRebate;
64     }
65 
66     function tradingFeeModifiers(address _maker, address _taker) public view returns (uint256 feeMakeDiscount, uint256 feeTakeDiscount, uint256 feeRebate) {
67         feeMakeDiscount = discounts[_maker] > commonDiscount ? discounts[_maker] : commonDiscount;
68         feeTakeDiscount = discounts[_taker] > commonDiscount ? discounts[_taker] : commonDiscount;
69         feeRebate = rebates[_maker] > commonRebate ? rebates[_maker] : commonRebate;
70     }
71 
72     function setAccountFeeModifiers(address _user, uint256 _feeDiscount, uint256 _feeRebate) public onlyOwner {
73         require(_feeDiscount <= 100 && _feeRebate <= 100);
74         discounts[_user] = _feeDiscount;
75         rebates[_user] = _feeRebate;
76     }
77 
78     function changeCommonDiscount(uint256 _commonDiscount) public onlyOwner {
79         require(_commonDiscount <=100);
80         commonDiscount = _commonDiscount;
81     }
82 
83     function changeCommonRebate(uint256 _commonRebate) public onlyOwner {
84         require(_commonRebate <=100);
85         commonRebate = _commonRebate;
86     }
87 }