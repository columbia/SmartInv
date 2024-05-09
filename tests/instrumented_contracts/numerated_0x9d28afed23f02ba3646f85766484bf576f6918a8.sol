1 pragma solidity ^0.4.21;
2 
3 contract Ownable { 
4     address public owner;
5     function Ownable() public { owner = address(this); }
6 }
7 
8 contract GRAND is Ownable {
9     
10     string public version           = "3.0.3";
11     string public name              = "GRAND";
12     string public symbol            = "G";
13 
14     uint256 public totalSupply      = 100000000000000000000000 * 1000;
15     uint8 public decimals           = 15;
16     
17     mapping (address => uint256) public balanceOf;
18        
19     event Transfer(address indexed from, address indexed to, uint256 value);
20    
21     function GRAND () public {
22         balanceOf[msg.sender]   = totalSupply;
23         _transfer (msg.sender, address(this), totalSupply);
24     }
25    
26     function _transfer(address _from, address _to, uint _value) internal {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         emit Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         if (_to == address(this)) { require(msg.sender.send(_value)); }
39         _transfer(msg.sender, _to, _value);
40     }
41      
42     function () payable public {
43         uint256 amount               = msg.value;
44         balanceOf[owner]             = balanceOf[owner] - amount;
45         balanceOf[msg.sender]        = balanceOf[msg.sender]  + amount;
46         emit Transfer(owner, msg.sender, msg.value);
47     }
48 }