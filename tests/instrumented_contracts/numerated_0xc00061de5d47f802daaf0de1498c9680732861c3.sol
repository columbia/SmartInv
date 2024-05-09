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
33 contract Mainsale {
34 
35   using SafeMath for uint256;
36 
37   address public owner;
38   address public multisig;
39   uint256 public endTimestamp;
40   uint256 public totalRaised;
41   uint256 public constant hardCap = 19333 ether;
42   uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
43   uint256 public constant MAX_CONTRIBUTION = 1000 ether;
44   uint256 public constant THIRTY_DAYS = 60 * 60 * 24 * 30;
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   modifier belowCap() {
52     require(totalRaised < hardCap);
53     _;
54   }
55 
56   modifier withinTimeLimit() {
57     require(block.timestamp <= endTimestamp);
58     _;
59   }
60 
61   function Mainsale(address _multisig, uint256 _endTimestamp) {
62     require (_multisig != 0 && _endTimestamp >= (block.timestamp + THIRTY_DAYS));
63     owner = msg.sender;
64     multisig = _multisig;
65     endTimestamp = _endTimestamp;
66   }
67   
68   function() payable belowCap withinTimeLimit {
69     require(msg.value >= MIN_CONTRIBUTION && msg.value <= MAX_CONTRIBUTION);
70     totalRaised = totalRaised.add(msg.value);
71     uint contribution = msg.value;
72     if (totalRaised > hardCap) {
73       uint refundAmount = totalRaised.sub(hardCap);
74       msg.sender.transfer(refundAmount);
75       contribution = contribution.sub(refundAmount);
76       refundAmount = 0;
77       totalRaised = hardCap;
78     }
79     multisig.transfer(contribution);
80   }
81 
82   function withdrawStuck() onlyOwner {
83     multisig.transfer(this.balance);
84   }
85 
86 }