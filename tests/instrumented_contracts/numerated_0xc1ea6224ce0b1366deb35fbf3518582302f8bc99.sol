1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {return 0;}
6         uint256 c = a * b;
7         assert(c / a == b);
8         return c;
9     }
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract ERC20{
26     using SafeMath for uint256;
27     function balanceOf(address _owner)public view returns (uint256 balance);
28     function transfer(address _to, uint256 _value)public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
30     function approve(address _spender, uint256 _value)public returns (bool success);
31     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 contract VTToken is ERC20{
36     string public name   = "Virtual Talk";
37     string public symbol = "VT"; 
38     uint8 public decimals=18;
39     uint256 public totalSupply;
40     mapping(address => uint256) balances;
41     mapping (address => mapping (address => uint256)) internal allowed;
42     
43     constructor(uint256 initialSupply)public{
44         totalSupply = initialSupply * 10 ** uint256(decimals);
45         balances[msg.sender] = totalSupply;
46     }
47     
48     function balanceOf(address _owner)public view returns (uint256 balance){
49         return balances[_owner];
50     }
51     
52     function transfer(address _to, uint256 _value)public returns (bool success){
53         require(_to != address(0));
54         require(_value <= balances[msg.sender]);
55         
56         balances[msg.sender] = balances[msg.sender].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61      
62     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success){
63         require(_to != address(0));
64         require(_value <= balances[_from]);
65         require(_value <= allowed[_from][msg.sender]);
66     
67         balances[_from] = balances[_from].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73     
74     function approve(address _spender, uint256 _value)public returns (bool success){
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true; 
78     }
79     
80     function allowance(address _owner, address _spender)public view returns (uint256 remaining){
81         return allowed[_owner][_spender];
82     }
83 }