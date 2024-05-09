1 pragma solidity ^0.4.11;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /// @title Loopring Refund Program
48 /// @author Kongliang Zhong - <kongliang@loopring.org>.
49 /// For more information, please visit https://loopring.org.
50 contract BatchTransferContract {
51     using SafeMath for uint;
52     using Math for uint;
53 
54     address public owner;
55 
56     function BatchTransferContract(address _owner) public {
57         owner = _owner;
58     }
59 
60     function () payable {
61         // do nothing.
62     }
63 
64     function batchRefund(address[] investors, uint[] ethAmounts) public payable {
65         require(msg.sender == owner);
66         require(investors.length > 0);
67         require(investors.length == ethAmounts.length);
68 
69         uint total = 0;
70         for (uint i = 0; i < investors.length; i++) {
71             total += ethAmounts[i];
72         }
73 
74         require(total <= this.balance);
75 
76         for (i = 0; i < investors.length; i++) {
77             if (ethAmounts[i] > 0) {
78                 investors[i].transfer(ethAmounts[i]);
79             }
80         }
81     }
82 
83     function drain(uint ethAmount) public payable {
84         require(msg.sender == owner);
85 
86         uint amount = ethAmount.min256(this.balance);
87         if (amount > 0) {
88           owner.transfer(amount);
89         }
90     }
91 }