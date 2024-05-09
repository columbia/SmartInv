1 pragma solidity ^0.4.18;
2 
3 contract ERC20Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract BeBitcoin is ERC20Token {
15 
16     uint256 constant private MAX_UINT256 = 2**256 - 1;
17     mapping (address => uint256) public balances;
18     mapping (address => mapping (address => uint256)) public allowed;
19 
20     string public name;
21     uint8 public decimals;             
22     string public symbol;              
23 
24     function BeBitcoin (
25         uint256 _initialAmount,
26         string _tokenName,
27         uint8 _decimalUnits,
28         string _tokenSymbol
29     ) public {
30         balances[msg.sender] = _initialAmount;              
31         totalSupply = _initialAmount;                       
32         name = _tokenName;                                 
33         decimals = _decimalUnits;  
34         symbol = _tokenSymbol;  
35     }
36 
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         uint256 allowance = allowed[_from][msg.sender];
47         require(balances[_from] >= _value && allowance >= _value);
48         balances[_to] += _value;
49         balances[_from] -= _value;
50         if (allowance < MAX_UINT256) {
51             allowed[_from][msg.sender] -= _value;
52         }
53         Transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function balanceOf(address _owner) public view returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
68         return allowed[_owner][_spender];
69     }   
70 }