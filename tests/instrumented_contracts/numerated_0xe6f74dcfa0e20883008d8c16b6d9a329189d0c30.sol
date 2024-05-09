1 pragma solidity ^0.4.15;
2 /* Briantbros Lima Kpy*/
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a < b ? a : b;
36   }
37   function assert(bool assertion) internal {
38     if (!assertion) {
39       throw;
40     }
41   }
42 }
43 
44 contract Ownable {
45     address public owner;
46     function Ownable() {
47         owner = msg.sender;
48     }
49     modifier onlyOwner {
50         if (msg.sender != owner) throw;
51         _;
52     }
53     function transferOwnership(address newOwner) onlyOwner {
54         if (newOwner != address(0)) {
55             owner = newOwner;
56         }
57     }
58 }
59 
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) constant returns (uint);
68   function transferFrom(address from, address to, uint value);
69   function approve(address spender, uint value);
70   event Approval(address indexed owner, address indexed spender, uint value);
71 }
72 
73 contract Token is ERC20Basic {
74   
75   using SafeMath for uint;
76   
77   mapping(address => uint) balances;
78   
79 
80   modifier onlyPayloadSize(uint size) {
81      if(msg.data.length < size + 4) {
82        throw;
83      }
84      _;
85   }
86   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90   }
91   function balanceOf(address _owner) constant returns (uint balance) {
92     return balances[_owner];
93   }
94 }
95 
96 contract FinTechCoin is Token, ERC20 {
97   mapping (address => mapping (address => uint)) allowed;
98   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
99     var _allowance = allowed[_from][msg.sender];
100     balances[_to] = balances[_to].add(_value);
101     balances[_from] = balances[_from].sub(_value);
102     allowed[_from][msg.sender] = _allowance.sub(_value);
103     Transfer(_from, _to, _value);
104   }
105   function approve(address _spender, uint _value) {
106     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
107     allowed[msg.sender][_spender] = _value;
108     Approval(msg.sender, _spender, _value);
109   }
110   function allowance(address _owner, address _spender) constant returns (uint remaining) {
111     return allowed[_owner][_spender];
112   }
113 }
114 
115 contract FTC is FinTechCoin, Ownable {
116   string public constant name = "FinTech Coin";
117   string public constant symbol = "FTC";
118   uint public constant decimals = 2;
119   uint256 public initialSupply;
120     
121   function FTC () { 
122      totalSupply = 365000000 * 10 ** decimals;
123       balances[msg.sender] = totalSupply;
124       initialSupply = totalSupply; 
125         Transfer(0, this, totalSupply);
126         Transfer(this, msg.sender, totalSupply);
127   }
128 }