1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5 
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12 
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14 
15 
16     function approve(address _spender, uint256 _value) public returns (bool success);
17 
18 
19     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 }
24 
25 
26 
27 
28 contract SourceDataVerification is EIP20Interface {
29 
30     uint256 constant private MAX_UINT256 = 2**256 - 1;
31     mapping (address => uint256) public balances;
32     mapping (address => mapping (address => uint256)) public allowed;
33     string public name;                  
34     uint8 public decimals;                
35     string public symbol;               
36 
37     function SourceDataVerification(
38         uint256 _initialAmount,
39         string _tokenName,
40         uint8 _decimalUnits,
41         string _tokenSymbol
42     ) public {
43         balances[msg.sender] = _initialAmount;              
44         totalSupply = _initialAmount;                       
45         name = _tokenName;                                  
46         decimals = _decimalUnits;                           
47         symbol = _tokenSymbol;                              
48     }
49 
50     function transfer(address _to, uint256 _value) public returns (bool success) {
51         require(balances[msg.sender] >= _value);
52         balances[msg.sender] -= _value;
53         balances[_to] += _value;
54         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         uint256 allowance = allowed[_from][msg.sender];
60         require(balances[_from] >= _value && allowance >= _value);
61         balances[_to] += _value;
62         balances[_from] -= _value;
63         if (allowance < MAX_UINT256) {
64             allowed[_from][msg.sender] -= _value;
65         }
66         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
67         return true;
68     }
69 
70     function balanceOf(address _owner) public view returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) public returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 }