1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36 
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46  
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52    
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 }
59 
60 
61 contract ERC20Basic {
62     uint256 public totalSupply;
63     function balanceOf(address who) public view returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function allowance(address owner, address spender) public view returns (uint256);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract HECToken is  ERC20Basic{
73 
74     string public name;
75     string public symbol;
76     uint8 public decimals;
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     
82     function balanceOf(address _owner) public view returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[msg.sender]);
89 
90         // SafeMath.sub will throw if there is not enough balance.
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         emit Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98         require(_to != address(0));
99         require(allowed[_from][msg.sender] >= _value);
100         require(balances[_from] >= _value);
101         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
102         balances[_from] = balances[_from].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115     
116     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
117         return allowed[_owner][_spender];
118     }
119 
120     constructor() public {
121         name = "HEC Coin";
122         symbol = "HEC";
123         decimals = 18;
124         totalSupply = 500000000e18;
125 
126         balances[msg.sender] = totalSupply;
127         emit Transfer(0x0, msg.sender, totalSupply);
128     }
129 }