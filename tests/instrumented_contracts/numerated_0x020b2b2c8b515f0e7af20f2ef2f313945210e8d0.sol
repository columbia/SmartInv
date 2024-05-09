1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract BeatOrgTokenPostSale is Ownable {
70     using SafeMath for uint256;
71 
72     address public wallet;
73 
74     uint256 public endTime;
75     bool public finalized;
76 
77     uint256 public weiRaised;
78     mapping(address => uint256) public purchases;
79 
80     event Purchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount);
81 
82     function BeatOrgTokenPostSale(address _wallet) public {
83         require(_wallet != address(0));
84         wallet = _wallet;
85 
86         // 2018-07-15T23:59:59+02:00
87         endTime = 1531691999;
88         finalized = false;
89     }
90 
91     function() payable public {
92         buyTokens(msg.sender);
93     }
94 
95     function buyTokens(address beneficiary) payable public {
96         require(beneficiary != address(0));
97         require(msg.value != 0);
98         require(validPurchase());
99 
100         uint256 weiAmount = msg.value;
101 
102         purchases[beneficiary] += weiAmount;
103         weiRaised += weiAmount;
104 
105         Purchase(msg.sender, beneficiary, weiAmount);
106 
107         wallet.transfer(weiAmount);
108     }
109 
110     function finalize() onlyOwner public {
111         endTime = now;
112         finalized = true;
113     }
114 
115     function validPurchase() internal view returns (bool) {
116         return (now <= endTime) && (finalized == false);
117     }
118 
119 }