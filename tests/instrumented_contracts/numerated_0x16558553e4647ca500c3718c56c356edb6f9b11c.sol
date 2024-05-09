1 /**
2  *Submitted for verification at Etherscan.io on 2018-09-20
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 contract Ownable {
8     address public owner;
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) public onlyOwner {
21         require(newOwner != address(0));
22         OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25 }
26 
27 library SafeMath {
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32         uint256 c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a / b;
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract ERC20Token {
55     using SafeMath for uint256;
56 
57     string public name;
58     string public symbol;
59     uint256 public decimals;
60     uint256 public totalSupply;
61 
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 
68     function ERC20Token (
69         string _name, 
70         string _symbol, 
71         uint256 _decimals, 
72         uint256 _totalSupply) public 
73     {
74         name = _name;
75         symbol = _symbol;
76         decimals = _decimals;
77         totalSupply = _totalSupply * 10 ** decimals;
78         balanceOf[msg.sender] = totalSupply;
79     }
80 
81     function _transfer(address _from, address _to, uint256 _value) internal {
82         require(_to != 0x0);
83         require(balanceOf[_from] >= _value);
84         require(balanceOf[_to].add(_value) > balanceOf[_to]);
85         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
86         balanceOf[_from] = balanceOf[_from].sub(_value);
87         balanceOf[_to] = balanceOf[_to].add(_value);
88 
89         Transfer(_from, _to, _value);
90         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         _transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);
100         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 }
111 
112 contract MonkeyKingToken is Ownable, ERC20Token {
113     event Burn(address indexed from, uint256 value);
114 
115     function MonkeyKingToken (
116         string name, 
117         string symbol, 
118         uint256 decimals, 
119         uint256 totalSupply
120     ) ERC20Token (name, symbol, decimals, totalSupply) public {}
121 
122     function() payable public {
123         revert();
124     }
125 
126     function burn(uint256 _value) onlyOwner public returns (bool success) {
127         require(balanceOf[msg.sender] >= _value);
128         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
129         totalSupply = totalSupply.sub(_value);
130         Burn(msg.sender, _value);
131         return true;
132     }
133 }