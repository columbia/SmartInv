1 pragma solidity ^0.4.21;
2 
3 interface ERC20 {
4    function balanceOf(address who) public view returns (uint256);
5    function transfer(address to, uint256 value) public returns (bool);
6    function allowance(address owner, address spender) public view returns (uint256);
7    function transferFrom(address from, address to, uint256 value) public returns (bool);
8    function approve(address spender, uint256 value) public returns (bool);
9    event Transfer(address indexed from, address indexed to, uint256 value);
10    event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 
14 library SafeMath {
15    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16        if (a == 0) {
17            return 0;
18        }
19        uint256 c = a * b;
20        assert(c / a == b);
21        return c;
22    }
23 
24    function div(uint256 a, uint256 b) internal pure returns (uint256) {
25        // assert(b > 0); // Solidity automatically throws when dividing by 0
26        uint256 c = a / b;
27        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28        return c;
29    }
30 
31    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32        assert(b <= a);
33        return a - b;
34    }
35 
36    function add(uint256 a, uint256 b) internal pure returns (uint256) {
37        uint256 c = a + b;
38        assert(c >= a);
39        return c;
40    }
41 }
42 
43 contract StandardToken is ERC20 {
44    using SafeMath for uint;
45 
46    string  internal _name;
47    string  internal _symbol;
48    uint8   internal _decimals;
49    uint256 internal _totalSupply;
50 
51    mapping (address => uint256) internal balances;
52    mapping (address => mapping (address => uint256)) internal allowed;
53 
54    function StandardToken() public {
55        _name = "ANIVERSE";                                  // Set the name
56        _decimals = 18;                                      // Amount of decimals for display purposes
57        _symbol = "ANV";                                     // Set the symbol for display purposes
58        _totalSupply = 3000000000000000000000000000;         // Update total supply 
59        balances[msg.sender] = 3000000000000000000000000000;  // Give the creator all initial tokens (100000 for example)       
60    }
61 
62    function name()
63    public
64    view
65    returns (string) {
66        return _name;
67    }
68 
69    function symbol()
70    public
71    view
72    returns (string) {
73        return _symbol;
74    }
75 
76    function decimals()
77    public
78    view
79    returns (uint8) {
80        return _decimals;
81    }
82 
83    function totalSupply()
84    public
85    view
86    returns (uint256) {
87        return _totalSupply;
88    }
89 
90    function transfer(address _to, uint256 _value) public returns (bool) {
91        require(_to != address(0));
92        require(_value <= balances[msg.sender]);
93        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
94        balances[_to] = SafeMath.add(balances[_to], _value);
95        Transfer(msg.sender, _to, _value);
96        return true;
97    }
98 
99    function isContract(address _addr) private returns (bool is_contract) {
100        uint length;
101        assembly {
102        //retrieve the size of the code on target address, this needs assembly
103            length := extcodesize(_addr)
104        }
105        return (length>0);
106    }
107 
108    function balanceOf(address _owner) public view returns (uint256 balance) {
109        return balances[_owner];
110    }
111 
112    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113        require(_to != address(0));
114        require(_value <= balances[_from]);
115        require(_value <= allowed[_from][msg.sender]);
116 
117        balances[_from] = SafeMath.sub(balances[_from], _value);
118        balances[_to] = SafeMath.add(balances[_to], _value);
119        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
120        Transfer(_from, _to, _value);
121        return true;
122    }
123 
124    function approve(address _spender, uint256 _value) public returns (bool) {
125        allowed[msg.sender][_spender] = _value;
126        Approval(msg.sender, _spender, _value);
127        return true;
128    }
129 
130    function allowance(address _owner, address _spender) public view returns (uint256) {
131        return allowed[_owner][_spender];
132    }
133 
134    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
136        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137        return true;
138    }
139 
140    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141        uint oldValue = allowed[msg.sender][_spender];
142        if (_subtractedValue > oldValue) {
143            allowed[msg.sender][_spender] = 0;
144        } else {
145            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
146        }
147        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148        return true;
149    }
150 }