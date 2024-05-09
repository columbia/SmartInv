1 pragma solidity 0.4.19;
2 
3 // KSC Token contract based on the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 // Smartcontract for KSC, for more information visit https://www.bysan.com
6 // Symbol: KSC
7 // Status: ERC20 Verified
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract KSANCoin {
37     using SafeMath for uint256;
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 
42     string public constant name = "KSANCoin";
43     string public constant symbol = "KSC";
44     uint8 public constant decimals = 8;
45 
46     /// The ERC20 total fixed supply of tokens.
47     uint256 public constant totalSupply = 100000000 * (10 ** uint256(decimals));
48 										  
49     /// Account balances.
50     mapping(address => uint256) balances;
51 
52     /// The transfer allowances.
53     mapping (address => mapping (address => uint256)) internal allowed;
54 
55     /// The initial distributor is responsible for allocating the supply
56     /// into the various pools described in the white paper. This can be
57     /// verified later from the event log.
58     function KSANCoin(address _distributor) public {
59         balances[_distributor] = totalSupply;
60         Transfer(0x0, _distributor, totalSupply);
61     }
62 
63     /// ERC20 balanceOf().
64     function balanceOf(address _owner) public view returns (uint256) {
65         return balances[_owner];
66     }
67 
68     /// ERC20 transfer().
69     function transfer(address _to, uint256 _value) public returns (bool) {
70         require(_to != address(0));
71         require(_value <= balances[msg.sender]);
72 
73         // SafeMath.sub will throw if there is not enough balance.
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /// ERC20 transferFrom().
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[_from]);
84         require(_value <= allowed[_from][msg.sender]);
85 
86         balances[_from] = balances[_from].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89         Transfer(_from, _to, _value);
90         return true;
91     }
92 
93     /// ERC20 approve(). Comes with the standard caveat that an approval
94     /// meant to limit spending may actually allow more to be spent due to
95     /// unfortunate ordering of transactions. For safety, this method
96     /// should only be called if the current allowance is 0. Alternatively,
97     /// non-ERC20 increaseApproval() and decreaseApproval() can be used.
98     function approve(address _spender, uint256 _value) public returns (bool) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     /// ERC20 allowance().
105     function allowance(address _owner, address _spender) public view returns (uint256) {
106         return allowed[_owner][_spender];
107     }
108 
109     /// Not officially ERC20. Allows an allowance to be increased safely.
110     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
111         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
112         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115 
116     /// Not officially ERC20. Allows an allowance to be decreased safely.
117     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118         uint oldValue = allowed[msg.sender][_spender];
119         if (_subtractedValue > oldValue) {
120             allowed[msg.sender][_spender] = 0;
121         } else {
122             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123         }
124         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125         return true;
126     }
127 }