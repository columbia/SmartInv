1 pragma solidity ^0.4.11;
2 
3 
4 //Math operations with safety checks
5 library SafeMath {
6   function mul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal returns (uint) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) {
48       throw;
49     }
50   }
51 }
52 
53 //creator
54 contract owned{
55     address public Admin;
56     function owned() public {
57         Admin = msg.sender;
58     }
59     modifier onlyAdmin{
60         require(msg.sender == Admin);
61         _;
62     }
63     function transferAdmin(address NewAdmin) onlyAdmin public {
64         Admin = NewAdmin;
65     }
66     
67 }
68 
69 //public
70 contract Erc{
71     using SafeMath for uint;
72     uint public totalSupply;
73     mapping(address => uint) balances;
74     mapping (address => mapping (address => uint)) allowed;
75     mapping (address => bool) public frozenAccount;
76     
77     function balanceOf(address _in) constant returns (uint);
78     function transfer(address _to , uint value);
79     function allowance(address owner, address spender) constant returns (uint);
80     function transferFrom(address from,address to ,uint value);
81     function approve(address spender, uint value);
82     
83     event Approval(address indexed owner, address indexed spender, uint value);
84     event Transfer(address indexed from , address indexed to , uint value);
85      
86     modifier onlyPayloadSize(uint size) {
87     if(msg.data.length < size + 4) {throw;}_;
88     }
89     
90     function _transfer(address _from ,address _to, uint _value) onlyPayloadSize(2 * 32) internal {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     }
95 }
96 
97 //function
98 contract StandardToken is Erc,owned{
99 
100     function balanceOf(address _owner) constant returns (uint balance) {
101     return balances[_owner];
102     }
103     
104     function transfer(address _to, uint256 _value) public {
105     _transfer(msg.sender, _to, _value);
106     }
107   
108     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
109     var _allowance = allowed[_from][msg.sender];
110     balances[_to] = balances[_to].add(_value);
111     balances[_from] = balances[_from].sub(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     }
115     
116     function approve(address _spender, uint _value) {
117     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     }
121     
122     function allowance(address _owner, address _spender) constant returns (uint remaining) {
123     return allowed[_owner][_spender];
124     }
125 }
126 
127 //contract
128 contract SOC is StandardToken {
129     string public name = "SOC Token";
130     string public symbol = "SOC";
131     uint public decimals = 8;
132     uint public INITIAL_SUPPLY = 10000000000000000; // Initial supply is 100,000,000 SOC
133 
134     function SOC(){
135         totalSupply = INITIAL_SUPPLY;
136         balances[msg.sender] = INITIAL_SUPPLY;
137     }
138  
139 }