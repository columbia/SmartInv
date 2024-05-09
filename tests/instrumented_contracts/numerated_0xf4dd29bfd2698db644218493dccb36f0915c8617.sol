1 pragma solidity ^0.4.24; contract DSMath {
2     function add(uint x, uint y) internal pure returns (uint z) {
3         require((z = x + y) >= x, "ds-math-add-overflow");
4     }
5     function sub(uint x, uint y) internal pure returns (uint z) {
6         require((z = x - y) <= x, "ds-math-sub-underflow");
7     }
8     function mul(uint x, uint y) internal pure returns (uint z) {
9         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
10     }
11 
12     function min(uint x, uint y) internal pure returns (uint z) {
13         return x <= y ? x : y;
14     }
15     function max(uint x, uint y) internal pure returns (uint z) {
16         return x >= y ? x : y;
17     }
18     function imin(int x, int y) internal pure returns (int z) {
19         return x <= y ? x : y;
20     }
21     function imax(int x, int y) internal pure returns (int z) {
22         return x >= y ? x : y;
23     }
24 
25     uint constant WAD = 10 ** 18;
26     uint constant RAY = 10 ** 27;
27 
28     function wmul(uint x, uint y) internal pure returns (uint z) {
29         z = add(mul(x, y), WAD / 2) / WAD;
30     }
31     function rmul(uint x, uint y) internal pure returns (uint z) {
32         z = add(mul(x, y), RAY / 2) / RAY;
33     }
34     function wdiv(uint x, uint y) internal pure returns (uint z) {
35         z = add(mul(x, WAD), y / 2) / y;
36     }
37     function rdiv(uint x, uint y) internal pure returns (uint z) {
38         z = add(mul(x, RAY), y / 2) / y;
39     } function rpow(uint x, uint n) internal pure returns (uint z) {
40         z = n % 2 != 0 ? x : RAY;
41 
42         for (n /= 2; n != 0; n /= 2) {
43             x = rmul(x, x);
44 
45             if (n % 2 != 0) {
46                 z = rmul(z, x);
47             }
48         }
49     }
50 } contract Bank is DSMath { mapping(address => uint) public balances;
51   event LogDepositMade(address accountAddress, uint amount); function deposit() public payable returns (uint balance) {
52     balances[msg.sender] = add(balances[msg.sender], msg.value);
53     emit LogDepositMade(msg.sender, msg.value);
54     return balances[msg.sender];
55   } function withdraw(uint amount) public returns (uint remainingBalance){
56     require(min(amount,balances[msg.sender]) == amount);
57     balances[msg.sender] = sub(balances[msg.sender],amount);
58     msg.sender.transfer(amount);
59     return balances[msg.sender];
60   } 
61 
62 function balance() view public returns (uint) {
63     return balances[msg.sender];
64   }
65 } contract OwnsArt is DSMath, Bank{
66   address public artist;
67   address public artOwner;
68   uint public price;
69   uint public resaleFee;
70   uint public constant maxFlatIncreaseAmount = 0.01 ether;
71   uint public constant maxPercentIncreaseAmount = 10;
72 
73   event LogArtBought(address purchaserAddress, uint price, uint resalePrice);
74 
75   bool private buyArtMutex = false;
76 
77   constructor() public {
78     artist = msg.sender;
79     artOwner = msg.sender;
80     price = 0.01 ether;
81     resaleFee = 0 ether;
82     emit LogArtBought(msg.sender,0 ether,price);
83   } function buyArt(uint maxBid, uint resalePrice) public returns (uint){
84     require(msg.sender != artOwner);
85     require(max(maxBid,price) == maxBid);
86     require(min(maxBid,balances[msg.sender]) == maxBid);
87     require(min(resalePrice,maxResalePrice()) == resalePrice);
88 
89     require(!buyArtMutex);
90     buyArtMutex = true;
91 
92 
93     balances[msg.sender] = sub(balances[msg.sender],price);
94     balances[artOwner] = add(balances[artOwner],sub(price,resaleFee));
95     balances[artist] = add(balances[artist],resaleFee);
96     artOwner = msg.sender; if(min(resalePrice,price)==resalePrice){
97       resaleFee = 0 ether;
98     } else{
99       resaleFee = rdiv(sub(resalePrice,price),2*RAY);
100     }
101 
102     emit LogArtBought(msg.sender,price,resalePrice);
103     price = resalePrice;
104 
105     buyArtMutex = false;
106     return balances[msg.sender];
107   } function maxResalePrice() view public returns (uint){
108     return add(add(rdiv(mul(price,maxPercentIncreaseAmount),100*RAY),price),maxFlatIncreaseAmount);
109   }
110 }