1 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
2 ///  later changed
3 contract Owned {
4 
5     /// @dev `owner` is the only address that can call a function with this
6     /// modifier
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     address public owner;
13 
14     /// @notice The Constructor assigns the message sender to be `owner`
15     function Owned() {
16         owner = msg.sender;
17     }
18 
19     address public newOwner;
20 
21     /// @notice `owner` can step down and assign some other address to this role
22     /// @param _newOwner The address of the new owner. 0x0 can be used to create
23     function changeOwner(address _newOwner) onlyOwner {
24         if(msg.sender == owner) {
25             owner = _newOwner;
26         }
27     }
28 }
29 
30 
31 
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37   function mul(uint a, uint b) internal returns (uint) {
38     uint c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint a, uint b) internal returns (uint) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint a, uint b) internal returns (uint) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint a, uint b) internal returns (uint) {
56     uint c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
62     return a >= b ? a : b;
63   }
64 
65   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
66     return a < b ? a : b;
67   }
68 
69   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
70     return a >= b ? a : b;
71   }
72 
73   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
74     return a < b ? a : b;
75   }
76 }
77 
78 
79 contract AccountOwnership is Owned {
80   using SafeMath for uint256;
81   
82   mapping (address => uint256) public transfers;
83   address public depositAddress;
84   
85   event RefundTransfer(uint256 date, uint256 paid, uint256 refunded, address user);
86   
87   function AccountOwnership() payable {
88   }
89 
90   function withdrawEther (address _to) onlyOwner {
91     _to.transfer(this.balance);
92   }
93 
94   function setDepositAddress(address _depositAddress) onlyOwner {
95     depositAddress = _depositAddress;
96   }
97 
98   function ()  payable {
99     require(msg.value > 0);
100     if (depositAddress != msg.sender) {
101       transfers[msg.sender] = msg.value;
102       msg.sender.transfer(msg.value);
103       RefundTransfer(now, msg.value, msg.value, msg.sender);
104     }
105   }
106 }