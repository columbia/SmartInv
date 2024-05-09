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
80 contract Oryza is BasicToken, Ownable {
81 
82   string public constant name = "Oryza";
83   string public constant symbol = "米";
84   uint256 public constant decimals = 0;
85 
86   event Mint(address indexed to, uint256 amount);
87 
88   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
89     totalSupply = totalSupply.add(_amount);
90     balances[_to] = balances[_to].add(_amount);
91     Mint(_to, _amount);
92     Transfer(address(0), _to, _amount);
93     return true;
94   }
95 }
96 
97 contract OryzaOffering is Ownable {
98   using SafeMath for uint256;
99 
100   Oryza public oryza = new Oryza();
101   uint256 public price = 3906250000000000;
102 
103   event Purchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
104 
105   function () external payable {
106     purchase(msg.sender);
107   }
108 
109   function purchase(address beneficiary) public payable {
110     require(beneficiary != address(0) && msg.value != 0);
111 
112     uint256 value = msg.value;
113     uint256 amount = value.div(price);
114 
115     oryza.mint(beneficiary, amount);
116     Purchase(msg.sender, beneficiary, value, amount);
117     owner.transfer(msg.value);
118   }
119 
120   function issue(address beneficiary, uint256 amount) onlyOwner public {
121     require(beneficiary != address(0));
122 
123     oryza.mint(beneficiary, amount);
124   }
125 }