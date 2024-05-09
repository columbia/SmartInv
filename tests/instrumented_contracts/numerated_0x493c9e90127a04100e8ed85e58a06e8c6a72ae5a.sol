1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC20Basic {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function transfer(address to, uint value);
55   event Transfer(address indexed from, address indexed to, uint value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) constant returns (uint);
60   function transferFrom(address from, address to, uint value);
61   function approve(address spender, uint value);
62   event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint;
67 
68   mapping(address => uint) balances;
69 
70   modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76 
77   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81   }
82 
83   function balanceOf(address _owner) constant returns (uint balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 contract StandardToken is BasicToken, ERC20 {
90 
91   mapping (address => mapping (address => uint)) allowed;
92 
93   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
94     var _allowance = allowed[_from][msg.sender];
95     balances[_to] = balances[_to].add(_value);
96     balances[_from] = balances[_from].sub(_value);
97     allowed[_from][msg.sender] = _allowance.sub(_value);
98     Transfer(_from, _to, _value);
99   }
100 
101 
102   function approve(address _spender, uint _value) {
103     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
104     allowed[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106   }
107 
108   function allowance(address _owner, address _spender) constant returns (uint remaining) {
109     return allowed[_owner][_spender];
110   }
111 }
112 
113 contract AOB is StandardToken{
114     string public constant name = "Assets On Blockchain";
115     string public constant symbol = "AOB";
116     uint public constant decimals = 18;
117     string public constant version = "1.0";
118     address public owner;
119     modifier onlyOwner{
120       if(msg.sender != owner) throw;
121       _;
122     } 
123     function AOB(){
124         owner = msg.sender;
125         totalSupply = 100*(10**8)*(10**decimals);
126         balances[owner] =  totalSupply;
127     }
128 
129     function changeOwner(address newOwner) onlyOwner{
130       owner = newOwner;
131     }
132 
133     function () payable{
134         throw;
135     }
136 
137     function kill() onlyOwner{
138         suicide(owner);
139     }
140 }