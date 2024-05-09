1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         require(b <= a, "SafeMath: subtraction overflow");
7         uint256 c = a - b;
8 
9         return c;
10     }
11 
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 }
19 
20 contract Token {
21 
22     using SafeMath for uint256;
23 
24     string  public name;
25     string  public symbol;
26     uint8   public decimals;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping(address => uint256)) public allowance;
31 
32     event Transfer (address indexed from, address indexed to, uint256 value);
33     event Approval (address indexed owner, address indexed spender, uint256 value);
34 
35 
36     function transfer(address _to, uint256 _value) public returns (bool) {
37 
38         require(_to != address(0), "Transfer: to address is the zero address");
39         require(_value <= balanceOf[msg.sender], "Transfer: transfer value is more than your balance");
40 
41         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
42         balanceOf[_to] = balanceOf[_to].add(_value);
43 
44         emit Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public returns (bool) {
49 
50         allowance[msg.sender][_spender] = _value;
51 
52         emit Approval(msg.sender, _spender, _value);
53         return true;
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
57 
58         require(_to != address(0), "TransferFrom: to address is the zero address");
59         require(_value <= balanceOf[_from], "TransferFrom: transfer value is more than the balance of the from address");
60         require(_value <= allowance[_from][msg.sender], "TransferFrom: transfer value is more than your allowance");
61 
62         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
63         balanceOf[_from] = balanceOf[_from].sub(_value);
64         balanceOf[_to] = balanceOf[_to].add(_value);
65 
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function increaseApproval( address _spender, uint256 _addedValue) public returns (bool) {
71 
72         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
73 
74         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
75         return true;
76     }
77 
78     function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool) {
79 
80         uint256 oldValue = allowance[msg.sender][_spender];
81         if (_subtractedValue >= oldValue) {
82         allowance[msg.sender][_spender] = 0;
83         } else {
84         allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
85         }
86 
87         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
88         return true;
89     }
90 }
91 
92 
93 contract SpotChainToken is Token {
94 
95     uint256 internal constant INIT_TOTALSUPLLY = 600000000;
96 
97     constructor() public {
98         name = "SpotChain Token";
99         symbol = "GSB";
100         decimals = uint8(18);
101         totalSupply = INIT_TOTALSUPLLY * uint256(10) ** uint256(decimals);
102         balanceOf[msg.sender] = totalSupply;
103         emit Transfer(address(0), msg.sender, totalSupply);
104     }
105 }