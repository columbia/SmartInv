1 library SafeMath {
2     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
3         uint256 c = a * b;
4         assert(a == 0 || c / a == b);
5         return c;
6     }
7 
8     function div(uint256 a, uint256 b) internal constant returns(uint256) {
9         uint256 c = a / b;
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal constant returns(uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }
24 contract ORIUMCOIN {
25     using SafeMath
26     for uint256;
27     mapping(address => mapping(address => uint256)) allowed;
28     mapping(address => uint256) balances;
29     uint256 public totalSupply;
30     uint256 public decimals;
31     address public owner;
32     bytes32 public symbol;
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed _owner, address indexed spender, uint256 value);
35 
36     function ORIUMCOIN() {
37         totalSupply = 200000000;
38         symbol = 'ORM';
39         owner = 0x106ceae9db9a3249084aa2140add5fab057f8ea6;
40         balances[owner] = totalSupply;
41         decimals = 0;
42     }
43 
44     function balanceOf(address _owner) constant returns(uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
49         return allowed[_owner][_spender];
50     }
51 
52     function transfer(address _to, uint256 _value) returns(bool) {
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
60         var _allowance = allowed[_from][msg.sender];
61         balances[_to] = balances[_to].add(_value);
62         balances[_from] = balances[_from].sub(_value);
63         allowed[_from][msg.sender] = _allowance.sub(_value);
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) returns(bool) {
69         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function() {
76         revert();
77     }
78 }