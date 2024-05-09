1 pragma solidity ^0.5.17;
2 
3 contract EzToken {
4 
5     uint256 public totalSupply;
6 
7     mapping (address => uint256) public balances;
8     mapping (address => mapping (address => uint256)) public allowed;
9 
10     string public name;
11     uint8 public decimals;
12     string public symbol;
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     using SafeMath for uint256;
18 
19     constructor(
20         uint256 _initialAmount,
21         string memory _tokenName,
22         uint8 _decimalUnits,
23         string memory _tokenSymbol
24     ) public {
25         balances[msg.sender] = _initialAmount;
26         totalSupply = _initialAmount;
27         name = _tokenName;
28         decimals = _decimalUnits;
29         symbol = _tokenSymbol;
30     }
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         require(balances[msg.sender] >= _value);
34         balances[msg.sender] -= _value;
35         balances[_to] += _value;
36         emit Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41         uint256 allowance = allowed[_from][msg.sender];
42         require(balances[_from] >= _value && allowance >= _value);
43         balances[_to] += _value;
44         balances[_from] -= _value;
45         allowed[_from][msg.sender] -= _value;
46         emit Transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function balanceOf(address _owner) public view returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
61         return allowed[_owner][_spender];
62     }
63 }
64 
65 library SafeMath {
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }