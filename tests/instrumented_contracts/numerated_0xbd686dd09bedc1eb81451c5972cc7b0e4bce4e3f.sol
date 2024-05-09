1 pragma solidity ^0.4.23;
2 
3 interface ERC20 {
4     function balanceOf(address _owner) external view returns (uint balance);
5     function transfer(address _to, uint _value) external returns (bool success);
6     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
7     function approve(address _spender, uint _value) external returns (bool success);
8     function allowance(address _owner, address _spender) external view returns (uint remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint _value);   
11 }
12 
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
39 contract LEK is ERC20 {
40     using SafeMath for uint256;
41     string public name;
42     string public symbol;
43     uint256 public totalSupply;
44     uint8 public decimals;
45     mapping (address => uint256) private balances;   
46     mapping (address => mapping (address => uint256)) private allowed;
47 
48     function LEK(string _tokenName, string _tokenSymbol,uint256 _initialSupply,uint8 _decimals) public {
49         decimals = _decimals;
50         totalSupply = _initialSupply * 10 ** uint256(decimals);  // 这里确定了总发行量
51         name = _tokenName;
52         symbol = _tokenSymbol;
53         balances[msg.sender] = totalSupply;
54     }
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[msg.sender]);
59         balances[msg.sender] = balances[msg.sender].sub(_value);
60         balances[_to] = balances[_to].add(_value);
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70         require(_to != address(0));
71         require(_value <= balances[_from]);
72         require(_value <= allowed[_from][msg.sender]);
73         balances[_from] = balances[_from].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
76         emit Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function approve(address _spender, uint256 _value) public returns (bool) {
81         allowed[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) public view returns (uint256) {
87         return allowed[_owner][_spender];
88     }
89 
90 }