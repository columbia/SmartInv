1 pragma solidity ^0.4.25;
2 
3 // ERC20 interface
4 interface IERC20 {
5   function balanceOf(address _owner) external view returns (uint256);
6   function allowance(address _owner, address _spender) external view returns (uint256);
7   function transfer(address _to, uint256 _value) external returns (bool);
8   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
9   function approve(address _spender, uint256 _value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ISC is IERC20 {
44   using SafeMath for uint256;
45   address private owner;
46   string public name = "IChain";
47   string public symbol = "ISC";
48   uint8 public constant decimals = 18;
49   uint256 public constant decimalFactor = 10 ** uint256(decimals);
50   uint256 public constant totalSupply = 210000000 * decimalFactor;
51   mapping (address => uint256) balances;
52   mapping (address => mapping (address => uint256)) internal allowed;
53   mapping (address => bool) public frozenAccount;
54   event Transfer(address indexed from, address indexed to, uint256 value);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56     event FrozenFunds(address target, bool frozen);
57   constructor() public {
58     balances[msg.sender] = totalSupply;
59     owner = msg.sender;
60     emit Transfer(address(0), msg.sender, totalSupply);
61   }
62 
63     modifier onlyOwner {
64         if (msg.sender != owner) revert();
65         _;
66     }
67    function() external payable {
68     }
69     function withdraw() onlyOwner public {
70         uint256 etherBalance = address(this).balance;
71         owner.transfer(etherBalance);
72     }
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77   function allowance(address _owner, address _spender) public view returns (uint256) {
78     return allowed[_owner][_spender];
79   }
80 
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84    // require(block.timestamp >= 1537164000 || msg.sender == deployer || msg.sender == multisend);
85   //检查 冻结帐户
86     //检查 冻结帐户
87     require(!frozenAccount[msg.sender]);
88     require(!frozenAccount[_to]);
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[_from]);
99     require(_value <= allowed[_from][msg.sender]);
100     require(block.timestamp >= 1537164000);
101     //检查 冻结帐户
102     require(!frozenAccount[_from]);
103     require(!frozenAccount[_to]);
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107     emit Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     emit Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
119     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 
123   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
124     uint oldValue = allowed[msg.sender][_spender];
125     if (_subtractedValue > oldValue) {
126       allowed[msg.sender][_spender] = 0;
127     } else {
128       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
129     }
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133   
134     function freezeAccount(address target, bool freeze) onlyOwner public {
135         frozenAccount[target] = freeze;
136         emit FrozenFunds(target, freeze);
137     } 
138 
139 }