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
25 contract MoneroGold {
26     using SafeMath for uint256;
27     mapping(address => mapping(address => uint256)) allowed;
28     mapping(address => uint256) balances;
29     uint256 public totalSupply;
30     uint256 public decimals;
31     address public owner;
32      bytes32 public name;
33     bytes32 public symbol;
34     bool public fullSupplyUnlocked;
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed _owner, address indexed spender, uint256 value);
37 
38     function MoneroGold() 
39     {
40         totalSupply = 21000000;
41         name = 'MoneroGold';
42         symbol = 'XMRG';
43         owner = 0x16aa7328A402CBbe46afdbA9FF2b54cb1a0124B6;
44         balances[owner] = 21000000;
45         decimals = 0;
46     }
47     function unlockSupply() returns(bool)
48     {
49         require(msg.sender == owner);
50         require(!fullSupplyUnlocked);
51         balances[owner] = balances[owner].add(21000000);
52         fullSupplyUnlocked = true;
53         return true;
54     }
55     function balanceOf(address _owner) constant returns(uint256 balance)
56     {
57         return balances[_owner];
58     }
59 
60     function allowance(address _owner, address _spender) constant returns(uint256 remaining)
61     {
62         return allowed[_owner][_spender];
63     }
64 
65     function transfer(address _to, uint256 _value) returns(bool)
66     {
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns(bool) 
74     {
75         var _allowance = allowed[_from][msg.sender];
76         balances[_to] = balances[_to].add(_value);
77         balances[_from] = balances[_from].sub(_value);
78         allowed[_from][msg.sender] = _allowance.sub(_value);
79         Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) returns(bool) 
84     {
85         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function() 
92     {
93         revert();
94     }
95 }