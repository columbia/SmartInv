1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     event OwnershipTransferred(address from, address to);
8 
9     function Ownable() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         require(_newOwner != 0x0);
20         OwnershipTransferred(owner, _newOwner);
21         owner = _newOwner;
22     }
23 }
24 
25 library SafeMath {
26     
27     function mul(uint256 a, uint256 b) internal  returns (uint256) {
28         uint256 c = a * b;
29         assert(a == 0 || c / a == b);
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal returns (uint256) {
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract ERC20 {
51     uint256 public totalSupply;
52     uint8 public decimals;
53     string public name;
54     string public symbol;
55     function balanceOf(address who) constant public returns (uint256);
56     function transfer(address to, uint256 value) public returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     function allowance(address owner, address spender) constant public returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public  returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract SHNZ is ERC20, Ownable {
65     
66     using SafeMath for uint256;
67     
68     uint256 private tokensSold;
69     
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowances;
72   
73     event TokensIssued(address from, address to, uint256 amount);
74 
75     function SHNZ() public {
76         totalSupply = 1000000000000000000;
77         decimals = 8;
78         name = "ShizzleNizzle";
79         symbol = "SHNZ";
80         balances[this] = totalSupply;
81     }
82 
83     function balanceOf(address _addr) public constant returns (uint256) {
84         return balances[_addr];
85     }
86 
87     function transfer(address _to, uint256 _amount) public returns (bool) {
88         require(balances[msg.sender] >= _amount);
89         balances[msg.sender] = balances[msg.sender].sub(_amount);
90         balances[_to] = balances[_to].add(_amount);
91         Transfer(msg.sender, _to, _amount);
92         return true;
93     }
94     
95     function approve(address _spender, uint256 _amount) public returns (bool) {
96         allowances[msg.sender][_spender] = _amount;
97         Approval(msg.sender, _spender, _amount);
98         return true;
99     }
100     
101     function allowance(address _owner, address _spender) public constant returns (uint256) {
102         return allowances[_owner][_spender];
103     }
104     
105     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
106         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
107         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
108         balances[_from] = balances[_from].sub(_amount);
109         balances[_to] = balances[_to].add(_amount);
110         Transfer(_from, _to, _amount);
111         return true;
112     }
113     
114     function issueTokens(address _to, uint256 _amount) public onlyOwner {
115         require(_to != 0x0 && _amount > 0);
116         if(balances[this] <= _amount) {
117             balances[_to] = balances[_to].add(balances[this]);
118             Transfer(0x0, _to, balances[this]);
119             balances[this] = 0;
120         } else {
121             balances[this] = balances[this].sub(_amount);
122             balances[_to] = balances[_to].add(_amount);
123             Transfer(0x0, _to, _amount);
124         }
125     }
126 
127     function getTotalSupply() public constant returns (uint256) {
128         return totalSupply;
129     }
130 }