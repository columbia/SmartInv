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
32 contract ERC20 {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 contract Ownable {
41   address public owner;
42 
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     owner = newOwner;
55   }
56 }
57 
58 contract Luxecoin is ERC20, Ownable {
59   using SafeMath for uint256;
60 
61   string public name = "LuxeCoin";
62   string public symbol = "LXC";
63   uint8 public constant decimals = 18;
64   uint256 public constant initial_supply = 220000000 * (10 ** uint256(decimals));
65 
66   mapping (address => uint256) balances;
67 
68   uint256 totalSupply_;
69   
70   constructor() public {
71     owner = msg.sender;
72     totalSupply_ = initial_supply;
73     balances[owner] = initial_supply;
74     emit Transfer(0x0, owner, initial_supply);
75   }
76 
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80   
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     uint256 _balance = balances[msg.sender];
83     require(_value <= _balance);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87 
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95   
96   function transferMany(address[] recipients, uint256[] values) public {
97     for (uint256 i = 0; i < recipients.length; i++) {
98       require(balances[msg.sender] >= values[i]);
99       balances[msg.sender] = balances[msg.sender].sub(values[i]);
100       balances[recipients[i]] = balances[recipients[i]].add(values[i]);
101       emit Transfer(msg.sender, recipients[i], values[i]);
102     }
103   }
104 }