1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0);
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     uint256 c = a - b;
22     return c;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     require(c >= a);
28     return c;
29   }
30 
31   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b != 0);
33     return a % b;
34   }
35 }
36 
37 contract Token {
38   function totalSupply() pure public returns (uint256 supply);
39   function balanceOf(address _owner) pure public returns (uint256 balance);
40   function transfer(address _to, uint256 _value) public returns (bool success);
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42   function approve(address _spender, uint256 _value) public returns (bool success);
43   function allowance(address _owner, address _spender) pure public returns (uint256 remaining);
44 
45   event Transfer(address indexed _from, address indexed _to, uint256 _value);
46   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48   uint public decimals;
49   string public name;
50 }
51 
52 contract Ownable {
53   address private _owner;
54 
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60   constructor() internal {
61     _owner = msg.sender;
62     emit OwnershipTransferred(address(0), _owner);
63   }
64 
65   function owner() public view returns(address) {
66     return _owner;
67   }
68 
69   modifier onlyOwner() {
70     require(isOwner());
71     _;
72   }
73 
74   function isOwner() public view returns(bool) {
75     return msg.sender == _owner;
76   }
77 
78   function renounceOwnership() public onlyOwner {
79     emit OwnershipTransferred(_owner, address(0));
80     _owner = address(0);
81   }
82 
83   function transferOwnership(address newOwner) public onlyOwner {
84     _transferOwnership(newOwner);
85   }
86 
87   function _transferOwnership(address newOwner) internal {
88     require(newOwner != address(0));
89     emit OwnershipTransferred(_owner, newOwner);
90     _owner = newOwner;
91   }
92 }
93 
94 contract AirDrop is Ownable {
95   address public tokenAddress;
96   Token public token;
97   uint256 public valueAirDrop;
98   mapping (address => uint8) public payedAddress; 
99   constructor() public{
100     tokenAddress = 0x4Ba012f6e411a1bE55b98E9E62C3A4ceb16eC88B;
101     token = Token(tokenAddress); 
102     valueAirDrop = 1e22;
103   } 
104   function sendAirDrop() external payable {
105     require(msg.value == 0);
106     require(payedAddress[msg.sender] == 0);  
107     payedAddress[msg.sender] = 1;  
108     token.transfer(msg.sender, valueAirDrop);
109   }
110 }