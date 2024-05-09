1 pragma solidity ^0.4.23;
2 
3 //Made based after being inspired from our meetup group: https://www.meetup.com/Blockchain-Vine-Meetup/
4 //Code by PGSystemTester
5 //Took a video of the launch of this code at the Houston Airport (IAH) on May 17, 2018
6 
7 
8 contract SystemTesterCode {
9 
10     uint256 public totalSupply;
11 
12     function balanceOf(address _owner) public view returns (uint256 balance);
13 
14     function transfer(address _to, uint256 _value) public returns (bool success);
15 
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     function approve(address _spender, uint256 _value) public returns (bool success);
19 
20     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 contract NapaCoin is SystemTesterCode {
28 
29     uint256 constant private MAX_UINT256 = 2**256 - 1;
30     mapping (address => uint256) public balances;
31     mapping (address => mapping (address => uint256)) public allowed;
32     
33     string public name;                   
34     uint8 public decimals;              
35     string public symbol;                 
36 
37     constructor(
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
54         emit Transfer(msg.sender, _to, _value); 
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
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function balanceOf(address _owner) public view returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) public returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 }