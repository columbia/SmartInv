1 pragma solidity ^ 0.4 .9;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 contract Garden {
27     using SafeMath
28     for uint256;
29     mapping(address => mapping(address => uint256)) allowed;
30     mapping(address => uint256) balances;
31     uint256 public totalSupply;
32     uint256 public decimals;
33     address public owner;
34     bytes32 public name;
35     bytes32 public symbol;
36         event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed _owner, address indexed spender, uint256 value);
38 
39     function Garden() {
40         totalSupply = 1000000000100000000000000000;
41         name = 'Garden';
42         symbol = 'GAR';
43         owner = 0x1416Ffd28bD3EAaBE8f9feCF3cB7B4D8248Cc158;
44         balances[owner] = totalSupply;
45         decimals = 18;
46     }
47 
48     function balanceOf(address _owner) constant returns(uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
53         return allowed[_owner][_spender];
54     }
55 
56     function transfer(address _to, uint256 _value) returns(bool) {
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
64         var _allowance = allowed[_from][msg.sender];
65         balances[_to] = balances[_to].add(_value);
66         balances[_from] = balances[_from].sub(_value);
67         allowed[_from][msg.sender] = _allowance.sub(_value);
68         Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function approve(address _spender, uint256 _value) returns(bool) {
73         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function() {
80         revert();
81     }
82 }