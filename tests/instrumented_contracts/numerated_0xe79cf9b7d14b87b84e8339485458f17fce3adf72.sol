1 pragma solidity ^0.4.18;
2 contract EIP20Interface {    
3     uint256 public totalSupply;
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract KLSToken is EIP20Interface {
13 
14     uint256 constant private MAX_UINT256 = 2**256 - 1;
15     mapping (address => uint256) public balances;
16     mapping (address => mapping (address => uint256)) public allowed;
17    
18     string public name;                   
19     uint8 public decimals;                
20     string public symbol;                 
21 
22     function KLSToken(
23         uint256 _initialAmount,
24         string _tokenName,
25         uint8 _decimalUnits,
26         string _tokenSymbol
27     ) public {
28         balances[msg.sender] = _initialAmount;               
29         totalSupply = _initialAmount;                        
30         name = _tokenName;                                   
31         decimals = _decimalUnits;                            
32         symbol = _tokenSymbol;                              
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[msg.sender] >= _value);
37         balances[msg.sender] -= _value;
38         balances[_to] += _value;
39         Transfer(msg.sender, _to, _value);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         uint256 allowance = allowed[_from][msg.sender];
45         require(balances[_from] >= _value && allowance >= _value);
46         balances[_to] += _value;
47         balances[_from] -= _value;
48         if (allowance < MAX_UINT256) {
49             allowed[_from][msg.sender] -= _value;
50         }
51         Transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function balanceOf(address _owner) public view returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function approve(address _spender, uint256 _value) public returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
66         return allowed[_owner][_spender];
67     }   
68 }