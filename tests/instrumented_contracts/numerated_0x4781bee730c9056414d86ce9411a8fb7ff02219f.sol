1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 /// @title Rose Token.
42 //  @story Mini buda loves kaeru.
43 /// For more information about this token, please visit https://rose.red
44 contract RoseToken is ERC20 {
45 
46     using SafeMath for uint256;
47     address owner;
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51 
52     string public constant name = "RoseToken";
53     string public constant symbol = "ROSE?";
54     uint public constant decimals = 0;
55 
56     uint256 public totalSupply = 99999999;
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60     
61 
62     function RoseToken() public {
63         owner = msg.sender;
64         balances[owner] = totalSupply;
65     }
66 
67     function () external payable {
68     }
69 
70     function balanceOf(address _owner) constant public returns (uint256) {
71        return balances[_owner];
72     }
73 
74     // mitigates the ERC20 short address attack
75     modifier onlyPayloadSize(uint size) {
76         assert(msg.data.length >= size + 4);
77         _;
78     }
79 
80     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
81         require(_to != address(0));
82         require(_amount <= balances[msg.sender] && _amount >=0 );
83 
84         balances[msg.sender] = balances[msg.sender].sub(_amount);
85         balances[_to] = balances[_to].add(_amount);
86         Transfer(msg.sender, _to, _amount);
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
91         require(_to != address(0));
92         require(_amount <= balances[_from] && _amount >= 0);
93         require(_amount <= allowed[_from][msg.sender]);
94 
95         balances[_from] = balances[_from].sub(_amount);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
97         balances[_to] = balances[_to].add(_amount);
98         Transfer(_from, _to, _amount);
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         // mitigates the ERC20 spend/approval race condition
104         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     function allowance(address _owner, address _spender) constant public returns (uint256) {
111         return allowed[_owner][_spender];
112     }
113 }