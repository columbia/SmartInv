1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns(uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256){
12     if(a==0){
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256){
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256){
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41   mapping(address => uint256) internal balances;
42   uint256 internal totalSupply_;
43   
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function transfer (address _to, uint256 _value) public returns (bool){
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns(uint256 balance){
60     return balances[_owner];
61   }
62 }
63 
64 contract BurnableToken is BasicToken {
65   event Burn(address indexed burner, uint256 value);
66 
67   function burn(uint256 _value) public {
68     _burn(msg.sender, _value);
69   }
70 
71   function _burn(address _who, uint256 _value) internal {
72     require(_value <= balances[_who]);
73     balances[_who] = balances[_who].sub(_value);
74     totalSupply_ = totalSupply_.sub(_value);
75     
76     emit Burn(_who, _value);
77     emit Transfer(_who, address(0), _value);
78   }
79 }
80 
81 contract DRToken is BurnableToken {
82   string public constant name = "DrawingRun";
83   string public constant symbol = "DR";
84   uint8 public constant decimals = 18;
85   uint256 public totalSupply;
86 
87   constructor() public{
88     totalSupply = 30000000000 * 10**uint256(decimals);
89     balances[msg.sender] = totalSupply;
90   }
91 }