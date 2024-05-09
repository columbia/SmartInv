1 pragma solidity ^0.5.4;
2 
3 library SafeMath {
4     
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29   
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract Crowdsale {
40     
41   using SafeMath for uint;    
42     
43   address public owner;
44   
45   address payable public wallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
46   
47   address public token = 0x42588776F50789AE5Ce2D9CE0c63F5dFE12F758c;
48   
49   uint public price; // coins per wei
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67   
68   function setPrice(uint newPrice) public onlyOwner {
69     price = newPrice;  
70   }
71   
72   function setWallet(address payable newWallet) public onlyOwner {
73     wallet = newWallet;
74   }
75   
76   function setToken(address newToken) public onlyOwner {
77     token = newToken;
78   }
79   
80   function retrieveTokens(address to, address anotherToken) public onlyOwner {
81     ERC20Basic alienToken = ERC20Basic(anotherToken);
82     alienToken.transfer(to, alienToken.balanceOf(address(this)));
83   }
84   
85   function () external payable {
86     wallet.transfer(msg.value);  
87     uint tokens = msg.value.mul(price).div(1000000000000000000);
88     ERC20Basic(token).transfer(msg.sender, tokens);
89   }
90 
91 }