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
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 }
50 
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 }
77 
78 // built upon OpenZeppelin
79 
80 contract Base is BasicToken, Ownable {
81   using SafeMath for uint256;
82   string public constant url = "https://base.very.systems";
83 
84   string public constant name = "Base";
85   string public constant symbol = "BASE";
86   uint256 public constant decimals = 0;
87 
88   uint256 public constant price = 3906250000000000;
89 
90   function () external payable {
91     require(msg.value != 0);
92 
93     uint256 value = msg.value;
94     uint256 amount = value.div(price);
95 
96     totalSupply = totalSupply.add(amount);
97     balances[msg.sender] = balances[msg.sender].add(amount);
98     Transfer(address(0), msg.sender, amount);
99 
100     owner.transfer(msg.value);
101   }
102 
103   uint256 public constant initialSupply = 32768;
104 
105   function Base() public {
106     totalSupply = totalSupply.add(initialSupply);
107     balances[owner] = balances[owner].add(initialSupply);
108     Transfer(address(0), owner, initialSupply);
109   }
110 }