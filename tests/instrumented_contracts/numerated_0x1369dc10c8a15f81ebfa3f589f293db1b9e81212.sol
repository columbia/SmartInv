1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-24
3 */
4 
5 pragma solidity ^0.4.21;
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
17 
18 library SafeMath {
19    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20        if (a == 0) {
21            return 0;
22        }
23        uint256 c = a * b;
24        assert(c / a == b);
25        return c;
26    }
27 
28    function div(uint256 a, uint256 b) internal pure returns (uint256) {
29        // assert(b > 0); // Solidity automatically throws when dividing by 0
30        uint256 c = a / b;
31        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32        return c;
33    }
34 
35    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36        assert(b <= a);
37        return a - b;
38    }
39 
40    function add(uint256 a, uint256 b) internal pure returns (uint256) {
41        uint256 c = a + b;
42        assert(c >= a);
43        return c;
44    }
45 }
46 
47 contract StandardToken is ERC20 {
48    using SafeMath for uint;
49 
50    string  internal _name;
51    string  internal _symbol;
52    uint8   internal _decimals;
53    uint256 internal _totalSupply;
54 
55    mapping (address => uint256) internal balances;
56    mapping (address => mapping (address => uint256)) internal allowed;
57 
58    function StandardToken() public {
59        _name = "CommaOpenChat";                                  // Set the name for display purposes
60        _decimals = 18;                                      // Amount of decimals for display purposes
61        _symbol = "COC";                                     // Set the symbol for display purposes
62        _totalSupply = 5000000000000000000000000000;         // Update total supply (100000 for example)
63        balances[msg.sender] = 5000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)       
64    }
65 
66    function name()
67    public
68    view
69    returns (string) {
70        return _name;
71    }
72 
73    function symbol()
74    public
75    view
76    returns (string) {
77        return _symbol;
78    }
79 
80    function decimals()
81    public
82    view
83    returns (uint8) {
84        return _decimals;
85    }
86 
87    function totalSupply()
88    public
89    view
90    returns (uint256) {
91        return _totalSupply;
92    }
93 
94    function transfer(address _to, uint256 _value) public returns (bool) {
95        require(_to != address(0));
96        require(_value <= balances[msg.sender]);
97        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
98        balances[_to] = SafeMath.add(balances[_to], _value);
99        Transfer(msg.sender, _to, _value);
100        return true;
101    }
102 
103    function isContract(address _addr) private returns (bool is_contract) {
104        uint length;
105        assembly {
106        //retrieve the size of the code on target address, this needs assembly
107            length := extcodesize(_addr)
108        }
109        return (length>0);
110    }
111 
112    function balanceOf(address _owner) public view returns (uint256 balance) {
113        return balances[_owner];
114    }
115 
116    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117        require(_to != address(0));
118        require(_value <= balances[_from]);
119        require(_value <= allowed[_from][msg.sender]);
120 
121        balances[_from] = SafeMath.sub(balances[_from], _value);
122        balances[_to] = SafeMath.add(balances[_to], _value);
123        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
124        Transfer(_from, _to, _value);
125        return true;
126    }
127 
128    function approve(address _spender, uint256 _value) public returns (bool) {
129        allowed[msg.sender][_spender] = _value;
130        Approval(msg.sender, _spender, _value);
131        return true;
132    }
133 
134    function allowance(address _owner, address _spender) public view returns (uint256) {
135        return allowed[_owner][_spender];
136    }
137 
138    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
140        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141        return true;
142    }
143 
144    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145        uint oldValue = allowed[msg.sender][_spender];
146        if (_subtractedValue > oldValue) {
147            allowed[msg.sender][_spender] = 0;
148        } else {
149            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
150        }
151        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152        return true;
153    }
154 }