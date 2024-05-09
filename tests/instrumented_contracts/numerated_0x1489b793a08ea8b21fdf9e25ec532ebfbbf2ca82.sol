1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
5         assert(b <= a);
6         return a - b;
7     }
8 
9     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         assert(c >= a && c >= b);
12         return c;
13     }
14 }
15 
16 
17 contract ERC20 is SafeMath {
18     uint256 public totalSupply;
19     function balanceOf( address who ) constant public returns (uint256 value);
20 
21     function transfer( address to, uint256 value) public returns (bool ok);
22     function transferFrom( address from, address to, uint256 value) public returns (bool ok);
23     function approve( address spender, uint256 value ) public returns (bool ok);
24 
25     event Transfer( address indexed from, address indexed to, uint256 value);
26     event Approval( address indexed owner, address indexed spender, uint256 value);
27 }
28 
29  
30 contract Token is ERC20 {
31     string public constant version  = "1.0";
32     string public constant name     = "X";
33     string public constant symbol   = "X";
34     uint8  public constant decimals = 18;
35 
36 
37     mapping(address => mapping (address => uint256)) allowed;
38     mapping(address => uint256) balances;
39 
40     function Token(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);
46         balances[msg.sender] = totalSupply;
47         tokenName = name; 
48         tokenSymbol = symbol; 
49     }
50     
51     
52     function _transfer(address _from, address _to, uint256 _value) internal {
53         require(_to != 0x0);                               
54         require(balances[_from] >= _value);                
55         require(balances[_to] + _value > balances[_to]); 
56         balances[_from] -= _value;                         
57         balances[_to] += _value;                           
58         emit Transfer(_from, _to, _value);
59     }
60     
61     function balanceOf(address _who) public constant returns (uint256) {
62         return balances[_who];
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         balances[msg.sender] = safeSub(balances[msg.sender], _value);
67         balances[_to] = safeAdd(balances[_to], _value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         uint256 _allowance = allowed[_from][msg.sender];
74         balances[_to] = safeAdd(balances[_to], _value);
75         balances[_from] = safeSub(balances[_from], _value);
76         allowed[_from][msg.sender] = safeSub(_allowance, _value);
77         emit Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) {
82         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
83         allowed[msg.sender][_spender] = _value;
84         emit Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88 }