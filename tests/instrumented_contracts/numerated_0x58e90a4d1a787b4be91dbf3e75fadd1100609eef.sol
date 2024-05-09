1 pragma solidity ^0.4.11;
2 
3 contract VST{
4 
5     string public name = "VST";      //  token name
6     string public symbol = "VST";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;  //balance of each address
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant valueFounder = 300000000000000000000000000; // token amount
16     address owner = 0x0;
17 
18     modifier isOwner {
19         assert(owner == msg.sender);
20         _;
21     }
22 
23     modifier validAddress {
24         assert(0x0 != msg.sender);
25         _;
26     }
27 
28     function VST(address _addressFounder) {
29         owner = msg.sender;
30         totalSupply = valueFounder;
31         balanceOf[_addressFounder] = valueFounder;
32         Transfer(0x0, _addressFounder, valueFounder);
33     }
34 
35     function transfer(address _to, uint256 _value)  validAddress returns (bool success) {
36         require(balanceOf[msg.sender] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38         balanceOf[msg.sender] -= _value;
39         balanceOf[_to] += _value;
40         Transfer(msg.sender, _to, _value);
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value)  validAddress returns (bool success) {
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         require(allowance[_from][msg.sender] >= _value);
48         balanceOf[_to] += _value;
49         balanceOf[_from] -= _value;
50         allowance[_from][msg.sender] -= _value;
51         Transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function approve(address _spender, uint256 _value)  validAddress returns (bool success) {
56         require(_value == 0 || allowance[msg.sender][_spender] == 0);
57         allowance[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }