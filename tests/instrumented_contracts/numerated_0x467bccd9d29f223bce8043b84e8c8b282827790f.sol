1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Telcoin {
36     using SafeMath for uint256;
37 
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 
41     string public constant name = "Telcoin";
42     string public constant symbol = "TEL";
43     uint8 public constant decimals = 2;
44 
45     /// The ERC20 total fixed supply of tokens.
46     uint256 public constant totalSupply = 100000000000 * (10 ** uint256(decimals));
47 
48     /// Account balances.
49     mapping(address => uint256) balances;
50 
51     /// The transfer allowances.
52     mapping (address => mapping (address => uint256)) internal allowed;
53 
54     /// The initial distributor is responsible for allocating the supply
55     /// into the various pools described in the whitepaper. This can be
56     /// verified later from the event log.
57     function Telcoin(address _distributor) public {
58         balances[_distributor] = totalSupply;
59         Transfer(0x0, _distributor, totalSupply);
60     }
61 
62     /// ERC20 balanceOf().
63     function balanceOf(address _owner) public view returns (uint256) {
64         return balances[_owner];
65     }
66 
67     /// ERC20 transfer().
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71 
72         // SafeMath.sub will throw if there is not enough balance.
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /// ERC20 transferFrom().
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[_from]);
83         require(_value <= allowed[_from][msg.sender]);
84 
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /// ERC20 approve(). Comes with the standard caveat that an approval
93     /// meant to limit spending may actually allow more to be spent due to
94     /// unfortunate ordering of transactions. For safety, this method
95     /// should only be called if the current allowance is 0. Alternatively,
96     /// non-ERC20 increaseApproval() and decreaseApproval() can be used.
97     function approve(address _spender, uint256 _value) public returns (bool) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     /// ERC20 allowance().
104     function allowance(address _owner, address _spender) public view returns (uint256) {
105         return allowed[_owner][_spender];
106     }
107 
108     /// Not officially ERC20. Allows an allowance to be increased safely.
109     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 
115     /// Not officially ERC20. Allows an allowance to be decreased safely.
116     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
117         uint oldValue = allowed[msg.sender][_spender];
118         if (_subtractedValue > oldValue) {
119             allowed[msg.sender][_spender] = 0;
120         } else {
121             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122         }
123         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 }