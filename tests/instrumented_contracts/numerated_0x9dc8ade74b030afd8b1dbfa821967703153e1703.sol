1 pragma solidity ^0.4.23;
2 
3 contract SystemTesterCode {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     function approve(address _spender, uint256 _value) public returns (bool success);
14 
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract TwiceAWeekCoin is SystemTesterCode {
23 
24     uint256 constant private MAX_UINT256 = 2**256 - 1;
25     mapping (address => uint256) public balances;
26     mapping (address => mapping (address => uint256)) public allowed;
27     
28     string public name;                   
29     uint8 public decimals;              
30     string public symbol;                 
31 
32     function TwiceAWeekCoin(
33         uint256 _initialAmount,
34         string _tokenName,
35         uint8 _decimalUnits,
36         string _tokenSymbol
37     ) public {
38         balances[msg.sender] = _initialAmount;
39         totalSupply = _initialAmount;
40         name = _tokenName;
41         decimals = _decimalUnits;
42         symbol = _tokenSymbol;
43     }
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46         require(balances[msg.sender] >= _value);
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         emit Transfer(msg.sender, _to, _value); 
50         return true;
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54         uint256 allowance = allowed[_from][msg.sender];
55         require(balances[_from] >= _value && allowance >= _value);
56         balances[_to] += _value;
57         balances[_from] -= _value;
58         if (allowance < MAX_UINT256) {
59             allowed[_from][msg.sender] -= _value;
60         }
61         emit Transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 }