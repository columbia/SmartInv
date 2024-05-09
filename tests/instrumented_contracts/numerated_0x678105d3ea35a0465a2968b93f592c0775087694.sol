1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
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
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract Ownable {
44     address public owner;
45     function Ownable() {
46         owner = msg.sender;
47     }
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52     function transferOwnership(address newOwner) onlyOwner {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57 }
58 
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) constant returns (uint);
67   function transferFrom(address from, address to, uint value);
68   function approve(address spender, uint value);
69   event Approval(address indexed owner, address indexed spender, uint value);
70 }
71 
72 contract MyToken is ERC20Basic {
73   
74   using SafeMath for uint;
75   
76   mapping(address => uint) balances;
77   
78 
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length < size + 4) {
81        throw;
82      }
83      _;
84   }
85   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89   }
90   function balanceOf(address _owner) constant returns (uint balance) {
91     return balances[_owner];
92   }
93 }
94 contract StandardToken is MyToken, ERC20 {
95   mapping (address => mapping (address => uint)) allowed;
96   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
97     var _allowance = allowed[_from][msg.sender];
98     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
99     // if (_value > _allowance) throw;
100     balances[_to] = balances[_to].add(_value);
101     balances[_from] = balances[_from].sub(_value);
102     allowed[_from][msg.sender] = _allowance.sub(_value);
103     Transfer(_from, _to, _value);
104   }
105   function approve(address _spender, uint _value) {
106     // hello world
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111   }
112   function allowance(address _owner, address _spender) constant returns (uint remaining) {
113     return allowed[_owner][_spender];
114   }
115 }
116 
117 contract BRI is StandardToken, Ownable {
118   string public constant name = "Briant Coin";
119   string public constant symbol = "BRI";
120   uint public constant decimals = 2;
121   // Constructor
122   function BRI () {
123       totalSupply = 30000000 * 100; 
124       balances[msg.sender] = totalSupply; 
125   }
126 }