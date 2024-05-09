1 pragma solidity ^0.4.21;
2 
3 contract ERC223ReceivingContract {
4    function tokenFallback(address _from, uint _value, bytes _data) public;
5 }
6 
7 interface ERC20 {
8    function balanceOf(address who) public view returns (uint256);
9    function transfer(address to, uint256 value) public returns (bool);
10    function allowance(address owner, address spender) public view returns (uint256);
11    function transferFrom(address from, address to, uint256 value) public returns (bool);
12    function approve(address spender, uint256 value) public returns (bool);
13    event Transfer(address indexed from, address indexed to, uint256 value);
14    event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface ERC223 {
18    function transfer(address to, uint value, bytes data) public;
19    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
20 }
21 
22 
23 
24 library SafeMath {
25    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26        if (a == 0) {
27            return 0;
28        }
29        uint256 c = a * b;
30        assert(c / a == b);
31        return c;
32    }
33 
34    function div(uint256 a, uint256 b) internal pure returns (uint256) {
35        // assert(b > 0); // Solidity automatically throws when dividing by 0
36        uint256 c = a / b;
37        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38        return c;
39    }
40 
41    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42        assert(b <= a);
43        return a - b;
44    }
45 
46    function add(uint256 a, uint256 b) internal pure returns (uint256) {
47        uint256 c = a + b;
48        assert(c >= a);
49        return c;
50    }
51 }
52 
53 contract StandardToken is ERC20, ERC223 {
54    using SafeMath for uint;
55 
56    string internal _name;
57    string internal _symbol;
58    uint8 internal _decimals;
59    uint256 internal _totalSupply;
60 
61    mapping (address => uint256) internal balances;
62    mapping (address => mapping (address => uint256)) internal allowed;
63 
64    function StandardToken() public {
65        _name = "SwingBiCoin";                                   // Set the name for display purposes
66        _decimals = 18;                            // Amount of decimals for display purposes
67        _symbol = "SWBI";                               // Set the symbol for display purposes
68        _totalSupply = 700000000000000000000000000;                        // Update total supply (100000 for example)
69        balances[msg.sender] = 700000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
70    }
71 
72    function name()
73    public
74    view
75    returns (string) {
76        return _name;
77    }
78 
79    function symbol()
80    public
81    view
82    returns (string) {
83        return _symbol;
84    }
85 
86    function decimals()
87    public
88    view
89    returns (uint8) {
90        return _decimals;
91    }
92 
93    function totalSupply()
94    public
95    view
96    returns (uint256) {
97        return _totalSupply;
98    }
99 
100    function transfer(address _to, uint256 _value) public returns (bool) {
101        require(_to != address(0));
102        require(_value <= balances[msg.sender]);
103        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
104        balances[_to] = SafeMath.add(balances[_to], _value);
105        Transfer(msg.sender, _to, _value);
106        return true;
107    }
108 
109    function transfer(address _to, uint _value, bytes _data) public {
110        require(_value > 0 );
111        if(isContract(_to)) {
112            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
113            receiver.tokenFallback(msg.sender, _value, _data);
114        }
115        balances[msg.sender] = balances[msg.sender].sub(_value);
116        balances[_to] = balances[_to].add(_value);
117        Transfer(msg.sender, _to, _value, _data);
118    }
119 
120    function isContract(address _addr) private returns (bool is_contract) {
121        uint length;
122        assembly {
123        //retrieve the size of the code on target address, this needs assembly
124            length := extcodesize(_addr)
125        }
126        return (length>0);
127    }
128 
129    function balanceOf(address _owner) public view returns (uint256 balance) {
130        return balances[_owner];
131    }
132 
133    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134        require(_to != address(0));
135        require(_value <= balances[_from]);
136        require(_value <= allowed[_from][msg.sender]);
137 
138        balances[_from] = SafeMath.sub(balances[_from], _value);
139        balances[_to] = SafeMath.add(balances[_to], _value);
140        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
141        Transfer(_from, _to, _value);
142        return true;
143    }
144 
145    function approve(address _spender, uint256 _value) public returns (bool) {
146        allowed[msg.sender][_spender] = _value;
147        Approval(msg.sender, _spender, _value);
148        return true;
149    }
150 
151    function allowance(address _owner, address _spender) public view returns (uint256) {
152        return allowed[_owner][_spender];
153    }
154 
155    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
157        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158        return true;
159    }
160 
161    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162        uint oldValue = allowed[msg.sender][_spender];
163        if (_subtractedValue > oldValue) {
164            allowed[msg.sender][_spender] = 0;
165        } else {
166            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
167        }
168        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169        return true;
170    }
171 }