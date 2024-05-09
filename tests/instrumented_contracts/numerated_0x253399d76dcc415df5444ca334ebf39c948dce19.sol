1 pragma solidity ^ 0.4 .18;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal constant returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal constant returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract BITTLE {
26     using SafeMath
27     for uint256;
28     mapping(address => mapping(address => uint256)) allowed;
29     mapping(address => uint256) balances;
30     uint256 public totalSupply;
31     uint256 public decimals;
32     address public owner;
33     bytes32 public symbol;
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed _owner, address indexed spender, uint256 value);
36 
37     function BITTLE() {
38         totalSupply = 10000000;
39         symbol = 'BTT';
40         owner = 0x2e2ab69143e18353d1b04658111f31fd88a8a239;
41         balances[owner] = totalSupply;
42         decimals = 8;
43     }
44 
45     function balanceOf(address _owner) constant returns(uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
50         return allowed[_owner][_spender];
51     }
52 
53     function transfer(address _to, uint256 _value) returns(bool) {
54         balances[msg.sender] = balances[msg.sender].sub(_value);
55         balances[_to] = balances[_to].add(_value);
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
61         var _allowance = allowed[_from][msg.sender];
62         balances[_to] = balances[_to].add(_value);
63         balances[_from] = balances[_from].sub(_value);
64         allowed[_from][msg.sender] = _allowance.sub(_value);
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) returns(bool) {
70         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function() {
77         revert();
78     }
79 }