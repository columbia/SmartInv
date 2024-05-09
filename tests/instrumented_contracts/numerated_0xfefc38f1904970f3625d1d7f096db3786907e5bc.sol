1 pragma solidity ^0.4.25;
2 
3 interface IERC20Token {                                     
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function decimals() external returns (uint256);
7 }
8 
9 contract LUPXSale {
10     IERC20Token public tokenContract ;
11     address owner ;
12     uint256 public tokensSold ;
13     uint256 public LUPXPrice ;
14     
15     event sold(address buyer, uint256 amount) ;
16     event priceAdjusted(uint256 oldPrice, uint256 newPrice) ;
17     event endOfSale(uint256 timeStamp) ; 
18 
19     constructor(IERC20Token _tokenContract, uint256 LUPXperETH) public {
20         owner = msg.sender ;
21         tokenContract = _tokenContract ;
22         LUPXPrice = LUPXperETH ; 
23     }
24     
25     modifier onlyOwner() {
26         require(msg.sender == owner) ; 
27         _;
28     }
29 
30     function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0 ;
33         } else {
34             uint256 c = a * b ;
35             assert(c / a == b) ;
36             return c ;
37         }
38     }
39 
40     function () public payable {
41         uint256 soldAmount = 0 ; 
42         
43         if (msg.value <= 1 ether) {
44             soldAmount = safeMultiply(msg.value, LUPXPrice) ;
45         }
46         else {
47             soldAmount = safeMultiply(msg.value*3/2, LUPXPrice) ;
48         }
49         require(tokenContract.balanceOf(this) >= soldAmount) ;
50         tokenContract.transfer(msg.sender, soldAmount) ;
51         
52         tokensSold += soldAmount/10**18 ; 
53         emit sold(msg.sender, soldAmount/10**18) ; 
54 
55     }
56     
57     function withdrawETH() public  onlyOwner {
58         msg.sender.transfer(address(this).balance) ;  
59     }
60 
61     function endLUPXSale() public onlyOwner { 
62         require(tokenContract.transfer(owner, tokenContract.balanceOf(this))) ;
63         msg.sender.transfer(address(this).balance) ;
64         emit endOfSale(now) ; 
65     }
66 }