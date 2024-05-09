1 pragma solidity ^0.4.19;
2 
3 contract Aqo {
4     string public constant name = "Aqo"; // ERC20
5     string public constant symbol = "AQO"; // ERC20
6     uint8 public constant decimals = 18; // ERC20
7     uint256 public totalSupply; // ERC20
8     mapping (address => uint256) public balanceOf; // ERC20
9     mapping (address => mapping (address => uint256)) public allowance; // ERC20 
10 
11     event Transfer(address indexed from, address indexed to, uint256 value); // ERC20
12     event Approval(address indexed owner, address indexed spender, uint256 value); // ERC20
13 
14     function Aqo() public {
15         uint256 initialSupply = 1000000000000000000000;
16         totalSupply = initialSupply;
17         balanceOf[msg.sender] = initialSupply;
18     }
19 
20     // ERC20
21     function transfer(address _to, uint256 _value) public returns (bool) {
22         require(balanceOf[msg.sender] >= _value);
23         if (_to == address(this)) {
24             if (_value > address(this).balance) {
25                 _value = address(this).balance;
26             }
27             balanceOf[msg.sender] -= _value;
28             totalSupply -= _value;
29             msg.sender.transfer(_value);
30         } else {
31             balanceOf[msg.sender] -= _value;
32             balanceOf[_to] += _value;
33         }
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     // ERC20
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
40         require(allowance[_from][msg.sender] >= _value);
41         require(balanceOf[_from] >= _value);
42         if (_to == address(this)) {
43             if (_value > address(this).balance) {
44                 _value = address(this).balance;
45             }
46             allowance[_from][msg.sender] -= _value;
47             balanceOf[_from] -= _value;
48             totalSupply -= _value;
49             msg.sender.transfer(_value);
50         } else {
51             allowance[_from][msg.sender] -= _value;
52             balanceOf[_from] -= _value;
53             balanceOf[_to] += _value;
54         }
55         emit Transfer(_from, _to, _value);
56         return true;
57     }
58 
59     // ERC20
60     function approve(address _spender, uint256 _value) public returns (bool) {
61         allowance[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function () public payable {
67         require (msg.data.length == 0);
68         balanceOf[msg.sender] += msg.value;
69         totalSupply += msg.value;
70         emit Transfer(address(this), msg.sender, msg.value);
71     }
72 }