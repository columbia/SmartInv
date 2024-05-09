1 pragma solidity ^0.4.16;
2 
3 contract ERC20token{
4     uint256 public totalSupply;
5     string public name;
6     uint8 public decimals;
7     string public symbol;
8     address public admin;
9     
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     
13     mapping (address => bool) public frozenAccount; //无限期冻结的账户
14     mapping (address => uint256) balances;
15     mapping (address => mapping (address => uint256)) allowed;
16     
17     function ERC20token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
18         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
19         balances[msg.sender] = totalSupply;
20         admin = msg.sender;
21         name = _tokenName;
22         decimals = _decimalUnits;
23         symbol = _tokenSymbol;
24     }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         require(!frozenAccount[msg.sender]);
28         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
29         require(_to != 0x0);
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         Transfer(msg.sender, _to, _value);
33         return true;
34     }
35     
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         require(!frozenAccount[msg.sender]);
38         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
39         balances[_to] += _value;
40         balances[_from] -= _value;
41         allowed[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44     }
45     
46     function balanceOf(address _owner) public constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49     
50      function freeze(address _target,bool _freeze) public returns (bool) {
51         require(msg.sender == admin);
52         // require(_target != address(0));
53         // require(_target != admin);
54         frozenAccount[_target] = _freeze;
55         return true;
56     }
57     
58     // function cgadmin(address _newadmin) public returns (bool){
59     //      require(msg.sender == admin);
60     // }
61     
62     function approve(address _spender, uint256 _value) public returns (bool success)
63     {
64         allowed[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68     
69     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
70         return allowed[_owner][_spender];
71     }
72 }