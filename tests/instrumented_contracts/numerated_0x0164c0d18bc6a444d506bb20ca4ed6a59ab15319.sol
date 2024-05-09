1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     // uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 
61 }
62 
63 contract Bastonet is ERC20Basic, Ownable {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68     string public symbol = "BSN";
69     string public name = "Bastonet";
70     uint8 public decimals = 18;
71     uint256 private totalSupply_ = 5*(10**27);
72     uint256 public fee = 5*(10**18);
73   
74   function Bastonet() public {
75       balances[msg.sender] = totalSupply_;
76   }
77 
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender] && _value <= fee);
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value.sub(fee));
88     balances[owner] = balances[_to].add(fee);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }