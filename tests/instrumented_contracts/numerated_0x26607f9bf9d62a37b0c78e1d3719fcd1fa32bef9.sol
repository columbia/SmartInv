1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4    function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }  
9   function div(uint256 a, uint256 b) internal returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }  
15   function sub(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }  
19   function add(uint256 a, uint256 b) internal returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }  
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }  
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }  
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }  
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36 
37 }
38 
39 
40 
41 contract Ownable {
42   address public owner;  
43   function Ownable() {
44     owner = msg.sender;
45   }  
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }  
50   function transferOwnership(address newOwner) onlyOwner {
51     if (newOwner != address(0)) {
52       owner = newOwner;
53     }
54   }
55 
56 }
57 
58 
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) constant returns (uint256);
62   function transfer(address to, uint256 value) returns(bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value)  returns(bool);
70   function approve(address spender, uint256 value) returns(bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;  mapping(address => uint256) balances;  
77   function transfer(address _to, uint256 _value) returns(bool) {
78     require(_to != address(0));
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }  
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 
89 }
90 
91 contract StandardToken is BasicToken, ERC20 {  
92     mapping (address => mapping (address => uint256)) allowed;  
93   function transferFrom(address _from, address _to, uint256 _value)  returns(bool){
94     require(_to != address(0));
95     var _allowance = allowed[_from][msg.sender];    
96     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
97     // if (_value > _allowance) throw;    
98     balances[_to] = balances[_to].add(_value);
99     balances[_from] = balances[_from].sub(_value);
100     allowed[_from][msg.sender] = _allowance.sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }  
104   function approve(address _spender, uint256 _value) returns(bool) {    // To change the approve amount you first have to reduce the addresses`
105     //  allowance to zero by calling `approve(_spender, 0)` if it is not
106     //  already 0 to mitigate the race condition described here:
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }  
113   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114     return allowed[_owner][_spender];
115   }
116 
117 }
118 
119 
120 
121 contract GoldenFleeceToken is StandardToken, Ownable{
122 
123   string public constant name = "Golden Fleece";
124   string public constant symbol = "GFL";
125   uint256 public constant decimals = 18;
126 
127 
128   /**
129    * @dev Contructor that gives msg.sender all of existing tokens. 
130    */
131   function GoldenFleeceToken(uint256 _total) {
132     totalSupply = _total;
133     balances[owner] = _total;
134   }
135 }