1 pragma solidity ^0.4.21;
2 /*
3 * @author Ivan Borisov(Github.com/pillardevelopment)
4 */
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b > 0);
18         uint256 c = a / b;
19         assert(a == b * c + a % b);
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract Ownable {
36     address public owner;
37 
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 }
47 
48 contract TokenERC20 is Ownable {
49     using SafeMath for uint;
50 
51     string public name = "Your Open Direct Sales Ecosystem";
52     string public symbol = "YODSE";
53     uint256 public decimals = 18;
54     uint256 DEC = 10 ** uint256(decimals);
55     address public owner;
56     uint256 public totalSupply = 100000000*DEC;
57     uint256 public avaliableSupply;
58 
59     mapping (address => uint256) public balanceOf;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Burn(address indexed from, uint256 value);
63 
64     function TokenERC20() public
65     {
66         balanceOf[msg.sender] = totalSupply;
67         avaliableSupply = balanceOf[msg.sender];
68         owner = msg.sender;
69     }
70 
71     function _transfer(address _from, address _to, uint256 _value) internal {
72         require(_to != 0x0);
73         require(balanceOf[_from] >= _value);
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         balanceOf[_from] -= _value;
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     function burn(uint256 _value) public {
87         _burn(msg.sender, _value);
88     }
89 
90     function _burn(address _who, uint256 _value) internal {
91         require(_value <= balanceOf[_who]);
92         balanceOf[_who] = balanceOf[_who].sub(_value);
93         totalSupply = totalSupply.sub(_value);
94         emit Burn(_who, _value);
95         emit Transfer(_who, address(0), _value);
96     }
97 }