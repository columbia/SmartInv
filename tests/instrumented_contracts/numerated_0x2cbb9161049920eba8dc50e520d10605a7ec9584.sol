1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         require(newOwner != address(0));
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69     }
70 }
71 
72 /*
73  * Price band
74  * 5 ETH       @ $550 = 10,000 ZMN 
75  * 10 ETH      @ $545 = 10,000 ZMN
76  * 25 ETH      @ $540 = 10,000 ZMN
77  * 50 ETH      @ $530 = 10,000 ZMN
78  * 250 ETH     @ $520 = 10,000 ZMN
79  * 500 ETH     @ $510 = 10,000 ZMN
80  * 1,000 ETH   @ $500 = 10,000 ZMN
81 */
82 contract PrivateSaleExchangeRate is Ownable {
83     using SafeMath for uint256;
84     uint256 public rate;
85     uint256 public timestamp;
86     event UpdateUsdEthRate(uint256 _rate);
87     
88     function PrivateSaleExchangeRate(uint256 _rate) public {
89         require(_rate > 0);
90         rate = _rate;
91         timestamp = now;
92     }
93     
94     /*
95      * @param _rate USD/ETH
96      */
97     function updateUsdEthRate(uint256 _rate) public onlyOwner {
98         require(_rate > 0);
99         require(rate != _rate);
100         emit UpdateUsdEthRate(_rate);
101         rate = _rate;
102         timestamp = now;
103     }
104     
105      /*
106      * @dev return amount of ZMN token derive from price band and current exchange rate
107      * @param _weiAmount purchase amount of ETH
108      */
109     function getTokenAmount(uint256 _weiAmount) public view returns (uint256){
110         
111         // US cost for 10,000 tokens
112         uint256 cost = 550;
113         
114         if(_weiAmount < 10 ether){ 
115             cost = 550; 
116         }else if(_weiAmount < 25 ether){ 
117             cost = 545; 
118         }else if(_weiAmount < 50 ether){ 
119             cost = 540; 
120         }else if(_weiAmount < 250 ether){ 
121             cost = 530; 
122         }else if(_weiAmount < 500 ether){ 
123             cost = 520; 
124         }else if(_weiAmount < 1000 ether){ 
125             cost = 510;
126         }else{
127             cost = 500;
128         }
129         return _weiAmount.mul(rate).mul(10000).div(cost);
130     }
131 }