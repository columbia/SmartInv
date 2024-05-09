1 pragma solidity ^0.4.13;
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
32 contract EnjinGiveaway {
33   using SafeMath for uint256;
34 
35   uint256 public totalShares = 1400000;
36   uint256 public totalReleased = 0;
37 
38   mapping(address => uint256) public shares;
39   mapping(address => uint256) public released;
40   address[] public payees;
41   address public owner;
42   address public tokenContract;
43   
44   /**
45    * @dev Constructor
46    */
47   function EnjinGiveaway() public {
48     owner = msg.sender;
49     tokenContract = 0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c;
50   }
51 
52   /**
53    * @dev Add a new payee to the contract.
54    * @param _payee The address of the payee to add.
55    * @param _shares The number of shares owned by the payee.
56    */
57   function addPayee(address _payee, uint256 _shares) internal {
58     require(_payee != address(0));
59     require(_shares > 0);
60     require(shares[_payee] == 0);
61 
62     payees.push(_payee);
63     shares[_payee] = _shares;
64   }
65   
66   function () payable {
67       require(totalReleased < totalShares);
68       uint256 amount = msg.value;
69       uint256 payeeShares = amount * 7000 / 1e18;
70       totalReleased = totalReleased + payeeShares;
71       addPayee(msg.sender, payeeShares);
72       owner.transfer(msg.value);
73   }
74 
75   function creditTokens() public {
76     require(msg.sender == owner);
77     
78     for (uint i=0; i < payees.length; i++) {
79         tokenContract.call(bytes4(sha3("transferFrom(address,address,uint256)")), this, payees[i], shares[payees[i]]);
80     }
81   }    
82 }