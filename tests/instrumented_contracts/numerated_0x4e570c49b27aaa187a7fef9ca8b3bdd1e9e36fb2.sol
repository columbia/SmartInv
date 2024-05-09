1 pragma solidity 0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract HibayexCoin{
34     using SafeMath for uint256;
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 
39     string public constant name = "HibayexCoin";
40     string public constant symbol = "HEC";
41     uint8 public constant decimals = 8;
42 
43     /// The ERC20 total fixed supply of tokens.
44     uint256 public constant totalSupply = 20000000000000000;
45 
46     /// Account balances.
47     mapping(address => uint256) balances;
48 
49     /// The transfer allowances.
50     mapping (address => mapping (address => uint256)) internal allowed;
51 
52     /// The initial distributor is responsible for allocating the supply
53     /// into the various pools described in the whitepaper. This can be
54     /// verified later from the event log.
55     function HECoin(address _distributor) public {
56         balances[_distributor] = totalSupply;
57         Transfer(0x0, _distributor, totalSupply);
58     }
59 
60     /// ERC20 balanceOf().
61     function balanceOf(address _owner) public view returns (uint256) {
62         return balances[_owner];
63     }
64 
65     /// ERC20 transfer().
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69 
70         // SafeMath.sub will throw if there is not enough balance.
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /// ERC20 transferFrom().
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80         require(_value <= balances[_from]);
81         require(_value <= allowed[_from][msg.sender]);
82 
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /// ERC20 approve(). Comes with the standard caveat that an approval
91     /// meant to limit spending may actually allow more to be spent due to
92     /// unfortunate ordering of transactions. For safety, this method
93     /// should only be called if the current allowance is 0. Alternatively,
94     /// non-ERC20 increaseApproval() and decreaseApproval() can be used.
95     function approve(address _spender, uint256 _value) public returns (bool) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     /// ERC20 allowance().
102     function allowance(address _owner, address _spender) public view returns (uint256) {
103         return allowed[_owner][_spender];
104     }
105 
106     /// Not officially ERC20. Allows an allowance to be increased safely.
107     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
108         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110         return true;
111     }
112 
113     /// Not officially ERC20. Allows an allowance to be decreased safely.
114     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
115         uint oldValue = allowed[msg.sender][_spender];
116         if (_subtractedValue > oldValue) {
117             allowed[msg.sender][_spender] = 0;
118         } else {
119             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
120         }
121         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122         return true;
123     }
124 }