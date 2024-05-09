1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53 
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 contract ERC20Basic {
61   uint256 public totalSupply;
62   function balanceOf(address who) public returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69 }
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   function balanceOf(address _owner) public returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) internal allowed;
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     Transfer(_from, _to, _value);
106     return true;
107   }
108 }
109 
110 contract PausableToken is StandardToken {
111 
112   function transfer(address _to, uint256 _value) public  returns (bool) {
113     return super.transfer(_to, _value);
114   }
115 
116   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
117     return super.transferFrom(_from, _to, _value);
118   }
119 
120 }
121 
122 contract AUVCoin is PausableToken {
123     string public name = "AUV";
124     string public symbol = "AUV";
125     uint public decimals = 18;
126     uint public INITIAL_SUPPLY = 21000000000000000000000000;
127 
128     function AUVCoin() public {
129         totalSupply = INITIAL_SUPPLY;
130         balances[msg.sender] = INITIAL_SUPPLY;
131     }
132 }