1 pragma solidity ^0.5.10;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address _owner) external view returns (uint256);
6     function transfer(address _to, uint256 _value) external returns (bool);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
8     function approve(address _spender, uint256 _value) external returns (bool);
9     function allowance(address _owner, address _spender) external view returns (uint256);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a / b;
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43     event OwnershipRenounced(address indexed previousOwner);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnerShip(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 
60     function renounceOwnerShip() public onlyOwner {
61         emit OwnershipRenounced(owner);
62         owner = address(0);
63     }
64 }
65 
66 interface tokenRecipient {
67     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
68 }
69 
70 contract TokenERC20 is Ownable {
71     using SafeMath for uint256;
72     string public name;
73     string public symbol;
74     uint8 public decimals = 18;
75     uint256 public totalSupply;
76 
77     mapping (address => uint256) public balanceOf;
78     mapping (address => mapping (address => uint256)) public allowance;
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82     event Burn(address indexed _from, uint256 _value);
83 
84     constructor (uint256 _initialSupply, string memory _tokenName, string memory _tokenSymbol, address _tokenOwner) public {
85         totalSupply = _initialSupply * 10 ** uint256(decimals);
86         balanceOf[_tokenOwner] = totalSupply;
87         name = _tokenName;
88         symbol = _tokenSymbol;
89 
90         emit Transfer(address(0), _tokenOwner, totalSupply);
91     }
92 
93     function _transfer(address _from, address _to, uint256 _value) internal {
94         require(_to != address(0));
95         require(balanceOf[_from] >= _value);
96         require(balanceOf[_to] + _value > balanceOf[_to]);
97         balanceOf[_from] -= _value;
98         balanceOf[_to] += _value;
99         emit Transfer(_from, _to, _value);
100     }
101 
102     function transfer(address _to, uint256 _value) public {
103         _transfer(msg.sender, _to, _value);
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_value <= allowance[_from][msg.sender]);   // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
123             return true;
124         }
125     }
126 
127     function burn(uint256 _value) public returns (bool) {
128         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
129         balanceOf[msg.sender] -= _value;
130         totalSupply -= _value;
131         emit Burn(msg.sender, _value);
132         return true;
133     }
134 
135     function burnFrom(address _from, uint256 _value) public returns (bool) {
136         require(balanceOf[_from] >= _value);
137         require(_value <= allowance[_from][msg.sender]);   // Check allowance
138         balanceOf[_from] -= _value;
139         allowance[_from][msg.sender] -= _value;   // Subtract from the sender's allowance
140         totalSupply -= _value;
141         emit Burn(_from, _value);
142         return true;
143     }
144 
145     function transferArray(address[] memory _to, uint256[] memory _value) public returns (bool) {
146         require(_to.length > 0);
147         for (uint256 i = 0; i < _to.length; i++) {
148             _transfer(msg.sender, _to[i], _value[i]);
149         }
150     }
151 
152     function transferBatch(address[] memory _to, uint256 _value) public returns (bool) {
153         require(_to.length > 0);
154         for (uint256 i = 0; i < _to.length; i++) {
155             _transfer(msg.sender, _to[i], _value);
156         }
157     }
158 }