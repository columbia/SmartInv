1 pragma solidity ^0.4.18;
2 
3 /*
4   в’ё  VENUS
5     2017
6 */
7 
8 
9 contract ERC20Basic {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function transfer(address to, uint value);
13   event Transfer(address indexed from, address indexed to, uint value);
14 }
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) constant returns (uint);
17   function transferFrom(address from, address to, uint value);
18   function approve(address spender, uint value);
19   event Approval(address indexed owner, address indexed spender, uint value);
20 }
21 
22 
23 library SafeMath {
24   function mul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29   function div(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35   function sub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39   function add(uint a, uint b) internal returns (uint) {
40     uint c = a + b;
41     assert(c >= a);
42     return c;
43   }
44   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a >= b ? a : b;
46   }
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a >= b ? a : b;
52   }
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56   function assert(bool assertion) internal {
57     if (!assertion) {
58       throw;
59     }
60   }
61 }
62 
63 contract newToken is ERC20Basic {
64   using SafeMath for uint;
65   mapping(address => uint) balances;
66   modifier onlyPayloadSize(uint size) {
67      if(msg.data.length < size + 4) {
68        throw;
69      }
70      _;
71   }
72   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76   }
77   function balanceOf(address _owner) constant returns (uint balance) {
78     return balances[_owner];
79   }
80 }
81 
82 contract VENUStoken is newToken, ERC20 {
83   mapping (address => mapping (address => uint)) allowed;
84   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
85     var _allowance = allowed[_from][msg.sender];
86     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
87     // if (_value > _allowance) throw;
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92   }
93   function approve(address _spender, uint _value) {
94     // To change the approve amount you first have to reduce the addresses`
95     //  allowance to zero by calling approve(_spender, 0) if it is not
96     //  already 0 to mitigate the race condition described here:
97     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
98     allowed[msg.sender][_spender] = _value;
99     Approval(msg.sender, _spender, _value);
100   }
101   function allowance(address _owner, address _spender) constant returns (uint remaining) {
102     return allowed[_owner][_spender];
103   }
104 }
105     
106 contract VENUS is VENUStoken {
107   string public constant name = "VENUS";
108   string public constant symbol = "VENUS";
109   uint public constant decimals = 3;
110   uint256 public initialSupply;
111     
112   function VENUS() { 
113      totalSupply = 80000000000 * 10 ** decimals;
114       balances[msg.sender] = totalSupply;
115       initialSupply = totalSupply; 
116         Transfer(0, this, totalSupply);
117         Transfer(this, msg.sender, totalSupply);
118   }
119 }