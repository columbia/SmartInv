1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0));
18         OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract ERC20Token {
51     using SafeMath for uint256;
52 
53     string public name;
54     string public symbol;
55     uint256 public decimals;
56     uint256 public totalSupply;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 
64     function ERC20Token (
65         string _name, 
66         string _symbol, 
67         uint256 _decimals, 
68         uint256 _totalSupply) public 
69     {
70         name = _name;
71         symbol = _symbol;
72         decimals = _decimals;
73         totalSupply = _totalSupply * 10 ** decimals;
74         balanceOf[msg.sender] = totalSupply;
75     }
76 
77     function _transfer(address _from, address _to, uint256 _value) internal {
78         require(_to != 0x0);
79         require(balanceOf[_from] >= _value);
80         require(balanceOf[_to].add(_value) > balanceOf[_to]);
81         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
82         balanceOf[_from] = balanceOf[_from].sub(_value);
83         balanceOf[_to] = balanceOf[_to].add(_value);
84 
85         Transfer(_from, _to, _value);
86         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
87     }
88 
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         _transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(_value <= allowance[_from][msg.sender]);
96         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 }
107 
108 contract KantrotechCoin1 is Ownable, ERC20Token {
109     event Burn(address indexed from, uint256 value);
110 
111     function KantrotechCoin1 (
112         string name, 
113         string symbol, 
114         uint256 decimals, 
115         uint256 totalSupply
116     ) ERC20Token (name, symbol, decimals, totalSupply) public {}
117 
118     function() payable public {
119         revert();
120     }
121 
122     function burn(uint256 _value) onlyOwner public returns (bool success) {
123         require(balanceOf[msg.sender] >= _value);
124         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
125         totalSupply = totalSupply.sub(_value);
126         Burn(msg.sender, _value);
127         return true;
128     }
129 }