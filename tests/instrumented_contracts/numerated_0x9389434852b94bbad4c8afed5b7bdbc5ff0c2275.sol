1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal pure returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal pure returns (uint) {
17     require(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal pure returns (uint) {
21     uint c = a + b;
22     require(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 contract ERC20Basic {
40   uint public totalSupply;
41   function balanceOf(address who) public constant returns (uint);
42   function transfer(address to, uint value) public;
43   event Transfer(address indexed from, address indexed to, uint value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public constant returns (uint);
48   function transferFrom(address from, address to, uint value) public;
49   function approve(address spender, uint value) public;
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 contract BasicToken is ERC20Basic {
54   
55   using SafeMath for uint;
56   
57   mapping(address => uint) balances;
58 
59   function transfer(address _to, uint _value) public{
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63   }
64 
65   function balanceOf(address _owner) public constant returns (uint balance) {
66     return balances[_owner];
67   }
68 }
69 
70 
71 contract StandardToken is BasicToken, ERC20 {
72   mapping (address => mapping (address => uint)) allowed;
73 
74   function transferFrom(address _from, address _to, uint _value) public {
75     balances[_to] = balances[_to].add(_value);
76     balances[_from] = balances[_from].sub(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79   }
80 
81   function approve(address _spender, uint _value) public{
82     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
88     return allowed[_owner][_spender];
89   }
90 }
91 
92 
93 contract Ownable {
94     address public owner;
95 
96     function Ownable() public{
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner {
101         require(msg.sender == owner);
102         _;
103     }
104     function transferOwnership(address newOwner) onlyOwner public{
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109 }
110 
111 
112 contract TTC is StandardToken, Ownable {
113   string public constant name = "TTC";
114   string public constant symbol = "TTC";
115   uint public constant decimals = 18;
116 
117 
118   function TTC() public {
119       totalSupply = 1000000000000000000000000000;
120       balances[msg.sender] = totalSupply; // Send all tokens to owner
121   }
122 
123 
124   function burn(uint _value) onlyOwner public returns (bool) {
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     totalSupply = totalSupply.sub(_value);
127     Transfer(msg.sender, 0x0, _value);
128     return true;
129   }
130 
131 }