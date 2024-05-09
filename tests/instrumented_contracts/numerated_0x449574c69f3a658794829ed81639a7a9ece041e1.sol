1 pragma solidity ^0.4.9;
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
25 contract NeoGold {
26     using SafeMath for uint256;
27     mapping(address => mapping(address => uint256)) allowed;
28     mapping(address => uint256) balances;
29     uint256 public totalSupply;
30     uint256 public decimals;
31     address public owner;
32     bytes32 public symbol;
33     bool public fullSupplyUnlocked;
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed _owner, address indexed spender, uint256 value);
36 
37     function NeoGold() 
38     {
39         totalSupply = 100000000;
40         symbol = 'NEOG';
41         owner = 0x61DDb6704A84CD906ec8318576465b25aD2100fd;
42         balances[owner] = 50000000;
43         decimals = 0;
44     }
45     function unlockSupply() returns(bool)
46     {
47         require(msg.sender == owner);
48         require(!fullSupplyUnlocked);
49         balances[owner] = balances[owner].add(50000000);
50         fullSupplyUnlocked = true;
51         return true;
52     }
53     function balanceOf(address _owner) constant returns(uint256 balance)
54     {
55         return balances[_owner];
56     }
57 
58     function allowance(address _owner, address _spender) constant returns(uint256 remaining)
59     {
60         return allowed[_owner][_spender];
61     }
62 
63     function transfer(address _to, uint256 _value) returns(bool)
64     {
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) returns(bool) 
72     {
73         var _allowance = allowed[_from][msg.sender];
74         balances[_to] = balances[_to].add(_value);
75         balances[_from] = balances[_from].sub(_value);
76         allowed[_from][msg.sender] = _allowance.sub(_value);
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) returns(bool) 
82     {
83         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function() 
90     {
91         revert();
92     }
93 }