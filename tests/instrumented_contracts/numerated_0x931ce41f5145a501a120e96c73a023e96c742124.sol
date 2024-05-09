1 pragma solidity ^0.4.11;
2 
3 contract Ulti {
4 
5     string public name = "Ulti";      //  token name
6     string public symbol = "Ulti";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 225000000 * (10**decimals);
13     address public owner;
14 
15     modifier isOwner {
16         assert(owner == msg.sender);
17         _;
18     }
19     function Ulti() {
20         owner = msg.sender;
21         balanceOf[owner] = totalSupply;
22     }
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         require(balanceOf[msg.sender] >= _value);
26         require(balanceOf[_to] + _value >= balanceOf[_to]);
27         balanceOf[msg.sender] -= _value;
28         balanceOf[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value >= balanceOf[_to]);
36         require(allowance[_from][msg.sender] >= _value);
37         balanceOf[_to] += _value;
38         balanceOf[_from] -= _value;
39         allowance[_from][msg.sender] -= _value;
40         Transfer(_from, _to, _value);
41         return true;
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success)
45     {
46         require(_value == 0 || allowance[msg.sender][_spender] == 0);
47         allowance[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51     
52     function setName(string _name) isOwner 
53     {
54         name = _name;
55     }
56     function burnSupply(uint256 _amount) isOwner
57     {
58         balanceOf[owner] -= _amount;
59         SupplyBurn(_amount);
60     }
61     function burnTotalSupply(uint256 _amount) isOwner
62     {
63         totalSupply-= _amount;
64     }
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event SupplyBurn(uint256 _amount);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }