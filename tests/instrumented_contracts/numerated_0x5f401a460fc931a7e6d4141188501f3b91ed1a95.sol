1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     
5     address public owner;
6     function Ownable() public { owner = address(this); }
7 }
8 
9 contract GRAND is Ownable {
10     
11     string public version           = "3.0.3";
12     string public name              = "GRAND";
13     string public symbol            = "G";
14 
15     uint256 public totalSupply      = 100000000000000000000000 * 1000;
16     uint8 public decimals           = 15;
17     
18     mapping (address => uint256) public balanceOf;
19        
20     event Transfer(address indexed from, address indexed to, uint256 value);
21    
22     function GRAND () public {
23         balanceOf[msg.sender] = totalSupply;
24         _transfer (msg.sender, address(this), totalSupply);
25     }
26    
27     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
28         require(_to != 0x0);
29         require(balanceOf[_from] >= _value);
30         require(balanceOf[_to] + _value > balanceOf[_to]);
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         emit Transfer(_from, _to, _value);
35         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36         return true;
37     }
38 
39     function transfer(address _to, uint256 _value) public {
40         
41         if (_transfer(msg.sender, _to, _value)) { if (_to == address(this)) { require(msg.sender.send(_value)); } }    
42     }
43      
44     function () payable public {
45         uint256 amount               = msg.value;
46         balanceOf[owner]             = balanceOf[owner] - amount;
47         balanceOf[msg.sender]        = balanceOf[msg.sender]  + amount;
48         emit Transfer(owner, msg.sender, msg.value);
49     }
50 }