1 pragma solidity ^0.4.18;
2 
3 /*
4   Minsa Coin
5  © International Salt Business
6   Worldwide 
7   2017
8 */
9 
10 library SafeMath {
11   function mul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16   function div(uint a, uint b) internal returns (uint) {
17     assert(b > 0);
18     uint c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22   function sub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43   function assert(bool assertion) internal {
44     if (!assertion) {
45       throw;
46     }
47   }
48 }
49 
50 contract ERC20Basic {
51   uint public totalSupply;
52   function balanceOf(address who) constant returns (uint);
53   function transfer(address to, uint value);
54   event Transfer(address indexed from, address indexed to, uint value);
55 }
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) constant returns (uint);
58   function transferFrom(address from, address to, uint value);
59   function approve(address spender, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 contract newToken is ERC20Basic {
64   
65   using SafeMath for uint;
66   
67   mapping(address => uint) balances;
68   
69 
70   modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80   }
81   function balanceOf(address _owner) constant returns (uint balance) {
82     return balances[_owner];
83   }
84 }
85 
86 contract msc is newToken, ERC20 {
87   mapping (address => mapping (address => uint)) allowed;
88   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
89     var _allowance = allowed[_from][msg.sender];
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // if (_value > _allowance) throw;
92     balances[_to] = balances[_to].add(_value);
93     balances[_from] = balances[_from].sub(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96   }
97   function approve(address _spender, uint _value) {
98     // To change the approve amount you first have to reduce the addresses`
99     //  allowance to zero by calling approve(_spender, 0) if it is not
100     //  already 0 to mitigate the race condition described here:
101     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104   }
105   function allowance(address _owner, address _spender) constant returns (uint remaining) {
106     return allowed[_owner][_spender];
107   }
108 }
109 
110 contract minsacoin is msc {
111   string public constant name = "Minsacoin";
112   string public constant symbol = "MSC";
113   uint public constant decimals = 4;
114   uint256 public initialSupply;
115     
116   function minsacoin () { 
117      totalSupply = 500000000 * 10 ** decimals;
118       balances[0x93E133789f505B939cD959bcA5e0B5b34B70E026] = totalSupply; 
119       initialSupply = totalSupply; 
120         Transfer(0, this, totalSupply);
121         Transfer(this, msg.sender, totalSupply);
122   }
123 }
124 
125 // © International Salt Business