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
53 
54 
55 contract BasicToken is ERC20Basic {
56   
57   using SafeMath for uint;
58   
59   mapping(address => uint) balances;
60 
61   function transfer(address _to, uint _value) public{
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65   }
66 
67   function balanceOf(address _owner) public constant returns (uint balance) {
68     return balances[_owner];
69   }
70 }
71 
72 
73 contract StandardToken is BasicToken, ERC20 {
74   mapping (address => mapping (address => uint)) allowed;
75 
76   function transferFrom(address _from, address _to, uint _value) public {
77     balances[_to] = balances[_to].add(_value);
78     balances[_from] = balances[_from].sub(_value);
79     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
80     Transfer(_from, _to, _value);
81   }
82 
83   function approve(address _spender, uint _value) public{
84     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
85     allowed[msg.sender][_spender] = _value;
86     Approval(msg.sender, _spender, _value);
87   }
88 
89   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
90     return allowed[_owner][_spender];
91   }
92 }
93 
94 contract Ownable {
95     address public owner;
96 
97     function Ownable() public{
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner {
102         require(msg.sender == owner);
103         _;
104     }
105     function transferOwnership(address newOwner) onlyOwner public{
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110 }
111 
112 
113 /**
114  *  TTC token contract. Implements
115  */
116 contract TTC is StandardToken, Ownable {
117   string public constant name = "TTC";
118   string public constant symbol = "TTC";
119   uint public constant decimals = 18;
120 
121 
122   // Constructor
123   function TTC() public {
124       totalSupply = 1000000000000000000000000000;
125       balances[msg.sender] = totalSupply; // Send all tokens to owner
126   }
127 
128   /**
129    *  Burn away the specified amount of SkinCoin tokens
130    */
131   function burn(uint _value) onlyOwner public returns (bool) {
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     totalSupply = totalSupply.sub(_value);
134     Transfer(msg.sender, 0x0, _value);
135     return true;
136   }
137 
138 }