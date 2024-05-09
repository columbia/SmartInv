1 library SafeMath {
2     function mul(uint a, uint b) internal returns (uint) {
3         uint c = a * b;
4         assert(a == 0 || c / a == b);
5         return c;
6     }
7     function div(uint a, uint b) internal returns (uint) {
8         assert(b > 0);
9         uint c = a / b;
10         assert(a == b * c + a % b);
11         return c;
12     }
13     function sub(uint a, uint b) internal returns (uint) {
14         assert(b <= a);
15         return a - b;
16      }
17     function add(uint a, uint b) internal returns (uint) {
18          uint c = a + b;
19          assert(c >= a);
20          return c;
21      }
22     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
23         return a >= b ? a : b;
24      }
25 
26     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27         return a < b ? a : b;
28     }
29 
30     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31         return a >= b ? a : b;
32     }
33 
34     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
35         return a < b ? a : b;
36     }
37 }
38 
39 contract ERC20 {
40     uint public totalSupply = 0;
41 
42     mapping(address => uint256) balances;
43     mapping(address => mapping (address => uint256)) allowed;
44 
45     function balanceOf(address _owner) constant returns (uint);
46     function transfer(address _to, uint _value) returns (bool);
47     function transferFrom(address _from, address _to, uint _value) returns (bool);
48     function approve(address _spender, uint _value) returns (bool);
49     function allowance(address _owner, address _spender) constant returns (uint);
50 
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 
54 }
55 
56 contract TKT  is ERC20 {
57     using SafeMath for uint;
58 
59     string public name = "CryptoTickets COIN";
60     string public symbol = "TKT";
61     uint public decimals = 18;
62 
63     address public ico;
64 
65     event Burn(address indexed from, uint256 value);
66 
67     bool public tokensAreFrozen = true;
68 
69     modifier icoOnly { require(msg.sender == ico); _; }
70 
71     function TKT(address _ico) {
72        ico = _ico;
73     }
74 
75 
76     function mint(address _holder, uint _value) external icoOnly {
77        require(_value != 0);
78        balances[_holder] = balances[_holder].add(_value);
79        totalSupply = totalSupply.add(_value);
80        Transfer(0x0, _holder, _value);
81     }
82 
83 
84     function defrost() external icoOnly {
85        tokensAreFrozen = false;
86     }
87 
88     function burn(uint256 _value) {
89        require(!tokensAreFrozen);
90        balances[msg.sender] = balances[msg.sender].sub(_value);
91        totalSupply = totalSupply.sub(_value);
92        Burn(msg.sender, _value);
93     }
94 
95 
96     function balanceOf(address _owner) constant returns (uint256) {
97          return balances[_owner];
98     }
99 
100 
101     function transfer(address _to, uint256 _amount) returns (bool) {
102         require(!tokensAreFrozen);
103         balances[msg.sender] = balances[msg.sender].sub(_amount);
104         balances[_to] = balances[_to].add(_amount);
105         Transfer(msg.sender, _to, _amount);
106         return true;
107     }
108 
109 
110     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
111         require(!tokensAreFrozen);
112         balances[_from] = balances[_from].sub(_amount);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
114         balances[_to] = balances[_to].add(_amount);
115         Transfer(_from, _to, _amount);
116         return true;
117      }
118 
119 
120     function approve(address _spender, uint256 _amount) returns (bool) {
121         // To change the approve amount you first have to reduce the addresses`
122         //  allowance to zero by calling `approve(_spender, 0)` if it is not
123         //  already 0 to mitigate the race condition described here:
124         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
126 
127         allowed[msg.sender][_spender] = _amount;
128         Approval(msg.sender, _spender, _amount);
129         return true;
130     }
131 
132 
133     function allowance(address _owner, address _spender) constant returns (uint256) {
134         return allowed[_owner][_spender];
135     }
136 }