1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13  
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20  
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25  
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Interface {
34     function balanceOf(address _owner) public constant returns (uint balance) {}
35     function transfer(address _to, uint _value) public returns (bool success) {}
36     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}
37 }
38 
39 contract Exchanger {
40     using SafeMath for uint;
41   // Decimals 18
42   ERC20Interface dai = ERC20Interface(0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359);
43   // Decimals 6
44   ERC20Interface usdt = ERC20Interface(0xdac17f958d2ee523a2206206994597c13d831ec7);
45 
46   address creator = 0x34f1e87e890b5683ef7b011b16055113c7194c35;
47   uint feeDAI = 50000000000000000;
48   uint feeUSDT = 50000;
49 
50   function getDAI(uint _amountInDollars) public returns (bool) {
51     // Must first call approve for the usdt contract
52     usdt.transferFrom(msg.sender, this, _amountInDollars * (10 ** 6));
53     dai.transfer(msg.sender, _amountInDollars.mul(((10 ** 18) - feeDAI)));
54     return true;
55   }
56 
57   function getUSDT(uint _amountInDollars) public returns (bool) {
58     // Must first call approve for the dai contract
59     dai.transferFrom(msg.sender, this, _amountInDollars * (10 ** 18));
60     usdt.transfer(msg.sender, _amountInDollars.mul(((10 ** 6) - feeUSDT)));
61     return true;
62   }
63 
64   function withdrawEquity(uint _amountInDollars, bool isUSDT) public returns (bool) {
65     require(msg.sender == creator);
66     if(isUSDT) {
67       usdt.transfer(creator, _amountInDollars * (10 ** 6));
68     } else {
69       dai.transfer(creator, _amountInDollars * (10 ** 18));
70     }
71     return true;
72   }
73 }