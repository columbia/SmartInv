1 pragma solidity ^0.4.11;
2 
3 contract TestToken5 {
4 
5     string public name = "TestToken5";      //  token name
6     string public symbol = "TT5";           //  token symbol
7     uint public decimals = 6;               //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 constant valueICO       = 40000000000000000;
13     uint256 constant valueFounder   = 35000000000000000;
14     uint256 constant valueVIP       = 15000000000000000;
15     uint256 constant valuePeiwo     = 10000000000000000;
16 
17     uint public totalSupply = valueICO + valueFounder + valueVIP + valuePeiwo;
18 
19     function TestToken5(address _addressICO, address _addressFounder, address _addressVIP, address _addressPeiwo) {
20         balanceOf[_addressICO] = valueICO;
21         balanceOf[_addressFounder] = valueFounder;
22         balanceOf[_addressVIP] = valueVIP;
23         balanceOf[_addressPeiwo] = valuePeiwo;
24         Transfer(0x0, _addressICO, valueICO);
25         Transfer(0x0, _addressFounder, valueFounder);
26         Transfer(0x0, _addressVIP, valueVIP);
27         Transfer(0x0, _addressPeiwo, valuePeiwo);
28     }
29 
30     function transfer(address _to, uint256 _value) returns (bool success) {
31         require(balanceOf[msg.sender] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         balanceOf[msg.sender] -= _value;
34         balanceOf[_to] += _value;
35         Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40         require(balanceOf[_from] >= _value);
41         require(balanceOf[_to] + _value >= balanceOf[_to]);
42         require(allowance[_from][msg.sender] >= _value);
43         balanceOf[_to] += _value;
44         balanceOf[_from] -= _value;
45         allowance[_from][msg.sender] -= _value;
46         Transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) returns (bool success) {
51         require(_value == 0 || allowance[msg.sender][_spender] == 0);
52         allowance[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }