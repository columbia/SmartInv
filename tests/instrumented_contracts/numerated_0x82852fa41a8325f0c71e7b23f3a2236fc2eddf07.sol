1 pragma solidity ^0.4.24;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 ///@title Dremabridge Payment contract
45 ///@author Arq
46 ///@notice Simple payment contract that checks an address for an "Operating Threshold" which is a set balance of ether, the remaining balance to another Address called Cold Storage.
47 
48 contract paymentContract {
49 
50     using SafeMath for uint256;
51 
52     address operatingAddress;
53     address coldStorage;
54 
55     uint public opThreshold;
56     
57 ///@author Arq
58 ///@notice Constructor function determines the payment parties and threshold.
59 ///@param _operatingAddress - The Address that will be refilled by payments to this contract.
60 ///@param _coldStorage - The Address of the Cold Storage wallet, where overflow funds are sent.
61 ///@param _threshold - The level to which this contract will replenish the funds in the operatingAddress wallet.
62     constructor(address _operatingAddress, address _coldStorage, uint _threshold) public {
63         operatingAddress = _operatingAddress;
64         coldStorage = _coldStorage;
65         opThreshold = _threshold * 1 ether;
66     }
67 ///@author Arq
68 ///@notice The Fallback Function that accepts payments.
69 ///@dev Contract can be used as a payment source.
70     function () public payable {
71         distribute();
72     }
73 
74     ///@author Arq
75     ///@notice Function that sends funds to either Cold Storage, Operating Address, or both based on the Operating Threshold.
76     ///@dev opThreshold determines what the balance in the operatingAddress should be, at a minimum.
77         function distribute() internal {
78             if(operatingAddress.balance < opThreshold) {
79                 if(address(this).balance < (opThreshold - operatingAddress.balance)){
80                     operatingAddress.transfer(address(this).balance);
81                 } else {
82                     operatingAddress.transfer(opThreshold - operatingAddress.balance);
83                     coldStorage.transfer(address(this).balance);
84                 }
85             } else {
86                 coldStorage.transfer(address(this).balance);
87             }
88         }
89 }