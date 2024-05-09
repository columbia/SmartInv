1 pragma solidity ^0.5.7;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a);
27         return c;
28     }
29 }
30 
31 contract NYTRUSA {
32 
33     using SafeMath for uint256;
34 
35     string public constant name = "New Currency Time Race";
36     string public constant symbol = "NYTR";
37     uint32 public constant decimals = 18;
38     uint256 public totalSupply = 300000000 ether;
39 
40 	mapping(address => bool) touched;
41     mapping(address => uint256) balances;
42     mapping(address => mapping(address => uint256)) internal allowed;
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46     
47     constructor()public {
48         balances[msg.sender] = totalSupply;
49     }
50 
51     function transfer(address _to, uint256 _value) public returns (bool) {
52         require(_to != address(0));
53         require(_value <= balances[msg.sender]);
54         balances[msg.sender] = balances[msg.sender].sub(_value);
55         balances[_to] = balances[_to].add(_value);
56         emit Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= allowed[_from][msg.sender]);
63         require(_value <= balances[_from]);
64         balances[_from] = balances[_from].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
67         emit Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public returns (bool) {
72         allowed[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) public view returns (uint256) {
78         return allowed[_owner][_spender];
79     }
80 
81     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
82         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
83         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
84         return true;
85     }
86 
87     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
88         uint oldValue = allowed[msg.sender][_spender];
89         if (_subtractedValue > oldValue) {
90             allowed[msg.sender][_spender] = 0;
91         } else {
92             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
93         }
94         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95         return true;
96     }
97 
98     function getBalance(address _a) internal view returns (uint256){
99         return balances[_a];
100 	}
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return getBalance(_owner);
104     }
105 }