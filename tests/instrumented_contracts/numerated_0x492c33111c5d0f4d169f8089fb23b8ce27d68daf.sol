1 pragma solidity 0.4.18;
2 
3 library SafeMathLib {
4     function times(uint a, uint b) internal pure returns (uint) {
5         uint c = a * b;
6         require(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function minus(uint a, uint b) internal pure returns (uint) {
11         require(b <= a);
12         return a - b;
13     }
14 
15     function plus(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         require(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 library ERC20Lib {
23     using SafeMathLib for uint;
24 
25     struct TokenStorage {
26         mapping (address => uint) balances;
27         mapping (address => mapping (address => uint)) allowed;
28         uint totalSupply;
29     }
30 
31     event Transfer(address indexed from, address indexed to, uint value);
32     event Approval(address indexed owner, address indexed spender, uint value);
33 
34     function init(TokenStorage storage self, uint _initial_supply, address _owner) internal {
35         self.totalSupply = _initial_supply;
36         self.balances[_owner] = _initial_supply;
37     }
38 
39 
40     function transfer(TokenStorage storage self, address _to, uint _value) internal returns (bool success) {
41         self.balances[msg.sender] = self.balances[msg.sender].minus(_value);
42         self.balances[_to] = self.balances[_to].plus(_value);
43         Transfer(msg.sender, _to, _value);
44         return true;
45     }
46 
47     function transferFrom(TokenStorage storage self, address _from, address _to, uint _value) internal returns (bool success) {
48         var _allowance = self.allowed[_from][msg.sender];
49 
50         self.balances[_to] = self.balances[_to].plus(_value);
51         self.balances[_from] = self.balances[_from].minus(_value);
52         self.allowed[_from][msg.sender] = _allowance.minus(_value);
53         Transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function balanceOf(TokenStorage storage self, address _owner) internal view returns (uint balance) {
58         return self.balances[_owner];
59     }
60 
61     function approve(TokenStorage storage self, address _spender, uint _value) internal returns (bool success) {
62         self.allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(TokenStorage storage self, address _owner, address _spender) internal view returns (uint remaining) {
68         return self.allowed[_owner][_spender];
69     }
70 }
71 
72 contract BpxToken {
73     using ERC20Lib for ERC20Lib.TokenStorage;
74 
75     ERC20Lib.TokenStorage token;
76 
77     string public name = "AsobimoX";
78     string public symbol = "ABX";
79     uint8 public decimals = 8;
80     uint public INITIAL_SUPPLY = 20000000;
81 
82     function BpxToken() public {
83         // adding decimals to initial supply
84         var totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);
85         // adding total supply to owner which could be msg.sender or specific address
86         token.init(totalSupply, 0x7fEDD97be49ba9EfC21acc025Dd29aa7addc82F1);
87     }
88 
89     function totalSupply() public view returns (uint) {
90         return token.totalSupply;
91     }
92 
93     function balanceOf(address who) public view returns (uint) {
94         return token.balanceOf(who);
95     }
96 
97     function allowance(address owner, address spender) public view returns (uint) {
98         return token.allowance(owner, spender);
99     }
100 
101     function transfer(address to, uint value) public returns (bool ok) {
102         return token.transfer(to, value);
103     }
104 
105     function transferFrom(address from, address to, uint value) public returns (bool ok) {
106         return token.transferFrom(from, to, value);
107     }
108 
109     function approve(address spender, uint value) public returns (bool ok) {
110         return token.approve(spender, value);
111     }
112 
113     event Transfer(address indexed from, address indexed to, uint value);
114     event Approval(address indexed owner, address indexed spender, uint value);
115 }