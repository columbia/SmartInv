1 pragma solidity ^0.4.11;
2 
3 interface IERC20{
4    function totalSupply() constant returns (uint256 totalSupply);
5    function balanceOf(address _owner) constant returns (uint256 balance);
6    function transfer(address _to, uint256 _value) returns (bool success);
7    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8    function approve(address _spender, uint256 _value) returns (bool success);
9    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10    event Transfer(address indexed _from, address indexed _to, uint256 _value);
11    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 pragma solidity ^0.4.11;
14 
15 
16 /**
17 * @title SafeMath
18 * @dev Math operations with safety checks that throw on error
19 */
20 library SafeMath {
21  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22    uint256 c = a * b;
23    assert(a == 0 || c / a == b);
24    return c;
25  }
26 
27  function div(uint256 a, uint256 b) internal constant returns (uint256) {
28    // assert(b > 0); // Solidity automatically throws when dividing by 0
29    uint256 c = a / b;
30    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31    return c;
32  }
33 
34  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35    assert(b <= a);
36    return a - b;
37  }
38 
39  function add(uint256 a, uint256 b) internal constant returns (uint256) {
40    uint256 c = a + b;
41    assert(c >= a);
42    return c;
43  }
44 }
45 
46 pragma solidity ^0.4.11;
47 
48 // DisLedger Intellectual Property License Agreement is incorporated by reference and is available in Exhibit A of https://www.disledger.com/DisLedger_PublicSale_TPA.pdf
49 
50 
51 
52 
53 
54     contract owned {
55         address public owner;
56 
57         function owned() {
58             owner = msg.sender;
59         }
60 
61         modifier onlyOwner {
62             require(msg.sender == owner);
63             _;
64         }
65 
66         function transferOwnership(address newOwner) onlyOwner {
67             owner = newOwner;
68         }
69     }
70     
71 contract DISLEDGERDCL is owned {
72    
73    using SafeMath for uint256;
74    
75    uint public constant _totalSupply = 30000000000;
76    
77    string public constant symbol = "DCL";
78    string public constant name = "DISLEDGER";
79    uint8 public constant decimals = 3;
80 
81    mapping(address => uint256) balances;
82    mapping(address => mapping (address => uint256)) allowed;
83    
84    function DISLEDGERDCL(){
85        balances[msg.sender] = _totalSupply;
86    }
87    function totalSupply() constant returns (uint256 totalSupply){
88        return _totalSupply;
89    }
90    function balanceOf(address _owner) constant returns (uint256 balance){
91        return balances[_owner];
92    }
93    function transfer(address _to, uint256 _value) returns (bool success){
94        require(
95            balances[msg.sender] >= _value
96            && _value > 0
97        );
98            balances[msg.sender] = balances[msg.sender].sub(_value);
99            balances[_to] = balances[_to].add(_value);
100            Transfer(msg.sender, _to, _value);
101            return true;
102    }
103    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
104        require(
105            allowed[_from][msg.sender] >= _value
106            && balances [_from] >= _value
107            && _value > 0
108        );
109        balances[_from] = balances[_from].sub(_value);
110        balances[_to] = balances[_to].add(_value);
111        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112        Transfer(_from, _to, _value);
113        return true;
114    }
115    function approve(address _spender, uint256 _value) returns (bool success){
116        allowed[msg.sender][_spender] = _value;
117        Approval(msg.sender, _spender, _value);
118        return true;
119    }
120    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
121        return allowed[_owner][_spender];
122    }
123    event Transfer(address indexed _from, address indexed _to, uint256 _value);
124    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
125 
126 }