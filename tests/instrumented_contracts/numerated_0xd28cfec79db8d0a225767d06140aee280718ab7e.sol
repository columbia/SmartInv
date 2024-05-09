1 pragma solidity 0.4.24;
2 
3 contract TokenInterface {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is TokenInterface {
15     function transfer(address _to, uint256 _value) public returns (bool success) {
16         require(balances[msg.sender] >= _value && _value > 0);
17         require(balances[_to] + _value > balances[_to] );
18 
19         balances[msg.sender] -= _value;
20         balances[_to] += _value;
21         emit Transfer(msg.sender, _to, _value);
22         return true;
23     }
24 
25     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
26         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
27         require(balances[_to] + _value > balances[_to]);
28 
29         balances[_to] += _value;
30         balances[_from] -= _value;
31         allowed[_from][msg.sender] -= _value;
32         emit Transfer(_from, _to, _value);
33         return true;
34 
35     }
36 
37     function balanceOf(address _owner) public constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         require( _value == 0 || allowed[msg.sender][_spender] == 0 );
43         allowed[msg.sender][_spender] = _value;
44         emit Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
49         return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54 }
55 
56 contract BizKeyToken is StandardToken {
57 
58     address public issuer ;
59     string public name = "BizKey Token";
60     string public symbol = "BZKY";
61     uint256 public decimals = 0;
62 
63     constructor(string _name,string _symbol,uint256 _decimals,uint256 _total) public {
64         name = _name;
65         symbol = _symbol;
66         decimals = _decimals;
67         totalSupply = _total;
68         balances[msg.sender] = totalSupply;
69         issuer = msg.sender;
70     }
71 
72     function () public payable {
73         revert();
74     }
75 }