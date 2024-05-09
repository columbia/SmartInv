1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract OwnerHelper
34 {
35     address public owner;
36     
37     modifier onlyOwner
38     {
39         require(msg.sender == owner);
40         _;
41     }
42     function OwnerHelper() public
43     {
44         owner = msg.sender;
45     }
46     function transferOwnership(address _to, uint _value) public returns (bool)
47     {
48         require(_to != owner);
49         require(_to != address(0x0));
50         owner = _to;
51         //OwnerTransferPropose(owner, _to);
52 
53     }
54 }
55 
56 contract Crowdsale is OwnerHelper {
57     using SafeMath for uint;
58     
59     uint public saleEthCount = 0;
60     uint public maxSaleEth = 2 ether;
61     uint constant public minEth = 1;
62     uint constant public maxEth = 10;
63 
64 
65     constructor() public {
66         owner = msg.sender;
67     }
68     
69     
70 
71     function () payable public
72     {
73         //require(msg.value.div(1) == 0);
74         require(msg.value >= minEth && msg.value <= maxEth);
75         require(msg.value.add(saleEthCount) <= maxSaleEth);
76    
77         saleEthCount = saleEthCount.add(msg.value);
78     }
79 
80     function withdraw() public onlyOwner {
81         
82         owner.transfer(saleEthCount);
83         
84     }
85 
86 }