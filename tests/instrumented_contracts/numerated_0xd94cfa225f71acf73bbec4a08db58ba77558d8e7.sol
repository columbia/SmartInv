1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-30
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 interface ERC20 {
8     function balanceOf(address _owner) external view returns (uint256);
9     function allowance(address _owner, address _spender) external view returns (uint256);
10     function transfer(address _to, uint256 _value) external returns (bool);
11     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
12     function approve(address _spender, uint256 _value) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract RubyFinance is ERC20 {
45     using SafeMath for uint256;
46     address private deployer;
47     string public name = "Ruby Finance";
48     string public symbol = "RUBY";
49     uint8 public constant decimals = 18;
50     uint256 public constant decimalFactor = 10 ** uint256(decimals);
51     uint256 public constant totalSupply = 1000000 * decimalFactor;
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) internal allowed;
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58     constructor() public {
59         balances[msg.sender] = totalSupply;
60         deployer = msg.sender;
61         emit Transfer(address(0), msg.sender, totalSupply);
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function allowance(address _owner, address _spender) public view returns (uint256) {
69         return allowed[_owner][_spender];
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74         require(_value <= balances[msg.sender]);
75         require(block.timestamp >= 1545102693);
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= balances[_from]);
86         require(_value <= allowed[_from][msg.sender]);
87         require(block.timestamp >= 1545102693);
88 
89         balances[_from] = balances[_from].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92         emit Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function approve(address _spender, uint256 _value) public returns (bool) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107 
108     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109         uint oldValue = allowed[msg.sender][_spender];
110         if (_subtractedValue > oldValue) {
111             allowed[msg.sender][_spender] = 0;
112         } else {
113             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114         }
115         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 }