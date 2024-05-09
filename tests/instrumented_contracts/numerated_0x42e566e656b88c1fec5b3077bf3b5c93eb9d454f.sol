1 pragma solidity ^0.4.24;
2 
3 contract MultiSend {
4 
5   struct Receiver {
6     address addr;
7     uint amount;
8   }
9 
10   event MultiTransfer (
11     address from,
12     uint total,
13     Receiver[] receivers
14   );
15 
16   address owner;
17 
18   constructor () public {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     require(owner == msg.sender, "msg sender is not owner!");
24     _;
25   }
26 
27   function close() public onlyOwner {
28     selfdestruct(owner);
29   }
30 
31   function _safeTransfer(address _to, uint _amount) internal {
32       require(_to != 0);
33       _to.transfer(_amount);
34   }
35 
36   function multiTransfer(address[] _addresses, uint[] _amounts)
37     payable public returns(bool)
38   {
39       require(_addresses.length == _amounts.length);
40       Receiver[] memory receivers = new Receiver[](_addresses.length);
41       uint toReturn = msg.value;
42       for (uint i = 0; i < _addresses.length; i++) {
43           _safeTransfer(_addresses[i], _amounts[i]);
44           toReturn = SafeMath.sub(toReturn, _amounts[i]);
45           receivers[i].addr = _addresses[i];
46           receivers[i].amount = _amounts[i]; 
47       }
48       emit MultiTransfer(msg.sender, msg.value, receivers);
49       return true;
50   }
51 }
52 
53 library SafeMath
54 {
55   /**
56   * @dev Multiplies two numbers, reverts on overflow.
57   */
58   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60     // benefit is lost if 'b' is also tested.
61     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62     if (_a == 0) {
63       return 0;
64     }
65 
66     uint256 c = _a * _b;
67     require(c / _a == _b);
68 
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
74   */
75   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     require(_b > 0); // Solidity only automatically asserts when dividing by 0
77     uint256 c = _a / _b;
78     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
79 
80     return c;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
87     require(_b <= _a);
88     uint256 c = _a - _b;
89 
90     return c;
91   }
92 
93   /**
94   * @dev Adds two numbers, reverts on overflow.
95   */
96   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
97     uint256 c = _a + _b;
98     require(c >= _a);
99 
100     return c;
101   }
102 
103   /**
104   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
105   * reverts when dividing by zero.
106   */
107   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b != 0);
109     return a % b;
110   }
111 }