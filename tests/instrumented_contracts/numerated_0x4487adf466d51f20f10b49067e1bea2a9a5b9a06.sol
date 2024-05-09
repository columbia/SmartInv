1 pragma solidity ^0.4.9;
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
25     }
26     contract Lux{
27     
28 	
29 	string public standard = 'Lux 1.0';
30     using SafeMath for uint256;
31     mapping(address => mapping(address => uint256)) allowed;
32     mapping(address => uint256) balances;
33     uint256 public totalSupply;
34     uint256 public decimals;
35     address public owner;
36     bytes32 public symbol;
37     
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed _owner, address indexed spender, uint256 value);
40 
41     function Lux() 
42     {
43         totalSupply = 1000000;
44         symbol = 'luxcorp';
45         owner =0x0720CF3Db1100aF1BEd64940c6D374A69b9935Ae;
46         balances[owner] = 1000000;
47         decimals = 0;
48     }
49     
50     function balanceOf(address _owner) constant returns(uint256 balance)
51     {
52         return balances[_owner];
53     }
54 
55     function allowance(address _owner, address _spender) constant returns(uint256 remaining)
56     {
57         return allowed[_owner][_spender];
58     }
59 
60     function transfer(address _to, uint256 _value) returns(bool)
61     {
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns(bool) 
69     {
70         var _allowance = allowed[_from][msg.sender];
71         balances[_to] = balances[_to].add(_value);
72         balances[_from] = balances[_from].sub(_value);
73         allowed[_from][msg.sender] = _allowance.sub(_value);
74         Transfer(_from, _to, _value);
75         return true;
76     }
77 
78     function approve(address _spender, uint256 _value) returns(bool) 
79     {
80         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function() 
87     {
88         revert();
89     }
90 }