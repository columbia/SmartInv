1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function div(uint a, uint b) internal returns (uint) {
5         assert(b > 0);
6         uint c = a / b;
7         assert(a == b * c + a % b);
8         return c;
9     }
10     function sub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13      }
14     function add(uint a, uint b) internal returns (uint) {
15          uint c = a + b;
16          assert(c >= a);
17          return c;
18      }
19 }
20 
21 
22 contract ERC20 {
23     uint public totalSupply = 0;
24 
25     mapping(address => uint256) balances;
26     mapping(address => mapping (address => uint256)) allowed;
27 
28     function balanceOf(address _owner) constant returns (uint);
29     function transfer(address _to, uint _value) returns (bool);
30     function transferFrom(address _from, address _to, uint _value) returns (bool);
31     function approve(address _spender, uint _value) returns (bool);
32     function allowance(address _owner, address _spender) constant returns (uint);
33 
34     event Transfer(address indexed _from, address indexed _to, uint _value);
35     event Approval(address indexed _owner, address indexed _spender, uint _value);
36 
37 } // Functions of ERC20 standard
38 
39 contract ERT  is ERC20 {
40     using SafeMath for uint;
41 
42     string public name = "Eristica TOKEN";
43     string public symbol = "ERT";
44     uint public decimals = 18;
45 
46     address public ico;
47 
48     event Burn(address indexed from, uint256 value);
49 
50     bool public tokensAreFrozen = true;
51 
52     modifier icoOnly { require(msg.sender == ico); _; }
53 
54     function ERT(address _ico) {
55        ico = _ico;
56     }
57 
58 
59     function mint(address _holder, uint _value) external icoOnly {
60        require(_value != 0);
61        balances[_holder] = balances[_holder].add(_value);
62        totalSupply = totalSupply.add(_value);
63        Transfer(0x0, _holder, _value);
64     }
65 
66 
67     function defrost() external icoOnly {
68        tokensAreFrozen = false;
69     }
70 
71     function burn(uint256 _value) {
72        require(!tokensAreFrozen);
73        balances[msg.sender] = balances[msg.sender].sub(_value);
74        totalSupply = totalSupply.sub(_value);
75        Burn(msg.sender, _value);
76     }
77 
78 
79     function balanceOf(address _owner) constant returns (uint256) {
80          return balances[_owner];
81     }
82 
83 
84     function transfer(address _to, uint256 _amount) returns (bool) {
85         require(!tokensAreFrozen);
86         balances[msg.sender] = balances[msg.sender].sub(_amount);
87         balances[_to] = balances[_to].add(_amount);
88         Transfer(msg.sender, _to, _amount);
89         return true;
90     }
91 
92 
93     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
94         require(!tokensAreFrozen);
95         balances[_from] = balances[_from].sub(_amount);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
97         balances[_to] = balances[_to].add(_amount);
98         Transfer(_from, _to, _amount);
99         return true;
100      }
101 
102 
103     function approve(address _spender, uint256 _amount) returns (bool) {
104         // To change the approve amount you first have to reduce the addresses`
105         //  allowance to zero by calling `approve(_spender, 0)` if it is not
106         //  already 0 to mitigate the race condition described here:
107         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
109 
110         allowed[msg.sender][_spender] = _amount;
111         Approval(msg.sender, _spender, _amount);
112         return true;
113     }
114 
115 
116     function allowance(address _owner, address _spender) constant returns (uint256) {
117         return allowed[_owner][_spender];
118     }
119 }