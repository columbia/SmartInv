1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal pure returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint a, uint b) internal pure returns (uint) {
11         uint c = a / b;
12         return c;
13     }
14 
15     function sub(uint a, uint b) internal pure returns (uint) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint a, uint b) internal pure returns (uint) {
21         uint c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract ERC20Basic {
28     uint public totalSupply;
29     function balanceOf(address who) public view returns (uint);
30     function transfer(address to, uint value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint value);
32 }
33 
34 contract BasicToken is ERC20Basic {
35     using SafeMath for uint;
36 
37     mapping(address => uint) balances;
38 
39     function transfer(address _to, uint _value) public returns (bool) {
40         require(_to != address(0));
41         require(_value <= balances[msg.sender]);
42 
43         balances[msg.sender] = balances[msg.sender].sub(_value);
44         balances[_to] = balances[_to].add(_value);
45         emit Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     function balanceOf(address _owner) public view returns (uint balance) {
50         return balances[_owner];
51     }
52 
53 }
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public view returns (uint);
57 
58     function transferFrom(address from, address to, uint value) public returns (bool);
59 
60     function approve(address spender, uint value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint value);
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66     mapping (address => mapping (address => uint)) allowed;
67 
68     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
69         require(_to != address(0));
70 
71         uint _allowance = allowed[_from][msg.sender];
72 
73         require (_value <= _allowance);
74         require(_value > 0);
75 
76         balances[_from] = balances[_from].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         allowed[_from][msg.sender] = _allowance.sub(_value);
79         emit Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint _value) public returns (bool) {
84         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
85 
86         allowed[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public view returns (uint remaining) {
92         return allowed[_owner][_spender];
93     }
94 
95     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
96         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99     }
100 
101     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
102         uint oldValue = allowed[msg.sender][_spender];
103         if (_subtractedValue > oldValue) {
104             allowed[msg.sender][_spender] = 0;
105         } else {
106             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107         }
108         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109         return true;
110     }
111 
112 }
113 
114 contract GOENT is StandardToken {
115 
116     string public constant name = "GOEN TOKEN";
117     string public constant symbol = "GOENT";
118     uint   public constant decimals = 8;
119     uint   public constant INITIAL_SUPPLY =  10000000000 * (10 ** decimals); 
120 
121     constructor() public { 
122         totalSupply = INITIAL_SUPPLY;
123         balances[msg.sender] = INITIAL_SUPPLY;
124     }
125 }