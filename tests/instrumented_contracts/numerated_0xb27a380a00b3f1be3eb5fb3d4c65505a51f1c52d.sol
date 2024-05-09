1 pragma solidity ^0.4.18;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 contract Ownable {
26   address public owner;
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28   function Ownable() public {
29     owner = msg.sender;
30   }
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 contract UpfiringStore is Ownable {
42   using SafeMath for uint;
43   mapping(bytes32 => mapping(address => uint)) private payments;
44   mapping(bytes32 => mapping(address => uint)) private paymentDates;
45   mapping(address => uint) private balances;
46   mapping(address => uint) private totalReceiving;
47   mapping(address => uint) private totalSpending;
48   function UpfiringStore() public {}
49   function balanceOf(address _owner) public view returns (uint balance) {
50     return balances[_owner];
51   }
52   function totalReceivingOf(address _owner) public view returns (uint balance) {
53     return totalReceiving[_owner];
54   }
55   function totalSpendingOf(address _owner) public view returns (uint balance) {
56     return totalSpending[_owner];
57   }
58   function check(bytes32 _hash, address _from, uint _availablePaymentTime) public view returns (uint amount) {
59     uint _amount = payments[_hash][_from];
60     uint _date = paymentDates[_hash][_from];
61     if (_amount > 0 && (_date + _availablePaymentTime) > now) {
62       return _amount;
63     } else {
64       return 0;
65     }
66   }
67   function payment(bytes32 _hash, address _from, uint _amount) onlyOwner public returns (bool result) {
68     payments[_hash][_from] = payments[_hash][_from].add(_amount);
69     paymentDates[_hash][_from] = now;
70     return true;
71   }
72   function subBalance(address _owner, uint _amount) onlyOwner public returns (bool result) {
73     require(balances[_owner] >= _amount);
74     balances[_owner] = balances[_owner].sub(_amount);
75     totalSpending[_owner] = totalSpending[_owner].add(_amount);
76     return true;
77   }
78   function addBalance(address _owner, uint _amount) onlyOwner public returns (bool result) {
79     balances[_owner] = balances[_owner].add(_amount);
80     totalReceiving[_owner] = totalReceiving[_owner].add(_amount);
81     return true;
82   }
83 }