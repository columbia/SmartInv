1 pragma solidity ^0.4.11;
2 
3 contract Token808 {
4 
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping(address => uint256)) public allowance;
12 
13     event Transfer(address from, address to, uint256 value);
14     event Approval(address from, address to, uint256 value);
15 
16     function Token808(){
17         decimals = 6;
18         totalSupply = 8080808080808 * (10 ** uint256(decimals));
19         balanceOf[msg.sender] = totalSupply;
20         name = "808token";
21         symbol = "808T";
22     }
23 
24     function _transfer(address _from, address _to, uint256 _value) internal {
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value >= balanceOf[_to]);
28         balanceOf[_to] += _value;
29         balanceOf[_from] -= _value;
30         Transfer(_from, _to, _value);
31     }
32 
33     function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public {
38         require(_value <= allowance[_from][_to]);
39         allowance[_from][_to] -= _value;
40         _transfer(_from, _to, _value);
41     }
42 
43     function approve(address _to, uint256 _value) public {
44         allowance[msg.sender][_to] = _value;
45         Approval(msg.sender, _to, _value);
46     }
47 }