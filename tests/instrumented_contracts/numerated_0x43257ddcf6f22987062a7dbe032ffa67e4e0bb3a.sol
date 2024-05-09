1 pragma solidity ^0.5.17;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 }
13 
14 contract Ownable {
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     address public owner;
18 
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     emit OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 
25 
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 }
31 
32 library SafeMath {
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         assert(c / a == b);
39         return c;
40     }
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a / b;
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 
60 contract HBTT is ERC20, Ownable {
61     using SafeMath for uint256;
62 
63 
64     event Mint(address indexed to, uint256 amount);
65     event MintFinished();
66 
67     bool public mintingFinished = false;
68 
69     mapping (address => uint256) public balances;
70     mapping (address => mapping (address => uint256)) public allowed;
71 
72 
73     string public name;
74     uint8  public decimals;
75     string public symbol;
76 
77     modifier canMint() {
78         require(!mintingFinished);
79         _;
80     }
81 
82     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
83         totalSupply = totalSupply.add(_amount);
84         balances[_to] = balances[_to].add(_amount);
85         emit Mint(_to, _amount);
86         emit Transfer(address(0), _to, _amount);
87         return true;
88     }
89 
90     function finishMinting() onlyOwner canMint public returns (bool) {
91         mintingFinished = true;
92         emit MintFinished();
93         return true;
94     }
95 
96 
97     constructor() public {
98         decimals = 4;
99         name = "HuobiPlusHbtt";
100         symbol = "HBTT";
101         address receiver = address(0xdCB4ec8900F7CDC2E1B672b437E2615552dF2aAf);
102         owner = receiver;
103         uint _initialAmount = 1000000000;
104 
105         balances[receiver] = _initialAmount * uint256(10) ** decimals;
106         totalSupply = _initialAmount * uint256(10) ** decimals;
107     }
108 
109 
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112         require(_value <= balances[msg.sender]);
113 
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         emit Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120 
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125 
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         emit Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     function balanceOf(address _owner) public view returns (uint256 balance) {
140         return balances[_owner];
141     }
142 
143 
144     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
149         uint oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165 }