1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract ERC20 {
28     uint256 public totalSupply;
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 contract StandardToken is ERC20 {
40     using SafeMath for uint256;
41 
42     mapping (address => uint256) balances;
43     mapping (address => mapping (address => uint256)) allowed;
44 
45     function transfer(address _to, uint256 _value) public returns (bool) {
46         require(_to != address(0));
47         require(_value > 0);
48 
49         balances[msg.sender] = balances[msg.sender].sub(_value);
50         balances[_to] = balances[_to].add(_value);
51         Transfer(msg.sender, _to, _value);
52         return true;
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
56         require(_from != address(0));
57         require(_to != address(0));
58 
59         uint256 _allowance = allowed[_from][msg.sender];
60 
61         balances[_from] = balances[_from].sub(_value);
62         balances[_to] = balances[_to].add(_value);
63         allowed[_from][msg.sender] = _allowance.sub(_value);
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 }
82 
83 contract SPNToken is StandardToken {
84 
85     string public name = "SPN Token";
86     string public symbol = "SPN";
87     uint public decimals = 18;
88 
89     uint public constant TOTAL_SUPPLY    = 200000000e18;
90     address public constant WALLET_SPN   = 0xDDD4b9Dc94Eb41969E37EB64baf3C0E1cd959c29; 
91 
92     function SPNToken() public {
93         balances[msg.sender] = TOTAL_SUPPLY;
94         totalSupply = TOTAL_SUPPLY;
95 
96         transfer(WALLET_SPN, TOTAL_SUPPLY);
97     }
98 }