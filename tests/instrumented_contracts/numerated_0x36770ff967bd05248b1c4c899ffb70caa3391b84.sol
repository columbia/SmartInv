1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.5.0
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract Bank {
39   using SafeMath for *;
40 
41   uint public totalShares = 0;
42   uint public totalReleased = 0;
43 
44   mapping(address => uint) public shares;
45   mapping(address => uint) public released;
46   address[] public payees;
47 
48   function Bank(address[] _payees, uint[] _shares) public payable {
49     require(_payees.length == _shares.length);
50 
51     for (uint i = 0; i < _payees.length; i++) {
52       addPayee(_payees[i], _shares[i]);
53     }
54   }
55 
56   function addPayee(address _payee, uint _shares) internal {
57     require(_payee != address(0));
58     require(_shares > 0);
59     require(shares[_payee] == 0);
60 
61     payees.push(_payee);
62     shares[_payee] = _shares;
63     totalShares = totalShares.add(_shares);
64   }
65 
66   function claim() public {
67     address payee = msg.sender;
68 
69     require(shares[payee] > 0);
70 
71     uint totalReceived = this.balance.add(totalReleased);
72     uint payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);
73 
74     require(payment != 0);
75     require(this.balance >= payment);
76 
77     released[payee] = released[payee].add(payment);
78     totalReleased = totalReleased.add(payment);
79 
80     payee.transfer(payment);
81   }
82 
83   function () public payable {}
84 }