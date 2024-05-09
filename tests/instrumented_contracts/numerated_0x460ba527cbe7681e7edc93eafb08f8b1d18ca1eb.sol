1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     function setOwner(address _owner) public onlyOwner {
12         owner = _owner;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20 }
21 
22 
23 contract PurchasePackInterface {
24     function basePrice() public returns (uint);
25     function purchaseFor(address user, uint16 packCount, address referrer) public payable;
26 }
27 
28 
29 
30 
31 
32 
33 
34 
35 
36 contract Vault is Ownable { 
37 
38     function () public payable {
39 
40     }
41 
42     function getBalance() public view returns (uint) {
43         return address(this).balance;
44     }
45 
46     function withdraw(uint amount) public onlyOwner {
47         require(address(this).balance >= amount);
48         owner.transfer(amount);
49     }
50 
51     function withdrawAll() public onlyOwner {
52         withdraw(address(this).balance);
53     }
54 }
55 
56 
57 
58 contract DiscountPack is Vault {
59 
60     PurchasePackInterface private pack;
61     uint public basePrice;
62     uint public baseDiscount;
63 
64     constructor(PurchasePackInterface packToDiscount) public {
65         pack = packToDiscount;
66 
67         baseDiscount = uint(7) * pack.basePrice() / uint(100);
68         basePrice = pack.basePrice() - baseDiscount;
69     }
70 
71     event PackDiscount(address purchaser, uint16 packs, uint discount);
72  
73     function() public payable {}
74 
75     function purchase(uint16 packs) public payable {
76         uint discountedPrice = packs * basePrice;
77         uint discount = packs * baseDiscount;
78         uint fullPrice = discountedPrice + discount;
79 
80         require(msg.value >= discountedPrice, "Not enough value for the desired pack count.");
81         require(address(this).balance >= discount, "This contract is out of front money.");
82 
83         // This should route the referral back to this contract
84         pack.purchaseFor.value(fullPrice)(msg.sender, packs, this);
85         emit PackDiscount(msg.sender, packs, discount);
86     }
87 
88     function fraction(uint value, uint8 num, uint8 denom) internal pure returns (uint) {
89         return (uint(num) * value) / uint(denom);
90     }
91 }
92 
93 
94 contract DiscountEpicPack is DiscountPack {
95     constructor(PurchasePackInterface packToDiscount) public payable DiscountPack(packToDiscount) {
96         
97     }
98 }